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
        -- addi $t0, $t0, 0xff
        x"000000FF",
        -- addi t1 t0 0x1
        x"00000100",
        -- ori t2 t2 0xac
        x"000000AC",
        -- andi t2 t2 0xa0
        x"000000A0",
        -- xori t2 t2 0xac
        x"0000000C",
        -- sw t0, 4($0)
        x"00000004", -- Placeholder
        -- lw t3, 4($0)
        x"00000004", -- Placeholder
        -- addi t3 t3 0x0
        x"000000FF",
        -- add t0, t0, t1
        x"000001FF",
        -- and t0, t0, t1
        x"00000100",
        -- multu t0 t0 $0
        x"00000000",
        -- or t1 t1 t0
        x"00000100",
        -- sll t1 t1 t2
        x"00100000",
        -- srl t1 t1 t2
        x"00000100",
        -- addi t0 $0 0x17
        x"00000017",
        -- sll t1 t0 t1
        x"80000000",
        -- sra t1 t0 t1
        x"FFFFFF00",
        -- sub t0 t0 t2
        x"0000000B",
        -- xor t0 t0 t2
        x"00000007"

        -- Start Fibonacci
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
            clk      => clk_s,
            rst      => rst_s,
            switches => (others => '0'),
            alu_out  => alu_s
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

            -- TEST
            assert test_s = alu_s
                report "Failed case " & integer'image(i)
                severity failure;

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

        for i in 0 to 1000 loop

            clk_s <= '0';
            wait for 50 ns;
            clk_s <= '1';
            wait for 50 ns;

        end loop;

        assert false
            report "Passed tests"
            severity failure;

    end process proc_clk_l;

end architecture struct;
