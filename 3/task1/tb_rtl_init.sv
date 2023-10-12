`timescale 1 ps / 1 ps
module tb_rtl_init();
    integer failed = 0;
    integer i = 0;

    reg clk, rst_n, en, rdy, wren;
    reg [7:0] addr;
	wire [7:0] wrdata;

    init dut (.clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy), .addr(addr), .wrdata(wrdata), .wren(wren));
    
    task clock;
		begin
		clk = 1'b1;
		#2;
		clk = 1'b0;
		#2;
		end
	endtask

	initial begin
        rst_n = 1'd0;
		#2;
		rst_n = 1'd1;

        $display("Now testing wrdata output");
        for (i = 0; i < 256; i = i + 1) begin
            if (dut.rdy == 1'd1) en = 1'd1;
            else en = 1'd0;
            clock;
            if(dut.wrdata != i) begin
                $error("wrdata = %b, it should be %b", wrdata, i);
                failed++;
            end
            else begin
                $display("Correct: wrdata output = %b, %b", wrdata, i);
            end
        end 
        $display("Total number of tests failed is: %d", failed);
        $stop;
    end 
endmodule: tb_rtl_init