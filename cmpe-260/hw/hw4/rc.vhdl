library ieee;
    use ieee.std_logic_1164.all;

entity rc is
    port (
        clk : in    std_logic;
        a   : in    std_logic_vector(31 downto 0);
        b   : in    std_logic_vector(31 downto 0);
        s   : out   std_logic_vector(31 downto 0)
    );
end entity rc;

architecture struct of rc is

    type reg_t is array(0 to 3) of std_logic_vector(31 downto 0);

    signal s_reg_s : reg_t;
    signal c_reg_s : reg_t;

begin

    fadd0_inst : entity work.fadd(df)
        port map (
            a    => a(0),
            b    => b(0),
            cin  => '0',
            y    => s_reg_s(0)(0),
            cout => c_reg_s(0)(0)
        );

    stage0_l : for i in 1 to 7 generate

        fadd1_inst : entity work.fadd(df)
            port map (
                a    => a(i),
                b    => b(i),
                cin  => c_reg_s(0)(i - 1),
                y    => s_reg_s(0)(i),
                cout => c_reg_s(0)(i)
            );

    end generate stage0_l;

    stage1_l : for i in 8 to 15 generate

        fadd1_inst : entity work.fadd(df)
            port map (
                a    => a(i),
                b    => b(i),
                cin  => c_reg_s(1)(i - 1),
                y    => s_reg_s(1)(i),
                cout => c_reg_s(1)(i)
            );

    end generate stage1_l;

    stage2_l : for i in 16 to 23 generate

        fadd1_inst : entity work.fadd(df)
            port map (
                a    => a(i),
                b    => b(i),
                cin  => c_reg_s(2)(i - 1),
                y    => s_reg_s(2)(i),
                cout => c_reg_s(2)(i)
            );

    end generate stage2_l;

    stage3_l : for i in 24 to 31 generate

        fadd1_inst : entity work.fadd(df)
            port map (
                a    => a(i),
                b    => b(i),
                cin  => c_reg_s(3)(i - 1),
                y    => s_reg_s(3)(i),
                cout => c_reg_s(3)(i)
            );

    end generate stage3_l;

    reg0_proc : process (clk) is
    begin

        if rising_edge(clk) then
            s          <= s_reg_s(3);
            s_reg_s(3) <= s_reg_s(2);
            s_reg_s(2) <= s_reg_s(1);
            s_reg_s(1) <= s_reg_s(0);
        end if;

    end process reg0_proc;

end architecture struct;
