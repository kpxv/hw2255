----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/24/2026 06:31:38 PM
-- Design Name:
-- Module Name: mem_stage - struct
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

entity mem_stage is
    port (
        clk        : in    std_logic;
        rst        : in    std_logic;
        reg_write  : in    std_logic;
        memto_reg  : in    std_logic;
        mem_write  : in    std_logic;
        write_reg  : in    std_logic_vector(4 downto 0);
        alu_result : in    std_logic_vector(31 downto 0);
        write_data : in    std_logic_vector(31 downto 0);
        switches   : in    std_logic_vector(15 downto 0);

        reg_write_out   : out   std_logic;
        memto_reg_out   : out   std_logic;
        write_reg_out   : out   std_logic_vector(4 downto 0);
        mem_out         : out   std_logic_vector(31 downto 0);
        alu_result_out  : out   std_logic_vector(31 downto 0);
        active_digit    : out   std_logic_vector(3 downto 0);
        seven_seg_digit : out   std_logic_vector(6 downto 0)
    );
end entity mem_stage;

architecture struct of mem_stage is

    signal num_s : std_logic_vector(15 downto 0);
    signal alu_s : std_logic_vector(9 downto 0);

begin

    reg_write_out  <= reg_write;
    memto_reg_out  <= memto_reg;
    write_reg_out  <= write_reg;
    alu_result_out <= alu_result;

    seven_seg_inst : entity work.sevensegcontroller(behavioral)
        port map (
            clk            => clk,
            rst            => rst,
            display_number => num_s,
            active_digit   => active_digit,
            led_out        => seven_seg_digit
        );

    data_mem_inst : entity work.data_mem(behv)
        port map (
            clk             => clk,
            w_en            => mem_write,
            addr            => alu_s,
            d_in            => write_data,
            switches        => switches,
            d_out           => mem_out,
            seven_seg_digit => num_s
        );

    alu_s <= alu_result(9 downto 0);

end architecture struct;
