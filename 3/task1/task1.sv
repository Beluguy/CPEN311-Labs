module task1(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here

    s_mem s(.address(addr), .clock(CLOCK_50), .data(wrdata), .wren(wren), .q(q));

    init init(.clk(CLOCK_50), .rst_n(KEY[3]), .en(), .rdy(), .addr(), .wrdata(), .wren());

    // your code here

endmodule: task1
