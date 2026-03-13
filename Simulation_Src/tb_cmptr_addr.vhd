library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

entity tb_address_counter is
end tb_address_counter;

architecture Behavioral of tb_address_counter is

    component address_counter is
        Port ( clk : in STD_LOGIC;
               raz : in STD_LOGIC;
               address : out STD_LOGIC_VECTOR (14 downto 0);
               write : out std_logic;
               x : out STD_LOGIC_VECTOR (8 downto 0);
               y : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    -- Signaux de test
    signal clk : STD_LOGIC := '0';
    signal raz : STD_LOGIC := '0';
    signal address : STD_LOGIC_VECTOR(14 downto 0);
    signal write : STD_LOGIC;
    signal x : STD_LOGIC_VECTOR(8 downto 0);
    signal y : STD_LOGIC_VECTOR(7 downto 0);

    -- Constantes
    constant CLK_PERIOD : time := 10 ns; -- 100 MHz
    constant SIMULATION_CYCLES : integer := 50000; -- Nombre de cycles à simuler

    -- Contrôle de simulation
    signal simulation_done : boolean := false;
    
    -- Signaux de monitoring
    signal x_int : integer;
    signal y_int : integer;
    signal address_int : integer;

begin

    -- Conversion pour le monitoring
    x_int <= to_integer(unsigned(x));
    y_int <= to_integer(unsigned(y));
    address_int <= to_integer(unsigned(address));

    -- Instanciation du DUT
    uut: address_counter
        port map (
            clk => clk,
            raz => raz,
            address => address,
            write => write,
            x => x,
            y => y
        );

    -- Génération de l'horloge
    clk_process : process
        variable cycle_count : integer := 0;
    begin
        while not simulation_done loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
            
            cycle_count := cycle_count + 1;
            if cycle_count >= SIMULATION_CYCLES then
                simulation_done <= true;
            end if;
        end loop;
        wait;
    end process;

    -- Processus de test principal
    stim_proc : process
        variable prev_x : integer := 0;
        variable prev_y : integer := 0;
        variable prev_address : integer := 0;
        variable frame_count : integer := 0;
        variable write_count : integer := 0;
    begin
        report "Début du test address_counter..." severity NOTE;
        
        -- Initialisation avec reset
        raz <= '1';
        wait for CLK_PERIOD * 5;
        raz <= '0';
        wait for CLK_PERIOD * 2;

        -- Test 1: Vérification du comportement normal
        report "Test 1: Comportement normal" severity NOTE;
        wait for CLK_PERIOD * 1000;
        
        -- Test 2: Vérification des limites
        report "Test 2: Vérification des limites" severity NOTE;
        
        -- Attendre que y atteigne une valeur non nulle pour vérifier l'incrémentation
        wait until y_int > 10 for CLK_PERIOD * 5000;
        
        if y_int > 10 then
--            report "SUCCÈS: Coordonnées Y en incrémentation" severity NOTE;
        else
            report "ERREUR: Coordonnées Y stagnantes" severity ERROR;
        end if;

        -- Test 3: Reset pendant le fonctionnement
        report "Test 3: Reset pendant le fonctionnement" severity NOTE;
        wait for CLK_PERIOD * 50;
        raz <= '1';
        wait for CLK_PERIOD * 2;
        raz <= '0';
        
        -- Vérifier que les compteurs sont reset
        wait for CLK_PERIOD * 2;
        if x_int = 0 and y_int = 0 and address_int = 0 then
--            report "SUCCÈS: Reset fonctionnel" severity NOTE;
        else
            report "ERREUR: Reset non fonctionnel - x=" & integer'image(x_int) & 
                   " y=" & integer'image(y_int) & " address=" & integer'image(address_int) severity ERROR;
        end if;

        -- Test 4: Vérification du signal write
        report "Test 4: Vérification du signal write" severity NOTE;
        wait for CLK_PERIOD * 100;
        
        -- Compter les pulses write
        for i in 1 to 100 loop
            wait until write = '1';
            write_count := write_count + 1;
            wait until write = '0';
        end loop;
        
        report "Write pulses comptés: " & integer'image(write_count) severity NOTE;

        -- Test 5: Vérification de la cohérence des coordonnées
        report "Test 5: Vérification cohérence coordonnées" severity NOTE;
        wait for CLK_PERIOD * 500;
        
        -- Vérifier que l'adresse correspond aux coordonnées (adresse = y * 160 + x)
        if address_int = (y_int * 160 + x_int) then
--            report "SUCCÈS: Cohérence adresse/coordonnées vérifiée" severity NOTE;
        else
            report "ERREUR: Incohérence adresse/coordonnées - address=" & integer'image(address_int) &
                   " attendu=" & integer'image(y_int * 160 + x_int) severity ERROR;
        end if;

        -- Test 6: Vérification du débordement
        report "Test 6: Vérification débordement" severity NOTE;
        
        -- Attendre un frame complet (19200 addresses)
        wait until address_int = 19199 for CLK_PERIOD * 40000;
        
        if address_int = 19199 then
--            report "SUCCÈS: Adresse maximale atteinte" severity NOTE;
            
            -- Vérifier le retour à zéro
            wait for CLK_PERIOD * 10;
            if address_int = 0 then
--                report "SUCCÈS: Retour à zéro après adresse max" severity NOTE;
            else
                report "ERREUR: Pas de retour à zéro après adresse max" severity ERROR;
            end if;
        else
            report "ATTENTION: Adresse maximale non atteinte dans le temps imparti: " & 
                   integer'image(address_int) severity WARNING;
        end if;

        -- Rapport final
        report "Test address_counter terminé" severity NOTE;
        report "Dernières valeurs - x:" & integer'image(x_int) & 
               " y:" & integer'image(y_int) & 
               " address:" & integer'image(address_int) severity NOTE;
        
        simulation_done <= true;
        wait;
    end process;

    -- Processus de monitoring automatique
    monitor_proc : process(clk)
        variable prev_x : integer := 0;
        variable prev_y : integer := 0;
        variable prev_address : integer := 0;
        variable error_count : integer := 0;
    begin
        if rising_edge(clk) then
            if raz = '0' then  -- En fonctionnement normal
                
                -- Vérification de la progression de x
                if write = '1' then
                    if x_int = 159 then
                        -- x doit revenir à 0
                        if prev_x /= 159 then
                            -- Cas normal d'incrémentation
                            null;
                        end if;
                    else
                        -- x doit s'incrémenter de 1
                        if x_int /= prev_x + 1 and prev_x /= 159 then
                            report "ERREUR: Incrémentation X incorrecte - précédent:" & 
                                   integer'image(prev_x) & " actuel:" & integer'image(x_int) severity ERROR;
                            error_count := error_count + 1;
                        end if;
                    end if;
                    
                    -- Vérification de la progression de y
                    if prev_x = 159 then
                        if y_int = 119 then
                            -- y doit revenir à 0
                            if prev_y /= 119 then
                                report "ERREUR: Y devrait revenir à 0" severity ERROR;
                            end if;
                        else
                            -- y doit s'incrémenter de 1
                            if y_int /= prev_y + 1 then
                                report "ERREUR: Incrémentation Y incorrecte" severity ERROR;
                                error_count := error_count + 1;
                            end if;
                        end if;
                    end if;
                end if;
                
                -- Mise à jour des valeurs précédentes
                prev_x := x_int;
                prev_y := y_int;
                prev_address := address_int;
                
                -- Vérification des limites
                assert x_int >= 0 and x_int <= 159
                    report "ERREUR: X hors limites: " & integer'image(x_int) severity ERROR;
                    
                assert y_int >= 0 and y_int <= 119
                    report "ERREUR: Y hors limites: " & integer'image(y_int) severity ERROR;
                    
                assert address_int >= 0 and address_int <= 19199
                    report "ERREUR: Adresse hors limites: " & integer'image(address_int) severity ERROR;
                    
            else
                -- Reset actif, réinitialiser les valeurs précédentes
                prev_x := 0;
                prev_y := 0;
                prev_address := 0;
            end if;
        end if;
    end process;

    -- Processus de dump des signaux pour analyse
    signal_dump_proc : process(clk)
        file output_file : TEXT open WRITE_MODE is "address_counter_simulation.csv";
        variable line_out : LINE;
        variable first_write : boolean := true;
    begin
        if rising_edge(clk) then
            if first_write then
--                write(line_out, string'("Time_ns;raz;write;x;y;address"));
                writeline(output_file, line_out);
                first_write := false;
            end if;
            
--            write(line_out, now / 1 ns);
--            write(line_out, string'(";"));
--            write(line_out, raz);
--            write(line_out, string'(";"));
--            write(line_out, write);
--            write(line_out, string'(";"));
--            write(line_out, integer'image(x_int));
--            write(line_out, string'(";"));
--            write(line_out, integer'image(y_int));
--            write(line_out, string'(";"));
--            write(line_out, integer'image(address_int));
            writeline(output_file, line_out);
        end if;
    end process;

    -- Processus de vérification du pattern write
    write_pattern_check : process
        variable write_high_time : time;
        variable write_low_time : time;
        variable last_edge : time := 0 ns;
        variable current_period : time;
    begin
        wait until write = '1';
        last_edge := now;
        
        wait until write = '0';
        write_high_time := now - last_edge;
        last_edge := now;
        
        wait until write = '1';
        write_low_time := now - last_edge;
        current_period := write_high_time + write_low_time;
        
        -- Vérifier que le signal write a une période de 2 cycles d'horloge
        assert write_high_time = CLK_PERIOD and write_low_time = CLK_PERIOD
            report "ATTENTION: Pattern write incorrect - High:" & time'image(write_high_time) & 
                   " Low:" & time'image(write_low_time) severity WARNING;
    end process;

end Behavioral;