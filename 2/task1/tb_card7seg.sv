module tb_card7seg();
// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").					
    reg [3:0] SW;
    wire [6:0] HEX0;

    card7seg dut(.SW, .HEX0);

    initial begin
        KEY[0] <= 1'b0; 
        forever #5 KEY[0] <= ~KEY[0];
    end
    
    initial begin
        SW = 10'd0; // print nothing (blank)
        #10;
        assert(HEX0 === 7'b1111111) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd1; // print "1"
        #10;
        assert(HEX0 === 7'b1111001) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd2; // print "2"
        #10;
        assert(HEX0 === 7'b0100100) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd3; // print "3"
        #10;
        assert(HEX0 === 7'b0110000) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd4; // print "4"
        #10;
        assert(HEX0 === 7'b0011001) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd5; // print "5"
        #10;
        assert(HEX0 === 7'b0010010) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd6; // print "6"
        #10;
        assert(HEX0 === 7'b0000010) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd7; // print "7"
        #10;
        assert(HEX0 === 7'b1111000) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd8; // print "8"
        #10;
        assert(HEX0 === 7'b0000000) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd9; // print "9"
        #10;
        assert(HEX0 === 7'b0010000) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd10; // print "0"
        #10;
        assert(HEX0 === 7'b1000000) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd11; // print "j"
        #10;
        assert(HEX0 === 7'b1110000) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd12; // print "q"
        #10;
        assert(HEX0 === 7'b0001100) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd13; // print "K"
        #10;
        assert(HEX0 === 7'b0001001) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd14; // print nothing (blank)
        #10;
        assert(HEX0 === 7'b1111111) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");

        SW = 10'd15; // print nothing (blank)
        #10;
        assert(HEX0 === 7'b1111111) $display("[PASS] for displaying digit 0");
        else $error("[FAIL] to display digit 0 ");
     end
endmodule