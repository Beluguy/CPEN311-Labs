//callee, it controls the rdy signal
module init(input logic clk, input logic rst_n,
        input logic en, output logic rdy,
        output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

    integer i;

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin 
            rdy <= 1'd1;
            i <= 0;
        end else begin
            if (rdy && en) begin
                rdy <= 1'd0;
                i <= 1;
            end else begin
                 if (i < 256) begin
                    rdy <= 1'd0;
                    wren <= 1'd1;
                    addr <= i;
                    wrdata <= i;
                    i <= i + 1;
                end else begin 
                    rdy <= 1'd0;
                    wren <= 1'd0;
                    addr <= addr;
                    wrdata <= wrdata;
                end 
            end
        end 
    end
endmodule: init