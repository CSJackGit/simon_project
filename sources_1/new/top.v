module top(output [2:0] simon_led0, simon_led1, simon_led2, simon_led3, output [7:0] seg_n, output [3:0] an_n, input clk, input [1:0] sw, input [3:0] simon_buttons_n);

// Global Variables
wire reset = sw[0];
reg [26:0] timer;

// Game State Machine States
localparam GAMESTATE_IDLE = 0, GAMESTATE_UPDATEPRNG = 1, GAMESTATE_PLAYSEQUENCE = 2, GAMESTATE_USERSEQUENCE = 3, GAMESTATE_USERFAILED = 4, GAMESTATE_REACHEDMAX = 5;
reg [2:0] current_state, next_state;

//Buttons, order: Top Left, Top Right, Bottom Left, Bottom Right
wire [3:0] pressed;
wire [3:0] held;
wire [3:0] released;

// Debounced buttons
debounce top_left(.pressed(pressed[0]), .held(held[0]), .released(released[0]), .button(~simon_buttons_n[0]), .clk(clk));
debounce top_right(.pressed(pressed[1]), .held(held[1]), .released(released[1]), .button(~simon_buttons_n[1]), .clk(clk));
debounce bottom_left(.pressed(pressed[2]), .held(held[2]), .released(released[2]), .button(~simon_buttons_n[2]), .clk(clk));
debounce bottom_right(.pressed(pressed[3]), .held(held[3]), .released(released[3]), .button(~simon_buttons_n[3]), .clk(clk));

// Sets up LEDs later we need to setup control over which one is not dimmed
reg [3:0] brightest_led;
led_ctrl led(.led0(simon_led0), .led1(simon_led1), .led2(simon_led2), .led3(simon_led3), .brightest_led(brightest_led), .clk(clk));

// Random Button Logic
wire [1:0] prng_random;
reg [3:0] prng_step_count;
reg [3:0] prng_step_count_max;

reg prng_step;
reg prng_randomize;
reg prng_rerun;

// PRNG module instantiation
PRNG prng(.random(prng_random), .clk(clk), .reset(reset), .step(prng_step), .randomize(prng_randomize), .rerun(prng_rerun));

// Seven seg display
seg_ctrl display(.seg_n(seg_n), .an_n(an_n), .A(prng_step_count), .B(prng_step_count_max), .C(current_state), .D(prng_step), .clk(clk));

always @(posedge clk) begin
    if (reset) begin
        current_state <= GAMESTATE_IDLE;
        prng_step_count <= 0;
        prng_step_count <= 1;
    end
    else begin
        current_state <= next_state;
    end
    
    
    timer <= timer + 1;
    if (timer == 99_999_999) begin
        timer <= 0;
        
        // While on PlaySequence state, play the current sequence
        if (current_state == GAMESTATE_PLAYSEQUENCE) begin
            prng_step_count <= prng_step_count + 1;
            if (prng_step_count == prng_step_count_max) begin
                prng_step_count <= 0;
                prng_step_count_max <= prng_step_count_max + 1;
            end
        end
        else if (current_state == GAMESTATE_IDLE) begin
            prng_step_count <= 0;
            prng_step_count_max <= 0;
        end
    end
end

always @* begin
    prng_randomize = 0;
    prng_step = 0;
    prng_rerun = 0;

    next_state = current_state;
    
    case (current_state)
        GAMESTATE_IDLE: begin 
            prng_randomize = 1;
            if (released) begin
                next_state = GAMESTATE_UPDATEPRNG;
                //prng_step_count = 0;
                //prng_step_count_max = 0;
            end
        end
        GAMESTATE_UPDATEPRNG: begin
             next_state = GAMESTATE_PLAYSEQUENCE;
        end
        GAMESTATE_PLAYSEQUENCE: begin
            if (timer == 99_999_999) begin
                prng_step = 1;
                
                // Brightest Led Encoder from prng random value
                case (prng_random)
                    0: brightest_led = 4'b0001;
                    1: brightest_led = 4'b0010;
                    2: brightest_led = 4'b0100;
                    3: brightest_led = 4'b1000;
                endcase
                
                if (prng_step_count == prng_step_count_max) begin
                    next_state = GAMESTATE_USERSEQUENCE;
                end
                
            end
        end
        GAMESTATE_USERSEQUENCE: begin
            brightest_led = 4'b0000;
            if (timer == 99_999_999) begin
                // Rerun from seed
                prng_rerun = 1;
                next_state = GAMESTATE_PLAYSEQUENCE;
            end
        end
        GAMESTATE_USERFAILED: begin
        
        end
        GAMESTATE_REACHEDMAX: begin
        
        end
    endcase
end

endmodule