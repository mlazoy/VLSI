#include <stdio.h>
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
	int N = 1024;
	u8 *input_buffer;
	u32 *output_buffer;
	//initiliazing pointer to the defined addresses
	input_buffer = (u8 *)TX_BUFFER; //8bit data, one pixel to the fpga
	output_buffer = (u32 *)RX_BUFFER; //32bit data, out 3 pixels from the fpga


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
    int *r_sw = (int *)malloc(N*N*sizeof(int));
	int *g_sw = (int *)malloc(N*N*sizeof(int));
	int *b_sw = (int *)malloc(N*N*sizeof(int));


    XTime_GetTime(&postExecCyclesSW);

    // Step 6: Compare FPGA and SW results
    //     6a: Report total percentage error
    //     6b: Report FPGA execution time in cycles (use preExecCyclesFPGA and postExecCyclesFPGA)
    //     6c: Report SW execution time in cycles (use preExecCyclesSW and postExecCyclesSW)
    //     6d: Report speedup (SW_execution_time / FPGA_exection_time)

    cleanup_platform();
    return 0;
}
