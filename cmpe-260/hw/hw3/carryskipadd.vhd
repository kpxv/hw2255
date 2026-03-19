library ieee;
    use ieee.std_logic_1164.all;

entity carryskipadd is
    generic (
        n    : integer := 4;
        k    : integer := 8;
        bign : integer := 32
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

    signal c_s : std_logic_vector(bign downto 0);

    signal an_s : std_logic_vector(n downto 1);
    signal bn_s : std_logic_vector(n downto 1);

    signal p_s : std_logic_vector(bign downto 1);
    signal g_s : std_logic_vector(bign downto 1);

begin

    c_s(0) <= cin;

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

    gen_kgroups_l : for i in 1 to k generate

        gen_nbits_l : for i in 1 to n generate
            an_s(i) <= a(i + n * (k - 1));
            bn_s(i) <= b(i + n * (k - 1));
        end generate gen_nbits_l;

    end generate gen_kgroups_l;

end architecture struct;
