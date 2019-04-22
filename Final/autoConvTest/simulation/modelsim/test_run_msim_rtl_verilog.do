transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+H:/Final/autoConvTest {H:/Final/autoConvTest/convolutionSM.sv}
vlog -sv -work work +incdir+H:/Final/autoConvTest {H:/Final/autoConvTest/signedMult.sv}
vlog -sv -work work +incdir+H:/Final/autoConvTest {H:/Final/autoConvTest/autoConvolution.sv}

vlog -sv -work work +incdir+H:/Final/autoConvTest {H:/Final/autoConvTest/testbench2.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench2

add wave *
view structure
view signals
run 100 ns
