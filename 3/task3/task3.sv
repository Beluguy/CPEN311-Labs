module task3(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

wire rst_n;
wire en;

assign rst_n = KEY[3];
assign en = ~KEY[0];

wire [7:0] ct_addr;
wire [7:0] ct_rddata;

wire [7:0] pt_addr;
wire [7:0] pt_rddata;
wire [7:0] pt_wrdata;
wire pt_wren;

wire rdy;
wire [23:0] key;
assign key = {14'b0,SW[9:0]};

wire [7:0] ct_wrdata;
assign ct_wrdata = 8'b0;
wire ct_wren;
assign ct_wren = 1'b0;
  
  // your code here

    ct_mem ct(.address(ct_addr),
		.clock(CLOCK_50),
		.data(ct_wrdata),
		.wren(ct_wren),
		.q(ct_rddata));

    pt_mem pt(.address(pt_addr),
		.clock(CLOCK_50),
		.data(pt_wrdata),
		.wren(pt_wren),
		.q(pt_rddata));

    arc4 a4(.clk(CLOCK_50),
		.rst_n(rst_n),
		.en(en),
		.rdy(rdy),
		.key(key),
		.ct_addr(ct_addr),
		.ct_rddata(ct_rddata),
		.pt_addr(pt_addr),
		.pt_rddata(pt_rddata),
		.pt_wrdata(pt_wrdata),
		.pt_wren(pt_wren));

    // your code here

endmodule: task3

