library ieee;
    use ieee.std_logic_1164.all;
    use work.globals.all;

entity proc is
    generic (
        n          : integer := 32;
        logn       : integer := 5;
        op_len     : integer := 4;
        addr_space : integer := 10
    );
    port (
        clk_in   : in    std_logic;
        rst      : in    std_logic;
        switches : in    std_logic_vector(15 downto 0);

        seven_seg_digit : out   std_logic_vector(6 downto 0);
        -- alu_out         : out   std_logic_vector(31 downto 0);
        active_digit    : out   std_logic_vector(3 downto 0)
    );
end entity proc;

architecture struct of proc is

    component clk_wiz_0 is
        port (
            -- Clock out ports
            clk_out1 : out   std_logic;
            -- Status and control signals
            reset   : in    std_logic;
            clk_in1 : in    std_logic
        );
    end component clk_wiz_0;

    signal alu_out  : std_logic_vector(31 downto 0);
    signal instr0_s : std_logic_vector(31 downto 0);
    signal instr1_s : std_logic_vector(31 downto 0);

    signal reg_write_addr1_s : std_logic_vector(4 downto 0);
    signal reg_write_data1_s : std_logic_vector(31 downto 0);
    signal reg_write_en1_s   : std_logic;

    signal reg_write0_s   : std_logic;
    signal memto_reg0_s   : std_logic;
    signal mem_write0_s   : std_logic;
    signal alu_control0_s : std_logic_vector(3 downto 0);
    signal alu_src0_s     : std_logic;
    signal reg_dst0_s     : std_logic;
    signal rega0_s        : std_logic_vector(31 downto 0);
    signal regb0_s        : std_logic_vector(31 downto 0);
    signal rt_dest0_s     : std_logic_vector(4 downto 0);
    signal rd_dest0_s     : std_logic_vector(4 downto 0);
    signal immd0_s        : std_logic_vector(31 downto 0);

    signal reg_write1_s   : std_logic;
    signal memto_reg1_s   : std_logic;
    signal mem_write1_s   : std_logic;
    signal alu_control1_s : std_logic_vector(3 downto 0);
    signal alu_src1_s     : std_logic;
    signal reg_dst1_s     : std_logic;
    signal rega1_s        : std_logic_vector(31 downto 0);
    signal regb1_s        : std_logic_vector(31 downto 0);
    signal rt_dest1_s     : std_logic_vector(4 downto 0);
    signal rd_dest1_s     : std_logic_vector(4 downto 0);
    signal immd1_s        : std_logic_vector(31 downto 0);

    signal reg_write2_s  : std_logic;
    signal memto_reg2_s  : std_logic;
    signal mem_write2_s  : std_logic;
    signal alu_result0_s : std_logic_vector(31 downto 0);
    signal write_data0_s : std_logic_vector(31 downto 0);
    signal write_reg0_s  : std_logic_vector(4 downto 0);

    signal reg_write3_s  : std_logic;
    signal memto_reg3_s  : std_logic;
    signal mem_write3_s  : std_logic;
    signal alu_result1_s : std_logic_vector(31 downto 0);
    signal write_data1_s : std_logic_vector(31 downto 0);
    signal write_reg1_s  : std_logic_vector(4 downto 0);
    signal switches_s    : std_logic_vector(15 downto 0);

    signal reg_write4_s      : std_logic;
    signal memto_reg4_s      : std_logic;
    signal mem_write4_s      : std_logic;
    signal alu_result2_s     : std_logic_vector(31 downto 0);
    signal write_data2_s     : std_logic_vector(31 downto 0);
    signal write_reg2_s      : std_logic_vector(4 downto 0);
    signal mem0_s            : std_logic_vector(31 downto 0);
    signal active_digit_s    : std_logic_vector(3 downto 0);
    signal seven_seg_digit_s : std_logic_vector(6 downto 0);

    signal reg_write5_s  : std_logic;
    signal memto_reg5_s  : std_logic;
    signal alu_result3_s : std_logic_vector(31 downto 0);
    signal mem1_s        : std_logic_vector(31 downto 0);
    signal write_reg3_s  : std_logic_vector(4 downto 0);

    signal reg_write6_s : std_logic;
    signal write_reg4_s : std_logic_vector(4 downto 0);
    signal result0_s    : std_logic_vector(31 downto 0);

    signal clk : std_logic;

begin

    -- your_instance_name : component clk_wiz_0
    --     port map (
    --         -- Clock out ports
    --         clk_out1 => clk,
    --         -- Status and control signals
    --         reset => rst,
    --         -- Clock in portsm
    --         clk_in1 => clk_in
    --     );
    clk <= clk_in;

    fetch_inst : entity work.instrfetch(struct)
        port map (
            clk => clk,
            rst => rst,

            instruction => instr0_s
        );

    decode_inst : entity work.instrdecode(struct)
        generic map (
            n    => n,
            logn => logn
        )
        port map (
            clk          => clk,
            instruction  => instr1_s,
            regwriteaddr => write_reg4_s,
            regwritedata => result0_s,
            regwriteen   => reg_write6_s,

            regwrite   => reg_write0_s,
            memtoreg   => memto_reg0_s,
            memwrite   => mem_write0_s,
            alucontrol => alu_control0_s,
            alusrc     => alu_src0_s,
            regdst     => reg_dst0_s,
            rd1        => rega0_s,
            rd2        => regb0_s,
            rtdest     => rt_dest0_s,
            rddest     => rd_dest0_s,
            immout     => immd0_s
        );

    execute_inst : entity work.execute(struct)
        generic map (
            n      => n,
            logn   => logn,
            op_len => op_len
        )
        port map (
            reg_write => reg_write1_s,
            memto_reg => memto_reg1_s,
            mem_write => mem_write1_s,
            alu_ctrl  => alu_control1_s,
            alu_src   => alu_src1_s,
            reg_dst   => reg_dst1_s,
            reg_srca  => rega1_s,
            reg_srcb  => regb1_s,
            rt_dest   => rt_dest1_s,
            rd_dest   => rd_dest1_s,
            sign_imm  => immd1_s,

            reg_write_out => reg_write2_s,
            memto_reg_out => memto_reg2_s,
            mem_write_out => mem_write2_s,
            alu_result    => alu_result0_s,
            write_data    => write_data0_s,
            write_reg     => write_reg0_s
        );

    mem_inst : entity work.mem_stage(struct)
        generic map (
            n          => n,
            addr_space => addr_space
        )
        port map (
            clk        => clk,
            rst        => rst,
            reg_write  => reg_write3_s,
            memto_reg  => memto_reg3_s,
            mem_write  => mem_write3_s,
            write_reg  => write_reg1_s,
            alu_result => alu_result1_s,
            write_data => write_data1_s,
            switches   => switches_s,

            reg_write_out   => reg_write4_s,
            memto_reg_out   => memto_reg4_s,
            write_reg_out   => write_reg2_s,
            mem_out         => mem0_s,
            alu_result_out  => alu_result2_s,
            active_digit    => active_digit_s,
            seven_seg_digit => seven_seg_digit_s
        );

    writeback_inst : entity work.writeback(behv)
        port map (
            reg_write  => reg_write5_s,
            memto_reg  => memto_reg5_s,
            alu_result => alu_result3_s,
            read_data  => mem1_s,
            write_reg  => write_reg3_s,

            reg_write_out => reg_write6_s,
            write_reg_out => write_reg4_s,
            result        => result0_s
        );

    clk_proc_l : process (clk) is
    begin

        if rising_edge(clk) then
            -- Input (switches)
            switches_s <= switches;

            -- Fetch outputs
            instr1_s <= instr0_s;

            -- Decode outputs
            reg_write1_s   <= reg_write0_s;
            memto_reg1_s   <= memto_reg0_s;
            mem_write1_s   <= mem_write0_s;
            alu_control1_s <= alu_control0_s;
            alu_src1_s     <= alu_src0_s;
            reg_dst1_s     <= reg_dst0_s;
            rega1_s        <= rega0_s;
            regb1_s        <= regb0_s;
            rt_dest1_s     <= rt_dest0_s;
            rd_dest1_s     <= rd_dest0_s;
            immd1_s        <= immd0_s;

            -- Execute outputs
            reg_write3_s  <= reg_write2_s;
            memto_reg3_s  <= memto_reg2_s;
            mem_write3_s  <= mem_write2_s;
            alu_result1_s <= alu_result0_s;
            write_data1_s <= write_data0_s;
            write_reg1_s  <= write_reg0_s;

            -- Memory outputs
            reg_write5_s  <= reg_write4_s;
            memto_reg5_s  <= memto_reg4_s;
            write_reg3_s  <= write_reg2_s;
            mem1_s        <= mem0_s;
            alu_result3_s <= alu_result2_s;

            -- Writeback outputs
            -- Not dependent on register

            -- Processor outputs
            seven_seg_digit <= seven_seg_digit_s;
            active_digit    <= active_digit_s;
            alu_out         <= alu_result0_s;
        end if;

    end process clk_proc_l;

end architecture struct;
