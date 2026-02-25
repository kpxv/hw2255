-------------------------------------------------
--  File:          InstructionDecodeTB.vhd
--
--  Entity:        InstructionDecodeTB
--  Architecture:  tb
--  Author:        Jason Blocklove
--  Created:       09/04/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 testbench for InstructionDecode
--                 stage
-------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity instructiondecodetb is
end entity instructiondecodetb;

architecture tb of instructiondecodetb is
    type     test_vector is record
        Instruction  : std_logic_vector(31 downto 0);
        RegWriteAddr : std_logic_vector(4 downto 0);
        RegWriteData : std_logic_vector(31 downto 0);
        RegWriteEn   : std_logic;
        RegWrite     : std_logic;
        MemtoReg     : std_logic;
        MemWrite     : std_logic;
        ALUControl   : std_logic_vector(3 downto 0);
        ALUSrc       : std_logic;
        RegDst       : std_logic;
        RD1, RD2     : std_logic_vector(31 downto 0);
        RtDest       : std_logic_vector(4 downto 0);
        RdDest       : std_logic_vector(4 downto 0);
        ImmOut       : std_logic_vector(31 downto 0);
    end record test_vector;
    type     test_array is array (natural range <>) of test_vector;
    constant test_vector_array : test_array :=
    (
        -- NOOP
        (
            Instruction  => x"00000000",
            RegWriteAddr => "00000",
            RegWriteData => x"00000000",
            RegWriteEn   => '0',
            RegWrite     => '1',
            MemtoReg     => '0',
            MemWrite     => '0',
            ALUControl   => "1100",
            ALUSrc       => '0',
            RegDst       => '1',
            RD1          => x"00000000",
            RD2          => x"00000000",
            RtDest       => "00000",
            RdDest       => "00000",
            ImmOut       => x"00000000"
        ),
        -- ADD R1, R1, R2 - 00000000001000010001000000100000
        (
            Instruction  => x"00211020",
            RegWriteAddr => "00001",
            RegWriteData => x"12121212",
            RegWriteEn   => '1',
            RegWrite     => '1',
            MemtoReg     => '0',
            MemWrite     => '0',
            ALUControl   => "0100",
            ALUSrc       => '0',
            RegDst       => '1',
            RD1          => x"12121212",
            RD2          => x"12121212",
            RtDest       => "00001",
            RdDest       => "00010",
            ImmOut       => x"00001020"
        ),
        -- ADDI R1, R1, 13 - 00100000001000010000000000001101
        (
            Instruction  => x"2021000D",
            RegWriteAddr => "00010",
            RegWriteData => x"00000001",
            RegWriteEn   => '1',
            RegWrite     => '1',
            MemtoReg     => '0',
            MemWrite     => '0',
            ALUControl   => "0100",
            ALUSrc       => '1',
            RegDst       => '0',
            RD1          => x"12121212",
            RD2          => x"12121212",
            RtDest       => "00001",
            RdDest       => "00000",
            ImmOut       => x"0000000D"
        )

        -- Add more test vectors here
    );

    component instructiondecode is
        port (
            --------- INPUTS ------------------
            -- Main Input
            instruction : in    std_logic_vector(31 downto 0);

            -- CLK
            clk : in    std_logic;

            -- WB Inputs
            regwriteaddr : in    std_logic_vector(4 downto 0);
            regwritedata : in    std_logic_vector(31 downto 0);
            regwriteen   : in    std_logic;

            ---------- OUTPUTS ----------------
            -- Cotrol Unit Outputs
            regwrite   : out   std_logic;
            memtoreg   : out   std_logic;
            memwrite   : out   std_logic;
            alucontrol : out   std_logic_vector(3 downto 0);
            alusrc     : out   std_logic;
            regdst     : out   std_logic;
            rd1        : out   std_logic_vector(31 downto 0);
            rd2        : out   std_logic_vector(31 downto 0);

            -- Other Outputs
            rtdest : out   std_logic_vector(4 downto 0);
            rddest : out   std_logic_vector(4 downto 0);
            immout : out   std_logic_vector(31 downto 0)
        );
    end component instructiondecode;

    signal instruction  : std_logic_vector(31 downto 0);
    signal clk          : std_logic;
    signal regwriteaddr : std_logic_vector(4 downto 0);
    signal regwritedata : std_logic_vector(31 downto 0);
    signal regwriteen   : std_logic;
    signal regwrite     : std_logic;
    signal memtoreg     : std_logic;
    signal memwrite     : std_logic;
    signal alucontrol   : std_logic_vector(3 downto 0);
    signal alusrc       : std_logic;
    signal regdst       : std_logic;
    signal rd1, rd2     : std_logic_vector(31 downto 0);
    signal rtdest       : std_logic_vector(4 downto 0);
    signal rddest       : std_logic_vector(4 downto 0);
    signal immout       : std_logic_vector(31 downto 0);
begin
    uut : component instructiondecode
        port map (
            --------- INPUTS ------------------
            -- Main Input
            instruction => instruction,
            -- CLK
            clk => clk,
            -- WB Inputs
            regwriteaddr => regwriteaddr,
            regwritedata => regwritedata,
            regwriteen   => regwriteen,
            ---------- OUTPUTS ----------------
            -- Cotrol Unit Outputs
            regwrite   => regwrite,
            memtoreg   => memtoreg,
            memwrite   => memwrite,
            alucontrol => alucontrol,
            alusrc     => alusrc,
            regdst     => regdst,
            -- Register File Outputs
            rd1 => rd1,
            rd2 => rd2,
            -- Other Outputs
            rtdest => rtdest,
            rddest => rddest,
            immout => immout
        );

    clk_proc : process is
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process clk_proc;

    stim_proc : process is
    begin
        wait until clk = '0';

        for i in 0 to 2 loop -- TODO: update to number of test vectors
            wait until clk = '1';
            instruction  <= test_vector_array(i).Instruction;
            regwriteaddr <= test_vector_array(i).RegWriteAddr;
            regwritedata <= test_vector_array(i).RegWriteData;
            regwriteen   <= test_vector_array(i).RegWriteEn;
            wait until clk = '0';
            wait for 5 ns;
        -- TODO:  assert statements
        end loop;

        wait until clk = '0';

        assert false
            report "Testbench Concluded"
            severity failure;
    end process stim_proc;
end architecture tb;
