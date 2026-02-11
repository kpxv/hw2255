-------------------------------------------------
--  File:          RegisterFileTB.vhd
--
--  Entity:        RegisterFileTB
--  Architecture:  testbench
--  Author:        Jason Blocklove
--  Created:       09/03/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 testbench for the complete
--                 register file
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegisterFileTB is
end RegisterFileTB;

architecture tb of RegisterFileTB is

constant BIT_WIDTH : integer := 8;
constant LOG_PORT_DEPTH : integer := 3;

type test_vector is record
	we : std_logic;
	Addr1 : std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
	Addr2 : std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
	Addr3 : std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
	wd : std_logic_vector(BIT_WIDTH-1 downto 0);
	RD1 : std_logic_vector(BIT_WIDTH-1 downto 0);
	RD2 : std_logic_vector(BIT_WIDTH-1 downto 0);
end record;

constant num_tests : integer := 12;
type test_array is array (0 to num_tests-1) of test_vector;

constant test_vector_array : test_array := (
    -- Write value to empty register, then read
    (we => '1', Addr1 => "000", Addr2 => "000", Addr3 => "001", wd => x"10", RD1 => x"00", RD2 => x"00"),  -- write 0x10 to R1.
    (we => '0', Addr1 => "001", Addr2 => "000", Addr3 => "000", wd => x"00", RD1 => x"10", RD2 => x"00"),  -- read R1. should be 0x10.

    -- Overwrite value in register, then read
    (we => '1', Addr1 => "000", Addr2 => "000", Addr3 => "001", wd => x"FF", RD1 => x"00", RD2 => x"00"),  -- overwrite R1 with 0xFF.
    (we => '0', Addr1 => "001", Addr2 => "000", Addr3 => "000", wd => x"00", RD1 => x"FF", RD2 => x"00"),  -- read R1. should be 0xFF.

    -- Read from unwritten register
    (we => '0', Addr1 => "010", Addr2 => "000", Addr3 => "000", wd => x"00", RD1 => x"00", RD2 => x"00"),  -- read R2. should be 0x00.

    -- Attempt write with we disabled.
    (we => '0', Addr1 => "000", Addr2 => "000", Addr3 => "010", wd => x"FF", RD1 => x"00", RD2 => x"00"),  -- attempt write R2 with 0xFF. should fail.
    (we => '0', Addr1 => "010", Addr2 => "000", Addr3 => "000", wd => x"00", RD1 => x"00", RD2 => x"00"),  -- read R2. should be 0x00.

    -- Discluded from prelab, because I can only have 10 tests.
    -- Attempt write to R0.
    -- (we => '1', Addr1 => "000", Addr2 => "000", Addr3 => "000", wd => x"FF", RD1 => x"00", RD2 => x"00"),  -- attempt write R0 with 0xFF. should fail.
    -- (we => '0', Addr1 => "000", Addr2 => "000", Addr3 => "000", wd => x"00", RD1 => x"00", RD2 => x"00"),  -- read R0. should be 0x00.

    -- Initial tests
    (we => '0', Addr1 => "000", Addr2 => "000", Addr3 => "001", wd => x"10", RD1 => x"00", RD2 => x"00"),
    (we => '1', Addr1 => "000", Addr2 => "000", Addr3 => "001", wd => x"10", RD1 => x"00", RD2 => x"00"),
    (we => '1', Addr1 => "001", Addr2 => "000", Addr3 => "010", wd => x"ff", RD1 => x"10", RD2 => x"00"),

    (we => '1', Addr1 => "000", Addr2 => "000", Addr3 => "010", wd => x"FF", RD1 => x"00", RD2 => x"00"),  -- write 0x10 to R2.
    (we => '0', Addr1 => "000", Addr2 => "010", Addr3 => "000", wd => x"00", RD1 => x"00", RD2 => x"FF")   -- read R2. should be 0x10.

);
component RegisterFile is
	PORT (
	------------ INPUTS ---------------
		clk_n	: in std_logic;
		we		: in std_logic;
		Addr1	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --read address 1
		Addr2	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --read address 2
		Addr3	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --write address
		wd		: in std_logic_vector(BIT_WIDTH-1 downto 0); --write data, din

	------------- OUTPUTS -------------
		RD1		: out std_logic_vector(BIT_WIDTH-1 downto 0); --Read from Addr1
		RD2		: out std_logic_vector(BIT_WIDTH-1 downto 0) --Read from Addr2
	);
end component;

signal clk_n	: std_logic;
signal we		: std_logic;
signal Addr1	: std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --read address 1
signal Addr2	: std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --read address 2
signal Addr3	: std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --write address
signal wd		: std_logic_vector(BIT_WIDTH-1 downto 0); --write data, din
signal RD1		: std_logic_vector(BIT_WIDTH-1 downto 0); --Read from Addr1
signal RD2		: std_logic_vector(BIT_WIDTH-1 downto 0); --Read from Addr2

begin

UUT : RegisterFile
	port map (
	------------ INPUTS ---------------
		clk_n	 => clk_n,
		we		 => we,
		Addr1	 => Addr1,
		Addr2	 => Addr2,
		Addr3	 => Addr3,
		wd		 => wd,
	------------- OUTPUTS -------------
		RD1		 => RD1,
		RD2		 => RD2
	);

clk_proc:process
begin
	clk_n <= '1';
	wait for 50 ns;
	clk_n <= '0';
	wait for 50 ns;
end process;

stim_proc:process
begin
	for i in 0 to num_tests-1 loop
		we <= test_vector_array(i).we;
		Addr1 <= test_vector_array(i).Addr1;
		Addr2 <= test_vector_array(i).Addr2;
		Addr3 <= test_vector_array(i).Addr3;
		wd <= test_vector_array(i).wd;
		wait for 100 ns;

        assert test_vector_array(i).RD1 = RD1
        report "RD1 does not match on test #" & integer'image(i)
        severity failure;

        assert test_vector_array(i).RD2 = RD2
        report "RD2 does not match on test #" & integer'image(i)
        severity failure;
	end loop;

	-- Stop testbench once done testing
	assert false
		report "Testbench Concluded"
		severity failure;

end process;

end tb;
