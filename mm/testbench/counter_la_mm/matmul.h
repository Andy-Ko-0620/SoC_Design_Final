#ifndef _MATMUL_H
#define _MATMUL_H

#define SIZE 4
#include <defs.h>
// int A[SIZE*SIZE] = {0, 1, 2, 3,
// 					0, 1, 2, 3,
// 					0, 1, 2, 3,
// 					0, 1, 2, 3,
// 	};
// int B[SIZE*SIZE] = {1, 2, 3, 4,
// 					5, 6, 7, 8,
// 					9, 10, 11, 12,
// 					13, 14, 15, 16,
// 	};
int B[SIZE*SIZE] = 	  {13, 9, 5, 1,
					   14, 10, 6, 2,
					   15, 11, 7, 3,
					   16, 12, 8, 4};
int result[64];
#define reg_fir_control  (*(volatile uint32_t*)0x30000000)
// #define reg_fir_data_len (*(volatile uint32_t*)0x30000010)
// #define reg_fir_coeff    (*(volatile uint32_t*)0x30000040)
#define reg_fir_x        (*(volatile uint32_t*)0x30000080)
#define reg_fir_y        (*(volatile uint32_t*)0x30000084)

#endif


// tap_ram   = {0,1,2,3,0,0,0,0,0,0,0}
// data_ram  = {4,8,12,16,3,7,11,15,2,6,10,14,1,5,9,13} =>y[3], y[7],y[11],y[15]