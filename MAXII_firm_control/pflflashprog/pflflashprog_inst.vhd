	component pflflashprog is
		port (
			pfl_nreset               : in    std_logic                     := 'X';             -- pfl_nreset
			pfl_flash_access_granted : in    std_logic                     := 'X';             -- pfl_flash_access_granted
			pfl_flash_access_request : out   std_logic;                                        -- pfl_flash_access_request
			flash_addr               : out   std_logic_vector(24 downto 0);                    -- flash_addr
			flash_data               : inout std_logic_vector(15 downto 0) := (others => 'X'); -- flash_data
			flash_nce                : out   std_logic;                                        -- flash_nce
			flash_nwe                : out   std_logic;                                        -- flash_nwe
			flash_noe                : out   std_logic                                         -- flash_noe
		);
	end component pflflashprog;

	u0 : component pflflashprog
		port map (
			pfl_nreset               => CONNECTED_TO_pfl_nreset,               --               pfl_nreset.pfl_nreset
			pfl_flash_access_granted => CONNECTED_TO_pfl_flash_access_granted, -- pfl_flash_access_granted.pfl_flash_access_granted
			pfl_flash_access_request => CONNECTED_TO_pfl_flash_access_request, -- pfl_flash_access_request.pfl_flash_access_request
			flash_addr               => CONNECTED_TO_flash_addr,               --               flash_addr.flash_addr
			flash_data               => CONNECTED_TO_flash_data,               --               flash_data.flash_data
			flash_nce                => CONNECTED_TO_flash_nce,                --                flash_nce.flash_nce
			flash_nwe                => CONNECTED_TO_flash_nwe,                --                flash_nwe.flash_nwe
			flash_noe                => CONNECTED_TO_flash_noe                 --                flash_noe.flash_noe
		);

