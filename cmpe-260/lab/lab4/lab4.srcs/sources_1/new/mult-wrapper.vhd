----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/17/2026 07:27:00 PM
-- Design Name:
-- Module Name: mult_wrapper - struct
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
    use ieee.numeric_std.all;
    use work.mult_wrapper_pkg.all;
    use work.mult_adder_pkg.all;

entity mult_wrapper is
    generic (
        -- Width of the input vector
        in_vec_len : integer;
        -- Width of the output vector
        out_vec_len : integer;
        -- Offset used to generate output sum
        offset : integer;
        -- Width of array
        arr_n : integer
    );
    port (
        a   : in    slv_arr_t(0 to arr_n - 1)(in_vec_len - 1 downto 0);
        sum : out   std_logic_vector(out_vec_len - 1 downto 0)
    );
end entity mult_wrapper;

architecture struct of mult_wrapper is

    signal res_left_s  : std_logic_vector(calc_inwidth(out_vec_len, offset) - 1 downto 0);
    signal res_right_s : std_logic_vector(calc_inwidth(out_vec_len, offset) - 1 downto 0);

begin

    gen_one_slv_l : if arr_n = 1 generate
        sum(out_vec_len - 1 downto out_vec_len - calc_inwidth(out_vec_len, offset)) <= a(0);
        sum(out_vec_len - calc_inwidth(out_vec_len, offset) - 1 downto 0) <= (others => '0');
    end generate gen_one_slv_l;

    gen_two_slv_l : if arr_n = 2 generate

        add_inst : entity work.mult_adder(struct)
            generic map (
                in_vec_len => in_vec_len,
                offset     => offset
            )
            port map (
                a => a(0),
                b => a(1),
                y => sum
            );

    end generate gen_two_slv_l;

    gen_reduce_slv_l : if arr_n > 2 generate
        -- Generate left tree addition
        wrapper_left_inst : entity work.mult_wrapper(struct)
            generic map (
                in_vec_len  => in_vec_len,
                out_vec_len => calc_inwidth(out_vec_len, arr_n / 2 ),
                offset      => offset / 2,
                arr_n       => arr_n / 2
            )
            port map (
                a   => a(0 to arr_n / 2 - 1),
                sum => res_left_s
            );
            
        -- Generate right tree addition
        wrapper_right_inst : entity work.mult_wrapper(struct)
            generic map (
                in_vec_len  => in_vec_len,
                out_vec_len => calc_inwidth(out_vec_len, (arr_n + 1) / 2 ),
                offset      => offset / 2,
                arr_n       => (arr_n + 1) / 2
            )
            port map (
                a   => a((arr_n / 2) to arr_n - 1),
                sum => res_right_s
            );

        -- Sum both sides of tree
        add_inst : entity work.mult_adder(struct)
            generic map (
                in_vec_len => calc_inwidth(out_vec_len, offset),
                offset     => offset
            )
            port map (
                a => res_left_s,
                b => res_right_s,
                y => sum
            );

    end generate gen_reduce_slv_l;

end architecture struct;
