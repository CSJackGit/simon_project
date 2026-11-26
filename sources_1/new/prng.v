module PRNG #(parameter FILL = 16'hACE1)(output [1:0] random, input clk, reset, step, randomize, rerun);
    
    
    reg [15:0] prng, rerun_reg;
    reg randomize_d;
    reg [26:0] timer;
    wire fb = prng[0] ^ prng[2] ^ prng[3] ^ prng[5];
    wire falling_edge_randomize = ~randomize & randomize_d;

    assign random = prng[1:0];
    
    
    always @(posedge clk) begin
        randomize_d <= randomize;
        if (reset) begin
            prng <= FILL;
            rerun_reg <= FILL;
            randomize_d <= 1'b0;
        end
        else begin
            if (rerun)
                prng <= rerun_reg;
            else if (step || randomize)
                prng <= {fb, prng[15:1]};

            if (falling_edge_randomize)
                rerun_reg <= prng;
        end
    end
endmodule