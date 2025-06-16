library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder_4bit is
    Port (
        a    : in  STD_LOGIC_VECTOR(3 downto 0);  -- Input A
        b    : in  STD_LOGIC_VECTOR(3 downto 0);  -- Input B
        sum  : out STD_LOGIC_VECTOR(3 downto 0);  -- Hasil penjumlahan
        cout : out STD_LOGIC                      -- Carry out
    );
end adder_4bit;

architecture Behavioral of adder_4bit is
    signal temp: STD_LOGIC_VECTOR(4 downto 0);  -- Sinyal sementara
begin
    temp <= ('0' & a) + ('0' & b);  -- Penjumlahan dengan ekstensi bit
    sum  <= temp(3 downto 0);       -- Output hasil
    cout <= temp(4);                -- Output carry
end Behavioral;