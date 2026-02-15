module FIFO #(DATA_WIDTH=8, FIFO_WIDTH=8, PTR_WIDTH=$clog2(DATA_WIDTH))(
  input[DATA_WIDTH-1:0] wdata,
  input[PTR_WIDTH-1:0] wptr,rptr,
  input wclk,wen,full
  input rclk,ren,empty,
  output rdata
);
  reg[DATA_WIDTH-1:0] mem[FIFO_WIDTH-1:0]
endmodule
