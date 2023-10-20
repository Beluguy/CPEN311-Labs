`timescale 1 ps / 1 ps
module tb_rtl_arc4();

integer failed = 0;
integer i = 0;

reg clk;
reg rst_n;
reg en;
wire rdy;
reg [23:0] key;
wire [7:0] ct_addr;
reg [7:0] ct_rddata;
wire [7:0] pt_addr;
reg [7:0] pt_rddata;
wire [7:0] pt_wrdata;
wire pt_wren;

arc4 dut(.clk(clk),
	.rst_n(rst_n),
	.en(en),
	.rdy(rdy),
	.key(key),
	.ct_addr(ct_addr),
	.ct_rddata(ct_rddata),
	.pt_addr(pt_addr),
	.pt_rddata(pt_rddata),
	.pt_wrdata(pt_wrdata),
	.pt_wren(pt_wren));

integer count;

task clock;
	begin
		clk = 1'b1;
		#1;
		clk = 1'b0;
		#1;
	end
endtask


initial begin
	rst_n = 1'b0;
	#1;       
	rst_n = 1'b1;
	count = 0;
	force dut.p.ct_length = 7'd100;
	key = 10'b1100111100;
	#1;
	clock;
	clock;
	clock;
	#1;
	en = 1'b1;
	#1;
	clock;
	for(i = 0; i < 3073; i = i + 1) begin  //after 256 clk cycles init is done, after 3072 cycles ksa is done
		count = count + 1;
		en = 1'b0;
		clock;
	end

end

endmodule: tb_rtl_arc4

