# C:\altera\14.0\quartus\bin64>quartus_stp -t my_tcl_Av_ST_MM.tcl

# quartus_stp -t my_tcl_Av_ST_MM.tcl
# cd altera\14.0\quartus\bin64
# ---------------------------------------------------------------

set  usb [lindex [get_hardware_names] 0]
set  device_name [lindex [get_device_names -hardware_name $usb] 0]
puts "*************************"
puts "programming cable:"
puts $usb

# ----------------------------------------------
#IR scan codes:  001 -> Avalon_ST_32bit
#                010 -> Avalon_MM_write_8bit
#                011 -> Avalon_MM_read_8bit
# ----------------------------------------------
# interface      0 -->  Avalon_ST
#                1 -->  Avalon_MM


set  fail_AvST  [open "c:/altera/14.0/quartus/bin64/temp/new_l4_p0.pof" r ]
fconfigure $fail_AvST -translation binary 



set interface 0

if { $interface == 0} {



#5084012
#131220
#229672
#196616

# 0) pfl 18094 --> 98452
# 1) pfl 18098 --> 98456
# 2) pfl 1809c --> 98460

set page 0

if { $page == 0} {
  set  i      0         ; #131220
  set  p_end  8       ; #5084012         
  set  pfl    98452
  
  } elseif { $page == 1} {
  set  i      5112256 
  set  p_end  10064748
  set  pfl    98456
   
  } elseif { $page == 2} {
  set  i      10092692 
  set  p_end  15045484
  set  pfl    98460
  }
  
  
  open_device -device_name $device_name -hardware_name $usb
device_lock -timeout 10000


#seek $fail_AvST $pfl start
#set chars [read   $fail_AvST  8]
#binary scan $chars B64  list
#device_virtual_ir_shift -instance_index 0 -ir_value 1 -no_captured_ir_value
#device_virtual_dr_shift -instance_index 0 -dr_value $list -length 64  -no_captured_dr_value


#set i 0
while {$i < $p_end}  { 

seek $fail_AvST $i start
set chars [read   $fail_AvST  8]
binary scan $chars B64  list

device_virtual_ir_shift -instance_index 0 -ir_value 1 -no_captured_ir_value
device_virtual_dr_shift -instance_index 0 -dr_value $list -length 64  -no_captured_dr_value 

set i [expr $i+8]
}; #while 


puts "write board LEDs:"

#puts $x

close $fail_AvST
device_unlock
close_device

}  elseif { $interface == 1} {
  set  fail_AvMM  [open "c:/altera/14.0/quartus/bin64/temp/test_file" r ]
  fconfigure $fail_AvMM -translation binary 

  close $fail_AvMM
}



