----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry
--
-- Create Date: 03/24/2026 07:29:28 PM
-- Design Name: Data Memory Testbench
-- Module Name: data_mem_tb - behv
-- Project Name: Memory Stage
-- Target Devices: Basys3 FPGA
-- Tool Versions: VHDL 2008
-- Description: Tests the data memory functionality of the MIPS memory stage
--
-- Dependencies: IEEE libs
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity data_mem_tb is
    generic (
        width      : integer := 32;
        addr_space : integer := 10
    );
end entity data_mem_tb;

architecture behv of data_mem_tb is

    signal clk_s, w_en_s : std_logic;
    signal addr_s        : std_logic_vector(addr_space - 1 downto 0);
    signal d_in_s        : std_logic_vector(width - 1 downto 0);
    signal switches_s    : std_logic_vector(15 downto 0);
    signal d_out_s       : std_logic_vector(width - 1 downto 0);
    signal seven_seg_s   : std_logic_vector(15 downto 0);

begin

    uut : entity work.data_mem(behv)
        generic map (
            width      => width,
            addr_space => addr_space
        )
        port map (
            clk             => clk_s,
            w_en            => w_en_s,
            addr            => addr_s,
            d_in            => d_in_s,
            switches        => switches_s,
            d_out           => d_out_s,
            seven_seg_digit => seven_seg_s
        );

    clk_proc : process is
    begin

        clk_s <= '0';
        wait for 20 ns;
        clk_s <= '1';
        wait for 20 ns;

    end process clk_proc;

    -- Modified clock cycle alignment from Verilog to improve test bench design
    stim_proc : process is
    begin

        -- Write data to 0x1b and 0x1c
        wait until clk_s = '0';
        w_en_s <= '1';
        addr_s <= "00" & x"1B";
        d_in_s <= x"AAAA5555";

        wait until clk_s = '0';
        addr_s <= "00" & x"1C";
        d_in_s <= x"5555AAAA";

        -- Ensure both are readable
        wait until clk_s = '0';
        w_en_s <= '0';
        addr_s <= "00" & x"1B";
        wait until clk_s = '0';
        assert d_out_s = x"AAAA5555"
            report "Fail test #1"
            severity failure;

        addr_s <= "00" & x"1C";
        wait until clk_s = '0';
        assert d_out_s = x"5555AAAA"
            report "Fail test #2"
            severity failure;

        -- Ensure reading from 0x3fe gets switch data
        w_en_s     <= '0';
        switches_s <= x"1111";
        addr_s     <= "11" & x"FE";
        wait until clk_s = '0';
        assert d_out_s = x"00001111"
            report "Fail test #3"
            severity failure;

        -- Ensure writing to 0x3ff sends data to display
        w_en_s <= '1';
        addr_s <= "11" & x"FF";
        d_in_s <= x"00003333";
        wait until clk_s = '0';
        assert seven_seg_s = x"3333"
            report "Fail test #4"
            severity failure;

        assert false
            report "Passed"
            severity failure;

    end process stim_proc;

end architecture behv;
