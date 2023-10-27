`timescale 1 ps / 1 ps
module tb_rtl_crack();
	/*
	module crack(input logic clk, input logic rst_n,
				input logic en, output logic rdy,
				output logic [23:0] key, output logic key_valid,
				output logic [7:0] ct_addr, input logic [7:0] ct_rddata);
	*/
	integer failed = 0;
	integer i = 0;

	reg clk;
	reg rst_n;
	reg en;
	wire rdy;
	wire [23:0] key;
	wire key_valid;
	wire [7:0] ct_addr;
	reg [7:0] ct_rddata;

	crack dut(.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.rdy(rdy),
		.key(key),
		.key_valid(key_valid),
		.ct_addr(ct_addr),
		.ct_rddata(ct_rddata));

	task clock;
		begin
			clk = 1'b1;
			#1;
			clk = 1'b0;
			#1;
		end
	endtask

	integer count;

	initial begin
		rst_n = 1'b0;
		count = 0;
		#1;
		rst_n = 1'b1;
		#1;
		clock;
		clock;
		clock;
		clock;
		#1;
		en = 1'b1;
		#1;
		clock;
		#1;
		en = 1'b0;
		#1;
		clock;
		for(i = 0; i < 20000; i = i + 1) begin //3075
			clock;
		end
	end
endmodule: tb_rtl_crack
