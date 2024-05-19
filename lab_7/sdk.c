#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xparameters_ps.h"
#include "xaxidma.h"
#include "xtime_l.h"

#define TX_DMA_ID                 XPAR_PS2PL_DMA_DEVICE_ID
#define RX_DMA_ID				  XPAR_PL2PS_DMA_DEVICE_ID

#define TX_BASEADDR 			  XPAR_PS2PL_DMA_BASEADDR
#define RX_BASEADDR				  XPAR_PL2PS_DMA_BASEADDR

#define TX_DMA_MM2S_LENGTH_ADDR  (XPAR_PS2PL_DMA_BASEADDR + 0x28) // Reports actual number of bytes transferred from PS->PL (use Xil_In32 for report)
#define RX_DMA_S2MM_LENGTH_ADDR  (XPAR_PL2PS_DMA_BASEADDR + 0x58) // Reports actual number of bytes transferred from PL->PS (use Xil_In32 for report)

#define TX_BUFFER (XPAR_DDR_MEM_BASEADDR + 0x20000000) // 0 + 512MByte
#define RX_BUFFER (XPAR_DDR_MEM_BASEADDR + 0x30000000) // 0 + 768MByte

#define size_N 16
#define PXL_LEN 8

/* User application global variables & defines */
u8 image[size_N][size_N] ;

u8 test_data[] = {
		#include "bayer16x16_sdk.txt"
		};

void read_input(){
	for (unsigned i=0; i<size_N; i++){
		for (unsigned j=0; j<size_N; j++){
			image[i][j] = test_data[i*size_N+j];
		}
	}
}

void print_data(u8 my_arr[size_N][size_N]){
	for (unsigned i=0; i<size_N; i++){
		for (unsigned j=0; j<size_N; j++){
			printf("%huh ",my_arr[i][j]);
		}
		printf("\n");
	}
}

//for cpu processing
u8 grid[3][3];
u32 rgb_values[size_N][size_N];

u32 calc_avg(int row, int pixel){
	u32 R,G,B,rgb_triplet;
	R=G=B=0;
	grid[0][0] = (row>0 && pixel>0) ? image[row-1][pixel-1] : 0;
	grid[0][1] = (row>0) ? image[row-1][pixel] : 0;
	grid[0][2] = (row>0 && pixel<size_N) ? image[row-1][pixel+1] : 0;
	grid[1][0] = (pixel>0) ? image[row][pixel-1] : 0;
	grid[1][1] = image[row][pixel];
	grid[1][2] = (pixel<size_N) ? image[row][pixel+1] : 0;
	grid[2][0] = (row<size_N && pixel>0) ? image[row+1][pixel-1] : 0;
	grid[2][1] = (row<size_N) ? image[row+1][pixel] : 0;
	grid[2][2] = (row<size_N && pixel<size_N) ? image[row+1][pixel+1] : 0;

	if (row%2==0 && pixel%2==0) { 	// case ii
		R = (grid[0][1]+grid[2][1])/2;
		G = grid[1][1];
		B = (grid[1][0]+grid[1][2])/2;
	}
	else if (row%2==0 && pixel%2==1){ // case iv
		R = (grid[0][0]+grid[0][2]+grid[2][0]+grid[2][2])/4;
		G = (grid[0][1]+grid[1][0]+grid[1][2]+grid[2][1])/4;
		B = grid[1][1];
	}
	else if(row%2==1 && pixel%2==0){ // case iii
		R = grid[1][1];
		G = (grid[0][1]+grid[1][0]+grid[1][2]+grid[2][1])/4;
		B = (grid[0][0]+grid[0][2]+grid[2][0]+grid[2][2])/4;
	}
	else if (row%2==1 && pixel%2==1) { //case i
		R = (grid[1][0]+grid[1][2])/2;
		G = grid[1][1];
		B = (grid[0][1]+grid[2][1])/2;
	}
	rgb_triplet = 0x00ffffff & (R<<16 & G<<8 & B);
	return rgb_triplet;
}

void debayer(void){
	for (unsigned i=0; i<size_N; ++i){
		for (unsigned j=0; j<size_N; ++j){
			rgb_values[i][j] = calc_avg(i,j);
		}
	}
}

int main()
{
	Xil_DCacheDisable();

	XTime preExecCyclesFPGA = 0;
	XTime postExecCyclesFPGA = 0;
	XTime preExecCyclesSW = 0;
	XTime postExecCyclesSW = 0;

	print("HELLO 1\r\n");
	// User application local variables

	init_platform();

	//read input from file and print pixels
	read_input();
	print_data(image);

    // Step 1: Initialize TX-DMA Device (PS->PL)
	XAxiDma_Config *tx_dma_conf;
	XAxiDma tx_dma;
	int ret_tx;

	tx_dma_conf = XAxiDma_LookupConfigBaseAddr(TX_BASEADDR);
	if (!tx_dma_conf){
		xil_printf("Error in DMA config\n");
		exit (XST_FAILURE);
	}
	ret_tx = XAxiDma_CfgInitialize(&tx_dma, tx_dma_conf);
	if (ret_tx != XST_SUCCESS){
		xil_printf("Error in initializing DMA\n");
		exit (XST_FAILURE);
	}
	print("TX setup ok\n");
    // Step 2: Initialize RX-DMA Device (PL->PS)
	XAxiDma_Config *rx_dma_conf;
	XAxiDma rx_dma;
	int ret_rx;

	rx_dma_conf = XAxiDma_LookupConfigBaseAddr(RX_BASEADDR);
	if (!rx_dma_conf){
		xil_printf("Error in DMA config\n");
		exit (XST_FAILURE);
	}
	ret_rx = XAxiDma_CfgInitialize(&rx_dma, rx_dma_conf);
	if (ret_rx != XST_SUCCESS){
		xil_printf("Error in initializing DMA\n");
		exit (XST_FAILURE);
	}
	print("RX setup ok\n");

    XTime_GetTime(&preExecCyclesFPGA);
    // Step 3 : Perform FPGA processing
    //      3a: Setup RX-DMA transaction
    //      3b: Setup TX-DMA transaction
    //      3c: Wait for TX-DMA & RX-DMA to finish
    XTime_GetTime(&postExecCyclesFPGA);

    XTime_GetTime(&preExecCyclesSW);
    // Step 5: Perform SW processing
    debayer();
    XTime_GetTime(&postExecCyclesSW);
    //print results
    print_data(rgb_values);

    // Step 6: Compare FPGA and SW results
    //     6a: Report total percentage error
    //     6b: Report FPGA execution time in cycles (use preExecCyclesFPGA and postExecCyclesFPGA)
    //     6c: Report SW execution time in cycles (use preExecCyclesSW and postExecCyclesSW)
    //     6d: Report speedup (SW_execution_time / FPGA_exection_time)

    cleanup_platform();
    return 0;
}
