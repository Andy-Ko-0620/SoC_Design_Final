#ifndef __FIR_H__
#define __FIR_H__

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

#endif
