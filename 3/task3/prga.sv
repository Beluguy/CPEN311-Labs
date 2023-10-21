module prga(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] s_addr, input logic [7:0] s_rddata, output logic [7:0] s_wrdata, output logic s_wren,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

	//i = 0, j = 0
	//for k = 0 to message_length-1:
		//i = (i+1) mod 256
		//j = (j+s[i]) mod 256
		//swap values of s[i] and s[j]
		//pad[k] = s[(s[i]+s[j]) mod 256]
		//plaintext[k] = pad[k] xor ciphertext[k] -- xor each byte

	//ct[0] = length prefix
	reg initialized;
	integer i;
	integer j;
	integer k;
	reg [7:0] ct_length; // max length = 255 (first character is length)
	integer state;

	reg [7:0] s_i;
	reg [7:0] s_j;

	integer pad_s_index;

	reg [7:0] pt_k_plus1;


	//outputs: s_addr,s_wrdata,s_wren,
	//         ct_addr
	//         pt_addr, pt_wrdata, pt_wren

	always_comb begin
	// s module
		case(state)
			4: s_addr = i; //read
			7: s_addr = j; //read
			8: s_addr = j; //write
			9: s_addr = i; //write
			12: s_addr = pad_s_index; //read
			default: s_addr = 8'b0;
		endcase

		case(state)
			8: s_wrdata = s_i;
			9: s_wrdata = s_j;
			default: s_wrdata = 8'b0;
		endcase
	
		case(state)
			8: s_wren = 1'b1;
			9: s_wren = 1'b1;
			default: s_wren = 1'b0;
		endcase

	// ct module
		case(state)
			1: ct_addr = k;   //read
			12: ct_addr = k + 1; //read
			default: ct_addr = 8'b0;
		endcase
		
	// pt module
		case(state)
			2: pt_addr = 0; //write
			14: pt_addr = k + 1; //write
			default: pt_addr = 8'b0;
		endcase

		case(state)
			2: pt_wrdata = ct_rddata;
			14: pt_wrdata = pt_k_plus1;
			default: pt_wrdata = 8'b0;
		endcase

		case(state)
			2: pt_wren = 1'b1;
			14: pt_wren = 1'b1;
			default: pt_wren = 1'b0;
		endcase
	end

	always_ff @(posedge(clk), negedge(rst_n)) begin
		if(!rst_n) begin
			i <= 1'd0;
			j <= 1'd0;
			k <= 1'd0;
			initialized <= 1'b0;
			rdy <= 1'b1;
			state <= 5'd0;
		end
		else if(en && rdy && (state == 0) && !initialized) begin
			state <= state + 1;
			rdy <= 1'b0;
		end
		else if(state == 1) begin   //ct_addr = k = 0 for state 1
			state <= state + 1;
		end
		else if(state == 2) begin   //load ct_rddata to ct_length (length-prefixed ct string)
			ct_length <= ct_rddata; //pt_wrdata = ct_rddata, pt_addr = 0, pt_wren = 1 for state 2  (load ct_rddata to pt[0])
			state <= state + 1;
		end

		//loop begins here
		else if(state == 3) begin  //ct_length now assigned, loop back to this state for subsequent cycles
			i <= (i + 1) % 256;
			state <= state + 1;
		end
		else if(state == 4) begin   //s_addr = i for state 4
			state <= state + 1;
		end
		else if(state == 5) begin   //load s_rddata to s_i
			s_i <= s_rddata;
			state <= state + 1;
		end
		else if(state == 6) begin   //load j value
			j <= (j + s_i) % 256;
			state <= state + 1;
		end
		else if(state == 7) begin   //s_addr = j for state 7
			state <= state + 1;
		end
		else if(state == 8) begin   //load s_rddata to s_j
			s_j <= s_rddata;     //s_addr = j, s_wren = 1, s_wrdata = s_i for state 8
			state <= state + 1;
		end
		else if(state == 9) begin   //initial s_i now at s address j
			state <= state + 1; //s_addr = i, s_wren = 1, s_wrdata = s_j for state 9
		end
		else if(state == 10) begin  //initial s_j now at s address i
			state <= state + 1; 
		end
		else if(state == 11) begin  //compute pad s index
			pad_s_index <= (s_i + s_j) % 256;  
			state <= state + 1;
		end
		else if(state == 12) begin  //s_addr = pad_s_index, ct_addr = k + 1 for state 12
			state <= state + 1;
		end
		else if(state == 13) begin  //load s_rdddata XOR ct_rddata to pt_k_plus1
			pt_k_plus1 <= (s_rddata ^ ct_rddata);	 
			state <= state + 1;
		end
		else if(state == 14) begin  //pt_addr = k + 1, pt_wren = 1, pt_wrdata = pt_k_plus1 for state 14
			state <= state + 1;
		end
		else if(state == 15) begin //pt_k_plus1 now loaded to pt[k+1], continue loop or end
			if(k == (ct_length - 1)) begin
				state <= 0;
				rdy <= 1'b1;
				initialized <= 1'b1;
			end
			else begin
				k <= (k + 1);
				state <= 3;
			end
		end
	end
endmodule: prga