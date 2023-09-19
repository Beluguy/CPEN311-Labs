module scorehand(input [3:0] card1, input [3:0] card2, input [3:0] card3, output [3:0] total);

// The code describing scorehand will go here.  Remember this is a combinational
// block. The function is described in the handout.  Be sure to review the section
// on representing numbers in the lecture notes.
    reg [3:0 ]output_reg;
    assign output = output_reg;

    always_comb begin
        output_reg = (card1[3:0] + card2[3:0] + card3[3:0]) mod 10;
    end 
endmodule

