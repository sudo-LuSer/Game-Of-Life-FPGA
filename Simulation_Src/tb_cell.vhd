library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_conversion_bit_pixel_simple is
end tb_conversion_bit_pixel_simple;

architecture Behavioral of tb_conversion_bit_pixel_simple is

    signal cell_state : STD_LOGIC := '0';
    signal s_color : STD_LOGIC_VECTOR (2 downto 0);

begin

    uut: entity work.conversion_bit_pixel
        port map (
            cell_state => cell_state,
            s_color => s_color
        );

    stimulus: process
    begin
        -- Test dead cell (0 -> black)
        cell_state <= '0';
        wait for 10 ns;
        
        -- Test live cell (1 -> white)
        cell_state <= '1';
        wait for 10 ns;
        
        -- Test dead cell again
        cell_state <= '0';
        wait for 10 ns;
        
        -- Test live cell again
        cell_state <= '1';
        wait for 10 ns;
        
        report "Simulation completed";
        wait;
    end process;

end Behavioral;