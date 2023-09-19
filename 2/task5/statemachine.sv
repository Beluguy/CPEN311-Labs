module statemachine(input slow_clock, input resetb,
                    input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
                    output load_pcard1, output load_pcard2,output load_pcard3,
                    output load_dcard1, output load_dcard2, output load_dcard3,
                    output player_win_light, output dealer_win_light);

// The code describing your state machine will go here.  Remember that
// a state machine consists of next state logic, output logic, and the 
// registers that hold the state.  You will want to review your notes from
// CPEN 211 or equivalent if you have forgotten how to write a state machine.

//1 initial state (no cards dealt)
//4 states for dealing first 4 cards
//1 state for player getting third card
//1 state for dealer getting third card
//1 state for game end
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

always_ff @(posedge slow_clock) begin
if(resetb == 1'b0) begin
state <= 3'b000;   // reset
p_win <= 1'b0;
d_win <= 1'b0;
end

else if(statewire < 3'b100) state <= statewire + 3'b001;  // 0 -> 4

else if((statewire == 3'b100) && ((dscore >= 4'b1000) || (pscore >= 4'b1000))) state <= 3'b111;  // 4 -> 7 (natural)
else if((statewire == 3'b100) && (pscore <= 4'b0101)) state <= 3'b101;				 // 4 -> 5 (pscore <= 5)
else if((statewire == 3'b100) && (pscore > 4'b0101) && (dscore <= 4'b0101)) state <= 3'b110;     // 4 -> 6 (pscore > 5 and dscore <= 5)
else if((statewire == 3'b100) && (pscore > 4'b0101) && (dscore > 4'b0101)) state <= 3'b111;      // 4- > 7 (pscore > 5 and dscore > 5)

else if((statewire == 3'b101) && (dscore == 4'b0111)) state <= 3'b111;							// 5 -> 7 (dscore  = 7)
else if((statewire == 3'b101) && (dscore == 4'b0110) && (pcard3 >= 4'b0110) && (pcard3 <= 4'b0111)) state <= 3'b110;    // 5 -> 6
else if((statewire == 3'b101) && (dscore == 4'b0101) && (pcard3 >= 4'b0100) && (pcard3 <= 4'b0111)) state <= 3'b110;    // 5 -> 6
else if((statewire == 3'b101) && (dscore == 4'b0100) && (pcard3 >= 4'b0010) && (pcard3 <= 4'b0111)) state <= 3'b110;    // 5 -> 6
else if((statewire == 3'b101) && (dscore == 4'b0011) && (pcard3 >= 4'b0010) && (pcard3 != 4'b1000)) state <= 3'b110;    // 5 -> 6
else if((statewire == 3'b101) && (dscore <= 4'b0010)) state <= 3'b110;						        // 5 -> 6

else if(statewire == 3'b110) state <= 3'b111;		    // 6 -> 7

else if (statewire == 3'b111 && (pscore > dscore)) p_win <= 1'b1;
else if (statewire == 3'b111 && (pscore < dscore)) d_win <= 1'b1;

case(statewire)
3'b001: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} <= 6'b100000;
3'b010: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} <= 6'b000100;
3'b011: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} <= 6'b010000;
3'b100: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} <= 6'b000010;
3'b101: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} <= 6'b001000;
3'b110: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} <= 6'b000001;
default: {load_pcard1_reg,load_pcard2_reg,load_pcard3_reg,load_dcard1_reg,load_dcard2_reg,load_dcard3_reg} <= 6'b000000;
endcase



end

endmodule

