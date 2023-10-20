`timescale 1 ps / 1 ps
module tb_rtl_prga();
	integer failed = 0;
	integer i = 0;

	//module prga(input logic clk, input logic rst_n,
				//input logic en, output logic rdy,
				//input logic [23:0] key,
				//output logic [7:0] s_addr, input logic [7:0] s_rddata, output logic [7:0] s_wrdata, output logic s_wren,
				//output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
				//output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);
	reg clk, rst_n, en;
	wire rdy;
	reg [23:0] key;

	wire [7:0] s_addr;
	reg [7:0] s_rddata;    // test val = 8'b10101010
	wire [7:0] s_wrdata;
	wire s_wren;

	wire [7:0] ct_addr;
	reg [7:0] ct_rddata;    // test val = 8'b01010101 (decimal 85, 85 cycles completed)

	wire [7:0] pt_addr;
	reg [7:0] pt_rddata;  
	wire [7:0] pt_wrdata;     //expected val = 8'b11111111
	wire pt_wren;

	prga dut(.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.rdy(rdy),
		.key(key),
		.s_addr(s_addr),
		.s_rddata(s_rddata),
		.s_wrdata(s_wrdata),
		.s_wren(s_wren),
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
		rst_n = 1'b0; //press reset
		#1;       
		rst_n = 1'b1;
		key = 10'b1100111100; //same key as PDF
		s_rddata = 8'b10101010;
		ct_rddata = 8'b01010101;
		#1;
		clock;

		//state 0
		if (rdy == 1 && dut.state == 0 && s_addr = 0 && s_wrdata == 0 && s_wren == 0 && 
			ct_addr == 0 && pt_addr == 0 && pr_wrdata == 0 && pt_wren == 0) 
			$display("Correct output for rdy: %b, state: %d, s_addr: %d, s_wrdata: %d, 
			s_wren: %d, ct_addr: %d, pt_addr: %b, pr_wrdata: %d, pt_wren: %d",
			rdy, dut.state, , s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pr_wrdata, pt_wren);
		else begin
			$error("Incorrect output for rdy: %b, state: %d, s_addr: %d, s_wrdata: %d, 
			s_wren: %d, ct_addr: %d, pt_addr: %b, pr_wrdata: %d, pt_wren: %d",
			rdy, dut.state, , s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pr_wrdata, pt_wren);
			failed = failed + 1;
		end 
		en = 1'b1;
	
		for(i = 0; i < 256; i = i + 1) begin
			clock;
			en = 1'b0;
			#1;
			s_rddata = 8'b10100000;    //pad[k]
			ct_rddata = 8'b01010000;   //ct[k+1]


			
			#1;
			clock;

		end
	end
endmodule: tb_rtl_prga
