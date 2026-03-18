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
    use ieee.math_real.all;

entity mult is
    generic (
        -- Should be an integer power of 2 greater than or equal to 4 (or maybe 2)
        n : integer := 32
    );
    port (
        a : in    std_logic_vector(n / 2 - 1 downto 0);
        b : in    std_logic_vector(n / 2 - 1 downto 0);

        product : out   std_logic_vector(n - 1 downto 0)
    );
end entity mult;

architecture struct of mult is
    type   mres_arr_t is array(0 to n / 2 - 1) of std_logic_vector(n / 2 - 1 downto 0);
    type   rsum_arr_t is array(0 to integer(ceil(log2(real(n)))), 0 to n / 2 - 1) of std_logic_vector(n - 1 downto 0);

    signal mult_result_s : mres_arr_t;
    signal rsum_s        : rsum_arr_t;
begin
    -- Generate products

    gen_mres_row_l : for i in 0 to n / 2 - 1 generate

        gen_mres_cell_l : for j in 0 to n / 2 - 1 generate
            mult_result_s(i)(j) <= a(j) and b(i);
        end generate gen_mres_cell_l;
    end generate gen_mres_row_l;

    -- Backfill products with 0's

    gen_expanded_prod_l : for j in 0 to n / 2 - 1 generate

        proc_expanded_prod_l : process (all) is
            variable sum_vec_v : std_logic_vector(n - 1 downto 0);
        begin
            sum_vec_v                         := (others => '0');
            sum_vec_v(n / 2 - 1 + j downto j) := mult_result_s(j);
            rsum_s(0, j)                      <= sum_vec_v;
        end process proc_expanded_prod_l;
    end generate gen_expanded_prod_l;

    -- Sum products

    gen_big_sum_l : for i in 1 to integer(ceil(log2(real(n)))) - 1 generate

        gen_prod_sum_l : for j in 0 to n / 2 - 1 generate

            gen_sum_exit_l : if j < n / (2 ** (i + 1)) generate
                rc_adder_inst : entity work.rc_adder(struct)
                    generic map (
                        n => n
                    )
                    port map (
                        a   => rsum_s(i - 1, j * 2),
                        b   => rsum_s(i - 1, j * 2 + 1),
                        op  => '0',
                        sum => rsum_s(i, j)
                    );

            end generate gen_sum_exit_l;
        end generate gen_prod_sum_l;
    end generate gen_big_sum_l;

    product <= rsum_s(integer(ceil(log2(real(n)))) - 1, 0);
end architecture struct;
