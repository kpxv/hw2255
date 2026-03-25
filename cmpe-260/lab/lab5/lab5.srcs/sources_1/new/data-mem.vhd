----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/24/2026 05:31:01 PM
-- Design Name:
-- Module Name: data_mem - behv
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

entity data_mem is
    generic (
        width      : integer := 32;
        addr_space : integer := 10
    );
    port (
        clk      : in    std_logic;
        w_en     : in    std_logic;
        addr     : in    std_logic_vector(addr_space - 1 downto 0);
        d_in     : in    std_logic_vector(width - 1 downto 0);
        switches : in    std_logic_vector(15 downto 0);

        d_out           : out   std_logic_vector(width - 1 downto 0);
        seven_seg_digit : out   std_logic_vector(15 downto 0)
    );
end entity data_mem;

architecture behv of data_mem is

    type memory is array(0 to 2 ** addr_space - 1) of std_logic_vector(width - 1 downto 0);

    signal mips_mem : memory := (others => (others => '0'));

begin

    write_proc : process (clk) is
    begin

        if rising_edge(clk) then
            if (w_en = '1') then
                mips_mem(to_integer(unsigned(addr))) <= d_in;
            end if;
        end if;

    end process write_proc;

    seg_proc : process (clk) is
    begin

        if rising_edge(clk) then
            if (to_integer(unsigned(addr)) = 16#3ff#) then
                if (w_en = '1') then
                    seven_seg_digit <= d_in(15 downto 0);
                end if;
            end if;
        end if;

    end process seg_proc;

    read_proc : process (clk) is
    begin

        if rising_edge(clk) then
            if (to_integer(unsigned(addr)) = 16#3fe#) then
                d_out <= (width - 1 downto width - 16 => '0') & switches;
            else
                d_out <= mips_mem(to_integer(unsigned(addr)));
            end if;
        end if;

    end process read_proc;

end architecture behv;
