module fifo_mem #(parameter DATA_WIDTH=8, parameter FIFO_WIDTH=8, parameter PTR_WIDTH=$clog2(FIFO_WIDTH))(
  input[DATA_WIDTH-1:0] data_in,
  input[PTR_WIDTH:0] w_ptr,r_ptr,
  input w_clk,w_en,full,
  input r_clk,r_en,empty,
  output data_out
);
  reg[DATA_WIDTH-1:0] mem[FIFO_WIDTH-1:0]
  always@(posedge w_clk) begin
    if(w_en & !full) begin
      mem[w_ptr[PTR_WIDTH-1:0]] <= data_in;
    end
  end
  /*
  always@(posedge r_clk) begin
    if(r_en & !empty) begin
      data_out <= mem[r_ptr[PTR_WIDTH-1:0]];
    end
  end
  */
  assign data_out = mem[r_ptr[PTR_WIDTH-1:0]];
endmodule
