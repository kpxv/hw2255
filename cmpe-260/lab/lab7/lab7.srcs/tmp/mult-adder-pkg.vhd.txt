----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry
--
-- Create Date: 03/17/2026 07:27:00 PM
-- Design Name: Multiplication Adder Helper Package
-- Module Name: mult_adder_pkg
-- Project Name: ALU Multiplication
-- Target Devices: Basys3
-- Tool Versions: VHDL 2008
-- Description: Calculate input and output vector lengths
--
-- Dependencies: std_logic_1164
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

package mult_adder_pkg is

    function calc_outwidth (
        in_n : integer;
        in_offset : integer
    ) return integer;

    function calc_inwidth (
        out_n : integer;
        in_offset : integer
    ) return integer;

end package mult_adder_pkg;

package body mult_adder_pkg is

    -- Calculate length of the output vector

    function calc_outwidth (
        in_n : integer;
        in_offset : integer
    ) return integer is
    begin

        -- Usually in_vec length plus offset
        if (in_offset >= 2) then
            return in_n + in_offset;
        else
            -- When offset is 1, must also include a carry out bit
            return in_n + in_offset + 1;
        end if;

    end function calc_outwidth;

    -- Calculate length of the input vectors

    function calc_inwidth (
        out_n : integer;
        in_offset : integer
    ) return integer is
    begin

        -- Usually the length of the out_vec minus the offset
        if (in_offset >= 2) then
            return out_n - in_offset;
        else
            -- When offset is 1, must account for carry out bit
            return out_n - in_offset - 1;
        end if;

    end function calc_inwidth;

end package body mult_adder_pkg;
