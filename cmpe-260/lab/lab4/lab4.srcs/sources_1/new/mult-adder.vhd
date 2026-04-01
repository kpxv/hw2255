----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/17/2026 07:27:00 PM
-- Design Name:
-- Module Name: mult - struct
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
    use work.mult_adder_pkg.all;

entity mult_adder is
    generic (
        in_vec_len : integer := 8;
        offset     : integer := 4
    );
    port (
        a : in    std_logic_vector(in_vec_len - 1 downto 0);
        b : in    std_logic_vector(in_vec_len - 1 downto 0);
        y : out   std_logic_vector(calc_outwidth(in_vec_len, offset) - 1 downto 0)
    );
end entity mult_adder;

architecture struct of mult_adder is

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

    gen_carry_sum_l : for i in in_vec_len to in_vec_len + offset - 1 generate
        carry_sum_inst : entity work.f_adder(behv)
            port map (
                a   => '0',
                b   => b(i - offset),
                cin => c_s(i),

                s    => y_s(i),
                cout => c_s(i + 1)
            );
    end generate gen_carry_sum_l;

    gen_sum_bit_l : if offset = 1 generate
        y_s(y'length - 1) <= c_s(y'length - 1);
    end generate gen_sum_bit_l;

    y <= y_s;

end architecture struct;
