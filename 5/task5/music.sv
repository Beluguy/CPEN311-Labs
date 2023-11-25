module music(input CLOCK_50, input CLOCK2_50, input [3:0] KEY, input [9:0] SW,
             input AUD_DACLRCK, input AUD_ADCLRCK, input AUD_BCLK, input AUD_ADCDAT,
             inout FPGA_I2C_SDAT, output FPGA_I2C_SCLK, output AUD_DACDAT, output AUD_XCK,
             output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2,
             output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5,
             output [9:0] LEDR);
			
// signals that are used to communicate with the audio core
// DO NOT alter these -- we will use them to test your design

reg read_ready, write_ready, write_s;
reg [15:0] writedata_left, writedata_right;
reg [15:0] readdata_left, readdata_right;	
wire reset, read_s;

assign read_s = 1'b0;

// signals that are used to communicate with the flash core
// DO NOT alter these -- we will use them to test your design

reg flash_mem_read;
reg flash_mem_waitrequest;
reg [22:0] flash_mem_address;
reg [31:0] flash_mem_readdata;
reg flash_mem_readdatavalid;
reg [3:0] flash_mem_byteenable;
reg rst_n, clk;

assign flash_mem_byteenable = 4'b1111;

// DO NOT alter the instance names or port names below -- we will use them to test your design

clock_generator my_clock_gen(CLOCK2_50, reset, AUD_XCK);
audio_and_video_config cfg(CLOCK_50, reset, FPGA_I2C_SDAT, FPGA_I2C_SCLK);
audio_codec codec(CLOCK_50,reset,read_s,write_s,writedata_left, writedata_right,AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK,read_ready, write_ready,readdata_left, readdata_right,AUD_DACDAT);
flash flash_inst(.clk_clk(clk), .reset_reset_n(rst_n), .flash_mem_write(1'b0), .flash_mem_burstcount(1'b1),
                 .flash_mem_waitrequest(flash_mem_waitrequest), .flash_mem_read(flash_mem_read), .flash_mem_address(flash_mem_address),
                 .flash_mem_readdata(flash_mem_readdata), .flash_mem_readdatavalid(flash_mem_readdatavalid), .flash_mem_byteenable(flash_mem_byteenable), .flash_mem_writedata());

// your code for the rest of this task here

reg [15:0] data1;
reg [15:0] data2;
integer state;
integer addr;
integer wr_addr;

assign rst_n = KEY[3];
assign reset = ~(KEY[3]);
assign en = ~(KEY[0]);
assign clk = CLOCK_50;

always_comb begin
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
end

/*
state cycles

normal speed: 0->1->2->3->4->5->6->7->1...
double speed: 0->1->2->3->4->7->1...
half speed:   0->1->2->3->4->8->9->5->6->10->11->7->1...

*/
always_ff @(posedge(clk), negedge(rst_n)) begin
	if(!rst_n) begin
		state <= 0;
		addr <= 0;
		wr_addr <= 0;
		writedata_left <= 0;
		writedata_right <= 0;
		write_s <= 1'b0;
		data1<= 16'b0;
		data2<= 16'b0;
	end
	else if((state == 0) && en) begin 
		state <= state + 1;
	end
	else if(state == 1) begin
		write_s <= 1'b0;
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
		if(write_ready == 1'b1) begin
			if (SW[1:0]==2'b01) begin
				wr_addr <= wr_addr + 2;
				state <= 7; // skip data2 entirely to double frequency
			end
			else if(SW[1:0]==2'b10) begin
				wr_addr <= wr_addr + 1;
				state <= 8;  //additional states to send data 1 a second time before moving to data2 (half frequency)
			end
			else begin
				wr_addr <= wr_addr + 1;
				state <= state + 1;
			end

			writedata_right <= data1;
			writedata_left <= data1;
			write_s <= 1'b1;
		end
		else begin
			state <= state;
		end
	end
	else if(state == 5) begin
		if(write_ready == 1'b0) begin
			state <= state + 1;
			write_s <= 1'b0;
		end
	end
	else if(state == 6) begin
		if(write_ready == 1'b1) begin
			wr_addr <= wr_addr + 1;
			writedata_right <= data2;
			writedata_left <= data2;
			write_s <= 1'b1;
			if(SW[1:0]==2'b10)begin  //additional states to send data 2 a second time 
				state <= 10;
			end
			else begin
				state <= state + 1;
			end
		end
	end
	else if(state == 7) begin
		if(write_ready == 1'b0) begin
			write_s <= 1'b0;
			if((wr_addr + 1) >= 2097152) begin
				state <= 1;                
				addr <= 0;
				wr_addr <= 0;
			end
			else begin
				addr <= addr + 1;
				state <= 1;
			end
		end
	end

	else if(state == 8) begin
		if(write_ready == 1'b0) begin
			state <= state + 1;
			write_s <= 1'b0;
		end
	end
	else if(state == 9) begin
		if(write_ready == 1'b1) begin
			state <= 5;
			writedata_right <= data1;
			writedata_left <= data1;
			write_s <= 1'b1;
		end
		else begin
			state <= state;
		end
	end
	else if(state == 10) begin
		if(write_ready == 1'b0) begin
			state <= state + 1;
			write_s <= 1'b0;
		end
	end
	else if(state == 11) begin
		if(write_ready == 1'b1) begin
			state <= 7;
			writedata_right <= data2; //<<< 6 (ASR 6 -> divide by 64)
			writedata_left <= data2;
			write_s <= 1'b1;
		end
		else begin
			state <= state;
		end
	end
	
	
end

endmodule: music
