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

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000040;

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
// helper function SubBytes; input: to 2d array ptr
void SubBytes(unsigned char** matAddr){
	unsigned char tmp;
	for(int i = 0; i < 4; i++){
		for(int j = 0; j < 4; j++){
			tmp = aes_sbox[ (int) ((matAddr)[j][i] & 0xff)]; // BUG: C compiler will SEXT when casting to int; take 2LSB only
			(matAddr)[j][i] = (tmp);
		}
	}
}
// help function ShiftRows; input: to 2d array ptr
void ShiftRows(unsigned char** matAddr){
	unsigned char tmp;

	for(int i = 0; i < 4; i++){
		for(int j = 0; j < i; j++){
			tmp = (matAddr)[i][0];
			for (int k = 1; k < 4; k++){
				(matAddr)[i][k-1] = (matAddr)[i][k];
			}
			(matAddr)[i][3] = tmp;
		}
	}
}
// helper function
unsigned char xtime(int ord, unsigned char base){
	if (ord==1)
		return base;
	else if (ord==2)
		return gf_mul[((int)(base & 0xff))][0];
	else if(ord==3)
		return gf_mul[((int)(base & 0xff))][1];
	else if(ord==9)
		return gf_mul[((int)(base & 0xff))][2];
	else if(ord==0x0b)
		return gf_mul[((int)(base & 0xff))][3];
	else if(ord==0x0d)
		return gf_mul[((int)(base & 0xff))][4];
	else if(ord==0x0e)
		return gf_mul[((int)(base & 0xff))][5];
	else{
		printf("Invalid ord");
		return 0x00;
	}
}
// helkper function
void MixColumns(unsigned char** matAddr){
	int coeff[4][4] = {{2,3,1,1}, {1,2,3,1}, {1,1,2,3}, {3,1,1,2}};
	unsigned char sum;
	unsigned char matInit[4][4]; // deep copy of mat
	for(int a = 0; a < 4; a++){ // col
		for (int b = 0; b < 4; b++){ // row
			matInit[a][b] = (matAddr)[a][b];
		}
	}
	for(int j = 0; j < 4; j++){ // col
		for (int i = 0; i < 4; i++){ // row
			sum = (xtime(coeff[i][0], matInit[0][j]));
			for(int k = 1; k < 4; k++){
				sum ^= xtime(coeff[i][k], matInit[k][j]);
			}
			(matAddr)[i][j] = sum;
		}
	}
}
// helper function
void AddRoundKey(unsigned char** matAddr, unsigned char** RoundKey){
	for(int i = 0; i < 4; i++){
		for(int j = 0; j < 4; j++){
			(matAddr)[i][j] ^= RoundKey[i][j];
		}
	}
}

// helper function
void KeyExpansion(unsigned char** keyAddr, int round_){
	// step1 : RotWord
	uchar Rconed[4];
	for(int i = 1; i < 4; i++){
		Rconed[i-1] = (keyAddr)[i][3];
	}
	Rconed[3] = (keyAddr)[0][3];
	// step2: SubBytes
	for(int i = 0; i < 4; i++){
		Rconed [i] = aes_sbox[ (int)(Rconed [i] & 0xff)];
	}
	// step3: xor x/ rcon
	for(int i = 0; i < 4; i++){
		(keyAddr)[i][4] = keyAddr[i][0] ^ Rconed[i] ^ ((Rcon[round_] >> 4*(6-2*i)) & 0x0ff);
	}
	// step4: Remaining cols
	for(int j = 5; j < 8; j++){
		for(int i = 0; i < 4; i++){
			(keyAddr)[i][j] = (keyAddr)[i][j-1] ^ (keyAddr)[i][j-4];
		}
	}
	// step5: Prev = Curr, Curr = 0
	for(int i = 0; i < 4; i++){
		for(int j = 0; j < 4; j++){
			(keyAddr)[i][j] = (keyAddr)[i][j+4];
		}
	}
	for(int i = 0; i < 4; i++){
		for(int j = 4; j < 8; j++){
			(keyAddr)[i][j] = 0xff;
		}
	}
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
	int round = 1;
	uint sumKey;
	// Implement this function
	// 2d array-dynamic allocation
	// read plaintext
	unsigned char** mat = malloc(4*sizeof(unsigned char*));
	for(int k = 0; k < 4; k++){
		mat[k] = malloc(4*sizeof(unsigned char));
	}
	int cnt = 0;
	for(int i = 0; i < 4; i++){
		for (int j = 0; j < 4; j++){
			// col major store msg_ascii
			// interprete as plain ascii should match input
			mat[j][i] = charsToHex(msg_ascii[cnt], msg_ascii[cnt+1]);
			cnt +=2;
		}
	}
	// read RoundKey
	unsigned char** RKey = malloc(4*sizeof(unsigned char*));
	for(int k = 0; k < 4; k++){
		RKey[k] = malloc(8*sizeof(unsigned char));
	}
	cnt = 0;
	for(int i = 0; i < 4; i++){
		sumKey = 0;
		for (int j = 0; j < 4; j++){
			// col major store msg_ascii
			// interprete as plain ascii should match input
			RKey[j][i] = charsToHex(key_ascii[cnt], key_ascii[cnt+1]);
			sumKey += RKey[j][i] << (4*(6-2*j));
			cnt +=2;
		}
		key[i] = sumKey;
	}
	// Operation:
	AddRoundKey(mat, RKey);
	for (int i = 0; i < 9; i++){
		SubBytes(mat);
		ShiftRows(mat);
		MixColumns(mat);
		KeyExpansion(RKey, round);
		AddRoundKey(mat, RKey);
		round++;
	}
	SubBytes(mat);
	ShiftRows(mat);
	KeyExpansion(RKey, round);
	AddRoundKey(mat, RKey);
	round++;
	// store
	uint sumMat;
	//uint sumKey;
	for(int i = 0; i < 4; i++){
		sumMat = 0;
		//sumKey = 0;
		for (int j = 0; j < 4; j++){
			// col major store msg_ascii
			// interprete as plain ascii should match input
			sumMat += mat[j][i] << (4*(6-2*j));
			//sumKey += RKey[j][i] << (4*(6-2*j));
		}
		msg_enc[i] = sumMat;
		//key[i] = sumKey;
	}
	// unfreed memory
}
// helper function
void InvSubBytes(unsigned char** mat_){
	for(int i = 0; i < 4; i++){
		for(int j = 0; j < 4; j++){
			mat_[j][i] = aes_invsbox[ (int) ((mat_)[j][i] & 0xff)];
		}
	}
}
// helper function
void InvShiftRows(unsigned char** mat_){
	unsigned char tmp;
	for(int i = 0; i < 4; i++){
		for(int j = 0; j < i; j++){
			tmp = (mat_)[i][3];
			for (int k = 2; k >= 0; k--){
				(mat_)[i][k+1] = (mat_)[i][k];
			}
			(mat_)[i][0] = tmp;
		}
	}
}

// helper function
void InvMixColumns(unsigned char** mat_){
	int coeff[4][4] = {	{0x0e,0x0b,0x0d,0x09},
											{0x09,0x0e,0x0b,0x0d},
											{0x0d,0x09,0x0e,0x0b},
											{0x0b,0x0d,0x09,0x0e}};
	unsigned char sum;
	unsigned char matInit[4][4]; // deep copy of mat
	for(int a = 0; a < 4; a++){ // col
		for (int b = 0; b < 4; b++){ // row
			matInit[a][b] = (mat_)[a][b];
		}
	}
	for(int j = 0; j < 4; j++){ // col
		for (int i = 0; i < 4; i++){ // row
			sum = (xtime(coeff[i][0], matInit[0][j]));
			for(int k = 1; k < 4; k++){
				sum ^= xtime(coeff[i][k], matInit[k][j]);
			}
			(mat_)[i][j] = sum;
		}
	}
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

	printf("%x\n",*msg_enc);
	AES_PTR[14] = 0;
	AES_PTR[15] = 0;

	AES_PTR[0]=key[0];
	AES_PTR[1]=key[1];
	AES_PTR[2]=key[2];
	AES_PTR[3]=key[3];
	AES_PTR[4]=msg_enc[0];
	AES_PTR[5]=msg_enc[1];
	AES_PTR[6]=msg_enc[2];
	AES_PTR[7]=msg_enc[3];
	printf("%x\n",AES_PTR[4]);
	printf("%x\n",AES_PTR[14]);
	printf("%x\n",AES_PTR[15]);
	AES_PTR[14]=1;
	printf("%x\n",AES_PTR[14]);
	while(AES_PTR[15]==0){
		//printf("%x\n",AES_PTR[4]);
	}
	printf("%x\n",AES_PTR[15]);
	msg_dec[0]=AES_PTR[8];
	msg_dec[1]=AES_PTR[9];
	msg_dec[2]=AES_PTR[10];
	msg_dec[3]=AES_PTR[11];
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
			AES_PTR[7] = msg_enc[3];
			AES_PTR[1] = key[1];
			AES_PTR[0] = key[0];

			AES_PTR[2] = key[2];
			AES_PTR[3] = key[3];
			AES_PTR[4] = msg_enc[0];
			AES_PTR[5] = msg_enc[1];
			AES_PTR[6] = msg_enc[2];

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
		AES_PTR[0] = 0XDEADBEEF;
			if(AES_PTR[0] != 0xDEADBEEF){
				printf("Error!");
				printf("%x",AES_PTR[0]);
			}
	}

	return 0;
}
