----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry ap1498@rit.edu
-- 
-- Create Date: 01/19/2026 07:40:36 PM
-- Design Name: andN
-- Module Name: andN - behv
-- Project Name: alu32
-- Target Devices: Basys3 FPGA
-- Tool Versions: Vivado 2025.2
-- Description: N-bit logical AND
-- 
-- Dependencies: 
-- 
-- Revision: 0.02 - Logical AND applied
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity andN is
    GENERIC (N: INTEGER := 32);  -- width of signal
    PORT (
             A, B: IN std_logic_vector(N-1 downto 0);
             Y: OUT std_logic_vector(N-1 downto 0)
         );
end andN;

architecture behv of andN is
begin
    generateAND: for i in 0 to N-1 generate
        Y(i) <= A(i) and B(i);
    end generate generateAND;
end behv;
