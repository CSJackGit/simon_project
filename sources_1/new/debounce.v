module debounce(output pressed, held, released, input button, clk);

localparam SAMPLETIME = 1_999_999;
reg [20:0] timer;
reg button_sampled, button_debounced, button_debounced_d;

always @(posedge clk) begin
    timer <= timer - 1;
    if (timer == 0)
        timer <= SAMPLETIME;
end

always @(posedge clk) begin
    button_debounced_d <= button_debounced;
    if (timer == 0) begin
        button_sampled <= button;
        if (button == button_sampled)
            button_debounced <= button;
    end
end

assign held = button_debounced;
assign pressed = button_debounced & ~button_debounced_d;
assign released = ~button_debounced & button_debounced_d;

endmodule