----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry ap1498@rit.edu
-- 
-- Create Date: 01/19/2026 07:40:36 PM
-- Design Name: alu32 Test Bench
-- Module Name: alu32_tb - behv
-- Project Name: alu32
-- Target Devices: Basys3 FPGA
-- Tool Versions: Vivado 2025.2
-- Description: a test bench to ensure functionality of alu32
-- 
-- Dependencies: 
-- 
-- Revision: 0.02 - Added test cases
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.globals.all;


entity alu32_tb is
    end alu32_tb;

architecture behv of alu32_tb is
    constant delay : time := 50 ns;
    signal A, B, Y : std_logic_vector(N-1 downto 0) := (others => '0');
    signal OP : std_logic_vector(O-1 downto 0) := (others => '0');

    type testRecord is record
        A, B, Y : std_logic_vector(N-1 downto 0);
        OP : std_logic_vector(O-1 downto 0);
    end record;

    type testArray is array(natural range <>) of testRecord;

    constant edgeCases : testArray := (
    -- SRL
    (x"00000006", x"00000002" ,x"00000001", x"D"),
    -- SRA
    (x"00000006", x"00000001", x"00000003", x"E"),
    (x"00000006", x"00000002", x"00000001", x"E"),
    (x"F0000000", x"00000001", x"F8000000", x"E"),
    -- OR
    (x"00000000", x"00000000", x"00000000", x"8"),
    (x"00000000", x"0000000F", x"0000000F", x"8"),
    (x"0000000F", x"0000000F", x"0000000F", x"8"),
    (x"00000005", x"0000000A", x"0000000F", x"8"),
    (x"0000000A", x"00000005", x"0000000F", x"8"),
    -- XOR
    (x"00000000", x"00000000", x"00000000", x"B"),
    (x"00000000", x"0000000F", x"0000000F", x"B"),
    (x"0000000F", x"00000000", x"0000000F", x"B"),
    (x"0000000F", x"0000000F", x"00000000", x"B"),
    (x"00000005", x"0000000A", x"0000000F", x"B"),
    (x"0000000A", x"00000005", x"0000000F", x"B"),
    -- AND
    (x"00000000", x"00000000", x"00000000", x"A"),
    (x"00000000", x"0000000F", x"00000000", x"A"),
    (x"0000000F", x"00000000", x"00000000", x"A"),
    (x"0000000F", x"0000000F", x"0000000F", x"A")
);

    constant generalCases : testArray := (
    -- SLL
    (x"00000008", x"00000001" ,x"00000010", x"C"),
    (x"00000008", x"00000002" ,x"00000020", x"C"),
    (x"10000000", x"00000001" ,x"20000000", x"C"),
    (x"10000000", x"00000002" ,x"40000000", x"C"),
    -- SRL
    (x"00000008", x"00000001" ,x"00000004", x"D"),
    (x"00000008", x"00000002" ,x"00000002", x"D"),
    (x"80000000", x"00000001" ,x"40000000", x"D"),
    (x"80000000", x"00000002" ,x"20000000", x"D"),
    -- SRA
    (x"00000008", x"00000001", x"00000004", x"E"),
    (x"00000008", x"00000002", x"00000002", x"E"),
    (x"80000000", x"00000001", x"C0000000", x"E"),
    (x"80000000", x"00000002", x"E0000000", x"E"),
    -- OR
    (x"CCCCCCCC", x"33333333", x"FFFFFFFF", x"8"),
    (x"00000000", x"FFFFFFFF", x"FFFFFFFF", x"8"),
    (x"CCCCCCCC", x"80808080", x"CCCCCCCC", x"8"),
    (x"AAAAAAAA", x"00000005", x"AAAAAAAF", x"8"),
    -- XOR
    (x"FFFFFFFF", x"00000000", x"FFFFFFFF", x"B"),
    (x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"B"),
    (x"CCCCCCCC", x"88888888", x"44444444", x"B"),
    (x"F0F0F0F0", x"0F0F0F0F", x"FFFFFFFF", x"B"),
    -- AND
    (x"CCCCCCCC", x"88888888", x"88888888", x"A"),
    (x"AAAAAAAA", x"FFFFFFFF", x"AAAAAAAA", x"A"),
    (x"0F0F0F0F", x"FFFFFFFF", x"0F0F0F0F", x"A"),
    (x"0F0F0F0F", x"F0F0F0F0", x"00000000", x"A")
);

begin
    alu_inst: entity work.alu32
    port map (A => A, B => B, OP => OP, Y => Y);

    data_proc: process is
    begin
        -- Test every edge case
        for i in edgeCases'range loop
            OP <= edgeCases(i).OP;
            A <= edgeCases(i).A;
            B <= edgeCases(i).B;

            wait for delay;

            assert edgeCases(i).Y = Y 
            report "Edge case failed on test #" & integer'image(i)
            severity failure;

        end loop;

        -- Test every general case
        for i in generalCases'range loop
            OP <= generalCases(i).OP;
            A <= generalCases(i).A;
            B <= generalCases(i).B;

            wait for delay;

            assert generalCases(i).Y = Y 
            report "General case failed on test #" & integer'image(i)
            severity failure;

        end loop;

 
        -- Forcibly end simulation early so that waveform is the minimum size
        assert false report "Tests passed successfully" severity failure;
    end process data_proc;
end behv;
