//
`timescale 1 ps / 1 ps
module datapath(input slow_clock, input fast_clock, input resetb,
                input load_pcard1, input load_pcard2, input load_pcard3,
                input load_dcard1, input load_dcard2, input load_dcard3,
                output [3:0] pcard3_out,
                output [3:0] pscore_out, output [3:0] dscore_out,
                output[6:0] HEX5, output[6:0] HEX4, output[6:0] HEX3,
                output[6:0] HEX2, output[6:0] HEX1, output[6:0] HEX0);
						
    // The code describing your datapath will go here.  Your datapath 
    // will hierarchically instantiate six card7seg blocks, two scorehand
    // blocks, and a dealcard block.  The registers may either be instatiated
    // or included as sequential always blocks directly in this file.
    //
    // Follow the block diagram in the Lab 1 handout closely as you write this code.

    reg pcard1_reg;
    reg pcard2_reg;
    reg pcard3_reg;
    reg dcard1_reg;
    reg dcard2_reg;
    reg dcard3_reg;

    card7seg c1 (, [6:0]HEX1);
    card7seg c2 ();
    card7seg c3 ();
    card7seg c4 ();
    card7seg c5 ();
    card7seg c6 ();

    scorehand sh1();
    scorehand sh2();

    dealcard dc(.clock(fast_clock), .resetb(resetb), .new_card());


    always_comb



endmodule

