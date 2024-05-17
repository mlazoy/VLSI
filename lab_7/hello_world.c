#include <stdio.h>
#include <stdint.h>
#include <sleep.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xparameters_ps.h"
#include "xaxidma.h"
#include "xtime_l.h"

#define TX_DMA_ID                 XPAR_PS2PL_DMA_DEVICE_ID
#define TX_DMA_MM2S_LENGTH_ADDR  (XPAR_PS2PL_DMA_BASEADDR + 0x28) // Reports actual number of bytes transferred from PS->PL (use Xil_In32 for report)

#define RX_DMA_ID                 XPAR_PL2PS_DMA_DEVICE_ID
#define RX_DMA_S2MM_LENGTH_ADDR  (XPAR_PL2PS_DMA_BASEADDR + 0x58) // Reports actual number of bytes transferred from PL->PS (use Xil_In32 for report)

#define TX_BUFFER (XPAR_DDR_MEM_BASEADDR + 0x08000000) // 0 + 128MByte
#define RX_BUFFER (XPAR_DDR_MEM_BASEADDR + 0x10000000) // 0 + 256MByte

/* User application global variables & defines */

int main()
{
	//so that the data is also directly changed for the ddr ram too, not only for the cache
	Xil_DCacheDisable();

	XTime preExecCyclesFPGA = 0;
	XTime postExecCyclesFPGA = 0;
	XTime preExecCyclesSW = 0;
	XTime postExecCyclesSW = 0;

	print("HELLO 1\r\n");
	// User application local variables
	int N = 16;
	u8 *input_buffer;
	u32 *output_buffer;

	//initiliazing pointer to the defined addresses
	input_buffer = (u8 *)TX_BUFFER; //8bit data, one pixel to the fpga
	output_buffer = (u32 *)RX_BUFFER; //32bit data, out 3 pixels from the fpga

	const char *filename = "bayer16x16_2024.txt"; // Replace with your filename
	FILE *file = fopen(filename, "r");
	if (file == NULL) {
		perror("Failed to open file");
		return -1;
	}

	for (int i = 0; i < N; i++) {
		for (int j = 0; j < N; j++) {
			if (fscanf(file, "%hhu", &input_buffer[i*N+j]) != 1) {
				fprintf(stderr, "Error reading number from file\n");
				fclose(file);
				return -1;
			}
		}
	}

	fclose(file);


	init_platform();

    // Step 1: Initialize TX-DMA Device (PS->PL)
	XAxiDma_Config *ps2pl_config;
	XAxiDma ps2pl_dma;

	ps2pl_config = XAxiDma_LookupConfigBaseAddr(XPAR_PS2PL_DMA_BASEADDR);
	//if device address not found returns nullptr
	if (!ps2pl_config) {
		xil_printf("error creating configuration for tx_dma\n");
		return -1;
	}
	int tx_dma_init = XAxiDma_CfgInitialize(&ps2pl_dma, ps2pl_config);
	if (tx_dma_init != XST_SUCCESS) {
		xil_printf("error initiliazing for tx_dma\n");
		return -1;
	}

	xil_printf("Initialized TX-DMA DEVICE successfully\n");

    // Step 2: Initialize RX-DMA Device (PL->PS)
	XAxiDma_Config *pl2ps_config;
	XAxiDma pl2ps_dma;

	pl2ps_config = XAxiDma_LookupConfigBaseAddr(XPAR_PL2PS_DMA_BASEADDR);
	if (!pl2ps_config) {
		xil_printf("error creating configuration for rx_dma\n");
		return -1;
	}
	int rx_dma_init = XAxiDma_CfgInitialize(&pl2ps_dma, pl2ps_config);
	if (rx_dma_init != XST_SUCCESS) {
		xil_printf("error initiliazing for tx_dma\n");
		return -1;
	}

	xil_printf("Initialized RX-DMA DEVICE successfully\n");


    XTime_GetTime(&preExecCyclesFPGA);
    // Step 3 : Perform FPGA processing
    //      3a: Setup RX-DMA transaction

    int status = XAxiDma_SimpleTransfer(&pl2ps_dma, (u32)output_buffer, sizeof(u32)*N*N, XAXIDMA_DEVICE_TO_DMA);
    if (status != XST_SUCCESS) {
    		xil_printf("error when trying to set up read to dma\n");
    		return -1;
    }

    xil_printf("Successfully setup to read from dma\n");

    //      3b: Setup TX-DMA transaction

    status = XAxiDma_SimpleTransfer(&ps2pl_dma, (u32)input_buffer, sizeof(u8)*N*N, XAXIDMA_DMA_TO_DEVICE);
	if (status != XST_SUCCESS) {
		xil_printf("error when trying to send data to dma\n");
		return -1;
	}

	xil_printf("Successfully tried to sent the pixels to dma\n");

    //      3c: Wait for TX-DMA & RX-DMA to finish

	//if they are busy they are not done sending and receiving
	while (XAxiDma_Busy(&ps2pl_dma, XAXIDMA_DMA_TO_DEVICE)) {}
	xil_printf("Transfered all pixels\n");
	while (XAxiDma_Busy(&pl2ps_dma, XAXIDMA_DEVICE_TO_DMA)) {}
	xil_printf("Received all pixels\n");

	int sent = Xil_In32(TX_DMA_MM2S_LENGTH_ADDR), received = Xil_In32(RX_DMA_S2MM_LENGTH_ADDR);
	xil_printf("Sent %d bytes to pl, received %d bytes from pl which means %d pixels received\n", sent, received, received / 4);

    XTime_GetTime(&postExecCyclesFPGA);



    XTime_GetTime(&preExecCyclesSW);
    // Step 5: Perform SW processing
    uint8_t *output_R = (uint8_t *)malloc(N*N*sizeof(uint8_t));
	uint8_t *output_G = (uint8_t *)malloc(N*N*sizeof(uint8_t));
	uint8_t *output_B = (uint8_t *)malloc(N*N*sizeof(uint8_t));
	uint8_t grid00, grid01, grid02, grid10, grid11, grid12, grid20, grid21, grid22;
	for(int i = 0; i < N; ++i) {
		for(int j = 0; j < N; ++j) {
			//make the proper grid, so that out of bounds pixels are assumed to be equal to 0
			if (i > 0 && j > 0) grid00 = input_buffer[(i-1)*N+(j-1)]; else grid00 = 0;
			if (i > 0) grid01 = input_buffer[(i-1)*N+j]; else grid01 = 0;
			if (i > 0 && j <(N-1)) grid02 = input_buffer[(i-1)*N+(j+1)]; else grid02 = 0;
			if (j > 0) grid10 = input_buffer[i*N+(j-1)]; else grid10 = 0;
			grid11 = input_buffer[i*N+j];
			if (j < (N-1)) grid12 = input_buffer[i*N+(j+1)]; else grid12 = 0;
			if (i < (N-1) && j > 0) grid20 = input_buffer[(i+1)*N+(j-1)]; else grid20 = 0;
			if (i < (N-1)) grid21 = input_buffer[(i+1)*N+j]; else grid21 = 0;
			if (i < (N-1) && j < (N-1)) grid22 = input_buffer[(i+1)*N+(j+1)]; else grid22 = 0;

			//check in which case of the debayering filter i am in
			if (i%2 == 0 && j%2 == 0) { //case ii
				output_R[i*N+j] = (grid01 + grid21) / 2;
				output_G[i*N+j] = grid11;
				output_B[i*N+j] = (grid10 + grid12) / 2;
			}
			else if (i%2 == 0 && j%2 == 1) { //case iv
				output_R[i*N+j] = (grid00 + grid02 + grid20 + grid22) / 4;
				output_G[i*N+j] = (grid01 + grid10 + grid12 + grid21) / 4;
				output_B[i*N+j] = grid11;
			}
			else if (i%2 == 1 && j%2 == 0) { //case iii
				output_R[i*N+j] = grid11;
				output_G[i*N+j] = (grid01 + grid10 + grid12 + grid21) / 4;
				output_B[i*N+j] = (grid00 + grid02 + grid20 + grid22) / 4;
			}
			else if (i%2 == 1 && j%2 == 1) { // case i
				output_R[i*N+j] = (grid10 + grid12) / 2;
				output_G[i*N+j] = grid11;
				output_B[i*N+j] = (grid01 + grid21) / 2;
			}
			else {
				output_R[i*N+j] = 0;
				output_G[i*N+j] = 0;
				output_B[i*N+j] = 0;
			}
		}
	}

    XTime_GetTime(&postExecCyclesSW);

    xil_printf("Software completed calculating the results as well\n");

    // Step 6: Compare FPGA and SW results
    //     6a: Report total percentage error
    uint8_t hardware_R, hardware_G, hardware_B;
    int errors = 0;
    for(int i = 0; i < N*N; ++i) {
    	hardware_R = (output_buffer[i] & 0x00FF0000) >> 16;
    	hardware_G = (output_buffer[i] & 0x0000FF00) >> 8;
    	hardware_B = (uint8_t) (output_buffer[i] & 0x000000FF);
    	if (output_R[i] == hardware_R && output_G[i] == hardware_G && output_B[i] == hardware_B) continue;
    	else ++errors;
    }
    double error_per = (errors * 1.0 / (N*N))*100;
    xil_printf("Total Percentage Error: %f\n", error_per);

    //     6b: Report FPGA execution time in cycles (use preExecCyclesFPGA and postExecCyclesFPGA)
    int fpga_cycles = postExecCyclesFPGA - preExecCyclesFPGA;
    xil_printf("FPGA cycles: %d\n", fpga_cycles);

    //     6c: Report SW execution time in cycles (use preExecCyclesSW and postExecCyclesSW)
    int software_cycles = postExecCyclesSW - preExecCyclesSW;
    xil_printf("Software cycles: %d\n", software_cycles);

    //     6d: Report speedup (SW_execution_time / FPGA_exection_time)
    double speedup = (software_cycles*1.0) / fpga_cycles;
    xil_printf("Speedup: %d\n", speedup);

    cleanup_platform();
    return 0;
}
