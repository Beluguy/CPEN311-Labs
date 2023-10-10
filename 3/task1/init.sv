module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

    integer i, j;
    s_men s(.address(addr), .clock(clk), .data(wrdata), .wren(wren), .q());

    always_ff @(posedge (!rst_n && en)) begin
        wren = 1'd1;
        for (i = 0'd8; i < 255'd8; i = i + 1'd8) begin
            addr = i;
            wrdata = i;
        end
    end 
endmodule: init