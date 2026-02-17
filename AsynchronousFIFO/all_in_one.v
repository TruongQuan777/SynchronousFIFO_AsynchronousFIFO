module async_fifo #(parameter DATA_WIDTH=8, parameter FIFO_WIDTH=8, parameter PTR_WIDTH=$clog2(FIFO_WIDTH)) (
  input w_clk, wrst_n,
  input r_clk, rrst_n,
  input w_en, r_en,
  input [DATA_WIDTH-1:0] data_in,
  output [DATA_WIDTH-1:0] data_out,
  output full, empty
);
  wire [PTR_WIDTH:0] b_w_ptr, g_w_ptr, g_w_ptr_sync, b_w_ptr_sync;
  wire [PTR_WIDTH:0] b_r_ptr, g_r_ptr, g_r_ptr_sync, b_r_ptr_sync;

  b2g_converter #(.PTR_WIDTH(PTR_WIDTH)) w_b2g_converter(b_w_ptr,g_w_ptr);
  b2g_converter #(.PTR_WIDTH(PTR_WIDTH)) r_b2g_converter(b_r_ptr,g_r_ptr);
  g2b_converter #(.PTR_WIDTH(PTR_WIDTH)) w_g2b_converter(g_w_ptr_sync,b_w_ptr_sync);
  g2b_converter #(.PTR_WIDTH(PTR_WIDTH)) r_g2b_converter(g_r_ptr_sync,b_r_ptr_sync);
  
  synchronizer #(.PTR_WIDTH(PTR_WIDTH)) sync_wptr (r_clk, rrst_n, g_r_ptr, g_r_ptr_sync); //write pointer to read clock domain
  synchronizer #(.PTR_WIDTH(PTR_WIDTH)) sync_rptr (w_clk, wrst_n, g_w_ptr, g_w_ptr_sync); //read pointer to write clock domain 
  
  wptr_handler #(.PTR_WIDTH(PTR_WIDTH)) wptr_h(w_clk, wrst_n, w_en,b_r_ptr_sync,b_w_ptr,full);
  rptr_handler #(.PTR_WIDTH(PTR_WIDTH)) rptr_h(r_clk, rrst_n, r_en,b_w_ptr_sync,b_r_ptr, empty);
  fifo_mem fifom(data_in, b_w_ptr,b_r_ptr, w_clk, w_en, full, r_clk,r_en,empty,data_out);
endmodule
module fifo_mem #(parameter DATA_WIDTH=8, parameter FIFO_WIDTH=8, parameter PTR_WIDTH=$clog2(FIFO_WIDTH))(
  input[DATA_WIDTH-1:0] data_in,
  input[PTR_WIDTH:0] w_ptr,r_ptr,
  input w_clk,w_en,full,
  input r_clk,r_en,empty,
  output[DATA_WIDTH-1:0] data_out
);
  reg[DATA_WIDTH-1:0] mem[FIFO_WIDTH-1:0];
  always@(posedge w_clk) 
    begin
      if(w_en & !full) mem[w_ptr[PTR_WIDTH-1:0]] <= data_in;
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
module synchronizer #(parameter FIFO_WIDTH=8, parameter PTR_WIDTH=$clog2(FIFO_WIDTH)) (
  input clk, rst_n, [PTR_WIDTH:0] d_in, 
  output reg [PTR_WIDTH:0] d_out
);
  reg [PTR_WIDTH:0] q1;
  always@(posedge clk) 
    begin
      if(!rst_n) 
        begin
        q1 <= 0;
        d_out <= 0;
        end
      else 
        begin
        q1 <= d_in;
        d_out <= q1;
    end
  end
endmodule
module b2g_converter #(parameter FIFO_WIDTH=8, parameter PTR_WIDTH=$clog2(FIFO_WIDTH))(
    input  wire [PTR_WIDTH:0] binary_in,
    output wire [PTR_WIDTH:0] gray_out
);

    // The Gray code is calculated by XORing the binary 
    // number with itself shifted right by one position.
    assign gray_out = binary_in ^ (binary_in >> 1);

endmodule
module g2b_converter #(parameter FIFO_WIDTH=8, parameter PTR_WIDTH=$clog2(FIFO_WIDTH))(
  input  wire [PTR_WIDTH:0] gray_in,
  output reg  [PTR_WIDTH:0] binary_out
);
    integer i;
    always @(*) 
      begin
        binary_out[PTR_WIDTH] = gray_in[PTR_WIDTH];
        for (i = PTR_WIDTH-1; i >= 0; i = i - 1) 
          begin
            binary_out[i] = binary_out[i+1] ^ gray_in[i];
          end
      end
endmodule
