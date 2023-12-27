#include "fir.h"

void __attribute__ ( ( section ( ".mprjram" ) ) ) initfir() {
	//initial your fir
	for (int i = 0; i < N_IN; i++)
	{
		inputsignal[i] = i;
	}
	
	for (int i = 0; i < N; i++)
	{
		// uint32_t* tmp = *(uint32_t *)(reg_fir_coeff + i);
		*(uint32_t *)(&reg_fir_coeff + i) = taps[i];
	}

	reg_fir_data_len = N_IN;
}

int* __attribute__ ( ( section ( ".mprjram" ) ) ) fir(){
	initfir();
	while (reg_fir_control & 4 == 0) continue; //Fir is not idle
	reg_fir_control = 1; //start
	
	for (int i = 0; i < N_IN; i++)
	{
		reg_fir_x = inputsignal[i];
		outputsignal[i] = reg_fir_y;
	}

	//write down your fir
	// for (int j = 0; j < N; j++)
	// {
	// 	for (int k = N - 1; k > 0; k--)
	// 	{
	// 		inputbuffer[k] = inputbuffer[k-1];
	// 	}
	// 	inputbuffer[0] = inputsignal[j];
	// 	outputsignal[j] = 0;
	// 	for (int m = 0; m < N; m++)
	// 	{
	// 		outputsignal[j] += inputbuffer[m] * taps[m];
	// 	}
	// }
	
	return outputsignal;
}
		
