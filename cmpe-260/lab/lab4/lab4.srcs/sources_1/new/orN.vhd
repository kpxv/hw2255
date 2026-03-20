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

library ieee;
    use ieee.std_logic_1164.all;

entity orn is
    generic (
        n : integer := 32   -- input signal width
    );
    port (
        a : in    std_logic_vector(n - 1 downto 0);
        b : in    std_logic_vector(n - 1 downto 0);
        y : out   std_logic_vector(n - 1 downto 0)
    );
end entity orn;

architecture behv of orn is

begin

    generateor : for i in 0 to N - 1 generate
        Y(i) <= a(i) or b(i);
    end generate generateor;

end architecture behv;
