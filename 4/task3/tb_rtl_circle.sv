module tb_rtl_circle();
// Your testbench goes here. Our toplevel will give up after 1,000,000 ticks.
wire [7:0] vga_x;
wire [6:0] vga_y; 
wire [2:0] vga_colour;
wire vga_plot, done;
reg clk, rst_n, start;
int failed, x, y;
int centre_x = 80;
int centre_y = 60;
int radius = 40;
int offset_y = 0;
int offset_x = radius;
int crit = 1 - radius;

circle dut(.clk, .rst_n, .colour(vga_colour), .centre_x(centre_x), .centre_y(centre_y), .radius(radius), .start, .done, .vga_x, .vga_y, .vga_colour, .vga_plot);

task clock;
    begin
        clk = 1'b1;
        #1;
        clk = 1'b0;
        #1;
    end
endtask

task check_output (input int dut_x, int dut_y, int dut_colour, bit dut_vga_plot, int correct_x, int correct_y, int correct_colour, bit correct_vga_plot);
    if(dut_x == correct_x && dut_y == correct_y && dut_colour == correct_colour && dut_vga_plot == correct_vga_plot) 
        $display("Correct! vga_x: %3d, vga_y: %3d, vga_colour: %3d, vga_plot:%b", dut_x, dut_y, dut_colour, vga_plot);
    else begin
        $error("Incorrect! expectd vga_x: %3d, actual vga_x: %3d, expected vga_y: %3d, actual vga_y: %3d,
                expected vga_colour: %3d, actual vga_colour: %3d, expected vga_plot: %b, actual vga_plot: %b", 
                correct_x, dut_x, correct_y, dut_y, correct_colour, dut_colour, correct_vga_plot, vga_plot);
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

    //first check is the screen black
    for (x = 0; x < 160; x = x + 1) begin
        for (y = 0; y < 120; y = y + 1) begin 
            clock;
            check_output(vga_x, vga_y, vga_colour, vga_plot, x, y, 1'b0, 1'b1);
        end 
    end 
    
    clock;
    //then check is the circle in the correct position and size
    while(offset_y < offset_x) begin
        clock;
        x = centre_x + offset_x;
        y = centre_y + offset_y;
        check_output(vga_x, vga_y, vga_colour, vga_plot, x, y, 2'd2, 1'b1);

        clock;
		x = centre_x + offset_y;
		y = centre_y + offset_x;
        check_output(vga_x, vga_y, vga_colour, vga_plot, x, y, 2'd2, 1'b1);

        clock;
		x = centre_x - offset_x;
		y = centre_y + offset_y;
        check_output(vga_x, vga_y, vga_colour, vga_plot, x, y, 2'd2, 1'b1);

        clock;
		x = centre_x - offset_y;
		y = centre_y + offset_x;
        check_output(vga_x, vga_y, vga_colour, vga_plot, x, y, 2'd2, 1'b1);

        clock;
		x = centre_x - offset_x;
        y = centre_y - offset_y;
        check_output(vga_x, vga_y, vga_colour, vga_plot, x, y, 2'd2, 1'b1);

        clock;
		x = centre_x - offset_y;
		y = centre_y - offset_x;
        check_output(vga_x, vga_y, vga_colour, vga_plot, x, y, 2'd2, 1'b1);

        clock;
		x = centre_x + offset_x;
		y = centre_y - offset_y;
        check_output(vga_x, vga_y, vga_colour, vga_plot, x, y, 2'd2, 1'b1);

        clock;
		x = centre_x + offset_y;
		y = centre_y - offset_x;
        check_output(vga_x, vga_y, vga_colour, vga_plot, x, y, 2'd2, 1'b1);

        offset_y = offset_y + 1;
        if (crit <= 0) crit = crit + 2*offset_y + 1;
        else begin
			offset_x <= offset_x - 1;
			crit <= crit + 2*(offset_y - offset_x) + 1;
		end
    end 

    //check is done low after drawing
    clock;
    if (done == 1'b1) begin 
        start = 1'b0;
    end
    clock;
    if(done == 1'b1 && vga_plot == 1'b0) 
        $display("Correct! done: %b, vga_plot: %b", done, vga_plot);
    else begin
        $error("Incorrect! done: %b, vga_plot: %b", done, vga_plot);
        failed = failed + 1;
    end 

    $display("Tests failed: %d", failed);
    $stop;
end 
endmodule: tb_rtl_circle