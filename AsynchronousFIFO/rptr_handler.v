module rptr_handler #(parameter DATA_WIDTH=8, parameter FIFO_WIDTH=8, parameter PTR_WIDTH=$clog2(FIFO_WIDTH))(
  input rclk, rrst_n, r_en,
  input [PTR_WIDTH:0] wptr_sync,
  output reg [PTR_WIDTH:0] rptr,
  output reg empty
);
  
  always@(posedge rclk or negedge rrst_n) begin
    if(!rrst_n) 
      begin
        b_rptr <= 0;
      end
    else 
      begin
        b_rptr <= b_rptr+(r_en & !empty);;
      end
  end
  
  always@(posedge rclk or negedge rrst_n) 
    begin
      if(!rrst_n) empty <= 1;
      else        empty <= b_wptr_sync == b_rptr+(r_en & !empty);
    end
endmodule
