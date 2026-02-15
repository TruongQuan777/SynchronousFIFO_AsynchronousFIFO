module g2b_converter #(parameter DATA_WIDTH=8,parameter PTR_WIDTH=$clog2(DATA_WIDTH))(
  input  wire [DATA_WIDTH-1:0] gray_in,
  output reg  [DATA_WIDTH-1:0] binary_out
);
    integer i;
    always @(*) 
      begin
        binary_out[DATA_WIDTH-1] = gray_in[DATA_WIDTH-1];
        for (i = DATA_WIDTH-2; i >= 0; i = i - 1) 
          begin
            binary_out[i] = binary_out[i+1] ^ gray_in[i];
          end
      end
endmodule
