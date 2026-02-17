`include "synchronizer.v"
`include "wptr_handler.v"
`include "rptr_handler.v"
`include "fifo_mem.v"

module async_fifo #(parameter DEPTH=8, DATA_WIDTH=8, parameter PTR_WIDTH = $clog2(DEPTH)) (
  input w_clk, wrst_n,
  input r_clk, rrst_n,
  input w_en, r_en,
  input [DATA_WIDTH-1:0] data_in,
  output reg [DATA_WIDTH-1:0] data_out,
  output reg full, empty
);
  reg [PTR_WIDTH:0] b_w_ptr, g_w_ptr, g_w_ptr_sync, b_w_ptr_sync;
  reg [PTR_WIDTH:0] b_r_ptr, g_r_ptr, g_r_ptr_sync, b_r_ptr_sync;

  b2g_converter #(PTR_WIDTH) w_b2g_converter(b_w_ptr,g_w_ptr);
  b2g_converter #(PTR_WIDTH) r_b2g_converter(b_r_ptr,g_r_ptr);
  g2b_converter #(PTR_WIDTH) w_g2b_converter(g_w_ptr_sync,b_w_ptr_sync);
  g2b_converter #(PTR_WIDTH) r_g2b_converter(g_r_ptr_sync,b_r_ptr_sync);
  
  synchronizer #(PTR_WIDTH) sync_wptr (r_clk, rrst_n, g_r_ptr, g_r_ptr_sync); //write pointer to read clock domain
  synchronizer #(PTR_WIDTH) sync_rptr (w_clk, wrst_n, g_w_ptr, g_w_ptr_sync); //read pointer to write clock domain 
  
  wptr_handler #(PTR_WIDTH) wptr_h(w_clk, wrst_n, w_en,b_r_ptr_sync,b_w_ptr,full);
  rptr_handler #(PTR_WIDTH) rptr_h(r_clk, rrst_n, r_en,b_w_ptr_sync,b_r_ptr, empty);
  fifo_mem fifom(data_in, b_w_ptr,b_r_ptr, w_clk, w_en, full, r_clk,r_en,empty);

endmodule
