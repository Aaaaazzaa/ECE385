transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib lab9_soc
vmap lab9_soc lab9_soc
vlog -sv -work lab9_soc +incdir+E:/My\ Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao/lab9_soc/synthesis/submodules {E:/My Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao/lab9_soc/synthesis/submodules/avalon_aes_interface.sv}
vlog -sv -work work +incdir+E:/My\ Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao {E:/My Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao/stateISB.sv}
vlog -sv -work work +incdir+E:/My\ Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao {E:/My Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao/Lab9_mealy_sm.sv}
vlog -sv -work work +incdir+E:/My\ Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao {E:/My Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao/SubBytes.sv}
vlog -sv -work work +incdir+E:/My\ Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao {E:/My Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao/KeyExpansion.sv}
vlog -sv -work work +incdir+E:/My\ Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao {E:/My Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao/InvShiftRows.sv}
vlog -sv -work work +incdir+E:/My\ Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao {E:/My Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao/InvMixColumns.sv}
vlog -sv -work work +incdir+E:/My\ Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao {E:/My Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao/AES.sv}
vlog -sv -work work +incdir+E:/My\ Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao {E:/My Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao/AddRoundKey.sv}

vlog -sv -work work +incdir+E:/My\ Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao {E:/My Document/ECE385/Lab9/Final_version/trial/week2_from_tianhao/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L lab9_soc -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1500 ns
