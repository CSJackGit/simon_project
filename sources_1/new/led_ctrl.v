module led_ctrl(output reg [2:0] led0, led1, led2, led3, input [3:0] brightest_led, input clk);

localparam RED = 3'b001, GREEN = 3'b010, BLUE = 3'b100, YELLOW = 3'b011, BLACK = 3'b000, MS = 100_000;

reg [18:0] timer;

always @(posedge clk) begin

    timer <= timer + 1;
    if(timer == (5*MS -1))
        timer <= 0;
end

always @* begin
    
    led0 = BLACK;
    led1 = BLACK;
    led2 = BLACK;
    led3 = BLACK;
    
    // Dims all the other LEDS
    if (timer < (1 * MS) - 1) begin
        led0 = GREEN;
        led1 = RED;
        led2 = BLUE;
        led3 = YELLOW;
    end
    
    // Sets one LED to be brighter than the rest
    case (brightest_led)
        4'b0001: led0 = GREEN;
        4'b0010: led1 = RED;
        4'b0100: led2 = BLUE;
        4'b1000: led3 = YELLOW;
    endcase
end

endmodule