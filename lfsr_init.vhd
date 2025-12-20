----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2025 04:50:43 PM
-- Design Name: 
-- Module Name: lfsr_init - Behavioral
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

entity lfsr_init is
    Port ( lfsr_reg : in STD_LOGIC_vector(3 downto 0);
           lfsr_counter : in STD_LOGIC_VECTOR (16 downto 0); 
           clk : in STD_LOGIC;
           ce : in std_logic; 
           raz : in STD_LOGIC;
           init_write : out STD_LOGIC;
           init_color_in : out STD_LOGIC;
           init_address : out STD_LOGIC_VECTOR (16 downto 0)); 
end lfsr_init;

architecture Behavioral of lfsr_init is

begin

init_process : process(clk)
begin
    if rising_edge(clk) then
        if raz = '1' then
            init_write <= '0';
            init_color_in <= '0';
            init_address <= (others => '0');
        elsif ce = '1' then 
            if (unsigned(lfsr_counter) < to_unsigned(76800 , 17)) then 
                init_write <= '1';
                init_address <= lfsr_counter(16 downto 0);
                if lfsr_reg = "0000" then  -- 1/16 = 6%
                    init_color_in <= '1';
                else
                    init_color_in <= '0';
                end if;
            else
                init_write <= '0';
            end if;
        else
            init_write <= '0';
        end if;
    end if;
end process;

end Behavioral;