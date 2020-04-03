/*
*********************************************************************************************************
*                                           Atmel ATmega128
*                                   STK500/501 Board Support Package
*
*                                (c) Copyright 2005, Micrium, Weston, FL
*                                          All Rights Reserved
*
*
* File : BSP.C
* By   : Jean J. Labrosse
*********************************************************************************************************
*/

/*
*********************************************************************************************************
*                                               CONSTANTS
*********************************************************************************************************
*/

#define  CPU_CLK_FREQ                  8000000L
#define  DELAYED_TIME                  2

/*
*********************************************************************************************************
*                                           FUNCTION PROTOTYPES
*********************************************************************************************************
*/
void  BSP_InitTickISR(void);
void  LED_Init(void);
void  BSP_Init(void);
void  BSP_TickISR(void);
void  LED_On(INT8U led);
void  LED_Off(INT8U led);
void  LED_Toggle(INT8U led);


