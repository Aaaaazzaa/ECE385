transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib lab7_soc
vmap lab7_soc lab7_soc
vlog -vlog01compat -work lab7_soc +incdir+E:/My_Document/ECE385/Lab8/tianhao6/lab8_final_version/Lab8_provided/lab7_soc/synthesis/submodules {E:/My_Document/ECE385/Lab8/tianhao6/lab8_final_version/Lab8_provided/lab7_soc/synthesis/submodules/lab7_soc_jtag_uart_0.v}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Lab8/tianhao6/lab8_final_version/Lab8_provided {E:/My_Document/ECE385/Lab8/tianhao6/lab8_final_version/Lab8_provided/VGA_controller.sv}

vlog -sv -work work +incdir+E:/My_Document/ECE385/Lab8/tianhao6/lab8_final_version/Lab8_provided {E:/My_Document/ECE385/Lab8/tianhao6/lab8_final_version/Lab8_provided/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L lab7_soc -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 2000 ns
