library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter_3bit is
    Port (
        clk    : in  STD_LOGIC;               -- Clock
        reset  : in  STD_LOGIC;               -- Reset (aktif tinggi)
        en     : in  STD_LOGIC;               -- Enable increment
        count  : out STD_LOGIC_VECTOR(2 downto 0);  -- Output counter
        done   : out STD_LOGIC                -- Selesai saat counter=4
    );
end counter_3bit;

architecture Behavioral of counter_3bit is
    signal cnt: STD_LOGIC_VECTOR(2 downto 0);  -- Sinyal internal counter
begin
    process(clk, reset)
    begin
        if reset = '1' then
            cnt <= "000";  -- Reset ke 0
        elsif rising_edge(clk) then
            if en = '1' then
                cnt <= cnt + 1;  -- Increment saat enable aktif
            end if;
        end if;
    end process;
    
    count <= cnt;
    done  <= '1' when cnt = "100" else '0';  -- Selesai setelah 4 iterasi
end Behavioral;