library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity address_counter is
    Port (
        clk     : in  STD_LOGIC;
        raz     : in  STD_LOGIC;
        ce      : in  STD_LOGIC;
        address : out STD_LOGIC_VECTOR (16 downto 0);
        write   : out STD_LOGIC;
        x       : out STD_LOGIC_VECTOR (8 downto 0);
        y       : out STD_LOGIC_VECTOR (7 downto 0);
        done    : out STD_LOGIC
    );
end address_counter;

architecture Behavioral of address_counter is

signal count_val : unsigned(16 downto 0) := (others => '0');
signal count_x   : unsigned(8 downto 0)  := (others => '0'); 
signal count_y   : unsigned(7 downto 0)  := (others => '0'); 
signal s_write   : std_logic := '0';
signal done_reg  : std_logic := '0';

begin

process(clk)
begin
    if rising_edge(clk) then
        if raz = '1' then
            s_write <= '0';
        elsif ce = '1' then
            s_write <= '1';
        else
            s_write <= '0';
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        if raz = '1' then
            count_val <= (others => '0');
            count_x <= (others => '0');
            count_y <= (others => '0');
            done_reg <= '0';
            
        elsif ce = '1' and s_write = '1' then  

            if count_val = to_unsigned(76799, 17) then
                count_val <= (others => '0');
                count_x <= (others => '0');
                count_y <= (others => '0');
                done_reg <= '1';
            else
                count_val <= count_val + 1;
                done_reg <= '0';
            end if;
            
            if count_x = to_unsigned(319, 9) then
                count_x <= (others => '0');
                if count_y = to_unsigned(239, 8) then
                    count_y <= (others => '0');
                else
                    count_y <= count_y + 1;
                end if;
            else
                count_x <= count_x + 1;
            end if;
        else
            count_val <= (others => '0');
            count_x <= (others => '0');
            count_y <= (others => '0');
            done_reg <= '0';
        end if;
        
    end if;
end process;

x <= std_logic_vector(count_x);
y <= std_logic_vector(count_y);
address <= std_logic_vector(count_val);
write <= s_write; 
done <= done_reg; 

end Behavioral;