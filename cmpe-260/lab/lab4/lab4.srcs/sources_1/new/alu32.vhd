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

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.globals.all; -- provides N and M to top level

entity alu32 is
    port (
        a  : in    std_logic_vector(N - 1 downto 0);
        b  : in    std_logic_vector(N - 1 downto 0);
        op : in    std_logic_vector(O - 1 downto 0);
        y  : out   std_logic_vector(N - 1 downto 0)
    );
end entity alu32;

architecture struct of alu32 is

    signal or_result  : std_logic_vector(N - 1 downto 0);
    signal and_result : std_logic_vector(N - 1 downto 0);
    signal xor_result : std_logic_vector(N - 1 downto 0);
    signal sll_result : std_logic_vector(N - 1 downto 0);
    signal srl_result : std_logic_vector(N - 1 downto 0);
    signal sra_result : std_logic_vector(N - 1 downto 0);
    signal add_result : std_logic_vector(N - 1 downto 0);
    signal sub_result : std_logic_vector(N - 1 downto 0);
    signal mul_result : std_logic_vector(N - 1 downto 0);

begin

    -- Establish operations
    or_comp : entity work.orn
        generic map (
            n => N
        )
        port map (
            a => a,
            b => b,
            y => or_result
        );

    and_comp : entity work.andn
        generic map (
            n => N
        )
        port map (
            a => a,
            b => b,
            y => and_result
        );

    xor_comp : entity work.xorn
        generic map (
            n => N
        )
        port map (
            a => a,
            b => b,
            y => xor_result
        );

    sll_comp : entity work.slln
        generic map (
            n => N, m => M
        )
        port map (
            a         => a,
            shift_amt => b(M - 1 downto 0),
            y         => sll_result
        );

    srl_comp : entity work.srln
        generic map (
            n => N, m => M
        )
        port map (
            a         => a,
            shift_amt => b(M - 1 downto 0),
            y         => srl_result
        );

    sra_comp : entity work.sran
        generic map (
            n => N, m => M
        )
        port map (
            a         => a,
            shift_amt => b(M - 1 downto 0),
            y         => sra_result
        );

    add_comp : entity work.rc_adder(struct)
        generic map (
            n => N
        )
        port map (
            a   => a,
            b   => b,
            op  => '0',
            sum => add_result
        );

    sub_comp : entity work.rc_adder(struct)
        generic map (
            n => N
        )
        port map (
            a   => a,
            b   => b,
            op  => '1',
            sum => sub_result
        );

    mul_comp : entity work.mult(struct)
        generic map (
            n => N
        )
        port map (
            a       => a(n / 2 - 1 downto 0),
            b       => b(n / 2 - 1 downto 0),
            product => mul_result
        );

    -- Select operation based on OP signal
    with OP select Y <=
        or_result when "1000",  -- 8
        and_result when "1010", -- A
        xor_result when "1011", -- B
        sll_result when "1100", -- C
        srl_result when "1101", -- D
        sra_result when "1110", -- E
        add_result when "0100",
        sub_result when "0101",
        mul_result when "0110",
        (others => '0') when others;

end architecture struct;
