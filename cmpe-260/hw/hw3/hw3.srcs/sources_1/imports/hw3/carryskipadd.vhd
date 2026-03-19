library ieee;
    use ieee.std_logic_1164.all;

entity carryskipadd is
    generic (
        n    : integer := 4;
        k    : integer := 4;
        bign : integer := 16
    );
    port (
        a   : in    std_logic_vector(bign downto 1);
        b   : in    std_logic_vector(bign downto 1);
        cin : in    std_logic;

        s    : out   std_logic_vector(bign downto 1);
        cout : out   std_logic
    );
end entity carryskipadd;

architecture struct of carryskipadd is

    type n_arr_t is array (1 to k) of std_logic_vector(n downto 1);

    signal pn_s   : n_arr_t;
    signal bigp_s : std_logic_vector(k downto 1);

    signal bigg_s : std_logic_vector(bign downto 0); -- Final, correct, fast value for g
    signal aog_s  : std_logic_vector(bign downto 1); -- What ao calculates for g based on bigg
    signal muxg_s : std_logic_vector(k downto 1);    -- What mux calculates for group edge g's based of aog and bigg

    signal p_s : std_logic_vector(bign downto 1);
    signal g_s : std_logic_vector(bign downto 1);

begin

    bigg_s(0) <= cin;

    -- Find bitwise prop/gen
    pg_inst : entity work.pg(behv)
        generic map (
            bign => bign
        )
        port map (
            a => a,
            b => b,
            p => p_s,
            g => g_s
        );

    gen_ao_l : for i in 1 to bign generate

        ao_inst : entity work.ao(behv)
            port map (
                g         => g_s(i),
                p         => p_s(i),
                bigg_prev => bigg_s(i - 1),
                bigg      => aog_s(i)
            );

    end generate gen_ao_l;

    gen_kgroups_l : for i in 1 to k generate

        gen_nbits_l : for j in 1 to n generate
            pn_s(i)(j) <= p_s(j + n * (i - 1));

            gen_mux2_l : if j = n generate

                mux2_inst : entity work.mux2(df)
                    port map (
                        s => bigp_s(i),
                        a => aog_s(j * i),
                        b => bigg_s(j * i - n),
                        y => muxg_s(i)
                    );

            end generate gen_mux2_l;

            -- Current G val is the result of the mux if at group edge, else the result of AO.
            bigg_s(j + n * (i - 1)) <= aog_s(j + n * (i - 1)) when j /= n else
                                       muxg_s(i);

        end generate gen_nbits_l;

        p_inst : entity work.p(behv)
            generic map (
                n => n
            )
            port map (
                p    => pn_s(i),
                bigp => bigp_s(i)
            );

    end generate gen_kgroups_l;

    sum_inst : entity work.sum(behv)
        generic map (
            bign => bign
        )
        port map (
            p         => p_s,
            bigg_prev => bigg_s(bign - 1 downto 0),
            s         => s
        );

    cout <= bigg_s(bign);

end architecture struct;
