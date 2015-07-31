//--------------------------------------------------------------------------//
// Title:       c4gx_f896_host.v                                            //
// Rev:         Rev 1                                                     //
// Created:     November 29, 2010 		                                     //
// Author:		 Altera High Speed Design Group - San Diego            		 //
//--------------------------------------------------------------------------//
// Description: Golden Top design contains all pins and I/O standards for   //
//              the Cyclone IV GX FPGA Development Board.                   //
//--------------------------------------------------------------------------//
// Revision History:                                                        //
// Rev 1:                                              //
//----------------------------------------------------------------------------
//------ 1 ------- 2 ------- 3 ------- 4 ------- 5 ------- 6 ------- 7 ------7
//------ 0 ------- 0 ------- 0 ------- 0 ------- 0 ------- 0 ------- 0 ------8
//----------------------------------------------------------------------------
//Copyright � 2010 Altera Corporation. All rights reserved.  Altera products  
//are protected under numerous U.S. and foreign patents, maskwork rights,     
//copyrights and other intellectual property laws.                            
//                                                                            
//Your use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.                           
//                                                                            
//This reference design file, and your use thereof, is subject to and         
//governed by the terms and conditions of the applicable Altera Reference     
//Design License Agreement.  By using this reference design file, you         
//indicate your acceptance of such terms and conditions between you and       
//Altera Corporation.  In the event that you do not agree with such terms and 
//conditions, you may not use the reference design file. Please promptly      
//destroy any copies you have made.                                           
//                                                                            
//This reference design file being provided on an "as-is" basis and as an     
//accommodation and therefore all warranties, representations or guarantees   
//of any kind (whether express, implied or statutory) including, without      
//limitation, warranties of merchantability, non-infringement, or fitness for 
//a particular purpose, are specifically disclaimed.  By making this          
//reference design file available, Altera expressly does not recommend,       
//suggest or require that this reference design file be used in combination   
//with any other product not provided by Altera.                              
//  
                                                                        
//`define	hsma_xcvrs
`define	hsma_parallel_x41
//`define	hsmb_xcvrs
`define	hsmb_parallel_x41
//`define	pcie_xcvrs
//`define	hsma_lvds


`ifdef	hsma_xcvrs          
	`define	use_clkin_100m_p_1  
	`define	hsma_xcvrs_refclk_p 	clkin_100m_p_1
`endif   

`ifdef	hsmb_xcvrs          
	`define	use_clkin_100m_p_1  
	`define	hsmb_xcvrs_refclk_p	clkin_100m_p_1
`endif   
 
`ifdef	pcie_xcvrs     
	`define	use_pcie_refclk_p
	`define	pcie_xcvrs_refclk_p	pcie_refclk_p
`endif

`ifdef	hsma_lvds 
	//`define	use_clkin_125m_p  
	//`define	hsma_lvds_refclk_p	clkin_125m_p
	`define	use_clkin_100m_p_1  
	`define	hsma_lvds_refclk_p 	clkin_100m_p_1	
`else
	// Allow 125 MHz clock to exist in design
	`define	use_clkin_125m_p  
`endif 

module c4gx_f896_host (
//--------------Clocks------------------
	input          clkin_50,             //2.5V    //Bank 8B  
`ifdef	use_clkin_100m_p_0
	input    clkin_100m_p_0,         //LVDS    // 
`endif 
`ifdef	use_clkin_100m_p_1
	input    clkin_100m_p_1,         //LVDS    // 
`endif 

`ifdef	use_clkin_125m_p
	input          clkin_125m_p,         //LVDS    // 
`endif
	input          clkin_sma,            //1.8V    //
	output         clkout_sma,           //1.8V    //

//--------------User-IO-----------------
	input          sys_resetn,           //2.5V    //TR=0, DEV_CLRn
	input          cpu_resetn,           //1.8V    //TR=0
	input  [7:0]   user_dipsw,           //1.8V    //TR=0
	output [7:0]   user_led,             //1.8V
	input  [3:0]   user_pb,              //1.8V    //TR=0

//-------------DDR2-Port-A--------------//1.8V    //Banks 3&4
	output [12:0]  ddr2a_a,              //SSTL18  
	output [1:0]   ddr2a_ba,             //SSTL18
	inout  [31:0]  ddr2a_dq,             //SSTL18
	inout  [3:0]   ddr2a_dqs,            //SSTL18
	output [3:0]   ddr2a_dm,             //SSTL18
	output         ddr2a_wen,            //SSTL18
	output         ddr2a_rasn,           //SSTL18
	output         ddr2a_casn,           //SSTL18
	inout          ddr2a_clk_p,          //SSTL18
	inout          ddr2a_clk_n,          //SSTL18
	output         ddr2a_cke,            //SSTL18
	output         ddr2a_csn,            //SSTL18
	output         ddr2a_odt,            //SSTL18

//-------------DDR2-Port-A--------------//1.8V    //Banks 7&8
	output [12:0]  ddr2b_a,              //SSTL18  
	output [1:0]   ddr2b_ba,             //SSTL18  
	inout  [31:0]  ddr2b_dq,             //SSTL18  
	inout  [3:0]   ddr2b_dqs,            //SSTL18  
	output [3:0]   ddr2b_dm,             //SSTL18  
	output         ddr2b_wen,            //SSTL18  
	output         ddr2b_rasn,           //SSTL18  
	output         ddr2b_casn,           //SSTL18  
	inout          ddr2b_clk_p,          //SSTL18  
	inout          ddr2b_clk_n,          //SSTL18  
	output         ddr2b_cke,            //SSTL18  
	output         ddr2b_csn,            //SSTL18  
	output         ddr2b_odt,            //SSTL18  

//------------SSRAM-Control-------------//1.8V    //Banks 7&8
	output			ssram_clk,            //1.8V
	output			ssram_e1n,            //1.8V    //Chip enable
	output			ssram_ban,            //1.8V    //Byte Enable
	output			ssram_bbn,            //1.8V    //Byte Enable
	output			ssram_bwn,            //1.8V
//	output			ssram_gwn,            //1.8V
//	output			ssram_adscn,          //1.8V
//	output			ssram_adspn,          //1.8V
//	output			ssram_advn,           //1.8V    //Addr valid
	output			ssram_gn,             //1.8V    //Output enable

//------------Flash-Control-------------//1.8V    //Banks 7&8
	output			flash_advn,           //1.8V                   // l_n           
	output			flash_cen,            //1.8V                   // e_n
	output			flash_clk,            //1.8V                   // k 
	output			flash_oen,            //1.8V                   // g_n
	input          flash_rdybsyn,        //1.8V                   // wp_n
	output			flash_resetn,         //1.8V    //TR=0         // rp_n
	output			flash_wen,            //1.8V                   // w_n

//----------------FSM-Bus---------------//1.8V    
   output [25:1]  fsm_a,                //
   inout  [15:0]  fsm_d,                //

//---------------Ethernet--------------//        //Bank 8
	output [3:0]   enet_tx_d,           //1.8V    //Trans to 2.5V
   output         enet_gtx_clk,        //1.8V    //Trans to 2.5V
	output         enet_tx_en,          //1.8V    //Trans to 2.5V
	input  [3:0]   enet_rx_d,           //1.8V    //Trans to 2.5V ???
	input          enet_rx_clk,         //1.8V    //Trans to 2.5V ???
	input          enet_rx_dv,          //1.8V    //Trans to 2.5V ???
   input          enet_intn,           //1.8V    //Trans to 2.5V       //TR=0
   output         enet_mdc,            //1.8V    //Trans to 2.5V       //TR=0
   inout          enet_mdio,           //1.8V    //Trans to 2.5V       //TR=0
   output         enet_resetn,         //1.8V    //Trans to 2.5V       //TR=0

//-------------PCI Express--------------//        //Bank QL0 w/HIP    
`ifdef	use_pcie_refclk_p		
	input          pcie_refclk_p,      //HCSL
`endif
`ifdef	pcie_xcvrs
	output [3:0]   pcie_tx_p,            //2.5V PCML
	input  [3:0]   pcie_rx_p,            //2.5V PCML
`endif
	input          pcie_smbclk,          //1.8V      //TR=0
   inout          pcie_smbdat,          //1.8V      //TR=0
   input          pcie_perstn,          //1.8V      //TR=0
   output         pcie_led_x1,          //1.8V      //TR=0
   output         pcie_led_x4,          //1.8V      //TR=0

//-------------HSMC-Port-A--------------//2.5V      //Banks 
`ifdef	hsma_xcvrs
   output   [3:0]    hsma_tx_p,         //2.5V PCML
   input    [3:0]    hsma_rx_p,         //2.5V PCML
`endif
`ifdef	hsma_parallel_x41  
	input	hsma_in_d_1	,
	input	hsma_in_d_3	,
	input	hsma_in_d_5     ,
	input	hsma_in_d_7     ,
	input	hsma_in_d_9     ,
	input	hsma_in_d_11    ,
	input	hsma_in_d_13    ,
	input	hsma_in_d_15    ,
	input	hsma_in_d_17    ,
	input	hsma_in_d_19    ,
	input	hsma_in_d_21    ,
	input	hsma_in_d_23    ,
	input	hsma_in_d_25    ,
	input	hsma_in_d_27    ,
	input	hsma_in_d_29    ,
	input	hsma_in_d_31    ,
	input	hsma_in_d_33    ,
	input	hsma_in_d_35    ,
	input	hsma_in_d_37    ,
	input	hsma_in_d_39    ,
	input	hsma_in_d_41    ,
	input	hsma_in_d_43    ,
	input	hsma_in_d_45    ,
	input	hsma_in_d_47    ,
	input	hsma_in_d_49    ,
	input	hsma_in_d_51    ,
	input	hsma_in_d_53    ,
	input	hsma_in_d_55    ,
	input	hsma_in_d_57    ,
	input	hsma_in_d_59    ,
	input	hsma_in_d_61    ,
	input	hsma_in_d_63    ,
	input	hsma_in_d_65    ,
	input	hsma_in_d_67    ,
	input	hsma_in_d_69    ,
	input	hsma_in_d_71    ,
	input	hsma_in_d_73    ,
	input	hsma_in_d_75    ,
	input	hsma_in_d_77    ,
	input	hsma_in_d_79    ,
	output	hsma_out_d_0    ,
	output	hsma_out_d_2    ,
	output	hsma_out_d_4    ,
	output	hsma_out_d_6    ,
	output	hsma_out_d_8    ,
	output	hsma_out_d_10   ,
	output	hsma_out_d_12   ,
	output	hsma_out_d_14   ,
	output	hsma_out_d_16   ,
	output	hsma_out_d_18   ,
	output	hsma_out_d_20   ,
	output	hsma_out_d_22   ,
	output	hsma_out_d_24   ,
	output	hsma_out_d_26   ,
	output	hsma_out_d_28   ,
	output	hsma_out_d_30   ,
	output	hsma_out_d_32   ,
	output	hsma_out_d_34   ,
	output	hsma_out_d_36   ,
	output	hsma_out_d_38   ,
	output	hsma_out_d_40   ,
	output	hsma_out_d_42   ,
	output	hsma_out_d_44   ,
	output	hsma_out_d_46   ,
	output	hsma_out_d_48   ,
	output	hsma_out_d_50   ,
	output	hsma_out_d_52   ,
	output	hsma_out_d_54   ,
	output	hsma_out_d_56   ,
	output	hsma_out_d_58   ,
	output	hsma_out_d_60   ,
	output	hsma_out_d_62   ,
	output	hsma_out_d_64   ,
	output	hsma_out_d_66   ,
	output	hsma_out_d_68   ,
	output	hsma_out_d_70   ,
	output	hsma_out_d_72   ,
	output	hsma_out_d_74   ,
	output	hsma_out_d_76   ,
	output	hsma_out_d_78   ,
	input   hsma_clk_in0,      //1.8V      //input only
	output	hsma_clk_out0,     //2.5V      //output only
//	inout					hsma_sda,          //1.8V      //TR=0
	input					hsma_sda,          //Make input for loopback test
	output				hsma_scl,          //2.5V      //TR=0	
`endif
`ifdef	hsma_lvds
	output	[16:0]	hsma_tx_d_p,       //LVDS      //
	input		[16:0]	hsma_rx_d_p,       //LVDS      //
	input		[2:1]		hsma_clk_in_p,     //LVDS
	output	[2:1]		hsma_clk_out_p,    //LVDS
`endif
`ifdef	hsma_parallel_x3
	//inout		[3:0]		hsma_d,            //2.5V      //Bank
	input	hsma_in_d_1	,
	input	hsma_in_d_3	,
	input	hsma_out_d_0	,
	input	hsma_out_d_2	,
   input             hsma_clk_in0,      //1.8V      //input only
	output				hsma_clk_out0,     //2.5V      //output only
//	inout					hsma_sda,          //1.8V      //TR=0
	input					hsma_sda,          //Make input for loopback test
	output				hsma_scl,          //2.5V      //TR=0	
`endif
	output				hsma_tx_led,       //1.8V
	output				hsma_rx_led,       //1.8V
	input					hsma_prsntn,       //1.8V      //TR=0
	
//-------------HSMC-Port-B--------------//2.5+1.8V //Banks 
`ifdef	hsmb_xcvrs
   output [3:0]      hsmb_tx_p,         //2.5V PCML //Requires resistor mux change 
   input  [3:0]      hsmb_rx_p,         //2.5V PCML //Requires resistor mux change
`endif
`ifdef	hsmb_parallel_x41
	input	hsmb_in_d_1	,
	input	hsmb_in_d_3	,
	input	hsmb_in_d_5     ,
	input	hsmb_in_d_7     ,
	input	hsmb_in_d_9     ,
	input	hsmb_in_d_11    ,
	input	hsmb_in_d_13    ,
	input	hsmb_in_d_15    ,
	input	hsmb_in_d_17    ,
	input	hsmb_in_d_19    ,
	input	hsmb_in_d_21    ,
	input	hsmb_in_d_23    ,
	input	hsmb_in_d_25    ,
	input	hsmb_in_d_27    ,
	input	hsmb_in_d_29    ,
	input	hsmb_in_d_31    ,
	input	hsmb_in_d_33    ,
	input	hsmb_in_d_35    ,
	input	hsmb_in_d_37    ,
	input	hsmb_in_d_39    ,
	input	hsmb_in_d_41    ,
	input	hsmb_in_d_43    ,
	input	hsmb_in_d_45    ,
	input	hsmb_in_d_47    ,
	input	hsmb_in_d_49    ,
	input	hsmb_in_d_51    ,
	input	hsmb_in_d_53    ,
	input	hsmb_in_d_55    ,
	input	hsmb_in_d_57    ,
	input	hsmb_in_d_59    ,
	input	hsmb_in_d_61    ,
	input	hsmb_in_d_63    ,
	input	hsmb_in_d_65    ,
	input	hsmb_in_d_67    ,
	input	hsmb_in_d_69    ,
	input	hsmb_in_d_71    ,
	input	hsmb_in_d_73    ,
	input	hsmb_in_d_75    ,
	input	hsmb_in_d_77    ,
	input	hsmb_in_d_79    ,
	output	hsmb_out_d_0    ,
	output	hsmb_out_d_2    ,
	output	hsmb_out_d_4    ,
	output	hsmb_out_d_6    ,
	output	hsmb_out_d_8    ,
	output	hsmb_out_d_10   ,
	output	hsmb_out_d_12   ,
	output	hsmb_out_d_14   ,
	output	hsmb_out_d_16   ,
	output	hsmb_out_d_18   ,
	output	hsmb_out_d_20   ,
	output	hsmb_out_d_22   ,
	output	hsmb_out_d_24   ,
	output	hsmb_out_d_26   ,
	output	hsmb_out_d_28   ,
	output	hsmb_out_d_30   ,
	output	hsmb_out_d_32   ,
	output	hsmb_out_d_34   ,
	output	hsmb_out_d_36   ,
	output	hsmb_out_d_38   ,
	output	hsmb_out_d_40   ,
	output	hsmb_out_d_42   ,
	output	hsmb_out_d_44   ,
	output	hsmb_out_d_46   ,
	output	hsmb_out_d_48   ,
	output	hsmb_out_d_50   ,
	output	hsmb_out_d_52   ,
	output	hsmb_out_d_54   ,
	output	hsmb_out_d_56   ,
	output	hsmb_out_d_58   ,
	output	hsmb_out_d_60   ,
	output	hsmb_out_d_62   ,
	output	hsmb_out_d_64   ,
	output	hsmb_out_d_66   ,
	output	hsmb_out_d_68   ,
	output	hsmb_out_d_70   ,
	output	hsmb_out_d_72   ,
	output	hsmb_out_d_74   ,
	output	hsmb_out_d_76   ,
	output	hsmb_out_d_78   ,
	input   hsmb_clk_in0,      //1.8V      //input only
	output	hsmb_clk_out0,     //2.5V      //output only
   //inout             hsmb_sda,          //1.8V     //TR=0
   input             hsmb_sda,          //Make input for loopback test
	output            hsmb_scl,          //1.8V     //TR=0
`endif
// HSMB LVDS unused due to board translators.
// This provides HSMB parallel I/O daughtercard compatibility
`ifdef	hsmb_lvds
 	output [16:0]      hsmb_tx_d_p,      //2.5V     //Bank 5
	output [16:0]      hsmb_tx_d_n,      //2.5V     //
   input  [16:0]      hsmb_rx_d_p,      //2.5V     //Bank 5
	input  [16:0]      hsmb_rx_d_n,      //2.5V     //
   input	 [2:1]       hsmb_clk_in_p,     //2=1.8V/1=2.5V
   input	 [2:1]       hsmb_clk_in_n,     //2=1.8V/1=2.5V
   output [2:1]       hsmb_clk_out_p,    //2=1.8V/1=2.5V
   output [2:1]       hsmb_clk_out_n,    //2=1.8V/1=2.5V
`endif
`ifdef	hsmb_parallel_x3
   // inout  [3:0]      hsmb_d,            //2.5V     //Bank 5
	input	hsmb_in_d_1	,
	input	hsmb_in_d_3	,
	input	hsmb_out_d_0	,
	input	hsmb_out_d_2	,
   input             hsmb_clk_in0,      //1.8V     //input only
   output            hsmb_clk_out0,     //2.5V
   //inout             hsmb_sda,          //1.8V     //TR=0
   input             hsmb_sda,          //Make input for loopback test
	output            hsmb_scl,          //1.8V     //TR=0
`endif
   output            hsmb_tx_led,       //1.8V
   output            hsmb_rx_led,       //1.8V
   input             hsmb_prsntn,       //1.8V     //TR=0
	
//-----------lcd-----------
	output			lcd_csn,
	output			lcd_d_cn,
	inout	[7:0]	   lcd_data, 
	output			lcd_wen,


//-----------max-----------
	output			max_csn,
	output			max_oen,
	output			max_wen,

	//TEMPRESERVE
	input ncso,
	input init_done
	
	
	/*
//-----------rup---------------
	input			rup2, //  Pin AD24      
//	input			rup3, //  Pin AD25
	input			rup4, //  Pin G25
	
//-----------rdn----------------
	input			rdn2, //  -- Pin AE24
//	input			rdn3, //  -- Pin AD26
	input			rdn4, //  -- Pin F25

*/

);   

		  wire	[40:0]	hsma_parallel_x41_rx_p;
        wire	[40:0]	hsma_parallel_x41_tx_p;  
        wire	[40:0]	hsmb_parallel_x41_rx_p;
        wire	[40:0]	hsmb_parallel_x41_tx_p;  
`ifdef	hsma_parallel_x41  
	assign	hsma_parallel_x41_rx_p	=
		{     
			hsma_in_d_1	,
			hsma_in_d_3	,
			hsma_in_d_5     ,
			hsma_in_d_7     ,
			hsma_in_d_9     ,
			hsma_in_d_11    ,
			hsma_in_d_13    ,
			hsma_in_d_15    ,
			hsma_in_d_17    ,
			hsma_in_d_19    ,
			hsma_in_d_21    ,
			hsma_in_d_23    ,
			hsma_in_d_25    ,
			hsma_in_d_27    ,
			hsma_in_d_29    ,
			hsma_in_d_31    ,
			hsma_in_d_33    ,
			hsma_in_d_35    ,
			hsma_in_d_37    ,
			hsma_in_d_39    ,
			hsma_in_d_41    ,
			hsma_in_d_43    ,
			hsma_in_d_45    ,
			hsma_in_d_47    ,
			hsma_in_d_49    ,
			hsma_in_d_51    ,
			hsma_in_d_53    ,
			hsma_in_d_55    ,
			hsma_in_d_57    ,
			hsma_in_d_59    ,
			hsma_in_d_61    ,
			hsma_in_d_63    ,
			hsma_in_d_65    ,
			hsma_in_d_67    ,
			hsma_in_d_69    ,
			hsma_in_d_71    ,
			hsma_in_d_73    ,
			hsma_in_d_75    ,
			hsma_in_d_77    ,
			hsma_in_d_79    ,
			hsma_sda
		};
			
		assign
		{     			
			hsma_out_d_0    ,
			hsma_out_d_2    ,
			hsma_out_d_4    ,
			hsma_out_d_6    ,
			hsma_out_d_8    ,
			hsma_out_d_10   ,
			hsma_out_d_12   ,
			hsma_out_d_14   ,
			hsma_out_d_16   ,
			hsma_out_d_18   ,
			hsma_out_d_20   ,
			hsma_out_d_22   ,
			hsma_out_d_24   ,
			hsma_out_d_26   ,
			hsma_out_d_28   ,
			hsma_out_d_30   ,
			hsma_out_d_32   ,
			hsma_out_d_34   ,
			hsma_out_d_36   ,
			hsma_out_d_38   ,
			hsma_out_d_40   ,
			hsma_out_d_42   ,
			hsma_out_d_44   ,
			hsma_out_d_46   ,
			hsma_out_d_48   ,
			hsma_out_d_50   ,
			hsma_out_d_52   ,
			hsma_out_d_54   ,
			hsma_out_d_56   ,
			hsma_out_d_58   ,
			hsma_out_d_60   ,
			hsma_out_d_62   ,
			hsma_out_d_64   ,
			hsma_out_d_66   ,
			hsma_out_d_68   ,
			hsma_out_d_70   ,
			hsma_out_d_72   ,
			hsma_out_d_74   ,
			hsma_out_d_76   ,
			hsma_out_d_78   ,
			hsma_scl
		}	=	 hsma_parallel_x41_tx_p;  
 
`endif                           

`ifdef	hsmb_parallel_x41  
	assign	hsmb_parallel_x41_rx_p	=
		{     
			hsmb_in_d_1	,
			hsmb_in_d_3	,
			hsmb_in_d_5     ,
			hsmb_in_d_7     ,
			hsmb_in_d_9     ,
			hsmb_in_d_11    ,
			hsmb_in_d_13    ,
			hsmb_in_d_15    ,
			hsmb_in_d_17    ,
			hsmb_in_d_19    ,
			hsmb_in_d_21    ,
			hsmb_in_d_23    ,
			hsmb_in_d_25    ,
			hsmb_in_d_27    ,
			hsmb_in_d_29    ,
			hsmb_in_d_31    ,
			hsmb_in_d_33    ,
			hsmb_in_d_35    ,
			hsmb_in_d_37    ,
			hsmb_in_d_39    ,
			hsmb_in_d_41    ,
			hsmb_in_d_43    ,
			hsmb_in_d_45    ,
			hsmb_in_d_47    ,
			hsmb_in_d_49    ,
			hsmb_in_d_51    ,
			hsmb_in_d_53    ,
			hsmb_in_d_55    ,
			hsmb_in_d_57    ,
			hsmb_in_d_59    ,
			hsmb_in_d_61    ,
			hsmb_in_d_63    ,
			hsmb_in_d_65    ,
			hsmb_in_d_67    ,
			hsmb_in_d_69    ,
			hsmb_in_d_71    ,
			hsmb_in_d_73    ,
			hsmb_in_d_75    ,
			hsmb_in_d_77    ,
			hsmb_in_d_79    ,
			hsmb_sda
		};
			
			
		assign
		{     			
			hsmb_out_d_0    ,
			hsmb_out_d_2    ,
			hsmb_out_d_4    ,
			hsmb_out_d_6    ,
			hsmb_out_d_8    ,
			hsmb_out_d_10   ,
			hsmb_out_d_12   ,
			hsmb_out_d_14   ,
			hsmb_out_d_16   ,
			hsmb_out_d_18   ,
			hsmb_out_d_20   ,
			hsmb_out_d_22   ,
			hsmb_out_d_24   ,
			hsmb_out_d_26   ,
			hsmb_out_d_28   ,
			hsmb_out_d_30   ,
			hsmb_out_d_32   ,
			hsmb_out_d_34   ,
			hsmb_out_d_36   ,
			hsmb_out_d_38   ,
			hsmb_out_d_40   ,
			hsmb_out_d_42   ,
			hsmb_out_d_44   ,
			hsmb_out_d_46   ,
			hsmb_out_d_48   ,
			hsmb_out_d_50   ,
			hsmb_out_d_52   ,
			hsmb_out_d_54   ,
			hsmb_out_d_56   ,
			hsmb_out_d_58   ,
			hsmb_out_d_60   ,
			hsmb_out_d_62   ,
			hsmb_out_d_64   ,
			hsmb_out_d_66   ,
			hsmb_out_d_68   ,
			hsmb_out_d_70   ,
			hsmb_out_d_72   ,
			hsmb_out_d_74   ,
			hsmb_out_d_76   ,
			hsmb_out_d_78   ,
			hsmb_scl
		}	=	 hsmb_parallel_x41_tx_p;  
`endif 

//////////////////////////////////////////////////////////
assign	max_csn       = reg_max_csn   ;                   // reconfig signal
assign   max_oen       = 1'bz    ;
assign	max_wen       = 1'bz    ;
reg      reg_max_csn   = 1'b1;

//--------------------  initial flash  -------------------------
assign	flash_clk     = 1'bZ ;  //
assign	flash_resetn  = 1'bZ ;  //


assign   fsm_d      = (dat_oe )? 16'hzzzz     : data ;
assign   fsm_a      = (dat_oe )? 25'hzzzzzzz  : addr ;

assign   flash_cen  = (dat_oe )? 1'bz    : sig_ce ;
assign   flash_wen  = (dat_oe )? 1'bz    : sig_we ; 
assign   flash_oen  = (dat_oe )? 1'bz    : sig_oe ;
assign   flash_advn = (dat_oe )? 1'bz    : sig_adv;

reg  dat_oe = 1'b1; 

reg [15:0] data        = 16'hZZZZ   ;
reg [15:0] read_data   = 16'hZZZZ   ;
reg [15:0] err_data    = 16'hZZZZ   ;
reg [25:1] addr        = 25'hZZZZZZZ ;  //E60000

reg  sig_ce    = 1'bz; 
reg  sig_oe    = 1'bz; 
reg  sig_we    = 1'bz; 
reg  sig_adv   = 1'bz; 

//--------------------------  fifo   ----------------------------
reg  [63:0]   fifo_in  ; 
wire [15:0]   fifo_out ;
wire  empty, full      ;    
reg   wr_fifo          ; 
reg   rdreq    = 1'b0  ; 

reg   full_flag = 1'b1     ;
reg   pfl_flag = 1'b0     ;
reg  [15:0] pfl = 16'hzzzz;

//-------------------------   jtag    ----------------------------
reg [7:0 ]  led  = 8'hZZ   ;

reg [63:0]  shift_dr_in    ;
reg [7:0 ]  shift_dr_out   ;

wire tck, tdi;
wire cdr, eldr, e2dr, pdr, sdr, udr, uir, cir, tms;
reg  tdo;
wire [2:0] ir_in; //IR command register

//---------------------  User leds winking -----------------------
reg [31:0]cnt_led={16{2'b00}};
assign user_led[7:0] = {state,cnt_led[25],cnt_led[25]};
always@(posedge clkin_125m_p)
cnt_led <= cnt_led + 1'b1;


//------------------------  JTAG data receiver----------------------	
 always @(posedge tck)
   if(sdr && (ir_in == 3'b001) )
   shift_dr_in <= { tdi,shift_dr_in[63:1] };
	

//---------------  write received data  into FIFO  -------------------- 

always @(posedge tck)
begin
   if (!full && (udr && (ir_in == 3'b001) ) )
		   begin
	      fifo_in   <=  {shift_dr_in[7:0],shift_dr_in[15:8],shift_dr_in[23:16],shift_dr_in[31:24],shift_dr_in[39:32],shift_dr_in[47:40],shift_dr_in[55:48],shift_dr_in[63:56]};
		   wr_fifo   <=  1'b1;
	      end
	else  wr_fifo   <=  1'b0;
end

//-------------------------------------------------------------------
//assign  flash_resetn  = sys_resetn;
//assign  user_led[7:0] = read_data [7:0];
//assign user_led[7:0] = {state,3'b111};

//assign user_led[7:0] = mem[1] [7:0];
//assign user_led[7:0] = {cnt,5'b11111};
//assign user_led[7:0] = fifo_out [15:8];
//assign user_led[7:0] = {!rdreq,7'bzzzzzzz};
//assign user_led[7:0] = {7'bzzzzzzz,sys_resetn};
//assign user_led[7:0] = {7'bzzzzzzz,start_cfg};
//assign user_led[7:0] = {7'bzzzzzzz,full_flag};

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
					  
					  F_READ_TAB        = 6'b101110,
                 F_UNLOCK_TAB      = 6'b101111,
                 F_UNLOCK_2_TAB    = 6'b110000,
                 F_ERASE_TAB       = 6'b110001,
                 F_ERASE_2_TAB     = 6'b110010,
                 F_READ_SR_ER_TAB  = 6'b110011,
                 F_CLEAR_SR_ER_TAB = 6'b110100,
                 F_WRITE_TAB       = 6'b110101,
                 F_WRITE_2_TAB     = 6'b110110,
                 F_READ_SR_WR_TAB  = 6'b110111,
                 F_CLEAR_SR_WR_TAB = 6'b111000;
					  
			 
reg [2:0  ]   cnt      = 3'b000       ;
reg [2:0  ]   cnt_pfl  = 3'b000       ;				
reg [5:0  ]   state    = INITE        ;
reg [24:0 ]   kol      = 24'h000000   ;	
reg [25:1 ]   adrcnt                  ;  
reg [1:0  ]   pos      = 2'b00        ;
reg           sig      = 1'b0         ;
reg           nres     = 1'b1         ;
reg [15:0 ]   dat_cnt  = 16'h0000     ;	
reg [3:0  ]   kol_2    = 3'b000       ;
reg           flag, flag_unl          ;
wire[15:0 ]   mem [0:6]               ; 
reg           rd_flg  = 1'b0          ;
reg           cnt_flg = 1'b0          ;
reg [15:0 ]   firm_N = 16'hZZZZ       ;
reg [5:0  ]   tabl                    ;
reg [15:0 ]   wr_tabl                 ;
reg           flag_err                ;

//------------------- flash_controller  ------------------
parameter [25:1]	ADDR_TABL        =	25'h0008000;

parameter [25:1] 	ADDR_FIRM_STOK   =	25'h0010000;
parameter [25:1]	ADDR_FIRM_1      =	25'h0270000;
parameter [25:1]	ADDR_FIRM_2      =	25'h04D0000;
parameter [25:1]  ADDR_PFL         =	25'h000C000;
parameter [25:1]  ADDR_PFL_END     =	25'h000C040;

assign mem [0] = 16'h0020;
assign mem [1] = 16'h04DA;
assign mem [2] = 16'h04E0;
assign mem [3] = 16'h099A;
assign mem [4] = 16'h09A0;
assign mem [5] = 16'h0E5A;
assign mem [6] = 16'hFF03;

//-------------------------  STATE M-  ---------------------------------------

always @(posedge clkin_50)
begin	
  
//if (!sys_resetn) state <= IDLE; && (kol <  7'b0000111)

case (state)  

       INITE : begin
			        
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
							flag_err     <= 1'b0        ;  
							//----------------------------------		
						    state <= FROM_Z_PFL ;	
     			end //UNLOCK_PFL
				
		FROM_Z_PFL : begin
		         dat_oe <= 1'b0;
		         state <= F_READ_TAB; 
		         end
					
		F_READ_TAB: begin
			           case (cnt)
					     //----------------------------- rd  -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL   ; sig_adv    <= 1'b1   ;  end		
			           3'b001: begin  sig_adv   <= 1'b0        ; sig_ce     <= 1'b0   ;  end 
			           3'b010: begin  sig_adv   <= 1'b1        ; sig_oe     <= 1'b0   ;  end	 
					     3'b110: begin  firm_N    <= fsm_d       ;                         end	
                    3'b111: begin  sig_ce    <= 1'b1        ;
						                 sig_oe    <= 1'b1        ;
											  
											      flag_err <= 1'b0 ;  
															 wr_tabl  <= {6'b101100,10'b0000000000};
															 state   <= UNLOCK_PFL;
															 adrcnt <= ADDR_PFL  ;
															 
															 
								/*			  						  
						  
											 if    (firm_N [15:10] == 6'b111111)
											        begin
									                   flag_err <= 1'b0 ;  
															 wr_tabl  <= {6'b101100,10'b0000000000};
															 state   <= UNLOCK_PFL;
															 adrcnt <= ADDR_PFL  ;
													  end 
													  
											 else if   (firm_N [15:10] == 6'b101100)
											        begin
											             flag_err <= 1'b1 ; 
															 wr_tabl <= {6'b111111,10'b0000000000};
															 state     <= F_UNLOCK_TAB  ;
													  end
													  
											 else if   (firm_N [15:10] == 6'b100101)
											        begin
											             flag_err <= 1'b1 ; 
															 wr_tabl <= {6'b110110,10'b0000000000};
															 state     <= F_UNLOCK_TAB  ;
													  end	  
													  
											 else if   (firm_N [15:10] == 6'b110110)
											        begin
											             flag_err <= 1'b1 ; 
															 wr_tabl <= {6'b101100,10'b0000000000};
															 state     <= F_UNLOCK_TAB  ;
													  end
													  
									*/
							       end  // 3'b111
						  endcase
            cnt <= cnt + 1'b1;						  
     			end //READ_N
				
		F_UNLOCK_TAB : begin
			         case (cnt)
					     //----------------------------- wr 60 h -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0     ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1     ;  sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzz60      ;                          end	
			           3'b111: begin  sig_ce    <= 1'b1     ;  sig_we    <= 1'b1 ; state <= F_UNLOCK_2_TAB; end         
						endcase
            cnt <= cnt + 1'b1;							
     			end //UNLOCK_TAB
				
		F_UNLOCK_2_TAB : begin
		            case (cnt)
					     //----------------------------- wr D0 h  -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzzD0   ;                          end	
						  3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= F_ERASE_TAB;      end 	  
						endcase	
            cnt <= cnt + 1'b1;							
     			end //UNLOCK_2_TAB
				
		F_ERASE_TAB : begin
		            case (cnt)
					     //----------------------------- wr 20 h -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzz20   ;                          end	
			           3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= F_ERASE_2_TAB; end         
						endcase	
              cnt <= cnt + 1'b1;							
     			  end //ERASE_TAB
				
		F_ERASE_2_TAB : begin   
			         case (cnt)
					     //----------------------------- wr D0 h -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL;  sig_adv <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce  <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we  <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzzD0   ;                       end	
                    3'b111: begin  sig_ce <= 1'b1     ;  sig_we    <= 1'b1 ; state <= F_READ_SR_ER_TAB ; data <= 16'hzzzz;   end    //dat_oe <= 1'b0;      				  
						endcase
                cnt <= cnt + 1'b1;							
     			    end //ERASE_2_TAB
					 	  
	   F_READ_SR_ER_TAB :  begin
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
											      if ((read_data [5] == 1'b1) || (read_data [4] == 1'b1)) state <=  F_CLEAR_SR_ER_TAB  ; 
													else state <=  F_WRITE_TAB;			
											 end
								end  // 3'b111
				       endcase
                   cnt <= cnt + 1'b1;	
	                end //READ_SR_ER_TAB
					
	  F_CLEAR_SR_ER_TAB : begin
			          case (cnt)
					     //----------------------------- wr 50 h  -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL; sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;    sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;    sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzz50   ;                          end	  
					     3'b111: begin  sig_ce    <= 1'b1  ;    sig_we    <= 1'b1 ; state <= F_UNLOCK_TAB; end  //state <=  WRITE;       				  
						endcase	
                  cnt <= cnt + 1'b1;							
     			      end //CLEAR_SR_TAB 
		
		F_WRITE_TAB:   
		          begin
			           case (cnt)
		              //----------------------------- wr 40 h  --------------------------//
	                 3'b000: begin  addr     <= ADDR_TABL; sig_adv  <= 1'b1;  end		
			           3'b001: begin  sig_adv  <= 1'b0   ;   sig_ce   <= 1'b0;  end 
			           3'b010: begin  sig_adv  <= 1'b1   ;   sig_we   <= 1'b0;  end	  
						  3'b011: begin  data <= 16'hzz40   ;                    end	
						  3'b111: begin  sig_ce   <= 1'b1   ;   sig_we   <= 1'b1; state <= F_WRITE_2_TAB ; end   // 3'b111
						endcase
               cnt <= cnt + 1'b1;	
			      end //WRITE_TAB
				
		F_WRITE_2_TAB:	 begin
			            case (cnt)	
						 //----------------------------- wr  h  --------------------------//
					     3'b000: begin  addr     <= ADDR_TABL ; sig_adv  <= 1'b1;  end  
			           3'b001: begin  sig_adv  <= 1'b0      ; sig_ce   <= 1'b0;  end  
			           3'b010: begin  sig_adv  <= 1'b1      ; sig_we   <= 1'b0;  end  
						  3'b011: begin  data     <= wr_tabl   ;   end	//data     <= fifo_out  wr_tabl
			           3'b111: begin  sig_ce   <= 1'b1      ;
						                 sig_we   <= 1'b1      ; 
										     state    <= F_READ_SR_WR_TAB;
											  data     <= 16'hzzzz      ;
									 end // 3'b111 
							endcase
                cnt <= cnt + 1'b1;	
					 end //WRITE_2_TAB 
	   
	  F_READ_SR_WR_TAB : begin
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
											      if ((read_data [5] == 1'b1) || (read_data [4] == 1'b1)) state <= F_CLEAR_SR_WR_TAB; 
												   else 
													  begin
													  state  <= UNLOCK_PFL;	
													  adrcnt <= ADDR_PFL  ;
											        end		
									       end
								    end  // 3'b111	
				      endcase
                  cnt <= cnt + 1'b1;	
	               end //READ_SR_WR_TAB
	
	  F_CLEAR_SR_WR_TAB : begin
			          case (cnt)
					     //----------------------------- wr 50 h   -----------------------------//
			           3'b000: begin  addr      <= ADDR_TABL;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b110: begin  data      <= 16'hzz50 ;                       end	  
					     3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= F_WRITE_TAB; end         				  
						endcase	
                  cnt <= cnt + 1'b1;							
     			      end //CLEAR_SR_WR_TAB			
						
						
						
				
//--------------------------------------  WRITE FPL data -----------------------------------------------------------				
		UNLOCK_PFL : begin
			         case (cnt)
					     //----------------------------- wr 60 h -----------------------------//
			           3'b000: begin  addr      <= adrcnt;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0     ;  sig_ce     <= 1'b0;    end 
			           3'b010: begin  sig_adv   <= 1'b1     ;  sig_we     <= 1'b0;    end	
					     3'b011: begin  data <= 16'hzz60      ;                         end	
			           3'b111: begin  sig_ce    <= 1'b1     ;  sig_we    <= 1'b1 ; state <= UNLOCK_2_PFL; end         
						endcase
            cnt <= cnt + 1'b1;							
     			end //UNLOCK_PFL
				
		UNLOCK_2_PFL : begin
		            case (cnt)
					     //----------------------------- wr D0 h  -----------------------------//
			           3'b000: begin  addr      <= adrcnt;  sig_adv    <= 1'b1;   end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzzD0   ;                          end	
						  3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= ERASE_PFL;      end 	  
						endcase	
            cnt <= cnt + 1'b1;							
     			end //UNLOCK_2_PFL
				
		ERASE_PFL : begin
		            case (cnt)
					     //----------------------------- wr 20 h -----------------------------//
			           3'b000: begin  addr      <= adrcnt;  sig_adv    <= 1'b1;   end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzz20   ;                          end	
			           3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= ERASE_2_PFL; end         
						endcase	
              cnt <= cnt + 1'b1;							
     			  end //ERASE_PFL
				
		ERASE_2_PFL : begin   
			         case (cnt)
					     //----------------------------- wr D0 h -----------------------------//
			           3'b000: begin  addr      <= adrcnt;  sig_adv <= 1'b1;   end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce  <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we  <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzzD0   ;                       end	
                    3'b111: begin  sig_ce <= 1'b1     ;  sig_we    <= 1'b1 ; state <= READ_SR_ER_PFL ; data <= 16'hzzzz;   end    //dat_oe <= 1'b0;      				  
						endcase
                cnt <= cnt + 1'b1;							
     			    end //ERASE_2_PFL
					 	  
	   READ_SR_ER_PFL :  begin
		              case (cnt)
						  3'b000: begin  addr      <= adrcnt;    sig_adv    <= 1'b1  ;     end		
			           3'b001: begin  sig_adv   <= 1'b0     ;    sig_ce     <= 1'b0  ;    end 
			           3'b010: begin  sig_adv   <= 1'b1     ;    sig_oe     <= 1'b0  ;    end	//dat_oe <= 1'b1;  dat_oe <= 1'b0; 
					     3'b110: begin  read_data <= fsm_d ;                                end	
			           3'b111: begin  
					                sig_ce    <= 1'b1      ; 
					                sig_oe    <= 1'b1      ; 
										 if (read_data [7] == 1'b1)
										    begin
											      if ((read_data [5] == 1'b1) || (read_data [4] == 1'b1)) state <=  CLEAR_SR_ER_PFL  ; 
													else state <=  WRITE_PFL;			
											 end
								end  // 3'b111
				       endcase
                   cnt <= cnt + 1'b1;	
	                end //READ_SR_ER_PFL
					
	  CLEAR_SR_ER_PFL : begin
			          case (cnt)
					     //----------------------------- wr 50 h  -----------------------------//
			           3'b000: begin  addr      <= adrcnt; sig_adv    <= 1'b1;    end		
			           3'b001: begin  sig_adv   <= 1'b0  ;   sig_ce     <= 1'b0;    end 
			           3'b010: begin  sig_adv   <= 1'b1  ;   sig_we     <= 1'b0;    end	
					     3'b011: begin  data <= 16'hzz50   ;                          end	  
					     3'b111: begin  sig_ce    <= 1'b1  ;    sig_we    <= 1'b1 ; state <= UNLOCK_PFL; end  //state <=  WRITE;       				  
						endcase	
                  cnt <= cnt + 1'b1;							
     			      end //CLEAR_SR_PFL 
		
		WRITE_PFL:   
		          begin
			           case (cnt)
		              //----------------------------- wr 40 h  --------------------------//
	                 3'b000: begin  addr     <= adrcnt; sig_adv  <= 1'b1;   end		
			           3'b001: begin  sig_adv  <= 1'b0   ;   sig_ce   <= 1'b0;  end 
			           3'b010: begin  sig_adv  <= 1'b1   ;   sig_we   <= 1'b0;  end	  
						  3'b011: begin  data <= 16'hzz40   ;                      end	
						  3'b111: begin  sig_ce   <= 1'b1   ;   sig_we   <= 1'b1; state <= WRITE_2_PFL ; end   // 3'b111
						endcase
               cnt <= cnt + 1'b1;	
			      end //WRITE_PFL
				
		WRITE_2_PFL:	 begin
			            case (cnt)	
						 //----------------------------- wr  h  --------------------------//
					     3'b000: begin  addr     <= adrcnt ; sig_adv  <= 1'b1;   end  
			           3'b001: begin  sig_adv  <= 1'b0      ; sig_ce   <= 1'b0;  end  
			           3'b010: begin  sig_adv  <= 1'b1      ; sig_we   <= 1'b0;  end  
						  3'b011: begin  data     <= mem [cnt_pfl]   ;   end	//data     <= fifo_out  wr_tabl
			           3'b111: begin  sig_ce   <= 1'b1      ;
						                 sig_we   <= 1'b1      ; 
											  adrcnt   <= adrcnt  + 1'b1 ; 
											  cnt_pfl  <= cnt_pfl + 1'b1 ;
										     state    <= READ_SR_WR_PFL ;
											  data     <= 16'hzzzz       ;
											  
									 end // 3'b111 
							endcase
                cnt <= cnt + 1'b1;	
					 end //WRITE_2_PFL 
	   
	  READ_SR_WR_PFL : begin
	               case (cnt)
						  3'b000: begin  addr      <= adrcnt;   sig_adv    <= 1'b1  ;   end		
			           3'b001: begin  sig_adv   <= 1'b0  ;     sig_ce     <= 1'b0  ;   end 
			           3'b010: begin  sig_adv   <= 1'b1  ;     sig_oe     <= 1'b0  ;   end	 
					     3'b110: begin  read_data <= fsm_d ;                             end	
			           3'b111: begin  
					                sig_ce    <= 1'b1      ; 
					                sig_oe    <= 1'b1      ; 
										 if (read_data [7] == 1'b1)
										    begin
											      if ((read_data [5] == 1'b1) || (read_data [4] == 1'b1)) state <= CLEAR_SR_WR_PFL; 
												   else if  (cnt_pfl < 3'b110) state  <= WRITE_PFL;
													else if  (cnt_pfl == 3'b110)
													      begin
												      	state  <= WRITE_PFL    ;
															adrcnt <= ADDR_PFL_END ;
															end
												   else state  <= TO_Z_PFL;       		
									       end
								    end  // 3'b111	
				      endcase
                  cnt <= cnt + 1'b1;	
	               end //READ_SR_WR_PFLB
	
	  CLEAR_SR_WR_PFL : begin
			          case (cnt)
					     //----------------------------- wr 50 h   -----------------------------//
			           3'b000: begin  addr      <= adrcnt;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b110: begin  data      <= 16'hzz50 ;                       end	  
					     3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= WRITE_ER_PFL; cnt_pfl  <= cnt_pfl - 1'b1 ; end         				  
						endcase	
                  cnt <= cnt + 1'b1;							
     			      end //CLEAR_SR_WR_PFL
						
		WRITE_ER_PFL:    begin
			         case (cnt)
		              //----------------------------- wr 40 h  --------------------------//
	                 3'b000: begin  addr     <= adrcnt - 1'b1 ; sig_adv  <= 1'b1;  end		
			           3'b001: begin  sig_adv  <= 1'b0          ; sig_ce   <= 1'b0;  end 
			           3'b010: begin  sig_adv  <= 1'b1          ; sig_we   <= 1'b0;  end	  
						  3'b011: begin  data <= 16'hzz40          ;                    end	
						  3'b111: begin  sig_ce   <= 1'b1          ; sig_we   <= 1'b1; state <= WRITE_ER_2_PFL ; end   // 3'b111
						endcase
                  cnt <= cnt + 1'b1;	
			         end //WRITE_ER_PFL
				
	  WRITE_ER_2_PFL: begin
			        case (cnt)	
						 //----------------------------- wr  h  --------------------------//
					     3'b000: begin  addr     <= adrcnt        ; sig_adv  <= 1'b1;  end  
			           3'b001: begin  sig_adv  <= 1'b0          ; sig_ce   <= 1'b0;  end  
			           3'b010: begin  sig_adv  <= 1'b1          ; sig_we   <= 1'b0;  end  
						  3'b011: begin  data     <= mem [cnt_pfl] ;                    end	
			           3'b111: begin  sig_ce   <= 1'b1          ;
						                 sig_we   <= 1'b1          ; 
										     adrcnt   <= adrcnt + 1'b1 ; 
										     state    <= READ_SR_WR_PFL;
											  data     <= 16'hzzzz      ;
									 end // 3'b111 
						endcase
                  cnt <= cnt + 1'b1;	
					   end //WRITE_ER_2_PFL 
		 TO_Z_PFL:
		       begin
		               dat_oe <= 1'b1; 
				         data         <= 16'hZZZZ    ;
                     read_data    <= 16'hZZZZ    ; 
                     sig_ce       <= 1'bz        ; 
                     sig_oe       <= 1'bz        ; 
                     sig_we       <= 1'bz        ; 
                     sig_adv      <= 1'bz        ; 
							addr         <= 25'hZZZZZZZ ;  
							
							if(!flag_err) 
							    begin
							      flag_err <= 1'b0 ;
								   state <= IDLE    ;
							    end
							else  
							    begin
							        state <= CONFIG  ;
									  flag_err <= 1'b0 ;
							    end
		       end
				 
//---------------------------------- WAIT fifo data   ----------------------------------------				
		 IDLE   : begin		
							flag         <= 0           ;
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
						   if (!empty) state <= FROM_Z ;		
				     end	// IDLE
					  
		FROM_Z : begin
		         dat_oe <= 1'b0;
		         //state <= READ_TAB;
				     state <= UNLOCK_TAB;	
					  adrcnt  <= ADDR_FIRM_1   ;
		         end
					
//------------------------------------ WRITE data table -------------------------------------------------------		
				 
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
											  
											 if    (firm_N [15:10] == 6'b111111)
											        begin
															 adrcnt  <= ADDR_FIRM_1   ;
															 wr_tabl <= {6'b110110,10'b0000000000};
													  end 
												/*	  
											 else 
											        begin
											             adrcnt <= ADDR_FIRM_1 ;
															 wr_tabl <= {6'b111110,10'b0000000000};
													  end
													  
											*/
											  /*
							             if     ((firm_N [15:10]  == 6'b110100) || (firm_N [15:10] == 6'b111111))
											        begin
															 adrcnt  <= ADDR_FIRM_1   ;
															 wr_tabl <= {6'b110100,10'b0000000000};
													  end 
											 else 
											        begin
											             adrcnt <= ADDR_FIRM_1 ;
															 wr_tabl <= {6'b111110,10'b0000000000};
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
			
	//----------------------------------- WRITE to flash firmware ------------------------------------------------	
		UNLOCK : begin
			         case (cnt)
					     //----------------------------- wr 60 h -----------------------------//
			           3'b000: begin  addr      <= adrcnt;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzz60   ;                          end	
			           3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= UNLOCK_2; end         
						endcase
            cnt <= cnt + 1'b1;							
     			end //UNLOCK
				
		UNLOCK_2 : begin
		            case (cnt)
					     //----------------------------- wr D0 h  -----------------------------//
			           3'b000: begin  addr      <= adrcnt;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzzD0   ;                          end	
						  3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= ERASE;      end 	  
						endcase	
            cnt <= cnt + 1'b1;							
     			end //UNLOCK_2
			
		ERASE : begin
		            case (cnt)
					     //----------------------------- wr 20 h -----------------------------//
			           3'b000: begin  addr      <= adrcnt;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzz20   ;                          end	
			           3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= ERASE_2; end         
						endcase	
              cnt <= cnt + 1'b1;							
     			  end //ERASE
				
		ERASE_2 : begin   
			         case (cnt)
					     //----------------------------- wr D0 h -----------------------------//
			           3'b000: begin  addr      <= adrcnt;  sig_adv <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce  <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we  <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzzD0   ;                       end	
                    3'b111: begin  sig_ce <= 1'b1  ;  sig_we    <= 1'b1 ; state <= READ_SR_ER ; data <= 16'hzzzz;   end    //dat_oe <= 1'b0;      				  
						endcase
                cnt <= cnt + 1'b1;							
     			    end //ERASE_2
					 	  
	   READ_SR_ER :  begin
		              case (cnt)
						  3'b000: begin  addr      <= adrcnt;       sig_adv    <= 1'b1  ;    end		
			           3'b001: begin  sig_adv   <= 1'b0  ;       sig_ce     <= 1'b0  ;    end 
			           3'b010: begin  sig_adv   <= 1'b1  ;       sig_oe     <= 1'b0  ;    end	//dat_oe <= 1'b1;  dat_oe <= 1'b0; 
					     3'b110: begin  read_data <= fsm_d ;                                end	
			           3'b111: begin  
					                sig_ce    <= 1'b1      ; 
					                sig_oe    <= 1'b1      ; 
										 if (read_data [7] == 1'b1)
										    begin
											      if ((read_data [5] == 1'b1) || (read_data [4] == 1'b1)) state <=  CLEAR_SR_ER  ; 
													else state <=  WRITE ;			
											 end
								end  // 3'b111
				       endcase
                   cnt <= cnt + 1'b1;	
	                end //READ_SR_ER
					
	  CLEAR_SR_ER : begin
			          case (cnt)
					     //----------------------------- wr 50 h  -----------------------------//
			           3'b000: begin  addr      <= adrcnt;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b011: begin  data <= 16'hzz50   ;                          end	  
					     3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= UNLOCK; end  //state <=  WRITE;       				  
						endcase	
                  cnt <= cnt + 1'b1;							
     			      end //CLEAR_SR 
		
		WRITE:  if (!empty ) 
		          begin
			           case (cnt)
		              //----------------------------- wr 40 h  --------------------------//
	                 3'b000: begin  addr     <= adrcnt ; sig_adv  <= 1'b1;  end		
			           3'b001: begin  sig_adv  <= 1'b0   ; sig_ce   <= 1'b0;  end 
			           3'b010: begin  sig_adv  <= 1'b1   ; sig_we   <= 1'b0;  end	  
						  3'b011: begin  data <= 16'hzz40   ;                    end	
						  3'b111: begin  sig_ce   <= 1'b1   ; sig_we   <= 1'b1; state <= WRITE_2 ; end   // 3'b111
						endcase
               cnt <= cnt + 1'b1;	
			      end //WRITE:
				  else if (kol == 24'h25C96C) state <= TO_Z;
		WRITE_2:	 begin
			            case (cnt)	
						 //----------------------------- wr  h  --------------------------//
					     3'b000: begin  addr     <= adrcnt ; sig_adv  <= 1'b1                  ;  end  
			           3'b001: begin  sig_adv  <= 1'b0   ; sig_ce   <= 1'b0;  rdreq <= 1'b1  ;  end  
			           3'b010: begin  sig_adv  <= 1'b1   ; sig_we   <= 1'b0;  rdreq <= 1'b0  ;  end  
						  3'b011: begin  data     <= fifo_out      ; err_data <= fifo_out       ;  end	
			           3'b111: begin  sig_ce   <= 1'b1          ;
						                 sig_we   <= 1'b1          ; 
										     adrcnt   <= adrcnt + 1'b1 ; 
											  kol      <= kol + 1'b1    ;
										     state    <= READ_SR_WR    ;
											  data     <= 16'hzzzz      ;
									 end // 3'b111 
							endcase
                cnt <= cnt + 1'b1;	
					 end //WRITE_2 
	   
	  READ_SR_WR : begin
	               case (cnt)
						  3'b000: begin  addr      <= adrcnt;       sig_adv    <= 1'b1  ;    end		
			           3'b001: begin  sig_adv   <= 1'b0  ;       sig_ce     <= 1'b0  ;    end 
			           3'b010: begin  sig_adv   <= 1'b1  ;       sig_oe     <= 1'b0  ;    end	 
					     3'b110: begin  read_data <= fsm_d ;                                end	
			           3'b111: begin  
					                sig_ce    <= 1'b1      ; 
					                sig_oe    <= 1'b1      ; 
										 if (read_data [7] == 1'b1)
										    begin
											      if ((read_data [5] == 1'b1) || (read_data [4] == 1'b1)) state <= CLEAR_SR_WR; 
												   else if ((adrcnt % 25'h0010000) == 1'b0)                state <= UNLOCK     ;
										         else  state  <= WRITE         ;			
									       end
								    end  // 3'b111	
				      endcase
                  cnt <= cnt + 1'b1;	
	               end //READ_SR_WR
	
	  CLEAR_SR_WR : begin
			          case (cnt)
					     //----------------------------- wr 50 h   -----------------------------//
			           3'b000: begin  addr      <= adrcnt;  sig_adv    <= 1'b1;     end		
			           3'b001: begin  sig_adv   <= 1'b0  ;  sig_ce     <= 1'b0;     end 
			           3'b010: begin  sig_adv   <= 1'b1  ;  sig_we     <= 1'b0;     end	
					     3'b110: begin  data      <= 16'hzz50 ;                       end	  
					     3'b111: begin  sig_ce    <= 1'b1  ;  sig_we    <= 1'b1 ; state <= WRITE_ER; end         				  
						endcase	
                  cnt <= cnt + 1'b1;							
     			      end //CLEAR_SR_WR		
						
	  WRITE_ER:    begin
			         case (cnt)
		              //----------------------------- wr 40 h  --------------------------//
	                 3'b000: begin  addr     <= adrcnt - 1'b1 ; sig_adv  <= 1'b1;  end		
			           3'b001: begin  sig_adv  <= 1'b0          ; sig_ce   <= 1'b0;  end 
			           3'b010: begin  sig_adv  <= 1'b1          ; sig_we   <= 1'b0;  end	  
						  3'b011: begin  data <= 16'hzz40          ;                    end	
						  3'b111: begin  sig_ce   <= 1'b1          ; sig_we   <= 1'b1; state <= WRITE_ER_2 ; end   // 3'b111
						endcase
                  cnt <= cnt + 1'b1;	
			         end //WRITE_ER
				
	  WRITE_ER_2: begin
			        case (cnt)	
						 //----------------------------- wr  h  --------------------------//
					     3'b000: begin  addr     <= adrcnt        ; sig_adv  <= 1'b1;  end  
			           3'b001: begin  sig_adv  <= 1'b0          ; sig_ce   <= 1'b0;  end  
			           3'b010: begin  sig_adv  <= 1'b1          ; sig_we   <= 1'b0;  end  
						  3'b011: begin  data     <= err_data      ;                    end	
			           3'b111: begin  sig_ce   <= 1'b1          ;
						                 sig_we   <= 1'b1          ; 
										     adrcnt   <= adrcnt + 1'b1 ; 
										     state    <= READ_SR_WR    ;
											  data     <= 16'hzzzz      ;
									 end // 3'b111 
						endcase
                  cnt <= cnt + 1'b1;	
					   end //WRITE_ER_2 
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
							*/
		                 kol_2 <= kol_2 + 1'b1;
							  reg_max_csn  <= 1'b0 ;
					        end
		         
		         end
	
    endcase 	 
 end
 
//------------------------------------------------   JTAG   data sender  -------------------------------
always @(posedge tck)
   if(cdr && (ir_in==3'b010) )
     //capture data for send during command POP
     shift_dr_out <= { user_pb[3:0], user_pb[3:0] };
   else
   if(sdr && (ir_in==3'b010) )
     //shift  data durng command POP
     shift_dr_out <= { tdi, shift_dr_out[7:1] };
	  
//pass or bypass data via tdo reg
always @*
begin
  case(ir_in)
   4'b001: tdo = shift_dr_in [0];
   4'b010: tdo = shift_dr_out[0];
  default:
   tdo = tdi;
  endcase
end
//-------------------------------------------------------------------------------------------------------


	virt_jtag u0 (
		.tdi                (tdi),                // jtag.tdi
		.tdo                (tdo),                //     .tdo
		.ir_in              (ir_in),              //     .ir_in
		.ir_out             (),                   //     .ir_out
		.virtual_state_cdr  (cdr),                //     .virtual_state_cdr
		.virtual_state_sdr  (sdr),                //     .virtual_state_sdr
		.virtual_state_e1dr (e1dr),               //     .virtual_state_e1dr
		.virtual_state_pdr  (pdr),                //     .virtual_state_pdr
		.virtual_state_e2dr (e2dr),               //     .virtual_state_e2dr
		.virtual_state_udr  (udr),                //     .virtual_state_udr
		.virtual_state_cir  (cir),                //     .virtual_state_cir
		.virtual_state_uir  (uir),                //     .virtual_state_uir
		.tck                (tck)                 //  tck.clk
	);
	
	
	fifo	fifo_inst (
	.data     ( fifo_in       ),
	.rdclk    ( clkin_50      ),
	.rdreq    ( rdreq         ), //rdreq  
	.wrclk    ( tck           ),
	.wrreq    ( wr_fifo       ),
	.q        ( fifo_out      ),
	.rdempty  ( empty         ),
	.wrfull   ( full          )
	);

endmodule

