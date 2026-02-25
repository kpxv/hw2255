-------------------------------------------------
--  File:          InstructionFetchTB.vhd
--
--  Entity:        InstructionFetchTB
--  Architecture:  BEHAVIORAL
--  Author:        Jason Blocklove
--  Created:       07/26/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 Testbench for Instruction Fetch
--                 Stage
-------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity instructionfetchtb is
end entity instructionfetchtb;

architecture behv of instructionfetchtb is
    type test_vector is record
        rst         : std_logic;
        Instruction : std_logic_vector(31 downto 0);
    end record test_vector;
    -- TODO: Add additional 5 cases to test table
    type     test_array is array (natural range <>) of test_vector;
    constant test_vector_array : test_array :=
    (
        (
            rst         => '1',
            Instruction => x"00000000"
        ), -- address 0, reset value
        (
            rst         => '0',
            Instruction => x"11111111"
        ), -- address 1
        (
            rst         => '0',
            Instruction => x"22222222"
        ), -- address 2
        (
            rst         => '0',
            Instruction => x"1F2E3D4C"
        )  -- address 3
    );

    component instructionfetch is
        port (
            clk         : in    std_logic;
            rst         : in    std_logic;
            instruction : out   std_logic_vector(31 downto 0)
        );
    end component instructionfetch;

    signal   rst               : std_logic;
    signal   clk               : std_logic;
    signal   instruction       : std_logic_vector(31 downto 0);
begin
    uut : component instructionfetch
        port map (
            clk         => clk,
            rst         => rst,
            instruction => instruction
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
        -- TODO:  time for everything to reset
        rst <= '1';
        wait until clk = '1';
        wait until clk = '0';

        for i in test_vector_array'range loop
            rst <= test_vector_array(i).rst;
            wait until clk = '0';
        -- TODO:  assert statement
        end loop;

        wait until clk = '0';

        assert false
            report "Testbench Concluded"
            severity failure;
    end process stim_proc;
end architecture behv;
