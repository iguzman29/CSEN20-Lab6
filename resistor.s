/*
 * File:			resistor.s
 *
 * Author:			Isabella Guzman
 *
 * Last updated:	5/19/2026
 *
 * Description:		This file contains functions to implement equivalent replacements in assembly language for the following three functions found in the C main program: Mul32X10, which returns the 32-bit unsigned product of ten
times its 32-bit argument, Mul64X10, which returns the 64-bit unsigned product of ten times its 64-bit argument, and Div32X10, which returns the 32-bit unsigned quotient of its argument divided by 10.
*/

        .syntax     unified
        .cpu        cortex-m4
        .text
// -----------------------------------------------------------------------------          
// uint32_t Mul32X10(uint32_t multiplicand) ;
// -----------------------------------------------------------------------------

        .global     Mul32X10
        .thumb_func
        .align
Mul32X10:           
        // 10*x = 2*x + 8*x = (x << 1) + (x << 3)
        LSL         R1, R0, #1          // R1 = x * 2
        ADD         R0, R1, R0, LSL #3  // R0 = (x * 2) + (x * 8)
        BX          LR                 

// -----------------------------------------------------------------------------          
// uint64_t Mul64X10(uint64_t multiplicand) ;
// -----------------------------------------------------------------------------

        .global     Mul64X10
        .thumb_func
        .align
Mul64X10:           
        LSR         R3, R0, #31         // Extract the MSB of R0 to carry to high 32 bits
        ORR         R3, R3, R1, LSL #1  // Shift R1 left by 1 and combine with carry
        LSL         R2, R0, #1          // Shift R0 left by 1

        LSR         R12, R0, #29        // Extract top 3 bits of R0 to carry to high 32 bits
        ORR         R1, R12, R1, LSL #3 // Shift R1 left by 3 and combine with carry
        LSL         R0, R0, #3          // Shift R0 left by 3

        ADDS        R0, R0, R2          // Add lower 32 bits and update carry flag
        ADC         R1, R1, R3          // Add upper 32 bits with carry
        BX          LR
// -----------------------------------------------------------------------------          
// uint32_t Div32X10(uint32_t dividend) ;
// -----------------------------------------------------------------------------

        .global     Div32X10
        .thumb_func
        .align
Div32X10:           
        // Equivalent to multiplying by reciprocal constant 0xCCCCCCCD
        LDR         R1, =0xCCCCCCCD     // Load the magic division reciprocal constant
        UMULL       R2, R3, R0, R1 
        MOV         R0, R3              // The upper 32-bit register (R3) holds (R0 * R1) >> 32
        BX          LR                  

        .end



