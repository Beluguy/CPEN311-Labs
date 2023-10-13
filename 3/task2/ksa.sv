module ksa(input logic clk, input logic rst_n,
           input logic en, output logic rdy,
           input logic [23:0] key,
           output logic [7:0] addr, input logic [7:0] rddata, output logic [7:0] wrdata, output logic wren);
// example decryption key from PDF: h00033c -> b1100111100
    // your code here

integer i,j;
reg [3:0] state;
reg [7:0] s_i;
reg [7:0] s_j;
integer keylength;




// combinational state-bound signal wren

always_comb begin
	if(key <= 4'b1111) keylength = 2'd1;
	else if(key <= 8'b11111111) keylength = 2'd2;
	else if(key <= 12'b111111111111) keylength = 2'd3;
	else if(key <= 16'b1111111111111111) keylength = 3'd4;
	else if(key <= 20'b11111111111111111111) keylength = 3'd5;
	else keylength = 3'd6;

case(state)
	4'b0110: wren = 1'b1;
	4'b0111: wren = 1'b1;
	4'b1000: wren = 1'b1;
	default: wren = 1'b0;
endcase

	
end



always @(posedge(clk), negedge(rst_n)) begin
	if(!rst_n) begin
		i <= 1'd0;
		j <= 1'd0;
		rdy <= 1'b1;
		state <= 4'b0000;
	end
	else if(en && rdy && (state == 4'b0000)) begin
		state <= state + 1'b1;
		rdy <= 1'b0;
	end
	else if(state == 4'b0001) begin   //load addr i
		addr <= i;
		state <= state + 1'b1;
	end
	else if(state == 4'b0010) begin  //load s_i
		s_i <= rddata;
		state <= state + 1'b1;
	end
	else if(state == 4'b0011) begin     //calculate j
		j <= (j + s_i + key[i % keylength]) % 256;
		state <= state + 1'b1;
	end
	else if(state == 4'b0100) begin  //load addr j
		addr <= j;
		state <= state + 1'b1;
	end
	else if(state == 4'b0101) begin // load s_j
		s_j <= rddata;
		state <= state + 1'b1;
	end
	else if(state == 4'b0110) begin   //load initial s[i] to address j (enable wren for this state)
		wrdata <= s_i;
		state <= state + 1'b1;
	end
	else if(state == 4'b0111) begin //load initial s[j] to address i (enable wren)   (s[j] is written to mem addr i)
		wrdata <= s_j;
		addr <= i;
		state <= state + 1'b1;
	end
	else if(state == 4'b1000) begin //finish writing respective values to addr's (enable wren)  (s[i] is written to mem addr j)		state <= state + 1'b1;
		state <= state + 1'b1;
	end
	else if(state == 4'b1001) begin //disable wren for this state
		if(i == 255) begin
			state <= 4'b0000; //return to state 0 (standby) if i has reached 255
			rdy <= 1'b1;
			i <= 1'd0;
		end
		else begin
			state <= 4'b0001; //returm to state 1 and continue loop if i < 255
			i <= i + 1;
		end
	end
end

endmodule: ksa
