----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 02/24/2026 07:53:30 PM
-- Design Name:
-- Module Name: InstrDecode - behv
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

entity instrdecode is
    port (
        clk          : in    std_logic;
        instruction  : in    std_logic_vector(31 downto 0);
        regwriteaddr : in    std_logic_vector(4 downto 0);
        regwritedata : in    std_logic_vector(31 downto 0);
        regwriteen   : in    std_logic;

        regwrite   : out   std_logic;
        memtoreg   : out   std_logic;
        memwrite   : out   std_logic;
        alucontrol : out   std_logic_vector(3 downto 0);
        alusrc     : out   std_logic;
        regdst     : out   std_logic;
        rd1        : out   std_logic_vector(31 downto 0);
        rd2        : out   std_logic_vector(31 downto 0);
        rtdest     : out   std_logic_vector(4 downto 0);
        rddest     : out   std_logic_vector(4 downto 0);
        immout     : out   std_logic_vector(31 downto 0)
    );
end entity instrdecode;

architecture behv of instrdecode is
    signal opcode_s,   funct_s    : std_logic_vector(5 downto 0);
    signal regwrite_s             : std_logic;
    signal memtoreg_s             : std_logic;
    signal memwrite_s             : std_logic;
    signal alusrc_s               : std_logic;
    signal regdst_s               : std_logic;
    signal alucontrol_s           : std_logic_vector(3 downto 0);
    signal regaddr1_s, regaddr2_s : std_logic_vector(4 downto 0);
    signal immout_s               : std_logic_vector(31 downto 0);
begin
    opcode_s   <= instruction(31 downto 26);
    funct_s    <= instruction(5 downto 0);
    regaddr1_s <= instruction(25 downto 21);
    regaddr2_s <= instruction(20 downto 16);

    controlunit_inst : entity work.controlunit(behv)
        port map (
            opcode => opcode_s,
            funct  => funct_s,

            regwrite   => regwrite_s,
            memtoreg   => memtoreg_s,
            memwrite   => memwrite_s,
            alucontrol => alucontrol_s,
            alusrc     => alusrc_s,
            regdst     => regdst_s
        );

    registerfile_inst : entity work.registerfile(behv)
        port map (
            clk_n => clk,
            we    => regwriteen,
            addr1 => regaddr1_s,
            addr2 => regaddr2_s,
            addr3 => regwriteaddr,
            wd    => regwritedata,

            rd1 => rd1,
            rd2 => rd2
        );

    regwrite_proc : process (clk, regwrite_s) is
    begin
        if rising_edge(clk) then
            regwrite <= regwrite_s;
        end if;
    end process regwrite_proc;

    memtoreg_proc : process (clk, memtoreg_s) is
    begin
        if rising_edge(clk) then
            memtoreg <= memtoreg_s;
        end if;
    end process memtoreg_proc;

    memwrite_proc : process (clk, memwrite_s) is
    begin
        if rising_edge(clk) then
            memwrite <= memwrite_s;
        end if;
    end process memwrite_proc;

    alucontrol_proc : process (clk, alucontrol_s) is
    begin
        if rising_edge(clk) then
            alucontrol <= alucontrol_s;
        end if;
    end process alucontrol_proc;

    alusrc_proc : process (clk, alusrc_s) is
    begin
        if rising_edge(clk) then
            alusrc <= alusrc_s;
        end if;
    end process alusrc_proc;

    regdst_proc : process (clk, regdst_s) is
    begin
        if rising_edge(clk) then
            regdst <= regdst_s;
        end if;
    end process regdst_proc;

    rtdest_proc : process (clk, instruction) is
    begin
        if rising_edge(clk) then
            rtdest <= instruction(20 downto 16);
        end if;
    end process rtdest_proc;

    rddest_proc : process (clk, instruction) is
    begin
        if rising_edge(clk) then
            rddest <= instruction(15 downto 11);
        end if;
    end process rddest_proc;

    immout_proc : process (clk, instruction) is
    begin
        if rising_edge(clk) then
            -- Sign extend
            immout_s (15 downto 0)  <= instruction(15 downto 0);
            immout_s (31 downto 16) <= (others => instruction(15));

            immout <= immout_s;
        end if;
    end process immout_proc;
end architecture behv;
