`timescale 1 ps / 1 ps
module tb_flash_reader();
integer i, y, failed;
reg clk;
reg [3:0] key;
flash_reader dut(.CLOCK_50(clk), .KEY(key));

task clock;
    begin
        clk = 1'b1;
        #1;
        clk = 1'b0;
        #1;
    end
endtask

task check_output (input int actual_data1, int correct_data1, int actual_data2, int correct_data2);
    if(actual_data1 == correct_data1 && actual_data2 == correct_data2) 
        $display("Correct! actual_data1: %d, actual_data2: %d", actual_data1, actual_data2);
    else begin
        $error("Incorrect! actual_data1: %d, it should be %d, actual_data2: %d, it should be %d", actual_data1, correct_data1, actual_data2, correct_data2);
        failed = failed + 1;	
    end
endtask

initial begin 
    failed = 0;
    key[3] = 1'b0; //press reset
    key[0] = 1'b0; //press enable
    clock;
    key[3] = 1'b1; //release reset
    for (y = 0; y < 6; y = y + 1) clock;
    for (i = 0; i < 128; i = i + 1) begin
        check_output(dut.data1, i * 2, dut.data2, i * 2 + 1);
        for (y = 0; y < 7; y = y + 1) clock;
    end
    $display("Tests failed: %d", failed);
    $stop;
end
endmodule: tb_flash_reader