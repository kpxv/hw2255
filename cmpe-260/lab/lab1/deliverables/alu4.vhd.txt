------------------------------------------------------
-- Company:  Rochester Institute of Technology (RIT)
-- Engineer: Aden Perry ap148@rit.edu
--
-- Create Date:    2026-01-13 19:41:44
-- Design Name:    alu4
-- Module Name:    alu4 - structural
-- Project Name:   lab1
-- Target Device:  Basys3
--
-- Description: Partial 4-bit Arithmetic Logic Unit
------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.globals.all; -- provides N and M to top level

entity alu4 is
    PORT (
             A   : IN std_logic_vector(N-1 downto 0);
             B   : IN std_logic_vector(N-1 downto 0);
             OP  : IN std_logic;
             Y   : OUT std_logic_vector(N-1 downto 0)
         );
end alu4;

architecture structural of alu4 is
    -- inverter component of declaration
    Component notN is 
        GENERIC ( N : INTEGER := 4); -- bit width
        PORT (
                 A : IN std_logic_vector(N-1 downto 0);
                 Y : OUT std_logic_vector(N-1 downto 0)
             );
    end Component;

    -- skip shift left component declaration, use entity work.
    -- this is done so you can see code with and without components.

    signal not_result : std_logic_vector(3 downto 0);
    signal sll_result : std_logic_vector(3 downto 0);

begin
    -- Instantiate the inverter, using component
    not_comp: notN
        generic map ( N => N)
        port map ( A => A, Y => not_result );

   -- Instantiate the SLL unit, without component
    sll_comp: entity work.sllN
        generic map (N => N, M => M)
        port map ( A=> A, SHIFT_AMT => B(M-1 downto 0), Y => sll_result );

    -- Use OP to control which operation to show/perform
    Y <= not_result when OP = '0' else  -- NOT
         sll_result;                    -- SLL
end structural;
