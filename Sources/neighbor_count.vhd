library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity neighbor_count is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           ce : in STD_LOGIC;
           x : in STD_LOGIC_VECTOR (8 downto 0);  
           y : in STD_LOGIC_VECTOR (7 downto 0); 
           neighbors_count : out STD_LOGIC_VECTOR (4 downto 0);         
           cell_data_in : in STD_LOGIC;
           FIN : out std_logic;
           x_neighbor : out STD_LOGIC_VECTOR (8 downto 0); 
           y_neighbor : out STD_LOGIC_VECTOR (7 downto 0));         
end neighbor_count;

architecture Behavioral of neighbor_count is

type state_type is (IDLE , COMPUTE,WAIT_READ, READ_NEIGHBORS, DONE);
signal state : state_type := IDLE;

signal neighbor_index : integer range 0 to 8 := 0;
signal count_reg : unsigned(4 downto 0) := (others => '0');
signal FINreg : std_logic := '0';

signal x_neighbor_reg : STD_LOGIC_VECTOR (8 downto 0); 
signal y_neighbor_reg : STD_LOGIC_VECTOR (7 downto 0);

type offset_array is array (0 to 7) of integer;
constant dx : offset_array := (-1, 0, 1, -1, 1, -1, 0, 1);
constant dy : offset_array := (-1, -1, -1, 0, 0, 1, 1, 1); 

begin

process(clk)
    variable temp_x, temp_y : integer;
    variable is_valid : boolean;
begin
    if rising_edge(clk) then
        if raz = '1' then
            state <= IDLE;
            neighbor_index <= 0;
            count_reg <= (others => '0');
            FINreg <= '0';
        elsif(ce = '1')then
            case state is
                when IDLE =>
                    FINreg <= '0';
                    count_reg <= (others => '0');
                    state <= COMPUTE;
                    neighbor_index <= 0;
                when COMPUTE => 
                    if neighbor_index < 8 then
                        temp_x := to_integer(unsigned(x)) + dx(neighbor_index);
                        temp_y := to_integer(unsigned(y)) + dy(neighbor_index);
                        
                        is_valid := (temp_x >= 0) and (temp_x < 320) and (temp_y >= 0) and (temp_y < 240);
                        if is_valid then
                            x_neighbor_reg <= std_logic_vector(to_unsigned(temp_x ,9));
                            y_neighbor_reg <= std_logic_vector(to_unsigned(temp_y ,8));
                            state <= WAIT_READ; 
                        else
                            neighbor_index <= neighbor_index + 1; 
                            state <= COMPUTE;
                        end if;
                    else
                        state <= DONE; 
                    end if;
                when WAIT_READ => 
                    state <= READ_NEIGHBORS;
                    
                when READ_NEIGHBORS =>
                    if cell_data_in = '1' then 
                        count_reg <= count_reg + 1; 
                    end if; 
                    neighbor_index <= neighbor_index + 1; 
                    state <= COMPUTE; 
                                        
                when DONE =>
                    neighbors_count <= std_logic_vector(count_reg);
                    FINreg <= '1';  
                    state <= IDLE;         
            end case;
        else 
            state <= IDLE;
            neighbor_index <= 0;
            count_reg <= (others => '0');
            FINreg <= '0';
        end if;
    end if;
end process;

FIN <= FINreg;
x_neighbor <= x_neighbor_reg; 
y_neighbor <= y_neighbor_reg; 


end Behavioral;