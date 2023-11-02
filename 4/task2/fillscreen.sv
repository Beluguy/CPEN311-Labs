module fillscreen(input logic clk, input logic rst_n, input logic [2:0] colour,
                  input logic start, output logic done,
                  output logic [7:0] vga_x, output logic [6:0] vga_y,
                  output logic [2:0] vga_colour, output logic vga_plot);
/*wire x;
wire y;
wire v_colour;
assign x = vga_x;
assign y = vga_y;
assign v_colour = vga_colour;*/
/*
always_ff @(posedge clk, negedge rst_n) begin
     if(!rst_n) begin
          done <= 1'b0;
          vga_x <= 1'd0;
          vga_plot <= 1'b1;
     end else if (start && vga_x < 160) begin
          vga_y <= 1'd0;
          vga_x <= vga_x + 1'd1;
     end else if (start && vga_y < 120) begin
               vga_colour <= vga_x % 8'd4;
               vga_y <= vga_y + 1'd1;
     end else begin
          done <= 1'b1;
          vga_plot <= 1'b1;
     end 
end*/
integer state;
integer x;
integer y;
integer color;
assign color = x % 8;
reg plot;

always_comb begin
	case(state)
		1: vga_x = x;
		default: vga_x = 0;
	endcase
	case(state)
		1: vga_y = y;
		default: vga_y = 0;
	endcase
	case(state)
		1: vga_colour = color;
		default: vga_colour = 0;
	endcase
	case(state)
		1: vga_plot = 1;
		default: vga_plot = 0;
	endcase
	case(state)
		2: done = 1;
		default: done = 0;
	endcase
end


always_ff @(posedge(clk), negedge(rst_n)) begin
		if(!rst_n) begin
			state <= 0;
			x <= 0;
			y <= 0;
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
	end

endmodule