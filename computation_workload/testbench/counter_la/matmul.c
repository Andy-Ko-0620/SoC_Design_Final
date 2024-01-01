#include <stdint.h>
#include <stdbool.h>

#define N 16
int inputsignal[N] = {13, 9, 5, 1,
             		  14, 10, 6, 2,
             		  15, 11, 7, 3,
             		  16, 12, 8, 4};

int taps[11] = {0,1,2,3,0,0,0,0,0,0,0};
int outputsignal[N];
// AP control
// #define reg_mm_control (*(volatile uint32_t*)0x30000000)
// // FIR input X, FIR output Y
// #define reg_mm_x (*(volatile uint32_t*)0x30000080)
// #define reg_mm_y (*(volatile uint32_t*)0x30000084)
// // data len = 64
// #define reg_mm_len (*(volatile uint32_t*)0x30000010)
// // TAP coeff
// #define reg_mm_coeff    (*(volatile uint32_t*)0x30000020)
#define reg_mm_control (*(volatile uint32_t*)0x30100000)
// FIR input X, FIR output Y
#define reg_mm_x (*(volatile uint32_t*)0x30100080)
#define reg_mm_y (*(volatile uint32_t*)0x30100084)
// data len = 64
#define reg_mm_len (*(volatile uint32_t*)0x30100010)
// TAP coeff
#define reg_mm_coeff    (*(volatile uint32_t*)0x30100020)
// #define reg_mm_coeff0  (*(volatile uint32_t*)0x30000020)
// #define reg_mm_coeff1  (*(volatile uint32_t*)0x30000024)
// #define reg_mm_coeff2  (*(volatile uint32_t*)0x30000028)
// #define reg_mm_coeff3  (*(volatile uint32_t*)0x3000002c)
// #define reg_mm_coeff4  (*(volatile uint32_t*)0x30000030)
// #define reg_mm_coeff5  (*(volatile uint32_t*)0x30000034)
// #define reg_mm_coeff6  (*(volatile uint32_t*)0x30000038)
// #define reg_mm_coeff7  (*(volatile uint32_t*)0x3000003c)
// #define reg_mm_coeff8  (*(volatile uint32_t*)0x30000040)
// #define reg_mm_coeff9  (*(volatile uint32_t*)0x30000044)
// #define reg_mm_coeff10 (*(volatile uint32_t*)0x30000048)

void __attribute__ ( ( section ( ".mprjram" ) ) ) initmm(){
	// write fir data length
	reg_mm_len = N;
	// write fir tap coef
	for (int i = 0; i < 11; i++)
	{
		// uint32_t* tmp = *(uint32_t *)(reg_mm_coeff + i);
		*(uint32_t *)(&reg_mm_coeff + i) = taps[i];
	}
	// reg_mm_coeff0 	= 0;
	// reg_mm_coeff1 	= 1;
	// reg_mm_coeff2 	= 2;
	// reg_mm_coeff3 	= 3;
	// reg_mm_coeff4 	= 0;
	// reg_mm_coeff5 	= 0;
	// reg_mm_coeff6 	= 0;
	// reg_mm_coeff7 	= 0;
	// reg_mm_coeff8 	= 0;
	// reg_mm_coeff9 	= 0;
	// reg_mm_coeff10 = 0;

}

int* __attribute__ ( ( section ( ".mprjram" ) ) ) matmul(){ 
	// initial first
	// initfir();
	uint8_t  register i=0;
	reg_mm_control = 1; //set ap_start, bit[0] = 1

    reg_mm_x = inputsignal[0];
	
	while(i<N-1){
	       
	        //while((reg_mm_control >> 4) & 1 !=1); // external signal x[n] ready, wait until bit[4] = 1
	      //while((reg_mm_control & 0x10 )==0);
		//reg_mm_x = i;
		
		//while((reg_mm_control >> 5) & 1!=1); // external signal y[n] ready, wait until bit[5] = 1
		outputsignal[i] = reg_mm_y;
		i=i+1;
		reg_mm_x = inputsignal[i];
	}
	outputsignal[N-1] = reg_mm_y;
	while((reg_mm_control >> 1) & 1 != 1); // read ap_done, bit[1] = 1

	// return &outputsignal[62];
	return outputsignal;
}

		
