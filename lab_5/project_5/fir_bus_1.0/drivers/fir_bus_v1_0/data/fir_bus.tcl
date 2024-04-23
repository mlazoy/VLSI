

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "fir_bus" "NUM_INSTANCES" "DEVICE_ID"  "C_CPU_AXI_BASEADDR" "C_CPU_AXI_HIGHADDR" "C_FIR_AXI_BASEADDR" "C_FIR_AXI_HIGHADDR"
}
