library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_sistema is
end entity;

architecture sim of tb_sistema is
    -- Señales para test
    signal clk          : std_logic := '0';
    signal BTN_llamar   : std_logic := '1';
    signal BTN_Atender  : std_logic := '1';
    signal SWITCH       : std_logic_vector(0 to 3) := "0000";
    signal LED_atencion : std_logic;
    signal ATENCION     : std_logic;
    signal BCD1         : std_logic_vector(0 to 13);
    signal BCD2         : std_logic_vector(0 to 13);

    -- Componente bajo prueba
    component sistema
        port (
            BTN_Atender  : in  std_logic;
            clk          : in  std_logic;
            BTN_llamar   : in  std_logic;
            SWITCH       : in  std_logic_vector(0 to 3);
            LED_atencion : out std_logic;
            ATENCION     : out std_logic;
            BCD1         : out std_logic_vector(0 to 13);
            BCD2         : out std_logic_vector(0 to 13)
        );
    end component;

begin

    -- Instancia del sistema
    DUT: sistema
        port map (
            BTN_Atender  => BTN_Atender,
            clk          => clk,
            BTN_llamar   => BTN_llamar,
            SWITCH       => SWITCH,
            LED_atencion => LED_atencion,
            ATENCION     => ATENCION,
            BCD1         => BCD1,
            BCD2         => BCD2
        );

    -- Reloj: 50 MHz → periodo = 20 ns
    clk_process: process
    begin
        while true loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
    end process;

    -- Estímulos
    stim_proc: process
    begin
        -- Espera inicial
        wait for 100 ns;

        -- Llamar mesa 3 (0011)
        SWITCH <= "0011";
        BTN_llamar <= '0';
        wait for 20 ns;
        BTN_llamar <= '1';

        -- Esperar un poco
        wait for 500 ns;

        -- Atender mesa
        BTN_Atender <= '0';
        wait for 20 ns;
        BTN_Atender <= '1';

        -- Otra mesa: mesa 5 (0101)
        wait for 500 ns;
        SWITCH <= "0101";
        BTN_llamar <= '0';
        wait for 20 ns;
        BTN_llamar <= '1';

        -- Otra mesa: mesa 7 (0111)
        wait for 500 ns;
        SWITCH <= "0111";
        BTN_llamar <= '0';
        wait for 20 ns;
        BTN_llamar <= '1';

        -- Esperar 5 us para ver rotación y LED de atención
        wait for 5 us;

        -- Fin de simulación
        wait;
    end process;

end architecture;
