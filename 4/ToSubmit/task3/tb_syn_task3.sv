`timescale 1 ps / 1 ps
module tb_syn_task3();
// Your testbench goes here. Our toplevel will give up after 1,000,000 ticks.
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

    de1_gui gui(.SW, .KEY, .LEDR, .HEX5, .HEX4, .HEX3, .HEX2, .HEX1, .HEX0);
   
    task3 dut(.CLOCK_50(CLK),
		.KEY(KEY));

	task clk;
		begin
			#1;
			CLK = 1;
			#1;
			CLK = 0;
			#1;
		end
	endtask

integer count = 0;

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
for(count = 0; count < 500; count = count + 1) begin
	clk;
end
$stop;



end

endmodule: tb_syn_task3
