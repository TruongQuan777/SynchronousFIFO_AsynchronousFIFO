module FIFO #(DATA_WIDTH=8, FIFO_WIDTH=8, PTR_WIDTH=$clog2(DATA_WIDTH))(
  input[DATA_WIDTH-1:0] wdata,
  input[PTR_WIDTH-1:0] wptr,rptr,
  input wclk,w_en,full
  input rclk,r_en,empty,
  output rdata
);
  reg[DATA_WIDTH-1:0] mem[FIFO_WIDTH-1:0]
  always@(posedge wclk) begin
    if(w_en & !full) begin
      mem[wptr[PTR_WIDTH-1:0]] <= data_in;
    end
  end
  /*
  always@(posedge rclk) begin
    if(r_en & !empty) begin
      data_out <= mem[rptr[PTR_WIDTH-1:0]];
    end
  end
  */
  assign data_out = mem[rptr[PTR_WIDTH-1:0]];
endmodule
