----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/19/2026 12:15:17 AM
-- Design Name:
-- Module Name: carryskipadd_tb - behv
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

entity carryskipadd_tb is
end entity carryskipadd_tb;

architecture behv of carryskipadd_tb is

    constant bign : integer := 16;
    constant n    : integer := 4;
    constant k    : integer := 4;

    type test_t is record
        a    : std_logic_vector(bign - 1 downto 0);
        b    : std_logic_vector(bign - 1 downto 0);
        cin  : std_logic;
        s    : std_logic_vector(bign - 1 downto 0);
        cout : std_logic;
    end record test_t;

    type test_arr_t is array (natural range <>) of test_t;

    constant tests : test_arr_t :=
    (
        (
            a    => x"FFFF",
            b    => x"0000",
            cin  => '1',
            s    => x"0000",
            cout => '1'
        ),
        (
            a    => x"C000",
            b    => x"8000",
            cin  => '1',
            s    => x"4001",
            cout => '1'
        )
    );

    signal a_s    : std_logic_vector(bign - 1 downto 0);
    signal b_s    : std_logic_vector(bign - 1 downto 0);
    signal cin_s  : std_logic;
    signal s_s    : std_logic_vector(bign - 1 downto 0);
    signal cout_s : std_logic;

begin

    adder_inst : entity work.carryskipadd(struct)
        generic map (
            bign => bign,
            n    => n,
            k    => k
        )
        port map (
            a    => a_s,
            b    => b_s,
            cin  => cin_s,
            s    => s_s,
            cout => cout_s
        );

    stim_proc : process is
    begin

        for i in tests'range loop

            a_s   <= tests(i).a;
            b_s   <= tests(i).b;
            cin_s <= tests(i).cin;

            wait for 100 ns;

            assert tests(i).s = s_s
                report "Failure on test #" & integer'image(i)
                severity failure;

            assert tests(i).cout = cout_s
                report "Failure on test #" & integer'image(i)
                severity failure;

        end loop;

        assert false
            report "Testbench passed"
            severity failure;

    end process stim_proc;

end architecture behv;
