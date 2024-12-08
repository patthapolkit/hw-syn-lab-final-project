`timescale 1ns / 1ps

module ascii_test(
    input clk,                 // Clock signal
    input reset,               // Reset signal
    input we,                  // Write enable signal from UART
    input [7:0] data,          // 8-bit data from UART
    input video_on,            // Video on/off signal
    input [9:0] x, y,          // Current pixel coordinates
    output reg [11:0] rgb      // RGB output
);

    // Parameters and declarations
    parameter MEMSIZE = 128;      // Memory size (128 locations)
    reg [15:0] mem[MEMSIZE:0];     // 16-bit memory array
    reg [6:0] itr;                // Memory index for writing

    // Signals for ASCII ROM
    wire [19:0] rom_addr;         // 20-bit text ROM address
    wire [15:0] ascii_char;        // 16-bit ASCII character code
    wire [3:0] char_row;          // 4-bit row of ASCII character
    wire [2:0] bit_addr;          // Column number of ROM data
    wire [7:0] rom_data;          // 8-bit row data from text ROM
    wire ascii_bit, plot;         // ASCII ROM bit and plot signal
    
    integer i ;
    initial begin
        itr = 7'b0 ;
        mem[128] = 16'h0020;
        for (i = 0 ; i < MEMSIZE ; i = i + 1) begin
            mem[i] = 16'h0020 ;
        end
    end

    // ASCII ROM instance
    ascii_rom rom(.clk(clk), .addr(rom_addr[15:0]), .data(rom_data));
    
    // ASCII ROM address and data interface
    assign rom_addr = {ascii_char, char_row};   // ROM address
    assign ascii_bit = rom_data[~bit_addr];     // Reverse bit order for ASCII character
    assign char_row = y[3:0];                   // Row number of ASCII character
    assign bit_addr = x[2:0];                   // Column number of ASCII character
    assign ascii_char = mem[((x[7:3] + 8) & 5'b11111) + (32 * ((y[5:4] + 3) & 2'b11))];
    
    assign plot = ((x >= 192 && x < 448) && (y >= 208 && y < 272)) ? ascii_bit : 1'b0;
    
    reg [23:0] thai_char;
	reg is_thai;
	reg [1:0] thai_char_count;
	
	initial is_thai = 0;

    // Memory write logic
    always @(posedge we) begin
        mem[128] = 16'h0020;
        if (is_thai) begin
            if (thai_char_count == 2) begin
                mem[itr] = {thai_char[15:8], data};
                itr = itr + 1;
                if (itr >= MEMSIZE)
                    itr = 0;
                thai_char = 24'b0; // Clear the thai_char buffer
                is_thai = 0;
            end else begin
                case (thai_char_count)
                    0: thai_char[23:16] = data;
                    1: thai_char[15:8] = data;
                    default: ; // Do nothing for unexpected values
                endcase
                thai_char_count = thai_char_count + 1;
            end
        end
        else begin
            if (data[6:0] == 7'h0D) begin // Handle Enter
                itr = (1 + (itr >> 5)) << 5;
                if (itr >= MEMSIZE)
                    itr = 0;
            end 
            else begin
                if (data[6:0] == 7'h7F) begin
                    itr = (itr + 127) % MEMSIZE;
                    mem[itr] = 16'h0020;
                end
                else begin
                    if (data == 8'hE0) begin
                        is_thai = 1;
                        thai_char_count = 0;
                        thai_char[23:16] = data;
                        thai_char_count = thai_char_count + 1;
                    end
                    else begin
                        mem[itr] = {9'b0, data[6:0]};
                        itr = itr + 1;
                        if (itr >= MEMSIZE)
                            itr = 0;    
                    end
                end
            end
        end
    end

    // RGB multiplexing logic
   always @* begin
        if (~video_on) begin
            rgb = 12'h000; // Display blank screen
        end else if (plot) begin
            case (y[5:4]) // Determine color based on the row number
                2'b00: rgb = 12'h817;
                2'b01: rgb = 12'hE94;
                2'b10: rgb = 12'hC66;
                2'b11: rgb = 12'hA35;
                default: rgb = 12'h888; // Gray for extra rows
            endcase
//        end else if ((x >= 460 && x < 640 && y >= 300 && y < 350) ||
//                     (x >= 480 && x < 620 && y >= 250 && y < 300) ||
//                     (x >= 500 && x < 600 && y >= 200 && y < 250) ||
//                     (x >= 520 && x < 580 && y >= 160 && y < 200) ||
//                     (x >= 535 && x < 565 && y >= 130 && y < 160)) begin
//            rgb = 12'hE94; // Leaf
//        end else if (x >= 535 && x < 565 && y >= 350 && y < 440) begin
//            rgb = 12'h36B; // Stem
//        end else if ((x >= 0 && x < 120 && y >= 400 && y < 480) ||
//                     (x >= 200 && x < 535 && y >= 400 && y < 480) ||
//                     (x >= 120 && x < 200 && y >= 440 && y < 480) ||
//                     (x >= 535 && x < 640 && y >= 440 && y < 480) ||
//                     (x >= 565 && x < 640 && y >= 400 && y < 440)) begin
//            rgb = 12'hC66; // Ground
//        end else if ((x >= 120 && x < 150 && y >= 360 && y < 390) ||
//                     (x >= 170 && x < 200 && y >= 360 && y < 390) ||
//                     (x >= 120 && x < 150 && y >= 410 && y < 440) ||
//                     (x >= 170 && x < 200 && y >= 410 && y < 440)) begin
//            rgb = 12'hA35; // Ribbon
//        end else if ((x >= 120 && x < 200 && y >= 390 && y < 410) ||
//                     (x >= 150 && x < 170 && y >= 360 && y < 390) ||
//                     (x >= 150 && x < 170 && y >= 410 && y < 440)) begin
//            rgb = 12'h888; // Box
        end else begin
            if ((x >= 460 && x < 640 && y >= 300 && y < 350) ||
                (x >= 480 && x < 620 && y >= 250 && y < 300) ||
                (x >= 500 && x < 600 && y >= 200 && y < 250) ||
                (x >= 520 && x < 580 && y >= 160 && y < 200) ||
                (x >= 535 && x < 565 && y >= 130 && y < 160)) begin
                rgb = 12'hE94; // Leaf
            end else begin
                if (x >= 535 && x < 565 && y >= 350 && y < 440) begin
                    rgb = 12'h36B; // Stem
                end else begin
                    if ((x >= 0 && x < 120 && y >= 400 && y < 480) ||
                         (x >= 200 && x < 535 && y >= 400 && y < 480) ||
                         (x >= 120 && x < 200 && y >= 440 && y < 480) ||
                         (x >= 535 && x < 640 && y >= 440 && y < 480) ||
                         (x >= 565 && x < 640 && y >= 400 && y < 440)) begin
                        rgb = 12'hC66; // Ground
                    end else begin
                        if ((x >= 120 && x < 200 && y >= 390 && y < 410) ||
                             (x >= 150 && x < 170 && y >= 360 && y < 390) ||
                             (x >= 150 && x < 170 && y >= 410 && y < 440)) begin
                            rgb = 12'h888; // Ribbon
                        end else begin
                            rgb = 12'hFFF; // White background
                        end
                    end
                end
            end
        end
    end
    
endmodule