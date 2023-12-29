#include <defs.h>

// void __attribute__ ( ( section ( ".mprjram" ) ) ) initfir() {
// 	//initial your fir
// 	for (int i = 0; i < N_IN; i++)
// 	{
// 		inputsignal[i] = i;
// 	}
	
// 	for (int i = 0; i < N; i++)
// 	{
// 		// uint32_t* tmp = *(uint32_t *)(reg_fir_coeff + i);
// 		*(uint32_t *)(&reg_fir_coeff + i) = taps[i];
// 	}

// 	reg_fir_data_len = N_IN;
// }
#define N 11
#define N_IN 64
#define SIZE_0 10
int A[SIZE_0] = {893, 40, 3233, 4267, 2669, 2541, 9073, 6023, 5681, 4622};
// int A[SIZE_0] = {31, 12, 13, 14, 15, 16, 17, 18, 19, 20};

int taps[N] = {0,-10,-9,23,56,63,56,23,-9,-10,0};
int inputsignal[N_IN];

#include <defs.h>
int inputbuffer[N];
int outputsignal[SIZE_0];

#define reg_fir_control  (*(volatile uint32_t*)0x30000000)
#define reg_fir_data_len (*(volatile uint32_t*)0x30000010)
#define reg_fir_coeff    (*(volatile uint32_t*)0x30000040)
#define reg_fir_x        (*(volatile uint32_t*)0x30000080)
#define reg_fir_y        (*(volatile uint32_t*)0x30000084)

void __attribute__ ( ( section ( ".mprjram" ) ) ) initqs() {
	
	for (int i = 0; i < SIZE_0; i++)
	{
		// uint32_t* tmp = *(uint32_t *)(reg_fir_coeff + i);
		*(uint32_t *)(&reg_fir_coeff + i) = A[i];
	}

	reg_fir_data_len = SIZE_0;
}

int* __attribute__ ( ( section ( ".mprjram" ) ) ) qsort(){
	initqs();
	// reg_mprj_datal = 0x00A50000;
	while (reg_fir_control & 4 == 0) continue; //Fir is not idle
	reg_fir_control = 1; //start
	
	for (int i = 0; i < SIZE_0; i++)
	{
		reg_fir_x = 5;//inputsignal[i];
		// reg_fir_x = 6;
		outputsignal[i] = reg_fir_y;
	}
	return outputsignal;
}
		

// int* __attribute__ ( ( section ( ".mprjram" ) ) ) qsort(){
// 	// sort(0,SIZE_0-1);
// 	initfir();
// 	while (reg_fir_control & 4 == 0) continue; //Fir is not idle
// 	reg_fir_control = 1; //start
// 	for (int i = 0; i < SIZE_0; i++)
// 	{
// 		reg_fir_x = A[i];
// 	}
// 	for (int i = 0; i < SIZE_0; i++)
// 	{
// 		outputsignal[i] = reg_fir_y;
// 	}
// 	return A;
// }
