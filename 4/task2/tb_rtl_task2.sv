`timescale 1 ps / 1 ps
module tb_rtl_task2();
/*
module task2(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);*/
logic CLK;
logic [3:0] KEY;
logic [9:0] SW;
logic [9:0] LEDR;
logic [6:0] HEX0;
logic [6:0] HEX1;
logic [6:0] HEX2;
logic [6:0] HEX3;
logic [6:0] HEX4;
logic [6:0] HEX5;

integer count = 0;


de1_gui gui(.SW, .KEY, .LEDR, .HEX5, .HEX4, .HEX3, .HEX2, .HEX1, .HEX0);

task2 dut(.CLOCK_50(CLK),
.KEY(KEY));

task clock;
    begin
        clk = 1'b1;
        forever #1 clk = ~clk;
    end
endtask


initial begin
  KEY = 4'b1111;
  clk;
  KEY[3] = 1'b0;
  #1;
  KEY[3] = 1'b1;
  clk;
  KEY[0] = 1'b0;
  clk;
  KEY[0] = 1'b1;
  for(count = 0; count < 19210; count = count + 1) begin
    clk;
  end
  $stop;



end
endmodule: tb_rtl_task2
