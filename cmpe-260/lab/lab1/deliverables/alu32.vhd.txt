----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry ap1498@rit.edu
-- 
-- Create Date: 01/19/2026 07:40:36 PM
-- Design Name: alu32
-- Module Name: alu32 - struct
-- Project Name: alu32
-- Target Devices: Basys3 FPGA
-- Tool Versions: Vivado 2025.2
-- Description: 32-bit simple ALU
-- 
-- Dependencies: 
-- 
-- Revision: 0.02 - Added OR, AND, XOR, SLL, SRL, SRA
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.globals.all; -- provides N and M to top level

entity alu32 is
    PORT (
             A   : IN std_logic_vector(N-1 downto 0);
             B   : IN std_logic_vector(N-1 downto 0);
             OP  : IN std_logic_vector(O-1 downto 0);
             Y   : OUT std_logic_vector(N-1 downto 0)
         );
end alu32;

architecture struct of alu32 is
    signal or_result : std_logic_vector(N-1 downto 0);
    signal and_result : std_logic_vector(N-1 downto 0);
    signal xor_result : std_logic_vector(N-1 downto 0);
    signal sll_result : std_logic_vector(N-1 downto 0);
    signal srl_result : std_logic_vector(N-1 downto 0);
    signal sra_result : std_logic_vector(N-1 downto 0);

begin
    -- Establish operations
    or_comp: entity work.orN
    generic map (N => N)
    port map (A => A, B => B, Y => or_result);

    and_comp: entity work.andN
    generic map (N => N)
    port map (A => A, B => B, Y => and_result);

    xor_comp: entity work.xorN
    generic map (N => N)
    port map (A => A, B => B, Y => xor_result);

    sll_comp: entity work.sllN
    generic map (N => N, M => M)
    port map (A => A, SHIFT_AMT => B(M-1 downto 0), Y => sll_result);

    srl_comp: entity work.srlN
    generic map (N => N, M => M)
    port map (A => A, SHIFT_AMT => B(M-1 downto 0), Y => srl_result);

    sra_comp: entity work.sraN
    generic map (N => N, M => M)
    port map (A => A, SHIFT_AMT => B(M-1 downto 0), Y => sra_result);


    -- Select operation based on OP signal
    with OP select
        Y <= or_result when "1000",   -- 8
             and_result when "1010",  -- A
             xor_result when "1011",  -- B
             sll_result when "1100",  -- C
             srl_result when "1101",  -- D
             sra_result when "1110",  -- E
             (others => '0') when others;
end struct;
