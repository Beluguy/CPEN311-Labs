`timescale 1 ps / 1 ps
module tb_datapath();
// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").
    integer failed = 0;
    integer passed = 0;

    reg slow_clock;
    reg fast_clock;
	reg resetb; 

    reg load_pcard1;
	reg load_pcard2;
	reg load_pcard3;
	reg load_dcard1;
	reg load_dcard2;
	reg load_dcard3;

	wire [3:0] pscore;
	wire [3:0] dscore;
	wire [3:0] pcard3;

    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;
    wire [6:0] HEX4;
    wire [6:0] HEX5;

    datapath dut (.slow_clock(slow_clock), .fast_clock(fast_clock), input resetb,
                .load_pcard1(load_pcard1), .load_pcard2(load_pcard2), .load_pcard3(load_pcard3),
                .load_dcard1(load_dcard1), .load_dcard2(load_dcard2), .load_dcard3(load_dcard3),
                .pcard3_out (pcard3), .pscore_out(pscore), .dscore_out(dscore),
                .HEX5(), .HEX4(), .HEX3(), .HEX2(), .HEX1(), .HEX0());

    task s_clk;
		begin
		#2;
		slow_clock = 1'b1;
		#2;
		slow_clock = 1'b0;
		#2;
		end
	endtask

    task f_clk;
		begin
		#1;
		fast_clock = 1'b1;
		#1;
		fast_clock = 1'b0;
		#1;
		end
	endtask

	initial begin



    end
    $display("Total number of tests failed is: %d", failed);
    $display("Total number of tests passed is: %d", passed);
    $stop;	
endmodule

