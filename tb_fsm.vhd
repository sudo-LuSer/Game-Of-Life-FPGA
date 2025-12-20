library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_tb is
end FSM_tb;

architecture Behavioral of FSM_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component FSM
        Port ( 
            clk : in STD_LOGIC;
            raz : in STD_LOGIC;
            init_done : in STD_LOGIC;
            done : in STD_LOGIC;
            FInREG : in STD_LOGIC;
            DONEcount : in std_logic;
            CE_COMPTE : out STD_LOGIC;
            CE_NEIGHBOUR : out STD_LOGIC;
            CE_VERIF_CELLULE : out STD_LOGIC;
            CE_VGA : out STD_LOGIC;
            CE_LFSR : out STD_LOGIC;
            CE_COPY : out STD_LOGIC;
            update_flag : in STD_LOGIC;
            copy_done : in STD_LOGIC;
            address_x : out STD_LOGIC_VECTOR (8 downto 0);
            address_y : out STD_LOGIC_VECTOR (7 downto 0);
            copy_x : in std_logic_vector(8 downto 0);
            copy_y : in std_logic_vector(7 downto 0);
            RW : out STD_LOGIC;
            addressArith : out STD_LOGIC_VECTOR (16 downto 0);
            COLOR_MACHINE : out STD_LOGIC;
            address_VGA : in STD_LOGIC_VECTOR (16 downto 0);
            write_VGA : in std_logic;
            x_VGA : in STD_LOGIC_VECTOR (8 downto 0);
            y_VGA : in STD_LOGIC_VECTOR (7 downto 0);
            EE : in STD_LOGIC;
            init_write : in STD_LOGIC;
            init_color_in : in STD_LOGIC;
            init_address : in STD_LOGIC_VECTOR (16 downto 0);
            copy_address : in STD_LOGIC_VECTOR (16 downto 0);
            pixelx : in STD_LOGIC_VECTOR (8 downto 0);
            pixely : in STD_LOGIC_VECTOR (7 downto 0);
            cell_read_en : in STD_LOGIC;
            led_debug : out STD_LOGIC_VECTOR(5 downto 0)
        );
    end component;

    -- Inputs
    signal clk : STD_LOGIC := '0';
    signal raz : STD_LOGIC := '0';
    signal init_done : STD_LOGIC := '0';
    signal done : STD_LOGIC := '0';
    signal FInREG : STD_LOGIC := '0';
    signal DONEcount : STD_LOGIC := '0';
    signal update_flag : STD_LOGIC := '0';
    signal copy_done : STD_LOGIC := '0';
    signal copy_x : STD_LOGIC_VECTOR(8 downto 0) := (others => '0');
    signal copy_y : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal address_VGA : STD_LOGIC_VECTOR(16 downto 0) := (others => '0');
    signal write_VGA : STD_LOGIC := '0';
    signal x_VGA : STD_LOGIC_VECTOR(8 downto 0) := (others => '0');
    signal y_VGA : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal EE : STD_LOGIC := '0';
    signal init_write : STD_LOGIC := '0';
    signal init_color_in : STD_LOGIC := '0';
    signal init_address : STD_LOGIC_VECTOR(16 downto 0) := (others => '0');
    signal copy_address : STD_LOGIC_VECTOR(16 downto 0) := (others => '0');
    signal pixelx : STD_LOGIC_VECTOR(8 downto 0) := (others => '0');
    signal pixely : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal cell_read_en : STD_LOGIC := '0';

    -- Outputs
    signal CE_COMPTE : STD_LOGIC;
    signal CE_NEIGHBOUR : STD_LOGIC;
    signal CE_VERIF_CELLULE : STD_LOGIC;
    signal CE_VGA : STD_LOGIC;
    signal CE_LFSR : STD_LOGIC;
    signal CE_COPY : STD_LOGIC;
    signal address_x : STD_LOGIC_VECTOR(8 downto 0);
    signal address_y : STD_LOGIC_VECTOR(7 downto 0);
    signal RW : STD_LOGIC;
    signal addressArith : STD_LOGIC_VECTOR(16 downto 0);
    signal COLOR_MACHINE : STD_LOGIC;
    signal led_debug : STD_LOGIC_VECTOR(5 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: FSM port map (
        clk => clk,
        raz => raz,
        init_done => init_done,
        done => done,
        FInREG => FInREG,
        DONEcount => DONEcount,
        CE_COMPTE => CE_COMPTE,
        CE_NEIGHBOUR => CE_NEIGHBOUR,
        CE_VERIF_CELLULE => CE_VERIF_CELLULE,
        CE_VGA => CE_VGA,
        CE_LFSR => CE_LFSR,
        CE_COPY => CE_COPY,
        update_flag => update_flag,
        copy_done => copy_done,
        address_x => address_x,
        address_y => address_y,
        copy_x => copy_x,
        copy_y => copy_y,
        RW => RW,
        addressArith => addressArith,
        COLOR_MACHINE => COLOR_MACHINE,
        address_VGA => address_VGA,
        write_VGA => write_VGA,
        x_VGA => x_VGA,
        y_VGA => y_VGA,
        EE => EE,
        init_write => init_write,
        init_color_in => init_color_in,
        init_address => init_address,
        copy_address => copy_address,
        pixelx => pixelx,
        pixely => pixely,
        cell_read_en => cell_read_en,
        led_debug => led_debug
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        raz <= '1';
        wait for clk_period * 2;
        raz <= '0';
        
        -- Test sequence 1: LFSR_INIT state
        report "Test 1: LFSR_INIT state";
        init_done <= '0';
        wait for clk_period * 5;
        
        -- Complete initialization
        init_done <= '1';
        wait for clk_period;
        init_done <= '0';
        
        -- Test sequence 2: COPY state
        report "Test 2: COPY state";
        copy_done <= '0';
        wait for clk_period * 3;
        
        -- Complete copy
        copy_done <= '1';
        wait for clk_period;
        copy_done <= '0';
        
        -- Test sequence 3: COMPTE -> COUNT_NEIGHBOUR -> VERIF_CELLULE cycle
        report "Test 3: Neighbour counting cycle";
        done <= '0';
        FInREG <= '0';
        
        -- First iteration
        wait for clk_period; -- COMPTE state
        FInREG <= '1';
        wait for clk_period; -- VERIF_CELLULE state
        FInREG <= '0';
        
        -- Second iteration
        wait for clk_period; -- COMPTE state
        FInREG <= '1';
        wait for clk_period; -- VERIF_CELLULE state
        FInREG <= '0';
        
        -- Complete counting
        done <= '1';
        wait for clk_period;
        done <= '0';
        
        -- Test sequence 4: AFFICHAGE state with update_flag
        report "Test 4: AFFICHAGE state";
        update_flag <= '1';
        DONEcount <= '0';
        wait for clk_period * 3;
        
        -- Complete display cycle
        DONEcount <= '1';
        wait for clk_period;
        DONEcount <= '0';
        update_flag <= '0';
        
        -- Test sequence 5: Return to COPY state
        report "Test 5: Return to COPY";
        copy_done <= '0';
        wait for clk_period * 2;
        copy_done <= '1';
        wait for clk_period;
        copy_done <= '0';
        
        -- Test sequence 6: Reset during operation
        report "Test 6: Reset during operation";
        wait for clk_period * 2;
        raz <= '1';
        wait for clk_period;
        raz <= '0';
        
        -- Complete initialization after reset
        init_done <= '1';
        wait for clk_period;
        init_done <= '0';
        
        wait for clk_period * 10;
        
        report "Simulation completed successfully";
        wait;
    end process;

    -- Monitor process to display state changes
    monitor_proc: process(clk)
    begin
        if rising_edge(clk) then
            case led_debug is
                when "000001" => report "State: LFSR_INIT";
                when "000010" => report "State: COPY";
                when "000100" => report "State: COMPTE";
                when "001000" => report "State: COUNT_NEIGHBOUR";
                when "010000" => report "State: VERIF_CELLULE";
                when "100000" => report "State: AFFICHAGE";
                when others => null;
            end case;
        end if;
    end process;

    -- Process to generate some input signal variations
    input_variation_proc: process
    begin
        wait for clk_period * 2;
        
        -- Vary some input signals
        pixelx <= "000000001";
        pixely <= "00000001";
        wait for clk_period * 5;
        
        pixelx <= "000000010";
        pixely <= "00000010";
        wait for clk_period * 5;
        
        address_VGA <= "00000000000000001";
        x_VGA <= "000000001";
        y_VGA <= "00000001";
        wait for clk_period * 5;
        
        copy_x <= "000000001";
        copy_y <= "00000001";
        copy_address <= "00000000000000010";
        wait;
    end process;

end Behavioral;