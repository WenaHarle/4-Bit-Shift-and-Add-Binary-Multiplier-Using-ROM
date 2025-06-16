library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shifter_4bit is
    Port (
        c_in  : in  STD_LOGIC;                -- Carry in (menjadi MSB A)
        a_in  : in  STD_LOGIC_VECTOR(3 downto 0);  -- Register A saat ini
        q_in  : in  STD_LOGIC_VECTOR(3 downto 0);  -- Register Q saat ini
        a_out : out STD_LOGIC_VECTOR(3 downto 0);  -- A tergeser
        q_out : out STD_LOGIC_VECTOR(3 downto 0)   -- Q tergeser
    );
end shifter_4bit;

architecture Behavioral of shifter_4bit is
begin
    -- Operasi geser kanan:
    --   a_out: MSB = c_in, sisanya = 3 bit teratas a_in
    --   q_out: MSB = LSB a_in, sisanya = 3 bit teratas q_in
    a_out <= c_in & a_in(3 downto 1);
    q_out <= a_in(0) & q_in(3 downto 1);
end Behavioral;