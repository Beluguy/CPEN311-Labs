`timescale 1 ps / 1 ps
module tb_rtl_task1();

// Your testbench goes here.
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

//module task1(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
//             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
//             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
//             output logic [9:0] LEDR);

task1 dut(.CLOCK_50(CLOCK_50),
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
	KEY[3] = 1'b0;
	#1;
	KEY[3] = 1'b1;
	#1;
	clock;
	clock;
	clock;
	if(LEDR[9] == 1'b1) begin
		$display("Correct output for LEDR9: init is in rdy state");
	end
	else begin
		$display("Incorrect output for LEDR9: %b. Expected 1", LEDR[9]);
		failed = failed + 1;
	end

	if((dut.init.addr == 0)&&(dut.init.wrdata == 0)&&(dut.init.wren == 0)) begin
		$display("Correct output for addr, wrdata, wren: %d %d %b", dut.init.addr, dut.init.wrdata, dut.init.wren);
	end
	else begin
		$display("Incorrect output for addr, wrdata, wren: %d %d %b. Expected output : 0, 0, 0", dut.init.addr, dut.init.wrdata, dut.init.wren);
		failed = failed + 1;
	end
	KEY[0] = 1'b1;
	#1;
	for(i = 0; i < 256; i = i + 1) begin
		clock;
		if((dut.init.addr == i)&&(dut.init.wrdata == i)&&(dut.init.wren == 1)) begin
			$display("Correct output for addr, wrdata, wren: %d %d %b", dut.init.addr, dut.init.wrdata, dut.init.wren);
		end
		else begin
			$display("Incorrect output for addr, wrdata, wren: %d %d %b. Expected output : %d, %d, 1", dut.init.addr, dut.init.wrdata, dut.init.wren, i, i);
		failed = failed + 1;
		end
		KEY[0]= 1'b0;
	end
	clock;
	if((dut.init.addr == 255)&&(dut.init.wrdata == 255)&&(dut.init.wren == 0)) begin
		$display("Correct output for addr, wrdata, wren: %d %d %b", dut.init.addr, dut.init.wrdata, dut.init.wren);
	end
	else begin
		$display("Incorrect output for addr, wrdata, wren: %d %d %b. Expected output : 255, 255, 0", dut.init.addr, dut.init.wrdata, dut.init.wren);
		failed = failed + 1;	
	end
	clock;
	if(LEDR[9] == 1'b1) begin
		$display("Correct output for LEDR9: init is in rdy state");
	end
	else begin
		$display("Incorrect output for LEDR9: %b. Expected 1", LEDR[9]);
		failed = failed + 1;
	end
	clock;
	KEY[0] = 1'b1;
	clock;
	KEY[0] = 1'b0;
	clock;
	KEY[3] = 1'b0;
	#1;
	KEY[3] = 1'b1;
	#1;
	clock;
	clock;
	KEY[0] = 1'b1;
	clock;
	KEY[0] = 1'b0;
	$display("Tests failed: %d", failed);
	$stop;


end

endmodule: tb_rtl_task1
