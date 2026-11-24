module state(input clk, reset);

localparam IDLE = 0;
reg[3:0] next, current;

always @(posedge clk) begin 
    if(reset)
        current <= IDLE;  
    else
        current <= next;
end

always@* begin
    next = current;
    
    case(current)
        
        default:   
            next = IDLE;        
        
        endcase
end



endmodule