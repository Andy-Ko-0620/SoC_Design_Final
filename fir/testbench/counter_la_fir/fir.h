#ifndef __FIR_H__
#define __FIR_H__

#define N 11
#define N_IN 64
#include <defs.h>

int taps[N] = {0,-10,-9,23,56,63,56,23,-9,-10,0};
// int inputbuffer[N];
int inputsignal[N_IN];
int outputsignal[N_IN];

#define reg_fir_control  (*(volatile uint32_t*)0x30000000)
#define reg_fir_data_len (*(volatile uint32_t*)0x30000010)
#define reg_fir_coeff    (*(volatile uint32_t*)0x30000040)
#define reg_fir_x        (*(volatile uint32_t*)0x30000080)
#define reg_fir_y        (*(volatile uint32_t*)0x30000084)

#endif
