/* SpriteParser.c - Parses the t files from matlab into an MIF file format
 */

#include <stdio.h>
#include <stdlib.h>

#define INPUT_FILE "sprite_bytes/testImageVertical.txt"			// Input filename
#define OUTPUT_FILE "testImageVertical.ram"		// Name of file to output to
#define NUM_COLORS 	16								// Total number of different colors
#define WIDTH		8
#define DEPTH		3072

// Use this to define value of each color in the palette
const long Palette_Colors []= {0x000000, 0xFBEE13, 0x08A9ED, 0xED028F,0x111111, 0x111115, 0x111125, 0x111113, 0x111117, 0x111116, 0x111145, 0x114514, 0x111167, 0x111190, 0x111178, 0x111166};
int addr = 0;

int main()
{
	char line[21];
	FILE *in = fopen(INPUT_FILE, "r");
	FILE *out = fopen(OUTPUT_FILE, "w");
	size_t num_chars = 20;
	long value = 0;
	int i;
	int *p;

	if(!in)
	{
		printf("Unable to open input file!");
		return -1;
	}

	// Get a line, convert it to an integer, and compare it to the palette values.
	while(fgets(line, num_chars, in) != NULL)
	{
		value = (char)strtol(line, NULL, 10);
		p = (int *)&value;
		fwrite(p, 2, 1, out);
	}

	fclose(out);
	fclose(in);
	return 0;
}
