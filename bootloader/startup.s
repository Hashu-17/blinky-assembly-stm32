.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global g_IVT

.word   _sidata
.word   _sdata
.word   _edata
.word   _sbss
.word   _ebss

.section .text.Reset_Handler
.weak Reset_Handler
.type Reset_Handler, %function

Reset_Handler:
    ldr sp, =_estack

    mov r1, #0
    b LoopCopyDataInit

CopyDataInit:
    ldr r3, =_sidata
    ldr r3, [r3, r1]
    str r3, [r0, r1]
    add r1, r1, #4

LoopCopyDataInit:
    ldr r0, =_sdata
    ldr r3, =_edata
    adds r2, r0, r1
    cmp r2, r3
    bcc CopyDataInit
    ldr r2, =_sbss
    b LoopFillZerobss

FillZerobss:
    movs r3, #0
    str r3, [r2], #4

LoopFillZerobss:
    ldr r3, = _ebss
    cmp r2, r3
    bcc FillZerobss

    bl main
    bx lr
.size  Reset_Handler, .-Reset_Handler

.section .isr_vector, "a", %progbits
.type g_IVT, %object
.size g_IVT, .-g_IVT

g_IVT:
    .word   _estack
    .word   Reset_Handler
