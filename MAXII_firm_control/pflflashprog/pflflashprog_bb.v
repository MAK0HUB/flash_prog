
module pflflashprog (
	pfl_nreset,
	pfl_flash_access_granted,
	pfl_flash_access_request,
	flash_addr,
	flash_data,
	flash_nce,
	flash_nwe,
	flash_noe);	

	input		pfl_nreset;
	input		pfl_flash_access_granted;
	output		pfl_flash_access_request;
	output	[24:0]	flash_addr;
	inout	[15:0]	flash_data;
	output		flash_nce;
	output		flash_nwe;
	output		flash_noe;
endmodule
