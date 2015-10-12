
module pfl_fl (
	pfl_nreset,
	pfl_flash_access_granted,
	pfl_flash_access_request,
	flash_addr,
	flash_data,
	flash_nce,
	flash_nwe,
	flash_noe,
	pfl_clk,
	fpga_pgm,
	fpga_conf_done,
	fpga_nstatus,
	fpga_data,
	fpga_dclk,
	fpga_nconfig);	

	input		pfl_nreset;
	input		pfl_flash_access_granted;
	output		pfl_flash_access_request;
	output	[24:0]	flash_addr;
	inout	[15:0]	flash_data;
	output		flash_nce;
	output		flash_nwe;
	output		flash_noe;
	input		pfl_clk;
	input	[2:0]	fpga_pgm;
	input		fpga_conf_done;
	input		fpga_nstatus;
	output		fpga_data;
	output		fpga_dclk;
	output		fpga_nconfig;
endmodule
