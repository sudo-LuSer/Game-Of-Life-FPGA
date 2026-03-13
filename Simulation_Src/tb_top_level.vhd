library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_affichage_vga is
end tb_affichage_vga;

architecture Behavioral of tb_affichage_vga is

    -- Constants
    constant CLK_PERIOD : time := 10 ns;  -- 100 MHz

    -- Component Declaration
    component affichage_vga
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
    end component;

    -- Signals
    signal clk       : STD_LOGIC := '0';
    signal raz       : STD_LOGIC := '1';
    signal btnc      : STD_LOGIC := '0';
    signal btnd      : STD_LOGIC := '0';
    signal btnu      : STD_LOGIC := '0';
    signal btnr      : STD_LOGIC := '0';
    signal btnl      : STD_LOGIC := '0';
    signal VGA_hs    : STD_LOGIC;
    signal VGA_vs    : STD_LOGIC;
    signal VGA_color : STD_LOGIC_VECTOR(11 downto 0);
    signal sw        : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal led       : STD_LOGIC_VECTOR(8 downto 0);

    -- Testbench control
    signal simulation_done : boolean := false;

begin

    -- Clock generation
    raz <= '0' after 6ns; 
    clk <= not clk after 5ns; 
    
    -- DUT Instantiation
    uut: affichage_vga
        port map (
            clk       => clk,
            raz       => raz,
            VGA_hs    => VGA_hs,
            btnc      => btnc, 
            btnd      => btnd, 
            btnu      => btnu, 
            btnr      => btnr, 
            btnl      => btnl, 
            VGA_vs    => VGA_vs,
            VGA_color => VGA_color,
            sw        => sw,
            led       => led
        );
    
    

end Behavioral;