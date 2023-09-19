module card7seg(input [3:0] SW, output [6:0] HEX0);
		
   always_comb begin
      case (SW)
         4'd0: HEX0 = 7'b1111111;   //print nothing
         4'd1: HEX0 = 7'b0001000;   //print 'A'
         4'd2: HEX0 = 7'b0100100;   //print '2'
         4'd3: HEX0 = 7'b0110000;   //print '3'
         4'd4: HEX0 = 7'b0011001;   //print '4'
         4'd5: HEX0 = 7'b0010010;   //print '5'
         4'd6: HEX0 = 7'b0000010;   //print '6'
         4'd7: HEX0 = 7'b1111000;   //print '7'
         4'd8: HEX0 = 7'b0000000;   //print '8'
         4'd9: HEX0 = 7'b0010000;   //print '9'
         4'd10: HEX0 = 7'b1000000;  //print '0'
         4'd11: HEX0 = 7'b1110000;  //print 'j'
         4'd12: HEX0 = 7'b0001100;  //print 'q'
         4'd13: HEX0 = 7'b0001001;  //print 'k'
         4'd14: HEX0 = 7'b1111111;  //print nothing
         4'd15: HEX0 = 7'b1111111;  //print nothing
      endcase
   end
endmodule

