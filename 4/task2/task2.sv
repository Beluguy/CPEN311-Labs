module task2(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

    // instantiate and connect the VGA adapter and your module
logic [9:0] VGA_R_10;
logic [9:0] VGA_G_10;
logic [9:0] VGA_B_10;

assign VGA_R = VGA_R_10[9:2];
assign VGA_G = VGA_G_10[9:2];
assign VGA_B = VGA_B_10[9:2];

/*module fillscreen(input logic clk, input logic rst_n, input logic [2:0] colour,
                  input logic start, output logic done,
                  output logic [7:0] vga_x, output logic [6:0] vga_y,
                  output logic [2:0] vga_colour, output logic vga_plot);*/

wire [2:0] colour;
wire [7:0] x;
wire [6:0] y;
wire plot;
wire done;

logic VGA_BLANK, VGA_SYNC;

fillscreen fill(.clk(CLOCK_50),
		.rst_n(KEY[3]),
		.colour(colour),
		.start(~KEY[0]),
		.done(done),
		.vga_x(x),
		.vga_y(y),
		.vga_colour(colour),
		.vga_plot(plot));



vga_adapter#(.RESOLUTION("160x120")) vga_u0(.resetn(KEY[3]), .clock(CLOCK_50), .colour(colour),
                                            .x(x), .y(y), .plot(plot),
                                            .VGA_R(VGA_R_10), .VGA_G(VGA_G_10), .VGA_B(VGA_B_10),
                                            .*);

endmodule: task2
