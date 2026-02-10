module sync_fifo #(parameter FIFO_WIDTH=8, DATA_WIDTH=8)(
  input clk,
  input rst_n,
  input w_en,
  input [DATA_WIDTH-1:0] data_in,
  input r_en,
  
  output reg [DATA_WIDTH-1:0] data_out,
  output full,
  output empty
);
  parameter PTR_WIDTH=$clog2(FIFO_WIDTH);
  reg [PTR_WIDTH:0] w_ptr;
  reg [PTR_WIDTH:0] r_ptr;
  reg [DATA_WIDTH-1:0] fifo[0:FIFO_WIDTH-1];
  integer i;

  //Output logic
  assign full=(w_ptr[PTR_WIDTH-1:0]==r_ptr[PTR_WIDTH-1:0] && w_ptr[PTR_WIDTH]!=r_ptr[PTR_WIDTH]);
  assign empty=(w_ptr==r_ptr);

  //Memory operation
  always @(posedge clk)
    begin
      if(~rst_n)
        begin
          for(i=0;  i<=FIFO_WIDTH-1;i++)
            begin
              fifo[i]<=0;
            end
          w_ptr<=0;
          r_ptr<=0;
        end
      else
        begin
          if(w_en &&  ~r_en)
            begin
              if(~full)
                begin
                  fifo[w_ptr[PTR_WIDTH-1:0]]<=data_in;
                  w_ptr<=w_ptr+1;
                end
            end
          if(r_en && ~w_en)
            begin
              if(~empty)
                begin
                  data_out<=fifo[r_ptr[PTR_WIDTH-1:0]];
                  r_ptr<=r_ptr+1;
                end
            end
          if(r_en  &&  w_en)
            begin
              if(empty)
                begin
                  fifo[w_ptr[PTR_WIDTH-1:0]]<=data_in;
                  w_ptr<=w_ptr+1;
                end
              else if(full)
                begin
                  data_out<=fifo[r_ptr[PTR_WIDTH-1:0]];
                  r_ptr<=r_ptr+1;
                end
              else
                begin
                  data_out<=fifo[r_ptr[PTR_WIDTH-1:0]];
                  fifo[w_ptr[PTR_WIDTH-1:0]]<=data_in;
                  w_ptr<=w_ptr+1;
                  r_ptr<=r_ptr+1;
                end
            end
        end
    end
  
endmodule
  
