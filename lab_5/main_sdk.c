#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "myip.h"
#include "sleep.h"
#include <stdio.h>

#define BaseAddress 0x43C00000 //from Address Editor

const unsigned test_values[12] = {8,4,34,6,50,9,31,7,12,42,17,15};

void fir_reset(){
	MYIP_mWriteReg(BaseAddress, 0, (u32)1);
	sleep(1);
}

void send_fir_data(unsigned x){
	//swap from valid_in 0 -> 1 to detect rising edge
	//LSB: valid_in, MSB: rst
	unsigned A;
	A = ((0<<1) | (x<<2)) & 0xfffffffe;
	MYIP_mWriteReg(BaseAddress, 0, (u32)A);
	sleep(1);
	A = ((1<<1) | (x<<2)) & 0xfffffffe;
	MYIP_mWriteReg(BaseAddress, 0, (u32)A);
}

unsigned get_fir_data(){
	unsigned B,y;
	unsigned valid_out = 0;
	while (valid_out==0){
		B = MYIP_mReadReg(BaseAddress, 4);
		valid_out = B & (0x01);
		printf("Calculating result...\n");
	}
	y = (B>>1) & (0x00ffffff);
	return y;
}

int main()
{
    init_platform();
    unsigned x,y,i;

    while(1){
		printf("Initializing FIR\n\n");
		fir_reset();

		for (i=0; i<12; i++){
			x = test_values[i];
			send_fir_data(x);
			printf("Input data x: %u\n",x);
			sleep(1);
			y = get_fir_data();
			printf("Ready y = %u\n\n", y);
		}
    }
    cleanup_platform();
    return 0;
}
