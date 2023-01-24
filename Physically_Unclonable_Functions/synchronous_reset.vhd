LIBRARY ieee;
USE ieee.std_logic_1164.all;
-----------------------------
ENTITY synchronous_reset IS
    PORT (
	       -- INPUTS --
	       sig_a   : IN STD_LOGIC;
			 sig_c   : IN STD_LOGIC;
	       sig_e   : IN STD_LOGIC;
	       sig_g   : IN STD_LOGIC;
			 clk_a   : IN STD_LOGIC;
			 clk_b   : IN STD_LOGIC;
			 rst     : IN STD_LOGIC; --Global reset signal
          on_1    : IN STD_LOGIC; --The first input signal that should be constant 1
		    on_2    : IN STD_LOGIC; --The second input signal that should be constant 1
			 -- Outputs
	       sig_b   : OUT STD_LOGIC;
			 sig_d   : OUT STD_LOGIC;
	       sig_f   : OUT STD_LOGIC;
	       sig_h   : OUT STD_LOGIC
			 );
END synchronous_reset;
-------------------------------------
ARCHITECTURE rtl of synchronous_reset IS
SIGNAL q0  : STD_LOGIC;
SIGNAL q1  : STD_LOGIC;
SIGNAL q2  : STD_LOGIC;
SIGNAL q3  : STD_LOGIC;
-- Each clock signal controls two stages of sequential logic. For organization, this is divided into 4 processes
BEGIN
	 ------------------------
    P1: PROCESS (clk_a, on_1)
    BEGIN
        IF not on_1 = '1' THEN
            q0 <= '0';
				q1 <= '0';
        ELSIF (rising_edge(clk_a)) THEN
            q0 <= rst;
				q1 <= q0;
        END IF;
	 END PROCESS P1;
	 -----------------------
	 P2: PROCESS(clk_b, on_2)
	 BEGIN
		  IF not on_2 = '1' THEN
            q2 <= '0';
				q3 <= '0';
        ELSIF (rising_edge(clk_b)) THEN
            q2 <= rst;
				q3 <= q2;
		  END IF;
	 END PROCESS P2;
	 ---------------------
	 P3: PROCESS(clk_a, q1)
	 BEGIN
		  IF not q1 ='1' THEN
				sig_b <= '0';
				sig_d <= '0';
		  ELSIF (rising_edge(clk_a)) THEN
				sig_b <= sig_a;
				sig_d <= sig_c;
		  END IF;
	 END PROCESS P3;
	 ---------------------
	 P4: PROCESS(clk_b, q3)
	 BEGIN
		  IF not q3 ='1' THEN
				sig_f <= '0';
				sig_h <= '0';
			ELSIF (rising_edge(clk_b)) THEN
				sig_f <= sig_e;
				sig_h <= sig_g;
			END IF;
    END PROCESS P4;
END rtl;