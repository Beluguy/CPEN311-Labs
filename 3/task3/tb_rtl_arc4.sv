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
		rst_n = 1'b0; //press reset
		#1;       
		rst_n = 1'b1; //release reset
		#1;
		clock;
		en = 1'b1; //press enable
		clock;
		en = 1'b0; //release enable
		clock;
		if(rdy == 1'b0) $display("Correct: rdy is 0 after reset and enable");
		else begin
			$error("Incorret: rdy is %d after reset and enable", rdy);
			failed = failed + 1;	
		end

		//testing the always comb
		force dut.init_started = 1;
		force dut.init_done = 1;
		clock;
		if(dut.ksa_en_reg == 1) $display("Correct: ksa_en_reg is 1 after reset and enable");
		else begin
			$error("Incorret: ksa_en_reg is %d after reset and enable", dut.ksa_en_reg);
			failed = failed + 1;	
		end
		
		force dut.ksa_started = 1;
		force dut.ksa_done = 1;
		clock;
		if(dut.prga_en_reg == 1) $display("Correct: prga_en_reg is 1 after reset and enable");
		else begin
			$error("Incorret: prga_en_reg is %d after reset and enable", dut.prga_en_reg);
			failed = failed + 1;	
		end


		//testing the always block
		force dut.state = 0;
		force dut.en = 1;
		clock;
		if(dut.init_started == 1) $display("Correct: prga_en_reg is 1 after reset and enable");
		else begin
			$error("Incorret: prga_en_reg is %d after reset and enable", dut.init_started);
			failed = failed + 1;	
		end

		force dut.state = 1;
		force dut.ksa_en = 1;
		clock;
		if(dut.ksa_started == 1) $display("Correct: init_started is 1 after reset and enable");
		else begin
			$error("Incorret: init_started is %d after reset and enable", rdy);
			failed = failed + 1;	
		end

		$display("Tests failed: %d", failed);
		$stop;
	end
endmodule: tb_rtl_arc4