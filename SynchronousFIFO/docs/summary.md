# Synchronous FIFO Design
This repo contain the verilog code for a synchronous FIFO along with the testbench and timing report.
## Introduction
This project implements a synchronous First-In First-Out (FIFO) buffer using Verilog. The primary purpose of a FIFO is to temporarily store data while maintaining the order of arrival, making it a critical component in digital systems where data needs to be buffered between modules operating at the same clock domain.
Synchronous FIFOs are widely used in applications such as data transfer between producer-consumer pairs, communication interfaces, and pipelined architectures. This repository include the RTL code, the SystemVerilog testbench along with the constraint file and the timing reports.
## Operation
<img width="882" height="281" alt="Image" src="https://github.com/user-attachments/assets/3d450132-9cfb-4eaa-a7d2-ba817706e9a4" />

### Write only
If the FIFO is not full, add data_in to fifo[w_ptr] and increase the w_ptr signal and count signal. w_ptr should warp to 0 if the previous values was FIFO_WIDTH-1:<br>
```verilog
fifo[w_ptr]<=data_in;
count<=count+1;
w_ptr<=(w_ptr==FIFO_WIDTH-1)?0:w_ptr+1;
r_ptr<=r_ptr;
```
If the FIFO is full, do nothing.<br>
### Read only
If the FIFO is not empty, remove data from fifo[r_ptr] and increase r_ptr signal and decrease the count signal. r_ptr should warp to 0 if the previous values was FIFO_WIDTH-1:<br>
```verilog
data_out<=fifo[r_ptr];
count<=count-1;
w_ptr<=w_ptr;
r_ptr<=(r_ptr==FIFO_WIDTH-1)?0:r_ptr+1;
```
If the FIFO is empty, do nothing.<br>
### Read & Write
If the FIFO is empty, perform write only.<br>
If the FIFO is full, perform read only.<br>
If the FIFO is neither, perform both read and write. Add data at fifo[w_ptr] and read output fifo[r_ptr] at data_out while increase r_ptr and w_ptr (including warp_around logic):<br>
```verilog
fifo[w_ptr]<=data_in;
data_out<=fifo[r_ptr];
count<=count;
w_ptr<=(w_ptr==FIFO_WIDTH-1)?0:w_ptr+1;
r_ptr<=(r_ptr==FIFO_WIDTH-1)?0:r_ptr+1;
```
### Full
`full = (count == FIFO_WIDTH)`
### Empty
`empty = (count == 0)`
## Simulation
The docs folder include 2 testbenches and 2 corresponding simulation waveform. The first testbench will perform 1 read + 1 write sequentially so the full and empty condition will never reach:<br>
```
Time = 206000: Comparison Passed: wr_data = 13 and rd_data = 13
Time = 226000: Comparison Passed: wr_data = 70 and rd_data = 70
Time = 246000: Comparison Passed: wr_data = fd and rd_data = fd
Time = 266000: Comparison Passed: wr_data = e2 and rd_data = e2
Time = 286000: Comparison Passed: wr_data = 97 and rd_data = 97
Time = 306000: Comparison Passed: wr_data = f1 and rd_data = f1
Time = 326000: Comparison Passed: wr_data = c5 and rd_data = c5
Time = 346000: Comparison Passed: wr_data = ec and rd_data = ec
Time = 366000: Comparison Passed: wr_data = 48 and rd_data = 48
Time = 386000: Comparison Passed: wr_data = 0c and rd_data = 0c
Time = 406000: Comparison Passed: wr_data = 2c and rd_data = 2c
Time = 426000: Comparison Passed: wr_data = 6b and rd_data = 6b
Time = 446000: Comparison Passed: wr_data = 1b and rd_data = 1b
Time = 466000: Comparison Passed: wr_data = 45 and rd_data = 45
Time = 486000: Comparison Passed: wr_data = f4 and rd_data = f4
Time = 546000: Comparison Passed: wr_data = 6c and rd_data = 6c
Time = 566000: Comparison Passed: wr_data = 67 and rd_data = 67
Time = 586000: Comparison Passed: wr_data = 8c and rd_data = 8c
Time = 606000: Comparison Passed: wr_data = 4a and rd_data = 4a
Time = 626000: Comparison Passed: wr_data = a6 and rd_data = a6
Time = 646000: Comparison Passed: wr_data = a3 and rd_data = a3
Time = 666000: Comparison Passed: wr_data = 9d and rd_data = 9d
Time = 686000: Comparison Passed: wr_data = 7c and rd_data = 7c
Time = 706000: Comparison Passed: wr_data = b8 and rd_data = b8
Time = 726000: Comparison Passed: wr_data = eb and rd_data = eb
Time = 746000: Comparison Passed: wr_data = 5b and rd_data = 5b
Time = 766000: Comparison Passed: wr_data = f3 and rd_data = f3
Time = 786000: Comparison Passed: wr_data = 4d and rd_data = 4d
Time = 806000: Comparison Passed: wr_data = 5c and rd_data = 5c
Time = 826000: Comparison Passed: wr_data = f6 and rd_data = f6
```
The second testbench will try to provoke the full and empty condition:
```
Push In: w_en=1, r_en=0, data_in=24
Push In: w_en=1, r_en=0, data_in=81
Push In: w_en=1, r_en=0, data_in=09
Push In: w_en=1, r_en=0, data_in=63
Push In: w_en=1, r_en=0, data_in=0d
Push In: w_en=1, r_en=1, data_in=8d
Pop Out: w_en=1, r_en=1, data_out=24
Pop Out: w_en=1, r_en=1, data_out=81
Push In: w_en=1, r_en=1, data_in=65
Push In: w_en=1, r_en=1, data_in=12
Pop Out: w_en=1, r_en=1, data_out=09
Pop Out: w_en=1, r_en=1, data_out=63
Push In: w_en=1, r_en=1, data_in=01
Push In: w_en=1, r_en=1, data_in=0d
Pop Out: w_en=0, r_en=1, data_out=0d
Pop Out: w_en=0, r_en=1, data_out=8d
Pop Out: w_en=0, r_en=1, data_out=65
Pop Out: w_en=0, r_en=1, data_out=12
Pop Out: w_en=0, r_en=1, data_out=01
Pop Out: w_en=0, r_en=1, data_out=0d
Push In: w_en=1, r_en=0, data_in=76
Push In: w_en=1, r_en=0, data_in=3d
Push In: w_en=1, r_en=0, data_in=ed
Push In: w_en=1, r_en=0, data_in=8c
Push In: w_en=1, r_en=0, data_in=f9
Push In: w_en=1, r_en=0, data_in=c6
Push In: w_en=1, r_en=0, data_in=c5
Push In: w_en=1, r_en=0, data_in=aa
FIFO Full!! Can not push data_in=170
FIFO Full!! Can not push data_in=170
Pop Out: w_en=0, r_en=1, data_out=76
Pop Out: w_en=0, r_en=1, data_out=3d
Pop Out: w_en=0, r_en=1, data_out=ed
Pop Out: w_en=0, r_en=1, data_out=8c
Pop Out: w_en=0, r_en=1, data_out=f9
Pop Out: w_en=0, r_en=1, data_out=c6
Pop Out: w_en=0, r_en=1, data_out=c5
Pop Out: w_en=0, r_en=1, data_out=aa
FIFO Empty!! Can not pop data_out
FIFO Empty!! Can not pop data_out
```

## Constraint + Timing report
## References
1/ [VLSI verify Blog - Synchronous FIFO](https://vlsiverify.com/verilog/verilog-codes/synchronous-fifo/) <br>
2/ [chipverify website](https://www.chipverify.com/verilog/synchronous-fifo) <br>
3/ 

