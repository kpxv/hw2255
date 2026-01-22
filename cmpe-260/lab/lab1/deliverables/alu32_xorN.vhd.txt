----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry ap1498@rit.edu
-- 
-- Create Date: 01/19/2026 07:40:36 PM
-- Design Name: xorN
-- Module Name: xorN - behv
-- Project Name: alu32
-- Target Devices: Basys3 FPGA
-- Tool Versions: Vivado 2025.2
-- Description: N-bit XOR
-- 
-- Dependencies: 
-- 
-- Revision: 0.02 - Implemented
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xorN is
    GENERIC (N: INTEGER := 32);  -- input signal width
    PORT (
             A, B: IN std_logic_vector(N-1 downto 0);
             Y: OUT std_logic_vector(N-1 downto 0)
         );
end xorN;

architecture behv of xorN is
begin
    generateXOR: for i in 0 to N-1 generate
        Y(i) <= A(i) xor B(i);
    end generate generateXOR;
end behv;
