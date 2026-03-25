----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/24/2026 07:29:28 PM
-- Design Name:
-- Module Name: writeback_tb - behv
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
    use ieee.numeric_std.all;

entity writeback_tb is
end entity writeback_tb;

architecture behv of writeback_tb is

    signal write_reg_s               : std_logic_vector(4 downto 0);
    signal reg_write_s,  memto_reg_s : std_logic;
    signal alu_result_s, read_data_s : std_logic_vector(31 downto 0);
    signal result_s                  : std_logic_vector(31 downto 0);
    signal write_reg_out_s           : std_logic_vector(4 downto 0);
    signal reg_write_out_s           : std_logic;

begin

    uut : entity work.writeback(behv)
        port map (
            reg_write     => reg_write_s,
            memto_reg     => memto_reg_s,
            alu_result    => alu_result_s,
            read_data     => read_data_s,
            write_reg     => write_reg_s,
            reg_write_out => reg_write_out_s,
            write_reg_out => write_reg_out_s,
            result        => result_s
        );

    stim_proc : process is
    begin

        write_reg_s <= "00000";
        wait for 20 ns;
        assert write_reg_out_s = "00000"
            report "Failed test #1"
            severity failure;

        write_reg_s <= "11111";
        wait for 20 ns;
        assert write_reg_out_s = "11111"
            report "Failed test #2"
            severity failure;

        reg_write_s <= '0';
        wait for 20 ns;
        assert reg_write_out_s = '0'
            report "Failed test #3"
            severity failure;

        reg_write_s <= '1';
        wait for 20 ns;
        assert reg_write_out_s = '1'
            report "Failed test #4"
            severity failure;

        memto_reg_s  <= '0';
        alu_result_s <= x"00000000";
        read_data_s  <= x"FFFFFFFF";
        wait for 20 ns;
        assert result_s = x"00000000"
            report "Failed test #5"
            severity failure;

        memto_reg_s <= '1';
        wait for 20 ns;
        assert result_s = x"FFFFFFFF"
            report "Failed test #6"
            severity failure;

        memto_reg_s  <= '0';
        alu_result_s <= x"55555555";
        read_data_s  <= x"AAAAAAAA";
        wait for 20 ns;
        assert result_s = x"55555555"
            report "Failed test #7"
            severity failure;

        memto_reg_s <= '1';
        wait for 20 ns;
        assert result_s = x"AAAAAAAA"
            report "Failed test #8"
            severity failure;

        assert false
            report "Passed"
            severity failure;

    end process stim_proc;

end architecture behv;
