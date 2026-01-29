library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb is
end tb;

architecture arch of tb is
    constant N : integer := 2;
    constant delay : time := 20 ns;
    signal a : std_logic_vector(N - 1 downto  0);
    signal q : std_logic_vector(2**N - 2 downto 0);
begin
    therm: entity work.thermN
    generic map(N => N)
    port map(a => a, q => q);

             test: process is
             begin
                 for i in 0 to 2**N - 1 loop
                     a <= std_logic_vector(to_unsigned(i, a'length));
                     wait for delay;
                 end loop;
                 assert false severity failure;
             end process test;

end arch;
