library ieee;
    use ieee.std_logic_1164.all;

entity mux2 is
    port (
        s : in    std_logic;
        a : in    std_logic;
        b : in    std_logic;

        y : out   std_logic
    );
end entity mux2;

architecture df of mux2 is

    signal as_s   : std_logic;
    signal nots_s : std_logic;
    signal bs_s   : std_logic;
    signal ab_s   : std_logic;

begin

    as_s   <= a and s after 1 ns;
    nots_s <= not s;
    bs_s   <= b and nots_s after 1 ns;
    ab_s   <= as_s or bs_s after 2 ns;
    y      <= ab_s;

end architecture df;
