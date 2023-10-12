module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

// your code here

integer i,j;
reg initialized;


always_ff @(posedge(!rst_n)) begin
        initialized <= 1'b0;
	rdy <= 1'b1;
        wren <= 1'b0;              
        i <= 1'd0;  
end

always_ff @(posedge(clk)) begin
       if(en && rdy && (i == 1'd0) && !initialized) begin
                rdy <= 1'b0;
	        wren <= 1'b1;
		i <= i + 1;
       end
       else if((i > 0) && (i <= 256) && startcyc) begin
		rdy <= 1'b0;
		wren <= 1'b1;
		addr <= i;
		wrdata <= i;
		i <= i + 1;
       end
       else if(i > 256) begin
		rdy <= 1'b1;
		wren <= 1'b0;
		addr <= 1'd0;
		wrdata <= 1'd0;
		i <= i;
		initialized <= 1'b1;
       end
       else begin
		rdy <= 1'b1;
	        wren <= 1'b0;
		addr <= 1'd0;
		wrdata <= 1'd0;
		i <= 0;
       end
end

endmodule: init
