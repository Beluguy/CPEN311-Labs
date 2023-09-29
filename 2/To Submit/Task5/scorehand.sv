module scorehand(input [3:0] card1, input [3:0] card2, input [3:0] card3, output [3:0] total);
// The code describing scorehand will go here.  Remember this is a combinational
// block. The function is described in the handout.  Be sure to review the section
// on representing numbers in the lecture notes.
    reg [3:0] total_reg;
    assign total = total_reg;
    reg [5:0] value1;
    reg [5:0] value2;
    reg [5:0] value3;

    always_comb begin
        if ((4'd1 <= card1[3:0]) && (card1[3:0] <= 4'd9))       //if the card i between 1 and 9 (ace and 9)
            value1[5:0] = card1[3:0];                           //then assign its value as the face value
        else                                                   //else assign its value as 0 (such as king and queen)
            value1[5:0] = 4'd0;

        if ((4'd1 <= card2[3:0]) && (card2[3:0] <= 4'd9))
            value2[5:0] = card2[3:0];
        else 
            value2[5:0] = 4'd0;

        if ((4'd1 <= card3[3:0]) && (card3[3:0] <= 4'd9))
            value3[5:0] = card3[3:0];
        else 
            value3[5:0] = 4'd0;

        total_reg = (value1[5:0] + value2[5:0] + value3[5:0]) % 4'd10;
    end 
endmodule