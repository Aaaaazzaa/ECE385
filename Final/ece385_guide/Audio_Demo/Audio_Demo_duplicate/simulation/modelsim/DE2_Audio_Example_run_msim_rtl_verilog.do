transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/avconf {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/avconf/avconf.v}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/avconf {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/avconf/I2C_Controller.v}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller/Altera_UP_Audio_Bit_Counter.v}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller/Altera_UP_Audio_In_Deserializer.v}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller/Altera_UP_Audio_Out_Serializer.v}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller/Altera_UP_Clock_Edge.v}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller/Altera_UP_SYNC_FIFO.v}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller/Audio_Clock.v}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/Audio_Controller/Audio_Controller.v}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/DE2_Audio_Example.v}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/signedMult.sv}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/signedMod.sv}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/findMaxIdx.sv}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/convolutionSM.sv}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/HexDriver.sv}
vlog -sv -work work +incdir+E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo {E:/My_Document/ECE385/Final/ece385_guide/Audio_Demo/Audio_Demo/autoConvolution.sv}

