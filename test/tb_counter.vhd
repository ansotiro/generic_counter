----------------------------------------------------------------------------------
--                 ________  __       ___  _____        __
--                /_  __/ / / / ___  / _/ / ___/______ / /____
--                 / / / /_/ / / _ \/ _/ / /__/ __/ -_) __/ -_)
--                /_/  \____/  \___/_/   \___/_/  \__/\__/\__/
--
----------------------------------------------------------------------------------
--
-- Author(s):   ansotiropoulos
--
-- Design Name: generic_counter
-- Module Name: tb_counter
--
-- Description: Testbench for generic COUNTER
--
-- Copyright:   (C) 2016 Microprocessor & Hardware Lab, TUC
--
-- This source file is free software; you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published
-- by the Free Software Foundation; either version 2.1 of the License, or
-- (at your option) any later version.
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;

ENTITY tb_counter IS
END tb_counter;

architecture behavior of tb_counter is

component COUNTER
generic (
    N       : integer := 4
);
port (
    CLK     : in  std_logic;
    RST     : in  std_logic;
    DRST    : in  std_logic_vector (3 downto 0);
    SET     : in  std_logic;
    DSET    : in  std_logic_vector (3 downto 0);
    EN      : in  std_logic;
    DOUT    : out std_logic_vector (3 downto 0)
);
end component;

procedure printf_slv (dat : in std_logic_vector (3 downto 0); file f: text) is
    variable my_line : line;
begin
    write(my_line, CONV_INTEGER(dat));
    write(my_line, string'(" -   ("));
    write(my_line, now);
    write(my_line, string'(")"));
    writeline(f, my_line);
end procedure printf_slv;



constant CLK_period : time := 10 ns;

signal CLK  : std_logic := '0';
signal RST  : std_logic := '0';
signal DRST : std_logic_vector (3 downto 0) := (others => '0');
signal SET  : std_logic := '0';
signal DSET : std_logic_vector (3 downto 0) := (others => '0');
signal EN   : std_logic := '0';
signal DOUT : std_logic_vector (3 downto 0) := (others => '0');

file file_q : text open WRITE_MODE is "out/test_d.out";


begin

CNT: COUNTER
generic map (
    N       => 4
)
port map (
    CLK     => CLK,
    RST     => RST,
    DRST    => DRST,
    SET     => SET,
    DSET    => DSET,
    EN      => EN,
    DOUT    => DOUT
);

CLKP :process
begin
    CLK <= '0';
    wait for CLK_period/2;
    CLK <= '1';
    wait for CLK_period/2;
end process;

TRACE: process (DOUT)
begin
    printf_slv(DOUT, file_q);
end process;

SIMUL: process
begin

wait until rising_edge(CLK);

RST  <= '0';
DRST <= "1000";
SET  <= '0';
DSET <= "0001";
EN   <= '0';
wait for CLK_period*10;

RST  <= '1';
wait for CLK_period*10;

RST  <= '0';
wait for CLK_period*10;

for K in 1 to 20 loop
    for J in 1 to 2 loop
        for I in 1 to 10 loop
            SET  <= '0';
            EN   <= '1';
            wait for CLK_period;
        end loop;
        for I in 1 to 10 loop
            SET  <= '0';
            EN   <= '0';
            wait for CLK_period;
        end loop;
    end loop;
    SET  <= '1';
    EN   <= '1';
    wait for CLK_period;
end loop;

wait;
end process;

end;
