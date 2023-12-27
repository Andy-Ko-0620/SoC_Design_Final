#include "matmul.h"

int* __attribute__ ( ( section ( ".mprjram" ) ) ) matmul()
{
	// int i=0;
	// int j;
	// int k;
	// int sum;
	// int kk;
	// unsigned int count = 0;
	// for (i=0; i<SIZE; i++){
	// 	for (j=0; j<SIZE; j++){
	// 		sum = 0;
	// 		for(k = 0;k<SIZE;k++)
	// 			sum += A[(i*SIZE) + k] * B[(k*SIZE) + j];
	// 		result[(i*SIZE) + j] = sum;
	// 	}
	// }
	// return result;
	// while (reg_fir_control & 4 == 0) continue;
	while (reg_fir_control & 4 == 0) continue;
	reg_fir_control = 1; //set ap_start, bit[0] = 1
    
	uint8_t  register i=0;
	while(i<64){
	       
	    //while((reg_fir_control >> 4) & 1 !=1); // external signal x[n] ready, wait until bit[4] = 1
	    //while((reg_fir_control & 0x10 )==0);
		//reg_fir_x = i;
		// if(i<SIZE*SIZE)
		// 	reg_fir_x = B[i];
		// else
		// 	reg_fir_x = 0;
		int input_x = (i<16) ? B[i] : 0;
		reg_fir_x = input_x;
		//while((reg_fir_control >> 5) & 1!=1); // external signal y[n] ready, wait until bit[5] = 1

		result[i] = reg_fir_y;

		i=i+1;
		
	}
	// while((reg_fir_control >> 1) & 1 != 1); // read ap_done, bit[1] = 1
	return result;
}
