#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "fir_axi.h"
#include "sleep.h"
#include <stdio.h>

#define BaseAddress 0x43C00000

const unsigned test_values[12] = {8,4,34,6,50,9,31,7,12,42,17,15};

void fir_reset(){
	FIR_AXI_mWriteReg(BaseAddress, 0, 0);
	sleep(1);
}

void send_fir_data(unsigned x){
	//swap from valid_0 -> valid_in to detect rising edge
	unsigned A;
	unsigned valid_in = 0, reset = 0;
	A = reset | (valid_in <<1) | (x<<2);
	printf("Input data A: %u\n",A);
	FIR_AXI_mWriteReg(BaseAddress, 0, A);
	valid_in = 1;
	A = reset | (valid_in<<1) | (x<<2);
	FIR_AXI_mWriteReg(BaseAddress, 0, A);
	printf("Input data A: %u\n",A);
}

unsigned get_fir_data(){
	unsigned B,y;
	unsigned valid_out = 0;
	while (valid_out==0){
		B = FIR_AXI_mReadReg(BaseAddress, 4);
		valid_out = B & (0x01);
		y = (B>>1) & (0x00ffffff);
		printf("Calculating result...%u\n",y);
	}
	//y = (B>>1) & (0x00ffffff);
	return y;
}

int main()
{
    init_platform();

    print("Hello World\n\r");

    unsigned x,y,i;
    fir_reset();

    for (i=0; i<12; i++){
    	x = test_values[i];
    	send_fir_data(x);
    	y = get_fir_data();
    	printf("Ready y = %u\n", y);
    	sleep(1);
    }

    return 0;
}
