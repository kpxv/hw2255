----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 02/24/2026 06:25:03 PM
-- Design Name:
-- Module Name: InstrFetch - struct
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity instrfetch is
    port (
        clk         : in    std_logic;
        rst         : in    std_logic;
        instruction : out   std_logic_vector(31 downto 0)
    );
end entity instrfetch;

architecture struct of instrfetch is
    signal addr_int_s        : integer := 0;
    signal addr_vector_s     : std_logic_vector(27 downto 0);
begin
    -- Sync vector and integer representations
    addr_vector_s <= std_logic_vector(to_unsigned(addr_int_s, 28));

    -- Use the Memory module
    instr_mem : entity work.instrmem(behv)
        port map (
            addr  => addr_vector_s,
            d_out => instruction
        );

    -- Increment the program counter
    incr_addr_proc : process (clk, rst) is
    begin
        if (rst = '1') then
            addr_int_s <= 0;
        elsif rising_edge(clk) then
            addr_int_s <= addr_int_s + 4;
        end if;
    end process incr_addr_proc;
end architecture struct;
