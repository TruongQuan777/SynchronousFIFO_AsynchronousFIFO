module wptr_handler #(parameter DATA_WIDTH=8, parameter FIFO_WIDTH=8, parameter PTR_WIDTH=$clog2(FIFO_WIDTH)) (
  input w_clk, wrst_n, w_en,
  input [PTR_WIDTH:0] r_ptr_sync,
  output reg [PTR_WIDTH:0] w_ptr,
  output reg full
);

  
  always@(posedge w_clk or negedge wrst_n) begin
    if(!wrst_n) begin
      w_ptr <= 0; // set default value
    end
    else begin
      w_ptr<=w_ptr+(w_en & !full); // incr binary write pointer
    end
  end

  always@(posedge w_clk or negedge wrst_n) begin
    if(!wrst_n) full <= 0;
    else        full <= (w_ptr[PTR_WIDTH-1:0]==r_ptr_sync[PTR_WIDTH-1:0] && w_ptr[PTR_WIDTH]!=r_ptr_sync[PTR_WIDTH]);
  end

endmodule
