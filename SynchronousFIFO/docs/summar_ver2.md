Same logic as version 1, but we don't use the count variable. Instead, we increase the size of w_ptr and r_ptr 1 more bit and implement the full, empty logic as below:
```verilog
full=(w_ptr[PTR_WIDTH-1:0]==r_ptr[PTR_WIDTH-1:0] && w_ptr[PTR_WIDTH]!=r_ptr[PTR_WIDTH]);
empty=(w_ptr==r_ptr);
```
