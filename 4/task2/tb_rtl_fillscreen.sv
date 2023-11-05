`timescale 1 ps / 1 ps
module tb_rtl_fillscreen();
// Your testbench goes here. Our toplevel will give up after 1,000,000 ticks.
wire [7:0] vga_x;
wire [6:0] vga_y; 
wire [2:0] vga_colour;
wire vga_plot, done;
reg clk, rst_n, start;
integer failed, x, y;

fillscreen dut(.clk, .rst_n, .colour(), .start, .done, .vga_x, .vga_y, .vga_colour, .vga_plot);

task clock;
    begin
        clk = 1'b1;
        #1;
        clk = 1'b0;
        #1;
    end
endtask

task check_output (input int dut_x, int dut_y, int dut_colour, dut_vga_plot, int correct_x, int correct_y, int correct_colour, correct_vga_plot);
    if(dut_x == correct_x && dut_y == correct_y && dut_colour == correct_colour && dut_vga_plot == correct_vga_plot) 
        $display("Correct! vga_x: %d, vga_y: %d, vga_colour: %d, vga_plot:%b", dut_x, dut_y, dut_colour, vga_plot);
    else begin
        $error("Incorrect! vga_x: %d, vga_y: %d, vga_colour: %d, vga_plot:%b", dut_x, dut_y, dut_colour, vga_plot);
        failed = failed + 1;	
    end
endtask

initial begin 
    failed = 0;
    rst_n = 1'b0;
    #1;
    rst_n = 1'b1;
    #1;
    start = 1'b1;
    for (x = 0; x < 160; x = x + 1) begin
        for (y = 0; y < 120; y = y + 1) begin 
            clock;
            check_output(vga_x, vga_y, vga_colour, vga_plot, x, y, x % 8, 1'b1);
        end 
    end 
    
    clock;
    if (done == 1'b1) begin 
        start = 1'b0;
    end
    clock;
    if(done == 1'b1 && vga_plot == 1'b0) 
        $display("Correct! done: %b, vga_plot: %b, state: %d", done, vga_plot, dut.state);
    else begin
        $error("Incorrect! done: %b, vga_plot: %b, state: %d", done, vga_plot, dut.state);
        failed = failed + 1;
    end 

    $display("Tests failed: %d", failed);
    $stop;
end 
endmodule: tb_rtl_fillscreen