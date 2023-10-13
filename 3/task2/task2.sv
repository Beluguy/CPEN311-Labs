module task2(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    	wire en;
	wire rdy;
	wire wren;
	wire [7:0] addr;
	wire [7:0] wrdata;
	wire [7:0] rddata;

//module ksa(input logic clk, input logic rst_n,
//           input logic en, output logic rdy,
//           input logic [23:0] key,
//           output logic [7:0] addr, input logic [7:0] rddata, output logic [7:0] wrdata, output logic wren);

	reg [2:0]test_en;
	wire [2:0] test_en_wire;
	assign test_en_wire = test_en;
	
	reg [3:0] state;

	wire [2:0] rdy_wire;
	
	reg [23:0] key_val;
	assign key_val = {14'b0,SW[9:0]};
	wire [23:0] key_val_wire;
	assign key_val_wire = key_val;

	wire init_wren;
	wire ksa_wren;
	wire [7:0] init_wrdata;
	wire [7:0] ksa_wrdata;
	wire [7:0] init_addr;
	wire [7:0] ksa_addr;
	
	reg wren_reg;
	reg [7:0] wrdata_reg;
	reg [7:0] addr_reg;
	
	assign wren = wren_reg;
	assign wrdata = wrdata_reg;
	assign addr = addr_reg;


	s_mem s(.address(addr),
		.clock(CLOCK_50),
		.data(wrdata),
		.wren(wren),
		.q(rddata));

	init init(.clk(CLOCK_50), 
		.rst_n(KEY[3]), 
		.en(test_en_wire[0]), 
		.rdy(rdy_wire[0]), 
		.addr(init_addr), 
		.wrdata(init_wrdata), 
		.wren(init_wren));

	ksa ksa(.clk(CLOCK_50),
		.rst_n(KEY[3]),
		.en(test_en_wire[1]),
		.rdy(rdy_wire[1]),
		.key(key_val_wire),
		.addr(ksa_addr),
		.rddata(rddata),
		.wrdata(ksa_wrdata),
		.wren(ksa_wren));

	always_comb begin
		case(state)
			4'b0000: test_en = {2'b00, ~KEY[0]};
			4'b0001: test_en = {1'b0, ~KEY[0], 1'b0};
			default: test_en = 3'b000;
		endcase
		case(state)
			4'b0001: wren_reg = init_wren;
			4'b0010: wren_reg = ksa_wren;
			default: wren_reg = 1'b0;
		endcase
		case(state)
			4'b0001: wrdata_reg = init_wrdata;
			4'b0010: wrdata_reg = ksa_wrdata;
			default: wrdata_reg = 8'b00000000;
		endcase
		case(state)
			4'b0001: addr_reg = init_addr;
			4'b0010: addr_reg = ksa_addr;
			default: addr_reg = 8'b00000000;
		endcase
	end

	always @(posedge(CLOCK_50), negedge(KEY[3])) begin
		if(!KEY[3]) begin
			state <= 4'b0000;
		end
		else if((state == 4'b0000) && (rdy_wire[0] == 1'b1) && (test_en_wire == 3'b001)) begin
			state <= 4'b0001;
		end
		else if((state == 4'b0001) && (rdy_wire[1:0] == 2'b11) && (test_en_wire == 3'b010)) begin
			state <= 4'b0010;
		end
		else if((state == 4'b0010) && (rdy_wire [1:0] == 2'b11)) begin
			state <= 4'b0011;
		end
	end

endmodule: task2
