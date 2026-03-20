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

library ieee;
    use ieee.std_logic_1164.all;

entity xorn is
    generic (
        n : integer := 32  -- input signal width
    );
    port (
        a : in    std_logic_vector(n - 1 downto 0);
        b : in    std_logic_vector(n - 1 downto 0);
        y : out   std_logic_vector(n - 1 downto 0)
    );
end entity xorn;

architecture behv of xorn is

begin

    generatexor : for i in 0 to N - 1 generate
        Y(i) <= a(i) xor b(i);
    end generate generatexor;

end architecture behv;
