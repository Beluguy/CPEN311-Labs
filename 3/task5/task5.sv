module task5(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

	integer state;

	reg [7:0] ct_addr;
	wire [7:0] ct_dc_addr;
	integer ct_copy_count;
	wire [7:0] ct_rddata;
	wire ct_wren;
	assign ct_wren = 1'b0;
	wire [23:0] key;
	wire key_valid;

	wire rst_n;
	wire en;
	assign rst_n = KEY[3];
	assign en = ~KEY[0];
	wire rdy;

	reg enabled;

	reg [6:0] hex0_input;
	reg [6:0] hex1_input;
	reg [6:0] hex2_input;
	reg [6:0] hex3_input;
	reg [6:0] hex4_input;
	reg [6:0] hex5_input;

	wire [6:0] hex0_input_wire;
	wire [6:0] hex1_input_wire;
	wire [6:0] hex2_input_wire;
	wire [6:0] hex3_input_wire;
	wire [6:0] hex4_input_wire;
	wire [6:0] hex5_input_wire;

	assign hex0_input_wire = hex0_input;
	assign hex1_input_wire = hex1_input;
	assign hex2_input_wire = hex2_input;
	assign hex3_input_wire = hex3_input;
	assign hex4_input_wire = hex4_input;
	assign hex5_input_wire = hex5_input;


		ct_mem ct(.address(ct_addr),
			.clock(CLOCK_50),
			.data(ct_rddata),
			.wren(ct_wren),
			.q(ct_rddata));
		doublecrack dc(.clk(CLOCK_50),
			.rst_n(rst_n),
			.en(en),
			.rdy(rdy),
			.key(key),
			.key_valid(key_valid),
			.ct_addr(ct_dc_addr),
			.ct_rddata(ct_rddata));


	always_comb begin
		case(state)
			1: ct_addr = ct_copy_count;                //copy CT to second CT memory inside doublecrack
			default: ct_addr = ct_dc_addr;
		endcase

		case({enabled,rdy,key_valid})
			3'b111: {HEX0,HEX1,HEX2,HEX3,HEX4,HEX5} = {hex0_input_wire,hex1_input_wire,hex2_input_wire,hex3_input_wire,hex4_input_wire,hex5_input_wire};
			3'b110: {HEX0,HEX1,HEX2,HEX3,HEX4,HEX5} = 42'b011111101111110111111011111101111110111111;
			default: {HEX0,HEX1,HEX2,HEX3,HEX4,HEX5} = 42'b111111111111111111111111111111111111111111;
		endcase

		case(key[3:0])
			4'b0000: hex0_input = 7'b1000000; //0
			4'b0001: hex0_input = 7'b1111001; //1
				4'b0010: hex0_input = 7'b0100100; //2
				4'b0011: hex0_input = 7'b0110000; //3
				4'b0100: hex0_input = 7'b0011001; //4
				4'b0101: hex0_input = 7'b0010010; //5
				4'b0110: hex0_input = 7'b0000010; //6
				4'b0111: hex0_input = 7'b1111000; //7
				4'b1000: hex0_input = 7'b0000000; //8
				4'b1001: hex0_input = 7'b0010000; //9
				4'b1010: hex0_input = 7'b0001000; //A
			4'b1011: hex0_input = 7'b0000011; //b
			4'b1100: hex0_input = 7'b1000110; //C
			4'b1101: hex0_input = 7'b0100001; //d
			4'b1110: hex0_input = 7'b0000110; //E
			4'b1111: hex0_input = 7'b0001110; //F
			default: hex0_input = 7'b1111111;
		endcase
		case(key[7:4])
			4'b0000: hex1_input = 7'b1000000; //0
			4'b0001: hex1_input = 7'b1111001; //1
				4'b0010: hex1_input = 7'b0100100; //2
				4'b0011: hex1_input = 7'b0110000; //3
				4'b0100: hex1_input = 7'b0011001; //4
				4'b0101: hex1_input = 7'b0010010; //5
				4'b0110: hex1_input = 7'b0000010; //6
				4'b0111: hex1_input = 7'b1111000; //7
				4'b1000: hex1_input = 7'b0000000; //8
				4'b1001: hex1_input = 7'b0010000; //9
				4'b1010: hex1_input = 7'b0001000; //A
			4'b1011: hex1_input = 7'b0000011; //b
			4'b1100: hex1_input = 7'b1000110; //C
			4'b1101: hex1_input = 7'b0100001; //d
			4'b1110: hex1_input = 7'b0000110; //E
			4'b1111: hex1_input = 7'b0001110; //F
			default: hex1_input = 7'b1111111;
		endcase
		case(key[11:8])
			4'b0000: hex2_input = 7'b1000000; //0
			4'b0001: hex2_input = 7'b1111001; //1
				4'b0010: hex2_input = 7'b0100100; //2
				4'b0011: hex2_input = 7'b0110000; //3
				4'b0100: hex2_input = 7'b0011001; //4
				4'b0101: hex2_input = 7'b0010010; //5
				4'b0110: hex2_input = 7'b0000010; //6
				4'b0111: hex2_input = 7'b1111000; //7
				4'b1000: hex2_input = 7'b0000000; //8
				4'b1001: hex2_input = 7'b0010000; //9
				4'b1010: hex2_input = 7'b0001000; //A
			4'b1011: hex2_input = 7'b0000011; //b
			4'b1100: hex2_input = 7'b1000110; //C
			4'b1101: hex2_input = 7'b0100001; //d
			4'b1110: hex2_input = 7'b0000110; //E
			4'b1111: hex2_input = 7'b0001110; //F
			default: hex2_input = 7'b1111111;
		endcase
		case(key[15:12])
			4'b0000: hex3_input = 7'b1000000; //0
			4'b0001: hex3_input = 7'b1111001; //1
				4'b0010: hex3_input = 7'b0100100; //2
				4'b0011: hex3_input = 7'b0110000; //3
				4'b0100: hex3_input = 7'b0011001; //4
				4'b0101: hex3_input = 7'b0010010; //5
				4'b0110: hex3_input = 7'b0000010; //6
				4'b0111: hex3_input = 7'b1111000; //7
				4'b1000: hex3_input = 7'b0000000; //8
				4'b1001: hex3_input = 7'b0010000; //9
				4'b1010: hex3_input = 7'b0001000; //A
			4'b1011: hex3_input = 7'b0000011; //b
			4'b1100: hex3_input = 7'b1000110; //C
			4'b1101: hex3_input = 7'b0100001; //d
			4'b1110: hex3_input = 7'b0000110; //E
			4'b1111: hex3_input = 7'b0001110; //F
			default: hex3_input = 7'b1111111;
		endcase
		case(key[19:16])
			4'b0000: hex4_input = 7'b1000000; //0
			4'b0001: hex4_input = 7'b1111001; //1
				4'b0010: hex4_input = 7'b0100100; //2
				4'b0011: hex4_input = 7'b0110000; //3
				4'b0100: hex4_input = 7'b0011001; //4
				4'b0101: hex4_input = 7'b0010010; //5
				4'b0110: hex4_input = 7'b0000010; //6
				4'b0111: hex4_input = 7'b1111000; //7
				4'b1000: hex4_input = 7'b0000000; //8
				4'b1001: hex4_input = 7'b0010000; //9
				4'b1010: hex4_input = 7'b0001000; //A
			4'b1011: hex4_input = 7'b0000011; //b
			4'b1100: hex4_input = 7'b1000110; //C
			4'b1101: hex4_input = 7'b0100001; //d
			4'b1110: hex4_input = 7'b0000110; //E
			4'b1111: hex4_input = 7'b0001110; //F
			default: hex4_input = 7'b1111111;
		endcase
		case(key[23:20])
			4'b0000: hex5_input = 7'b1000000; //0
			4'b0001: hex5_input = 7'b1111001; //1
				4'b0010: hex5_input = 7'b0100100; //2
				4'b0011: hex5_input = 7'b0110000; //3
				4'b0100: hex5_input = 7'b0011001; //4
				4'b0101: hex5_input = 7'b0010010; //5
				4'b0110: hex5_input = 7'b0000010; //6
				4'b0111: hex5_input = 7'b1111000; //7
				4'b1000: hex5_input = 7'b0000000; //8
				4'b1001: hex5_input = 7'b0010000; //9
				4'b1010: hex5_input = 7'b0001000; //A
			4'b1011: hex5_input = 7'b0000011; //b
			4'b1100: hex5_input = 7'b1000110; //C
			4'b1101: hex5_input = 7'b0100001; //d
			4'b1110: hex5_input = 7'b0000110; //E
			4'b1111: hex5_input = 7'b0001110; //F
			default: hex5_input = 7'b1111111;
		endcase
	end

    always_ff @(posedge(CLOCK_50), negedge(rst_n)) begin
		if(!rst_n) begin
			state <= 0;
			ct_copy_count <= 0;
			enabled <= 1'b0;
		end
		else if((state == 0) && en) begin
			enabled <= 1'b1;
			state <= state + 1;
		end
		else if(state == 1) begin                            //copy CT to second CT memory inside doublecrack
			if(ct_copy_count < 256) begin
				ct_copy_count <= ct_copy_count + 1;
			end
			else begin
				state <= state + 1;
			end
		end
	end
endmodule: task5
