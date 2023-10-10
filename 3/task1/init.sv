module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

integer i,j;
reg initialized;

always_ff @(posedge(!rst_n)) begin
        initialized <= 1'b0;
end

always_ff @(posedge(clk)) begin
        if(rdy && en && !initialized) begin
		rdy <= 1'b0;
                wren <= 1'b1;
                for(i=0; i<256; i = i+1) begin
                     addr <= i;
                     wrdata <= i;
                end   
                initialized <= 1'b1;
	        rdy <= 1'b1;
                wren <= 1'b0;
	end
        else begin
                rdy <= 1'b1;
                wren <= 1'b0;
	end
end

endmodule: init