----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2025 07:17:42 PM
-- Design Name: 
-- Module Name: Gest_Freq - Behavioral
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

entity Gest_Freq is
    Generic (
        CLK_FREQ : integer := 100000000;  
        UPDATE_FREQ : integer := 2      
    );
    Port ( 
        clk : in STD_LOGIC;
        raz : in STD_LOGIC;
        update_flag : out STD_LOGIC
    );
end Gest_Freq;

architecture Behavioral of Gest_Freq is

    constant MAX_COUNT : integer := (CLK_FREQ / UPDATE_FREQ) - 1;
    signal counter : unsigned(31 downto 0) := (others => '0');
    
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if raz = '1' then
                counter <= (others => '0');
                update_flag <= '0';
            else
                if counter = to_unsigned(MAX_COUNT, 32) then
                    counter <= (others => '0');
                    update_flag <= '1';
                else
                    counter <= counter + 1;
                    update_flag <= '0';
                end if;
            end if;
        end if;
    end process;

end Behavioral;