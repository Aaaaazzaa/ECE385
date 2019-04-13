transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/test {E:/My_Document/ECE385/Final/test/test.sv}

vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/test {E:/My_Document/ECE385/Final/test/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
