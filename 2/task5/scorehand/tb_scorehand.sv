module tb_scorehand();
// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").
    reg [3:0] card1;
    reg [3:0] card2;
    reg [3:0] card3;
    wire [3:0] total;

    reg err_reg;
    assign err = err_reg;
    scorehand dut (.card1(card1), .card2(card2), .card3(card3),.total(total));

    initial begin
        err_reg = 1'b0; //initialize err = 1'b0

        card1 = 4'd0;   //blank
        card2 = 4'd0;   //blank
        card3 = 4'd0;   //blank
        #1;
        if(total != 4'd0) begin
            $display("Error: total is %d, expected total for card1:%d, card2:%d, and card3:%d is %d", total, card1, card2, card3, 4'd0 );
            err_reg = 1'd1;
        end
        else begin
            $display("total is %d, which is correct for card1:%d, card2:%d, and card3:%d", total, card1, card2, card3);
        end
        #1;

        //first card1
        card1 = 4'd1;   //ace
        card2 = 4'd0;   //blank
        card3 = 4'd0;   //blank
        #1;
        if(total != 4'd1) begin
            $display("Error: total is %d, expected total for card1:%d, card2:%d, and card3:%d is %d", total, card1, card2, card3, 4'd1);
            err_reg = 1'd1;
        end
        else begin
            $display("total is %d, which is correct for card1:%d, card2:%d, and card3:%d", total, card1, card2, card3);
        end
        #1;
        
        card1 = 4'd9;   //9
        card2 = 4'd0;   //blank
        card3 = 4'd0;   //blank
        #1;
        if(total != 4'd9) begin
            $display("Error: total is %d, expected total for card1:%d, card2:%d, and card3:%d is %d", total, card1, card2, card3, 4'd9);
            err_reg = 1'd1;
        end
        else begin
            $display("total is %d, which is correct for card1:%d, card2:%d, and card3:%d", total, card1, card2, card3);
        end
        #1;

        card1 = 4'd10;  //10
        card2 = 4'd0;   //blank
        card3 = 4'd0;   //blank
        #1;
        if(total != 4'd0) begin
            $display("Error: total is %d, expected total for card1:%d, card2:%d, and card3:%d is %d", total, card1, card2, card3, 4'd0);
            err_reg = 1'd1;
        end
        else begin
            $display("total is %d, which is correct for card1:%d, card2:%d, and card3:%d", total, card1, card2, card3);
        end
        #1;

        card1 = 4'd11;  //jack
        card2 = 4'd0;   //blank
        card3 = 4'd0;   //blank
        #1;
        if(total != 4'd0) begin
            $display("Error: total is %d, expected total for card1:%d, card2:%d, and card3:%d is %d", total, card1, card2, card3, 4'd0);
            err_reg = 1'd1;
        end
        else begin
            $display("total is %d, which is correct for card1:%d, card2:%d, and card3:%d", total, card1, card2, card3);
        end
        #1;

        card1 = 4'd12;  //queen
        card2 = 4'd0;   //blank
        card3 = 4'd0;   //blank
        #1;
        if(total != 4'd0) begin
            $display("Error: total is %d, expected total for card1:%d, card2:%d, and card3:%d is %d", total, card1, card2, card3, 4'd0);
            err_reg = 1'd1;
        end
        else begin
            $display("total is %d, which is correct for card1:%d, card2:%d, and card3:%d", total, card1, card2, card3);
        end
        #1;


        // now test card1 and card2
        card1 = 4'd2;   //2
        card2 = 4'd1;   //ace
        card3 = 4'd0;   //blank
        #1;
        if(total != 4'd3) begin
            $display("Error: total is %d, expected total for card1:%d, card2:%d, and card3:%d is %d", total, card1, card2, card3, 4'd3);
            err_reg = 1'd1;
        end
        else begin
            $display("total is %d, which is correct for card1:%d, card2:%d, and card3:%d", total, card1, card2, card3);
        end
        #1;

        card1 = 4'd3;   //3
        card2 = 4'd9;   //9
        card3 = 4'd0;   //blank
        #1;
        if(total != 4'd2) begin
            $display("Error: total is %d, expected total for card1:%d, card2:%d, and card3:%d is %d", total, card1, card2, card3, 4'd2);
            err_reg = 1'd1;
        end
        else begin
            $display("total is %d, which is correct for card1:%d, card2:%d, and card3:%d", total, card1, card2, card3);
        end
        #1;

        card1 = 4'd4;   //4
        card2 = 4'd10;  //10
        card3 = 4'd0;   //blank
        #1;
        if(total != 4'd4) begin
            $display("Error: total is %d, expected total for card1:%d, card2:%d, and card3:%d is %d", total, card1, card2, card3, 4'd4);
            err_reg = 1'd1;
        end
        else begin
            $display("total is %d, which is correct for card1:%d, card2:%d, and card3:%d", total, card1, card2, card3);
        end
        #1;

        card1 = 4'd5;   //5
        card2 = 4'd11;  //jack
        card3 = 4'd0;   //blank
        #1;
        if(total != 4'd5) begin
            $display("Error: total is %d, expected total for card1:%d, card2:%d, and card3:%d is %d", total, card1, card2, card3, 4'd5);
            err_reg = 1'd1;
        end
        else begin
            $display("total is %d, which is correct for card1:%d, card2:%d, and card3:%d", total, card1, card2, card3);
        end
        #1;

        card1 = 4'd6;   //6
        card2 = 4'd0;   //king
        card3 = 4'd0;   //blank
        #1;
        if(total != 4'd6) begin
            $display("Error: total is %d, expected total for card1:%d, card2:%d, and card3:%d is %d", total, card1, card2, card3, 4'd6);
            err_reg = 1'd1;
        end
        else begin
            $display("total is %d, which is correct for card1:%d, card2:%d, and card3:%d", total, card1, card2, card3);
        end
        #1;


        //now test all three card



        

        if(err_reg != 1'd0) begin
            $display("Display errors found. Review above results");
        end
        else begin
            $display("No errors found. Scorehand is working as intended");
        end
        $stop;
    end						
endmodule

