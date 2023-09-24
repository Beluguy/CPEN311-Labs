module statemachine(input slow_clock, input resetb,
                    input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
                    output load_pcard1, output load_pcard2,output load_pcard3,
                    output load_dcard1, output load_dcard2, output load_dcard3,
                    output player_win_light, output dealer_win_light);

    // The code describing your state machine will go here.  Remember that
    // a state machine consists of next state logic, output logic, and the 
    // registers that hold the state.  You will want to review your notes from
    // CPEN 211 or equivalent if you have forgotten how to write a state machine.

    //1 (0) initial state (no cards dealt)
    //4,(1-4) states for dealing first 4 cards
    //1 (5) state for player getting third card
    //1 (6) state for dealer getting third card
    //1 (7) state for game end
    //8 states 0-7 -> 3 bits
    reg [3:0] state;
    wire [3:0] statewire;
    assign statewire = state;

    reg load_pcard1_reg;
    reg load_pcard2_reg;
    reg load_pcard3_reg;
    reg load_dcard1_reg;
    reg load_dcard2_reg;
    reg load_dcard3_reg;
    assign load_pcard1 = load_pcard1_reg;
    assign load_pcard2 = load_pcard2_reg;
    assign load_pcard3 = load_pcard3_reg;
    assign load_dcard1 = load_dcard1_reg;
    assign load_dcard2 = load_dcard2_reg;
    assign load_dcard3 = load_dcard3_reg;

    reg p_win;
    reg d_win;
    assign player_win_light = p_win;
    assign dealer_win_light = d_win;

    always_comb begin
        case(statewire)
            3'd1: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} = 6'b100000;
            3'd2: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} = 6'b000100;
            3'd3: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} = 6'b010000;
            3'd4: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} = 6'b000010;
            3'd5: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} = 6'b001000;
            3'd6: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} = 6'b000001;
            default: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} = 6'b000000;
        endcase

        if (statewire == 3'd7 && (pscore > dscore)) {p_win,d_win} = 2'b10;
        else if (statewire == 3'd7 && (pscore < dscore)) {p_win,d_win} = 2'b01;
        else {p_win,d_win} = 2'b00;
    end

    always_ff @(posedge slow_clock) begin
        if(resetb == 1'd0) begin
            state <= 3'd0;   // reset
        end

        else if(statewire < 3'd4) state <= statewire + 3'b001;  // state go from 0 -> 4

        else if((statewire == 3'd4) && ((dscore >= 4'd8) || (pscore >= 4'd8))) state <= 3'd7;  // if pscore or dscore reach >= 8, then state go from 4 -> 7 (natural)
        else if((statewire == 3'd4) && (pscore <= 4'd5)) state <= 3'd5;				           // if pscore is <= 4 -> 5 (pscore <= 5)
        else if((statewire == 3'd4) && (pscore > 4'd5) && (dscore <= 4'd5)) state <= 3'd6;     // 4 -> 6 (pscore > 5 and dscore <= 5)
        else if((statewire == 3'd4) && (pscore > 4'd5) && (dscore > 4'd5)) state <= 3'd7;      // 4- > 7 (pscore > 5 and dscore > 5)

        else if((statewire == 3'd5) && (dscore == 4'd7)) state <= 3'd7;							// 5 -> 7 (dscore  = 7)
        else if((statewire == 3'd5) && (dscore == 4'd6) && (pcard3 >= 4'd6) && (pcard3 <= 4'd7)) state <= 3'd6;    // 5 -> 6 (dscore = 6, pcard3 between 6,7)
        else if((statewire == 3'd5) && (dscore == 4'd6) && ~((pcard3 >= 4'd6) && (pcard3 <= 4'd7))) state <= 3'd7; // 5 -> 7 (dscore = 6, pcard3 not between 6,7)
        else if((statewire == 3'd5) && (dscore == 4'd5) && (pcard3 >= 4'd4) && (pcard3 <= 4'd7)) state <= 3'd6;    // 5 -> 6 (dscore = 5, pcard3 between 4,7)
        else if((statewire == 3'd5) && (dscore == 4'd5) && ~((pcard3 >= 4'd4) && (pcard3 <= 4'd7))) state <= 3'd7; // 5 -> 7 (dscore = 5, pcard3 not between 4,7)
        else if((statewire == 3'd5) && (dscore == 4'd4) && (pcard3 >= 4'd2) && (pcard3 <= 4'd7)) state <= 3'd6;    // 5 -> 6 (dscore = 4, pcard3 between 2,7)
        else if((statewire == 3'd5) && (dscore == 4'd4) && ~((pcard3 >= 4'd2) && (pcard3 <= 4'd7))) state <= 3'd7; // 5 -> 7 (dscore = 4, pcard3 not between 2,7)
        else if((statewire == 3'd5) && (dscore == 4'd3) && (pcard3 != 4'd8)) state <= 3'd6;    // 5 -> 6 (dscore = 3, pcard3 not 8)
        else if((statewire == 3'd5) && (dscore == 4'd3) && ~(pcard3 != 4'd8)) state <= 3'd7;   // 5 -> 7 (dscore = 3, pcard3 is 8)
        else if((statewire == 3'd5) && (dscore <= 4'd2)) state <= 3'd6;			 // 5 -> 6 (dscore <= 2)

        else if(statewire == 3'd6) state <= 3'd7;		    // 6 -> 7
    end
endmodule