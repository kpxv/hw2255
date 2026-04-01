----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry
--
-- Create Date: 03/17/2026 07:27:00 PM
-- Design Name: Full Adder
-- Module Name: f_adder - behv
-- Project Name: ALU Multiplication
-- Target Devices: Basys3
-- Tool Versions: VHDL 2008
-- Description: implements a full adder
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

entity f_adder is
    port (
        a   : in    std_logic;
        b   : in    std_logic;
        cin : in    std_logic;

        s    : out   std_logic;
        cout : out   std_logic
    );
end entity f_adder;

architecture behv of f_adder is

begin

    s    <= (a xor b) xor cin;
    cout <= (a and b) or (b and cin) or (a and cin);

end architecture behv;
