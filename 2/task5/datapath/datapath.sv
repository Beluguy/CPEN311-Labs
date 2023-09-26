// datapath connect everything and keep track of scores
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

    assign pcard3_out = pcard3_reg;

    // instantiation of the 6 reg that store the player's and dealer's card
    reg [3:0] pcard1_reg;
    reg [3:0] pcard2_reg;
    reg [3:0] pcard3_reg;
    reg [3:0] dcard1_reg;
    reg [3:0] dcard2_reg;
    reg [3:0] dcard3_reg;

    // instantiation of the 6 block that drives the HEX display
    card7seg c1 (.SW(pcard1_reg), .HEX0(HEX0));
    card7seg c2 (.SW(pcard2_reg), .HEX0(HEX1));
    card7seg c3 (.SW(pcard3_reg), .HEX0(HEX2));
    card7seg c4 (.SW(dcard4_reg), .HEX0(HEX3));
    card7seg c5 (.SW(dcard5_reg), .HEX0(HEX4));
    card7seg c6 (.SW(dcard6_reg), .HEX0(HEX5));

    // instantiation of the 2 blocks that computes the value of cards from players and dealers respectively
    scorehand shp(.card1(pcard1_reg), .card2(pcard2_reg), .card3(pcard3_reg), .total(pscore_out));
    scorehand shd(.card1(dcard1_reg), .card2(dcard2_reg), .card3(dcard3_reg), .total(dscore_out));

    // instantiation of the block that deal random cards to player and dealer
    wire [3:0] new_card;
    dealcard dc(.clock(fast_clock), .resetb(resetb), .new_card(new_card));

    // for the registers
    always_ff @(posedge slow_clock) begin
        if (load_pcard1 == 1 && resetb != 0) pcard1_reg <= new_card;
        else if (load_pcard2 == 1 && resetb != 0) pcard2_reg <= new_card;
        else if (load_pcard3 == 1 && resetb != 0) pcard3_reg <= new_card;
        else if (load_dcard1 == 1 && resetb != 0) dcard1_reg <= new_card;
        else if (load_dcard2 == 1 && resetb != 0) dcard2_reg <= new_card;
        else if (load_dcard3 == 1 && resetb != 0) dcard3_reg <= new_card;
    end 
endmodule