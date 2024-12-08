`timescale 1ns / 1ps

module top(
    output reg [15:0] led,
    input PS2Data,
    input PS2Clk,
    input clk,          // 100MHz on Basys 3
    input btnC,         // btnC on Basys 3 reset VGA
    input btnU,         // btnU on Basys 3 and send data from switch to another
    input btnR,
    output wire RsTx,   // UART
    input wire RsRx,    // UART
    input [7:0] sw,     // switch
    input ja1,          // Receive from another board
    output ja2,         // Transmit to another board
    output hsync,       // to VGA connector
    output vsync,       // to VGA connector
    output [11:0] rgb,  // to DAC, to VGA connector
    output [6:0] seg,   // 7-Segment Display
    output dp,
    output [3:0] an     // 7-Segment an control
    );
    
    // Keyboard
    reg         CLK50MHZ=0;
    wire [15:0] keycode;
    wire        flag;
    wire [7:0]  char;
    
    always @(posedge(clk))begin
        CLK50MHZ<=~CLK50MHZ;
    end
    
    PS2Receiver uut (
        .clk(CLK50MHZ),
        .kclk(PS2Clk),
        .kdata(PS2Data),
        .keycode(keycode),
        .oflag(flag)
    );
    
    wire is_cap;
    scan2ascii conv(keycode[7:0], char, is_cap);
    
    wire is_press;
    assign is_press = (keycode[15:8] === 8'hF0) ? 0 : 1;
    
    always @(clk) begin
        led[7:0] = char;
        led[15] = is_cap;
        led[13] = is_press;
    end
    
    // signals
    wire [9:0] w_x, w_y;
    wire w_video_on, w_p_tick;
    wire received1, received2; // FROM Keyboard and FROM another board
    reg [11:0] rgb_reg;
    wire [7:0] data_in; //WRITE DATA FROM UART, DATA THAT SHOWN ON SCREEN
    wire [11:0] rgb_next;
    wire [7:0] gnd_b; // GROUND_BUS
    wire [7:0] data_rx, data_tx;
    wire dummy1, dummy2;
    
    // VGA Controller
    vga_controller vga(.clk_100MHz(clk), .reset(btnC), .hsync(hsync), .vsync(vsync), .video_on(w_video_on), .p_tick(w_p_tick), .x(w_x), .y(w_y));
    
    // Text Generation Circuit
    ascii_test at(.clk(clk), .video_on(w_video_on), .x(w_x), .y(w_y), .rgb(rgb_next), .data(data_in), .we(received1));
    
    // UART1 Receive from another and transmit to monitor
    uart uart1(.tx(RsTx), .data_transmit({7'b0, gnd_b}),
               .rx(ja1), .data_received(data_in), .received(received1),
               .dte(2'b00), .clk(clk), .disp(data_rx));
                
    // UART2 Receive from keyboard or switch and transmit to another
    uart uart2(.tx(ja2), .data_transmit({char, sw[7:0]}),
               .rx(RsRx), .data_received(gnd_b), .received(received2),
               .dte({is_press, btnU}), .clk(clk), .disp(data_tx));
               
   
    // Assign number
    wire [3:0] num3,num2,num1,num0; // From left to right
    
    assign num0=data_tx[3:0];
    assign num1=data_tx[7:4];
    assign num2=data_in[3:0];
    assign num3=data_in[7:4];

    wire an0,an1,an2,an3;
    assign an={an3,an2,an1,an0};
    
    // Clock
    wire targetClk;
    wire [17:0] tclk;
    assign tclk[0]=clk;
    genvar c;
    generate for(c=0;c<17;c=c+1) begin
        clockDiv fDiv(tclk[c+1],tclk[c]);
    end endgenerate
    
    clockDiv fdivTarget(targetClk,tclk[17]);
    
    // Display
    quadSevenSeg q7seg(seg,dp,an0,an1,an2,an3,num0,num1,num2,num3,targetClk);
    
    
    // rgb buffer
    always @(posedge clk)begin
        if(w_p_tick)
            rgb_reg <= rgb_next;
    end
    // output
    assign rgb = rgb_reg;
      
endmodule