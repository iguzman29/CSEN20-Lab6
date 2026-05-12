/*
 * File:			lab7c.s
 *
 * Author:			Isabella Guzman
 *
 * Last updated:	5/12/2026
 *
 * Description:		This file contains functions to implement equivalent replacements in assembly language for the  two functions, PutNibble and GetNibble, found in the C main program to store and retrieve individual nibbles within the array.
*/
        .syntax     unified
        .cpu        cortex-m4
        .text
// -----------------------------------------------------------------------------          
// void PutNibble(void *nibbles, uint32_t which, uint32_t value)
// R0 = base address, R1 = index, R2 = value
// -----------------------------------------------------------------------------

PutNibble:
        LSR     R3, R1, #1          // R3 = byte offset (which >> 1)
        LDRB    R12, [R0, R3]       // R12 = current byte
        TST     R1, #1              // Test if index is odd (which & 1)
        BNE     .PutOdd             // If result is NOT zero (odd), jump

.PutEven:
        BIC     R12, R12, #0x0F     // Clear bits 0-3 (low nibble)
        AND     R2, R2, #0x0F       // Ensure input value is only 4 bits [cite: 25]
        ORR     R12, R12, R2        // Combine new value into low nibble
        B       .PutDone

.PutOdd:
        BIC     R12, R12, #0xF0     // Clear bits 4-7 (high nibble)
        LSL     R2, R2, #4          // Shift value to bits 4-7
        ORR     R12, R12, R2        // Combine new value into high nibble

.PutDone:
        STRB    R12, [R0, R3]       // Store the updated byte back to memory [cite: 15]
        BX      LR                  // Return to caller
// -----------------------------------------------------------------------------
// uint32_t GetNibble(void *nibbles, uint32_t which)
// R0 = base address of nibbles array
// R1 = index (0 to 80)
// Returns: 4-bit value in R0
// -----------------------------------------------------------------------------
        .global     GetNibble
        .thumb_func
        .align
GetNibble:
        LSR     R2, R1, #1          // R2 = which / 2 (byte offset)
        LDRB    R0, [R0, R2]        
        ANDS    R1, R1, #1          // Check if index is odd (R1 = which & 1)
        IT      NE                  // If Not Equal (odd index)
        LSRNE   R0, R0, #4          // Shift right by 4 bits to move high nibble to low
        AND     R0, R0, #0x0F       // Mask out everything except the low 4 bits
        BX      LR                  

        .end
