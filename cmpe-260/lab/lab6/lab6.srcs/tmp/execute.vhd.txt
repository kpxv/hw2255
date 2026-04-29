----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry
--
-- Create Date: 03/18/2026 12:29:27 AM
-- Design Name: Execute Wrapper
-- Module Name: execute - struct
-- Project Name: Execute Stage
-- Target Devices: Basys3
-- Tool Versions: VHDL 2008
-- Description: Maps the execute stage
--
-- Dependencies: std_logic_1164, execute
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

entity execute is
    generic (
        n      : integer := 32;
        logn   : integer := 5;
        op_len : integer := 4
    );
    port (
        reg_write : in    std_logic;
        memto_reg : in    std_logic;
        mem_write : in    std_logic;
        alu_ctrl  : in    std_logic_vector(3 downto 0);
        alu_src   : in    std_logic;
        reg_dst   : in    std_logic;
        reg_srca  : in    std_logic_vector(31 downto 0);
        reg_srcb  : in    std_logic_vector(31 downto 0);
        rt_dest   : in    std_logic_vector(4 downto 0);
        rd_dest   : in    std_logic_vector(4 downto 0);
        sign_imm  : in    std_logic_vector(31 downto 0);

        reg_write_out : out   std_logic;
        memto_reg_out : out   std_logic;
        mem_write_out : out   std_logic;
        alu_result    : out   std_logic_vector(31 downto 0);
        write_data    : out   std_logic_vector(31 downto 0);
        write_reg     : out   std_logic_vector(4 downto 0)
    );
end entity execute;

architecture struct of execute is

    signal b_s : std_logic_vector(31 downto 0);

begin

    reg_write_out <= reg_write;
    memto_reg_out <= memto_reg;
    mem_write_out <= mem_write;

    b_s <= reg_srcb when alu_src = '0' else
           sign_imm;

    alu32_inst : entity work.alu32(struct)
        generic map (
            n      => n,
            logn   => logn,
            op_len => op_len
        )
        port map (
            a  => reg_srca,
            b  => b_s,
            op => alu_ctrl,
            y  => alu_result
        );

    write_data <= reg_srcb;
    write_reg  <= rt_dest when reg_dst = '0' else
                  rd_dest;

end architecture struct;
