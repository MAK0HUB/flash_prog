module sys_cpld_top (
//*****************************************************************************
//*	                             System Signals                             *
//*****************************************************************************
input	wire  clkin_50,
input	wire 	clkin_max_100,
input	wire	sys_resetn,

//fpga interface
input	wire	max_csn,
output wire	max_wen,
input	wire	max_oen,
input	wire	hsma_psntn,
input	wire	hsmb_psntn,

//pfl interface
input	wire	fpga_conf_done,
//inout	wire	         fpga_conf_done,
input	wire	         fpga_statusn,
input	wire	         load,
input	wire	         pgm_sel,
input	wire	         user_factory,
output wire	[7:0]    fpga_data,
output wire	         fpga_dclk,
output wire	         fpga_confign,
output wire	         msel_0,
output wire	         msel_2,
output wire	         msel_3,

//*********************************
//*              flash            *
//********************************* 
inout wire  [15:0]	fsm_d,
output wire	[25:1]   fsm_a,
output wire	         flash_cen,
output wire	         flash_wen,
output wire	         flash_oen,
//----------------------------
output wire	         flash_clk,
output wire       	flash_advn,
output wire	         flash_resetn,
//**********************************

input wire	         csense_sdo,
output wire	         csense_sck,
output wire	         csense_sdi,
output wire	         csense_csn,
//------------max_led-------------
//output wire	         max_factory,   //G4
//output wire	         max_user,      //G1
//output wire	         max_error,     //G2
//output wire	         max_epcs,      //G3

output wire  [3:0]   max_leds,
//output wire	max_load, -- changed on rev3

output wire	        fan_cntl,
output wire	[7:0]   user_led ,

//Si570 control
output wire	clka_en,
output wire	smb_clk,
inout wire	smb_data

);

wire pfl_flash_access_request_ins;
wire [2:0]  fpga_pgm_ins;
assign fpga_pgm_ins	= {1'b0,flag};

reg [1:0] flag   = 2'b00 ; 
reg [1:0] p_flag = 2'b00 ; 

wire   pfl_flash_access_granted_ins;
assign pfl_flash_access_granted_ins = pfl_flash_access;
reg    pfl_flash_access = 1'b1 ;

assign	flash_clk   = 1'b0 ;
assign	flash_advn  = 1'b0 ;

assign	user_led    = 8'hZZ;
assign   msel_0      = 1'bZ ;
assign   msel_1      = 1'bZ ;
assign   msel_2      = 1'bZ ;

assign max_leds = {1'b0, !flag [0], !flag [1], state[0]};

assign max_wen     = reg_max_wen;
reg    reg_max_wen = 1'b1;

wire start_cfg ;
assign  start_cfg = start_cfg_reg;
reg start_cfg_reg = 1'b1;

wire rst_pfl; 
assign  rst_pfl = rst_pfl_reg;
reg rst_pfl_reg = 1'b1;

wire fl_rd_req ;
assign  fl_rd_req = fl_rd_req_reg;
reg fl_rd_req_reg = 1'b1;


wire [1:0]  pfl_str   ;
wire        rd_compl  ;

parameter [3:0] IDLE         = 4'b0001,
                FST_CFG      = 4'b0010,
				    FST_IDLE     = 4'b0011,
					 READ_FIRM    = 4'b0100,
					 CNT_RST      = 4'b0101,
					 CNT_CFG      = 4'b0110,
					 PAGE         = 4'b0111,
					 CFG_DN       = 4'b1000,
					 WAIT_CFG     = 4'b1001,
					 CFG          = 4'b1010,
					 FLAG         = 4'b1011,
					 WR_TB        = 4'b1100,
					 WAIT_WR      = 4'b1101,
					 WR_DN        = 4'b1110;
					  
assign   flash_cen    = (pfl_flash_access_granted_ins )? pfl_cen  : fl_cen  ; 
assign   flash_oen    = (pfl_flash_access_granted_ins )? pfl_oen  : fl_oen  ;
assign   flash_wen    = (pfl_flash_access_granted_ins )? pfl_wen  : fl_wen  ;
assign   fsm_a        = (pfl_flash_access_granted_ins )? pfl_addr : fl_addr ;

wire          fl_cen  ,pfl_cen  ; 
wire          fl_oen  ,pfl_oen  ;
wire          fl_wen  ,pfl_wen  ;
wire [25:1 ]  fl_addr ,pfl_addr ; 

//-------------------------------------------------------------
reg [2:0 ]   cnt     = 3'b000      ;				
reg [3:0 ]   state   = FST_IDLE    ;	
reg [23:0]   cnt_rst = 24'h000000  ;
reg [23:0]   cnt_cfg = 24'h000000  ;
reg [27:0]   cnt_wt  = 28'h0000000 ;
reg  reg_fst_cfg     = 1'b1        ;
//------------------------------------------------------------


always @( posedge clkin_max_100)

begin
//if (!sys_resetn) state <= IDLE; 

case (state)  

        FST_IDLE : begin
		               reg_max_wen      <= 1'b1   ;
							reg_fst_cfg      <= 1'b1   ;
			            pfl_flash_access <= 1'b1   ;
							fl_rd_req_reg    <= 1'b1   ;
							if ( fpga_conf_done )  
					              state <= READ_FIRM ;	
     			       end // FST_IDLE
					 
		  READ_FIRM: begin
		               pfl_flash_access <= 1'b0   ;
			            fl_rd_req_reg    <= 1'b0   ;
							case (pfl_str)
							  2'b00: flag <= pfl_str   ;
							  2'b01: flag <= pfl_str   ;
							  2'b10: flag <= pfl_str   ;
							  2'b11: flag <= 2'b01     ;
							endcase
							if ( rd_compl)
			      				  state <= FST_CFG   ;		
     			       end // READ_FIRM
		 
		  FST_CFG:  begin
			            pfl_flash_access <= 1'b1   ;
							fl_rd_req_reg    <= 1'b1   ;	
					      state <= CNT_CFG           ;	
     			      end // FST_CFG

		  IDLE   :  begin
					      pfl_flash_access <= 1'b1   ;
					      start_cfg_reg    <= 1'b1   ;
							rst_pfl_reg      <= 1'b1   ;
					      cnt_rst   <= 24'h000000    ;
							cnt_cfg   <= 24'h000000    ;
							cnt_wt    <= 28'h0000000   ;
							if (!max_csn) 
							  begin
							     state       <= FLAG;
								  reg_max_wen <= 1'b1;
							  end
				       end	// IDLE
					  
			FLAG : begin 
			            p_flag <= flag              ;	
			            state  <= PAGE              ; 
			       end 
					 
			PAGE : begin
			            if ((flag == 2'b00 ) || (flag == 2'b10  )) flag <= 2'b01;
							else if (flag == 2'b01) flag <= 2'b10;
							state   <= CFG              ;
     			    end //PAGE 
					 
			CFG:  begin
			            pfl_flash_access <= 1'b1    ;
					      state            <= CNT_CFG ;	
     			    end //CFG
					 
			CNT_CFG : begin
			             pfl_flash_access <= 1'b1   ;
			             if (cnt_cfg == 24'hFFFFFF)
							   begin
								  state <= CNT_RST         ;
						        start_cfg_reg <= 1'b1    ;	
							     cnt_cfg <= 24'h000000    ;	
								end
			             else 
							   begin
							     cnt_cfg <= cnt_cfg +1'b1 ;
				              start_cfg_reg <= 1'b0    ;
				            end				
     			       end //CNT_CFG 
					 
		   CNT_RST: begin
			             if (cnt_rst == 24'hFFFFFF)
						       begin
								   state   <= WAIT_CFG   ;  
									rst_pfl_reg <= 1'b1   ;
									cnt_rst <= 24'h000000 ;
								 end  
			             else 
							    begin
							      cnt_rst <= cnt_rst +1'b1;
								   rst_pfl_reg   <= 1'b0   ;
								  end 			
     			        end //CNT_RES 
						  
			 WAIT_CFG :  begin
			             if (cnt_wt == 28'hFFFFFFF)
						       begin
								   state   <=  CFG_DN    ;  
									cnt_wt <= 28'h0000000 ;
								 end  
			             else 
							    begin
							      cnt_wt <= cnt_wt +1'b1;
								  end 			
     			        end //WAIT_CFG  
			
          CFG_DN:  begin
			             if (fpga_conf_done == 1'b1)
						       begin
								   state        <= IDLE  ;
								   reg_fst_cfg  <= 1'b0  ;	
								 end
			             else 
							    begin
								    if (reg_fst_cfg)
								       case (pfl_str)
							           2'b00: flag <= 2'b00   ;
							           2'b01: flag <= 2'b00   ;
							           2'b10: flag <= 2'b01   ;
							           2'b11: flag <= 2'b10   ;
							          endcase
								    else       flag <= p_flag  ;	
								 reg_max_wen <= 1'b0           ;
                         state       <= CFG            ; 
								 end 
     			        end //CFG_DN 	

	   endcase 	 
 end				  
			
			pfl_fun pfl_fun_conf_fpga (
		.pfl_nreset               (rst_pfl       ),               // pfl_nreset.pfl_nreset  
		.pfl_flash_access_granted (pfl_flash_access_granted_ins), // pfl_flash_access_granted.pfl_flash_access_granted
		.pfl_flash_access_request (pfl_flash_access_request_ins), // pfl_flash_access_request.pfl_flash_access_request
		.flash_addr               (pfl_addr      ),               // flash_addr.flash_addr
		.flash_data               (fsm_d         ),               // flash_data.flash_data
		.flash_nce                (pfl_cen       ),               // flash_nce.flash_nce
		.flash_nwe                (pfl_wen       ),               // flash_nwe.flash_nwe
		.flash_noe                (pfl_oen       ),               // flash_noe.flash_noe
		.pfl_clk                  (clkin_max_100 ),               // pfl_clk.pfl_clk
		.fpga_pgm                 (fpga_pgm_ins  ),               // fpga_pgm.fpga_pgm
		.fpga_conf_done           (fpga_conf_done),               // fpga_conf_done.fpga_conf_done
		.fpga_nstatus             (fpga_statusn  ),               // fpga_nstatus.fpga_nstatus
		.fpga_data                (fpga_data     ),               // fpga_data.fpga_data
		.fpga_dclk                (fpga_dclk     ),               // fpga_dclk.fpga_dclk
		.fpga_nconfig             (fpga_confign  ),               // fpga_nconfig.fpga_nconfig
	   .pfl_nreconfigure         (start_cfg     ),               // pfl_nreconfigure.pfl_nreconfigure  
		.flash_nreset             (flash_resetn  ) 
	);

		flash_control_MM cpld_flash_cont (
//--------------- flash --------------------
     .fc_rd_req                 ( fl_rd_req    ),
     .clk                       ( clkin_50     ),
//---------------------------------------------   
     .fc_flash_cen              ( fl_cen       ),
     .fc_flash_oen              ( fl_oen       ),
     .fc_flash_wen              ( fl_wen       ),
     .fc_fsm_d                  ( fsm_d        ),
     .fc_fsm_a                  ( fl_addr      ),
 //------------ reconf  --------------------
     .rd_done                   ( rd_compl     ),
     .pfl_str                   ( pfl_str      ) 
  );
  
	endmodule