----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Aden Perry
--
-- Create Date: 03/17/2026 07:27:00 PM
-- Design Name: Carry-save bit-forwarding multiplier
-- Module Name: mult - struct
-- Project Name: ALU Multiplication
-- Target Devices: Basys3
-- Tool Versions: VHDL 2008
-- Description: Performs multiplication with carry-save multiplier.
--
-- Dependencies: mult_wrapper, mult_wrapper_pkg, std_logic_1164, numeric_std
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

entity mult is
    generic (
        -- Output widht. Must be a power of two.
        n : integer := 32
    );
    port (
        a : in    std_logic_vector(n / 2 - 1 downto 0);
        b : in    std_logic_vector(n / 2 - 1 downto 0);

        product : out   std_logic_vector(n - 1 downto 0)
    );
end entity mult;

architecture struct of mult is

    constant halfn : integer := n / 2;

    type mres_arr_t is array(0 to halfn - 1) of std_logic_vector(halfn - 1 downto 0);

    signal mult_result_s : mres_arr_t;
    signal input_arr     : slv_arr_t(0 to halfn - 1)(halfn - 1 downto 0);

begin

    -- Generate intermediary products

    gen_mres_row_l : for i in 0 to halfn - 1 generate

        gen_mres_cell_l : for j in 0 to halfn - 1 generate
            mult_result_s(i)(j) <= a(j) and b(i);
        end generate gen_mres_cell_l;

        input_arr(i) <= mult_result_s(i);
    end generate gen_mres_row_l;

    -- Sum all intermediary results
    prod_inst : entity work.mult_wrapper(struct)
        generic map (
            in_vec_len  => halfn,
            out_vec_len => n,
            offset      => halfn / 2,
            arr_n       => halfn
        )
        port map (
            a   => input_arr,
            sum => product
        );

end architecture struct;
