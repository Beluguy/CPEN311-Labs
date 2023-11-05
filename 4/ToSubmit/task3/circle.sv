module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] radius,
              input logic start, output logic done,
              output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot);
     // draw the circle

integer state;
integer offset_x;
integer offset_y;
integer x;
integer y;
integer crit;
integer green = 2; //decimal 2 = binary 3'b010 = rgb green
integer black = 0; //decimal 0 = binary 3'b000 = rgb black

always_comb begin
	case(state)
		1: vga_x = x;
		2: vga_x = centre_x + offset_x;
		3: vga_x = centre_x + offset_y;
		4: vga_x = centre_x - offset_x;
		5: vga_x = centre_x - offset_y;
		6: vga_x = centre_x - offset_x;
		7: vga_x = centre_x - offset_y;
		8: vga_x = centre_x + offset_x;
		9: vga_x = centre_x + offset_y;
		default: vga_x = 0;
	endcase
	case(state)
		1: vga_y = y;
		2: vga_y = centre_y + offset_y;
		3: vga_y = centre_y + offset_x;
		4: vga_y = centre_y + offset_y;
		5: vga_y = centre_y + offset_x;
		6: vga_y = centre_y - offset_y;
		7: vga_y = centre_y - offset_x;
		8: vga_y = centre_y - offset_y;
		9: vga_y = centre_y - offset_x;
		default: vga_y = 0;
	endcase
	case(state)
		0: vga_plot = 0;
		1: vga_colour = black;
		10: vga_plot = 0;
		11: vga_plot = 0;
		default: vga_colour = green;
	endcase
	case(state)
		0: vga_plot = 0;
		10: vga_plot = 0;
		11: vga_plot = 0;
		default: vga_plot = 1;
	endcase
	case(state)
		11: done = 1;
		default: done = 0;
	endcase
end

always_ff @(posedge(clk), negedge(rst_n)) begin
	if(!rst_n) begin
		state <= 0;
		offset_y <= 0;
		offset_x <= radius;
		x <= 0;
		y <= 0;
		crit <= 1- radius;
	end
	else if((state == 0) && start) begin
		state <= state + 1;
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
			state <= 11;
		end
	end
	else if((state >= 3) && (state <= 8)) begin
		state <= state + 1;
	end
	else if(state == 9) begin
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
	else if(state == 10) begin
		if(crit <= 0) begin
			crit <= crit + 2*offset_y + 1;
		end
		else begin
			offset_x <= offset_x - 1;
			crit <= crit + 2*(offset_y - offset_x) + 1;
		end
		state <= 2;
	end
end
endmodule