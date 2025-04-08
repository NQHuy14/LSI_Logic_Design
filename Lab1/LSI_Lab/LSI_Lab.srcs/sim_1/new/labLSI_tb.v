`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2024 07:44:41 PM
// Design Name: 
// Module Name: labLSI_tb
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


module new_bound_flasher_tb;
reg reset,clk,flick;
wire [15:0] led;
new_bound_flasher uut(.reset(reset),.clk(clk),.flick(flick),.led(led));
  initial 
    begin 
        clk=1'b0;
        forever 
            #1 clk=~clk;
        
    end
parameter TIME_UNIT =1;
task testCase1; 
begin 
    #TIME_UNIT reset=0;
    #TIME_UNIT flick=1;
    #TIME_UNIT reset =1;
    #(TIME_UNIT*3) flick=0;
    #(TIME_UNIT*57) flick=1;
   
end 

endtask    

task testCase2; 
begin 
        reset = 0;
        @(negedge clk);
        reset = 1;
        flick = 1;
        @(negedge clk);
        flick = 0;
        repeat(50) begin
            @(negedge clk);
        end
        flick = 1;
        repeat(50) begin
            @(negedge clk);
        end
      
end 

endtask 

task testCase3; 
begin 
     #TIME_UNIT reset=0;
    #TIME_UNIT flick=1;
    #TIME_UNIT reset =1;
    #(TIME_UNIT*3) flick=0;
    #(TIME_UNIT*43) flick=1;
end 

endtask

task testCase4; 
begin 
     #TIME_UNIT reset=0;
    #TIME_UNIT flick=1;
    #TIME_UNIT reset =1;
    #(TIME_UNIT*3) flick=0;
end 

endtask       
task testCase5; 
begin 
     #TIME_UNIT reset=0;
    #TIME_UNIT flick=1;
    #TIME_UNIT reset =1;
    #(TIME_UNIT*3) flick=0;
    #(TIME_UNIT*71) flick=1;
end 

endtask
task testCase6; 
begin 
     #TIME_UNIT reset=0;
    #TIME_UNIT flick=1;
    #TIME_UNIT reset =1;
    #(TIME_UNIT*3) flick=0;
    #(TIME_UNIT*71) reset=0;
end 

endtask



task testCase7; 
begin 
     #TIME_UNIT reset=0;
    #TIME_UNIT flick=1;
    #TIME_UNIT reset =1;
    #(TIME_UNIT*3) flick=0;
    #(TIME_UNIT*71) reset=0;
    
    #(TIME_UNIT*2) reset=1;
    #(TIME_UNIT*2) flick=1;
    
end 

endtask

                                
 initial begin 
//    testCase1;
//    testCase2;
//    testCase3;
      testCase4;
//    testCase5;
//    testCase6;
//    testCase7;

    $finish;
 end 
endmodule
