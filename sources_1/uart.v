`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 12:24:42 PM
// Design Name: 
// Module Name: uart
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


module uart(
    input clk,
    input rx,
    input [15:0] data_transmit,
    input [1:0] dte,
    output tx,
    output [7:0] data_received,
    output received,
    output [7:0] disp
    );
    
    reg en, last_rec;
    wire [7:0] data;
    wire baud;
    wire sent;
    
    assign data = (dte == 2'b01) ? data_transmit[7:0] : 
                  (dte == 2'b10) ? data_transmit[15:8] : 
                  data_received;
    
    baudrate_gen baudrate_gen(clk, baud);
    uart_rx receiver(baud, rx, received, data_received);
    uart_tx transmitter(baud, data, en, sent, tx, disp);
    
    always @(posedge baud) begin
        if (en) en = 0;
        if ((~last_rec & received) || dte) begin
            en = 1;
        end
        last_rec = received;
    end
    
endmodule