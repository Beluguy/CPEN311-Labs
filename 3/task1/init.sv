module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

// your code here

integer i,j;
reg initialized;

always_comb begin
	addr = i;
	wrdata = i;
end

always_ff @(posedge(clk), negedge(rst_n)) begin
	if(!rst_n) begin
		initialized <= 1'b0;
		rdy <= 1'b1;
       		wren <= 1'b0;             
       		i <= 1'd0; 
	end
	else if(en && rdy && !initialized) begin
		rdy <= 1'b0;
		wren <= 1'b1;
	end
	else if(wren && (i < 255)) begin
		i <= i + 1;
	end
	else if(i == 255) begin
		rdy <= 1'b1;
		initialized <= 1'b1;
		wren <= 1'b0;
	end
	else begin
		wren <= 1'b0;
		rdy <= 1'b1;
	end
end

endmodule: init
