module tb_card7seg();
// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").					
    reg [3:0] SW;
    wire [6:0] HEX0;

    card7seg dut(.SW, .HEX0);
    
    initial begin
        SW = 4'd0; // print nothing (blank)
        #10;
        assert(HEX0 === 7'b1111111) $display("[PASS] for displaying nothing for input 0");
        else $error("[FAIL] to display nothing for input 0");

        SW = 4'd1; // print "A"
        #10;
        assert(HEX0 === 7'b0001000) $display("[PASS] for displaying 'A'");
        else $error("[FAIL] to display 'A' ");

        SW = 4'd2; // print "2"
        #10;
        assert(HEX0 === 7'b0100100) $display("[PASS] for displaying '2'");
        else $error("[FAIL] to display '2'");

        SW = 4'd3; // print "3"
        #10;
        assert(HEX0 === 7'b0110000) $display("[PASS] for displaying '3'");
        else $error("[FAIL] to display '3'");

        SW = 4'd4; // print "4"
        #10;
        assert(HEX0 === 7'b0011001) $display("[PASS] for displaying '4'");
        else $error("[FAIL] to display '4'");

        SW = 4'd5; // print "5"
        #10;
        assert(HEX0 === 7'b0010010) $display("[PASS] for displaying '5'");
        else $error("[FAIL] to display ''5");

        SW = 4'd6; // print "6"
        #10;
        assert(HEX0 === 7'b0000010) $display("[PASS] for displaying '6'");
        else $error("[FAIL] to display '6'");

        SW = 4'd7; // print "7"
        #10;
        assert(HEX0 === 7'b1111000) $display("[PASS] for displaying '7'");
        else $error("[FAIL] to display '7'");

        SW = 4'd8; // print "8"
        #10;
        assert(HEX0 === 7'b0000000) $display("[PASS] for displaying '8'");
        else $error("[FAIL] to display '8'");

        SW = 4'd9; // print "9"
        #10;
        assert(HEX0 === 7'b0010000) $display("[PASS] for displaying '9'");
        else $error("[FAIL] to display '9'");

        SW = 4'd10; // print "0"
        #10;
        assert(HEX0 === 7'b1000000) $display("[PASS] for displaying '0'");
        else $error("[FAIL] to display '0' ");

        SW = 4'd11; // print "j"
        #10;
        assert(HEX0 === 7'b1110000) $display("[PASS] for displaying 'j'");
        else $error("[FAIL] to display 'j'");

        SW = 4'd12; // print "q"
        #10;
        assert(HEX0 === 7'b0001100) $display("[PASS] for displaying'q'");
        else $error("[FAIL] to display 'q' ");

        SW = 4'd13; // print "K"
        #10;
        assert(HEX0 === 7'b0001001) $display("[PASS] for displaying 'K'");
        else $error("[FAIL] to display 'K'");

        SW = 4'd14; // print nothing (blank)
        #10;
        assert(HEX0 === 7'b1111111) $display("[PASS] for displaying nothing");
        else $error("[FAIL] to display nothing");

        SW = 4'd15; // print nothing (blank)
        #10;
        assert(HEX0 === 7'b1111111) $display("[PASS] for displaying nothing");
        else $error("[FAIL] to display nothing");
        $stop;
     end
endmodule