# Synchronous FIFO Design
This repo contain the verilog code for a synchronous FIFO along with the testbench and timing report.
## Introduction
This project implements a synchronous First-In First-Out (FIFO) buffer using Verilog. The primary purpose of a FIFO is to temporarily store data while maintaining the order of arrival, making it a critical component in digital systems where data needs to be buffered between modules operating at the same clock domain.
Synchronous FIFOs are widely used in applications such as data transfer between producer-consumer pairs, communication interfaces, and pipelined architectures. This repository include the RTL code, the SystemVerilog testbench along with the constraint file and the timing reports.
## Operation
The docs folder include 2 testbenches and 2 corresponding simulation waveform.
The first testbench will perform 1 read + 1 write sequentially so the full and empty condition will never reach.
The second testbench will try to provoke the full and empty condition.
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
## Simulation

## Constraint + Timing report
## References
1/ [VLSI verify Blog - Synchronous FIFO](https://vlsiverify.com/verilog/verilog-codes/synchronous-fifo/)
2/ [chipverify website](https://www.chipverify.com/verilog/synchronous-fifo)
3/ 

