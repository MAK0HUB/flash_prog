# C:\altera\14.0\quartus\bin64>quartus_stp -t FIRM_CONTROL.tcl

#quartus_stp -t FIRM_CONTROL.tcl
#cd altera\14.0\quartus\bin64
# -------------------------------------------------------------------------
set  usb [lindex [get_hardware_names] 0]                                     ; # Список доступных USB устройств
set  device_name [lindex [get_device_names -hardware_name $usb] 0]           ; # Открытие USB устройства с индексом 0
puts "*************************"
puts "programming cable:"
puts $usb

#set  fileid  [open "c:/altera/14.0/quartus/bin64/temp/RFH_new_01.pof" r ]
set  fileid  [open "c:/altera/14.0/quartus/bin64/temp/RFH_new_10.pof" r ]
#set  fileid  [open "c:/altera/14.0/quartus/bin64/temp/RFH_new_00.pof" r ]
#set  fileid  [open "c:/altera/14.0/quartus/bin64/temp/RFH_new_err.pof" r ]

# ---------------------------------------------------------------------------

fconfigure $fileid -translation binary                                        ; # Открытие файла как двоичного   
# --------------------------------------------------------------------------

set  i      131220  ;      # адрес в файле hex  20094   (смещенный на 94)                                          
set  p_end  5084012 ;      # адрес в файле hex  4D936C  (смещенный на 94)    
 
open_device -device_name $device_name -hardware_name $usb   ; # Открытие usb стройства 
device_lock -timeout 10000                                  ; # Блокирование usb стройства 

set v 0                                                     ; # Кол-во переданных слов 16 бит      
while {$i < $p_end}  { 

if {[expr $v%10000] == 0 } {                                ; # Снижение
after 1500                                                  ; # скорости 
incr r                                                      ; # передачи
}
seek $fileid $i start                                       ; # Устанавливаем курсор на начальную позицию в файле
set chars [read   $fileid  8]                               ; # Считываем строку симвлов 8 байт
binary scan $chars B64  list                                ; # Перевод строки символов в двоичную строку 64 бит

device_virtual_ir_shift -instance_index 0 -ir_value 1 -no_captured_ir_value                    ; # Передаем команду 1 в регистр команд virtual_JTAG
device_virtual_dr_shift -instance_index 0 -dr_value $list -length 64  -no_captured_dr_value    ; # Передаем  строку 64 бит в регистр данных virtual_JTAG

set i [expr $i+8]                                           ; # Перемещаем курсор в файле на 8 байт (символов)
incr v                                                      ; # Увеличиваем на 1 кол-во переданных слов (16 бит) 
}; #while 


puts "write words:"
puts  $v

close $fileid                         ;  # Закрытие файла
device_unlock                         ;  # Разблокировка USB devce
close_device                          ;  # Закрытие USB


