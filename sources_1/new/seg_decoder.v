module seg_decoder (
    output reg [7:0] segment,
    input  wire [3:0] hex
);

    always @(*) begin
        case (hex)
            4'h0 : segment = ~8'b00111111;
            4'h1 : segment = ~8'b00000110;
            4'h2 : segment = ~8'b01011011;
            4'h3 : segment = ~8'b01001111;
            4'h4 : segment = ~8'b01100110;
            4'h5 : segment = ~8'b01101101;
            4'h6 : segment = ~8'b01111101;
            4'h7 : segment = ~8'b00000111;
            4'h8 : segment = ~8'b01111111;
            4'h9 : segment = ~8'b01101111;
            4'hA : segment = ~8'b01110111;
            4'hB : segment = ~8'b01111100;
            4'hC : segment = ~8'b00111001;
            4'hD : segment = ~8'b01011110;
            4'hE : segment = ~8'b01111001;
            4'hF : segment = ~8'b01110001;
            default: segment = ~8'b00000000;
        endcase
    end
endmodule