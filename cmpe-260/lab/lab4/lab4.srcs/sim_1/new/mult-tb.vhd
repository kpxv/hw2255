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
    use ieee.math_real.all;

entity mult_tb is
end entity mult_tb;

architecture behv of mult_tb is

    constant n : integer := 6;
    -- Find n ceiling divide 2. VHDL ints get truncated, so add 1 to get ceiling
    constant halfn : integer := (n + 1) / 2;

    type test_rec_t is record
        a_r : std_logic_vector(halfn - 1 downto 0);
        b_r : std_logic_vector(halfn - 1 downto 0);
        p_r : std_logic_vector(n - 1 downto 0);
    end record test_rec_t;

    type test_arr_t is array (natural range <>) of test_rec_t;

    constant test_rec_arr : test_arr_t :=
    (
        (
            -- 0 * 0 = 0
            a_r => (others => '0'),
            b_r => (others => '0'),
            p_r => (others => '0')
        ),
        (
            -- 1 * 0 = 0
            a_r => (0 => '1', others => '0'),
            b_r => (others => '0'),
            p_r => (others => '0')
        ),
        (
            -- 1 * 1 = 1
            a_r => (0 => '1', others => '0'),
            b_r => (0 => '1', others => '0'),
            p_r => (0 => '1', others => '0')
        ),
        (
            -- 2 * 2 = 4
            a_r => (1 => '1', others => '0'),
            b_r => (1 => '1', others => '0'),
            p_r => (2 => '1', others => '0')
        ),
        -- (
        --     -- 3 * 8 = 24
        --     a_r => (1 downto 0 => '1', others => '0'),
        --     b_r => (3 => '1', others => '0'),
        --     p_r => (4 downto 3 => '1', others => '0')
        -- ),
        (
            -- 0xFF..F * 0xFF..F = 0xFF..FE 00..01
            a_r => (others => '1'),
            b_r => (others => '1'),
            p_r => (halfn downto 1 => '0', others => '1')
        ),
        (
            -- 0xFF..F * 0xFF..FE = FF..FD 00.02
            a_r => (others => '1'),
            b_r => (0 => '0', others => '1'),
            p_r => (halfn + 1 => '0', halfn - 1 downto 2 => '0', 0 => '0', others => '1')
        ),
        -- (
        --     -- 8 * 2 = 16
        --     a_r => (3 => '1', others => '0'),
        --     b_r => (1 => '1', others => '0'),
        --     p_r => (4 => '1', others => '0')
        -- ),
        -- (
        --     -- 8 * 8 = 64
        --     a_r => (3 => '1', others => '0'),
        --     b_r => (3 => '1', others => '0'),
        --     p_r => (6 => '1', others => '0')
        -- ),
        -- (
        --     -- 10 * 1 = 10
        --     a_r => (3 => '1', 1 => '1', others => '0'),
        --     b_r => (0 => '1', others => '0'),
        --     p_r => (3 => '1', 1 => '1', others => '0')
        -- ),
        -- (
        --     -- 16 * 16 = 256
        --     a_r => (4 => '1', others => '0'),
        --     b_r => (4 => '1', others => '0'),
        --     p_r => (8 => '1', others => '0')
        -- ),
        (
            -- 3 * 4 = 12
            a_r => (1 downto 0 => '1', others => '0'),
            b_r => (2 => '1', others => '0'),
            p_r => (3 downto 2 => '1', others => '0')
        )
    );

    signal a_s : std_logic_vector(halfn - 1 downto 0);
    signal b_s : std_logic_vector(halfn - 1 downto 0);
    signal p_s : std_logic_vector(n - 1 downto 0);
    signal clk : std_logic;

begin

    uut : entity work.mult(struct)
        generic map (
            n => n,
            halfn => halfn
        )
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
                report "Case failed on test #" & integer'image(i) &
                       ". Inputs: 0x" & to_hstring(a_s) & " and 0x" & to_hstring(b_s) &
                       ". Expected: 0x" & to_hstring(test_rec_arr(i).p_r) &
                       ". Got: 0x" & to_hstring(p_s) & ".";

        end loop;

        wait until clk = '0';
        assert false
            report "Testbench conluded."
            severity failure;

    end process stim_proc;

end architecture behv;
