`timescale 1 ps / 1 ps
module tb_datapath();
// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").
    integer failed = 0;

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

    datapath dut (.slow_clock(slow_clock), .fast_clock(fast_clock), .resetb(resetb),
                .load_pcard1(load_pcard1), .load_pcard2(load_pcard2), .load_pcard3(load_pcard3),
                .load_dcard1(load_dcard1), .load_dcard2(load_dcard2), .load_dcard3(load_dcard3),
                .pcard3_out (pcard3), .pscore_out(pscore), .dscore_out(dscore),
                .HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX2(HEX2), .HEX1(HEX1), .HEX0(HEX0));

    task s_clk;
		begin
        #5;
		slow_clock = 1'b1;
		#5;
		slow_clock = 1'b0;
		#5;
		end
	endtask

	initial begin
        resetb = 1'b0;
		#5;
		resetb = 1'b1;

        //forcing new_card to be 0 and test it HEX display
        force dut.new_card = 4'd0;
        {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3} = 6'b100000;
        s_clk; 
        if(HEX0 != 7'b1111111 || HEX1 != 7'b1111111 || HEX2 != 7'b1111111 || HEX3 != 7'b1111111 || HEX4 != 7'b1111111 || HEX5 != 7'b1111111) begin
            $display("Error: HEX0 = %b, HEX1 = %b, HEX2 = %b, HEX3 = %b, HEX4, = %b, HEX5 = %b", HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
            failed++;
        end
        else begin
            $display("HEX display is correct");
        end

        //forcing new_card to be A and test it HEX display
        force dut.new_card = 4'd1;
        {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3} = 6'b100000;
        s_clk; 
        if(HEX0 != 7'b0001000 || HEX1 != 7'b1111111 || HEX2 != 7'b1111111 || HEX3 != 7'b1111111 || HEX4 != 7'b1111111 || HEX5 != 7'b1111111) begin
            $display("Error: HEX0 = %b, HEX1 = %b, HEX2 = %b, HEX3 = %b, HEX4, = %b, HEX5 = %b", HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
            failed++;
        end
        else begin
            $display("HEX display is correct");
        end

        //forcing new_card to be 9 and test it HEX display
        force dut.new_card = 4'd9;
        {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3} = 6'b100000;
        s_clk; 
        if(HEX0 != 7'b0010000 || HEX1 != 7'b1111111 || HEX2 != 7'b1111111 || HEX3 != 7'b1111111 || HEX4 != 7'b1111111 || HEX5 != 7'b1111111) begin
            $display("Error: HEX0 = %b, HEX1 = %b, HEX2 = %b, HEX3 = %b, HEX4, = %b, HEX5 = %b", HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
            failed++;
        end
        else begin
            $display("HEX display is correct");
        end







        $display("Total number of tests failed is: %d", failed);
        $stop;
    end
endmodule

