-------------------------------------------------
--  File:          register.vhd
--
--  Entity:        Register
--  Architecture:  behavioral
--  Author:        Aden Perry
--  Created:       2025-02-10
--  Modified:
--  VHDL'93
--  Description:   An entity describing a register file
-------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity registerfile is
    generic (
        bit_width      : integer := 32;
        log_port_depth : integer := 5
    );
    port (
        clk_n : in    std_logic;
        we    : in    std_logic;
        addr1 : in    std_logic_vector(log_port_depth - 1 downto 0); -- read address 1
        addr2 : in    std_logic_vector(log_port_depth - 1 downto 0); -- read address 2
        addr3 : in    std_logic_vector(log_port_depth - 1 downto 0); -- write address
        wd    : in    std_logic_vector(bit_width - 1 downto 0);      -- write data, din
        rd1   : out   std_logic_vector(bit_width - 1 downto 0);      -- Read from Addr1
        rd2   : out   std_logic_vector(bit_width - 1 downto 0)       -- Read from Addr2
    );
end entity registerfile;

architecture behv of registerfile is

    type memory is array(0 to 2 ** LOG_PORT_DEPTH - 1) of std_logic_vector(BIT_WIDTH - 1 downto 0);

    signal register_array : memory := (others => (others => '0'));

begin

    -- ASYNC READ
    rd1 <= register_array(to_integer(unsigned(addr1)));
    rd2 <= register_array(to_integer(unsigned(addr2)));

    -- SYNC WRITE
    write_proc_l : process (clk_n) is
    begin

        if (falling_edge(clk_n)) then
            -- Only write if we active. Do not allow R0 write.
            if ((we = '1') and (to_integer(unsigned(addr3)) /= 0)) then
                register_array(to_integer(unsigned(addr3))) <= wd;
            end if;
        end if;

    end process write_proc_l;

end architecture behv;
