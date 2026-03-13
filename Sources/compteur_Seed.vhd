----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2025 04:02:21 PM
-- Design Name: 
-- Module Name: compteur_Seed - Behavioral
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

entity compteur_Seed is
    Port ( clk : in STD_LOGIC;
           seed : out STD_LOGIC_VECTOR (16 downto 0)); 
end compteur_Seed;

architecture Behavioral of compteur_Seed is

signal cmp : unsigned(16 downto 0) := to_unsigned(0, 17); 

begin

process (clk)
begin 
    if rising_edge(clk) then 
        if(cmp = to_unsigned(131071, 17)) then  
            cmp <= TO_UNSIGNED(0, 17); 
        else     
            cmp <= cmp + to_unsigned(1, 17); 
        end if; 
    end if; 
end process; 

seed <= std_logic_vector(cmp); 

end Behavioral;