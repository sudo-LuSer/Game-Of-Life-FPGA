----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2025 06:04:52 PM
-- Design Name: 
-- Module Name: verif_cellule - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity verif_cellule is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           ce : in STD_LOGIC;
           E : in STD_LOGIC;
           S : in STD_LOGIC_VECTOR(4 downto 0);
           EE : out STD_LOGIC);
end verif_cellule;

architecture Behavioral of verif_cellule is

signal EEE : std_logic := '0'; 
signal survive_rule, birth_rule : std_logic := '0';

begin

process (clk)
begin 
    if rising_edge(clk) then 
        if raz = '1' then
           EEE <= '0'; 
        else 
            if ce = '1' then 
                if (E = '1') and (S = "00010" or S = "00011") then
                    survive_rule <= '1';
                else
                    survive_rule <= '0';
                end if;
                
                if (E = '0') and (S = "00011") then
                    birth_rule <= '1';
                else
                    birth_rule <= '0';
                end if;
                
                EEE <= survive_rule or birth_rule;  
            end if; 
        end if; 
    end if; 
end process; 

EE <= EEE; 

end Behavioral;