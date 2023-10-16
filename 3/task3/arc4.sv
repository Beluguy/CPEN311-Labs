module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

integer state;

wire [7:0] init_s_addr;
wire [7:0] init_s_wrdata;
wire init_s_wren;

wire [7:0] ksa_s_addr;
wire [7:0] ksa_s_wrdata;
wire ksa_s_wren;

wire [7:0] prga_s_addr;
wire [7:0] prga_s_wrdata;
wire prga_s_wren;

reg [7:0] s_addr_reg;
reg [7:0] s_wrdata_reg;
reg s_wren_reg;

wire [7:0] s_addr;
wire [7:0] s_rddata;
wire [7:0] s_wrdata;
wire s_wren;

assign s_addr = s_addr_reg;
assign s_wrdata = s_wrdata_reg;
assign s_wren = s_wren_reg;

wire init_done;
wire ksa_done;
wire prga_done;

reg init_started;
reg ksa_started;

reg ksa_en_reg;
wire ksa_en;
assign ksa_en = ksa_en_reg;

reg prga_en_reg;
wire prga_en;
assign prga_en = prga_en_reg;


	s_mem s(.address(s_addr),
		.clock(clk),
		.data(s_wrdata),
		.wren(s_wren),
		.q(s_rddata));

	init i(.clk(clk), 
		.rst_n(rst_n), 
		.en(en), 
		.rdy(init_done),
 
		.addr(init_s_addr),      //s module
		.wrdata(init_s_wrdata), 
		.wren(init_s_wren));

	ksa k(.clk(clk),
		.rst_n(rst_n),
		.en(ksa_en),
		.rdy(ksa_done),
		.key(key),

		.addr(ksa_s_addr),       //s module
		.rddata(s_rddata),
		.wrdata(ksa_s_wrdata),
		.wren(ksa_s_wren));

	prga p(.clk(clk),
		.rst_n(rst_n),
		.en(prga_en),
		.rdy(prga_done),
		.key(key),

		.s_addr(prga_s_addr),      //s module
		.s_rddata(s_rddata),
		.s_wrdata(prga_s_wrdata),
		.s_wren(prga_s_wren),

		.ct_addr(ct_addr),
		.ct_rddata(ct_rddata),
		.pt_addr(pt_addr),
		.pt_rddata(pt_rddata),
		.pt_wrdata(pt_wrdata),
		.pt_wren(pt_wren));

always_comb begin
	case({init_started,init_done})
		2'b11: ksa_en_reg = 1'b1;      //ksa_en only when init has started and is done
		default: ksa_en_reg = 1'b0;
	endcase

	case({ksa_started,ksa_done})
		2'b11: prga_en_reg = 1'b1;     //prga_en only when ksa has started and is done
		default: prga_en_reg = 1'b0;
	endcase
	
	case(state)
		1: {s_addr_reg,s_wrdata_reg,s_wren_reg} = {init_s_addr, init_s_wrdata, init_s_wren};           // init
		2: {s_addr_reg,s_wrdata_reg,s_wren_reg} = {ksa_s_addr, ksa_s_wrdata, ksa_s_wren};      // ksa
		3: {s_addr_reg,s_wrdata_reg,s_wren_reg} = {prga_s_addr, prga_s_wrdata, prga_s_wren};  //prga
		default: {s_addr_reg,s_wrdata_reg,s_wren_reg} = 17'b0;
	endcase

	if(prga_done && ksa_done && init_done) rdy = 1'b1; //final output rdy
	else rdy = 1'b0;
end

always @(posedge(clk), negedge(rst_n)) begin
		if(!rst_n) begin
			state <= 0;
			init_started <= 1'b0;
			ksa_started <= 1'b0;
		end
		else if((state == 0) && (en == 1'b1)) begin
			init_started <= 1'b1;
			state <= state + 1;
		end
		else if((state == 1) && (ksa_en == 1'b1)) begin
			ksa_started <= 1'b1;
			state <= state + 1;
		end
		else if((state == 2) && (prga_en == 1'b1)) begin
			state <= state + 1;
		end
end

endmodule: arc4
