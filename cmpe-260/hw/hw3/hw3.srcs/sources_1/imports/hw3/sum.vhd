library ieee;
    use ieee.std_logic_1164.all;

entity sum is
    generic (
        bign : integer := 32
    );
    port (
        p         : in    std_logic_vector(bign downto 1);
        bigg_prev : in    std_logic_vector(bign - 1 downto 0);

        s : out   std_logic_vector(bign downto 1)
    );
end entity sum;

architecture behv of sum is

begin

    gen_sum_l : for i in 1 to bign generate
        s(i) <= p(i) xor bigg_prev(i - 1) after 3 ns;
    end generate gen_sum_l;

end architecture behv;
