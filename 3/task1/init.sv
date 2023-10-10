module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

    integer i, j;
    s_men s(.address(addr), .clock(clk), .data(wrdata), .wren(wren), .q());

    always_ff @(posedge (!rst_n && en)) begin
        for (i = 0; 0 < 255; i = i + 1) begin
            s[i] = i;
        end
    end 
endmodule: init