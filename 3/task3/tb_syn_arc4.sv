`timescale 1 ps / 1 ps
module tb_syn_arc4();
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

	reg [7:0] s_i = 69;
	reg [7:0] s_j = 96;

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
		#1;
		clock;

		//state 0
		if (rdy == 1 && dut.state == 0 && s_wren == 0 && pt_wren == 0) 
			$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
		else begin
			$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			failed = failed + 1;
		end 
		en = 1'b1;

		clock;
		//state 1
		if (rdy == 0 && dut.state == 1 && s_wren == 0 && pt_wren == 0) 
			$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
		else begin
			$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			failed = failed + 1;
		end

		clock;
		//state 2
		if (rdy == 0 && dut.state == 2 && s_wren == 0 && pt_wren == 1) 
			$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
		else begin
			$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			failed = failed + 1;
		end
		force dut.ct_length = 255;

		for(i = 0; i < 255; i = i + 1) begin
			clock;
			en = 1'b0;

			//state 3
			if (rdy == 0 && dut.state == 3 && s_wren == 0 && pt_wren == 0) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
				end

            clock;
			//state 4
			if (rdy == 0 && dut.state == 4 && s_wren == 0 && pt_wren == 0) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
			end

            clock;
			//state 5
			if (rdy == 0 && dut.state == 5 && s_wren == 0 && pt_wren == 0) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
			end

            clock;
			//state 6
			if (rdy == 0 && dut.state == 6 && s_wren == 0 && pt_wren == 0) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
			end

            clock;
			//state 7
			if (rdy == 0 && dut.state == 7 && s_wren == 0 && pt_wren == 0) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
			end

            clock;
			//state 8
			if (rdy == 0 && dut.state == 8 && s_wren == 1 && pt_wren == 0) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
			end

            clock;
			//state 9
			if (rdy == 0 && dut.state == 9 && s_wren == 1 && pt_wren == 0) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
			end

            clock;
			//state 10
			if (rdy == 0 && dut.state == 10 && s_wren == 0 && pt_wren == 0) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
			end

            clock;
			//state 11
			if (rdy == 0 && dut.state == 11 && s_wren == 0 && pt_wren == 0) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
			end

            clock;
			//state 12
			if (rdy == 0 && dut.state == 12 && s_wren == 0 && pt_wren == 0) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
			end

            clock;
			//state 13
			if (rdy == 0 && dut.state == 13 && s_wren == 0 && pt_wren == 0) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
			end

            clock;
			//state 14
			if (rdy == 0 && dut.state == 14 && s_wren == 0 && pt_wren == 1) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
			end

            clock;
			//state 15
			if (rdy == 0 && dut.state == 15 && s_wren == 0 && pt_wren == 0) 
				$display("Correct output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
			else begin
				$error("Incorrect output for rdy: %b, state: %d, s_wren: %d, pt_wren: %d", rdy, dut.state, s_wren, pt_wren);
				failed = failed + 1;
			end
		end

		//now check for rdy after en is pressed and initialization 
		clock;
		en = 1'b1;
		clock;
		en = 1'b0;
		clock;

		if(rdy == 1'b1) $display("Correct: rdy is 1 after initialized");
		else begin
			$error("Incorret: rdy is %d after initialized", rdy);
			failed = failed + 1;	
		end

		//now check for rdy after reset and enable is pressed 
		rst_n = 1'b0;
		#1;
		rst_n = 1'b1;
		#1;
		clock;
		en = 1'b1;
		clock;
		en = 1'b0;
		clock;

		if(rdy == 1'b0) $display("Correct: rdy is 0 after reset and enable");
		else begin
			$error("Incorret: rdy is %d after reset and enable", rdy);
			failed = failed + 1;	
		end
		$display("Tests failed: %d", failed);
		$stop;
	end
endmodule: tb_syn_arc4
