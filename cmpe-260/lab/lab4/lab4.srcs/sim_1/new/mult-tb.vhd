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
    constant n : integer := 32;

    type test_rec_t is record
        a_r : std_logic_vector(n / 2 - 1 downto 0);
        b_r : std_logic_vector(n / 2 - 1 downto 0);
        p_r : std_logic_vector(n - 1 downto 0);
    end record test_rec_t;

    type test_arr_t is array (natural range <>) of test_rec_t;

    constant test_rec_arr : test_arr_t :=
    (
        (
            a_r => std_logic_vector(to_unsigned(0, n / 2)),
            b_r => std_logic_vector(to_unsigned(0, n / 2)),
            p_r => std_logic_vector(to_unsigned(0, n))
        ),
        (
            a_r => std_logic_vector(to_unsigned(1, n / 2)),
            b_r => std_logic_vector(to_unsigned(0, n / 2)),
            p_r => std_logic_vector(to_unsigned(0, n))
        ),
        (
            a_r => std_logic_vector(to_unsigned(1, n / 2)),
            b_r => std_logic_vector(to_unsigned(1, n / 2)),
            p_r => std_logic_vector(to_unsigned(1, n))
        ),
        (
            a_r => std_logic_vector(to_unsigned(2, n / 2)),
            b_r => std_logic_vector(to_unsigned(2, n / 2)),
            p_r => std_logic_vector(to_unsigned(4, n))
        ),
        (
            a_r => std_logic_vector(to_unsigned(3, n / 2)),
            b_r => std_logic_vector(to_unsigned(8, n / 2)),
            p_r => std_logic_vector(to_unsigned(24, n))
        ),
        (
            a_r => std_logic_vector(to_unsigned(2 ** (n / 2) - 1, n / 2)),
            b_r => std_logic_vector(to_unsigned(2 ** (n / 2) - 1, n / 2)),
            p_r => std_logic_vector(to_unsigned((2 ** (n / 2) - 1) ** 2, n))
        ),
        (
            a_r => std_logic_vector(to_unsigned(2 ** (n / 2) - 1, n / 2)),
            b_r => std_logic_vector(to_unsigned(2 ** (n / 2) - 2, n / 2)),
            p_r => std_logic_vector(to_unsigned((2 ** (n / 2) - 1) * (2 ** (n / 2) - 2), n))
        ),
        (
            a_r => std_logic_vector(to_unsigned(8, n / 2)),
            b_r => std_logic_vector(to_unsigned(2, n / 2)),
            p_r => std_logic_vector(to_unsigned(16, n))
        ),
        (
            a_r => std_logic_vector(to_unsigned(8, n / 2)),
            b_r => std_logic_vector(to_unsigned(8, n / 2)),
            p_r => std_logic_vector(to_unsigned(64, n))
        ),
        (
            a_r => std_logic_vector(to_unsigned(10, n / 2)),
            b_r => std_logic_vector(to_unsigned(1, n / 2)),
            p_r => std_logic_vector(to_unsigned(10, n))
        ),
        (
            a_r => std_logic_vector(to_unsigned(16, n / 2)),
            b_r => std_logic_vector(to_unsigned(16, n / 2)),
            p_r => std_logic_vector(to_unsigned(256, n))
        ),
        (
            a_r => std_logic_vector(to_unsigned(3, n / 2)),
            b_r => std_logic_vector(to_unsigned(4, n / 2)),
            p_r => std_logic_vector(to_unsigned(12, n))
        )
    );

    signal a_s : std_logic_vector(n / 2 - 1 downto 0);
    signal b_s : std_logic_vector(n / 2 - 1 downto 0);
    signal p_s : std_logic_vector(n - 1 downto 0);
    signal clk : std_logic;

begin

    uut : entity work.mult(struct)
    generic map (
    n => n
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
                report "Case failed on test #" & integer'image(i)
                severity failure;

        end loop;

        wait until clk = '0';
        assert false
            severity failure;

    end process stim_proc;

end architecture behv;
