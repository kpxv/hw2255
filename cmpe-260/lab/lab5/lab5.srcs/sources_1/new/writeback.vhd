----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/24/2026 05:31:01 PM
-- Design Name:
-- Module Name: writeback - behv
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
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

entity writeback is
    port (
        reg_write  : in    std_logic;
        memto_reg  : in    std_logic;
        alu_result : in    std_logic_vector(31 downto 0);
        read_data  : in    std_logic_vector(31 downto 0);
        write_reg  : in    std_logic_vector(4 downto 0);

        reg_write_out : out   std_logic;
        write_reg_out : out   std_logic_vector(4 downto 0);
        result        : out   std_logic_vector(31 downto 0)
    );
end entity writeback;

architecture behv of writeback is

begin

    memto_reg_proc : process (read_data, memto_reg, alu_result) is
    begin

        if (memto_reg = '1') then
            result <= read_data;
        else
            result <= alu_result;
        end if;

    end process memto_reg_proc;

    reg_write_out <= reg_write;
    write_reg_out <= write_reg;

end architecture behv;
