module speaker(output reg speaker, input clk, enable, input[2:0] tone);
    reg [17:0] counter;
    reg [17:0] freq;
   
    always @(posedge clk)begin
        if (enable) begin
            counter <= counter - 1;
           
            if (counter == 0)
            counter <= freq;
           
            if (counter >= (freq >> 1) )
                speaker <= 1'b0;
               
            else speaker <= 1'b1;
        end
        else speaker <= 1'b0;
    end
   
    always @* begin
        case (tone)
            0: freq = 227272;
            1: freq = 202478;
            2: freq = 180384;
            3: freq = 170262;
            4: freq = 151686;
            5: freq = 135136;
            6: freq = 120392;
            7: freq = 113636;
        endcase
    end
endmodule