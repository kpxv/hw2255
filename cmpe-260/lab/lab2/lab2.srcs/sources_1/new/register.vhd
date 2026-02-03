library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

constant BIT_WIDTH : INTEGER := 8;
constant LOG_PORT_DEPTH : INTEGER := 3;

entity RegisterFile is
	PORT (
	------------ INPUTS ---------------
		clk_n	: in std_logic;
		we		: in std_logic;
		Addr1	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --read address 1
		Addr2	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --read address 2
		Addr3	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --write address
		wd		: in std_logic_vector(BIT_WIDTH-1 downto 0); --write data, din

	------------- OUTPUTS -------------
		RD1		: out std_logic_vector(BIT_WIDTH-1 downto 0); --Read from Addr1
		RD2		: out std_logic_vector(BIT_WIDTH-1 downto 0) --Read from Addr2
	);
end RegisterFile

architecture arch of RegisterFile is
    type memory is array(2 ** LOG_PORT_DEPTH) of std_logic_vector(BIT_WIDTH - 1 downto 0);
begin
    process(clk_n) is
        if(falling_edge(clk_n)) then
            -- ASYNC (outside of process):
            -- when read address is 0
            --     assign output data to 0
            -- else
            --     output data <= memory(address converted to number)



            -- SYNC:
            -- if write address not 0
            --     memory(address converted to number) <= wd
        end if;
    end process;
end memory;
