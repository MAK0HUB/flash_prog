module sys_cpld_top (
//*****************************************************************************
//*	                             System Signals                             *
//*****************************************************************************
input	wire  clkin_50,
input	wire 	clkin_max_100,
input	wire	sys_resetn,

//fpga interface
input	wire	max_csn,
input	wire	max_wen,
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
reg [1:0] flag = 2'b00 ; // 

wire pfl_flash_access_granted_ins;
assign   pfl_flash_access_granted_ins = pfl_flash_access;
reg   pfl_flash_access = 1'b1 ;

//assign	flash_clk = 1'b0;
//assign	flash_resetn = 1'b1;
//assign	flash_advn = 1'b0;

assign	user_led  = 8'bZZZZZZZZ;
assign   msel_0 = 1'bZ;
assign   msel_1 = 1'bZ;
assign   msel_2 = 1'bZ;


//assign max_leds = {m_led , max_csn};
//assign fpga_pgm_ins	= {3'b000};
assign max_leds = {state[3:0]};
//reg [2:0] m_led = 3'b011;

//assign max_leds = {fpga_statusn,fpga_conf_done,fpga_confign,oper_compl};

wire start_cfg ;
assign  start_cfg = start_cfg_reg;
reg start_cfg_reg = 1'b1;

wire rst_pfl; 
assign  rst_pfl = rst_pfl_reg;
reg rst_pfl_reg = 1'b1;

wire fl_req ;
assign  fl_req = fl_req_reg;
reg fl_req_reg = 1'b1;

reg  cnt_flag  = 1'b1;
reg [3:0] cnt_res = 4'h0;
reg  load_flag = 1'b1;

wire [1:0]  pfl_str ;



/*
	always@(posedge clkin_max_100)
begin
//   if (!pgm_sel) flag = ! flag;
	
     if (!pgm_sel & load_flag)
	  begin
	      load_flag <= 1'b0;
	      if (flag == 2'b10) flag <=2'b00;
	      else
	      flag <= flag + 1'b1;
	 end;
	  if (!load) load_flag <= 1'b1;  //if (!load) load_flag <= 1'b1;
	  
	  case (flag) 
	   2'b00: m_led = 3'b011 ; 
      2'b01: m_led = 3'b101 ; 
      2'b10: m_led = 3'b110 ; 
    endcase 

	end
*/	
	
	
	
/*
reg prev_signal;
	always@(posedge clkin_max_100)
	prev_signal <= fpga_conf_done;
wire front_edge;
assign front_edge = ~prev_signal & fpga_conf_done;
*/


parameter [5:0] IDLE         = 6'b000001,
                FST_CFG      = 6'b000010,
				    FST_IDLE     = 6'b000011,
					 READ_FIRM    = 6'b000100,
					 FIRST        = 6'b000101,
					 INITE        = 6'b011111,
					 UNLOCK_PFL   = 6'b100000, 
				    UNLOCK_2_PFL = 6'b100001,
					 ERASE_PFL    = 6'b100010,
					 ERASE_2_PFL  = 6'b100011,
					 WRITE_PFL	  = 6'b100100,
					 WRITE_2_PFL  = 6'b100101,
				CLEAR_SR_WR_PFL  = 6'b100110,
				READ_SR_WR_PFL   = 6'b100111,     
				READ_SR_ER_PFL   = 6'b101000,
				CLEAR_SR_ER_PFL  = 6'b101001,	
				WRITE_ER_PFL     = 6'b101010, 
			   WRITE_ER_2_PFL   = 6'b101011,
				     TO_Z_PFL    = 6'b101100,
				     FROM_Z_PFL  = 6'b101101,
					  CNT_RST     = 6'b101110,
					  CNT_CFG     = 6'b101111,
					  PAGE        = 6'b110000,
					  CFG_DN      = 6'b110001,
					  WAIT_CFG    = 6'b110010,
					  CFG         = 6'b110011,
					  PAGE_2      = 6'b110100;
					  
assign   flash_cen    = (pfl_flash_access_granted_ins )? pfl_cen  : fl_cen  ; 
assign   flash_oen    = (pfl_flash_access_granted_ins )? pfl_oen  : fl_oen  ;
assign   flash_wen    = (pfl_flash_access_granted_ins )? pfl_wen  : fl_wen  ;
assign   flash_advn   = (pfl_flash_access_granted_ins )? pfl_advn : fl_advn ;
//assign   fsm_d        = (pfl_flash_access_granted_ins )? pfl_data : fl_data ;
assign   fsm_a        = (pfl_flash_access_granted_ins )? pfl_addr : fl_addr ;


wire   fl_cen  ,pfl_cen  ; 
wire   fl_oen  ,pfl_oen  ;
wire   fl_wen  ,pfl_wen  ;
wire   fl_advn ,pfl_advn ;
wire [15:0 ]    fl_data , pfl_data    ;  
wire [25:1 ]    fl_addr , pfl_addr    ; 

//-------------------------------------------------------------
reg [2:0  ]   cnt      = 3'b000       ;				
reg [5:0  ]   state    = FST_IDLE     ;
reg [23:0 ]   kol      = 24'h000000   ;	
reg [1:0  ]   pos      = 2'b00        ;
reg           sig      = 1'b0         ;
reg           nres     = 1'b1         ;
reg [15:0 ]   dat_cnt  = 16'h0000     ;	
reg [4:0  ]   kol_2    = 5'b00000     ;
reg           flag_unl                ;
reg           rd_flg  = 1'b0          ;
reg           cnt_flg = 1'b0          ;

reg [23:0]    cnt_rst                 ;
reg [23:0]    cnt_cfg                 ;
reg [27:0]    cnt_wt                  ;

//------------------------------------------------------------
//reg fl_req   = 1'b0;


always @( posedge clkin_max_100)

begin
//if (!sys_resetn) state <= IDLE; 
case (state)  

        FST_IDLE : begin
			             pfl_flash_access <= 1'b1  ;
							 fl_req_reg       <= 1'b1  ;
							 if ( fpga_conf_done )  
					       state <=   READ_FIRM      ;	
     			      end // FST_IDLE
					 
		 READ_FIRM: begin
		                pfl_flash_access <= 1'b0  ;
			             fl_req_reg       <= 1'b0  ;
							 flag <= pfl_str           ;
							 if ( oper_compl)
			      				   state <= FST_CFG  ;		
     			      end // READ_FIRM
		 
		  FST_CFG:  begin
			            pfl_flash_access <= 1'b1   ;
					      state <= CNT_CFG           ;		
     			      end // FST_CFG

		  IDLE   : begin
					      pfl_flash_access <= 1'b1    ;
					      start_cfg_reg    <= 1'b1    ;
							rst_pfl_reg      <= 1'b1    ;
					      cnt_rst   <= 24'h000000     ;
							cnt_cfg   <= 24'h000000     ;
							cnt_wt    <= 28'h0000000    ;
							if (!max_csn) state <= PAGE ;
				     end	// IDLE
					  
			PAGE : begin
			            if ((flag == 2'b00 ) || (flag == 2'b10  )) flag <= 2'b01;
							else if (flag == 2'b01) flag <= 2'b10;
							 state <= CFG        ;
							/*
			            pfl_flash_access <= 1'b0   ;
			            fl_req_reg       <= 1'b0   ;
							flag <= pfl_str            ;
							if ( oper_compl)
			      				 state <= CFG        ;
					*/				 
     			    end //PAGE 
					 
			CFG:  begin
			            pfl_flash_access <= 1'b1   ;
					      state <= CNT_CFG           ;		
     			    end //CFG
					 
			CNT_CFG : begin
			             pfl_flash_access <= 1'b1  ;
			             if (cnt_cfg == 24'hFFFFFF)
							   begin
								state <= CNT_RST     ;
						      start_cfg_reg <= 1'b1    ;	
							   cnt_cfg <= 24'h000000;	
								end
			             else 
							   begin
							   cnt_cfg <= cnt_cfg +1'b1;
				            start_cfg_reg <= 1'b0   ;
				            end				
     			       end //CNT_CFG 
					 
		   CNT_RST: begin
			             if (cnt_rst == 24'hFFFFFF)
						       begin
								   state   <= WAIT_CFG   ;  
									rst_pfl_reg <= 1'b1       ;
									cnt_rst <= 24'h000000 ;
								 end  
			             else 
							    begin
							      cnt_rst <= cnt_rst +1'b1;
								   rst_pfl_reg   <= 1'b0       ;
								  end 			
     			        end //CNT_RES 
						  
			 WAIT_CFG :  begin
			             if (cnt_wt == 28'hFFFFFFF)
						       begin
								   state   <=  IDLE  ;  // CFG_DN 
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
								   state <= IDLE   ;  
								 end
			             else 
							 
							    begin
								 flag <= 2'b01;
	                      //  flag <= flag - 1'b1;
					            state <= CNT_CFG ;	
								 end 	
							
     			        end //CFG_DN 	
						 
						 
	   endcase 	 
 end				  

							
			pfl_fun pfl_fun_conf_fpga (
		.pfl_nreset               (rst_pfl ),                   // pfl_nreset.pfl_nreset  sys_resetn start_cfg front_edge rst_pfl 
		.pfl_flash_access_granted (pfl_flash_access_granted_ins), // pfl_flash_access_granted.pfl_flash_access_granted
		.pfl_flash_access_request (pfl_flash_access_request_ins), // pfl_flash_access_request.pfl_flash_access_request
		.flash_addr               (pfl_addr),                        // flash_addr.flash_addr
		.flash_data               (fsm_d),                        // flash_data.flash_data
		.flash_nce                (pfl_cen),                    // flash_nce.flash_nce
		.flash_nwe                (pfl_wen),                    // flash_nwe.flash_nwe
		.flash_noe                (pfl_oen),                    // flash_noe.flash_noe
		.pfl_clk                  (clkin_max_100),                // pfl_clk.pfl_clk
		.fpga_pgm                 (fpga_pgm_ins ),                // fpga_pgm.fpga_pgm
		.fpga_conf_done           (fpga_conf_done),               // fpga_conf_done.fpga_conf_done
		.fpga_nstatus             (fpga_statusn),                 // fpga_nstatus.fpga_nstatus
		.fpga_data                (fpga_data),                    // fpga_data.fpga_data
		.fpga_dclk                (fpga_dclk),                    // fpga_dclk.fpga_dclk
		.fpga_nconfig             (fpga_confign),                 // fpga_nconfig.fpga_nconfig
		//.pfl_nreconfigure         (start_cfg),                  // pfl_nreconfigure.pfl_nreconfigure
		//.pfl_nreconfigure         (load),                       // pfl_nreconfigure.pfl_nreconfigure
	   .pfl_nreconfigure         (start_cfg ),                     // pfl_nreconfigure.pfl_nreconfigure  start_cfg
		//.pfl_reset_watchdog       (load),                             // pfl_reset_watchdog.pfl_reset_watchdog
		//.pfl_watchdog_error       (reconf),                       // pfl_watchdog_error.pfl_watchdog_error
		.flash_nreset             (flash_resetn) 
	);

	
		flash_control_MM cpld_flash_cont (
//--------------- flash --------------------
  .fc_flash_contr      ( pfl_flash_access  ),
  .fc_req              ( fl_req            ),
  .clk                 ( clkin_50          ),
//---------------------------------------------  
  .fc_flash_advn       ( fl_advn              ),  // flash_advn   fl_advn 
  .fc_flash_cen        ( fl_cen            ),
  .fc_flash_clk        ( flash_clk         ),
  .fc_flash_oen        ( fl_oen            ),
 // .fc_flash_rdybsyn    ( flash_rdybsyn ),
 // .fc_flash_resetn     ( flash_resetn  ),
  .fc_flash_wen        ( fl_wen            ),
  .fc_fsm_d            ( fsm_d             ),
  .fc_fsm_a            ( fl_addr           ),
//--------------- fifo  --------------------
 //  .fc_fifo_in          ( fifo_in       ),  
 // .fc_wrclk            ( tck           ),     
 // .fc_wrreq            ( wr_fifo       ),     
 // .fc_wrfull           ( full          ), 
 // .fc_rdclk            ( clkin_50      ),  
 //------------   leds  --------------------
  .fc_user_led         (  user_led        ), //      user_led 
 //------------ reconf  --------------------
  .wr_done             ( oper_compl        ),
  .pfl_str             ( pfl_str           ) 
  );
  
	
	endmodule