module flash_control_MM (

//------------   flash  -------------------
input  wire          fc_flash_contr   ,
input  wire          fc_req           ,
input  wire          clk              ,
//------------------------------------------
output wire          fc_flash_advn    ,
output wire	         fc_flash_cen     ,
output wire	         fc_flash_clk     ,
output wire	         fc_flash_oen     ,
//input  wire	         fc_flash_rdybsyn ,
//output wire	         fc_flash_resetn  ,
output wire	         fc_flash_wen     ,
inout  wire  [15:0]	fc_fsm_d         ,
output wire	 [25:1]  fc_fsm_a         ,
//------------ fifo  ---------------------
//input  wire  [63:0]  fc_fifo_in       ,
//input  wire          fc_wrclk         ,
//input  wire          fc_wrreq         ,
//output wire          fc_wrfull        ,
//input  wire          fc_rdclk         ,
//-----------  leds  ---------------------
output wire	 [7:0]   fc_user_led      ,  
//---------- reconf  --------------------
output wire	         wr_done          ,  
output wire	 [1:0]   pfl_str            

);

	
assign fc_user_led[7:0] = firm_N  [15:8];


//assign fc_user_led[7:0] = {state[4:0],3'b111};


//assign fc_user_led[7:0] = {5'b10101,3'b111};
//assign fc_user_led[7:0] = tabl;
//assign fc_user_led[7:0] = mem[1] [7:0];
//assign fc_user_led[7:0] = {cnt,5'b11111};
//assign fc_user_led[7:0] = fc_fifo_in  [55:48];
//assign fc_user_led[7:0] = fifo_out  [7:0];
//assign fc_user_led[7:0] = {!rdreq,7'bzzzzzzz};
//assign fc_user_led[7:0] = {7'bzzzzzzz,sys_resetn};
//assign fc_user_led[7:0] = {7'bzzzzzzz,start_cfg};
//assign fc_user_led[7:0] = {7'bzzzzzzz,empty_flag };

//assign	fc_flash_clk     = 1'b0    ;
//assign   fc_flash_resetn  = 1'b1    ;
//assign   reconf_fpga      = reconf  ;


// ---------------------  flash initial  ------------------------------
//reg   flash_flag = 1'b0;
//assign   flash_flag = fc_flash_contr ;

/*
assign   fc_flash_cen    = (fc_flash_contr  )? 1'bz :sig_ce   ; 
assign   fc_flash_oen    = (fc_flash_contr )? 1'bz :sig_oe    ;
assign   fc_flash_wen    = (fc_flash_contr  )? 1'bz :sig_we   ;
//assign   fc_flash_advn   = (fc_flash_contr )? 1'b1 :sig_adv   ;
//assign   fc_fsm_d        = (fc_flash_contr  )? 16'hzzzz :data     ;
assign   fc_fsm_a        = (fc_flash_contr )? 25'hzzzzzzz :addr   ;
*/


/*
assign   fc_flash_cen    = (fc_flash_contr )? 1'bz :sig_ce  ; 
assign   fc_flash_oen    = (fc_flash_contr )? 1'bz :sig_oe  ;
assign   fc_flash_wen    = (fc_flash_contr )? 1'bz :sig_we  ;
//assign   fc_flash_advn   = (fc_flash_contr )? 1'bz :sig_adv ;
assign   fc_fsm_d        = (fc_flash_contr )? 16'hzzzz    :data ;
assign   fc_fsm_a        = (fc_flash_contr )? 25'hzzzzzzz :addr ;
*/





  
assign  wr_done = wr_done_reg;
reg  wr_done_reg = 1'b0;

wire flash_flag;
assign flash_flag = flash_flag_reg;
reg  flash_flag_reg  = 1'b1;

assign  pfl_str = pfl_str_reg;
reg [1:0] pfl_str_reg;

assign	fc_flash_clk = 1'b0;
assign   fc_flash_advn = sig_adv;



//-----------------------------------------------

assign   fc_flash_cen    = sig_ce  ; 
assign   fc_flash_oen    = sig_oe  ;
assign   fc_flash_wen    = sig_we  ;
assign   fc_fsm_d        = data ;
assign   fc_fsm_a        = addr ;

reg [15:0] data        = 16'hZZZZ    ;
reg [15:0] read_data   = 16'hZZZZ    ;
reg [15:0] err_data    = 16'hZZZZ    ;
reg [25:1] addr        = 25'hZZZZZZZ ;  

reg  sig_ce    = 1'bz; 
reg  sig_oe    = 1'bz; 
reg  sig_we    = 1'bz; 
reg  sig_adv   = 1'b1; 

// --------------------------------------------------------------------
parameter [4:0] IDLE         = 5'b00001,
                UNLOCK       = 5'b00010, 
				    UNLOCK_2     = 5'b00011,
		          ERASE        = 5'b00100,
					 ERASE_2      = 5'b00101,
					 READ_SR_ER   = 5'b00110,
					 READ_TAB     = 5'b00111,
					 CLEAR_SR_ER  = 5'b01000, 
	             WRITE		  = 5'b01001,	 
					 WRITE_2		  = 5'b01010,
					 READ_SR_WR   = 5'b01011,
				READ_SR_WR_TAB   = 5'b01100,  
					 END  		  = 5'b01101,    
				READ_SR_ER_TAB   = 5'b01110,
				CLEAR_SR_ER_TAB  = 5'b01111,	 
					 WRITE_SR_WR  = 5'b10000,
					 UNLOCK_TABLE = 5'b10001,
					 CLEAR_SR_WR  = 5'b10010,
					 WRITE_ER     = 5'b10011, 
					 WRITE_ER_2   = 5'b10100,
					 UNLOCK_TAB   = 5'b10101, 
				    UNLOCK_2_TAB = 5'b10110,
					 ERASE_TAB    = 5'b10111,
					 ERASE_2_TAB  = 5'b11000,
					 WRITE_TAB	  = 5'b11001,
					 WRITE_2_TAB  = 5'b11010,
				CLEAR_SR_WR_TAB  = 5'b11011;
				
reg [2:0  ]   cnt      = 3'b000       ;				
reg [4:0  ]   state    = IDLE         ;
reg [23:0 ]   kol      = 24'h000000   ;	
reg [25:1 ]   adrcnt                  ;  //= 25'h0010000 
reg [1:0  ]   pos      = 2'b00        ;
reg           sig      = 1'b0         ;
reg           nres     = 1'b1         ;
reg [15:0 ]   dat_cnt  = 16'h0000     ;	
reg [4:0  ]   kol_2    = 5'b00000     ;
reg           flag, flag_unl          ;
reg [7:0  ]   mem [0:31]              ; 
reg           rd_flg  = 1'b0          ;
reg           cnt_flg = 1'b0          ;

reg [15:0 ]   firm_N = 16'hzzzz      ;
reg [5:0 ]    tabl                    ;
reg [15:0 ]   wr_tabl                 ;
//assign  tabl =  firm_N [15:9 ]      ;

//--------------------- fifo -----------------------------
wire [15:0]   fifo_out ;
wire  empty            ;  
reg   rdreq      = 1'b0; 
reg   empty_flag = 1'b1;

//-------------------------------------------------------
reg   start_flag = 1'b1;
reg   reconf     = 1'b1;
reg   wr_1       = 1'b1;


//reg  [63:0]   fifo_in      ; 
//wire  empty, full          ;    
//reg   wr_fifo              ; 
//reg   full_flag = 1'b1     ;
//reg   pfl_flag = 1'b0      ;
//reg  [15:0] pfl = 16'hzzzz ;
// -------------------------------------------------------

//------------------- flash_controller  ------------------
parameter	ADDR_TABL        =	25'h0008000;
parameter	ADDR_FIRM_STOK   =	25'h0010000;
//parameter	ADDR_FIRM_1      =	25'h0270000;
//parameter	ADDR_FIRM_2      =	25'h04D0000;
//--------------------------------------------------------


/*
always @(posedge fc_rdclk)
if ((empty) && (!start_flag)) empty_flag <= 1'b0;
*/


always @(posedge clk)
begin	
  
//if (!sys_resetn) state <= IDLE; && (kol <  7'b0000111)

case (state)  
		 IDLE   : begin		
							//flag         <= 0         ;
							//flag_unl     <= 0         ;
						   //	read_data    <= 16'hZZZZ ; 
						
			            data         <= 16'hZZZZ    ;
							addr         <= 25'hZZZZZZZ ;
							firm_N       <= 16'hZZZZ    ; 
                     sig_ce       <= 1'bz        ; 
                     sig_oe       <= 1'bz        ; 
                     sig_we       <= 1'bz        ; 
                     sig_adv      <= 1'bz        ; 
							
							cnt          <= 3'b000      ;
							kol_2        <= 5'b00000    ;
						   kol          <= 24'h000000  ;
							
							if (!fc_req) state <=  READ_TAB;
						   wr_done_reg <= 1'b0;	
							//state <=  READ_TAB;
							
			   // wr_tabl <= {6'b100000,10'b0000000000} ;
				      // if (!fc_flash_contr) state <=  READ_TAB        ; //UNLOCK_TAB 
				/*  
					   if (!start_flag)
					      begin
							kol_2  <= kol_2 +1'b1   ;
							reconf <= 1'b0          ;
							end
						if (kol_2 == 5'b11111)
						 begin
						   start_flag  <= 1'b1     ;
							kol_2       <= 5'b00000 ;
							reconf      <= 1'b1     ;
						 end
				*/	
				    end	// IDLE

		READ_TAB: begin
		        //  start_flag   <= 1'b0;
					// flash_flag   <= 1'b1; 
			           case (cnt)
					     //----------------------------- rd  -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL   ; sig_adv    <= 1'b1   ;  end		
			           3'b001: begin  sig_adv   <= 1'b0        ; sig_ce     <= 1'b0   ;  end 
			           3'b010: begin  sig_adv   <= 1'b1        ; sig_oe     <= 1'b0   ;  end	//dat_oe <= 1'b1;  dat_oe <= 1'b0; 
					     3'b110: begin  firm_N    <= fc_fsm_d    ;                         end	// tabl <= firm_N [15:10];   fc_fsm_d  fc_fsm_d
			           3'b111: begin  sig_ce    <= 1'b1        ;
						                 sig_oe    <= 1'b1        ;
											  state     <= IDLE ;
											  
											  if ((firm_N [15:10] == 6'b100010) || (firm_N [15:10] == 6'b101101))
											     begin
											           // wr_tabl <= {6'b100010,10'b0000000000};
															pfl_str_reg <= 2'b01;
															wr_done_reg <= 1'b1;	
												  end
											  else if (firm_N [15:10] == 6'b101010)
											     begin
												        // wr_tabl <= {6'b101010,10'b0000000000};
														   pfl_str_reg <= 2'b10;
														   wr_done_reg <= 1'b1;	
											     end
											else if (firm_N [15:10] == 6'b1111111)
											     begin
												        // wr_tabl <= {6'b101010,10'b0000000000};
														   pfl_str_reg <= 2'b01;
														   wr_done_reg <= 1'b1;	
											     end
												  /*
											 else if (firm_N [15:10] == 6'b101101)
											     begin
												        // wr_tabl <= {6'b101010,10'b0000000000};
														   pfl_str_reg <= 2'b01;
														   wr_done_reg <= 1'b1;	
											     end
											  */
							             // if (firm_N [15:10]  == 6'b110000) 
											       // begin
															// adrcnt  <= ADDR_FIRM_1;
															
													//  end
													  
											/*		  
										    else if (firm_N [15:10] == 6'b110000)  
											        begin
											             adrcnt <= ADDR_FIRM_2 ;
															 wr_tabl <= {6'b110001,10'b0000000000};
												     end
											 else if (firm_N [15:10] == 6'b101010) // 6'b101000 
											        begin
											             adrcnt <= ADDR_FIRM_STOK ;
															 wr_tabl <= {6'b101010,10'b0000000000};
													  end
											*/
										
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
			           3'b001: begin  sig_adv   <= 1'b0  ;     sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;     sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzzD0   ;                             end	
						  3'b111: begin  sig_ce    <= 1'b1  ;     sig_we    <= 1'b1 ; state <= ERASE_TAB;    end 	  
						endcase	
            cnt <= cnt + 1'b1;							
     			end //UNLOCK_2_TAB
				
		ERASE_TAB : begin
		            case (cnt)
					     //----------------------------- wr 20 h -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL;  sig_adv    <= 1'b1;  end		
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
			           3'b000: begin  addr      <= ADDR_TABL;  sig_adv <= 1'b1;  end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce  <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we  <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzzD0   ;                       end	
                    3'b111: begin  sig_ce <= 1'b1     ;  sig_we    <= 1'b1 ; 
						 // state <= READ_SR_ER_TAB ;
						 wr_done_reg <=1'b1;
						  data <= 16'hzzzz;   end    //dat_oe <= 1'b0;      				  
						endcase
                cnt <= cnt + 1'b1;							
     			    end //ERASE_2_TAB
					 	  
	   READ_SR_ER_TAB :  begin
		              case (cnt)
						  3'b000: begin  addr      <= ADDR_TABL;    sig_adv    <= 1'b1  ;    end		
			           3'b001: begin  sig_adv   <= 1'b0     ;    sig_ce     <= 1'b0  ;    end 
			           3'b010: begin  sig_adv   <= 1'b1     ;    sig_oe     <= 1'b0  ;    end	//dat_oe <= 1'b1;  dat_oe <= 1'b0; 
					     3'b110: begin  read_data <= fc_fsm_d ;                             end	
			           3'b111: begin  
					                sig_ce    <= 1'b1      ; 
					                sig_oe    <= 1'b1      ; 
										 if (read_data [7] == 1'b1)
										    begin
											      if ((read_data [5] == 1'b1) || (read_data [4] == 1'b1)) state <= CLEAR_SR_ER_TAB ; 
													else state <=  WRITE_TAB;		//WRITE_TAB	
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
					     3'b011: begin  data <= 16'hzz50   ;                            end	  
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
						  3'b011: begin  data <= 16'hzz40   ;                      end	
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
										     state    <=READ_SR_WR_TAB ;
											  data     <= 16'hzzzz      ;
									 end // 3'b111 
							endcase
                cnt <= cnt + 1'b1;	
					 end //WRITE_2_TAB 
	   
	  READ_SR_WR_TAB : begin
	               case (cnt)
						  3'b000: begin  addr      <= ADDR_TABL;    sig_adv    <= 1'b1  ;    end		
			           3'b001: begin  sig_adv   <= 1'b0  ;       sig_ce     <= 1'b0  ;    end 
			           3'b010: begin  sig_adv   <= 1'b1  ;       sig_oe     <= 1'b0  ;    end	 
					     3'b110: begin  read_data <= fc_fsm_d ;                             end	
			           3'b111: begin  
					                sig_ce    <= 1'b1      ; 
					                sig_oe    <= 1'b1      ; 
										 if (read_data [7] == 1'b1)
										    begin
											      if ((read_data [5] == 1'b1) || (read_data [4] == 1'b1)) state <= CLEAR_SR_WR_TAB ; 
												   else 
													   begin
												   	  //state  <= END;
														  wr_done_reg <=1'b1;
														  wr_1   <=1'b0; 
												      end		
									       end
								    end  // 3'b111	
				      endcase
                  cnt <= cnt + 1'b1;	
	               end //READ_SR_WR_TAB
	
	  CLEAR_SR_WR_TAB : begin
			          case (cnt)
					     //----------------------------- wr 50 h   -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL; sig_adv    <= 1'b1;   end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b110: begin  data      <= 16'hzz50 ;                       end	  
					     3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= WRITE_TAB; end         				  
						endcase	
                  cnt <= cnt + 1'b1;							
     			      end //CLEAR_SR_WR_TAB		
	    END : begin 
		           state   <= IDLE         ;
					  
					  //flash_flag_reg   <= 1'b1   ;	
					  
					  data    <= 16'hZZZZ    ;
                 addr    <= 25'hZZZZZZZ ;  //E60000
                 sig_ce  <= 1'bZ; 
                 sig_oe  <= 1'bZ; 
                 sig_we  <= 1'bZ; 
                 sig_adv <= 1'bZ; 
					  
				 end
	
    endcase 	 
 end
endmodule