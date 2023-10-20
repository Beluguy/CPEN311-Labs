module doublecrack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata);

	integer state;
	
	reg even_reg = 1'b0;
	wire even;
	assign even = even_reg;

	reg odd_reg = 1'b1;
	wire odd;
	assign odd = odd_reg;

	wire rdy1;
	wire rdy2;
	
	wire [23:0] key_even;
	wire [23:0] key_odd;
	wire key_valid_even;
	wire key_valid_odd;

	wire [7:0] finish_pt_even;
	wire [7:0] finish_pt_odd;

	reg stop_even;
	reg stop_odd;

	reg [7:0] finish_pt;
	wire [7:0] finish_pt_addr;
	reg finish_pt_wren;
	wire [7:0] q;
	integer finish_pt_count;
	assign finish_pt_addr = finish_pt_count;
	
	reg rdy_reg;
	assign rdy = rdy_reg;

	reg [23:0] key_reg;

	assign key_valid = (key_valid_even || key_valid_odd);
	
	integer ct_copy_count;
	
	reg [7:0] ct_copy_addr;
	reg [7:0] ct_copy_data;
	reg ct_copy_wren;
	wire [7:0] ct_copy_rddata;
	wire [7:0] ct_addr_c2;

	reg en1;
	reg en2;


    ct_mem ct_copy(.address(ct_copy_addr),
		.clock(clk),
		.data(ct_copy_data),
		.wren(ct_copy_wren),
		.q(ct_copy_rddata));

    // this memory must have the length-prefixed plaintext if key_valid
    pt_mem pt(.address(finish_pt_addr),
		.clock(clk),
		.data(finish_pt),
		.wren(finish_pt_wren),
		.q(q));

    // for this task only, you may ADD ports to crack
  
    crack2 c1(.clk(clk),   //even
	.rst_n(rst_n),
	.en(en1),
	.rdy(rdy1),
	.key(key_even),
	.key_valid(key_valid_even),
	.ct_addr(ct_addr),
	.ct_rddata(ct_rddata),
	.even_odd(even),
	.finish_pt(finish_pt_even),
	.stop(stop_even));

    crack2 c2(.clk(clk),    //odd
	.rst_n(rst_n),
	.en(en2),
	.rdy(rdy2),
	.key(key_odd),
	.key_valid(key_valid_odd),
	.ct_addr(ct_addr_c2),
	.ct_rddata(ct_copy_rddata),
	.even_odd(odd),
	.finish_pt(finish_pt_odd),
	.stop(stop_odd));

	always_comb begin
		case(state)
			2: {ct_copy_data, ct_copy_wren} = {ct_rddata, 1'b1};
			default: {ct_copy_data, ct_copy_wren} = {9'b0};
		endcase

		case(state)
			2: ct_copy_addr = ct_copy_count;
			default: ct_copy_addr = ct_addr_c2;
		endcase

		case(state)
			3: {en1,en2} = 2'b11;
			default: {en1,en2} = 2'b00;
		endcase
		
		case(state)
			6: {stop_even,stop_odd} = 2'b01;
			7: {stop_even,stop_odd} = 2'b10;
			default: {stop_even, stop_odd} = 2'b00;
		endcase
		
		case(state)
			2: {finish_pt,finish_pt_wren} = {9'b000000001}; 
			6: {finish_pt,finish_pt_wren} = {finish_pt_even, 1'b1};
			7: {finish_pt,finish_pt_wren} = {finish_pt_odd, 1'b1};
			default: {finish_pt,finish_pt_wren} = 9'b0;
		endcase

		case(state)
			8: rdy_reg = 1'b1;
			default: rdy_reg = 1'b0;
		endcase
		
		case({key_valid_even,key_valid_odd})
			2'b10: key_reg = key_even;
			2'b01: key_reg = key_odd;
			default: key_reg = 24'b0;
		endcase

		case(state)
			8: key = key_reg;
			default: key = 24'b0;
		endcase
	end

	
	always_ff @(posedge(clk), negedge(rst_n)) begin
		if(!rst_n) begin
			state <= 0;
			ct_copy_count <= 0;
			finish_pt_count <= 0;
		end
		else if((state == 0) && en) begin
			state <= state + 1;
		end
		else if(state == 1) begin
			state <= state + 1;
		end
		else if(state == 2) begin                        //copy CT to second CT memory inside doublecrack
			if(ct_copy_count < 256) begin
				ct_copy_count <= ct_copy_count + 1;
				finish_pt_count <= finish_pt_count + 1;   //reset PT memory for every run
			end
			else begin
				state <= state + 1;
				finish_pt_count <= 0;
			end
		end
		else if(state == 3) begin             //start c1 and c2
			state <= state + 1;
		end
		else if(state == 4) begin
			if(rdy1 || rdy2) begin
				state <= state + 1;
			end
		end
		else if(state == 5) begin
			if(key_valid_even) begin
				state <= 6;
			end
			else if(key_valid_odd) begin
				state <= 7;
			end
			else begin
				state <= 8;
			end
		end
		else if((state == 6) || (state == 7)) begin
			if(finish_pt_count < 256) begin
				finish_pt_count <= finish_pt_count + 1;
			end
			else begin
				state <= 8;
			end
		end


		
	end

    
    // your code here

endmodule: doublecrack
