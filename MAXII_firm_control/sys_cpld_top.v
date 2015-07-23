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
output wire	[7:0]   user_led,

//Si570 control
output wire	clka_en,
output wire	smb_clk,
inout wire	smb_data

);

wire pfl_flash_access_granted_ins;
wire pfl_flash_access_request_ins;
wire [2:0]  fpga_pgm_ins;

assign   pfl_flash_access_granted_ins = pfl_flash_access;
reg   pfl_flash_access = 1'b1;

assign	flash_clk = 1'b0;
//assign	flash_resetn = 1'b1;
//assign	flash_advn = 1'b1;

assign	user_led  = 8'bZZZZZZZZ;
assign   msel_0 = 1'bZ;
assign   msel_1 = 1'bZ;
assign   msel_2 = 1'bZ;

assign fpga_pgm_ins	= {1'b0,flag};
//assign max_leds = {m_led , max_csn};
//assign fpga_pgm_ins	= {3'b000};
//assign max_leds = {fpga_statusn,fpga_conf_done,fpga_confign,max_csn};
assign max_leds = {state[3:0]};

reg [1:0] flag = 2'b00;
reg [2:0] m_led = 3'b011;

reg  load_flag = 1'b1;
reg start_cfg = 1'b1;
reg rst_pfl = 1'b1;

reg cnt_flag  = 1'b1;
reg [3:0] cnt_res = 4'h0;

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
                UNLOCK       = 6'b000010, 
				    UNLOCK_2     = 6'b000011,
		          ERASE        = 6'b000100,
					 ERASE_2      = 6'b000101,
					 READ_SR_ER   = 6'b000110,
					 READ_TAB     = 6'b000111,
					 CLEAR_SR_ER  = 6'b001000, 
	             WRITE		  = 6'b001001,	 
					 WRITE_2		  = 6'b001010,
					 READ_SR_WR   = 6'b001011,
				READ_SR_WR_TAB   = 6'b001100,  
					 FROM_Z  	  = 6'b001101,    
				READ_SR_ER_TAB   = 6'b001110,
				CLEAR_SR_ER_TAB  = 6'b001111,	 
					 WRITE_SR_WR  = 6'b010000,
					 UNLOCK_TABLE = 6'b010001,
					 CLEAR_SR_WR  = 6'b010010,
					 WRITE_ER     = 6'b010011, 
					 WRITE_ER_2   = 6'b010100,
					 UNLOCK_TAB   = 6'b010101, 
				    UNLOCK_2_TAB = 6'b010110,
					 ERASE_TAB    = 6'b010111,
					 ERASE_2_TAB  = 6'b011000,
					 WRITE_TAB	  = 6'b011001,
					 WRITE_2_TAB  = 6'b011010,
				CLEAR_SR_WR_TAB  = 6'b011011,
				    CONFIG       = 6'b011100,
					 TO_Z         = 6'b011110,
					 
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
					  PAGE        = 6'b110000;
/*

assign   flash_cen    = (!pfl_flash_access )? sig_ce   : flash_cen  ; 
assign   flash_oen    = (!pfl_flash_access )? sig_oe   : 1'bz ;
assign   flash_wen    = (!pfl_flash_access )? sig_we   : 1'bz ;
assign   flash_advn   = (!pfl_flash_access )? sig_adv  : 1'bz ;

assign   fsm_d        = (!pfl_flash_access )? data     : 16'hzzzz   ;
assign   fsm_a        = (!pfl_flash_access )? addr     : 25'hzzzzzzz;
*/

/*
assign   flash_cen    = sig_ce; 
assign   flash_oen    = sig_oe;
assign   flash_wen    = sig_we;
assign   flash_advn   = sig_adv;

assign   fsm_d        = data;
assign   fsm_a        = addr;
*/

reg [15:0] data        = 16'hZZZZ    ;
reg [15:0] read_data   = 16'hZZZZ    ;
reg [15:0] err_data    = 16'hZZZZ    ;
reg [25:1] addr        = 25'hZZZZZZZ ;  //E60000

reg  sig_ce    = 1'bz; 
reg  sig_oe    = 1'bz; 
reg  sig_we    = 1'bz; 
reg  sig_adv   = 1'bz; 

//-------------------------------------------------------------
reg [2:0  ]   cnt      = 3'b000       ;				
reg [4:0  ]   state    = IDLE         ;
reg [23:0 ]   kol      = 24'h000000   ;	
reg [25:1 ]   adrcnt                  ;  //= 25'h0010000 
reg [1:0  ]   pos      = 2'b00        ;
reg           sig      = 1'b0         ;
reg           nres     = 1'b1         ;
reg [15:0 ]   dat_cnt  = 16'h0000     ;	
reg [4:0  ]   kol_2    = 5'b00000     ;
reg           flag_unl          ;
reg [7:0  ]   mem [0:31]              ; 
reg           rd_flg  = 1'b0          ;
reg           cnt_flg = 1'b0          ;

reg [15:0 ]   firm_N = 16'h1243       ;
reg [5:0 ]    tabl                    ;
reg [15:0 ]   wr_tabl                 ;

reg [31:0]    cnt_rst                 ;
reg [31:0]    cnt_cfg                 ;
//assign  tabl =  firm_N [15:9 ]      ;

//-------------------------------------------------------------

always @( posedge clkin_max_100)
begin	
  
//if (!sys_resetn) state <= IDLE; 

case (state)  

		 IDLE   : begin
	/*	 
							flag_unl     <= 0           ;
							//-------------------------------
			            data         <= 16'hZZZZ    ;
                     read_data    <= 16'hZZZZ    ; 
                     sig_ce       <= 1'bz        ; 
                     sig_oe       <= 1'bz        ; 
                     sig_we       <= 1'bz        ; 
                     sig_adv      <= 1'bz        ; 
							addr         <= 25'hZZZZZZZ ; 
							//-------------------------------
							cnt          <= 3'b000      ;
							kol_2        <= 3'b000      ;
						   kol          <= 24'h000000  ;
						   rdreq        <= 1'b0        ;	
							reg_max_csn  <= 1'b1        ;
					      dat_oe       <= 1'b1        ;
							//----------------------------------
					*/		
					      start_cfg <= 1'b1            ;
							rst_pfl   <= 1'b1            ;
					      cnt_rst <= 32'h00000000      ;
							cnt_cfg <= 32'h00000000      ;
						   if (!load) state <= PAGE     ;		 // max_csn 
				     end	// IDLE
					  
			PAGE : begin
			            //  if (flag == 2'b10) 
							 //    flag <=2'b00;
	                  //  else
	                  //    flag <= flag + 1'b1;
					 state <= CNT_CFG ;			 
     			    end //CNT_RES 
					 
			CNT_CFG : begin
			            // if (cnt_cfg == 32'hFFFFFFFF)
							 //  begin
								state <= CNT_RST    ;
						    //  start_cfg <= 1'b1   ;		
							//	end
			           //  else 
							//   begin
							//   cnt_cfg <= cnt_cfg +1'b1;
				            start_cfg <= 1'b0   ;
				         //   end				
     			       end //CNT_RES 
					  
		   CNT_RST  : begin
			             if (cnt_rst == 32'hFFFFFFFF)
						       begin
								   state <= IDLE;  
									rst_pfl   <= 1'b1       ;
								 end  
			             else 
							    begin
							      cnt_rst <= cnt_rst +1'b1;
								   rst_pfl   <= 1'b0       ;
								  end 
							      				
     			       end //CNT_RES 	  
					  
					  
					  
		/*			  
		READ_TAB: begin
			           case (cnt)
					     //----------------------------- rd  -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL   ; sig_adv    <= 1'b1   ;  end		
			           3'b001: begin  sig_adv   <= 1'b0        ; sig_ce     <= 1'b0   ;  end 
			           3'b010: begin  sig_adv   <= 1'b1        ; sig_oe     <= 1'b0   ;  end	//dat_oe <= 1'b1;  dat_oe <= 1'b0; 
					     3'b110: begin  firm_N    <= fsm_d    ;                         end	// tabl <= firm_N [15:10];
			           3'b111: begin  sig_ce    <= 1'b1        ;
						                 sig_oe    <= 1'b1        ;
											  state     <= UNLOCK_TAB  ;
							             if     ((firm_N [15:10]  == 6'b100000) || (firm_N [15:10] == 6'b111111))
											        begin
															 adrcnt  <= ADDR_FIRM_1   ;
															 wr_tabl <= {6'b100010,10'b0000000000};
													  end 
											 else 
											        begin
											             adrcnt <= ADDR_FIRM_1 ;
															 wr_tabl <= {6'b100010,10'b0000000000};
													  end
													  
										/*	  
										    else if (firm_N [15:10] == 6'b110000)  
											        begin
											             adrcnt <= ADDR_FIRM_2    ;
															 wr_tabl <= {6'b110001,10'b0000000000};
												     end
											 else if (firm_N [15:10] == 6'b101000) // 6'b101000 
											        begin
											             adrcnt <= ADDR_FIRM_1  ;
															 wr_tabl <= {6'b101010,10'b0000000000};
													  end
													  
											 else if (firm_N [15:10] == 6'b111111) 
											        begin
											             adrcnt <= ADDR_FIRM_1 ;
															 wr_tabl <= {6'b100010,10'b0000000000};
													  end
										
										
							       end  // 3'b111
						  endcase
            cnt <= cnt + 1'b1;						  
     			end //READ_N
				
		UNLOCK_TAB : begin
			         case (cnt)
					     //----------------------------- wr 60 h -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0     ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1     ;  sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzz60      ;                          end	
			           3'b111: begin  sig_ce    <= 1'b1     ;  sig_we    <= 1'b1 ; state <= UNLOCK_2_TAB; end         
						endcase
            cnt <= cnt + 1'b1;							
     			end //UNLOCK_TAB
				
		UNLOCK_2_TAB : begin
		            case (cnt)
					     //----------------------------- wr D0 h  -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzzD0   ;                          end	
						  3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= ERASE_TAB;      end 	  
						endcase	
            cnt <= cnt + 1'b1;							
     			end //UNLOCK_2_TAB
				
		ERASE_TAB : begin
		            case (cnt)
					     //----------------------------- wr 20 h -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzz20   ;                          end	
			           3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= ERASE_2_TAB; end         
						endcase	
              cnt <= cnt + 1'b1;							
     			  end //ERASE_TAB
				
		ERASE_2_TAB : begin   
			         case (cnt)
					     //----------------------------- wr D0 h -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL;  sig_adv <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce  <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we  <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzzD0   ;                       end	
                    3'b111: begin  sig_ce <= 1'b1     ;  sig_we    <= 1'b1 ; state <= READ_SR_ER_TAB ; data <= 16'hzzzz;   end    //dat_oe <= 1'b0;      				  
						endcase
                cnt <= cnt + 1'b1;							
     			    end //ERASE_2_TAB
					 	  
	   READ_SR_ER_TAB :  begin
		              case (cnt)
						  3'b000: begin  addr      <= ADDR_TABL;    sig_adv    <= 1'b1  ;    end		
			           3'b001: begin  sig_adv   <= 1'b0     ;    sig_ce     <= 1'b0  ;    end 
			           3'b010: begin  sig_adv   <= 1'b1     ;    sig_oe     <= 1'b0  ;    end	//dat_oe <= 1'b1;  dat_oe <= 1'b0; 
					     3'b110: begin  read_data <= fsm_d ;                                end	
			           3'b111: begin  
					                sig_ce    <= 1'b1      ; 
					                sig_oe    <= 1'b1      ; 
										 if (read_data [7] == 1'b1)
										    begin
											      if ((read_data [5] == 1'b1) || (read_data [4] == 1'b1)) state <=  CLEAR_SR_ER_TAB  ; 
													else state <=  WRITE_TAB;			
											 end
								end  // 3'b111
				       endcase
                   cnt <= cnt + 1'b1;	
	                end //READ_SR_ER_TAB
					
	  CLEAR_SR_ER_TAB : begin
			          case (cnt)
					     //----------------------------- wr 50 h  -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL; sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;    sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;    sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzz50   ;                          end	  
					     3'b111: begin  sig_ce    <= 1'b1  ;    sig_we    <= 1'b1 ; state <= UNLOCK_TAB; end  //state <=  WRITE;       				  
						endcase	
                  cnt <= cnt + 1'b1;							
     			      end //CLEAR_SR_TAB 
		
		WRITE_TAB:   
		          begin
			           case (cnt)
		              //----------------------------- wr 40 h  --------------------------//
	                 3'b000: begin  addr     <= ADDR_TABL; sig_adv  <= 1'b1;  end		
			           3'b001: begin  sig_adv  <= 1'b0   ;   sig_ce   <= 1'b0;  end 
			           3'b010: begin  sig_adv  <= 1'b1   ;   sig_we   <= 1'b0;  end	  
						  3'b011: begin  data <= 16'hzz40   ;                    end	
						  3'b111: begin  sig_ce   <= 1'b1   ;   sig_we   <= 1'b1; state <= WRITE_2_TAB ; end   // 3'b111
						endcase
               cnt <= cnt + 1'b1;	
			      end //WRITE_TAB
				
		WRITE_2_TAB:	 begin
			            case (cnt)	
						 //----------------------------- wr  h  --------------------------//
					     3'b000: begin  addr     <= ADDR_TABL ; sig_adv  <= 1'b1;  end  
			           3'b001: begin  sig_adv  <= 1'b0      ; sig_ce   <= 1'b0;  end  
			           3'b010: begin  sig_adv  <= 1'b1      ; sig_we   <= 1'b0;  end  
						  3'b011: begin  data     <= wr_tabl   ;   end	//data     <= fifo_out  wr_tabl
			           3'b111: begin  sig_ce   <= 1'b1      ;
						                 sig_we   <= 1'b1      ; 
										     state    <= READ_SR_WR_TAB;
											  data     <= 16'hzzzz      ;
									 end // 3'b111 
							endcase
                cnt <= cnt + 1'b1;	
					 end //WRITE_2_TAB 
	   
	  READ_SR_WR_TAB : begin
	               case (cnt)
						  3'b000: begin  addr      <= ADDR_TABL;       sig_adv    <= 1'b1  ;    end		
			           3'b001: begin  sig_adv   <= 1'b0  ;       sig_ce     <= 1'b0  ;    end 
			           3'b010: begin  sig_adv   <= 1'b1  ;       sig_oe     <= 1'b0  ;    end	 
					     3'b110: begin  read_data <= fsm_d ;                                end	
			           3'b111: begin  
					                sig_ce    <= 1'b1      ; 
					                sig_oe    <= 1'b1      ; 
										 if (read_data [7] == 1'b1)
										    begin
											      if ((read_data [5] == 1'b1) || (read_data [4] == 1'b1)) state <= CLEAR_SR_WR_TAB; 
												   else  state  <= UNLOCK;			
									       end
								    end  // 3'b111	
				      endcase
                  cnt <= cnt + 1'b1;	
	               end //READ_SR_WR_TAB
	
	  CLEAR_SR_WR_TAB : begin
			          case (cnt)
					     //----------------------------- wr 50 h   -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b110: begin  data      <= 16'hzz50 ;                       end	  
					     3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= WRITE_TAB; end         				  
						endcase	
                  cnt <= cnt + 1'b1;							
     			      end //CLEAR_SR_WR_TAB			 
		 TO_Z:
		       begin
		       dat_oe <= 1'b1;
		       state <= CONFIG;
				         data         <= 16'hZZZZ    ;
                     read_data    <= 16'hZZZZ    ; 
                     sig_ce       <= 1'bz        ; 
                     sig_oe       <= 1'bz        ; 
                     sig_we       <= 1'bz        ; 
                     sig_adv      <= 1'bz        ; 
							addr         <= 25'hZZZZZZZ ;  
		       end
		 
		 CONFIG: begin 
		             if (kol_2 == 3'b111)
						     begin
							  kol_2 <=3'b000;
							  reg_max_csn  <= 1'b1 ;
							  state <= IDLE;
							  end
						 else
						     begin
							  /*
							dat_oe <= 1'b1; 
							data         <= 16'hZZZZ    ;
                     read_data    <= 16'hZZZZ    ; 
                     sig_ce       <= 1'bz        ; 
                     sig_oe       <= 1'bz        ; 
                     sig_we       <= 1'bz        ; 
                     sig_adv      <= 1'bz        ; 
							addr         <= 25'hZZZZZZZ ; 
							
		                 kol_2 <= kol_2 + 1'b1;
							  reg_max_csn  <= 1'b0 ;
					        end
		         
		         end
	 */
    endcase 	 
 end


							
			pfl_fun pfl_fun_conf_fpga (
		.pfl_nreset               ( rst_pfl ),                   // pfl_nreset.pfl_nreset  sys_resetn start_cfg front_edge
		.pfl_flash_access_granted (pfl_flash_access_granted_ins), // pfl_flash_access_granted.pfl_flash_access_granted
		.pfl_flash_access_request (pfl_flash_access_request_ins), // pfl_flash_access_request.pfl_flash_access_request
		.flash_addr               (fsm_a),                        // flash_addr.flash_addr
		.flash_data               (fsm_d),                        // flash_data.flash_data
		.flash_nce                (flash_cen),                    // flash_nce.flash_nce
		.flash_nwe                (flash_wen),                    // flash_nwe.flash_nwe
		.flash_noe                (flash_oen),                    // flash_noe.flash_noe
		.pfl_clk                  (clkin_max_100),                // pfl_clk.pfl_clk
		.fpga_pgm                 (fpga_pgm_ins ),                // fpga_pgm.fpga_pgm
		.fpga_conf_done           (fpga_conf_done),               // fpga_conf_done.fpga_conf_done
		.fpga_nstatus             (fpga_statusn),                 // fpga_nstatus.fpga_nstatus
		.fpga_data                (fpga_data),                    // fpga_data.fpga_data
		.fpga_dclk                (fpga_dclk),                    // fpga_dclk.fpga_dclk
		.fpga_nconfig             (fpga_confign),                 // fpga_nconfig.fpga_nconfig
		//.pfl_nreconfigure         (start_cfg),                  // pfl_nreconfigure.pfl_nreconfigure
		//.pfl_nreconfigure         (load),                       // pfl_nreconfigure.pfl_nreconfigure
	   .pfl_nreconfigure         (start_cfg ),                     // pfl_nreconfigure.pfl_nreconfigure
		//.pfl_reset_watchdog       (load),                             // pfl_reset_watchdog.pfl_reset_watchdog
		//.pfl_watchdog_error       (reconf),                       // pfl_watchdog_error.pfl_watchdog_error
		.flash_nreset             (flash_resetn) 
	);
	
	/*
		flash_control_MM cpld_flash_cont (
//--------------- flash --------------------
  .fc_flash_contr      ( pfl_flash_access   ),
  .clk                 ( clkin_50      ),
//---------------------------------------------  
  .fc_flash_advn       ( flash_advn    ),
  .fc_flash_cen        ( flash_cen     ),
  // .fc_flash_clk        ( flash_clk     ),
  .fc_flash_oen        ( flash_oen     ),
 // .fc_flash_rdybsyn    ( flash_rdybsyn ),
 // .fc_flash_resetn     ( flash_resetn  ),
  .fc_flash_wen        ( flash_wen     ),
  .fc_fsm_d            ( fsm_d         ),
  .fc_fsm_a            ( fsm_a         ),
  
//--------------- fifo  --------------------
 //  .fc_fifo_in          ( fifo_in       ),  
 // .fc_wrclk            ( tck           ),     
 // .fc_wrreq            ( wr_fifo       ),     
 // .fc_wrfull           ( full          ), 
 // .fc_rdclk            ( clkin_50      ),  
 //------------   leds  --------------------
  //.fc_user_led         ( user_led     ), // user_led 
 //------------ reconf  --------------------
  .wr_done             ( oper_compl    ) 
  );
  
	*/
	endmodule