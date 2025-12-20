library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           init_done : in STD_LOGIC;
           done : in STD_LOGIC;
           FInREG : in STD_LOGIC;
           DONEcount : in STD_LOGIC; 
           CE_COMPTE : out STD_LOGIC;
           CE_NEIGHBOUR : out STD_LOGIC;
           CE_VERIF_CELLULE : out STD_LOGIC;
           CE_VGA : out STD_LOGIC;
           CE_LFSR : out STD_LOGIC;
           CE_COPY : out STD_LOGIC;
           CE_EDIT : out STD_LOGIC;
           color_out_edit : in STD_LOGIC;
           update_flag : in STD_LOGIC;
           copy_done : in STD_LOGIC; 
           address_x : out STD_LOGIC_VECTOR (8 downto 0);
           address_y : out STD_LOGIC_VECTOR (7 downto 0);
           copy_x : in std_logic_vector(8 downto 0);
           copy_y : in std_logic_vector(7 downto 0);
           address_copy_x : out STD_LOGIC_VECTOR (8 downto 0);
           address_copy_y : out STD_LOGIC_VECTOR (7 downto 0);
           address_copy : out STD_LOGIC_VECTOR (16 downto 0);
           x_neighbor : in STD_LOGIC_VECTOR (8 downto 0); 
           y_neighbor : in STD_LOGIC_VECTOR (7 downto 0);
           RW : out STD_LOGIC;
           gest_RW_edit : in STD_LOGIC;
           addressArith : out STD_LOGIC_VECTOR (16 downto 0); 
           COLOR_MACHINE : out STD_LOGIC;
           address_VGA : in STD_LOGIC_VECTOR (16 downto 0);   
           write_VGA : in std_logic ;
           x_VGA : in STD_LOGIC_VECTOR (8 downto 0);
           y_VGA : in STD_LOGIC_VECTOR (7 downto 0);
           x_edit : in STD_LOGIC_VECTOR (8 downto 0);
           y_edit : in STD_LOGIC_VECTOR (7 downto 0);
           EE : in STD_LOGIC; 
           sw_edit : in STD_LOGIC; 
           init_write : in STD_LOGIC;
           init_color_in : in STD_LOGIC;
           init_address : in STD_LOGIC_VECTOR (16 downto 0);  
           copy_address : in STD_LOGIC_VECTOR (16 downto 0); 
           pixelx : in STD_LOGIC_VECTOR (8 downto 0);
           pixely : in STD_LOGIC_VECTOR (7 downto 0);
           led_debug : out STD_LOGIC_VECTOR(5 downto 0));
end FSM;

architecture Behavioral of FSM is

type state is (LFSR_INIT, COPY, COMPTE, COUNT_NEIGHBOUR, VERIF_CELLULE, AFFICHAGE, WAIT_VGA, EDIT_GAME); 
signal etat_p , etat_f : state; 
signal debug : std_logic_vector(5 downto 0);

begin

process (etat_p, copy_done, init_done, done, FInREG, DONEcount, update_flag, sw_edit) 
begin 
    etat_f <= etat_p;  
    debug <= (others => '0');
    
    case etat_p is 
        when LFSR_INIT => 
            debug <= "000001";
            if(init_done = '1') then 
                etat_f <= COPY;
            end if;
            
        when COPY =>
            debug <= "000010";
            if(copy_done = '1') then 
                etat_f <= COMPTE;
            end if;
            
        when COMPTE => 
            debug <= "000100";
            if(done = '1') then 
                etat_f <= AFFICHAGE; 
            else 
                etat_f <= COUNT_NEIGHBOUR; 
            end if;
            
        when COUNT_NEIGHBOUR => 
            debug <= "001000";
            if(FInREG = '1') then 
                etat_f <= VERIF_CELLULE; 
            end if;
            
        when VERIF_CELLULE => 
            debug <= "010000";
            etat_f <= COMPTE;
            
        when AFFICHAGE => 
            debug <= "100000";
            if(DONEcount = '1') then 
                etat_f <= WAIT_VGA;  
            end if;
            
        when WAIT_VGA => 
            debug <= "101010";
            if(update_flag = '1') then 
                etat_f <= COPY; 
            elsif(sw_edit = '1')then 
                etat_f <= EDIT_GAME;
            end if;
        when EDIT_GAME =>
            debug <= "111111";
            if(sw_edit = '0')then 
                etat_f <= WAIT_VGA; 
            end if;
    end case;
end process; 

process (clk) 
begin 
    if(rising_edge(clk)) then 
        if(raz = '1') then 
            etat_p <= LFSR_INIT;
        else 
            etat_p <= etat_f; 
        end if;  
    end if; 
end process; 

process(etat_p, init_write, init_color_in, init_address, copy_address, copy_x, copy_y, 
        x_neighbor, y_neighbor, pixelx, pixely, EE, address_VGA, x_VGA, y_VGA, write_VGA, x_edit, y_edit, gest_RW_edit, color_out_edit)
begin
    CE_LFSR <= '0';
    CE_COMPTE <= '0'; 
    CE_NEIGHBOUR <= '0'; 
    CE_VERIF_CELLULE <= '0'; 
    CE_COPY <= '0'; 
    CE_VGA <= '0';
    CE_EDIT <= '0'; 
    RW <= '0';
    COLOR_MACHINE <= '0';
    address_x <= (others => '0');
    address_y <= (others => '0');
    addressArith <= (others => '0');
    address_copy <= (others => '0');
    address_copy_x <= (others => '0');
    address_copy_y <= (others => '0');
    case etat_p is
        when LFSR_INIT => 
            CE_LFSR <= '1';
            RW <= init_write;
            COLOR_MACHINE <= init_color_in;
            addressArith <= init_address;  
        
        when COPY => 
            CE_COPY <= '1'; 
            addressArith <= copy_address;
            address_x <= copy_x;
            address_y <= copy_y;
            address_copy <= copy_address;
            address_copy_x <= copy_x;
            address_copy_y <= copy_y;
            RW <= '0'; 
        when COMPTE => 
            CE_COMPTE <= '1'; 
            address_copy <= std_logic_vector(to_unsigned((to_integer(unsigned(pixely)) * 320) + to_integer(unsigned(pixelx)), 17));
            address_copy_x <= pixelx;
            address_copy_y <= pixely;
        
        when COUNT_NEIGHBOUR => 
            CE_NEIGHBOUR <= '1'; 
            address_copy <= std_logic_vector(to_unsigned((to_integer(unsigned(y_neighbor)) * 320) + to_integer(unsigned(x_neighbor)), 17));
            address_copy_x <= x_neighbor;
            address_copy_y <= y_neighbor;
        
        when VERIF_CELLULE => 
            CE_VERIF_CELLULE <= '1'; 
            RW <= '1';
            address_copy_x <= pixelx;
            address_copy_y <= pixely;
            addressArith <= std_logic_vector(to_unsigned((to_integer(unsigned(pixely)) * 320) + to_integer(unsigned(pixelx)), 17));
            COLOR_MACHINE <= EE;
        
        when AFFICHAGE => 
            CE_VGA <= '1';
            addressArith <= address_VGA;
            address_x <= x_VGA;
            address_y <= y_VGA;
            RW <= not write_VGA; 
        when WAIT_VGA =>
            CE_VGA <= '0';
            addressArith <= address_VGA;
            address_x <= x_VGA;
            address_y <= y_VGA;
            RW <= '0';
            CE_LFSR <= '0';
            CE_COMPTE <= '0'; 
            CE_NEIGHBOUR <= '0'; 
            CE_VERIF_CELLULE <= '0'; 
            CE_COPY <= '0'; 
            CE_EDIT <= '0'; 
            COLOR_MACHINE <= '0';
            address_copy <= (others => '0');
            address_copy_x <= (others => '0');
            address_copy_y <= (others => '0');
        when EDIT_GAME => 
            CE_EDIT <= '1'; 
            addressArith <= std_logic_vector(to_unsigned((to_integer(unsigned(y_edit)) * 320) + to_integer(unsigned(x_edit)), 17));
            address_x <= x_edit;
            address_y <= y_edit;
            RW <= gest_RW_edit;
            CE_LFSR <= '0';
            CE_COMPTE <= '0'; 
            CE_NEIGHBOUR <= '0'; 
            CE_VERIF_CELLULE <= '0'; 
            CE_COPY <= '0';
            CE_VGA <= '0'; 
            COLOR_MACHINE <= color_out_edit;
            address_copy <= (others => '0');
            address_copy_x <= (others => '0');
            address_copy_y <= (others => '0');
    end case;
end process;

led_debug <= debug; 

end Behavioral;