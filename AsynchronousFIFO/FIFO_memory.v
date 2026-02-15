module FIFO #(DATA_WIDTH=8, FIFO_WIDTH=8, PTR_WIDTH=$clog2(DATA_WIDTH))(
  input[DATA_WIDTH-1:0] wdata,
  input[PTR_WIDTH-1:0] wptr,rptr,
  input wclk,wen,full
  input rclk,ren,empty,
  output rdata
);
endmodule
