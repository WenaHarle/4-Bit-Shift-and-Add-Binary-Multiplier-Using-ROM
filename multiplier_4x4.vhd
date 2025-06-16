library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplier_4x4 is
    Port (
        clk               : in  STD_LOGIC;                    -- Clock sistem
        reset             : in  STD_LOGIC;                    -- Reset (aktif tinggi)
        start             : in  STD_LOGIC;                    -- Sinyal mulai operasi
        addr_multiplicand : in  STD_LOGIC_VECTOR(3 downto 0); -- Alamat multiplicand di ROM
        addr_multiplier   : in  STD_LOGIC_VECTOR(3 downto 0); -- Alamat multiplier di ROM
        product           : out STD_LOGIC_VECTOR(7 downto 0); -- Hasil perkalian 8-bit
        done              : out STD_LOGIC                     -- Sinyal selesai
    );
end multiplier_4x4;

architecture Behavioral of multiplier_4x4 is
    -- Deklarasi komponen ROM 32x4
    component rom_32x4
        Port ( 
            addr : in  STD_LOGIC_VECTOR(4 downto 0);
            data : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
    -- Deklarasi komponen inti pengali 4x4
    component multiplier_core_4x4
        Port (
            clk          : in  STD_LOGIC;
            reset        : in  STD_LOGIC;
            start        : in  STD_LOGIC;
            multiplier   : in  STD_LOGIC_VECTOR(3 downto 0);
            multiplicand : in  STD_LOGIC_VECTOR(3 downto 0);
            product      : out STD_LOGIC_VECTOR(7 downto 0);
            done         : out STD_LOGIC
        );
    end component;
    
    -- Tipe state untuk FSM
    type state_type is (IDLE, LOAD_MULTIPLICAND, LOAD_MULTIPLIER, START_MULT, WAIT_DONE);
    signal state : state_type := IDLE;
    
    -- Sinyal internal
    signal rom_data         : STD_LOGIC_VECTOR(3 downto 0);
    signal rom_addr         : STD_LOGIC_VECTOR(4 downto 0);
    signal multiplicand_reg : STD_LOGIC_VECTOR(3 downto 0);
    signal multiplier_reg   : STD_LOGIC_VECTOR(3 downto 0);
    signal core_start       : STD_LOGIC;
    signal core_done        : STD_LOGIC;
    signal addr_multiplicand_reg : STD_LOGIC_VECTOR(3 downto 0);
    signal addr_multiplier_reg   : STD_LOGIC_VECTOR(3 downto 0);
    
begin
    -- Instansiasi ROM
    ROM_INST: rom_32x4 port map(
        addr => rom_addr,
        data => rom_data
    );
    
    -- Instansiasi inti pengali
    CORE: multiplier_core_4x4 port map(
        clk          => clk,
        reset        => reset,
        start        => core_start,
        multiplier   => multiplier_reg,
        multiplicand => multiplicand_reg,
        product      => product,
        done         => core_done
    );
    
    done <= core_done;  -- Sinyal selesai langsung dari inti pengali
    
    -- FSM untuk mengontrol pemuatan operand dan memulai perkalian
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            core_start <= '0';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if start = '1' then
                        -- Simpan alamat operand
                        addr_multiplicand_reg <= addr_multiplicand;
                        addr_multiplier_reg   <= addr_multiplier;
                        -- Atur alamat ROM untuk membaca multiplicand (0-15)
                        rom_addr <= '0' & addr_multiplicand;
                        state <= LOAD_MULTIPLICAND;
                    end if;
                
                when LOAD_MULTIPLICAND =>
                    -- Muat multiplicand dari ROM
                    multiplicand_reg <= rom_data;
                    -- Atur alamat ROM untuk membaca multiplier (16-31)
                    rom_addr <= '1' & addr_multiplier_reg;
                    state <= LOAD_MULTIPLIER;
                
                when LOAD_MULTIPLIER =>
                    -- Muat multiplier dari ROM
                    multiplier_reg <= rom_data;
                    core_start <= '1';  -- Aktifkan sinyal mulai inti pengali
                    state <= START_MULT;
                
                when START_MULT =>
                    core_start <= '0';  -- Nonaktifkan sinyal mulai
                    state <= WAIT_DONE;
                
                when WAIT_DONE =>
                    if core_done = '1' then
                        state <= IDLE;  -- Kembali ke idle setelah selesai
                    end if;
            end case;
        end if;
    end process;
end Behavioral;