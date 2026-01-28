library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity majority is
    port (
    a,b,c : in std_logic;
    y   : out std_logic);
end majority;

architecture selectarch of majority is
    signal inputs : std_logic_vector(2 downto 0);
begin
    inputs <= a & b & c;

    with inputs select 
        y <= '1' when "110",
             '1' when "101",
             '1' when "011",
             '0' when others;
end architecture;



architecture condarch of majority is
    signal inputs : std_logic_vector(2 downto 0);
begin
    inputs <= a & b & c;

    y <= '1' when (inputs = "110") else
         '1' when (inputs = "101") else
         '1' when (inputs = "011") else
         '0';
end architecture;



architecture ifarch of majority is
begin
    process(a,b,c)
    begin
        if ((a = '1' and b = '1') or (a = '1' and c = '1') or (b = '1' and c = '1')) then
            y <= '1';
        else
            y <= '0';
        end if;
    end process;
end architecture;
