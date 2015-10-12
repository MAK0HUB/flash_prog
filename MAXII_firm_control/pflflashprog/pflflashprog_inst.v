	pflflashprog u0 (
		.pfl_nreset               (<connected-to-pfl_nreset>),               //               pfl_nreset.pfl_nreset
		.pfl_flash_access_granted (<connected-to-pfl_flash_access_granted>), // pfl_flash_access_granted.pfl_flash_access_granted
		.pfl_flash_access_request (<connected-to-pfl_flash_access_request>), // pfl_flash_access_request.pfl_flash_access_request
		.flash_addr               (<connected-to-flash_addr>),               //               flash_addr.flash_addr
		.flash_data               (<connected-to-flash_data>),               //               flash_data.flash_data
		.flash_nce                (<connected-to-flash_nce>),                //                flash_nce.flash_nce
		.flash_nwe                (<connected-to-flash_nwe>),                //                flash_nwe.flash_nwe
		.flash_noe                (<connected-to-flash_noe>)                 //                flash_noe.flash_noe
	);

