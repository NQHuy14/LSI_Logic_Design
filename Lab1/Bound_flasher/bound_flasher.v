module labLSI(
    input reset,
    input clk,
    input flick,
    output reg [15:0] led
);

    // State definitions remain unchanged
    localparam IDLE = 0, LAMP5_ON = 1, LAMP0_OFF = 2, LAMP10_ON = 3,
               LAMP4_ON = 4, LAMP15_ON = 5, FINAL_OFF = 6, FINAL_BLINK = 7,
               KICK1 = 8, KICK2 = 9;

    reg [4:0] counter;
    reg [3:0] state, next_state;

    // Simplify the reset and state transition process
    always @(posedge clk or posedge reset) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    // Use functions for common operations to simplify the case statement
    function [15:0] shiftLeftInsert1(input [15:0] value);
        shiftLeftInsert1 = {value[14:0], 1'b1};
    endfunction

    function [15:0] shiftRight(input [15:0] value);
        shiftRight = value >> 1;
    endfunction

    // Main logic with simplified syntax for bit manipulation
    always @(posedge clk) begin
        case (state)
            IDLE: led <= 0;

            LAMP5_ON, LAMP10_ON, LAMP15_ON: begin
                led <= shiftLeftInsert1(led);
                counter <= counter - 1;
            end

            LAMP0_OFF, LAMP4_ON, FINAL_OFF, KICK1, KICK2: begin
                led <= shiftRight(led);
                counter <= counter - 1;
            end

            FINAL_BLINK: led <= 16'hFFFF;

            default: led <= 0;
        endcase
    end

    // State transition logic remains largely unchanged as it is already quite optimized
   always @(*) begin
        case(state)
            IDLE: 
                begin
                    if(flick) begin
                        counter = 5;
                        next_state = LAMP5_ON;
                    end
                end
            LAMP5_ON:   
                begin
                    if(counter == 0) begin
                        next_state = LAMP0_OFF;
                        counter = 6;
                    end
                end
            LAMP0_OFF:
                begin
                    if(counter == 0) begin
                        next_state = LAMP10_ON;
                        counter = 11;
                    end
                end
            LAMP10_ON:
                begin
                    if(flick && (led == 16'h001F || led == 16'h03FF)) begin
                        next_state = KICK1;
                        if(led == 16'h001F) begin
                            counter = 6;
                        end
                        else if(led == 16'h03FF) begin
                            counter = 11;
                        end
                    end
                    else if(counter == 0) begin
                        next_state = LAMP4_ON;
                        counter = 6;
                    end
                end
            LAMP4_ON:
                begin
                    if(counter == 0) begin
                        next_state = LAMP15_ON;
                        counter = 11;
                    end
                end
            LAMP15_ON:
                begin
                    if(flick && (led == 16'h001F || led == 16'h03FF)) begin
                        next_state = KICK2;
                        if(led == 16'h001F) begin
                            counter = 1;
                        end
                        else if(led == 16'h03FF) begin
                                counter = 6;
                        end
                    end
                    else if(counter == 0) begin
                        next_state = FINAL_OFF;
                        counter = 16;
                    end
                end
            FINAL_OFF:
                begin
                    if(counter == 0) begin
                        next_state = FINAL_BLINK;
                    end
                end
            FINAL_BLINK:
                begin
                    next_state = IDLE;
                end
            KICK1:
                begin
                    if(counter == 0) begin
                        next_state = LAMP10_ON;
                        counter = 11;
                    end
                end
            KICK2:
                begin
                    if(counter == 0) begin
                        next_state = LAMP15_ON;
                        counter = 11;
                    end
                end
            default:
                next_state = IDLE;
        endcase
    end


endmodule
