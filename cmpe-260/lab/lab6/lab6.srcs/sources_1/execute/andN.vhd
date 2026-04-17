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

library ieee;
    use ieee.std_logic_1164.all;

entity andn is
    generic (
        n : integer := 32  -- width of signal
    );
    port (
        a : in    std_logic_vector(n - 1 downto 0);
        b : in    std_logic_vector(n - 1 downto 0);
        y : out   std_logic_vector(n - 1 downto 0)
    );
end entity andn;

architecture behv of andn is

begin

    generateand : for i in 0 to N - 1 generate
        Y(i) <= a(i) and b(i);
    end generate generateand;

end architecture behv;
