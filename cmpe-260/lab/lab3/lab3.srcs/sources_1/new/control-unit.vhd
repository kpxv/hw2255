----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 02/24/2026 08:00:47 PM
-- Design Name:
-- Module Name: ControlUnit - behv
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

entity controlunit is
    port (
        opcode : in    std_logic_vector(5 downto 0);
        funct  : in    std_logic_vector(5 downto 0);

        regwrite   : out   std_logic;
        memtoreg   : out   std_logic;
        memwrite   : out   std_logic;
        alucontrol : out   std_logic_vector(3 downto 0);
        alusrc     : out   std_logic;
        regdst     : out   std_logic
    );
end entity controlunit;

architecture behv of controlunit is
begin
    -- Set RegWrite
    regwrite_proc : process (opcode) is
    begin
        with opcode select regwrite <=
            '0' when "101011",
            '1' when others;
    end process regwrite_proc;

    -- Set MemtoReg
    memtoreg_proc : process (opcode) is
    begin
        with opcode select memtoreg <=
            '1' when "100011",
            '0' when others;
    end process memtoreg_proc;

    -- Set MemWrite
    memwrite_proc : process (opcode) is
    begin
        with opcode select memwrite <=
            '1' when "101011",
            '0' when others;
    end process memwrite_proc;

    -- Set ALUControl
    alucontrol_proc : process (opcode, funct) is
    begin
        if (opcode = "000000") then
            with funct select alucontrol <=
                -- Add
                "0100" when "100000",
                -- And
                "1010" when "100100",
                -- Mult
                "0110" when "011001",
                -- Or
                "1000" when "100101",
                -- Xor
                "1011" when "100110",
                -- SLL
                "1100" when "000000",
                -- SRA
                "1110" when "000011",
                -- SRL
                "1101" when "000010",
                -- Sub
                "0101" when "100010",
                -- Invalid
                "1100" when others;
        else
            with opcode select alucontrol <=
                -- Add
                "0100" when "001000",
                -- And
                "1010" when "001100",
                -- Or
                "1000" when "001101",
                -- Xor
                "1011" when "001110",
                -- SW
                "0100" when "101011",
                -- LW
                "0100" when "100011",
                -- Invalid
                "1100" when others;
        end if;
    end process alucontrol_proc;

    -- Set ALUsrc
    aulsrc_proc : process (opcode) is
    begin
        if (opcode = "000000") then
            alusrc <= '0';
        else
            alusrc <= '1';
        end if;
    end process aulsrc_proc;

    -- Set RegDst
    regdst_proc : process (opcode) is
    begin
        if (opcode = "000000") then
            regdst <= '1';
        else
            regdst <= '0';
        end if;
    end process regdst_proc;
end architecture behv;
