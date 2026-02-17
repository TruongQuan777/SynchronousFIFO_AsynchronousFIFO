module rptr_handler #(parameter DATA_WIDTH=8, parameter FIFO_WIDTH=8, parameter PTR_WIDTH=$clog2(FIFO_WIDTH))(
  input r_clk, rrst_n, r_en,
  input [PTR_WIDTH:0] w_ptr_sync,
  output reg [PTR_WIDTH:0] r_ptr,
  output reg empty
);
  
  always@(posedge r_clk or negedge rrst_n) begin
    if(!rrst_n) 
      begin
        r_ptr <= 0;
      end
    else 
      r_ptr <= r_ptr+(r_en & !empty);
  end
  
  always@(posedge r_clk or negedge rrst_n) 
    begin
      if(!rrst_n) empty <= 1;
      else        empty <= w_ptr_sync == r_ptr+(r_en & !empty);
    end
endmodule
