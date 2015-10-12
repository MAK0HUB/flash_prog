	pfl_fl u0 (
		.pfl_nreset               (<connected-to-pfl_nreset>),               //               pfl_nreset.pfl_nreset
		.pfl_flash_access_granted (<connected-to-pfl_flash_access_granted>), // pfl_flash_access_granted.pfl_flash_access_granted
		.pfl_flash_access_request (<connected-to-pfl_flash_access_request>), // pfl_flash_access_request.pfl_flash_access_request
		.flash_addr               (<connected-to-flash_addr>),               //               flash_addr.flash_addr
		.flash_data               (<connected-to-flash_data>),               //               flash_data.flash_data
		.flash_nce                (<connected-to-flash_nce>),                //                flash_nce.flash_nce
		.flash_nwe                (<connected-to-flash_nwe>),                //                flash_nwe.flash_nwe
		.flash_noe                (<connected-to-flash_noe>),                //                flash_noe.flash_noe
		.pfl_clk                  (<connected-to-pfl_clk>),                  //                  pfl_clk.pfl_clk
		.fpga_pgm                 (<connected-to-fpga_pgm>),                 //                 fpga_pgm.fpga_pgm
		.fpga_conf_done           (<connected-to-fpga_conf_done>),           //           fpga_conf_done.fpga_conf_done
		.fpga_nstatus             (<connected-to-fpga_nstatus>),             //             fpga_nstatus.fpga_nstatus
		.fpga_data                (<connected-to-fpga_data>),                //                fpga_data.fpga_data
		.fpga_dclk                (<connected-to-fpga_dclk>),                //                fpga_dclk.fpga_dclk
		.fpga_nconfig             (<connected-to-fpga_nconfig>)              //             fpga_nconfig.fpga_nconfig
	);

