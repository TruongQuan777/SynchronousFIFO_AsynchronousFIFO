// Code your design here
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
  reg [PTR_WIDTH+1:0] count;
  integer i;
  assign full=(count==FIFO_WIDTH);
  assign empty=(count==0);
  
  always @(posedge clk)
    begin
      if(!rst_n)
        begin
          for (i = 0; i <=FIFO_WIDTH-1 ; i = i + 1)
            fifo[i] <= 0;
          data_out<=0;
          count<=0;
          w_ptr<=0;
          r_ptr<=0;
        end
      else
        begin
          if(w_en==1 && r_en==0)
            begin
              if(full==0)
                begin
                  fifo[w_ptr]<=data_in;
                  count<=count+1;
                  w_ptr<=(w_ptr==FIFO_WIDTH-1)?0:w_ptr+1;
                  r_ptr<=r_ptr;
                end
               else;
            end
          else if(w_en==0 && r_en==1)
            begin
              if(empty==0)
                begin
                  data_out<=fifo[r_ptr];
                  count<=count-1;
                  w_ptr<=w_ptr;
                  r_ptr<=(r_ptr==FIFO_WIDTH-1)?0:r_ptr+1;
                end
              else;
            end
          else if(w_en==1 && r_en==1)
            begin
              if(!empty && !full)
                begin
                 fifo[w_ptr]<=data_in;
                 data_out<=fifo[r_ptr];
                 count<=count;
                 w_ptr<=(w_ptr==FIFO_WIDTH-1)?0:w_ptr+1;
                 r_ptr<=(r_ptr==FIFO_WIDTH-1)?0:r_ptr+1;
                end
              else if(empty && !full)
                begin
                  fifo[w_ptr]<=data_in;
                  data_out<=data_out;
                  count<=count+1;
                  w_ptr<=(w_ptr==FIFO_WIDTH-1)?0:w_ptr+1;
                  r_ptr<=r_ptr;
                end
              else
                begin
                  fifo[w_ptr]<=fifo[w_ptr];
                  data_out<=fifo[r_ptr];
                  count<=count-1;
                  w_ptr<=w_ptr;
                  r_ptr<=(r_ptr==FIFO_WIDTH-1)?0:r_ptr+1;
                end
            end
          else;
        end
    end
endmodule
  
