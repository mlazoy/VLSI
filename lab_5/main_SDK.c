/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "myip.h"
#include "sleep.h"

#define BaseAddress 0x43C00000

const unsigned test_values[12] = {8,4,34,6,50,9,31,7,12,42,17,15};

void send_fir_data(unsigned x){
	//swap from valid_0 -> valid_in to detect rising edge
	unsigned A;
	unsigned valid_in = 0;
	A = valid_in | (x<<1);
	MYIP_mWriteReg(BaseAddress, 0, A);
	printf("Input data A: %u\n",A);
	valid_in = 1;
	A = valid_in | (x<<1);
	MYIP_mWriteReg(BaseAddress, 0, A);
	printf("Input data A: %u\n",A);
}

unsigned get_fir_data(){
	unsigned B,y;
	unsigned valid_out = 0;
	while (valid_out==0){
		B = MYIP_mReadReg(BaseAddress, 4);
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

    for (i=0; i<12; i++){
    	x = test_values[i];
    	send_fir_data(x);
    	y = get_fir_data();
    	printf("Ready y = %u\n", y);

    }


    return 0;
}
