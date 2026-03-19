library ieee;
    use ieee.std_logic_1164.all;

entity ao is
    port (
        g         : in    std_logic;
        p         : in    std_logic;
        bigg_prev : in    std_logic;

        bigg : out   std_logic
    );
end entity ao;

architecture behv of ao is

    signal biggp_s : std_logic;

begin

    biggp_s <= bigg_prev and p after 1 ns;
    bigg    <= biggp_s or g after 2 ns;

end architecture behv;
