library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity tb is
end entity tb;

architecture behv of tb is
    signal a_s : std_logic_vector(31 downto 0);
    signal b_s : std_logic_vector(31 downto 0);
    signal s_s : std_logic_vector(31 downto 0);
    signal clk_s : std_logic;
begin

    uut : entity work.rc(struct)
    port map(
    clk => clk_s,
    a => a_s,
    b => b_s,
    s => s_s
);

stim_proc : process (all) is
begin
    clk_s <= '0';
    a_s <= x"00000000";
    b_s <= x"00000010";
end process stim_proc;

end architecture behv;
