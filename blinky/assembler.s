 .syntax unified
 
  .text
  .global ASM_SystemInit
  .global ASM_Function
  .thumb_func
 
  .equ  RCC_BASE_ADDR,  0x40021000
  .equ  o_RCC_CR,       0x00       // offset to RCC_CR
  .equ  o_RCC_CFGR,     0x08       // offset to RCC_CFGR
  .equ  o_RCC_PLLCFGR,  0x0C       // offset to RCC_PLLCFGR
  .equ  o_RCC_AHB2ENR,  0x4C       // offset to RCC_AHB2ENR
 
  .equ  GPIOA_BASE_ADDR,0x48000000
  .equ  o_GPIOA_MODER,  0x00       // offset to GPIOA_MODER
  .equ  o_GPIOA_OTYPER, 0x04       // offset for GPIOA Output PP/OD
  .equ  o_GPIOA_OSPEEDR,0x08       // offset for GPIOA Output Speed
  .equ  o_GPIOA_PUPDR,  0x0C       // offset for GPIOA PU/PD
 
  .equ  GPIOA_BSRR,     0x48000018 // GPIOA Bit set reset register
 
  .equ  COUNTER,        10000
//------------------------------------------------------------------------------------------------
  ASM_SystemInit:
 
  // Clock configuration, 16 MHz HSI as PLL clock source
  LDR R1, =RCC_BASE_ADDR           // Load RCC configuration register address in R1
 
  LDR R0, =0x06000802              // PLLPDIV=0, PLLR=8, PLLQ=2, PLLP=7, PLLN=16, PLLM=1, HSI16->PLL
  STR R0, [R1, o_RCC_PLLCFGR]      // store into RCC_PLLCFGR
 
  ORR R0, #0x01000000              // set PLLREN (bit 24)
  STR R0, [R1, o_RCC_PLLCFGR]      // store into RCC_PLLCFGR
 
  LDR R0, [R1, o_RCC_CR]           // read RCC_CR
  ORR R0, #0x01000000              // set PLLON (bit 24)
  STR R0, [R1, o_RCC_CR]           // store into RCC_CR
 
  ASM_SystemInit_1:
  LDR R0, [R1, o_RCC_CR]           // read RCC_CR
  LSLS R0, #6                      // Logical Shift Left by 6
  BPL.N ASM_SystemInit_1           // Branch if N flag = 0 (= positive or zero, see PM0214, table 24)
 
  [...]
 
  BX LR                            // Return from function
 
//------------------------------------------------------------------------------------------------
  ASM_Function:
 
  turnON:
  // Set output high
  LDR R1, =GPIOA_BSRR
  LDR R0, =0x00000020
  STR R0, [R1]
 
  LDR R2, =COUNTER
  delay1:
  SUBS R2, R2, #1                  // R2 = R2 - 1, R2 = 0?
  BNE delay1                       // stay in loop delay1 if not equal to zero
 
  turnOFF:
  // Set output low
  LDR R0, =0x00200000
  STR R0, [R1]
 
  LDR R2, =#COUNTER
  LSL R2, #6                       // Logical Shift Left
 
  delay2:
  SUBS R2, R2, #1                  // R2 = R2 - 1, R2 = 0?
  BNE delay2                       // stay in loop delay1 if not equal to zero
 
  delayDone:
  B turnON                         // Jump to turnON
