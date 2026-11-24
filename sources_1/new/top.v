module top(output [2:0]simon_led0, simon_led1, simon_led2, simon_led3, input clk);

led_ctrl led(.led0(simon_led0), .led1(simon_led1), .led2(simon_led2), .led3(simon_led3), .clk(clk));




endmodule



