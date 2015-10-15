# C:\altera\14.0\quartus\bin64>quartus_stp -t FIRM_CONTROL.tcl

#quartus_stp -t FIRM_CONTROL.tcl
#cd altera\14.0\quartus\bin64
# -------------------------------------------------------------------------
set  usb [lindex [get_hardware_names] 0]                                     ; # ������ ��������� USB ���������
set  device_name [lindex [get_device_names -hardware_name $usb] 0]           ; # �������� USB ���������� � �������� 0
puts "*************************"
puts "programming cable:"
puts $usb

#set  fileid  [open "c:/altera/14.0/quartus/bin64/temp/RFH_new_01.pof" r ]
set  fileid  [open "c:/altera/14.0/quartus/bin64/temp/RFH_new_10.pof" r ]
#set  fileid  [open "c:/altera/14.0/quartus/bin64/temp/RFH_new_00.pof" r ]
#set  fileid  [open "c:/altera/14.0/quartus/bin64/temp/RFH_new_err.pof" r ]

# ---------------------------------------------------------------------------

fconfigure $fileid -translation binary                                        ; # �������� ����� ��� ���������   
# --------------------------------------------------------------------------

set  i      131220  ;      # ����� � ����� hex  20094   (��������� �� 94)                                          
set  p_end  5084012 ;      # ����� � ����� hex  4D936C  (��������� �� 94)    
 
open_device -device_name $device_name -hardware_name $usb   ; # �������� usb ��������� 
device_lock -timeout 10000                                  ; # ������������ usb ��������� 

set v 0                                                     ; # ���-�� ���������� ���� 16 ���      
while {$i < $p_end}  { 

if {[expr $v%10000] == 0 } {                                ; # ��������
after 1500                                                  ; # �������� 
incr r                                                      ; # ��������
}
seek $fileid $i start                                       ; # ������������� ������ �� ��������� ������� � �����
set chars [read   $fileid  8]                               ; # ��������� ������ ������� 8 ����
binary scan $chars B64  list                                ; # ������� ������ �������� � �������� ������ 64 ���

device_virtual_ir_shift -instance_index 0 -ir_value 1 -no_captured_ir_value                    ; # �������� ������� 1 � ������� ������ virtual_JTAG
device_virtual_dr_shift -instance_index 0 -dr_value $list -length 64  -no_captured_dr_value    ; # ��������  ������ 64 ��� � ������� ������ virtual_JTAG

set i [expr $i+8]                                           ; # ���������� ������ � ����� �� 8 ���� (��������)
incr v                                                      ; # ����������� �� 1 ���-�� ���������� ���� (16 ���) 
}; #while 


puts "write words:"
puts  $v

close $fileid                         ;  # �������� �����
device_unlock                         ;  # ������������� USB devce
close_device                          ;  # �������� USB


