library ieee;
use ieee.std_logic_1164.all;

entity q3 is
    port (
    c, en, rst, clk : in std_logic;
    y : out std_logic_vector(2 downto 0)
);
end q3;

architecture arch of q3 is
    type state_t is (s000, s001, s010, s011, s100, s101, s110, s111);
    signal current_state, next_state : state_t := s000;
    signal sel : std_logic_vector(1 downto 0);
begin

    -- Determine next state
    process(c, en, rst, current_state)
    begin
        if rst = '0' then
            next_state <= s000;
        else
            case current_state is
                when s000 =>
                    sel <= c & en;
                    case sel is
                        when "11" => next_state <= s001;
                        when "01" => next_state <= s111;
                        -- when "10" => next_state <= s110;
                        -- when "00" => next_state <= s101;
                        when others => next_state <= s000;
                    end case;
                when s001 =>
                    sel <= c & en;
                    case sel is
                        when "11" => next_state <= s010;
                        when "01" => next_state <= s000;
                        when others => next_state <= s001;
                    end case;
                when s010 =>
                    sel <= c & en;
                    case sel is
                        when "11" => next_state <= s011;
                        when "01" => next_state <= s001;
                        when others => next_state <= s010;
                    end case;
                when s011 =>
                    sel <= c & en;
                    case sel is
                        when "11" => next_state <= s100;
                        when "01" => next_state <= s010;
                        when others => next_state <= s011;
                    end case;
                when s100 =>
                    sel <= c & en;
                    case sel is
                        when "11" => next_state <= s101;
                        when "01" => next_state <= s011;
                        when others => next_state <= s100;
                    end case;
                when s101 =>
                    sel <= c & en;
                    case sel is
                        when "11" => next_state <= s110;
                        when "01" => next_state <= s100;
                        when others => next_state <= s101;
                    end case;
                when s110 =>
                    sel <= c & en;
                    case sel is
                        when "11" => next_state <= s111;
                        when "01" => next_state <= s101;
                        when others => next_state <= s110;
                    end case;
                when others =>
                    sel <= c & en;
                    case sel is
                        when "11" => next_state <= s000;
                        when "01" => next_state <= s110;
                        when others => next_state <= s111;
                    end case;
            end case;
        end if;
    end process;

    -- Update state
    process(clk)
    begin
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Update output
    process(current_state)
    begin
        case current_state is
            when s000 => y <= "000";
            when s001 => y <= "001";
            when s010 => y <= "010";
            when s011 => y <= "011";
            when s100 => y <= "100";
            when s101 => y <= "101";
            when s110 => y <= "110";
            when others => y <= "111";
        end case;
    end process;
end arch;
