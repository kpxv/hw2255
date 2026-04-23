----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry
--
-- Create Date: 03/17/2026 07:27:00 PM
-- Design Name: Ripple Carry adder
-- Module Name: rc_adder - struct
-- Project Name: ALU Multiplication
-- Target Devices: Basys3
-- Tool Versions: VHDL 2008
-- Description: ripple carry adder that combines full adders
--
-- Dependencies: std_logic_1164, f_adder
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;

entity rc_adder is
    generic (
        n : integer := 32
    );
    port (
        a  : in    std_logic_vector(n - 1 downto 0);
        b  : in    std_logic_vector(n - 1 downto 0);
        op : in    std_logic;

        sum : out   std_logic_vector(n - 1 downto 0)
    );
end entity rc_adder;

architecture struct of rc_adder is

    signal c_s : std_logic_vector(n downto 0);
    signal b_s : std_logic_vector(n - 1 downto 0);

begin

    c_s(0) <= op;

    -- Handle subtraction

    gen_inv_l : for i in 0 to n - 1 generate
        b_s(i) <= b(i) xor op;
    end generate gen_inv_l;

    add_l : for i in 0 to n - 1 generate

        f_adder_inst : entity work.f_adder(behv)
            port map (
                a   => a(i),
                b   => b_s(i),
                cin => c_s(i),

                s    => sum(i),
                cout => c_s(i + 1)
            );

    end generate add_l;

end architecture struct;
