----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry
--
-- Create Date: 03/17/2026 07:27:00 PM
-- Design Name: Mult Wrapper Helper Package
-- Module Name: mult_wrapper - struct
-- Project Name: ALU Multiplication
-- Target Devices: Basys3
-- Tool Versions: VHDL 2008
-- Description: Adds a type for use in the mult_wrapper input port
--
-- Dependencies: numeric_std, std_logic_1164
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

package mult_wrapper_pkg is

    type slv_arr_t is array (natural range <>) of std_logic_vector;

end package mult_wrapper_pkg;
