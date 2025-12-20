----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2025 03:10:08 PM
-- Design Name: 
-- Module Name: LFSR - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LFSR is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           seed : in STD_LOGIC_VECTOR(16 downto 0); 
           lfsr_res : out STD_LOGIC_VECTOR (16 downto 0);  
           lfsr_counter : out std_logic_vector(16 downto 0);
           initialization_done : out STD_LOGIC);
end LFSR;

architecture Behavioral of LFSR is

-- Polynôme primitif pour 17 bits: x^17 + x^14 + 1

signal lfsr_reg : unsigned(16 downto 0) := "10101100111000010";  

signal init_done : std_logic := '0';
signal lfsr_counter_inter : unsigned(16 downto 0) := to_unsigned(0, 17); 

begin

lfsr_process : process(clk)
    variable lfsr_next : std_logic;
begin
    if rising_edge(clk) then
        if raz = '1' then
            lfsr_reg <= unsigned(seed);
            lfsr_counter_inter <= (others => '0');
            init_done <= '0';
        elsif init_done = '0' then
            if lfsr_counter_inter < 76800 then
                lfsr_next := lfsr_reg(16) xor lfsr_reg(13);
                lfsr_reg <= lfsr_reg(15 downto 0) & lfsr_next;
                lfsr_counter_inter <= lfsr_counter_inter + 1;
            else
                init_done <= '1';
            end if;
        end if;
    end if;
end process;

initialization_done <= init_done; 
lfsr_res <= std_logic_vector(lfsr_reg); 
lfsr_counter <= std_logic_vector(lfsr_counter_inter); 

end Behavioral;