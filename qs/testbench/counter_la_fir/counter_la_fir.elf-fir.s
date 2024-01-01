	.file	"fir.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/home/andy/SoC_Design/SoC_Design_Final/qs/testbench/counter_la_fir" "fir.c"
	.section	.mprjram,"ax",@progbits
	.align	2
	.globl	initqs
	.type	initqs, @function
initqs:
.LFB316:
	.file 1 "fir.c"
	.loc 1 37 60
	.cfi_startproc
	.loc 1 39 2
.LBB2:
	.loc 1 39 7
.LVL0:
	.loc 1 39 20
	lui	a5,%hi(.LANCHOR0)
	addi	a4,a5,%lo(.LANCHOR0)
	addi	a1,a4,40
.LBE2:
	.loc 1 37 60 is_stmt 0
	addi	a5,a5,%lo(.LANCHOR0)
.LBB3:
	.loc 1 42 52
	li	a2,805306368
	addi	a2,a2,64
	sub	a2,a2,a4
.LVL1:
.L2:
	.loc 1 42 3 is_stmt 1 discriminator 3
	.loc 1 42 57 is_stmt 0 discriminator 3
	add	a4,a2,a5
	lw	a3,0(a5)
	sw	a3,0(a4)
	.loc 1 39 27 is_stmt 1 discriminator 3
	.loc 1 39 20 discriminator 3
	addi	a5,a5,4
	bne	a5,a1,.L2
.LBE3:
	.loc 1 45 2
	.loc 1 45 36 is_stmt 0
	li	a5,805306368
	li	a4,10
	sw	a4,16(a5)
	.loc 1 46 1
	ret
	.cfi_endproc
.LFE316:
	.size	initqs, .-initqs
	.align	2
	.globl	qsort
	.type	qsort, @function
qsort:
.LFB317:
	.loc 1 48 58 is_stmt 1
	.cfi_startproc
	.loc 1 51 2
	.loc 1 51 9
	.loc 1 51 10 is_stmt 0
	li	a5,805306368
	lw	a4,0(a5)
	.loc 1 52 2 is_stmt 1
	.loc 1 52 36 is_stmt 0
	li	a4,1
	sw	a4,0(a5)
	.loc 1 54 2 is_stmt 1
.LBB4:
	.loc 1 54 7
.LVL2:
	.loc 1 54 20
	lui	a5,%hi(.LANCHOR1)
	addi	a5,a5,%lo(.LANCHOR1)
	addi	a0,a5,40
	.loc 1 56 37 is_stmt 0
	li	a3,805306368
	addi	a1,a3,128
	li	a2,5
.LVL3:
.L5:
	.loc 1 56 3 is_stmt 1 discriminator 3
	.loc 1 56 37 is_stmt 0 discriminator 3
	sw	a2,0(a1)
	.loc 1 58 3 is_stmt 1 discriminator 3
	.loc 1 58 22 is_stmt 0 discriminator 3
	lw	a4,132(a3)
	.loc 1 58 19 discriminator 3
	sw	a4,0(a5)
	.loc 1 54 27 is_stmt 1 discriminator 3
	.loc 1 54 20 discriminator 3
	addi	a5,a5,4
	bne	a5,a0,.L5
.LBE4:
	.loc 1 60 2
	.loc 1 60 9 is_stmt 0
	lui	a0,%hi(.LANCHOR1)
	.loc 1 61 1
	addi	a0,a0,%lo(.LANCHOR1)
	ret
	.cfi_endproc
.LFE317:
	.size	qsort, .-qsort
	.globl	outputsignal
	.globl	inputbuffer
	.globl	inputsignal
	.globl	taps
	.globl	A
	.data
	.align	2
	.set	.LANCHOR0,. + 0
	.type	A, @object
	.size	A, 40
A:
	.word	893
	.word	40
	.word	3233
	.word	4267
	.word	2669
	.word	2541
	.word	9073
	.word	6023
	.word	5681
	.word	4622
	.type	taps, @object
	.size	taps, 44
taps:
	.word	0
	.word	-10
	.word	-9
	.word	23
	.word	56
	.word	63
	.word	56
	.word	23
	.word	-9
	.word	-10
	.word	0
	.bss
	.align	2
	.set	.LANCHOR1,. + 0
	.type	outputsignal, @object
	.size	outputsignal, 40
outputsignal:
	.zero	40
	.type	inputbuffer, @object
	.size	inputbuffer, 44
inputbuffer:
	.zero	44
	.type	inputsignal, @object
	.size	inputsignal, 256
inputsignal:
	.zero	256
	.text
.Letext0:
	.file 2 "/opt/riscv/lib/gcc/riscv32-unknown-elf/12.1.0/include/stdint-gcc.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.4byte	0x151
	.2byte	0x5
	.byte	0x1
	.byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x6
	.4byte	.LASF15
	.byte	0x1d
	.4byte	.LASF0
	.4byte	.LASF1
	.4byte	.LLRL3
	.4byte	0
	.4byte	.Ldebug_line0
	.byte	0x1
	.byte	0x1
	.byte	0x6
	.4byte	.LASF2
	.byte	0x1
	.byte	0x2
	.byte	0x5
	.4byte	.LASF3
	.byte	0x1
	.byte	0x4
	.byte	0x5
	.4byte	.LASF4
	.byte	0x1
	.byte	0x8
	.byte	0x5
	.4byte	.LASF5
	.byte	0x1
	.byte	0x1
	.byte	0x8
	.4byte	.LASF6
	.byte	0x1
	.byte	0x2
	.byte	0x7
	.4byte	.LASF7
	.byte	0x7
	.4byte	.LASF16
	.byte	0x2
	.byte	0x34
	.byte	0x1b
	.4byte	0x5c
	.byte	0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF8
	.byte	0x1
	.byte	0x8
	.byte	0x7
	.4byte	.LASF9
	.byte	0x8
	.byte	0x4
	.byte	0x5
	.string	"int"
	.byte	0x1
	.byte	0x4
	.byte	0x7
	.4byte	.LASF10
	.byte	0x3
	.4byte	0x6a
	.4byte	0x88
	.byte	0x4
	.4byte	0x71
	.byte	0x9
	.byte	0
	.byte	0x9
	.string	"A"
	.byte	0x1
	.byte	0x15
	.byte	0x5
	.4byte	0x78
	.byte	0x5
	.byte	0x3
	.4byte	A
	.byte	0x3
	.4byte	0x6a
	.4byte	0xa8
	.byte	0x4
	.4byte	0x71
	.byte	0xa
	.byte	0
	.byte	0x2
	.4byte	.LASF11
	.byte	0x18
	.4byte	0x98
	.byte	0x5
	.byte	0x3
	.4byte	taps
	.byte	0x3
	.4byte	0x6a
	.4byte	0xc8
	.byte	0x4
	.4byte	0x71
	.byte	0x3f
	.byte	0
	.byte	0x2
	.4byte	.LASF12
	.byte	0x19
	.4byte	0xb8
	.byte	0x5
	.byte	0x3
	.4byte	inputsignal
	.byte	0x2
	.4byte	.LASF13
	.byte	0x1c
	.4byte	0x98
	.byte	0x5
	.byte	0x3
	.4byte	inputbuffer
	.byte	0x2
	.4byte	.LASF14
	.byte	0x1d
	.4byte	0x78
	.byte	0x5
	.byte	0x3
	.4byte	outputsignal
	.byte	0xa
	.4byte	.LASF17
	.byte	0x1
	.byte	0x30
	.byte	0x33
	.4byte	0x129
	.4byte	.LFB317
	.4byte	.LFE317-.LFB317
	.byte	0x1
	.byte	0x9c
	.4byte	0x129
	.byte	0xb
	.4byte	.LBB4
	.4byte	.LBE4-.LBB4
	.byte	0x5
	.string	"i"
	.byte	0x36
	.4byte	0x6a
	.4byte	.LLST2
	.byte	0
	.byte	0
	.byte	0xc
	.byte	0x4
	.4byte	0x6a
	.byte	0xd
	.4byte	.LASF18
	.byte	0x1
	.byte	0x25
	.byte	0x33
	.4byte	.LFB316
	.4byte	.LFE316-.LFB316
	.byte	0x1
	.byte	0x9c
	.byte	0xe
	.4byte	.LLRL0
	.byte	0x5
	.string	"i"
	.byte	0x27
	.4byte	0x6a
	.4byte	.LLST1
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.byte	0x1
	.byte	0x24
	.byte	0
	.byte	0xb
	.byte	0xb
	.byte	0x3e
	.byte	0xb
	.byte	0x3
	.byte	0xe
	.byte	0
	.byte	0
	.byte	0x2
	.byte	0x34
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0x21
	.byte	0x1
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0x21
	.byte	0x5
	.byte	0x49
	.byte	0x13
	.byte	0x3f
	.byte	0x19
	.byte	0x2
	.byte	0x18
	.byte	0
	.byte	0
	.byte	0x3
	.byte	0x1
	.byte	0x1
	.byte	0x49
	.byte	0x13
	.byte	0x1
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x4
	.byte	0x21
	.byte	0
	.byte	0x49
	.byte	0x13
	.byte	0x2f
	.byte	0xb
	.byte	0
	.byte	0
	.byte	0x5
	.byte	0x34
	.byte	0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0x21
	.byte	0x1
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0x21
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x2
	.byte	0x17
	.byte	0
	.byte	0
	.byte	0x6
	.byte	0x11
	.byte	0x1
	.byte	0x25
	.byte	0xe
	.byte	0x13
	.byte	0xb
	.byte	0x3
	.byte	0x1f
	.byte	0x1b
	.byte	0x1f
	.byte	0x55
	.byte	0x17
	.byte	0x11
	.byte	0x1
	.byte	0x10
	.byte	0x17
	.byte	0
	.byte	0
	.byte	0x7
	.byte	0x16
	.byte	0
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0x8
	.byte	0x24
	.byte	0
	.byte	0xb
	.byte	0xb
	.byte	0x3e
	.byte	0xb
	.byte	0x3
	.byte	0x8
	.byte	0
	.byte	0
	.byte	0x9
	.byte	0x34
	.byte	0
	.byte	0x3
	.byte	0x8
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x3f
	.byte	0x19
	.byte	0x2
	.byte	0x18
	.byte	0
	.byte	0
	.byte	0xa
	.byte	0x2e
	.byte	0x1
	.byte	0x3f
	.byte	0x19
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0x40
	.byte	0x18
	.byte	0x7a
	.byte	0x19
	.byte	0x1
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0xb
	.byte	0xb
	.byte	0x1
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0
	.byte	0
	.byte	0xc
	.byte	0xf
	.byte	0
	.byte	0xb
	.byte	0xb
	.byte	0x49
	.byte	0x13
	.byte	0
	.byte	0
	.byte	0xd
	.byte	0x2e
	.byte	0x1
	.byte	0x3f
	.byte	0x19
	.byte	0x3
	.byte	0xe
	.byte	0x3a
	.byte	0xb
	.byte	0x3b
	.byte	0xb
	.byte	0x39
	.byte	0xb
	.byte	0x11
	.byte	0x1
	.byte	0x12
	.byte	0x6
	.byte	0x40
	.byte	0x18
	.byte	0x7a
	.byte	0x19
	.byte	0
	.byte	0
	.byte	0xe
	.byte	0xb
	.byte	0x1
	.byte	0x55
	.byte	0x17
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loclists,"",@progbits
	.4byte	.Ldebug_loc3-.Ldebug_loc2
.Ldebug_loc2:
	.2byte	0x5
	.byte	0x4
	.byte	0
	.4byte	0
.Ldebug_loc0:
.LLST2:
	.byte	0x7
	.4byte	.LVL2
	.4byte	.LVL3
	.byte	0x2
	.byte	0x30
	.byte	0x9f
	.byte	0
.LLST1:
	.byte	0x7
	.4byte	.LVL0
	.4byte	.LVL1
	.byte	0x2
	.byte	0x30
	.byte	0x9f
	.byte	0
.Ldebug_loc3:
	.section	.debug_aranges,"",@progbits
	.4byte	0x24
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.LFB316
	.4byte	.LFE316-.LFB316
	.4byte	.LFB317
	.4byte	.LFE317-.LFB317
	.4byte	0
	.4byte	0
	.section	.debug_rnglists,"",@progbits
.Ldebug_ranges0:
	.4byte	.Ldebug_ranges3-.Ldebug_ranges2
.Ldebug_ranges2:
	.2byte	0x5
	.byte	0x4
	.byte	0
	.4byte	0
.LLRL0:
	.byte	0x6
	.4byte	.LBB2
	.4byte	.LBE2
	.byte	0x6
	.4byte	.LBB3
	.4byte	.LBE3
	.byte	0
.LLRL3:
	.byte	0x6
	.4byte	.LFB316
	.4byte	.LFE316
	.byte	0x6
	.4byte	.LFB317
	.4byte	.LFE317
	.byte	0
.Ldebug_ranges3:
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF12:
	.string	"inputsignal"
.LASF15:
	.string	"GNU C17 12.1.0 -mabi=ilp32 -mtune=rocket -misa-spec=2.2 -march=rv32i -g -O1 -ffreestanding"
.LASF18:
	.string	"initqs"
.LASF17:
	.string	"qsort"
.LASF6:
	.string	"unsigned char"
.LASF8:
	.string	"long unsigned int"
.LASF7:
	.string	"short unsigned int"
.LASF10:
	.string	"unsigned int"
.LASF11:
	.string	"taps"
.LASF9:
	.string	"long long unsigned int"
.LASF13:
	.string	"inputbuffer"
.LASF14:
	.string	"outputsignal"
.LASF5:
	.string	"long long int"
.LASF3:
	.string	"short int"
.LASF16:
	.string	"uint32_t"
.LASF4:
	.string	"long int"
.LASF2:
	.string	"signed char"
	.section	.debug_line_str,"MS",@progbits,1
.LASF0:
	.string	"fir.c"
.LASF1:
	.string	"/home/andy/SoC_Design/SoC_Design_Final/qs/testbench/counter_la_fir"
	.ident	"GCC: (g1ea978e3066) 12.1.0"
