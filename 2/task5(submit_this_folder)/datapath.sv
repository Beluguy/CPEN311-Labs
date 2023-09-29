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

    // instantiation of the 6 reg that store the player's and dealer's card
    reg [3:0] pcard1_reg;
    reg [3:0] pcard2_reg;
    reg [3:0] pcard3_reg;
    reg [3:0] dcard1_reg;
    reg [3:0] dcard2_reg;
    reg [3:0] dcard3_reg;

    assign pcard3_out = pcard3_reg;

    // instantiation of the 6 block that drives the HEX display
    card7seg p1 (.SW(pcard1_reg), .HEX0(HEX0));
    card7seg p2 (.SW(pcard2_reg), .HEX0(HEX1));
    card7seg p3 (.SW(pcard3_reg), .HEX0(HEX2));
    card7seg d1 (.SW(dcard1_reg), .HEX0(HEX3));
    card7seg d2 (.SW(dcard2_reg), .HEX0(HEX4));
    card7seg d3 (.SW(dcard3_reg), .HEX0(HEX5));

    // instantiation of the 2 blocks that computes the value of cards from players and dealers respectively
    scorehand shp(.card1(pcard1_reg), .card2(pcard2_reg), .card3(pcard3_reg), .total(pscore_out));
    scorehand shd(.card1(dcard1_reg), .card2(dcard2_reg), .card3(dcard3_reg), .total(dscore_out));

    // instantiation of the block that deal random cards to player and dealer
    wire [3:0] new_card;
    dealcard dc(.clock(fast_clock), .resetb(resetb), .new_card(new_card));

    // for the registers
    always_ff @(posedge slow_clock) begin
        if (resetb == 1'd0) begin
            pcard1_reg <= 4'd0;
            pcard2_reg <= 4'd0;
            pcard3_reg <= 4'd0;
            dcard1_reg <= 4'd0;
            dcard2_reg <= 4'd0;
            dcard3_reg <= 4'd0;
        end
        else begin
            case({load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3})
                6'b100000: pcard1_reg <= new_card;
                6'b010000: pcard2_reg <= new_card;
                6'b001000: pcard3_reg <= new_card;
                6'b000100: dcard1_reg <= new_card;
                6'b000010: dcard2_reg <= new_card;
                6'b000001: dcard3_reg <= new_card;
                default: begin
                    pcard1_reg <= pcard1_reg;
                    pcard2_reg <= pcard2_reg;
                    pcard3_reg <= pcard3_reg;
                    dcard1_reg <= dcard1_reg;
                    dcard2_reg <= dcard2_reg;
                    dcard3_reg <= dcard3_reg;
                end
            endcase 
        end 
    end
endmodule