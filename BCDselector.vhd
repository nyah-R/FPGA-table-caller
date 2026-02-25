library IEEE;
use IEEE.std_logic_1164.all;

entity BCDselector is
    port (
        
		  clk            : in  std_logic;
		  N              : in  std_logic_vector(0 to 3); 
        btn_llamar     : in  std_logic;
		  seg            : out std_logic_vector(0 to 13);
        salida         : out std_logic_vector(3 downto 0);
          
        btn_llamar_OUT : out std_logic 
    );
end entity;

architecture bhv of BCDselector is
    signal sal         : std_logic_vector(13 downto 0); 
    signal reg_btn     : std_logic := '1';
    signal salida_reg  : std_logic_vector(3 downto 0) := "0000";
begin

    salida <= salida_reg;

    -- Captura del número al presionar el botón
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_llamar = '0' and reg_btn = '1' and N /= "0000" then
                salida_reg <= N;
            end if;
            reg_btn <= btn_llamar;
        end if;
    end process;

    -- Conversión de N a patrón de display
    process(N)
    begin
        case N is
            when "0001" => sal <= "01100000000000";
            when "0010" => sal <= "11011010000000";
            when "0011" => sal <= "11110010000000";
            when "0100" => sal <= "01100110000000";
            when "0101" => sal <= "10110110000000";
            when "0110" => sal <= "10111110000000";
            when "0111" => sal <= "11100000000000";
            when "1000" => sal <= "11111110000000";
            when "1001" => sal <= "11110110000000";
            when "1010" => sal <= "11111100110000";
            when "1011" => sal <= "01100000110000";
            when "1100" => sal <= "11011010110000";
            when "1101" => sal <= "11110010110000";
            when "1110" => sal <= "01100110110000";
            when "1111" => sal <= "10110110110000";
            when others => sal <= "00000010000001";
        end case;
    end process;

    seg<=not(sal);
    btn_llamar_OUT <= reg_btn;

end architecture;
