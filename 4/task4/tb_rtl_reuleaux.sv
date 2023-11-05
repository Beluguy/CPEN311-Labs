module tb_rtl_reuleaux();
// Your testbench goes here. Our toplevel will give up after 1,000,000 ticks.
wire [7:0] vga_x;
wire [6:0] vga_y; 
wire [2:0] vga_colour;
wire vga_plot, done;
reg clk, rst_n, start;
int failed, x, y;
int centre_x = 80;
int centre_y = 60;
int diameter = 80;
int offset_y = 0;
int offset_x = diameter;
int crit = 1 - diameter;
int right_vga_plot;

integer hor_offset = diameter/2;
integer ver_offset = hor_offset*57735/100000; //0.57735 = 57735/100000
integer radius = 2*hor_offset;

integer top_circle_centre_x = centre_x;
integer top_circle_centre_y = centre_y - ver_offset*2;
integer left_circle_centre_x = centre_x - hor_offset;
integer left_circle_centre_y = centre_y + ver_offset;
integer right_circle_centre_x = centre_x + hor_offset;
integer right_circle_centre_y = centre_y + ver_offset;

reuleaux dut(.clk, .rst_n, .colour(vga_colour), .centre_x(centre_x), .centre_y(centre_y), .diameter(diameter), .start, .done, .vga_x, .vga_y, .vga_colour, .vga_plot);

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

task check_reuleaux (input int x, int y);
        if(((dut.state == 2) || (dut.state == 3)) && (x > left_circle_centre_x) && (x < right_circle_centre_x)) right_vga_plot = 1;
        else if(((dut.state == 4) || (dut.state == 5)) && (x >= centre_x) && (x <= right_circle_centre_x)) right_vga_plot = 1;
        else if(((dut.state == 6) || (dut.state == 7)) && (x >= left_circle_centre_x) && (x < centre_x)) right_vga_plot = 1;
        else right_vga_plot = 0;
        check_output(vga_x, vga_y, vga_colour, vga_plot, x, y, 2'd2, right_vga_plot);
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
    //then check is the reuleaux triangle in the correct position and size
    while(offset_y < offset_x) begin
        clock;
        check_reuleaux(top_circle_centre_x - offset_y, top_circle_centre_y + offset_x);

        clock;
        check_reuleaux(top_circle_centre_x + offset_y, top_circle_centre_y + offset_x);

        clock;
        check_reuleaux(left_circle_centre_x + offset_y, left_circle_centre_y - offset_x);

        clock;
        check_reuleaux(left_circle_centre_x + offset_x, left_circle_centre_y - offset_y);

        clock;
        check_reuleaux(right_circle_centre_x - offset_x, right_circle_centre_y - offset_y);

        clock;
        check_reuleaux(right_circle_centre_x - offset_y, right_circle_centre_y - offset_x);

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
endmodule: tb_rtl_reuleaux