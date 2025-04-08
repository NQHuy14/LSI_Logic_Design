`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2024 04:31:39 PM
// Design Name: 
// Module Name: new_bound_flasher
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module new_bound_flasher(
    input reset,
    input clk,
    input flick,
    output reg [15:0] led
);

    parameter  INIT_STATE = 0, FIRST_INCREASE = 1, FIRST_DECREASE = 2, SECOND_INCREASE = 3,
               THIRD_INCREASE = 4, FOURTH_INCREASE = 5, FINAL_DECREASE = 6, FINAL_STATE = 7,
               FIRST_KICK_BALL = 12, SECOND_KICK_BALL = 14;

    reg [4:0] change_state_counter;
    reg [3:0] curr_state, next_state;

   
    always @(posedge clk or negedge reset) begin
        if (!reset) curr_state <= INIT_STATE;
        else curr_state <= next_state;
    end

  
    function [15:0] shiftLeftInsert1(input [15:0] value);
        shiftLeftInsert1 = {value[14:0], 1'b1};
    endfunction

    function [15:0] shiftRight(input [15:0] value);
        shiftRight = value >> 1;
    endfunction

   
    always @(posedge clk) begin
        case (curr_state)
            INIT_STATE: begin
                 led <= 0;
                end

            FIRST_INCREASE, SECOND_INCREASE, FOURTH_INCREASE: begin
                led <= shiftLeftInsert1(led);
                change_state_counter <= change_state_counter - 1;
            end

            FIRST_DECREASE, THIRD_INCREASE, FINAL_DECREASE, FIRST_KICK_BALL, SECOND_KICK_BALL: begin
                led <= shiftRight(led);
                change_state_counter <= change_state_counter - 1;
            end

            FINAL_STATE: begin 
                led <= 16'b1111111111111111;
            end
            default: begin 
                led <= 0;
            end
        endcase
        
        
        case(curr_state)
            INIT_STATE: 
                begin
                    if(flick) begin
                        change_state_counter <= 5;
                        next_state <= FIRST_INCREASE;
                    end
                end
            FIRST_INCREASE:   
                begin
                    if(change_state_counter == 0) begin
                        next_state <= FIRST_DECREASE;
                        change_state_counter <= 6;
                    end
                end
            FIRST_DECREASE:
                begin
                    if(change_state_counter == 0) begin
                        next_state <= SECOND_INCREASE;
                        change_state_counter <= 11;
                    end
                end
            SECOND_INCREASE:
                begin
                    if(flick && (led == 16'b0000000000011111 || led == 16'b0000001111111111)) begin
                        next_state <= FIRST_KICK_BALL;
                        if(led == 16'b0000000000011111) begin
                            change_state_counter <= 6;
                        end
                        else if(led == 16'b0000001111111111) begin
                            change_state_counter <= 11;
                        end
                    end
                    else if(change_state_counter == 0) begin
                        next_state <= THIRD_INCREASE;
                        change_state_counter <= 6;
                    end
                end
            THIRD_INCREASE:
                begin
                    if(change_state_counter == 0) begin
                        next_state <= FOURTH_INCREASE;
                        change_state_counter <= 11;
                    end
                end
            FOURTH_INCREASE:
                begin
                    if(flick && (led == 16'b0000000000011111 || led == 16'b0000001111111111)) begin
                        next_state <= SECOND_KICK_BALL;
                        if(led == 16'b0000000000011111) begin
                            change_state_counter <= 1;
                        end
                        else if(led == 16'b0000001111111111) begin
                                change_state_counter <= 6;
                        end
                    end
                    else if(change_state_counter == 0) begin
                        next_state <= FINAL_DECREASE;
                        change_state_counter <= 16;
                    end
                end
            FINAL_DECREASE:
                begin
                    if(change_state_counter == 0) begin
                        next_state <= FINAL_STATE;
                    end
                end
            FINAL_STATE:
                begin
                    next_state <= INIT_STATE;
                end
            FIRST_KICK_BALL:
                begin
                    if(change_state_counter == 0) begin
                        next_state <= SECOND_INCREASE;
                        change_state_counter <= 11;
                    end
                end
            SECOND_KICK_BALL:
                begin
                    if(change_state_counter == 0) begin
                        next_state <= FOURTH_INCREASE;
                        change_state_counter <= 11;
                    end
                end
            default:
                next_state <= INIT_STATE;
        endcase
    end

    

endmodule