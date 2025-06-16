library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multiplier_4x4_tb is
end multiplier_4x4_tb;

architecture Behavioral of multiplier_4x4_tb is
    -- Komponen yang diuji
    component multiplier_4x4
        Port (
            clk               : in  STD_LOGIC;
            reset             : in  STD_LOGIC;
            start             : in  STD_LOGIC;
            addr_multiplicand : in  STD_LOGIC_VECTOR(3 downto 0);
            addr_multiplier   : in  STD_LOGIC_VECTOR(3 downto 0);
            product           : out STD_LOGIC_VECTOR(7 downto 0);
            done              : out STD_LOGIC
        );
    end component;

    -- Sinyal uji
    signal clk_tb          : STD_LOGIC := '0';
    signal reset_tb        : STD_LOGIC := '1';
    signal start_tb        : STD_LOGIC := '0';
    signal addr_multiplicand_tb : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal addr_multiplier_tb   : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal product_tb      : STD_LOGIC_VECTOR(7 downto 0);
    signal done_tb         : STD_LOGIC;
    
    -- Periode clock
    constant CLK_PERIOD : time := 10 ns;
    
begin
    -- Instansiasi Unit Under Test (UUT)
    uut: multiplier_4x4 port map(
        clk               => clk_tb,
        reset             => reset_tb,
        start             => start_tb,
        addr_multiplicand => addr_multiplicand_tb,
        addr_multiplier   => addr_multiplier_tb,
        product           => product_tb,
        done              => done_tb
    );

    -- Proses pembangkit clock
    clk_process: process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD/2;
        clk_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Proses stimulus
    stim_proc: process
        variable expected : STD_LOGIC_VECTOR(7 downto 0);
    begin
        -- Inisialisasi sistem
        reset_tb <= '1';
        wait for CLK_PERIOD*2;
        reset_tb <= '0';
        wait for CLK_PERIOD;
        
        -- Test Case 1: 3 * 3 = 9 (alamat 3 dan 19)
        addr_multiplicand_tb <= "0011";  -- Alamat 3 (multiplicand=3)
        addr_multiplier_tb   <= "0011";  -- Alamat 19 (multiplier=3)
        start_tb <= '1';
        wait for CLK_PERIOD;
        start_tb <= '0';
        
        wait until done_tb = '1';
        wait for CLK_PERIOD;
        expected := "00001001";  -- 9
        assert product_tb = expected
            report "Test Case 1 Gagal: 3*3=9" 
            severity error;
        wait for CLK_PERIOD;
        
        -- Test Case 2: 15 * 15 = 225 (alamat 15 dan 31)
        addr_multiplicand_tb <= "1111";  -- Alamat 15 (multiplicand=15)
        addr_multiplier_tb   <= "1111";  -- Alamat 31 (multiplier=15)
        start_tb <= '1';
        wait for CLK_PERIOD;
        start_tb <= '0';
        
        wait until done_tb = '1';
        wait for CLK_PERIOD;
        expected := "11100001";  -- 225
        assert product_tb = expected
            report "Test Case 2 Gagal: 15*15=225" 
            severity error;
        wait for CLK_PERIOD;
        
        -- Test Case 3: 0 * 5 = 0 (alamat 0 dan 21)
        addr_multiplicand_tb <= "0000";  -- Alamat 0 (multiplicand=0)
        addr_multiplier_tb   <= "0101";  -- Alamat 21 (multiplier=5)
        start_tb <= '1';
        wait for CLK_PERIOD;
        start_tb <= '0';
        
        wait until done_tb = '1';
        wait for CLK_PERIOD;
        expected := "00000000";  -- 0
        assert product_tb = expected
            report "Test Case 3 Gagal: 0*5=0" 
            severity error;
        wait for CLK_PERIOD;
        
        -- Berhenti simulasi
        report "Semua test selesai dijalankan";
        wait;
    end process;
end Behavioral;