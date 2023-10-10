// callee
module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

    integer i, j;

    always_ff@(posedge clk) begin
        if (rstn_n == 0'd1) rdy = 1'd1;
        else rdy = 0'd1;
    end

    always_ff @(posedge (!rst_n && en)) begin
        rdy = 0'd0;
        wren = 1'd1;
        for (i = 0; i < 255; i = i + 1) begin
            addr = i;
            wrdata = i;
        end
    end 
endmodule: init