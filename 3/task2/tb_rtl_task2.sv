`timescale 1 ps / 1 ps
module tb_rtl_task2();

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

task2 dut(.CLOCK_50(CLOCK_50),
	  	.KEY(KEY),   //KEY[3] rst_n, KEY[0] en
		.SW(SW),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
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
	KEY[0] = 1'b1; //en not pressed
	SW[9:0] = 10'b1100111100; // sample key from pdf task 2
	#1;
	KEY[3] = 1'b1;
	#1;
	clock;
	clock;
	clock;
	clock;
	KEY[0] = 1'b0; //en pressed
	for(i = 0; i < 256; i = i + 1) begin
		clock;
		KEY[0] = 1'b1;
	end
	clock;
	clock;
	clock;
	
	KEY[0] = 1'b0;
	for(i = 0; i < 256; i = i + 1) begin
		clock;
		KEY[0] = 1'b1;
		clock;
		clock;
		clock;
		clock;
		clock;
		clock;
		clock;
		clock;
		clock;
		clock;
		
	end
	clock;
	clock;
	
	
end

endmodule: tb_rtl_task2
