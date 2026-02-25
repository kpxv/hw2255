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
    signal addr        : integer := 0;
    signal addr_vector : std_logic_vector(27 downto 0);
begin
    addr_vector <= std_logic_vector(to_unsigned(addr, 28));

    instr_mem : entity work.instrmem(behv)
        port map (
            addr  => addr_vector,
            d_out => instruction
        );

    inc_pc_proc : process (clk, rst) is
    begin
        if (rst = '1') then
            addr <= 0;
        elsif rising_edge(clk) then
            addr <= addr + 4;
        end if;
    end process inc_pc_proc;
end architecture struct;
