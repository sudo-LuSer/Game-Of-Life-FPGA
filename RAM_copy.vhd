----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2025 08:17:42 AM
-- Design Name: 
-- Module Name: RAM_copy - Behavioral
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

entity RAM_copy is
    Port ( clk : in STD_LOGIC;
           s_write : in STD_LOGIC;
           s_address : in STD_LOGIC_VECTOR (16 downto 0);
           s_x : in STD_LOGIC_VECTOR (8 downto 0);
           s_y : in STD_LOGIC_VECTOR (7 downto 0);
           s_color_in : in STD_LOGIC;
           s_color_out : out STD_LOGIC);
end RAM_copy;

architecture Behavioral of RAM_copy is

type grid_ram_type is array (0 to 76799) of std_logic; 
signal grid_ram : grid_ram_type := (others => '0');

signal read_address : integer range 0 to 76799;
signal write_address : integer range 0 to 76799;

begin

    read_address <= to_integer(unsigned(s_y)) * 320 + to_integer(unsigned(s_x));
    write_address <= to_integer(unsigned(s_address));

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) then
            if s_write = '1' then
                if write_address < 76800 then
                    grid_ram(write_address) <= s_color_in;
                else 
                    grid_ram(write_address) <= '0';
                end if;
            else
                if(read_address < 76800)then 
                    s_color_out <= grid_ram(read_address); 
                else
                    s_color_out <= '0'; 
                end if; 
            end if;
        END IF;
    END PROCESS;

end Behavioral;