
/*
 * os_cpu_a.s
 *
 * Created: 6/19/2013 11:49:47 PM
 *  Author: MOSTAFA
 */ 
 ;********************************************************************************************************
; uC/OS-II
; The Real-Time Kernel
;
; ATmega128 Specific code for V2.8x
; (AVR-GCC 4.1.1)
;
;
; File : OS_CPU_A.ASM
;
;********************************************************************************************************
#include <avr/io.h>
#define OS_CPU_A
#include "OS_CFG.h"
#include "OS_CPU.h"

;********************************************************************************************************
; I/O PORT ADDRESSES
;********************************************************************************************************




;********************************************************************************************************
; PUBLIC DECLARATIONS
;********************************************************************************************************

					.global OSStartHighRdy
					.global OSCtxSw
					.global OSIntCtxSw
					.global OSTickISR
					

;********************************************************************************************************
; EXTERNAL DECLARATIONS
;********************************************************************************************************

					.extern OSIntExit
					.extern OSIntNesting
					.extern OSPrioCur
					.extern OSPrioHighRdy
					.extern OSRunning
					.extern OSTaskSwHook
					.extern OSTCBCur
					.extern OSTCBHighRdy
					.extern OSTimeTick

;********************************************************************************************************
; MACROS
;********************************************************************************************************

; Push all registers and the status register
.macro PUSHRS
					push r0
					push r1
					push r2
					push r3
					push r4
					push r5
					push r6
					push r7
					push r8
					push r9
					push r10
					push r11
					push r12
					push r13
					push r14
					push r15
					push r16
					push r17
					push r18
					push r19
					push r20
					push r21
					push r22
					push r23
					push r24
					push r25
					push r26
					push r27
					push r28
					push r29
					push r30
					push r31
					in r16,_SFR_IO_ADDR(SREG)
					push r16

					.endm
;****************************************************************************************
; Pop all registers and the status registers
.macro POPRS

					pop r16
					out _SFR_IO_ADDR(SREG),r16
					pop r31
					pop r30
					pop r29
					pop r28
					pop r27
					pop r26
					pop r25
					pop r24
					pop r23
					pop r22
					pop r21
					pop r20
					pop r19
					pop r18
					pop r17
					pop r16
					pop r15
					pop r14
					pop r13
					pop r12
					pop r11
					pop r10
					pop r9
					pop r8
					pop r7
					pop r6
					pop r5
					pop r4
					pop r3
					pop r2
					pop r1
					pop r0
					
					.endm

					.text
					.section .text


;********************************************************************************************************
 .macro  PUSH_SP                             ; Save stack pointer
                IN      R16,_SFR_IO_ADDR(SPH)
                ST      -Z,R16
                IN      R16,_SFR_IO_ADDR(SPL)
                ST      -Z,R16
               .endm

.macro  POP_SP                              ; Restore stack pointer
                LD      R16,Z+
                OUT     _SFR_IO_ADDR(SPL),R16
                LD      R16,Z+
                OUT     _SFR_IO_ADDR(SPH),R16
               .endm
;********************************************************************************************************
; START HIGHEST PRIORITY TASK READY-TO-RUN
;
; Description : This function is called by OSStart() to start the highest priority task that was created
; by your application before calling OSStart().
;
; Note(s) : 1) The (data)stack frame is assumed to look as follows:
;
; OSTCBHighRdy->OSTCBStkPtr --> LSB of (return) stack pointer (Low memory)
; SPH of (return) stack pointer
; Flags to load in status register
; R31
; R30
; R7
; .
; .
; .
; R0 (High memory)
;
; where the stack pointer points to the task start address.
;
;
; 2) OSStartHighRdy() MUST:
; a) Call OSTaskSwHook() then,
; b) Set OSRunning to TRUE,
; c) Switch to the highest priority task.
;********************************************************************************************************
OSStartHighRdy :

					LDS R16,OSRunning						 ; Indicate that we are multitasking
					INC R16 ;
					STS OSRunning,R16						 ;

					LDS R30,OSTCBHighRdy					 ; Let Z point to TCB of highest priority task
					LDS R31,OSTCBHighRdy+1					 ; ready to run

					POP_SP

					POPRS									 ; Pop all registers and status register
					
					RET										 ; Start task

;********************************************************************************************************
; TASK LEVEL CONTEXT SWITCH
;
; Description : This function is called when a task makes a higher priority task ready-to-run.
;
; Note(s) : 1) Upon entry,
; OSTCBCur points to the OS_TCB of the task to suspend
; OSTCBHighRdy points to the OS_TCB of the task to resume
;
; 2) The stack frame of the task to suspend looks as follows:
;
; SP+0 --> LSB of task code address
; +1 MSB of task code address (High memory)
;
; 3) The saved context of the task to resume looks as follows:
;
; OSTCBHighRdy->OSTCBStkPtr --> LSB of (return) stack pointer (Low memory)
; SPH of (return) stack pointer
; Flags to load in status register
; R31
; R30
; R7
; .
; .
; .
; R0 (High memory)
;********************************************************************************************************

OSCtxSw:
				PUSHRS                              ; Save current tasks context
				
				PUSH_SP

  
                RCALL   OSTaskSwHook                ; Call user defined task switch hook

                LDS     R16,OSPrioHighRdy           ; OSPrioCur = OSPrioHighRdy
                STS     OSPrioCur,R16




	
						
				LDS     R30,OSTCBHighRdy            ; Let Z point to TCB of highest priority task
                LDS     R31,OSTCBHighRdy+1          ; ready to run
				STS     OSTCBCur,R30                ; OSTCBCur = OSTCBHighRdy
                STS     OSTCBCur+1,R31              ;
				
				POP_SP
				
                POPRS                               ; Restore all registers and the status register
                RET
;*********************************************************************************************************
; INTERRUPT LEVEL CONTEXT SWITCH
;
; Description : This function is called by OSIntExit() to perform a context switch to a task that has
; been made ready-to-run by an ISR.
;
; Note(s) : 1) Upon entry,
; OSTCBCur points to the OS_TCB of the task to suspend
; OSTCBHighRdy points to the OS_TCB of the task to resume
;
; 2) The stack frame of the task to suspend looks as follows:
;
; SP+0 --> LSB of return address of OSIntCtxSw() (Low memory)
; +1 MSB of return address of OSIntCtxSw()
; +2 LSB of return address of OSIntExit()
; +3 MSB of return address of OSIntExit()
; possible SREG save
; +4 LSB of task code address
; +5 MSB of task code address (High memory)
;
; 3) The saved context of the task to resume looks as follows:
;
; OSTCBHighRdy->OSTCBStkPtr --> Flags to load in status register (Low memory)
; R31
; R30
; R7
; .
; .
; .
; R0 (High memory)
;*********************************************************************************************************

OSIntCtxSw:

				;IN      R28,_SFR_IO_ADDR(SPL)                    ; Z = SP
                ;IN      R29,_SFR_IO_ADDR(SPH)
				
				;PUSH_SP
 

 				LDS     R16,OSPrioHighRdy           ; OSPrioCur = OSPrioHighRdy
                STS     OSPrioCur,R16

				LDS     R30,OSTCBHighRdy            ; Let Z point to TCB of highest priority task
                LDS     R31,OSTCBHighRdy+1          ; ready to run

				STS     OSTCBCur,R30                ; OSTCBCur->OSTCBstkptr = OSTCBHighRdy->OSTCBstkptr
                STS     OSTCBCur+1,R31

				POP_SP

 




				

				POPRS								; Restore all registers and the status register

                RET		

;********************************************************************************************************
; SYSTEM TICK ISR
;
; Description : This function is the ISR used to notify uC/OS-II that a system tick has occurred.
;
;
;********************************************************************************************************
OSTickISR:
						
						PUSHRS                              ; Save all registers and status register
						
						

						CALL     OSTaskSwHook   

						CALL     OSIntEnter					; Notify uC/OS-II of ISR

						CALL     OSTimeTick                 ; Call uC/OS-IIs tick updating function

						CALL     OSIntExit						; Notify uC/OS-II about end of ISR

						

						POPRS                               ; Restore all registers and status register

						RET                                 ; Note: RET instead of RETI		 ; Note: RET instead of RETI


