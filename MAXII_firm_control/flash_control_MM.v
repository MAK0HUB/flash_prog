`include "DEF_PARAM.v"
//`define 	ADDR_TABL  25'h0008000;

module flash_control_MM (

//------------   flash  -------------------
input  wire          fc_rd_req        ,
input  wire          clk              ,
//------------------------------------------
output wire	         fc_flash_cen     ,
output wire	         fc_flash_oen     ,
output wire	         fc_flash_wen     ,
inout  wire  [15:0]	fc_fsm_d         ,
output wire	 [25:1]  fc_fsm_a         ,
//---------- reconf  --------------------
output wire	         rd_done          ,  
output wire	 [1:0]   pfl_str            
);

assign  rd_done     = rd_done_reg;
reg     rd_done_reg = 1'b0;

assign  pfl_str     = pfl_str_reg;
reg    [1:0] pfl_str_reg;

//-----------------------------------------------

assign   fc_flash_cen    = sig_ce  ; 
assign   fc_flash_oen    = sig_oe  ;
assign   fc_flash_wen    = sig_we  ;
assign   fc_fsm_d        = data    ;
assign   fc_fsm_a        = addr    ;

reg [15:0] data      = 16'hZZZZ    ;
reg [25:1] addr      = 25'hZZZZZZZ ;  
reg [15:0] firm_N    = 16'hzzzz    ;
reg  sig_ce  = 1'bz; 
reg  sig_oe  = 1'bz; 
reg  sig_we  = 1'bz; 

reg [2:0  ]   cnt    = 3'b000      ;				
reg [4:0  ]   state  = IDLE        ;
// ------------------------------------------------
parameter [4:0] IDLE     = 5'b00001,
					 READ_TAB = 5'b00111;
//------------------------------------------------

always @(posedge clk)
begin	
  
//if (!sys_resetn) state <= IDLE; && (kol <  7'b0000111)

case (state)  
		 IDLE   : begin		
							addr         <= 25'hZZZZZZZ ;
							firm_N       <= 16'hZZZZ    ; 
                     sig_ce       <= 1'bz        ; 
                     sig_oe       <= 1'bz        ; 
                     sig_we       <= 1'bz        ; 
							data         <= 16'hZZZZ    ; 
							cnt          <= 3'b000      ;
							if (!fc_rd_req) state <=  READ_TAB;
						   rd_done_reg <= 1'b0;						
				    end	// IDLE
	
		READ_TAB: begin
			           case (cnt)
					     //----------------------------- rd  -----------------------------//
			           3'b000: begin addr    <= `ADDR_TABL  ; end		
			           3'b001: begin sig_ce  <= 1'b0        ; end 
			           3'b010: begin sig_oe  <= 1'b0        ; end 
					     3'b110: begin firm_N  <= fc_fsm_d    ; end	
			           3'b111: begin sig_ce  <= 1'b1        ;
						                sig_oe  <= 1'b1        ;
											 state   <= IDLE        ;
											  
											  if      (firm_N [15:10] == 6'b100101) 
											     begin
															pfl_str_reg <= 2'b01;
															rd_done_reg <= 1'b1;	
												  end
											  else if (firm_N [15:10] == 6'b101100)
											     begin
														   pfl_str_reg <= 2'b11;
														   rd_done_reg <= 1'b1;	
												  end
											  else if (firm_N [15:10] == 6'b110110)
											     begin
														   pfl_str_reg <= 2'b10;
														   rd_done_reg <= 1'b1;	
											     end
											  else if (firm_N [15:10] == 6'b111111)
											     begin
														   pfl_str_reg <= 2'b00;
														   rd_done_reg <= 1'b1;	
											     end
							       end  // 3'b111
						  endcase
            cnt <= cnt + 1'b1;						  
     			end //READ_N
	
    endcase 	 
 end
endmodule