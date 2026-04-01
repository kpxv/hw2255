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

    function calc_outwidth (
        in_n : integer;
        in_offset : integer
    ) return integer is
    begin

        -- report "in_n: " & integer'image(in_n);
        -- report "in_offset: " & integer'image(in_offset);
        if (in_offset >= 2) then
            return in_n + in_offset;
        else
            return in_n + in_offset + 1;
        end if;

    end function calc_outwidth;

    function calc_inwidth (
        out_n : integer;
        in_offset : integer
    ) return integer is
    begin

        -- report "out_n: " & integer'image(out_n);
        -- report "in_offset: " & integer'image(in_offset);

        if (in_offset >= 2) then
            -- report "inwidth: " & integer'image(out_n - in_offset);
            return out_n - in_offset;
        else
            -- report "inwidth: " & integer'image(out_n - in_offset - 1);
            return out_n - in_offset - 1;
        end if;

    end function calc_inwidth;

end package body mult_adder_pkg;
