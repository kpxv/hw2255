library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
    generic (
        BIT_WIDTH : INTEGER := 8;
        LOG_PORT_DEPTH : INTEGER := 3
    );

    PORT (
             clk_n	: in std_logic;
             we		: in std_logic;
             Addr1	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --read address 1
             Addr2	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --read address 2
             Addr3	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --write address
             wd		: in std_logic_vector(BIT_WIDTH-1 downto 0); --write data, din
             RD1		: out std_logic_vector(BIT_WIDTH-1 downto 0); --Read from Addr1
             RD2		: out std_logic_vector(BIT_WIDTH-1 downto 0) --Read from Addr2
         );
end RegisterFile;

architecture arch of RegisterFile is
    type memory is array(0 to 2 ** LOG_PORT_DEPTH - 1) of std_logic_vector(BIT_WIDTH - 1 downto 0);
    signal register_array : memory := (others => (others => '0'));

begin
    -- ASYNC READ
    RD1 <= register_array(to_integer(unsigned(Addr1)));
    RD2 <= register_array(to_integer(unsigned(Addr2)));

    process(clk_n) is
    begin
        if (falling_edge(clk_n)) then
            if (we = '1') and (to_integer(unsigned(Addr3)) /= 0) then
                register_array(to_integer(unsigned(Addr3))) <= wd;
            end if;
        end if;
    end process;
end arch;
