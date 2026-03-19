library ieee;
    use ieee.std_logic_1164.all;

entity pg is
    generic (
        bign : integer := 32
    );
    port (
        a : in    std_logic_vector(bign downto 1);
        b : in    std_logic_vector(bign downto 1);

        p : out   std_logic_vector(bign downto 1);
        g : out   std_logic_vector(bign downto 1)
    );
end entity pg;

architecture behv of pg is

    signal ab_s : std_logic_vector(bign downto 0);
    signal pg_s : std_logic_vector(bign downto 0);

    signal p_s : std_logic_vector(bign downto 0);
    signal g_s : std_logic_vector(bign downto 0);

begin

    p_s(0) <= '0';
    g_s(0) <= '0';

    gen_p_l : for i in 1 to bign generate
        p_s(i) <= a(i) xor b(i) after 3 ns;
        p(i)   <= p_s(i);
    end generate gen_p_l;

    gen_g_l : for i in 1 to bign generate
        ab_s(i) <= a(i) and b(i) after 1 ns;
        pg_s(i) <= p_s(i) and g_s(i - 1) after 1 ns;
        g_s(i)  <= ab_s(i) or pg_s(i) after 2 ns;
        g(i)    <= g_s(i);
    end generate gen_g_l;

end architecture behv;
