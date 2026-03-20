----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/17/2026 07:27:00 PM
-- Design Name:
-- Module Name: f_adder - behv
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
