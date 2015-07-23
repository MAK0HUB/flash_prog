# C:\altera\14.0\quartus\bin64>quartus_stp -t my_tcl_new.tcl

# quartus_stp -t my_tcl_new_2.tcl
# cd altera\14.0\quartus\bin64
# ---------------------------------------------------------------
set  usb [lindex [get_hardware_names] 0]
set  device_name [lindex [get_device_names -hardware_name $usb] 0]
puts "*************************"
puts "programming cable:"
puts $usb

#IR scan codes:  001 -> push
#                010 -> pop

#set  fileid  [open "c:/altera/14.0/quartus/bin64/temp/p2_FIRM_01.pof" r ]
set  fileid  [open "c:/altera/14.0/quartus/bin64/temp/p1_FIRM_10.pof" r ]
#set  fileid  [open "c:/altera/14.0/quartus/bin64/temp/p0_FIRM_Stock_00.pof" r ]
fconfigure $fileid -translation binary 

#set  fd      [open "c:/altera/14.0/quartus/bin64/temp/test_file"   w ]
#fconfigure $fd -translation binary -encoding binary

#set  buffer   [read -nonewline  $fileid  ]
#set  buffer   [read  $fileid             ]

#set  one_b    [expr   $kol_b   %    8    ]

#5084012
#131220
#229672
#196616

# 0) pfl 18094 --> 98452
# 1) pfl 18098 --> 98456
# 2) pfl 1809c --> 98460

set page 0

if { $page == 0} {
  set  i      131220  ; #131220
  set  p_end  5084012 ; #5084012     132020       
  set  pfl    98452
  
  } elseif { $page == 1} {
  set  i      5112256 
  set  p_end  10064748
   set  pfl   98456
   
   
  } elseif { $page == 2} {
  set  i      10092692 
  set  p_end  15045484
  set  pfl    98460
  }
  
#seek $fileid $i start
#seek $fd 0 start


open_device -device_name $device_name -hardware_name $usb
device_lock -timeout 10000

#seek $fileid $pfl start
#set chars [read   $fileid  8]
#binary scan $chars B64  list
#puts $fd $chars
#device_virtual_ir_shift -instance_index 0 -ir_value 1 -no_captured_ir_value
#device_virtual_dr_shift -instance_index 0 -dr_value $list -length 64  -no_captured_dr_value
#set r 0
set v 0
while {$i < $p_end}  { 

#for {set j 0} {$j < 100} {incr j} {
#incr r
#}

if {[expr $v%10000] == 0 } {
after 1500
incr r
}

seek $fileid $i start
set chars [read   $fileid  8]
binary scan $chars B64  list
#binary scan $chars "c"  list2

device_virtual_ir_shift -instance_index 0 -ir_value 1 -no_captured_ir_value
device_virtual_dr_shift -instance_index 0 -dr_value $list -length 64  -no_captured_dr_value 

#binary scan $chars B* list
#device_virtual_ir_shift -instance_index 0 -ir_value 3 -no_captured_ir_value
#device_virtual_dr_shift -instance_index 0 -dr_value $list -length 8  -no_captured_dr_value 

set i [expr $i+8]
incr v
}; #while 


puts "write board LEDs:"
puts  $v
#puts $x



#close $fileid2
close $fileid
#close $fd

#set  kol_b 0
#set  fdd      [open "c:/altera/14.0/quartus/bin64/temp/test_file"   r]
#set  buf_fd   [read -nonewline  $fdd   ]
#set  kol_b    [string length    $fdd   ]
#puts  $kol_b 
#close $fdd


device_unlock
close_device


