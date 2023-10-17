module ksa(input logic clk, input logic rst_n,
           input logic en, output logic rdy,
           input logic [23:0] key,
           output logic [7:0] addr, input logic [7:0] rddata, output logic [7:0] wrdata, output logic wren);
	// example decryption key from PDF: h00 03 3c -> b00000000 b00000011 b00111100
    // your code here                              

	//FIX KEYLENGTH

	integer i;
	reg [9:0] j;
	reg [3:0] state;
	reg [7:0] s_i;
	reg [7:0] s_j;

	reg [7:0] keyval;

	wire [7:0] key0;
	wire [7:0] key1;
	wire [7:0] key2;

	assign key2 = key[7:0];
	assign key1 = key[15:8];
	assign key0 = key[23:16];

	reg initialized;

	integer keyindex;
	assign keyindex = i % 3;

	// combinational state-bound signal wren

	always_comb begin
		case(keyindex)
		2'd0: keyval = key0;
		2'd1: keyval = key1;
		2'd2: keyval = key2;
		default: keyval = 8'b00000000;
		endcase

		case(state)
			4'b1000: wren = 1'b1;
			4'b1001: wren = 1'b1;
			4'b1010: wren = 1'b1;
			default: wren = 1'b0;
		endcase	
	end

	always @(posedge(clk), negedge(rst_n)) begin
		if(!rst_n) begin
			i <= 1'd0;
			j <= 1'd0;
			rdy <= 1'b1;
			initialized <= 1'b0;
			state <= 4'b0000;
		end
		else if(en && rdy && (state == 4'b0000) && !initialized) begin
			state <= state + 1'b1;
			rdy <= 1'b0;
		end
		else if(state == 4'b0001) begin   //load addr i
			addr <= i;
			state <= state + 1'b1;
		end
		else if(state == 4'b0010) begin //load rddata
			state <= state + 1'b1;
		end 
		else if(state == 4'b0011) begin  //load s_i
			s_i <= rddata;
			state <= state + 1'b1;
		end
		else if(state == 4'b0100) begin     //calculate j
			//j <= (j + s_i + key[i % keylength]) % 9'd256;
			j <= (j + s_i + keyval) % 9'd256;
			state <= state + 1'b1;
		end
		else if(state == 4'b0101) begin  //load addr j
			addr <= j;
			state <= state + 1'b1;
		end
		else if(state == 4'b0110) begin // load rddata
			state <= state + 1'b1;
		end
		else if(state == 4'b0111) begin // load s_j
			s_j <= rddata;
			state <= state + 1'b1;
		end
		else if(state == 4'b1000) begin   //load initial s[i] to address j (enable wren for this state)
			wrdata <= s_i;
			state <= state + 1'b1;
		end
		else if(state == 4'b1001) begin //load initial s[j] to address i (enable wren)   (s[j] is written to mem addr i)
			wrdata <= s_j;
			addr <= i;
			state <= state + 1'b1; 
		end
		else if(state == 4'b1010) begin //finish writing respective values to addr's (enable wren)  (s[i] is written to mem addr j)		
			state <= state + 1'b1;
		end
		else if(state == 4'b1011) begin //disable wren for this state
			if(i == 255) begin
				state <= 4'b0000; //return to state 0 (standby) if i has reached 255
				rdy <= 1'b1;
				i <= 1'd0;
				initialized <= 1'b1;
			end
			else begin
				state <= 4'b0001; //return to state 1 and continue loop if i < 255
				i <= i + 1;
			end
		end
	end

endmodule: ksa
