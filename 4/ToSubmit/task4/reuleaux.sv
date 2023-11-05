module reuleaux(input logic clk, input logic rst_n, input logic [2:0] colour,
                input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] diameter,
                input logic start, output logic done,
                output logic [7:0] vga_x, output logic [6:0] vga_y,
                output logic [2:0] vga_colour, output logic vga_plot);
     // draw the Reuleaux triangle

integer state;
integer offset_x;
integer offset_y;
integer x;
integer y;
integer crit;
integer green = 2; //decimal 2 = binary 3'b010 = rgb green
integer black = 0; //decimal 0 = binary 3'b000 = rgb black

//test variable

integer hor_offset;
assign hor_offset = diameter/2;
integer ver_offset;
assign ver_offset = hor_offset*57735/100000; //0.57735 = 57735/100000
integer radius;
assign radius = 2*hor_offset;

integer top_circle_centre_x; 
assign top_circle_centre_x = centre_x;
integer top_circle_centre_y;
assign top_circle_centre_y = centre_y - ver_offset*2;
integer left_circle_centre_x;
assign left_circle_centre_x = centre_x - hor_offset;
integer left_circle_centre_y;
assign left_circle_centre_y = centre_y + ver_offset;
integer right_circle_centre_x;
assign right_circle_centre_x = centre_x + hor_offset;
integer right_circle_centre_y;
assign right_circle_centre_y = centre_y + ver_offset;


/*  based on states 2-9 from circle, determine corresponding expressions to octants
		2: vga_x = centre_x + offset_x;
		3: vga_x = centre_x + offset_y;
		4: vga_x = centre_x - offset_x;
		5: vga_x = centre_x - offset_y;
		6: vga_x = centre_x - offset_x;
		7: vga_x = centre_x - offset_y;
		8: vga_x = centre_x + offset_x;
		9: vga_x = centre_x + offset_y;

		2: vga_y = centre_y + offset_y;
		3: vga_y = centre_y + offset_x;
		4: vga_y = centre_y + offset_y;
		5: vga_y = centre_y + offset_x;
		6: vga_y = centre_y - offset_y;
		7: vga_y = centre_y - offset_x;
		8: vga_y = centre_y - offset_y;
		9: vga_y = centre_y - offset_x;
       7  9
    6        8
   
    4        2
       5  3

	top circle: render octants 5 and 3 
	left circle: render octants 9 and 8
	right circle: render octants 6 and 7
*/
always_comb begin
	case(state)
		1: vga_x = x;
        2: vga_x = top_circle_centre_x - offset_y;        //5
		3: vga_x = top_circle_centre_x + offset_y;        //3
		4: vga_x = left_circle_centre_x + offset_y;       //9
		5: vga_x = left_circle_centre_x + offset_x;       //8
		6: vga_x = right_circle_centre_x - offset_x;      //6
		7: vga_x = right_circle_centre_x - offset_y;      //7
		default: vga_x = 0;
	endcase
	case(state)
		1: vga_y = y;
		2: vga_y = top_circle_centre_y + offset_x;
		3: vga_y = top_circle_centre_y + offset_x;
		4: vga_y = left_circle_centre_y - offset_x;
		5: vga_y = left_circle_centre_y - offset_y;
		6: vga_y = right_circle_centre_y - offset_y;
		7: vga_y = right_circle_centre_y - offset_x;
		default: vga_y = 0;
	endcase
	case(state)
		1: vga_colour = black;
		default: vga_colour = green;
	endcase
	case(state)
		9: done = 1;
		default: done = 0;
	endcase
	if (state == 1) begin
		vga_plot = 1;
	end				//no overlapping pixels
	else if(((state == 2) || (state == 3)) && (vga_x > left_circle_centre_x) && (vga_x < right_circle_centre_x)) begin
		vga_plot = 1;
	end
	else if(((state == 4) || (state == 5)) && (vga_x >= centre_x) && (vga_x <= right_circle_centre_x)) begin
		vga_plot = 1;
	end
	else if(((state == 6) || (state == 7)) && (vga_x >= left_circle_centre_x) && (vga_x < centre_x)) begin
		vga_plot = 1;
	end
	else vga_plot = 0;
end

always_ff @(posedge(clk), negedge(rst_n)) begin
	if(!rst_n) begin
		state <= 0;
		offset_y <= 0;
		offset_x <= radius;
		x <= 0;
		y <= 0;
		crit <= 1 - radius;
	end
	else if((state == 0) && start) begin
		state <= 1;
	end
	else if(state == 1) begin
		if(x <= 159) begin
			if(y < 119) begin
				y <= y + 1;
			end
			else begin
				y <= 0;
				x <= x + 1;
			end
		end
		else begin
			state <= state + 1;
		end
	end
	else if(state == 2) begin
                if(offset_y <= offset_x) begin
			state <= state + 1;
		end
		else begin
			state <= 9;
		end
	end
	else if((state >= 3) && (state <= 6)) begin
		state <= state + 1;
	end
	else if(state == 7) begin
		state <= 2;
		offset_y <= offset_y + 1;
		if(crit <= 0) begin
			crit <= crit + 2*(offset_y + 1) + 1;
		end
		else begin
			offset_x <= offset_x - 1;
			crit <= crit + 2*((offset_y + 1) - offset_x) + 1;   //add 1 to offset y for crit calculation in same cycle
		end
	end
end
endmodule