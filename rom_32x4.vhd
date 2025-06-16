library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom_32x4 is
    Port (
        addr : in  STD_LOGIC_VECTOR(4 downto 0);  -- Alamat 5-bit (32 lokasi)
        data : out STD_LOGIC_VECTOR(3 downto 0)   -- Data 4-bit
    );
end rom_32x4;

architecture Behavioral of rom_32x4 is
    -- Tipe memori ROM: 32 lokasi x 4-bit
    type rom_type is array (0 to 31) of STD_LOGIC_VECTOR(3 downto 0);
    
    -- Inisialisasi isi ROM
    constant ROM : rom_type := (
        -- Multiplicands (alamat 0-15)
        0  => "0000", 1  => "0001", 2  => "0010", 3  => "0011", 
        4  => "0100", 5  => "0101", 6  => "0110", 7  => "0111", 
        8  => "1000", 9  => "1001", 10 => "1010", 11 => "1011", 
        12 => "1100", 13 => "1101", 14 => "1110", 15 => "1111", 
        
        -- Multipliers (alamat 16-31)
        16 => "0000", 17 => "0001", 18 => "0010", 19 => "0011", 
        20 => "0100", 21 => "0101", 22 => "0110", 23 => "0111", 
        24 => "1000", 25 => "1001", 26 => "1010", 27 => "1011", 
        28 => "1100", 29 => "1101", 30 => "1110", 31 => "1111", 
        
        others => "0000"  -- Default value
    );
begin
    -- Pembacaan data dari ROM
    data <= ROM(to_integer(unsigned(addr)));
end Behavioral;