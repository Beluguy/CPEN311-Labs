`timescale 1 ps / 1 ps
module tb_rtl_init();


    integer failed = 0;
    integer i;

    reg clk;
    reg rst_n;
    reg en;
    reg rdy;
    reg wren;
    reg [7:0] addr;
	wire [7:0] wrdata;

    init dut (.clk(clk), .rstn(rst_n), .en(en), .rdy(rdy), .addr(addr), .wrdata(wrdata), .wren(wren));

    task clock;
		begin
        #2;
		clk = 1'b1;
		#2;
		clk = 1'b0;
		#2;
		end
	endtask

	initial begin
        rst_n = 1'b0;
		#2;
		rst_n = 1'b1;

        $display("Now ram output with wren enable");
        force dut.wren = 1'd1;
        for (i = 1; i < 255; i = i + 1) begin
            clock; 
            if(dut.q != i) begin
                $error("q = %b,", dut.q);
                failed++;
            end
            else begin
                $display("Correct: ram output = %b", dut.q);
            end
        end 
    end 
endmodule: tb_rtl_init
