library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_LlamadorMesas is
-- Testbench no tiene puertos
end tb_LlamadorMesas;

architecture Behavioral of tb_LlamadorMesas is

  -- Señales de interconexión
  signal clk          : std_logic := '0';
  signal btn_llamar   : std_logic := '1';
  signal btn_atender  : std_logic := '1';
  signal num_mesa_in  : std_logic_vector(3 downto 0) := (others => '0');

  signal mesa_actual  : std_logic_vector(3 downto 0);
  signal modo_visual  : std_logic;
  signal refresh      : std_logic;
  signal LED_llamado_out : std_logic;
  signal LED_ATENCION : std_logic;

  -- Señales para BCDselector y BCDout
  signal seg_bcdselector : std_logic_vector(0 to 13);
  signal salida_bcdselector : std_logic_vector(3 downto 0);
  signal btn_llamar_OUT : std_logic;

  signal seg_bcdout : std_logic_vector(0 to 13);

begin

  -- Instancia FIFO
  DUT_FIFO: entity work.FIFO
    port map (
      clk          => clk,
      btn_llamar   => btn_llamar,
      btn_atender  => btn_atender,
      num_mesa_in  => num_mesa_in,
      mesa_actual  => mesa_actual,
      modo_visual  => modo_visual,
      refresh      => refresh,
      LED_llamado_out => LED_llamado_out,
      LED_ATENCION => LED_ATENCION
    );

  -- Instancia BCDselector
  DUT_BCDselector: entity work.BCDselector
    port map (
      clk          => clk,
      N            => salida_bcdselector,
      btn_llamar   => btn_llamar,
      seg          => seg_bcdselector,
      salida       => salida_bcdselector,
      btn_llamar_OUT => btn_llamar_OUT
    );

  -- Instancia BCDout
  DUT_BCDout: entity work.BCDout
    port map (
      clk         => clk,
      mesa_in     => mesa_actual,
      modo_in     => modo_visual,
      refresh     => refresh,
      segmentos   => seg_bcdout
    );

  -- Reloj: 50 MHz (20 ns periodo)
  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for 10 ns;
      clk <= '1';
      wait for 10 ns;
    end loop;
  end process;

  -- Proceso estímulo botones y entradas
  stim_proc : process
  begin
    -- Inicio: todos botones inactivos
    btn_llamar <= '1';
    btn_atender <= '1';
    num_mesa_in <= (others => '0');
    wait for 100 ns;

    -- Pulsar llamar mesa 3
    num_mesa_in <= "0011";  -- Mesa 3
    btn_llamar <= '0';
    wait for 20 ns;
    btn_llamar <= '1';
    wait for 200 ns;

    -- Pulsar llamar mesa 5
    num_mesa_in <= "0101";  -- Mesa 5
    btn_llamar <= '0';
    wait for 20 ns;
    btn_llamar <= '1';
    wait for 200 ns;

    -- Pulsar atender la primer mesa (3)
    btn_atender <= '0';
    wait for 20 ns;
    btn_atender <= '1';
    wait for 200 ns;

    -- Pulsar llamar mesa 7
    num_mesa_in <= "0111";  -- Mesa 7
    btn_llamar <= '0';
    wait for 20 ns;
    btn_llamar <= '1';
    wait for 500 ns;

    -- Pulsar atender la siguiente mesa (5)
    btn_atender <= '0';
    wait for 20 ns;
    btn_atender <= '1';

    wait for 500 ns;

    -- Fin simulación
    wait;
  end process;

end Behavioral;

