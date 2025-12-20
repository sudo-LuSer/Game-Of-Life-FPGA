----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/08/2025 06:15:21 AM
-- Design Name: 
-- Module Name: affichage_vga - Behavioral
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

entity affichage_vga is
  Port ( 
        clk          : in STD_LOGIC;
        raz          : in STD_LOGIC;
        btnc         : in STD_LOGIC;
        btnr         : in STD_LOGIC;
        btnl         : in STD_LOGIC;
        btnu         : in STD_LOGIC;
        btnd         : in STD_LOGIC;
        VGA_hs       : out std_logic;
        VGA_vs       : out std_logic;
        VGA_color    : out std_logic_vector(11 downto 0);
        sw           : in std_logic_vector(7 downto 0);
        led          : out std_logic_vector(8 downto 0)
        );
end affichage_vga;

architecture Behavioral of affichage_vga is

component address_counter is
Port ( clk : in STD_LOGIC;
       raz : in STD_LOGIC;
       address : out STD_LOGIC_VECTOR (16 downto 0); 
       ce : in std_logic; 
       done : out std_logic; 
       write : out std_logic; 
       x : out STD_LOGIC_VECTOR (8 downto 0);
       y : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component VGA_bitmap_320x240 is
generic(CLK_FREQ : integer := 100000000;
        RAM_BPP  : integer range 1 to 12:= 8;
        HARD_BPP : integer range 1 to 16:= 12;
        INDEXED  : integer range 0 to  1:= 0;
        READBACK : integer range 0 to  1:= 0);
    port(clk          : in  std_logic;
         reset        : in  std_logic;
         VGA_hs       : out std_logic;
         VGA_vs       : out std_logic;
         VGA_color    : out std_logic_vector(HARD_BPP - 1 downto 0);
         pixel_x      : in  std_logic_vector(8 downto 0);
         pixel_y      : in  std_logic_vector(7 downto 0);
         data_in      : in  std_logic_vector( RAM_BPP - 1 downto 0);
         data_write   : in  std_logic;
         data_read    : in  std_logic;
         data_rout    : out std_logic;
         data_out     : out std_logic_vector( RAM_BPP - 1 downto 0);
         end_of_frame : out std_logic;
         palette_w    : in  std_logic;
         palette_idx  : in  std_logic_vector( RAM_BPP - 1 downto 0);
         palette_val  : in  std_logic_vector(HARD_BPP - 1 downto 0));
end component;

component Gest_Freq is 
Port ( clk : in STD_LOGIC;
       raz : in STD_LOGIC;
       update_flag : out STD_LOGIC);
end component; 

component LFSR is 
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           seed : in STD_LOGIC_VECTOR(16 downto 0); 
           lfsr_res : out STD_LOGIC_VECTOR (16 downto 0);  
           lfsr_counter : out std_logic_vector(16 downto 0);  
           initialization_done : out STD_LOGIC);
end component; 

component Ram is 
Port ( clk : in std_logic;
       s_write : in STD_LOGIC;
       s_address : in STD_LOGIC_VECTOR (16 downto 0);
       s_x : in STD_LOGIC_VECTOR (8 downto 0);
       s_y : in STD_LOGIC_VECTOR (7 downto 0);
       s_color_in : in std_logic;
       s_color_out : out std_logic);
end component; 

component conversion_bit_pixel is 
    Port (cell_state : in STD_LOGIC;
           s_color : out STD_LOGIC_VECTOR (2 downto 0));
end component; 

component lfsr_init is 
Port ( lfsr_reg : in STD_LOGIC_VECTOR(3 downto 0);
       lfsr_counter : in STD_LOGIC_VECTOR (16 downto 0);  
       clk : in STD_LOGIC;
       ce : in std_logic; 
       raz : in STD_LOGIC;
       init_write : out STD_LOGIC;
       init_color_in : out STD_LOGIC;
       init_address : out STD_LOGIC_VECTOR (16 downto 0));  
end component; 

component compteur_Seed is 
Port ( clk : in STD_LOGIC;
       seed : out STD_LOGIC_VECTOR (16 downto 0));
end component;  

component verif_cellule is 
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           ce : in STD_LOGIC;
           E : in STD_LOGIC;
           S : in STD_LOGIC_VECTOR(4 downto 0);
           EE : out STD_LOGIC);
end component; 

component compteur_game is
    Port ( clk : in STD_LOGIC;
           raz : in STD_LOGIC;
           ce : in STD_LOGIC;
           x : out STD_LOGIC_VECTOR (8 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0);
           done : out std_logic);
end component;

component neighbor_count is
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
end component;

component FSM is 
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
end component; 

component Ram_copy is 
Port ( clk : in STD_LOGIC;
       s_write : in STD_LOGIC;
       s_address : in STD_LOGIC_VECTOR (16 downto 0);  
       s_x : in STD_LOGIC_VECTOR (8 downto 0);
       s_y : in STD_LOGIC_VECTOR (7 downto 0);
       s_color_in : in STD_LOGIC;
       s_color_out : out STD_LOGIC);
end component; 

component Copy is 
Port ( clk : in STD_LOGIC;
       raz : in STD_LOGIC;
       ce : in STD_LOGIC;
       copy_done : out STD_LOGIC; 
       s_x : out STD_LOGIC_VECTOR (8 downto 0);
       s_y : out STD_LOGIC_VECTOR (7 downto 0);
       s_address : out STD_LOGIC_VECTOR (16 downto 0)); 
end component;

component Reg_Button
Port ( clk : in STD_LOGIC;
       input : in STD_LOGIC;
       output : out STD_LOGIC);
end component; 

component game_edit 
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
end component; 

signal s_write : std_logic;
signal s_address : std_logic_vector(16 downto 0);  
signal s_x : std_logic_vector(8 downto 0);
signal s_y : std_logic_vector(7 downto 0);
signal s_VGA_color : std_logic_vector(11 downto 0);
signal s_color : std_logic_vector(2 downto 0);

signal cell_state : std_logic;
signal lfsr_reg : std_logic_vector(16 downto 0);  
signal initialization_done : std_logic;
signal lfsr_counter : std_logic_vector(16 downto 0);
signal update_flag : std_logic;
signal seed : STD_LOGIC_VECTOR (16 downto 0);

signal init_write : std_logic;
signal init_address : std_logic_vector(16 downto 0); 
signal init_color_in : std_logic;

signal RW : std_logic; 
signal game_color_in : std_logic;

signal ce_compteurGame : std_logic; 
signal ce_countNeigh : std_logic; 
signal ce_VifCel : std_logic; 
signal CE_LFSR : STD_LOGIC;
signal CE_VGA : STD_LOGIC; 
signal ce_game_edit : STD_LOGIC;

signal pixel_xx : STD_LOGIC_VECTOR(8 downto 0);
signal pixel_yy : STD_LOGIC_VECTOR(7 downto 0);
signal x_neighbor : STD_LOGIC_VECTOR (8 downto 0); 
signal y_neighbor : STD_LOGIC_VECTOR (7 downto 0);

signal cell_state_out : STD_LOGIC; 
signal neighbors_count : STD_LOGIC_VECTOR (4 downto 0);

signal FINreg : std_logic; 
signal DONEreg : std_logic;
signal DONEcount : std_logic; 

signal copy_done : std_logic;
signal copy_address : std_logic_vector(16 downto 0); 
signal ce_copy : std_logic;
signal copy_x : std_logic_vector(8 downto 0); 
signal copy_y : std_logic_vector(7 downto 0);

signal sortie_vf : std_logic; 

signal debug_signals : std_logic_vector(5 downto 0);


--attribute mark_debug : string; 
--attribute mark_debug of cell_state : signal is "true"; 
--attribute mark_debug of ce_copy : signal is "true"; 

--attribute mark_debug of ce_countNeigh : signal is "true"; 
--attribute mark_debug of neighbors_count : signal is "true"; 

signal ram_address : std_logic_vector(16 downto 0); 
signal ram_x : std_logic_vector(8 downto 0);
signal ram_y : std_logic_vector(7 downto 0);

signal ram_copy_address : std_logic_vector(16 downto 0); 
signal ram_copy_x : std_logic_vector(8 downto 0);
signal ram_copy_y : std_logic_vector(7 downto 0);

signal btn_CENTER : std_logic; 
signal btn_UP : std_logic; 
signal btn_RIGHT : std_logic; 
signal btn_DOWN : std_logic; 
signal btn_LEFT : std_logic; 

signal color_out_edit : std_logic; 
signal x_edit : STD_LOGIC_VECTOR (8 downto 0);
signal y_edit : STD_LOGIC_VECTOR (7 downto 0);
signal gestEdit_RW_RAM : STD_LOGIC;

signal data_valid_neighbor : std_logic;
signal read_request_neighbor : std_logic;

begin

Compteur : address_counter port map(
    clk => clk,
    raz => raz,
    address => s_address,
    ce => CE_VGA, 
    done => DONEcount,
    write => s_write,
    x => s_x,
    y => s_y
);

G_Freq : Gest_Freq port map(
    clk => clk, 
    raz => raz, 
    update_flag => update_flag 
);

lfsr_vga : LFSR port map(
    clk => clk, 
    raz => raz, 
    seed => seed, 
    lfsr_res => lfsr_reg, 
    lfsr_counter => lfsr_counter, 
    initialization_done => initialization_done 
);

lfsr_cmp : compteur_Seed port map(
    clk => clk, 
    seed => seed  
); 


RAM_Grill : Ram port map(
    clk => clk,
    s_write => RW,
    s_address => ram_address,    
    s_x => ram_x,                 
    s_y => ram_y,              
    s_color_in => game_color_in,
    s_color_out => cell_state 
);

copy_ram : Ram_copy port map(
    clk => clk,
    s_write => ce_copy, 
    s_address => ram_copy_address,  
    s_x => ram_copy_x,           
    s_y => ram_copy_y,           
    s_color_in => cell_state,      
    s_color_out => cell_state_out   
);

convertisseur : conversion_bit_pixel port map(
    cell_state => cell_state, 
    s_color => s_color
);

initialization_LFSR : lfsr_init port map(
    clk => clk, 
    raz => raz, 
    init_write => init_write, 
    init_color_in => init_color_in, 
    init_address => init_address, 
    lfsr_counter => lfsr_counter, 
    ce => CE_LFSR, 
    lfsr_reg => lfsr_reg(3 downto 0)  
); 

pixel_counter : compteur_game port map(
    clk => clk,
    raz => raz,
    ce => ce_compteurGame,
    x => pixel_xx,
    y => pixel_yy,
    done => DONEreg 
);

neighbor_counter : neighbor_count port map(
    clk => clk,
    raz => raz,
    ce => ce_countNeigh,
    x => pixel_xx,
    y => pixel_yy,
    x_neighbor => x_neighbor,
    y_neighbor => y_neighbor,
    neighbors_count => neighbors_count,
    cell_data_in => cell_state_out, 
    FIN => FinREG
);

Verif : verif_cellule port map(
    clk => clk, 
    raz => raz, 
    ce => ce_VifCel,
    E => cell_state_out, 
    S => neighbors_count,
    EE => sortie_vf
);
              
STATE_MACHINE : FSM 
    Port map(
        clk => clk, 
        raz => raz, 
        init_done => initialization_done,
        done => DONEreg,  
        FinREG => FinREG, 
        DONEcount => DONEcount, 
        COLOR_MACHINE => game_color_in,
        color_out_edit => color_out_edit,
        CE_COMPTE => ce_compteurGame, 
        CE_LFSR => CE_LFSR,
        CE_NEIGHBOUR => ce_countNeigh, 
        CE_VERIF_CELLULE => ce_VifCel,
        CE_VGA => CE_VGA,
        CE_COPY => ce_copy,
        CE_EDIT => ce_game_edit,
        EE => sortie_vf,
        sw_edit => sw(0),
        copy_x => copy_x, 
        copy_y => copy_y,
        address_x => ram_x, 
        address_y => ram_y, 
        addressArith => ram_address,
        address_copy_x => ram_copy_x,
        address_copy_y => ram_copy_y,
        address_copy => ram_copy_address,
        RW => RW, 
        gest_rw_edit => gestEdit_RW_RAM,
        update_flag => update_flag,
        copy_done => copy_done,
        address_VGA => s_address,
        write_VGA => s_write, 
        x_VGA => s_x,
        y_VGA => s_y,
        x_edit => x_edit, 
        y_edit => y_edit,
        x_neighbor => x_neighbor,
        y_neighbor => y_neighbor,
        init_write => init_write, 
        init_color_in => init_color_in,
        init_address => init_address,
        copy_address => copy_address,
        pixelx => pixel_xx,
        pixely => pixel_yy, 
        led_debug => debug_signals);
        
copy_counter : Copy
    Port map(
        clk => clk, 
        raz => raz, 
        ce => ce_copy, 
        copy_done => copy_done, 
        s_address => copy_address,
        s_x => copy_x, 
        s_y => copy_y
);

process(clk)
begin 
    if(rising_edge(clk))then 
        led(5 downto 0) <= debug_signals;
        led(7) <= initialization_done;
        led(8) <= update_flag;
    end if; 
end process; 

REG_BTN_UP : Reg_Button 
    port map(clk => clk , input => btnu , output => btn_UP); 
     
REG_BTN_DOWN : Reg_Button 
    port map(clk => clk , input => btnd , output => btn_DOWN); 

REG_BTN_LEFT : Reg_Button 
    port map(clk => clk , input => btnl , output => btn_LEFT); 
    
REG_BTN_RIGHT : Reg_Button 
    port map(clk => clk , input => btnr , output => btn_RIGHT); 
    
REG_BTN_CENTER : Reg_Button 
    port map(clk => clk , input => btnc , output => btn_CENTER); 
    
GAME_EDITOR : game_edit 
    port map(clk => clk, rst => raz, gest_edit => ce_game_edit, color_in => cell_state, b_up => btn_UP, b_down => btn_DOWN, b_left => btn_LEFT, b_right => btn_RIGHT, b_center => btn_CENTER, color_out => color_out_edit, x => x_edit, y => y_edit, gest_RW_RAM => gestEdit_RW_RAM);

vga : entity work.VGA_bitmap_320x240
      generic map(
                  CLK_FREQ => 100000000,
                  RAM_BPP => 3,
                  HARD_BPP => 12,
                  INDEXED => 0,
                  READBACK => 0)   
 port map(
         clk => clk,
         reset => raz,
         VGA_hs => VGA_hs,
         VGA_vs => VGA_vs,
         VGA_color => s_VGA_color,
         pixel_x => s_x,
         pixel_y => s_y,
         data_in => s_color,
         data_write => s_write,
         data_read => '0',
         data_rout => open,
         data_out => open,
         end_of_frame => open,
         palette_w => '0',
         palette_idx => "000",
         palette_val => "000000000000"
         );
 
VGA_color <= s_VGA_color;
 
end Behavioral;