module flash_test(input logic clk_clk, input logic reset_reset_n,
             input logic flash_mem_write, input logic [6:0] flash_mem_burstcount,
             output logic flash_mem_waitrequest, input logic flash_mem_read,
             input logic [22:0] flash_mem_address, output logic [31:0] flash_mem_readdata,
             output logic flash_mem_readdatavalid, input logic [3:0] flash_mem_byteenable,
             input logic [31:0] flash_mem_writedata);
logic clk, read, waitrequest, readdatavalid, address, rst_n;
assign clk = clk_clk;
assign read = flash_mem_read;
assign address = flash_mem_address;
assign readdata = flash_mem_readdata;

integer i;

enum reg [1:0] {reset, waiting, busy, finished} state;

always_ff @(posedge clk) begin
    if (rst_n)state <= reset;        
    else begin
        case (state)
            reset: state <= waiting;
            waiting: begin
                if (read) state <= busy;
                else state <= waiting;
            end 
            busy: begin
                if (address == 256) state <= finished;
                else if (address < 256) state <= waiting;
                else state <= busy;
            end 
            finished: state <= finished;
            default: state <= reset;
        endcase
    end
end

assign flash_mem_waitrequest = (state == busy) ? 1'b1 : 1'b0;
assign flash_mem_readdatavalid = (state == waiting) ? 1'b1 : 1'b0;
assign readdata = address;
endmodule: flash_test