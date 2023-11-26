module audio_codec_test(input logic clk, input logic rst_n,  input logic write,
                        output logic write_ready, input logic [15:0] writedata_left, input logic [15:0] writedata_right);
enum reg {waiting, busy} state;
int counter;

always_ff @(posedge clk) begin
    if (!rst_n) begin
        state <= waiting;   
        counter <= 0;  
    end   
    else begin
        case (state)
            waiting: begin
                if (counter == 1) counter <= 0;
                else if (write) state <= busy;
                else state <= waiting;
            end 
            busy: begin
                if (counter < 1) counter <= counter + 1;
                else if (counter == 1) state <= waiting;
                else state <= busy;
            end 
        endcase
    end
end

assign write_ready = (state == waiting) ? 1'b1 : 1'b0;
endmodule: audio_codec_test