`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2024 05:39:38 PM
// Design Name: 
// Module Name: scan2ascii
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


module scan2ascii(
    input [7:0] scan_code,
    output reg [6:0] ascii_code,
    output reg is_cap
    );

always @(*) begin
    if (scan_code === 8'h58) begin
        is_cap = ~is_cap; // Caps Lock
    end
    
    if (is_cap === 0) begin
        case (scan_code)
            // Digits
            8'h45: ascii_code = 7'h30; // '0'
            8'h16: ascii_code = 7'h31; // '1'
            8'h1E: ascii_code = 7'h32; // '2'
            8'h26: ascii_code = 7'h33; // '3'
            8'h25: ascii_code = 7'h34; // '4'
            8'h2E: ascii_code = 7'h35; // '5'
            8'h36: ascii_code = 7'h36; // '6'
            8'h3D: ascii_code = 7'h37; // '7'
            8'h3E: ascii_code = 7'h38; // '8'
            8'h46: ascii_code = 7'h39; // '9'
            
            // Backspace
            8'h66: ascii_code = 7'h7F;
            
            // Enter
            8'h5A: ascii_code = 7'h0D;
            
            // Lower letters
            8'h1C: ascii_code = 7'h61; // 'a'
            8'h32: ascii_code = 7'h62; // 'b'
            8'h21: ascii_code = 7'h63; // 'c'
            8'h23: ascii_code = 7'h64; // 'd'
            8'h24: ascii_code = 7'h65; // 'e'
            8'h2B: ascii_code = 7'h66; // 'f'
            8'h34: ascii_code = 7'h67; // 'g'
            8'h33: ascii_code = 7'h68; // 'h'
            8'h43: ascii_code = 7'h69; // 'i'
            8'h3B: ascii_code = 7'h6A; // 'j'
            8'h42: ascii_code = 7'h6B; // 'k'
            8'h4B: ascii_code = 7'h6C; // 'l'
            8'h3A: ascii_code = 7'h6D; // 'm'
            8'h31: ascii_code = 7'h6E; // 'n'
            8'h44: ascii_code = 7'h6F; // 'o'
            8'h4D: ascii_code = 7'h70; // 'p'
            8'h15: ascii_code = 7'h71; // 'q'
            8'h2D: ascii_code = 7'h72; // 'r'
            8'h1B: ascii_code = 7'h73; // 's'
            8'h2C: ascii_code = 7'h74; // 't'
            8'h3C: ascii_code = 7'h75; // 'u'
            8'h2A: ascii_code = 7'h76; // 'v'
            8'h1D: ascii_code = 7'h77; // 'w'
            8'h22: ascii_code = 7'h78; // 'x'
            8'h35: ascii_code = 7'h79; // 'y'
            8'h1A: ascii_code = 7'h7A; // 'z'
            default: ascii_code = 7'h00; // Invalid or unmapped key
        endcase
    end
    else begin
        case (scan_code)
            // Digits
            8'h45: ascii_code = 7'h30; // '0'
            8'h16: ascii_code = 7'h31; // '1'
            8'h1E: ascii_code = 7'h32; // '2'
            8'h26: ascii_code = 7'h33; // '3'
            8'h25: ascii_code = 7'h34; // '4'
            8'h2E: ascii_code = 7'h35; // '5'
            8'h36: ascii_code = 7'h36; // '6'
            8'h3D: ascii_code = 7'h37; // '7'
            8'h3E: ascii_code = 7'h38; // '8'
            8'h46: ascii_code = 7'h39; // '9'
            
            // Backspace
            8'h66: ascii_code = 7'h7F;
            
            // Enter
            8'h5A: ascii_code = 7'h0D;
            
            // Uppercase letters
            8'h1C: ascii_code = 7'h41; // 'A'
            8'h32: ascii_code = 7'h42; // 'B'
            8'h21: ascii_code = 7'h43; // 'C'
            8'h23: ascii_code = 7'h44; // 'D'
            8'h24: ascii_code = 7'h45; // 'E'
            8'h2B: ascii_code = 7'h46; // 'F'
            8'h34: ascii_code = 7'h47; // 'G'
            8'h33: ascii_code = 7'h48; // 'H'
            8'h43: ascii_code = 7'h49; // 'I'
            8'h3B: ascii_code = 7'h4A; // 'J'
            8'h42: ascii_code = 7'h4B; // 'K'
            8'h4B: ascii_code = 7'h4C; // 'L'
            8'h3A: ascii_code = 7'h4D; // 'M'
            8'h31: ascii_code = 7'h4E; // 'N'
            8'h44: ascii_code = 7'h4F; // 'O'
            8'h4D: ascii_code = 7'h50; // 'P'
            8'h15: ascii_code = 7'h51; // 'Q'
            8'h2D: ascii_code = 7'h52; // 'R'
            8'h1B: ascii_code = 7'h53; // 'S'
            8'h2C: ascii_code = 7'h54; // 'T'
            8'h3C: ascii_code = 7'h55; // 'U'
            8'h2A: ascii_code = 7'h56; // 'V'
            8'h1D: ascii_code = 7'h57; // 'W'
            8'h22: ascii_code = 7'h58; // 'X'
            8'h35: ascii_code = 7'h59; // 'Y'
            8'h1A: ascii_code = 7'h5A; // 'Z'
    
            default: ascii_code = 7'h00; // Default: unmapped or invalid key
        endcase
    end 
end

endmodule
