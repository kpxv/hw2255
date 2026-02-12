library ieee;
use ieee.std_logic_1164.all;

entity tb is
end tb;

architecture arch of tb is
    component q3
        port (
                c, en, rst, clk : in std_logic;
                y : out std_logic_vector(2 downto 0)
        );
    end component;
    signal c_s, en_s, rst_s, clk_s : std_logic;
    signal y_s : std_logic_vector(2 downto 0);
begin
    labl: q3 port map (c => c_s, en => en_s, rst => rst_s, clk => clk_s, y => y_s);

    process
    begin
        rst_s <= '1';
        c_s <= '1';
        en_s <= '0';

        -- Hold for 1 cycle
        clk_s <= '0';
        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;

        -- Increment 8 times
        en_s <= '1';

        for i in 0 to 7 loop
            clk_s <= '0';
            wait for 50 ns;
            clk_s <= '1';
            wait for 50 ns;
        end loop;

        -- Hold for 1 cycle
        en_s <= '0';

        clk_s <= '0';
        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;

        -- Decrement 4 times
        c_s <= '0';
        en_s <= '1';

        for i in 0 to 3 loop
            clk_s <= '0';
            wait for 50 ns;
            clk_s <= '1';
            wait for 50 ns;
        end loop;

        -- Hold for 1 cycle
        en_s <= '0';

        clk_s <= '0';
        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;

        -- Test reset
        rst_s <= '0';

        clk_s <= '0';
        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;

        assert false severity failure;
    end process;
end arch;
