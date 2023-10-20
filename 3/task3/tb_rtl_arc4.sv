`timescale 1 ps / 1 ps
module tb_rtl_arc4();
	integer failed = 0;
	integer i = 0;

/*module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren)*/

	reg clk, rst_n, en;
	wire rdy, pt_wren;
	reg [23:0] key;
	wire [7:0] ct_addr;
	reg [7:0] ct_rddata;
	wire [7:0] pt_addr;
	reg [7:0] pt_rddata;
	wire [7:0] pt_wrdata;

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
			en = 1'b0;
			clock;
		end

	end
endmodule: tb_rtl_arc4

