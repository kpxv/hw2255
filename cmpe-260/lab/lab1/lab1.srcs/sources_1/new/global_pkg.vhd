------------------------------------------------------
-- Company:  Rochester Institute of Technology (RIT)
-- Engineer: Aden Perry ap148@rit.edu
--
-- Create Date:    2026-01-13 19:41:44
-- Design Name:    globals
-- Module Name:    globals - package (library)
-- Project Name:   lab1
-- Target Device:  Basys3
--
-- Description: Constants used in top and test bench level
--     Xilinx does not like generics in the top level of a design
------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
package globals is
    constant N : INTEGER := 4;
    constant M : INTEGER := 2;
end;
