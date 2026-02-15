module wptr_handler #(parameter DATA_WIDTH=8, parameter FIFO_WIDTH=8, parameter PTR_WIDTH=$clog2(FIFO_WIDTH)) (
  input wclk, wrst_n, w_en,
  input [PTR_WIDTH:0] rptr_sync,
  output reg [PTR_WIDTH:0] wptr,
  output reg full
);

   
  wire full;
  
  always@(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) begin
      wptr <= 0; // set default value
    end
    else begin
      wptr<=wptr+(w_en & !full); // incr binary write pointer
    end
  end
  

  assign full=(w_ptr[PTR_WIDTH-1:0]==r_ptr_sync[PTR_WIDTH-1:0] && w_ptr[PTR_WIDTH]!=r_ptr_sync[PTR_WIDTH]);

endmodule
