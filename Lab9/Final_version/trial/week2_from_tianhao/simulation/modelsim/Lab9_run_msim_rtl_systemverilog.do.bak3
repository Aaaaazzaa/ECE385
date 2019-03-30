transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2\ from\ tianhao {C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2 from tianhao/Lab9_mealy_sm.sv}
vlog -sv -work work +incdir+C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2\ from\ tianhao {C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2 from tianhao/SubBytes.sv}
vlog -sv -work work +incdir+C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2\ from\ tianhao {C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2 from tianhao/InvShiftRows.sv}
vlog -sv -work work +incdir+C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2\ from\ tianhao {C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2 from tianhao/InvMixColumns.sv}
vlog -sv -work work +incdir+C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2\ from\ tianhao {C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2 from tianhao/AddRoundKey.sv}
vlog -sv -work work +incdir+C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2\ from\ tianhao {C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2 from tianhao/KeyExpansion.sv}
vlog -sv -work work +incdir+C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2\ from\ tianhao {C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2 from tianhao/AES.sv}
vlib lab9_soc
vmap lab9_soc lab9_soc

vlog -sv -work work +incdir+C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2\ from\ tianhao {C:/Users/leihaoc2/Documents/GitHub/ECE385/Lab9/leihaoc2/week2 from tianhao/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L lab9_soc -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1500 ns
