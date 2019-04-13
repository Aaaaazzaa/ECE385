module testread(output logic abc);
    //string mem [5];        
    reg [3:0] mem [128*64];            
    initial begin
        $sreadmemh("sky128_64.txt",mem);
        $display("mem = %p",mem);
    end 
	 assign abc = mem[1];
endmodule 