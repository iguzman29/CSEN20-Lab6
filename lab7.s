/*
    This code was written to support the book, "ARM Assembly for Embedded Applications",
    by Daniel W. Lewis.
*/
        .syntax     unified
        .cpu        cortex-m4
        .text

// -----------------------------------------------------------------------------
// void PutNibble(void *nibbles, uint32_t which, uint32_t value)
// R0 = base address of nibbles array
// R1 = index (0 to 80)
// R2 = value (4-bit number)
// -----------------------------------------------------------------------------
        .global     PutNibble
        .thumb_func
        .align
PutNibble:
        PUSH    {R4, R5}            // Save registers to stay AAPCS compliant
        LSR     R3, R1, #1          // R3 = which / 2 (byte offset)
        LDRB    R4, [R0, R3]        // R4 = current byte at the calculated address
        AND     R1, R1, #1          // Check if index is odd (R1 = which & 1)
        CMP     R1, #1              
        BEQ     .PutOdd             // If odd, jump to handle high nibble

.PutEven:
        BIC     R4, R4, #0x0F       // Clear the low nibble (bits 0-3)
        AND     R2, R2, #0x0F       // Ensure value is only 4 bits
        ORR     R4, R4, R2          // Or the value into the low nibble
        B       .PutDone

.PutOdd:
        BIC     R4, R4, #0xF0       // Clear the high nibble (bits 4-7)
        LSL     R2, R2, #4          // Shift value to the high nibble position
        ORR     R4, R4, R2          // Or the value into the high nibble

.PutDone:
        STRB    R4, [R0, R3]        // Store the modified byte back to memory
        POP     {R4, R5}            // Restore registers
        BX      LR                  // Return

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
        LDRB    R0, [R0, R2]        // R0 = byte containing the desired nibble
        ANDS    R1, R1, #1          // Check if index is odd (R1 = which & 1)
        IT      NE                  // If Not Equal (odd index)...
        LSRNE   R0, R0, #4          // ...shift right by 4 bits to move high nibble to low
        AND     R0, R0, #0x0F       // Mask out everything except the low 4 bits
        BX      LR                  // Return

        .end
