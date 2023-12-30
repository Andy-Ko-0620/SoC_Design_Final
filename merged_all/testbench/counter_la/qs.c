#include <defs.h>

#define SIZE_0 10
int A[SIZE_0] = {893, 40, 3233, 4267, 2669, 2541, 9073, 6023, 5681, 4622};

int outputsignal_qs[SIZE_0];

#define reg_fir_control  (*(volatile uint32_t*)0x30200000)
#define reg_fir_data_len (*(volatile uint32_t*)0x30200010)
#define reg_fir_coeff    (*(volatile uint32_t*)0x30200040)
#define reg_fir_x        (*(volatile uint32_t*)0x30200080)
#define reg_fir_y        (*(volatile uint32_t*)0x30200084)

void __attribute__ ( ( section ( ".mprjram" ) ) ) initqs() {
	
	for (int i = 0; i < SIZE_0; i++)
	{
		// uint32_t* tmp = *(uint32_t *)(reg_fir_coeff + i);
		*(uint32_t *)(&reg_fir_coeff + i) = A[i];
	}

	reg_fir_data_len = SIZE_0;
}

int* __attribute__ ( ( section ( ".mprjram" ) ) ) qsort(){
	// initqs();
	reg_mprj_datal = 0xAB500000;
	while (reg_fir_control & 4 == 0) continue; //Fir is not idle
	reg_fir_control = 1; //start
	
	for (int i = 0; i < SIZE_0; i++)
	{
		reg_fir_x = 5;//inputsignal[i];
		outputsignal_qs[i] = reg_fir_y;
	}
	return outputsignal_qs;
}
	
