module task1(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    wire en, rdy, wren;
    wire [7:0] addr;
    wire [7:0] wrdata;
    wire [7:0] q; //OUTPUT READ FOR TESTBENCH, READ 0-255

    s_mem s(.address(addr), .clock(CLOCK_50), .data(wrdata), .wren(wren), .q(LEDR[7:0]));
    init init(.clk(CLOCK_50), .rst_n(KEY[3]), .en(KEY[0]), .rdy(LEDR[9]), .addr(addr), .wrdata(wrdata), .wren(wren));

    

endmodule: task1
