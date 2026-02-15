module synchronizer #(parameter DATA_WIDTH=8, parameter FIFO_WIDTH=8, parameter PTR_WIDTH=$clog2(FIFO_WIDTH)) (
  input clk, rst_n, [DATA-WIDTH:0] d_in, 
  output reg [DATA_WIDTH:0] d_out
);
  reg [WIDTH:0] q1;
  always@(posedge clk) 
    begin
      if(!rst_n) 
        begin
        q1 <= 0;
        d_out <= 0;
        end
      else 
        begin
        q1 <= d_in;
        d_out <= q1;
    end
  end
endmodule
