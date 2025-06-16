library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_4bit is
    Port (
        clk   : in  STD_LOGIC;                    -- Clock
        reset : in  STD_LOGIC;                    -- Reset (aktif tinggi)
        en    : in  STD_LOGIC;                    -- Enable load
        d     : in  STD_LOGIC_VECTOR(3 downto 0); -- Data input
        q     : out STD_LOGIC_VECTOR(3 downto 0)  -- Data output
    );
end register_4bit;

architecture Behavioral of register_4bit is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q <= "0000";  -- Reset semua bit ke '0'
        elsif rising_edge(clk) then
            if en = '1' then
                q <= d;   -- Load data saat enable aktif
            end if;
        end if;
    end process;
end Behavioral;