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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstrFetch is
    port (
             clk : in std_logic;
             rst : in std_logic;
             Instruction : out std_logic_vector(31 downto 0)
         );
end InstrFetch;

architecture struct of InstrFetch is
    signal addr : integer := 0;
    signal addr_vector : std_logic_vector(27 downto 0);
begin
    addr_vector <= std_logic_vector(to_unsigned(addr, 28));

    instr_mem : entity work.InstrMem
    port map (
                 addr => addr_vector,
                 d_out => Instruction
             );

    process (clk, rst)
    begin
        if rst = '1' then
            addr <= 0;
        elsif rising_edge(clk) then
            addr <= addr + 4;
        end if;
    end process;
end struct;
