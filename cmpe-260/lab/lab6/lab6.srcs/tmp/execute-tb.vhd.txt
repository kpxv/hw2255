----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry
--
-- Create Date: 03/18/2026 12:58:23 AM
-- Design Name: Execute Testbench
-- Module Name: execute_tb - behv
-- Project Name: Execute Stage
-- Target Devices: Testbench
-- Tool Versions: VHDL 2008
-- Description: Tests the execute stage
--
-- Dependencies: std_logic_1164, numeric_std, execute
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity execute_tb is
end entity execute_tb;

architecture behv of execute_tb is

    type test_rec_t is record
        reg_write_r : std_logic;
        memto_reg_r : std_logic;
        mem_write_r : std_logic;
        alu_ctrl_r  : std_logic_vector(3 downto 0);
        alu_src_r   : std_logic;
        reg_dst_r   : std_logic;
        reg_srca_r  : std_logic_vector(31 downto 0);
        reg_srcb_r  : std_logic_vector(31 downto 0);
        rt_dest_r   : std_logic_vector(4 downto 0);
        rd_dest_r   : std_logic_vector(4 downto 0);
        sign_imm_r  : std_logic_vector(31 downto 0);

        reg_write_out_r : std_logic;
        memto_reg_out_r : std_logic;
        mem_write_out_r : std_logic;
        alu_result_r    : std_logic_vector(31 downto 0);
        write_data_r    : std_logic_vector(31 downto 0);
        write_reg_r     : std_logic_vector(4 downto 0);
    end record test_rec_t;

    type test_arr_t is array (natural range <>) of test_rec_t;

    constant test_rec_arr : test_arr_t :=
    (
        (
            reg_write_r => '1',
            memto_reg_r => '0',
            mem_write_r => '0',
            alu_ctrl_r  => "0100", -- ADD
            alu_src_r   => '0',
            reg_dst_r   => '1',
            reg_srca_r  => x"00000001",
            reg_srcb_r  => x"00000001",
            rt_dest_r   => "00000",
            rd_dest_r   => "00001",
            sign_imm_r  => x"00000000",

            reg_write_out_r => '1',
            memto_reg_out_r => '0',
            mem_write_out_r => '0',
            alu_result_r    => x"00000002",
            write_data_r    => x"00000001",
            write_reg_r     => "00001"
        ),
        (
            reg_write_r     => '1',
            memto_reg_r     => '0',
            mem_write_r     => '0',
            alu_ctrl_r      => "1010", -- AND
            alu_src_r       => '0',
            reg_dst_r       => '1',
            reg_srca_r      => x"00000001",
            reg_srcb_r      => x"0000000F",
            rt_dest_r       => "00000",
            rd_dest_r       => "00001",
            sign_imm_r      => x"00000000",

            reg_write_out_r => '1',
            memto_reg_out_r => '0',
            mem_write_out_r => '0',
            alu_result_r    => x"00000001",
            write_data_r    => x"0000000F",
            write_reg_r     => "00001"
        ),
        (
            reg_write_r     => '1',
            memto_reg_r     => '0',
            mem_write_r     => '0',
            alu_ctrl_r      => "1000", -- ORI
            alu_src_r       => '1',
            reg_dst_r       => '0',
            reg_srca_r      => x"0000000F",
            reg_srcb_r      => x"00000010",
            rt_dest_r       => "00000",
            rd_dest_r       => "00001",
            sign_imm_r      => x"00000080",

            reg_write_out_r => '1',
            memto_reg_out_r => '0',
            mem_write_out_r => '0',
            alu_result_r    => x"0000008F",
            write_data_r    => x"00000010",
            write_reg_r     => "00000"
        ),
        (
            reg_write_r     => '1',
            memto_reg_r     => '0',
            mem_write_r     => '0',
            alu_ctrl_r      => "1011", -- XORI
            alu_src_r       => '1',
            reg_dst_r       => '0',
            reg_srca_r      => x"00000001",
            reg_srcb_r      => x"00000008",
            rt_dest_r       => "00010",
            rd_dest_r       => "00001",
            sign_imm_r      => x"00000003",

            reg_write_out_r => '1',
            memto_reg_out_r => '0',
            mem_write_out_r => '0',
            alu_result_r    => x"00000002",
            write_data_r    => x"00000008",
            write_reg_r     => "00010"
        ),
        (
            reg_write_r     => '1',
            memto_reg_r     => '0',
            mem_write_r     => '0',
            alu_ctrl_r      => "1100", -- SLL
            alu_src_r       => '0',
            reg_dst_r       => '1',
            reg_srca_r      => x"00000001",
            reg_srcb_r      => x"00000001",
            rt_dest_r       => "00000",
            rd_dest_r       => "00001",
            sign_imm_r      => x"00000000",

            reg_write_out_r => '1',
            memto_reg_out_r => '0',
            mem_write_out_r => '0',
            alu_result_r    => x"00000002",
            write_data_r    => x"00000001",
            write_reg_r     => "00001"
        ),
        (
            reg_write_r     => '1',
            memto_reg_r     => '0',
            mem_write_r     => '0',
            alu_ctrl_r      => "1110", -- SRA
            alu_src_r       => '0',
            reg_dst_r       => '1',
            reg_srca_r      => x"80000001",
            reg_srcb_r      => x"00000001",
            rt_dest_r       => "00000",
            rd_dest_r       => "00001",
            sign_imm_r      => x"00000000",

            reg_write_out_r => '1',
            memto_reg_out_r => '0',
            mem_write_out_r => '0',
            alu_result_r    => x"C0000000",
            write_data_r    => x"00000001",
            write_reg_r     => "00001"
        ),
        (
            reg_write_r     => '1',
            memto_reg_r     => '0',
            mem_write_r     => '0',
            alu_ctrl_r      => "1101", -- SRL
            alu_src_r       => '0',
            reg_dst_r       => '1',
            reg_srca_r      => x"00000001",
            reg_srcb_r      => x"00000001",
            rt_dest_r       => "00000",
            rd_dest_r       => "00001",
            sign_imm_r      => x"00000000",

            reg_write_out_r => '1',
            memto_reg_out_r => '0',
            mem_write_out_r => '0',
            alu_result_r    => x"00000000",
            write_data_r    => x"00000001",
            write_reg_r     => "00001"
        ),
        (
            reg_write_r     => '1',
            memto_reg_r     => '0',
            mem_write_r     => '0',
            alu_ctrl_r      => "0101", -- SUB
            alu_src_r       => '0',
            reg_dst_r       => '1',
            reg_srca_r      => x"00000001",
            reg_srcb_r      => x"00000001",
            rt_dest_r       => "00000",
            rd_dest_r       => "00001",
            sign_imm_r      => x"00000000",

            reg_write_out_r => '1',
            memto_reg_out_r => '0',
            mem_write_out_r => '0',
            alu_result_r    => x"00000000",
            write_data_r    => x"00000001",
            write_reg_r     => "00001"
        ),
        (
            reg_write_r     => '1',
            memto_reg_r     => '1',
            mem_write_r     => '0',
            alu_ctrl_r      => "0100", -- LW
            alu_src_r       => '0',
            reg_dst_r       => '1',
            reg_srca_r      => x"00000001",
            reg_srcb_r      => x"00000001",
            rt_dest_r       => "00000",
            rd_dest_r       => "00001",
            sign_imm_r      => x"00000000",

            reg_write_out_r => '1',
            memto_reg_out_r => '1',
            mem_write_out_r => '0',
            alu_result_r    => x"00000002",
            write_data_r    => x"00000001",
            write_reg_r     => "00001"
        ),
        (
            reg_write_r     => '0',
            memto_reg_r     => '0',
            mem_write_r     => '1',
            alu_ctrl_r      => "0100", -- SW
            alu_src_r       => '0',
            reg_dst_r       => '1',
            reg_srca_r      => x"00000001",
            reg_srcb_r      => x"00000001",
            rt_dest_r       => "00000",
            rd_dest_r       => "00001",
            sign_imm_r      => x"00000000",

            reg_write_out_r => '0',
            memto_reg_out_r => '0',
            mem_write_out_r => '1',
            alu_result_r    => x"00000002",
            write_data_r    => x"00000001",
            write_reg_r     => "00001"
        ),
        (
            reg_write_r     => '1',
            memto_reg_r     => '0',
            mem_write_r     => '0',
            alu_ctrl_r      => "0110", -- MULT
            alu_src_r       => '0',
            reg_dst_r       => '1',
            reg_srca_r      => x"00000002",
            reg_srcb_r      => x"00000002",
            rt_dest_r       => "00000",
            rd_dest_r       => "00001",
            sign_imm_r      => x"00000000",

            reg_write_out_r => '1',
            memto_reg_out_r => '0',
            mem_write_out_r => '0',
            alu_result_r    => x"00000004",
            write_data_r    => x"00000002",
            write_reg_r     => "00001"
        )
    );

    signal reg_write_s : std_logic;
    signal memto_reg_s : std_logic;
    signal mem_write_s : std_logic;
    signal alu_ctrl_s  : std_logic_vector(3 downto 0);
    signal alu_src_s   : std_logic;
    signal reg_dst_s   : std_logic;
    signal reg_srca_s  : std_logic_vector(31 downto 0);
    signal reg_srcb_s  : std_logic_vector(31 downto 0);
    signal rt_dest_s   : std_logic_vector(4 downto 0);
    signal rd_dest_s   : std_logic_vector(4 downto 0);
    signal sign_imm_s  : std_logic_vector(31 downto 0);

    signal reg_write_out_s : std_logic;
    signal memto_reg_out_s : std_logic;
    signal mem_write_out_s : std_logic;
    signal alu_result_s    : std_logic_vector(31 downto 0);
    signal write_data_s    : std_logic_vector(31 downto 0);
    signal write_reg_s     : std_logic_vector(4 downto 0);

begin

    uut : entity work.execute(struct)
        port map (
            reg_write => reg_write_s,
            memto_reg => memto_reg_s,
            mem_write => mem_write_s,
            alu_ctrl  => alu_ctrl_s,
            alu_src   => alu_src_s,
            reg_dst   => reg_dst_s,
            reg_srca  => reg_srca_s,
            reg_srcb  => reg_srcb_s,
            rt_dest   => rt_dest_s,
            rd_dest   => rd_dest_s,
            sign_imm  => sign_imm_s,

            reg_write_out => reg_write_out_s,
            memto_reg_out => memto_reg_out_s,
            mem_write_out => mem_write_out_s,
            alu_result    => alu_result_s,
            write_data    => write_data_s,
            write_reg     => write_reg_s
        );

    stim_proc : process is
    begin

        for i in test_rec_arr'range loop

            reg_write_s <= test_rec_arr(i).reg_write_r;
            memto_reg_s <= test_rec_arr(i).memto_reg_r;
            mem_write_s <= test_rec_arr(i).mem_write_r;
            alu_ctrl_s  <= test_rec_arr(i).alu_ctrl_r;
            alu_src_s   <= test_rec_arr(i).alu_src_r;
            reg_dst_s   <= test_rec_arr(i).reg_dst_r;
            reg_srca_s  <= test_rec_arr(i).reg_srca_r;
            reg_srcb_s  <= test_rec_arr(i).reg_srcb_r;
            rt_dest_s   <= test_rec_arr(i).rt_dest_r;
            rd_dest_s   <= test_rec_arr(i).rd_dest_r;
            sign_imm_s  <= test_rec_arr(i).sign_imm_r;

            wait for 50 ns;

            assert test_rec_arr(i).reg_write_out_r = reg_write_out_s
                report "Case failed on test #" & integer'image(i)
                severity failure;
            assert test_rec_arr(i).memto_reg_out_r = memto_reg_out_s
                report "Case failed on test #" & integer'image(i)
                severity failure;
            assert test_rec_arr(i).mem_write_out_r = mem_write_out_s
                report "Case failed on test #" & integer'image(i)
                severity failure;
            assert test_rec_arr(i).alu_result_r = alu_result_s
                report "Case failed on test #" & integer'image(i)
                severity failure;
            assert test_rec_arr(i).write_data_r = write_data_s
                report "Case failed on test #" & integer'image(i)
                severity failure;
            assert test_rec_arr(i).write_reg_r = write_reg_s
                report "Case failed on test #" & integer'image(i)
                severity failure;

        end loop;

        assert false
            report "TB Successful"
            severity failure;

    end process stim_proc;

end architecture behv;
