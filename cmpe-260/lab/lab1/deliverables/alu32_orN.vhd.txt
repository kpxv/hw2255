----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry ap1498@rit.edu
-- 
-- Create Date: 01/19/2026 07:40:36 PM
-- Design Name: orN
-- Module Name: orN - behv
-- Project Name: alu32
-- Target Devices: Basys3 FPGA
-- Tool Versions: Vivado 2025.2
-- Description: N-bit logical OR
-- 
-- Dependencies: 
-- 
-- Revision: 0.02 - Logical OR applied
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity orN is
    GENERIC (N: INTEGER := 32);   -- input signal width
    PORT (
             A, B: IN std_logic_vector(N-1 downto 0);
             Y: OUT std_logic_vector(N-1 downto 0)
         );
end orN;

architecture behv of orN is
begin
    generateOR: for i in 0 to N-1 generate
        Y(i) <= A(i) or B(i);
    end generate generateOR;
end behv;
