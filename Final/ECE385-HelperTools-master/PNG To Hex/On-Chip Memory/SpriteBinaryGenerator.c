/* SpriteParser.c - Parses the t files from matlab into an MIF file format
 */

#include <stdio.h>
#include <stdlib.h>

#define INPUT_FILE "sprite_bytes/Char1.txt"			// Input filename
#define OUTPUT_FILE "Char0.ram"		// Name of file to output to
#define NUM_COLORS 	16								// Total number of different colors
#define WIDTH		8
#define DEPTH		3072

// Use this to define value of each color in the palette
const long Palette_Colors []= {0xFF00FF, 0x001000, 0xFF4629, 0xE6EFDA, 0x9CFF1F, 0x6BCA67, 0x8CA5BD, 0x082577, 0xA9BDC5, 0x3B5D66, 0xFBC00C, 0x6C6D71, 0xCAB580,  0x88674E, 0x634E52, 0x000009};
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
