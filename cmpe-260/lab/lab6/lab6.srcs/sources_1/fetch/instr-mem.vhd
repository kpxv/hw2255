----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry
--
-- Create Date: 02/24/2026 08:00:47 PM
-- Design Name: Instruction Memory
-- Module Name: InstrMem - behv
-- Project Name: Instruction Fetch Stage
-- Target Devices:
-- Tool Versions: VHDL 2008
-- Description: Stores and provides byte-addressable access to instructions
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity instrmem is
    port (
        addr  : in    std_logic_vector(27 downto 0);
        d_out : out   std_logic_vector(31 downto 0)
    );
end entity instrmem;

architecture behv of instrmem is

    type memory is array(0 to (1024 * 4) - 1) of std_logic_vector(7 downto 0);

    -- Get a byte from provided memory array. Return 0x00 if out of range.

    function get_byte (
        addr_a : integer;
        mem_a  : memory
    ) return std_logic_vector is
    begin

        if (addr_a < (1024 * 4) and addr_a >= 0) then
            return mem_a(addr_a);
        else
            return x"00";
        end if;

    end function get_byte;

    -- Initialize memory instructions
    signal mem_array : memory := (
        x"20", x"09", x"00", x"FF", -- addi $t1, $0, 0xff
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"20", x"0A", x"00", x"02", -- addi $t2, $0, 0x2
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"01", x"49", x"48", x"00", -- sll $t1, $t1, $t2
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"21", x"29", x"00", x"02", -- addi $t1, $t1, 0x2
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"8D", x"28", x"00", x"00", -- lw $t0, 0x0($t1)
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"21", x"08", x"00", x"01", -- addi $t0, $t0, 0x01
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"01", x"48", x"40", x"00", -- sll $t0, $t0, $t2
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"AD", x"28", x"00", x"01", -- sw $t0, 0x1($t1)
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
        x"00", x"00", x"00", x"00",
                                  others => x"00");
    signal addr_int_s : integer;

    signal d_out_s : std_logic_vector(31 downto 0);

begin

    -- Get the address as an integer for math purposes
    addr_int_s <= to_integer(unsigned(addr));

    -- Get addressed byte and next three bytes
    get_mem_proc : process (addr_int_s, mem_array) is
    begin

        d_out_s <= get_byte(addr_int_s, mem_array)
                   & get_byte(addr_int_s + 1, mem_array)
                   & get_byte(addr_int_s + 2, mem_array)
                   & get_byte(addr_int_s + 3, mem_array);

    end process get_mem_proc;

    d_out <= d_out_s;

end architecture behv;
