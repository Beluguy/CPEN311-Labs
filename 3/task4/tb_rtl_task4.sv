`timescale 1 ps / 1 ps
module tb_rtl_task4();
	integer failed = 0;
	integer i = 0;

	reg CLOCK_50;
	reg [3:0] KEY;
	reg [9:0] SW;
	wire [6:0] HEX0;
	wire [6:0] HEX1;
	wire [6:0] HEX2;
	wire [6:0] HEX3;
	wire [6:0] HEX4;
	wire [6:0] HEX5;
	wire [9:0] LEDR;

	task4 dut(.CLOCK_50(CLOCK_50),
		.KEY(KEY),
		.SW(SW),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.LEDR(LEDR));

	task clock;
		begin
			CLOCK_50 = 1'b1;
			#1;
			CLOCK_50 = 1'b0;
			#1;
		end
	endtask

	initial begin
		KEY[3] = 1'b0;
		KEY[0] = 1'b1;
		#1;
		KEY[3] = 1'b1;
					//previous test to confirm init/ksa works: key = 10'b1100111100
		SW[9:0] = 10'b0000000000;  //test 2, key = 6'h000018 = 10'b0000011000    //Decoded message = Mrs. Dalloway said she would buy the flowers herself.
		$readmemh("C:/Users/bryan/Downloads/CPEN311/github/CPEN311-Labs/3/task4/test3.memh",dut.ct.altsyncram_component.m_default.altsyncram_inst.mem_data);
		#1;															//tests 1-3 (test 4 has a very big key)
		clock;
		clock;
		clock;
		KEY[0] = 1'b0;
		clock;
		for(i = 0; i < 100000; i = i + 1) begin  //after 256 clk cycles init is done, after 3072 cycles ksa is done
			KEY[0] = 1'b1;
			clock;
		end
	end
endmodule: tb_rtl_task4
