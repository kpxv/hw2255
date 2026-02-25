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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit is
    port (
             Opcode : in std_logic_vector (5 downto 0);
             Funct : in std_logic_vector (5 downto 0);

             RegWrite : out std_logic;
             MemtoReg : out std_logic;
             MemWrite : out std_logic;
             ALUControl : out std_logic_vector (3 downto 0);
             ALUSrc : out std_logic;
             RegDst : out std_logic
         );
end ControlUnit;

architecture behv of ControlUnit is
begin
    -- Set RegWrite
    process (Opcode)
    begin
        with Opcode select RegWrite <=
        '0' when "101011",
        '1' when others;
    end process;

    -- Set MemtoReg
    process (Opcode)
    begin
        with Opcode select MemtoReg <=
        '1' when "100011",
        '0' when others;
    end process;

    -- Set MemWrite
    process (Opcode)
    begin
        with Opcode select RegWrite <=
        '1' when "101011",
        '0' when others;
    end process;

    -- Set ALUControl
    process (Opcode, Funct)
    begin
        if Opcode = "000000" then
            with Funct select ALUControl <=
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
            "0000" when others;
        else
            with Opcode select ALUControl <=
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
            "0000" when others;
        end if;
    end process;

    -- Set ALUsrc
    process (Opcode)
    begin
        if Opcode = "000000" then
            ALUSrc <= '0';
        else
            ALUSrc <= '1';
        end if;
    end process;

    -- Set RegDst
    process (Opcode)
    begin
        if Opcode = "000000" then
            RegDst <= '1';
        else
            RegDst <= '0';
        end if;
    end process;
end behv;
