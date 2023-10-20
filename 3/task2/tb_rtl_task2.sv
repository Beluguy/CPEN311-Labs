`timescale 1 ps / 1 ps
module tb_rtl_task2();
	integer failed = 0;
	integer i = 0;

	reg CLOCK_50;
	reg [3:0] KEY;
	reg [9:0] SW;
	wire [9:0] LEDR;

	task2 dut(.CLOCK_50(CLOCK_50),
			.KEY(KEY),   //KEY[3] rst_n, KEY[0] en for init, KEY[1] en for ksa
			.SW(SW),
			.HEX0(),
			.HEX1(),
			.HEX2(),
			.HEX3(),
			.HEX4(),
			.HEX5(),
			.LEDR(LEDR)); //LEDR[0] rdy

	task clock;
		begin
			CLOCK_50 = 1'b1;
			#1;
			CLOCK_50 = 1'b0;
			#1;
		end
	endtask

	initial begin
		KEY[3] = 1'b0; //rst pressed
		KEY[0] = 1'b1; //init en not pressed
		KEY[1] = 1'b1; //ksa en not pressed
		#1;
		KEY[3] = 1'b1;
		#1;
		clock;

		if(dut.rdy_wire[0] == 1'b1) begin //rdy wire for init
			$display("Correct output for rdy wire for init: init is in rdy state");
		end
		else begin
			$error("Incorrect output for rdy wire for init: %b. Expected 1", dut.rdy_wire[0]);
			failed = failed + 1;
		end

		SW[9:0] = 10'b1100111100; // sample key from pdf task 2
		KEY[0] = 1'b0; //init en pressed

		//for loop for init to finish
		for(i = 0; i < 256; i = i + 1) begin
			clock;
			KEY[0] = 1'b1;
		end
		clock;
		clock;
		clock;


		KEY[1] = 1'b0; //ksa en pressed
		for(i = 0; i < 256; i = i + 1) begin   //after 256 clk cycles, init is done, after 
			clock;
			KEY[1] = 1'b1;	
			if(dut.ksa.state == 1 && dut.ksa_wren == 0 && dut.rdy_wire[1] == 0) begin
				$display("Correct output for state: %d, wren: %d, rdy: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1]);
			end
			else begin
				$error("Incorrect output for state: %d, wren: %d, rdy: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1]);
			failed = failed + 1;
			end
		
			clock;
			//state 2
			if(dut.ksa.state == 2 && dut.ksa_wren == 0 && dut.rdy_wire[1] == 0 && dut.s.address == i) begin
				$display("Correct output for state: %d, wren: %d, rdy: %d, mem addr: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1], dut.s.address);
			end
			else begin
				$error("Incorrect output for state: %d, wren: %d, rdy: %d, mem addr: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1], dut.s.address);
			failed = failed + 1;
			end

			clock;
			//state 3
			if(dut.ksa.state == 3 && dut.ksa_wren == 0 && dut.rdy_wire[1] == 0) begin
				$display("Correct output for state: %d, wren: %d, rdy: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1]);
			end
			else begin
				$error("Incorrect output for state: %d, wren: %d, rdy: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1]);
			failed = failed + 1;
			end

			clock;
			//state 4
			if(dut.ksa.state == 4 && dut.ksa_wren == 0 && dut.rdy_wire[1] == 0 && dut.rddata == dut.s.q) begin
				$display("Correct output for state: %d, wren: %d, rdy: %d, rddata: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1], dut.s.q);
			end
			else begin
				$error("Incorrect output for state: %d, wren: %d, rdy: %d, rddata: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1], dut.s.q);
			end

			clock;
			//state 5
			if(dut.ksa.state == 5 && dut.ksa_wren == 0 && dut.rdy_wire[1] == 0) begin
				$display("Correct output for state: %d, wren: %d, rdy: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1]);
			end
			else begin
				$error("Incorrect output for state: %d, wren: %d, rdy: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1]);
			failed = failed + 1;
			end

			clock;
			//state 6
			if(dut.ksa.state == 6 && dut.ksa_wren == 0 && dut.rdy_wire[1] == 0) begin
				$display("Correct output for state: %d, wren: %d, rdy: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1]);
			end
			else begin
				$error("Incorrect output for state: %d, wren: %d, rdy: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1]);
			failed = failed + 1;
			end

			clock;
			//state 7
			if(dut.ksa.state == 7 && dut.ksa_wren == 0 && dut.rdy_wire[1] == 0) begin
				$display("Correct output for state: %d, wren: %d, rdy: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1]);
			end
			else begin
				$error("Incorrect output for state: %d, wren: %d, rdy: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1]);
			failed = failed + 1;
			end

			clock;
			//state 8
			if(dut.ksa.state == 8 && dut.ksa_wren == 1 && dut.rdy_wire[1] == 0 && dut.ksa.s_j == dut.s.q) begin
				$display("Correct output for state: %d, wren: %d, rdy: %d, s_j: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1], dut.s.q);
			end
			else begin
				$error("Incorrect output for state: %d, wren: %d, rdy: %d, s_j: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1], dut.s.q);
			failed = failed + 1;
			end

			clock;
			//state 9
			if(dut.ksa.state == 9 && dut.ksa_wren == 1 && dut.rdy_wire[1] == 0 && dut.s.data == dut.ksa.s_i) begin //check is data about to write to mem the same as s_i
				$display("Correct output for state: %d, wren: %d, rdy: %d, wrdata: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1], dut.s.data);
			end
			else begin
				$error("Incorrect output for state: %d, wren: %d, rdy: %d, wrdata: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1], dut.s.data);
			failed = failed + 1;
			end

			clock;
			//state 10
			if(dut.ksa.state == 10 && dut.ksa_wren == 1 && dut.rdy_wire[1] == 0 && dut.s.address == i && dut.s.data == dut.ksa.s_j) begin
				$display("Correct output for state: %d, wren: %d, rdy: %d, mem addr: %d, s_j: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1], dut.s.address, dut.s.data);
			end
			else begin
				$error("Incorrect output for state: %d, wren: %d, rdy: %d, mem addr: %d, s_j: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1], dut.s.address, dut.s.data);
			failed = failed + 1;
			end

			clock;
			//state 11
			if(dut.ksa.state == 11 && dut.ksa_wren == 0 && dut.rdy_wire[1] == 0) begin
				$display("Correct output for state: %d, wren: %d, rdy: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1]);
			end
			else begin
				$error("Incorrect output for state: %d, wren: %d, rdy: %d", dut.ksa.state, dut.ksa_wren, dut.rdy_wire[1]);
			failed = failed + 1;
			end
		end

		clock;
		KEY[0] = 1'b0; //press reset
		clock;
		KEY[0] = 1'b1;
		clock;

		if(dut.rdy_wire == 2'b11) $display("Correct: rdy is %b after initialized", dut.rdy_wire);
		else begin
			$error("rdy is %b after initialized", dut.rdy_wire);
			failed = failed + 1;	
		end

		KEY[3] = 1'b0;	//press reset
		#1;
		KEY[3] = 1'b1;	
		#1;
		clock;
		KEY[1] = 1'b0;	//press ksa for init
		clock;
		KEY[1] = 1'b1;
		clock;

		if(dut.rdy_wire[1] == 1'b0) $display("Correct: ksa rdy is %b after reset and ksa enable", dut.rdy_wire[1]);
		else begin
			$error("Incorrect: ksa rdy is %b after reset", dut.rdy_wire[1]);
			failed = failed + 1;	
		end

		$display("Tests failed: %d", failed);
		$stop;
	end
endmodule: tb_rtl_task2