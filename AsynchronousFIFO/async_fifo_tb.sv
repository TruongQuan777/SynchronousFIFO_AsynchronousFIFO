`timescale 1ns/1ps

module async_fifo_tb();

    // Align parameters with your async_fifo module
    parameter DATA_WIDTH = 8;
    parameter FIFO_WIDTH = 8; 
    // PTR_WIDTH is handled internally by your module, but we can define it for DEPTH
    localparam DEPTH = FIFO_WIDTH;

    // Logic/Reg signals for driving inputs
    reg [DATA_WIDTH-1:0] data_in;
    reg w_en, r_en, w_clk, r_clk, wrst_n, rrst_n;

    // Wire signals for module outputs
    wire [DATA_WIDTH-1:0] data_out;
    wire full, empty;

    // Instantiate your async_fifo module with named mapping
    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_WIDTH(FIFO_WIDTH)
    ) dut (
        .w_clk(w_clk), 
        .wrst_n(wrst_n),
        .r_clk(r_clk), 
        .rrst_n(rrst_n),
        .w_en(w_en),
        .r_en(r_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock Generation: Faster Write, Slower Read
    always #5 w_clk = (w_clk === 1'b0) ? 1'b1 : 1'b0; // 100MHz
    always #17 r_clk = (r_clk === 1'b0) ? 1'b1 : 1'b0; // ~29MHz

    initial begin
        // Initialize all signals
        w_clk = 0;
        r_clk = 0;
        wrst_n = 1;     // Active low reset
        rrst_n = 1;
        w_en = 0;
        r_en = 0;
        data_in = 0;

        // Reset Sequence
        #20 wrst_n = 0; rrst_n = 0;
        #40 wrst_n = 1; rrst_n = 1;
        #20;

        // TEST CASE 1: Simple Write and Read
        $display("Time = %0t: Starting TEST CASE 1", $time);
        @(posedge w_clk);
        for (int i = 0; i < 5; i = i + 1) begin
            data_in = $urandom_range(0, 255);
            w_en = 1;
            @(posedge w_clk);
        end
        w_en = 0;

        repeat(5) @(posedge r_clk);
        r_en = 1;
        repeat(5) @(posedge r_clk);
        r_en = 0;

        // TEST CASE 2: Fill the FIFO until 'full' is high
        $display("Time = %0t: Starting TEST CASE 2 (Fill to Full)", $time);
        w_en = 1;
        while (!full) begin
            data_in = $urandom_range(0, 255);
            @(posedge w_clk);
        end
        w_en = 0;
        $display("Time = %0t: FIFO is FULL", $time);

        // TEST CASE 3: Empty the FIFO until 'empty' is high
        $display("Time = %0t: Starting TEST CASE 3 (Drain to Empty)", $time);
        r_en = 1;
        while (!empty) begin
            @(posedge r_clk);
        end
        r_en = 0;
        $display("Time = %0t: FIFO is EMPTY", $time);

        #100;
        $display("Time = %0t: Simulation Finished", $time);
        $finish;
    end

    initial begin 
        $dumpfile("dump.vcd"); 
        $dumpvars(0, async_fifo_tb);
    end

endmodule
