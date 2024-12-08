`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2024 09:52:23 PM
// Design Name: 
// Module Name: singlePulser
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


module singlePulser(
    input clk,
    input sig,
    output out
    );
    
reg out;
reg state;

initial state = 0;

always @(posedge clk)
begin
    out = 0;
    if (state == 0 && sig == 1)
    begin
        state = 1;
        out = 1;
    end
    else if (state == 1 && sig == 0)
    begin
        state = 0;
        out = 0;
    end
end
    
endmodule
