----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry ap1498@rit.edu
--
-- Create Date: 01/19/2026 07:40:36 PM
-- Design Name: sllN
-- Module Name: sllN - behv
-- Project Name: alu32
-- Target Devices: Basys3 FPGA
-- Tool Versions: Vivado 2025.2
-- Description: N-bit SLL
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
    use ieee.numeric_std.all;

entity slln is
    generic (
        n : integer := 32; -- bit width
        m : integer := 5   -- shift bits
    );
    port (
        a         : in    std_logic_vector(n - 1 downto 0);
        shift_amt : in    std_logic_vector(m - 1 downto 0);
        y         : out   std_logic_vector(n - 1 downto 0)
    );
end entity slln;

architecture behv of slln is

    -- create array of vectors to hold each of n shifters

    type shifty_array is array(N - 1 downto 0) of std_logic_vector(N - 1 downto 0);

    signal asll : shifty_array;

begin

    generatesll : for i in 0 to N - 1 generate
        asll(i)(N - 1 downto i) <= a(n - 1 - i downto 0);

        left_fill : if i > 0 generate
            asll(i)(i - 1 downto 0) <= (others => '0');
        end generate left_fill;

    end generate generatesll;

    -- The value of shift_amt (in binary) determines number of bits A is shifted.
    -- Since shift_amt (in decimal) must not exceed n-1 so only M bits are used. The default or N=4,
    -- will require 2 shift bits (M=2), because 2^2 = 4, the maximum shift.
    -- In all cases, 2^m = N.
    y <= asll(to_integer(unsigned(shift_amt)));

end architecture behv;
