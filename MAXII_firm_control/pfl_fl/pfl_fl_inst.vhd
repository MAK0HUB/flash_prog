	component pfl_fl is
		port (
			pfl_nreset               : in    std_logic                     := 'X';             -- pfl_nreset
			pfl_flash_access_granted : in    std_logic                     := 'X';             -- pfl_flash_access_granted
			pfl_flash_access_request : out   std_logic;                                        -- pfl_flash_access_request
			flash_addr               : out   std_logic_vector(24 downto 0);                    -- flash_addr
			flash_data               : inout std_logic_vector(15 downto 0) := (others => 'X'); -- flash_data
			flash_nce                : out   std_logic;                                        -- flash_nce
			flash_nwe                : out   std_logic;                                        -- flash_nwe
			flash_noe                : out   std_logic;                                        -- flash_noe
			pfl_clk                  : in    std_logic                     := 'X';             -- pfl_clk
			fpga_pgm                 : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- fpga_pgm
			fpga_conf_done           : in    std_logic                     := 'X';             -- fpga_conf_done
			fpga_nstatus             : in    std_logic                     := 'X';             -- fpga_nstatus
			fpga_data                : out   std_logic;                                        -- fpga_data
			fpga_dclk                : out   std_logic;                                        -- fpga_dclk
			fpga_nconfig             : out   std_logic                                         -- fpga_nconfig
		);
	end component pfl_fl;

	u0 : component pfl_fl
		port map (
			pfl_nreset               => CONNECTED_TO_pfl_nreset,               --               pfl_nreset.pfl_nreset
			pfl_flash_access_granted => CONNECTED_TO_pfl_flash_access_granted, -- pfl_flash_access_granted.pfl_flash_access_granted
			pfl_flash_access_request => CONNECTED_TO_pfl_flash_access_request, -- pfl_flash_access_request.pfl_flash_access_request
			flash_addr               => CONNECTED_TO_flash_addr,               --               flash_addr.flash_addr
			flash_data               => CONNECTED_TO_flash_data,               --               flash_data.flash_data
			flash_nce                => CONNECTED_TO_flash_nce,                --                flash_nce.flash_nce
			flash_nwe                => CONNECTED_TO_flash_nwe,                --                flash_nwe.flash_nwe
			flash_noe                => CONNECTED_TO_flash_noe,                --                flash_noe.flash_noe
			pfl_clk                  => CONNECTED_TO_pfl_clk,                  --                  pfl_clk.pfl_clk
			fpga_pgm                 => CONNECTED_TO_fpga_pgm,                 --                 fpga_pgm.fpga_pgm
			fpga_conf_done           => CONNECTED_TO_fpga_conf_done,           --           fpga_conf_done.fpga_conf_done
			fpga_nstatus             => CONNECTED_TO_fpga_nstatus,             --             fpga_nstatus.fpga_nstatus
			fpga_data                => CONNECTED_TO_fpga_data,                --                fpga_data.fpga_data
			fpga_dclk                => CONNECTED_TO_fpga_dclk,                --                fpga_dclk.fpga_dclk
			fpga_nconfig             => CONNECTED_TO_fpga_nconfig              --             fpga_nconfig.fpga_nconfig
		);

