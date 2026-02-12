library ieee;
use ieee.std_logic_1164.all;

entity q2 is
    generic (
                n : integer := 4
            );
    port (
             din : in std_logic;
             clk : in std_logic;
             lr : in std_logic;
             mode : in std_logic;
             d : in std_logic_vector(n-1 downto 0);
             dout : out std_logic;
             q : out std_logic_vector(n-1 downto 0)
         );
end q2;

architecture arch of q2 is
    signal q_sig : std_logic_vector(n-1 downto 0) := (others => '0');
    signal sel : std_logic_vector(1 downto 0) := "00";
begin
    sel <= lr & mode;

    process(clk)
    begin
        if falling_edge(clk) then
            case sel is
                when "00" =>
                    dout <= q_sig(0);
                    q_sig <= d;
                when "01" =>
                    dout <= q_sig(n-1);
                    q_sig <= q_sig(n-2 downto 0) & din;
                when "10" =>
                    dout <= q_sig(0);
                    q_sig <= din & q_sig(n-1 downto 1);
                when others =>
                    null;
            end case;
        end if;
    end process;

    q <= q_sig;
end arch;
