-------------------------------------------------
--  File:          aluTB.vhd
--
--  Entity:        aluTB
--  Architecture:  Testbench
--  Author:        Jason Blocklove
--  Created:       07/29/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                aluTB
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity aluTB is
    Generic ( N : integer := 32 );
end aluTB;

architecture tb of aluTB is

component aluN IS
    Port ( in1 : in  std_logic_vector(N-1 downto 0);
           in2 : in  std_logic_vector(N-1 downto 0);
           control : in  std_logic_vector(3 downto 0);
           out1    : out std_logic_vector(N-1 downto 0)
          );
end component;

signal in1 : std_logic_vector(N-1 downto 0);
signal in2 : std_logic_vector(N-1 downto 0);
signal control : std_logic_vector(3 downto 0);
signal out1 : std_logic_vector(N-1 downto 0);

type alu_tests is record
	-- Test Inputs
	in1 : std_logic_vector(31 downto 0);
	in2 : std_logic_vector(31 downto 0);
	control : std_logic_vector(3 downto 0);
	-- Test Outputs
	out1 : std_logic_vector(31 downto 0);
end record;

type test_array is array (natural range <>) of alu_tests;

constant tests : test_array :=(
    -- Add / AddI / SW / LW
	(in1 => x"00000001", in2 => x"00000000", control => "0100", out1 => x"00000001"),
	(in1 => x"11111111", in2 => x"00000001", control => "0100", out1 => x"00000000"),

    -- And / AndI
	(in1 => x"00000001", in2 => x"00000001", control => "1010", out1 => x"00000001"),
	(in1 => x"00000001", in2 => x"00000000", control => "1010", out1 => x"00000000"),

    -- MultU
	(in1 => x"00000001", in2 => x"00000000", control => "0110", out1 => x"00000000"),
	(in1 => x"00000011", in2 => x"00000011", control => "0110", out1 => x"00001001"),

    -- Or / OrI
	(in1 => x"00000001", in2 => x"00000000", control => "1000", out1 => x"00000001"),
	(in1 => x"00000000", in2 => x"00000000", control => "1000", out1 => x"00000000"),

    -- Xor / XorI
	(in1 => x"00000001", in2 => x"00000000", control => "1011", out1 => x"00000001"),
	(in1 => x"00000001", in2 => x"00000001", control => "1011", out1 => x"00000000"),

    -- SLL
	(in1 => x"00000001", in2 => x"00000001", control => "1100", out1 => x"00000010"),
	(in1 => x"11000001", in2 => x"00000010", control => "1100", out1 => x"00000100"),

    -- SRA
	(in1 => x"00001000", in2 => x"00000010", control => "1110", out1 => x"00000010"),
	(in1 => x"10001000", in2 => x"00000010", control => "1110", out1 => x"11100010"),

    -- SRL
	(in1 => x"00001000", in2 => x"00000010", control => "1101", out1 => x"00000010"),
	(in1 => x"10001000", in2 => x"00000010", control => "1101", out1 => x"00100010"),

    -- Sub
	(in1 => x"00000001", in2 => x"00000000", control => "0101", out1 => x"00000001"),
	(in1 => x"11111111", in2 => x"00000001", control => "0101", out1 => x"11111110")
);

begin


aluN_0 : aluN
    port map (
			in1  => in1,
			in2  => in2,
            control  => control,
            out1     => out1
		);

	stim_proc:process
	begin

        -- Renamed from test_vector_array to tests, because the latter was
        -- declared and the former wasn't. I assume it was a typo.
		for i in tests'range loop
            in1 <= tests(i).in1;
            in2 <= tests(i).in2;
            control <= tests(i).control;

			wait for 100 ns;
            
            assert edgeCases(i).out1 = out1 
            report "Edge case failed on test #" & integer'image(i)
            severity failure;

		end loop;


		assert false
		  report "Testbench Concluded."
		  severity failure;

	end process;
end tb;
