----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/21/2025 02:13:31 PM
-- Design Name: 
-- Module Name: game_edit - Behavioral
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

entity game_edit is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           gest_edit : in STD_LOGIC;
           b_up : in STD_LOGIC;
           b_down : in STD_LOGIC;
           b_left : in STD_LOGIC;
           b_right : in STD_LOGIC;
           b_center : in STD_LOGIC;
           color_out : out STD_LOGIC;
           x : out STD_LOGIC_VECTOR (8 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0);
           gest_RW_RAM : out STD_LOGIC;
           color_in : in STD_LOGIC);
end game_edit;

architecture Behavioral of game_edit is

type state is (INIT, DEPLACEMENT, WAIT_STATE, EDIT_CELL);

signal etat_prst, etat_futur : state;

signal s_x : unsigned (8 downto 0);
signal s_y : unsigned (7 downto 0);

signal mem_x : unsigned (8 downto 0) := TO_UNSIGNED (0, 9);
signal mem_y : unsigned (7 downto 0) := TO_UNSIGNED (0, 8);


begin

    x <= std_logic_vector (s_x);
    y <= std_logic_vector (s_y);

    process_synchrone : process(clk)
    
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                etat_prst <= INIT;
            else
                etat_prst <= etat_futur;
            end if;
        end if;
        
    end process;
    
    gestion_etat : process(etat_prst, b_right, b_left, b_up, b_down, b_center, gest_edit, color_in, mem_x, mem_y, s_x, s_y)
    
    begin
    
        case etat_prst is
            when INIT =>
                if (gest_edit = '1') then
                    etat_futur <= DEPLACEMENT;
                else
                    etat_futur <= INIT;
                end if;
                
                color_out <= color_in;
                s_x <= mem_x;
                s_y <= mem_y;
                gest_RW_RAM <= '0';
                
            when DEPLACEMENT =>
                if (b_center = '1') then
                    etat_futur <= WAIT_STATE;
                elsif (gest_edit = '0') then
                    etat_futur <= INIT;
                    mem_x <= s_x;
                    mem_y <= s_y;
                else
                    etat_futur <= DEPLACEMENT;
                end if;
                
                if (b_right = '1') then
                    if (s_x < "111111111") then
                        s_x <= s_x + TO_UNSIGNED (1, 9);
                    else
                        s_x <= "000000000";
                    end if;
                end if;
                
                if (b_left = '1') then
                    if (s_x > "000000000") then
                        s_x <= s_x - TO_UNSIGNED (1, 9);
                    else
                        s_x <= "111111111";
                    end if;
                end if;
                
                if (b_up = '1') then
                    if (s_y > "00000000") then
                        s_y <= s_y - TO_UNSIGNED (1, 8);
                    else
                        s_y <= "11111111";
                    end if;
                end if;
                
                if (b_down = '1') then
                    if (s_y < "11111111") then
                        s_y <= s_y + TO_UNSIGNED (1, 8);
                    else
                        s_y <= "00000000";
                    end if;
                end if;
                
                color_out <= color_in; 
                gest_RW_RAM <= '0';
            when WAIT_STATE =>
                gest_RW_RAM <= '1';
                etat_futur <= EDIT_CELL;
                
            when EDIT_CELL =>
                if (gest_edit = '0') then
                    etat_futur <= INIT;
                    mem_x <= s_x;
                    mem_y <= s_y;
                else
                    etat_futur <= DEPLACEMENT;
                end if;
                
                color_out <= not color_in; -- on change l'état de la cellule
        end case;
        
    end process;

end Behavioral;