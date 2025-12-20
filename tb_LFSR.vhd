library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

entity LFSR_TB is
end LFSR_TB;

architecture Behavioral of LFSR_TB is

    -- Component Declaration for the Unit Under Test (UUT)
    component LFSR is
        Port ( 
            clk : in STD_LOGIC;
            raz : in STD_LOGIC;
            lfsr_res : out STD_LOGIC_VECTOR (15 downto 0);
            lfsr_counter : out STD_LOGIC_VECTOR (15 downto 0);
            initialization_done : out STD_LOGIC
        );
    end component;

    -- Test bench signals
    signal clk : STD_LOGIC := '0';
    signal raz : STD_LOGIC := '0';
    signal lfsr_res : STD_LOGIC_VECTOR (15 downto 0);
    signal lfsr_counter : STD_LOGIC_VECTOR (15 downto 0);
    signal initialization_done : STD_LOGIC;

    -- Clock period definitions
    constant CLK_PERIOD : time := 10 ns;
    
    -- Test control
    signal simulation_done : boolean := false;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: LFSR
        port map (
            clk => clk,
            raz => raz,
            lfsr_res => lfsr_res,
            lfsr_counter => lfsr_counter,
            initialization_done => initialization_done
        );

    -- Clock generation process
    clk_process : process
    begin
        while not simulation_done loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
        variable cycle_count : integer := 0;
        variable lfsr_value_prev : STD_LOGIC_VECTOR(15 downto 0);
    begin
        -- Report test start
        report "Starting LFSR test bench..." severity NOTE;
        
        -- Initialize inputs
        raz <= '0';
        wait for CLK_PERIOD;
        
        -- Test 1: Normal operation - run for a while
        report "Test 1: Normal operation" severity NOTE;
        raz <= '0';
        wait for 100 * CLK_PERIOD;
        
        -- Test 2: Reset during operation
        report "Test 2: Reset during operation" severity NOTE;
        raz <= '1';
        wait for CLK_PERIOD;
        raz <= '0';
        
        -- Check that reset worked
        wait for CLK_PERIOD;
        assert to_integer(unsigned(lfsr_counter)) = 0 
            report "Counter not reset properly" severity ERROR;
        
        -- Test 3: Run until initialization is done
        report "Test 3: Run until initialization done" severity NOTE;
        wait until initialization_done = '1' for 20000 * CLK_PERIOD;
        
        if initialization_done = '1' then
            report "Initialization completed after " & integer'image(to_integer(unsigned(lfsr_counter))) & " cycles" severity NOTE;
            
            -- Verify counter reached expected value
            assert to_integer(unsigned(lfsr_counter)) = 19200 
                report "Counter final value mismatch. Expected 19200, got " & 
                       integer'image(to_integer(unsigned(lfsr_counter))) severity ERROR;
        else
            report "Initialization did not complete within expected time" severity WARNING;
        end if;
        
        -- Test 4: Multiple reset cycles
        report "Test 4: Multiple reset cycles" severity NOTE;
        for i in 1 to 5 loop
            raz <= '1';
            wait for CLK_PERIOD;
            raz <= '0';
            wait for 10 * CLK_PERIOD;
            
            -- Verify LFSR is generating new values
            lfsr_value_prev := lfsr_res;
            wait for CLK_PERIOD;
            assert lfsr_res /= lfsr_value_prev 
                report "LFSR not advancing after reset" severity WARNING;
        end loop;
        
        -- Test 5: Extended operation test
        report "Test 5: Extended operation test" severity NOTE;
        raz <= '0';
        wait for 500 * CLK_PERIOD;
        
        -- Check LFSR pattern (basic sanity check)
        for i in 1 to 10 loop
            lfsr_value_prev := lfsr_res;
            wait for CLK_PERIOD;
            if initialization_done = '0' then
                assert lfsr_res /= lfsr_value_prev 
                    report "LFSR stuck at same value during operation" severity WARNING;
            end if;
        end loop;
        
        -- Final report
        report "LFSR test bench completed" severity NOTE;
        report "Final counter value: " & integer'image(to_integer(unsigned(lfsr_counter))) severity NOTE;
        report "Initialization done: " & STD_LOGIC'image(initialization_done) severity NOTE;
        report "Final LFSR value: " & integer'image(to_integer(unsigned(lfsr_res))) severity NOTE;
        
        simulation_done <= true;
        wait;
    end process;

    -- Monitoring process for additional checks
    monitor_proc : process(clk)
        variable cycle : integer := 0;
    begin
        if rising_edge(clk) then
            cycle := cycle + 1;
            
            -- Check for X or U states
            assert lfsr_res /= "XXXXXXXXXXXXXXXX" 
                report "LFSR output has undefined bits" severity WARNING;
            assert lfsr_counter /= "XXXXXXXXXXXXXXXX" 
                report "Counter output has undefined bits" severity WARNING;
            
            -- Check counter increments during initialization
            if raz = '0' and initialization_done = '0' then
                if cycle > 1 then  -- Skip first cycle after reset
                    assert to_integer(unsigned(lfsr_counter)) >= 0 and 
                           to_integer(unsigned(lfsr_counter)) <= 19200
                        report "Counter out of expected range: " & 
                               integer'image(to_integer(unsigned(lfsr_counter))) severity WARNING;
                end if;
            end if;
        end if;
    end process;

    -- Process to dump signals to file for analysis
    file_dump_proc : process(clk)
        file output_file : TEXT open WRITE_MODE is "lfsr_simulation.txt";
        variable line_out : LINE;
    begin
        if rising_edge(clk) then
            if now = 0 ns then
                -- Write header
                write(line_out, string'("Time(ns)"));
                write(line_out, HT);
                write(line_out, string'("raz"));
                write(line_out, HT);
                write(line_out, string'("lfsr_res"));
                write(line_out, HT);
                write(line_out, string'("lfsr_counter"));
                write(line_out, HT);
                write(line_out, string'("init_done"));
                writeline(output_file, line_out);
            else
                write(line_out, now / 1 ns);
                write(line_out, HT);
                write(line_out, raz);
                write(line_out, HT);
                write(line_out, lfsr_res);
                write(line_out, HT);
                write(line_out, lfsr_counter);
                write(line_out, HT);
                write(line_out, initialization_done);
                writeline(output_file, line_out);
            end if;
        end if;
    end process;

end Behavioral;