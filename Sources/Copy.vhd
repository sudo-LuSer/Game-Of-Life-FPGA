library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Copy is
    Port (
        clk       : in STD_LOGIC;
        raz       : in STD_LOGIC;
        ce        : in STD_LOGIC;
        copy_done : out STD_LOGIC;
        s_x       : out STD_LOGIC_VECTOR (8 downto 0);
        s_y       : out STD_LOGIC_VECTOR (7 downto 0);
        s_address : out STD_LOGIC_VECTOR (16 downto 0)
    );
end Copy;

architecture Behavioral of Copy is

signal count_x : unsigned(8 downto 0) := (others => '0');
signal count_y : unsigned(7 downto 0) := (others => '0');
signal done_reg : std_logic := '0';
signal addr_reg : unsigned(16 downto 0) := (others => '0');

signal next_x : unsigned(8 downto 0);
signal next_y : unsigned(7 downto 0);
signal next_done : std_logic;

constant MAX_X : integer := 319;
constant MAX_Y : integer := 239;

begin

process(count_x, count_y)
begin

    next_x <= count_x;
    next_y <= count_y;
    next_done <= '0';
    
    if count_x = to_unsigned(MAX_X, 9) then
        next_x <= (others => '0');
        if count_y = to_unsigned(MAX_Y, 8) then
            next_y <= (others => '0');
            next_done <= '1'; 
        else
            next_y <= count_y + 1;
        end if;
    else
        next_x <= count_x + 1;
    end if;
end process;

process(clk)
    variable tmp_addr : unsigned(16 downto 0);
begin
    if rising_edge(clk) then
        if raz = '1' then
            count_x <= (others => '0');
            count_y <= (others => '0');
            done_reg <= '0';
            addr_reg <= (others => '0');
        else
            if ce = '1' then
                tmp_addr := resize(count_y * to_unsigned(320, 9) + count_x, 17);
                addr_reg <= tmp_addr;
                count_x <= next_x;
                count_y <= next_y;
                done_reg <= next_done;
            else
                count_x <= (others => '0');
                count_y <= (others => '0');
                addr_reg <= (others => '0');
                done_reg <= '0';
            end if;
        end if;
    end if;
end process;

copy_done <= done_reg;
s_x <= std_logic_vector(count_x); 
s_y <= std_logic_vector(count_y); 
s_address <= std_logic_vector(addr_reg);

end Behavioral;