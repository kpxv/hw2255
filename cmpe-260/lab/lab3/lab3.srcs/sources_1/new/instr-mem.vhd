library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity InstrMem is
    port (
             addr : in std_logic_vector (27 downto 0);
             d_out : out std_logic_vector (31 downto 0)
         );
end entity InstrMem;


architecture arch of InstrMem is
    type memory is array(0 to 1023) of std_logic_vector(7 downto 0);

    function get_byte (
        addr : integer;
        mem  : memory
    ) return std_logic_vector is
    begin
        if addr < 1024 then
            return mem(addr);
        else
            return (others => '0');
        end if;
    end function get_byte;

    signal mem_array : memory := (others => (others => '0'));
    signal addr_int : integer := 0;
begin
    addr_int <= to_integer(unsigned(addr));

    process (addr) is
    begin
        d_out <= get_byte(addr_int, mem_array) &
                 get_byte(addr_int + 1, mem_array) &
                 get_byte(addr_int + 2, mem_array) &
                 get_byte(addr_int + 3, mem_array);
    end process;
end arch;
