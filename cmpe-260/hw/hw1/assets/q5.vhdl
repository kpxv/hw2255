library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity thermN is
    generic(N : integer := 2);

    port (
             a : in std_logic_vector(N - 1 downto 0);
             q : out std_logic_vector(2**N - 2 downto 0));
end thermN;

architecture arch of thermN is
begin
    genN: for i in 0 to (2**N - 2) generate
        q(i) <= '0' when (i >= to_integer(unsigned(a))) else '1';
    end generate genN;
end arch;
