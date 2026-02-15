module b2g_converter #(parameter DATA_WIDTH=8, parameter PTR_WIDTH=$clog2(DATA_WIDTH))(
    input  wire [WIDTH-1:0] binary_in,
    output wire [WIDTH-1:0] gray_out
);

    // The Gray code is calculated by XORing the binary 
    // number with itself shifted right by one position.
    assign gray_out = binary_in ^ (binary_in >> 1);

endmodule
