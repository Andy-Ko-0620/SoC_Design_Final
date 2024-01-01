#include <stdint.h>
#include <stdbool.h>

#define N_FIR 64

int outputsignal_fir[N_FIR];
// AP control
#define reg_fir_control (*(volatile uint32_t*)0x30000000)

// FIR input X, FIR output Y
#define reg_fir_x (*(volatile uint32_t*)0x30000080)
#define reg_fir_y (*(volatile uint32_t*)0x30000084)
#define reg_fir_len (*(volatile uint32_t*)0x30000010)
// TAP coeff
#define reg_fir_coeff0  (*(volatile uint32_t*)0x30000020)
#define reg_fir_coeff1  (*(volatile uint32_t*)0x30000024)
#define reg_fir_coeff2  (*(volatile uint32_t*)0x30000028)
#define reg_fir_coeff3  (*(volatile uint32_t*)0x3000002c)
#define reg_fir_coeff4  (*(volatile uint32_t*)0x30000030)
#define reg_fir_coeff5  (*(volatile uint32_t*)0x30000034)
#define reg_fir_coeff6  (*(volatile uint32_t*)0x30000038)
#define reg_fir_coeff7  (*(volatile uint32_t*)0x3000003c)
#define reg_fir_coeff8  (*(volatile uint32_t*)0x30000040)
#define reg_fir_coeff9  (*(volatile uint32_t*)0x30000044)
#define reg_fir_coeff10 (*(volatile uint32_t*)0x30000048)

void __attribute__ ( ( section ( ".mprjram" ) ) ) initfir(){
	// write fir data length
	reg_fir_len = N_FIR;
	// write fir tap coef
	reg_fir_coeff0 	= 0;
	reg_fir_coeff1 	= -10;
	reg_fir_coeff2 	= -9;
	reg_fir_coeff3 	= 23;
	reg_fir_coeff4 	= 56;
	reg_fir_coeff5 	= 63;
	reg_fir_coeff6 	= 56;
	reg_fir_coeff7 	= 23;
	reg_fir_coeff8 	= -9;
	reg_fir_coeff9 	= -10;
	reg_fir_coeff10 = 0;
}

int* __attribute__ ( ( section ( ".mprjram" ) ) ) fir(){ 
	// initial first
	// initfir();
	uint8_t  register i=0;
	reg_fir_control = 1; //set ap_start, bit[0] = 1

    reg_fir_x = 0;
	
	while(i<N_FIR-1){
	       
	        //while((reg_fir_control >> 4) & 1 !=1); // external signal x[N_FIR] ready, wait until bit[4] = 1
	      //while((reg_fir_control & 0x10 )==0);
		//reg_fir_x = i;
		
		//while((reg_fir_control >> 5) & 1!=1); // external signal y[N_FIR] ready, wait until bit[5] = 1
		outputsignal_fir[i] = reg_fir_y;
		i=i+1;
		reg_fir_x = i;
	}
	outputsignal_fir[N_FIR-1] = reg_fir_y;
	// while((reg_fir_control >> 1) & 1 != 1); // read ap_done, bit[1] = 1

	return &outputsignal_fir[62];
}

		
