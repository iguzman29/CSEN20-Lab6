/*
    Lab 6C: Slide 15-Puzzle
    Task: Implement CopyCell and FillCell in Assembly.
*/

            .syntax     unified
            .cpu        cortex-m4
            .text

// void CopyCell(uint32_t *dst, uint32_t *src) ; 
// R0 = dst, R1 = src
            .global     CopyCell
            .thumb_func
            .align
CopyCell:   
            PUSH    {R4-R5}             // Save registers used for loops
            MOVS    R2, #60             // R2 = Outer loop counter (rows)

NextRow1:   
            MOVS    R3, #60             // R3 = Inner loop counter (cols)

NextCol1:   
            LDR     R4, [R1], #4        // Load pixel from src, post-increment src by 4
            STR     R4, [R0], #4        // Store pixel to dst, post-increment dst by 4
            SUBS    R3, R3, #1          // Decrement column counter
            BNE     NextCol1            // Loop until 60 pixels are copied

            // Move to the start of the next row
            // The display width is 240 pixels. We just moved 60 pixels (240 bytes).
            // Per Lab6C-Main.c, we need to add 240 * 4 bytes to skip to the next row,
            // but the C code uses "dst += 240" where dst is uint32_t*, 
            // which is 240 * 4 = 960 bytes.
            ADD     R0, R0, #720        // (240 - 60) * 4 = 720 bytes to reach next row
            ADD     R1, R1, #720        
            
            SUBS    R2, R2, #1          // Decrement row counter
            BNE     NextRow1

            POP     {R4-R5}             // Restore registers
            BX      LR                  // Return

// void FillCell(uint32_t *dst, uint32_t color) ; 
// R0 = dst, R1 = color
            .global     FillCell
            .thumb_func
            .align 
FillCell:   
            MOVS    R2, #60             // R2 = Outer loop counter (rows)

NextRow2:   
            MOVS    R3, #60             // R3 = Inner loop counter (cols)

NextCol2:   
            STR     R1, [R0], #4        // Store color to dst, post-increment dst by 4
            SUBS    R3, R3, #1          // Decrement column counter
            BNE     NextCol2            // Loop until row is filled

            ADD     R0, R0, #720        // Skip to next row: (240 - 60) * 4 = 720 bytes 
            
            SUBS    R2, R2, #1          // Decrement row counter
            BNE     NextRow2

            BX      LR                  // Return

            .end
