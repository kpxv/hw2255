----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry ap1498@rit.edu
-- 
-- Create Date: 01/19/2026 07:40:36 PM
-- Design Name: globals
-- Module Name: globals
-- Project Name: alu32
-- Target Devices: Basys3 FPGA
-- Tool Versions: Vivado 2025.2
-- Description: Globals for generates
-- 
-- Dependencies: 
-- 
-- Revision: 0.02 - Added N, M, O
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
package globals is
    constant N : INTEGER := 32; -- Bit length of inputs
    constant M : INTEGER := 5;  -- log_2 of N
    constant O : INTEGER := 4;  -- Bit length of OP CODE
end;
