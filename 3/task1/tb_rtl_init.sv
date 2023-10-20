`timescale 1 ps / 1 ps
module tb_rtl_init();
    integer failed = 0;
    integer i = 0;

    reg clk, rst_n, en, rdy, wren;
    reg [7:0] addr;
    wire [7:0] wrdata;
	
    init dut (.clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy), .addr(addr), .wrdata(wrdata), .wren(wren));

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
		#1;
		clock;
		if((addr == 0)&&(wrdata == 0)&&(wren == 0)&&(rdy == 1)) begin
			$display("Correct output for addr, wrdata, wren, rdy: %d %d %b %b", addr, wrdata, wren, rdy);
		end
		else begin
			$error("Incorrect output for addr, wrdata, wren, rdy: %d %d %b %b. Expected output : 0, 0, 0", addr, wrdata, wren, rdy);
			failed = failed + 1;
		end
		en = 1'b1;
		
		for(i = 0; i < 256; i = i + 1) begin
			clock;
			if((addr == i)&&(wrdata == i)&&(wren == 1)) begin
				$display("Correct output for addr, wrdata, wren: %d %d %b", addr, wrdata, wren);
			end
			else begin
				$error("Incorrect output for addr, wrdata, wren: %d %d %b. Expected output : %d, %d, 1", addr, wrdata, wren, i, i);
			failed = failed + 1;
			end
			en = 1'b0;
		end
		clock;
		if((addr == 255)&&(wrdata == 255)&&(wren == 0)) begin
			$display("Correct output for addr, wrdata, wren: %d %d %b", addr, wrdata, wren);
		end
		else begin
			$error("Incorrect output for addr, wrdata, wren: %d %d %b. Expected output : 255, 255, 0", addr, wrdata, wren);
			failed = failed + 1;	
		end
		
		clock;
		en = 1'b1;
		clock;
		en = 1'b0;
		clock;

		if(rdy == 1'b1) $display("Correct: rdy is %d after initialized", rdy);
		else begin
			$error("rdy is %d after initialized", rdy);
			failed = failed + 1;	
		end

		rst_n = 1'b0;
		#1;
		rst_n = 1'b1;
		#1;
		clock;
		en = 1'b1;
		clock;
		en = 1'b0;
		clock;

		if(rdy == 1'b1) $display("Correct: rdy is %d after reset", rdy);
		else begin
			$error("rdy is %d after reset", rdy);
			failed = failed + 1;	
		end

		$display("Tests failed: %d", failed);
		$stop;
	end
endmodule: tb_rtl_init
