library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port (
        clk      : in  STD_LOGIC;  -- Clock
        reset    : in  STD_LOGIC;  -- Reset (aktif tinggi)
        start    : in  STD_LOGIC;  -- Sinyal mulai operasi
        Q0       : in  STD_LOGIC;  -- Bit LSB register pengali
        cnt_done : in  STD_LOGIC;  -- Sinyal selesai dari counter
        load     : out STD_LOGIC;  -- Sinyal load untuk inisialisasi
        shift    : out STD_LOGIC;  -- Sinyal geser
        add      : out STD_LOGIC;  -- Sinyal penjumlahan
        done     : out STD_LOGIC   -- Sinyal perkalian selesai
    );
end control_unit;

architecture FSM of control_unit is
    type state_type is (IDLE, LOAD_REG, CHECK, ADD_STATE, SHIFT_STATE, DONE_STATE);
    signal state, next_state : state_type;
begin
    -- Proses sinkronisasi state
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Proses transisi state dan output
    process(state, start, Q0, cnt_done)
    begin
        -- Default nilai sinyal kontrol
        load  <= '0';
        shift <= '0';
        add   <= '0';
        done  <= '0';
        
        case state is
            when IDLE =>
                if start = '1' then
                    next_state <= LOAD_REG;  -- Mulai operasi
                else
                    next_state <= IDLE;
                end if;
                
            when LOAD_REG =>
                load <= '1';                -- Inisialisasi register
                next_state <= CHECK;
                
            when CHECK =>
                if cnt_done = '1' then      -- Cek apakah counter selesai
                    next_state <= DONE_STATE;
                elsif Q0 = '1' then         -- Jika LSB=1, lakukan penjumlahan
                    next_state <= ADD_STATE;
                else                        -- Jika tidak, langsung geser
                    next_state <= SHIFT_STATE;
                end if;
                
            when ADD_STATE =>
                add <= '1';                 -- Aktifkan sinyal penjumlahan
                next_state <= SHIFT_STATE;
                
            when SHIFT_STATE =>
                shift <= '1';               -- Aktifkan sinyal geser
                next_state <= CHECK;
                
            when DONE_STATE =>
                done <= '1';                -- Tandai operasi selesai
                if start = '0' then         -- Tunggu start dilepas
                    next_state <= IDLE;
                else
                    next_state <= DONE_STATE;
                end if;
        end case;
    end process;
end FSM;