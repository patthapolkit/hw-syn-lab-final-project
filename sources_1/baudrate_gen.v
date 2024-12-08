`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 12:24:05 PM
// Design Name: 
// Module Name: baudrate_gen
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


module baudrate_gen(
    input clk,
    output reg baud
    );
    
    integer counter;
    always @(posedge clk) begin
        counter = counter + 1;
        if (counter == 325) begin counter = 0; baud = ~baud; end 
    end
    
endmodule