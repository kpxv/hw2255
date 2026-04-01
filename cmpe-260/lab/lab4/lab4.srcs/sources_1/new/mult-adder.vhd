----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry
--
-- Create Date: 03/17/2026 07:27:00 PM
-- Design Name: Multiplier Bit-Forwarding Adder
-- Module Name: mult - struct
-- Project Name: ALU Multiplication
-- Target Devices: Basys3
-- Tool Versions: VHDL 2008
-- Description: Sum the two input vectors. The second vector is shifted left
-- by `offset` bits. Low bits get forwarded rather than summed with 0 for small
-- speedup.
--
-- Dependencies:mult_adder_pkg, std_logic_1164
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use work.mult_adder_pkg.all;

entity mult_adder is
    generic (
        in_vec_len : integer := 8;
        offset     : integer := 4
    );
    port (
        -- Base vector
        a : in    std_logic_vector(in_vec_len - 1 downto 0);
        -- Offset vector
        b : in    std_logic_vector(in_vec_len - 1 downto 0);
        y : out   std_logic_vector(calc_outwidth(in_vec_len, offset) - 1 downto 0)
    );
end entity mult_adder;

architecture struct of mult_adder is

    -- Carry-ins start at the b vector
    signal c_s : std_logic_vector(y'length downto offset);
    signal y_s : std_logic_vector(y'length - 1 downto 0);

begin

    -- Initialize carry-in
    c_s(offset) <= '0';

    -- Generate a-input signal forwarding
    y_s(offset - 1 downto 0) <= a(offset - 1 downto 0);

    -- Generate normal sum bits

    gen_sums_l : for i in offset to in_vec_len - 1 generate

        sum_inst : entity work.f_adder(behv)
            port map (
                a   => a(i),
                b   => b(i - offset),
                cin => c_s(i),

                s    => y_s(i),
                cout => c_s(i + 1)
            );

    end generate gen_sums_l;

    -- Propogates carries.

    gen_carry_sum_l : for i in in_vec_len to in_vec_len + offset - 1 generate

        -- Slightly more efficient than a full adder with a grounded input
        y_s(i)     <= b(i - offset) xor c_s(i);
        c_s(i + 1) <= b(i - offset) and c_s(i);

    end generate gen_carry_sum_l;

    -- Handle special case where offset is 1 but y is length in_vec_len + 2

    gen_sum_bit_l : if offset = 1 generate
        y_s(y'length - 1) <= c_s(y'length - 1);
    end generate gen_sum_bit_l;

    y <= y_s;

end architecture struct;
