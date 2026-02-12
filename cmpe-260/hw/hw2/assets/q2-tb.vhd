library ieee;
use ieee.std_logic_1164.all;

entity tb is
end tb;

architecture arch of tb is
    constant n : integer := 4;
    component q2
        port (
                 din : in std_logic;
                 clk : in std_logic;
                 lr : in std_logic;
                 mode : in std_logic;
                 d : in std_logic_vector(n-1 downto 0);
                 dout : out std_logic;
                 q : out std_logic_vector(n-1 downto 0)
             );
    end component;
    signal din_s, clk_s, lr_s, mode_s, dout_s : std_logic := '0';
    signal d_s, q_s : std_logic_vector(n-1 downto 0) := (others => '0');
begin
    labl: q2 port map (din => din_s, clk => clk_s, lr => lr_s, mode => mode_s, d => d_s, dout => dout_s, q => q_s);
    process
    begin
        lr_s <= '0';
        mode_s <= '0';
        d_s <= "1010";

        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;
        clk_s <= '0';

        lr_s <= '1';
        mode_s <= '0';
        din_s <= '1';

        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;
        clk_s <= '0';
        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;
        clk_s <= '0';

        lr_s <= '1';
        mode_s <= '1';

        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;
        clk_s <= '0';

        lr_s <= '0';
        mode_s <= '1';
        din_s <= '0';

        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;
        clk_s <= '0';
        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;
        clk_s <= '0';

        lr_s <= '1';
        mode_s <= '1';

        wait for 50 ns;
        clk_s <= '1';
        wait for 50 ns;
        clk_s <= '0';

        assert false severity failure;
    end process;
end arch;
