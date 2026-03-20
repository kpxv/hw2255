-------------------------------------------------
--  File:          aluTB.vhd
--
--  Entity:        aluTB
--  Architecture:  Testbench
--  Author:        Jason Blocklove
--  Created:       07/29/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                aluTB
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity alutb is
    generic (
        n : integer := 32
    );
end entity alutb;

architecture tb of alutb is

    component alu32 is
        port (
            a  : in    std_logic_vector(N - 1 downto 0);
            b  : in    std_logic_vector(N - 1 downto 0);
            op : in    std_logic_vector(3 downto 0);
            y  : out   std_logic_vector(N - 1 downto 0)
        );
    end component alu32;

    signal a  : std_logic_vector(n - 1 downto 0);
    signal b  : std_logic_vector(n - 1 downto 0);
    signal op : std_logic_vector(3 downto 0);
    signal y  : std_logic_vector(n - 1 downto 0);

    type alu_tests is record
        -- Test Inputs
        a  : std_logic_vector(31 downto 0);
        b  : std_logic_vector(31 downto 0);
        op : std_logic_vector(3 downto 0);
        -- Test Outputs
        y : std_logic_vector(31 downto 0);
    end record alu_tests;

    type test_array is array (natural range <>) of alu_tests;

    constant tests : test_array :=
    (
        -- Add / AddI / SW / LW
        (
            a  => x"00000001",
            b  => x"00000000",
            op => "0100",
            y  => x"00000001"
        ),
        (
            a  => x"FFFFFFFF",
            b  => x"00000001",
            op => "0100",
            y  => x"00000000"
        ),
        (
            a  => x"FFFFFFFF",
            b  => x"00000002",
            op => "0100",
            y  => x"00000001"
        ),
        (
            a  => x"7FFFFFFF",
            b  => x"00000001",
            op => "0100",
            y  => x"80000000"
        ),

        -- And / AndI
        (
            a  => x"00000001",
            b  => x"00000001",
            op => "1010",
            y  => x"00000001"
        ),
        (
            a  => x"00000001",
            b  => x"00000000",
            op => "1010",
            y  => x"00000000"
        ),
        (
            a  => x"00000001",
            b  => x"0000000F",
            op => "1010",
            y  => x"00000001"
        ),

        -- MultU
        (
            a  => x"00000001",
            b  => x"00000000",
            op => "0110",
            y  => x"00000000"
        ),
        (
            a  => x"00000003",
            b  => x"00000003",
            op => "0110",
            y  => x"00000009"
        ),
        (
            a  => x"00000001",
            b  => x"00000001",
            op => "0110",
            y  => x"00000001"
        ),

        -- Or / OrI
        (
            a  => x"00000001",
            b  => x"00000000",
            op => "1000",
            y  => x"00000001"
        ),
        (
            a  => x"00000000",
            b  => x"00000000",
            op => "1000",
            y  => x"00000000"
        ),
        (
            a  => x"00000010",
            b  => x"00000000",
            op => "1000",
            y  => x"00000010"
        ),

        -- Xor / XorI
        (
            a  => x"00000001",
            b  => x"00000000",
            op => "1011",
            y  => x"00000001"
        ),
        (
            a  => x"00000001",
            b  => x"00000001",
            op => "1011",
            y  => x"00000000"
        ),
        (
            a  => x"00000000",
            b  => x"00000000",
            op => "1011",
            y  => x"00000000"
        ),

        -- SLL
        (
            a  => x"00000001",
            b  => x"00000001",
            op => "1100",
            y  => x"00000002"
        ),
        (
            a  => x"11000001",
            b  => x"00000004",
            op => "1100",
            y  => x"10000010"
        ),
        (
            a  => x"00000001",
            b  => x"00000002",
            op => "1100",
            y  => x"00000004"
        ),

        -- SRA
        (
            a  => x"00001000",
            b  => x"00000004",
            op => "1110",
            y  => x"00000100"
        ),
        (
            a  => x"80001000",
            b  => x"00000004",
            op => "1110",
            y  => x"F8000100"
        ),
        (
            a  => x"00008000",
            b  => x"00000004",
            op => "1110",
            y  => x"00000800"
        ),

        -- SRL
        (
            a  => x"00001000",
            b  => x"00000004",
            op => "1101",
            y  => x"00000100"
        ),
        (
            a  => x"10001000",
            b  => x"00000004",
            op => "1101",
            y  => x"01000100"
        ),
        (
            a  => x"00008000",
            b  => x"00000004",
            op => "1101",
            y  => x"00000800"
        ),

        -- Sub
        (
            a  => x"00000001",
            b  => x"00000000",
            op => "0101",
            y  => x"00000001"
        ),
        (
            a  => x"00000002",
            b  => x"00000001",
            op => "0101",
            y  => x"00000001"
        ),
        (
            a  => x"80000000",
            b  => x"00000001",
            op => "0101",
            y  => x"7FFFFFFF"
        ),
        (
            a  => x"FFFFFFFF",
            b  => x"00000001",
            op => "0101",
            y  => x"FFFFFFFE"
        )
    );

begin

    alun_0 : component alu32
        port map (
            a  => a,
            b  => b,
            op => op,
            y  => y
        );

    stim_proc : process is
    begin

        -- Renamed from test_vector_array to tests, because the latter was
        -- declared and the former wasn't. I assume it was a typo.
        for i in tests'range loop

            a  <= tests(i).a;
            b  <= tests(i).b;
            op <= tests(i).op;

            wait for 100 ns;

            assert tests(i).y = y
                report "Edge case failed on test #" & integer'image(i)
                severity failure;

        end loop;

        assert false
            report "Testbench Concluded."
            severity failure;

    end process stim_proc;

end architecture tb;
