----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2025 04:02:57 PM
-- Design Name: 
-- Module Name: conversion_bit_pixel - Behavioral
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

entity conversion_bit_pixel is
    Port ( cell_state : in STD_LOGIC;
           s_color : out STD_LOGIC_VECTOR (2 downto 0));
end conversion_bit_pixel;

architecture Behavioral of conversion_bit_pixel is

constant COLOR_BLACK : std_logic_vector(2 downto 0) := "000";
constant COLOR_WHITE : std_logic_vector(2 downto 0) := "111";

begin
    
    process (cell_state) 
    begin 
   
        if(cell_state = '0')then 
            s_color <= COLOR_WHITE;
        else
            s_color <= COLOR_BLACK;
        end if;
    
    end process; 

end Behavioral;