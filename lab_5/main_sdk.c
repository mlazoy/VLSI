
#include <stdio.h>
#include <stdlib.h>
#include <sleep.h>
#include <stdint.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "fir_IP.h"

const unsigned test_values[12] = {8,4,34,6,50,9,31,7,12,17,42,15};

int main()
{
    init_platform();

    print("Hello World\n\r");

    unsigned valid_in,x,A;
    unsigned B,y,valid_out;
    unsigned i=0;


    for (i; i<12; i++){
    	x = test_values[i];

    	valid_in = 1;
    	A = valid_in | (x << 1);
    	printf("Input value A: %u\n",A);
    	FIR_IP_mWriteReg(0, 4, A);

    	// give some 0 valid_in input to detect next upcoming edge
    	A = 0;
    	printf("Input value A: %u\n",A);
    	FIR_IP_mWriteReg(0, 4, A);

    	B = FIR_IP_mReadReg(0, 0);
    	valid_out = B & (0x01);

    	while (valid_out == 0){
    		printf("Calculating result...");
    	}
    	y = (B >> 1) & (0x00ffffff);
    	printf("Result: %u\n",y);

    }

    return 0;
}
