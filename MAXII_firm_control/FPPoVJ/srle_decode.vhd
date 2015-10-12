library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity srle_decode is 
        port (
              -- inputs:
                 signal clk_in : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC_vector(7 downto 0);
                 signal ir_in : IN std_logic_vector(2 downto 0);
                 
                 signal clk : in std_logic;
                 signal reset_n : in std_logic;
                 signal clk_pls : in std_logic;
                 signal decode_reset : in std_logic;
                 

              -- outputs:
				signal data_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
				signal clk_out : out std_logic
              );
end entity srle_decode;


architecture rtl of srle_decode is
	signal out_data : std_logic_vector(7 downto 0);
	signal data : std_logic_vector(7 downto 0);
	signal data_out_int1 : std_logic_vector(7 downto 0);
	signal data_out_int2 : std_logic_vector(7 downto 0);
	signal clk_out_ok : std_logic;
	signal count_ok : std_logic;
	
--	signal clk : std_logic;


	type STATE is (get_length1, get_data, get_length2, IDL);
	signal stm : STATE;
	signal leng_con : std_logic_vector(7 downto 0);
	signal leng_uncon : std_logic_vector(7 downto 0);
	signal clk_out_1, clk_out_2 : std_logic;

	signal uncon_cont : std_logic_vector(7 downto 0);
	signal con_cont : std_logic_vector(7 downto 0);
	
	signal clk_in_d1, clk_in_d2, clk_in_d3, clk_in_d4, clk_in_d5 : std_logic;
	signal clk2_int : std_logic;
	signal reset_int : std_logic;
begin
	reset_int <= reset_n and decode_reset;

	process(reset_int, clk)begin
		if(reset_int = '0')then
			stm <= IDL;
		elsif(clk'event and clk = '1')then
			if(clk_pls = '1')then
				if(ir_in = "100")then
					case stm is
					when IDL =>
						stm <= get_length1;
						leng_uncon <= data_in;
					when get_length1 =>
						stm <= get_data;
						out_data <= data_in;
					when get_data =>
						leng_con <= data_in;
						if(leng_uncon = uncon_cont)then
							stm <= get_length2;
						end if;
					when get_length2 =>
						leng_uncon <= data_in;
						stm <= get_length1;
					when others =>
						stm <= IDL;
					end case;
				end if;
			end if;
		end if;
	end process;

	process(reset_int, clk)begin
		if(reset_int = '0')then
			uncon_cont <= "00000000";
			clk_out_1 <= '0';							
		elsif(clk'event and clk = '1')then
			if(clk_pls = '1')then
				if(ir_in = "100")then
					if(stm = get_data or stm = get_length1)then
						if(leng_uncon = uncon_cont)then
							uncon_cont <= uncon_cont;
							clk_out_1 <= '0';
						else
							uncon_cont <= uncon_cont + 1;
							clk_out_1 <= '1';
							data_out_int1 <= data_in;
						end if;
					elsif(stm = IDL)then
						uncon_cont <= "00000000";
						clk_out_1 <= '0';				
					else
						uncon_cont <= "00000000";
						clk_out_1 <= '0';				
					end if;
				end if;
			end if;
		end if;
	end process;

	process(reset_int, clk)begin
		if(reset_int = '0')then
			con_cont <= (others => '0');
			clk_out_2 <= '0';					
		elsif(clk'event and clk = '1')then
			if(ir_in = "100")then
				if(stm = get_length2 or stm = get_length1)then
					if(leng_con = con_cont)then
						con_cont <= con_cont;
						clk_out_2 <= '0';
					else
						data_out_int2 <= out_data;
						con_cont <= con_cont + 1;
						clk_out_2 <= '1';
					end if;
				else
					con_cont <= (others => '0');
					clk_out_2 <= '0';				
				end if;
			end if;
		end if;
	end process;

	process(clk)begin
		if(clk'event and clk = '1')then
			if(ir_in = "100")then
				if(leng_uncon > 0)then
					data_out <= data_out_int1;
				elsif(leng_con > 0)then
					data_out <= data_out_int2;
				end if;
			end if;
		end if;
	end process;
	
	process(clk)begin
		if(clk'event and clk = '1')then
			clk_in_d5 <= clk_in_d4;
			clk_in_d4 <= clk_in_d3;
			clk_in_d3 <= clk_in_d2;
			clk_in_d2 <= clk_in_d1;
			clk_in_d1 <= clk_in;
		end if;
	end process;

	process(clk)begin
		if(clk'event and clk = '1')then
			if(clk_out_2 = '1')then
				clk2_int <= not clk2_int;
			else
				clk2_int <= '0';
			end if;
		end if;
	end process;
	
	process(clk_out_1, clk_out_2, clk, clk_in, ir_in, clk_in_d5)begin
		if(ir_in = "100")then
			if(clk_out_1 = '1')then
				clk_out <= not clk_in_d5;
			elsif(clk_out_2 = '1')then
				clk_out <= not clk;
			else
				clk_out <= '1';
			end if;
		elsif(ir_in = "110")then
			clk_out <= '0';
		end if;
	end process;
	
end rtl;

