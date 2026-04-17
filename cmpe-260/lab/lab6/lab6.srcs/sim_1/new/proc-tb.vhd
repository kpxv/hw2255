library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.globals.all;

entity proc_tb is
end entity proc_tb;

architecture struct of proc_tb is

    type test_array_t is array (natural range <>) of std_logic_vector(n - 1 downto 0);

    constant test_array : test_array_t :=
    (
        -- addi $t1, $0, 0xff
        x"000000FF",
        -- addi $t2, $0, 0x2
        x"00000002",
        -- sll $t1, $t1, $t2
        x"000003F0",
        -- addi $t1, $t1, 0x2
        x"000003FE",
        -- lw $t0, 0x0($t1)
        x"00000004",
        -- addi $t0, $t0, 0x01
        x"00000001",
        -- sll $t0, $t0, $t2
        x"00000004",
        -- sw $t0, 0x1($t1)
        x"00000004"

    );

    signal clk_s  : std_logic;
    signal rst_s  : std_logic;
    signal alu_s  : std_logic_vector(n - 1 downto 0);
    signal test_s : std_logic_vector(n - 1 downto 0);

begin

    uut : entity work.proc(struct)
        generic map (
            n          => n,
            logn       => logn,
            op_len     => op_len,
            addr_space => addr_space
        )
        port map (
            clk_in   => clk_s,
            rst      => rst_s,
            switches => std_logic_vector(to_unsigned(7, 16))
        );

    proc_clk_l : process is
    begin

        rst_s <= '1';
        clk_s <= '0';
        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;

        rst_s <= '0';
        clk_s <= '0';
        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;

        clk_l : for i in test_array'range loop

            test_s <= test_array(i);
            clk_s  <= '0';
            wait for 50 ns;
            clk_s  <= '1';
            wait for 50 ns;

            clk_s <= '0';
            wait for 50 ns;
            clk_s <= '1';
            wait for 50 ns;

            clk_s <= '0';
            wait for 50 ns;

            -- -- TEST
            -- assert test_s = alu_s
            --     report "Failed case " & integer'image(i)
            --     severity failure;

            clk_s <= '1';
            wait for 50 ns;

            clk_s <= '0';
            wait for 50 ns;
            clk_s <= '1';
            wait for 50 ns;

            clk_s <= '0';
            wait for 50 ns;
            clk_s <= '1';
            wait for 50 ns;

        end loop clk_l;

        assert false
            report "Passed tests"
            severity failure;

    end process proc_clk_l;

end architecture struct;
