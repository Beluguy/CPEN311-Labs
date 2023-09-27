`timescale 1 ps / 1 ps
module tb_card7seg();
    // Your testbench goes here. Make sure your tests exercise the entire design
    // in the .sv file.  Note that in our tests the simulator will exit after
    // 10,000 ticks (equivalent to "initial #10000 $finish();").
            
    reg [3:0] SW;
    wire [6:0] HEX0;

    reg err_reg;
    card7seg dut (.SW(SW),.HEX0(HEX0));

    initial begin
        err_reg = 1'b0; //initialize err = 1'b0

        SW = 4'b0000;
        #1;
        if(HEX0 != 7'b1111111) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b1111111);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b0001;
        #1;
        if(HEX0 != 7'b0001000) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b0001000);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b0010;
        #1;
        if(HEX0 != 7'b0100100) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b0100100);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b0011;
        #1;
        if(HEX0 != 7'b0110000) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b0110000);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b0100;
        #1;
        if(HEX0 != 7'b0011001) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b0011001);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b0101;
        #1;
        if(HEX0 != 7'b0010010) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b0010010);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b0110;
        #1;
        if(HEX0 != 7'b0000010) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b0000010);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b0111;
        #1;
        if(HEX0 != 7'b1111000) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b1111000);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b1000;
        #1;
        if(HEX0 != 7'b0000000) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b0000000);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b1001;
        #1;
        if(HEX0 != 7'b0010000) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b0010000);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b1010;
        #1;
        if(HEX0 != 7'b1000000) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b1000000);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b1011;
        #1;
        if(HEX0 != 7'b1100001) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b1100001);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b1100;
        #1;
        if(HEX0 != 7'b0011000) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b0011000);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b1101;
        #1;
        if(HEX0 != 7'b0001001) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b0001001);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b1110;
        #1;
        if(HEX0 != 7'b1111111) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b1111111);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        SW = 4'b1111;
        #1;
        if(HEX0 != 7'b1111111) begin
        $display("Error: HEX0 is %b, expected display for input %b is %b", HEX0, SW, 7'b1111111);
        err_reg = 1'b1;
        end
        else begin
        $display("HEX0 correctly displaying %b for input %b", HEX0, SW);
        end
        #1;

        if(err_reg != 1'b0) begin
        $display("Display errors found. Review above results");
        end
        else begin
        $display("No errors found. Display is working as intended");
        end
        $stop;
    end			
endmodule