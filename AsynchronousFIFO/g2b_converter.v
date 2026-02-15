module g2b_converter #(parameter FIFO_WIDTH=8, parameter PTR_WIDTH=$clog2(FIFO_WIDTH))(
  input  wire [PTR_WIDTH:0] gray_in,
  output reg  [PTR_WIDTH:0] binary_out
);
    integer i;
    always @(*) 
      begin
        binary_out[PTR_WIDTH] = gray_in[PTR_WIDTH];
        for (i = PTR_WIDTH-1; i >= 0; i = i - 1) 
          begin
            binary_out[i] = binary_out[i+1] ^ gray_in[i];
          end
      end
endmodule
