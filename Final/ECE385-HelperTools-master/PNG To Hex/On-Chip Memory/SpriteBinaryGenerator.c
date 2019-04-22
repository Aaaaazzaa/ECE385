/* SpriteParser.c - Parses the t files from matlab into an MIF file format
 */

#include <stdio.h>
#include <stdlib.h>

#define INPUT_FILE "sprite_bytes/NpcBllg2.txt"			// Input filename
#define OUTPUT_FILE "NPC.ram"		// Name of file to output to
#define NUM_COLORS 	16								// Total number of different colors
#define WIDTH		8
#define DEPTH		3072

// Use this to define value of each color in the palette
const long Palette_Colors []= {0xFF00FF, 0x9C2E99, 0x5E2464, 0xB4C3EB, 0xF2C571, 0xA9814A, 0xDAEFDE,0x294656, 0xA9BDC5, 0x000003, 0x000004, 0x000005, 0x000006,  0x000007, 0x000008, 0x000009};
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
