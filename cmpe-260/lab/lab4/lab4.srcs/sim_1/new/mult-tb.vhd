----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/17/2026 10:37:46 PM
-- Design Name:
-- Module Name: mult_tb - behv
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

entity mult_tb is
end entity mult_tb;

architecture behv of mult_tb is
    type     test_rec_t is record
        a_r : std_logic_vector(15 downto 0);
        b_r : std_logic_vector(15 downto 0);
        p_r : std_logic_vector(31 downto 0);
    end record test_rec_t;

    type     test_arr_t is array (natural range <>) of test_rec_t;

    constant test_rec_arr : test_arr_t :=
    (
        (
            a_r => x"0000",
            b_r => x"0000",
            p_r => x"00000000"
        ),
        (
            a_r => x"0001",
            b_r => x"0000",
            p_r => x"00000000"
        ),
        (
            a_r => x"0001",
            b_r => x"0001",
            p_r => x"00000001"
        ),
        (
            a_r => x"0002",
            b_r => x"0002",
            p_r => x"00000004"
        ),
        (
            a_r => x"0003",
            b_r => x"0008",
            p_r => x"00000018"
        ),
        (
            a_r => x"FFFF",
            b_r => x"FFFF",
            p_r => x"FFFE0001"
        ),
        (
            a_r => x"FFFF",
            b_r => x"FFFE",
            p_r => x"FFFD0002"
        ),
        (
            a_r => x"0008",
            b_r => x"0002",
            p_r => x"00000010"
        ),
        (
            a_r => x"0008",
            b_r => x"0008",
            p_r => x"00000040"
        ),
        (
            a_r => x"000A",
            b_r => x"0001",
            p_r => x"0000000A"
        ),
        (
            a_r => x"0010",
            b_r => x"0010",
            p_r => x"00000100"
        ),
        (
            a_r => x"0003",
            b_r => x"0004",
            p_r => x"0000000C"
        )
    );

    signal   a_s          : std_logic_vector(15 downto 0);
    signal   b_s          : std_logic_vector(15 downto 0);
    signal   p_s          : std_logic_vector(31 downto 0);
    signal   clk          : std_logic;
begin
    uut : entity work.mult(struct)
        port map (
            a       => a_s,
            b       => b_s,
            product => p_s
        );

    clk_proc : process is
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process clk_proc;

    stim_proc : process is
    begin
        for i in test_rec_arr'range loop
            wait until clk = '1';
            a_s <= test_rec_arr(i).a_r;
            b_s <= test_rec_arr(i).b_r;

            wait until clk = '0';

            assert test_rec_arr(i).p_r = p_s
                report "Case failed on test #" & integer'image(i)
                severity failure;
        end loop;

        wait until clk = '0';
        assert false
            severity failure;
    end process stim_proc;
end architecture behv;
