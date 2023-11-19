module flash_reader(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
                    output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
                    output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
                    output logic [9:0] LEDR);

// You may use the SW/HEX/LEDR ports for debugging. DO NOT delete or rename any ports or signals.

logic clk, rst_n;

assign clk = CLOCK_50;
assign rst_n = KEY[3];
assign en = !KEY[0];

logic flash_mem_read, flash_mem_waitrequest, flash_mem_readdatavalid;
logic [22:0] flash_mem_address;
logic [31:0] flash_mem_readdata;
logic [3:0] flash_mem_byteenable;
logic wren;

flash flash_inst(.clk_clk(clk), 
		.reset_reset_n(rst_n), 
		.flash_mem_write(1'b0), 
		.flash_mem_burstcount(1'b1),
                 .flash_mem_waitrequest(flash_mem_waitrequest),  //output from controller
		.flash_mem_read(flash_mem_read), 
		.flash_mem_address(flash_mem_address),
                 .flash_mem_readdata(flash_mem_readdata),   //output from controller
		.flash_mem_readdatavalid(flash_mem_readdatavalid),   //output from controller
		.flash_mem_byteenable(flash_mem_byteenable), 
		.flash_mem_writedata());

reg [15:0] data1;
reg [15:0] data2;
reg [15:0] writedata;
integer state;
integer addr;
integer wr_addr;


s_mem samples(.address(wr_addr),
		.clock(clk),
		.data(writedata),
		.wren(wren),
		.q());

assign flash_mem_byteenable = 4'b1111;

always_comb begin
	case(state) 
		4: wren = 1'b1;
		5: wren = 1'b1;
		default: wren = 1'b0;
	endcase
	case(state) 
		1: flash_mem_address = addr;
		2: flash_mem_address = addr;
		default: flash_mem_address = 0;
	endcase	
	case(state) 
		1: flash_mem_read = 1'b1;
		2: flash_mem_read = 1'b1;
		default: flash_mem_read = 1'b0;
	endcase	
	case(state)
		4: writedata = data1;
		5: writedata = data2;
		default: writedata = 16'b0;
	endcase
end

always_ff @(posedge(clk), negedge(rst_n)) begin
	if(!rst_n) begin
		state <= 0;
		addr <= 0;
		wr_addr <= 0;
	end
	else if((state == 0) && en) begin 
		state <= state + 1;
	end
	else if(state == 1) begin
		state <= state + 1;
	end
	else if(state == 2) begin
		if(flash_mem_waitrequest == 0) begin
			state <= state + 1;
		end
		else begin
			state <= state;
		end
	end
	else if(state == 3) begin
		if(flash_mem_readdatavalid == 1) begin
			data1 <= flash_mem_readdata[15:0];
			data2 <= flash_mem_readdata[31:16];
			state <= state + 1;
		end
		else begin
			state <= state;
		end
	end
	else if(state == 4) begin
		wr_addr <= wr_addr + 1;
		state <= state + 1;
	end
	else if(state == 5) begin
		wr_addr <= wr_addr + 1;
		addr <= addr + 1;
		if((wr_addr + 1) == 256) begin
			state <= 6;
		end
		else begin
			state <= 1;
		end
	end

	
	
end

endmodule: flash_reader