/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"
void SubByte(unsigned char * msg_ascii, char*** save);
void ShiftRows(char ***save);
void CircularShift(char* temp);
// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000100;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	// Implement this function
	char **save=malloc(sizeof(char*)*4);
	int j=0;
	for(j=0;j<4;j++){
		save[j]=malloc(sizeof(char)*4);
	} 
	int i=0;
	for(i=0;i<9;i++){
		SubByte(msg_ascii,&save);
		ShiftRows(&save);
	}
}

void SubByte(unsigned char * msg_ascii, char*** save){
	int i=0;
	int j=0;
	//unsigned char tmp;
	//char ret[16];
		while(i<4){
			j=0;
			while(j<4){
				int current1 = * msg_ascii;
				msg_ascii++;
				int current2 = * msg_ascii;
				msg_ascii++;
				//char intermediate = charsToHex(current1,current2);
				//int lower=intermediate%16;
				//int higher=intermediate/16;
//				if(current1>=65&&current1<=70){
//					current1=current1-55;
//				}else if(current1>=97&&current1<=102){
//					current1=current1-87;
//				}else{
//					current1=current1-48;
//				}
//				if(current2>=65&&current2<=70){
//					current2=current2-55;
//				}else if(current2>=97&&current2<=102){
//					current2=current2-87;
//				}else{
//					current2=current2-48;
//				}
				
				printf("%d,%d\n",current1,current2);
				current1=charToHex(current1);
				current2=charToHex(current2);
				printf("%d\n",(current1*16+current2));
				*(save)[i][j]=aes_sbox[(current1*16+current2)]&0xff;
				printf("%x\n",*(save)[i][j]);
				j++;
			}
//			unsigned char charrow=*(msg_ascii+j);
//			j++;
//			unsigned char charcol=*(msg_ascii+j);
//			j++;
			i++;
		}	
		//return ret;
}

void ShiftRows(char ***save){
	int i,j;
	char* temp;
	for(i=0;i<4;i++){
		temp=(*save)[i];
		for(j=0;j<i;j++){
			CircularShift(temp);
		}
		
	}
}

void CircularShift(char* temp){
	char* keep=temp;
	char temp1=*temp;
	int j=0;
	for(j=0;j<3;j++){
		*(temp+j)=*(temp+j+1);
	
	}
	*(keep+3)=temp1;
}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
