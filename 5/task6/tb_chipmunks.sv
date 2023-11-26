`timescale 1 ps / 1 ps
module tb_chipmunks();
integer i, y, failed;
reg clk, write_ready;
reg [9:0] SW;
reg [3:0] key;
chipmunks dut(.CLOCK_50(clk), .KEY(key), .SW);

task clock;
    begin
        clk = 1'b1;
        #1;
        clk = 1'b0;
        #1;
    end
endtask

task check_output (input int actual_left, int correct_left, int actual_right, int correct_right);
    if(actual_left == correct_left && actual_right == correct_right) 
        $display("Correct! actual_left: %d, actual_right: %d", actual_left, actual_right);
    else begin
        $error("Incorrect! actual_left: %d, it should be %d, actual_right: %d, it should be %d", actual_left, correct_left, actual_right, correct_right);
        failed = failed + 1;	
    end
endtask

initial begin 
    failed = 0;
    key[3] = 1'b0; //press reset
    key[0] = 1'b0; //press enable
    SW = 3'b0000000000; // set volume to high
    clock;
    key[3] = 1'b1; //release reset
    for (y = 0; y < 7; y = y + 1) clock;
    for (i = 0; i < 128; i = i + 1) begin
        check_output(dut.writedata_left, i * 2, dut.writedata_right, i * 2);
        for (y = 0; y < 4; y = y + 1) clock;
        check_output(dut.writedata_left, i * 2 + 1, dut.writedata_right, i * 2 + 1);
        for (y = 0; y < 8; y = y + 1) clock;
    end

    $display("Tests failed: %d", failed);
    $stop;
end
endmodule: tb_chipmunks