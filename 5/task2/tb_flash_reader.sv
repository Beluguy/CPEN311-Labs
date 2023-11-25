`timescale 1 ps / 1 ps
module tb_flash_reader();
integer i, failed;
reg clk, rst_n;
reg [3:0] en;
flash_reader dut(.CLOCK_50(clk), .KEY(en));

task clock;
    begin
        clk = 1'b1;
        #1;
        clk = 1'b0;
        #1;
    end
endtask

task check_output (input int actual_data, int correct_data);
    if(actual_data == correct_data) $display("Correct! actual_data: %d", actual_data);
    else begin
        $error("Incorrect! actual_data: %d", actual_data);
        failed = failed + 1;	
    end
endtask

initial begin 
    failed = 0;
    rst_n = 1'b0;
    en = 4'd0;
    #1;
    rst_n = 1'b1;
    #1;
    for (i = 0; i < 256; i = i + 1) begin 
        clock;
        check_output(dut.samples.data, i);
    end 
    $display("Tests failed: %d", failed);
    $stop;
end
endmodule: tb_flash_reader