library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1 is
    port (
    a,b,s : in std_logic;
    y   : out std_logic);
end mux2to1;

architecture arch of mux2to1 is
begin
    with s select 
        y <= a when '0',
             b when others;
end architecture;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lut3 is 
    port(x1,x2,x3 : in std_logic; 
    val1,val2,val3,val4,val5,val6,val7,val8 : in std_logic; 
    f : out std_logic); 
end lut3; 

architecture structural of lut3 is 
    component mux2to1
        port(a,b,s : in std_logic;
             y : out std_logic);
    end component;

    signal mux1out, mux2out, mux3out, mux4out, mux5out, mux6out, mux7out : std_logic;
begin

    mux1: mux2to1 port map (a => val1, b => val2, s => x1, y => mux1out);
    mux2: mux2to1 port map (a => val3, b => val4, s => x1, y => mux2out);
    mux3: mux2to1 port map (a => val5, b => val6, s => x1, y => mux3out);
    mux4: mux2to1 port map (a => val7, b => val8, s => x1, y => mux4out);

    mux5: mux2to1 port map (a => mux1out, b => mux2out, s => x2, y => mux5out);
    mux6: mux2to1 port map (a => mux3out, b => mux4out, s => x2, y => mux6out);

    mux7: mux2to1 port map (a => mux5out, b => mux6out, s => x3, y => mux7out);

    f <= mux7out;
 
end structural;
