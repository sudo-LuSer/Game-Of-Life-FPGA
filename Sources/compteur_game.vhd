----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2025 04:37:25 PM
-- Design Name: 
-- Module Name: compteur_game - Behavioral
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

entity compteur_game is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           ce : in STD_LOGIC; 
           x : out STD_LOGIC_VECTOR (8 downto 0); 
           y : out STD_LOGIC_VECTOR (7 downto 0); 
           done : out std_logic);
end compteur_game;

architecture Behavioral of compteur_game is

signal count_x : unsigned(8 downto 0) := (others => '0'); 
signal count_y : unsigned(7 downto 0) := (others => '0'); 
signal done_reg : std_logic := '0'; 

begin

process(clk)

variable is_last_cell : boolean := false; 

begin               
    if rising_edge(clk) then
        if raz = '1' then 
            done_reg <= '0'; 
            count_x <= (others => '0'); 
            count_y <= (others => '0');
            is_last_cell := false;
        elsif ce = '1' then 
            done_reg <= '0';
            
            if count_x = 319 and count_y = 239 then
                is_last_cell := true;
            else
                is_last_cell := false;
            end if;
            
            if count_x = 319 then
                count_x <= (others => '0');
                if count_y = 239 then
                    count_y <= (others => '0');
                else
                    count_y <= count_y + 1;
                end if;
            else
                count_x <= count_x + 1;
            end if;
            
            if is_last_cell then
                done_reg <= '1';
            end if;
        end if;  
    end if;                    
end process;

x <= std_logic_vector(count_x); 
y <= std_logic_vector(count_y); 
done <= done_reg;

end Behavioral;      