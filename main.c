/*
 * main.c
 *
 * Created: 6/19/2013 11:42:11 PM
 *  Author: MOSTAFA
 */ 

#include "config.h"
/************************************************************************/
/*          variables and tasks decelerations                           */
/************************************************************************/


static OS_STK Task1Stk[OS_USER_TASK_STK_SIZE] = {0};
static OS_STK Task2Stk[OS_USER_TASK_STK_SIZE] = {0};
//static OS_STK Task3Stk[OS_USER_TASK_STK_SIZE] = {0};
//OS_STK Task4Stk[OS_USER_TASK_STK_SIZE] = {0};
//OS_STK Task5Stk[OS_USER_TASK_STK_SIZE] = {0};
OS_EVENT * sem_key;
//INT16U time_out=OS_TICKS_PER_SEC/20;
INT8U s_err=0;



/************************************************************************/
/*        tasks definitions                                             */
/************************************************************************/


void Task1(void *pdata)
{
	pdata=pdata;
	
	
	while(1)
	{
		

		//OSSemPend(sem_key,5,&s_err);
		PORTD=0x0F;
		PORTE=0x0F;
		PORTF=0x0F;
		OSTimeDly(DELAYED_TIME);
		//OSSemPost(sem_key);
	}
}
void Task2(void *pdata)
{
	pdata=pdata;
	
	while(1)
	{
		
		//OSSemPend(sem_key,5,&s_err);
		PORTD=0xF0;
		PORTE=0xF0;
		PORTF=0xF0;
		OSTimeDly(DELAYED_TIME );
		//OSSemPost(sem_key);
		
	}
}	
void Task3(void *pdata)
{
	pdata=pdata;
	
	while(1)
	{
		
		//OSSemPost(sem_key);
		//OSSemPend(sem_key,time_out,& s_err);
		//OSTimeDly(10);
		PORTF=~PORTF;
		//OSSemPend(sem_k
		OSTimeDly(DELAYED_TIME );
		
	}
}	

	
void tasks_create(void)
{
        //timer0_init_ucos();
        //timer3_init_ucos();
        //uart_init();
		
        OSTaskCreate(Task1,0,&Task1Stk[OS_USER_TASK_STK_SIZE-1],1);
        OSTaskCreate(Task2,0,&Task2Stk[OS_USER_TASK_STK_SIZE-1],2);
        //OSTaskCreate(Task3,0,&Task3Stk[OS_USER_TASK_STK_SIZE-1],3);
        //OSTaskCreate(Task4,0,&Task4Stk[OS_USER_TASK_STK_SIZE-1],4);
        //OSTaskCreate(Task5,0,&Task5Stk[OS_USER_TASK_STK_SIZE-1],5);  
		sem_key=OSSemCreate(0);  
}

int main(void)
 {
		BSP_Init();
		
        OSInit();
		
		//sem_key=OSSemCreate(1);	
       
        tasks_create();

        OSStart();
       
        return 0;
}
