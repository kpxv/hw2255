library ieee;
    use ieee.std_logic_1164.all;

entity fadd is
    port (
        a    : in    std_logic;
        b    : in    std_logic;
        cin  : in    std_logic;
        y    : out   std_logic;
        cout : out   std_logic
    );
end entity fadd;

architecture df of fadd is

begin

    y    <= a xor (b xor cin);
    cout <= (a and b) or (b and cin) or (a and cin);

end architecture df;
