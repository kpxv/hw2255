library ieee;
    use ieee.std_logic_1164.all;

entity p is
    generic (
        n : integer := 4
    );
    port (
        p : in    std_logic_vector(n downto 1);

        bigp : out   std_logic
    );
end entity p;

architecture behv of p is

    signal bigp_s : std_logic_vector(n downto 0);

begin

    bigp_s(0) <= '1';

    gen_bigp_l : for i in 1 to n generate
        bigp_s(i) <= p(i) and bigp_s(i - 1) after 1 ns;
    end generate gen_bigp_l;

    bigp <= bigp_s(n);

end architecture behv;
