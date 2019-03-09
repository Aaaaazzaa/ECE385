// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	volatile unsigned int *LED_PIO = (unsigned int*)0x90; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO = (unsigned int*)0x80;
	volatile unsigned int *KEY3_PIO = (unsigned int*)0x70;
	volatile unsigned int *KEY2_PIO = (unsigned int*)0x60;
	unsigned int sum=0;
	*LED_PIO = 0; //clear all LEDs
	int i = 0;
		//volatile unsigned int *LED_PIO = (unsigned int*)0x20; //make a pointer to access the PIO block

		*LED_PIO = 0; //clear all LEDs
		while ( *KEY2_PIO != 0) //infinite loop
		{
			for (i = 0; i < 100000; i++); //software delay
			*LED_PIO |= 0x1; //set LSB
			for (i = 0; i < 100000; i++); //software delay
			*LED_PIO &= ~0x1; //clear LSB
		}
	while(1){
		if (*KEY3_PIO == 0){
			sum += *SW_PIO;
		}
		if (*KEY2_PIO == 0){
			sum = 0;
		}
		while(*KEY3_PIO == 0){
			*LED_PIO = sum;
		}
		*LED_PIO = sum;
	}


}
