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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstrDecode is
    port (
             clk : in std_logic;
             Instruction : in std_logic_vector(31 downto 0);
             RegWriteAddr : in std_logic_vector(4 downto 0);
             RegWriteData : in std_logic_vector(31 downto 0);
             RegWriteEn : in std_logic;

             RegWrite : out std_logic;
             MemtoReg : out std_logic;
             MemWrite : out std_logic;
             ALUControl : out std_logic_vector(3 downto 0);
             ALUSrc : out std_logic;
             RegDst : out std_logic;
             RD1 : out std_logic_vector(31 downto 0);
             RD2 : out std_logic_vector(31 downto 0);
             RtDest : out std_logic_vector(4 downto 0);
             RdDest : out std_logic_vector(4 downto 0);
             ImmOut : out std_logic_vector(31 downto 0)
         );
end InstrDecode;

architecture behv of InstrDecode is
    signal Opcode_s, Funct_s : std_logic_vector(5 downto 0);
    signal RegWrite_s, MemtoReg_s, MemWrite_s, ALUSrc_s, RegDst_s : std_logic;
    signal ALUControl_s : std_logic_vector(3 downto 0);
    signal RegAddr1_s, RegAddr2_s : std_logic_vector(4 downto 0);
    signal ImmOut_s : std_logic_vector(31 downto 0);
begin
    Opcode_s <= Instruction(31 downto 26);
    Funct_s <= Instruction(5 downto 0);
    RegAddr1_s <= Instruction(25 downto 21);
    RegAddr2_s <= Instruction(20 downto 16);

    ControlUnit_inst : entity work.ControlUnit
    port map (
                 Opcode => Opcode_s,
                 Funct => Funct_s,

                 RegWrite => RegWrite_s,
                 MemtoReg => MemtoReg_s,
                 MemWrite => MemWrite_s,
                 ALUControl => ALUControl_s,
                 ALUSrc => ALUSrc_s,
                 RegDst => RegDst_s
             );

    RegisterFile_inst : entity work.RegisterFile
    port map (
                 clk_n => clk,
                 we => RegWriteEn,
                 Addr1 => RegAddr1_s,
                 Addr2 => RegAddr2_s,
                 Addr3 => RegWriteAddr,
                 wd => RegWriteData,

                 RD1 => RD1,
                 RD2 => RD2
             );

    process (clk, RegWrite_s)
    begin
        if rising_edge(clk) then
            RegWrite <= RegWrite_s;
        end if;
    end process;

    process (clk, MemtoReg_s)
    begin
        if rising_edge(clk) then
            MemtoReg <= MemtoReg_s;
        end if;
    end process;

    process (clk, MemWrite_s)
    begin
        if rising_edge(clk) then
            MemWrite <= MemWrite_s;
        end if;
    end process;

    process (clk, ALUControl_s)
    begin
        if rising_edge(clk) then
            ALUControl <= ALUControl_s;
        end if;
    end process;

    process (clk, ALUSrc_s)
    begin
        if rising_edge(clk) then
            ALUSrc <= ALUSrc_s;
        end if;
    end process;

    process (clk, RegDst_s)
    begin
        if rising_edge(clk) then
            RegDst <= RegDst_s;
        end if;
    end process;

    process (clk, Instruction)
    begin
        if rising_edge(clk) then
            RtDest <= Instruction(20 downto 16);
        end if;
    end process;

    process (clk, Instruction)
    begin
        if rising_edge(clk) then
            RdDest <= Instruction(15 downto 11);
        end if;
    end process;

    process (clk, Instruction)
    begin
        if rising_edge(clk) then
            -- Sign extend
            ImmOut_s (15 downto 0) <= Instruction(15 downto 0);
            ImmOut_s (31 downto 16) <= (others => Instruction(15));

            ImmOut <= ImmOut_s;
        end if;
    end process;
end behv;
