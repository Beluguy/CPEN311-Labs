module flash_test(input logic clk_clk, input logic reset_reset_n,
             input logic flash_mem_write, input logic [6:0] flash_mem_burstcount,
             output logic flash_mem_waitrequest, input logic flash_mem_read,
             input logic [22:0] flash_mem_address, output logic [31:0] flash_mem_readdata,
             output logic flash_mem_readdatavalid, input logic [3:0] flash_mem_byteenable,
             input logic [31:0] flash_mem_writedata);
enum reg [1:0] {reset, waiting, busy, finished} state;
int counter;

always_ff @(posedge clk_clk) begin
    if (!reset_reset_n) begin
        state <= reset;   
        counter <= 0;   
    end   
    else begin
        case (state)
            reset: state <= waiting;
            waiting: begin
                if (counter == 2) begin
                    counter <= 0;
                    flash_mem_readdata <= flash_mem_address;
                end 
                else if (flash_mem_read) state <= busy;
                else state <= waiting;
            end 
            busy: begin
                if (counter < 2) counter <= counter + 1;
                else if (flash_mem_address == 256) state <= finished;
                else if (flash_mem_address < 256 && counter == 2) state <= waiting;
                else state <= busy;
            end 
            finished: state <= finished;
            default: state <= reset;
        endcase
    end
end

assign flash_mem_waitrequest = (state == busy) ? 1'b1 : 1'b0;
assign flash_mem_readdatavalid = (state == waiting) ? 1'b1 : 1'b0;
endmodule: flash_test