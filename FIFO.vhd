library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FIFO is
    port (
        clk          : in  std_logic;
        btn_llamar   : in  std_logic;
        btn_atender  : in  std_logic;
        num_mesa_in  : in  std_logic_vector(3 downto 0);
        mesa_actual  : out std_logic_vector(3 downto 0);
        modo_visual  : out std_logic;
        refresh      : out std_logic;
        LED_llamado_out : out std_logic;
        LED_ATENCION: out std_logic
    );
end entity;

architecture Behavioral of FIFO is

    type estado_type is (S0, S1, S2);

    type mesa_record is record
        numero : std_logic_vector(3 downto 0);
        estado : estado_type;
        timer_atencion : unsigned(31 downto 0);
    end record;

    type fifo_array is array (0 to 15) of mesa_record; -- arreglo circular de 16 posiciones, cada una con un mesa_record

    signal fifo : fifo_array := (others => (numero => "0000", estado => S0, timer_atencion => (others => '0')));

    signal head,tail  : natural range 0 to 15 := 0; -- índices para controlar entrada y salida en la cola.
    signal count      : natural range 0 to 16 := 0; -- cantidad de mesas en la cola.

    signal scan_index : natural range 0 to 15 := 0;
    signal display_timer : natural range 0 to 50000000 := 0;
    signal refresh_flag : std_logic := '0';

    signal led_llamado : std_logic := '0';
    signal led_timeout : std_logic := '0';  -- led para timeout (OPCIONAL)
    signal btn_llamar_r, btn_atender_r : std_logic := '1';

    -- CONSTANTE para timeout 2950000000 en unsigned(32 bits)
    constant TIMEOUT_VAL : unsigned(31 downto 0) := x"AF1B9C00";  -- 2950000000 decimal

begin
    -- Muestreo de botones (flancos de bajada)
    process(clk)
    begin
        if rising_edge(clk) then
            btn_llamar_r  <= btn_llamar;
            btn_atender_r <= btn_atender;
        end if;
    end process;

    -- Proceso principal FIFO
    process(clk)
        variable tmp_fifo : fifo_array;
        variable tmp_head, tmp_tail : natural range 0 to 15;
        variable tmp_count        : natural range 0 to 16;
        variable existe_ya : boolean;
        variable timeout_detectado : boolean;
    begin
        if rising_edge(clk) then
            -- Copio señales a variables
            tmp_fifo   := fifo;
            tmp_head   := head;
            tmp_tail   := tail;
            tmp_count  := count;

            timeout_detectado := false;

            -- ENCOLADO (S1)
            existe_ya := false;
            if btn_llamar_r='1' and btn_llamar='0' and tmp_count < 16
                and num_mesa_in /= "0000" then

                -- Busco duplicados
                for i in 0 to 15 loop
                    if tmp_fifo(i).numero = num_mesa_in
                        and tmp_fifo(i).estado = S1 then
                        existe_ya := true;
                        exit;
                    end if;
                end loop;

                -- Si no existe, encolo
                if not existe_ya then
                    tmp_fifo(tmp_tail).numero         := num_mesa_in;
                    tmp_fifo(tmp_tail).estado         := S1;
                    tmp_fifo(tmp_tail).timer_atencion := (others => '0');
                    tmp_tail                          := (tmp_tail + 1) mod 16;
                    tmp_count                         := tmp_count + 1;
                    led_llamado <= '1';
                end if;
            end if;

            -- ATENCION (S2)
            if btn_atender_r='1' and btn_atender='0' and tmp_count > 0
                and tmp_fifo(tmp_head).estado = S1 then
                tmp_fifo(tmp_head).estado        := S2;
                tmp_fifo(tmp_head).timer_atencion := (others => '0');
                led_llamado <= '0';
                tmp_head := (tmp_head + 1) mod 16;
            end if;

            head <= tmp_head;

            -- TIMEOUT y conteo de timer_atencion
            for i in 0 to 15 loop
                if tmp_fifo(i).estado = S2 then
                    if tmp_fifo(i).timer_atencion < TIMEOUT_VAL then
                        tmp_fifo(i).timer_atencion := tmp_fifo(i).timer_atencion + 1;
                    else
                        tmp_fifo(i).estado := S0;
                        tmp_fifo(i).numero := "0000";
                        if i = tmp_head then
                            tmp_head  := (tmp_head + 1) mod 16;
                            tmp_count := tmp_count - 1;
                        end if;
                    end if;

                elsif tmp_fifo(i).estado = S1 then
                    if tmp_fifo(i).timer_atencion < TIMEOUT_VAL then
                        tmp_fifo(i).timer_atencion := tmp_fifo(i).timer_atencion + 1;
                    else
                        timeout_detectado := true;
                    end if;
                end if;
            end loop;

            if timeout_detectado then
                led_timeout <= '1';
            else
                led_timeout <= '0';
            end if;

            -- Actualizo
            fifo  <= tmp_fifo;
            head  <= tmp_head;
            tail  <= tmp_tail;
            count <= tmp_count;
        end if;
    end process;

    -- Rotacion y refresh 
    process(clk)
    begin
        if rising_edge(clk) then
            if display_timer < 50_000_000 then
                display_timer <= display_timer + 1;
                refresh_flag  <= '0';
            else
                display_timer <= 0;
                refresh_flag  <= '1';
                for offset in 1 to 16 loop
                    if fifo((scan_index+offset) mod 16).estado /= S0 then
                        scan_index <= (scan_index+offset) mod 16;
                        exit;
                    end if;
                end loop;
            end if;
        end if;
    end process;

    -- Salidas
    mesa_actual <= fifo(scan_index).numero;
    modo_visual <= '1' when fifo(scan_index).estado = S1 else '0';
    refresh     <= refresh_flag;
    LED_llamado_out <= led_llamado;
    LED_ATENCION <= led_timeout;

end Behavioral;
