/*	Firmware fo Nixie clock
		Air_Hamster
		2017
*/
#include "stm8s.h"
#include <stdio.h>
#include <stdlib.h>
#include "iostm8s103.h"
#include "varables.h" 
#include "uart.h"

#include "keys.h"
#include "i2c.h"
#include "timers.h"
#include "functions.h"

#include "spi.h"
#include "stm8s_itc.h"

#include "int_funcs.h"
int main( void )
{
	//	Clock setup	================
		CLK_CKDIVR=0;                //	no dividers
		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //clocking for TIM1, UART1, SPI i I2C
	
  //	Ports setup	================
    PA_DDR=(1<<3) | (1<<2); //0b000001000; //output for register's latch, input for RTC 1 Hz pulse
    PA_CR1= 0xff;        //	pull-up on inputs, push-pull on outputs
    PA_ODR |= (1<<3);
		PA_CR2 |=(1<<3);        //	interrupt on PA1 for 1hz

    PC_DDR=0x60; //0b01100000; // buttons pins as input
    PC_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
    PC_CR2 |= (1<<4) | (1<<3);        //	interrapts for buttons

		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM
    PD_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
    PD_ODR = (1 << 3);
		
		
	//	SPI setup	================
    spi_setup();
		
	//	UART setup	================
		uart_setup();
		uart_send('h');
		
  //	Timers initialization ===========
    timer1_setup( 65500,0xffff);//	freq in hz and top value
		timer2_setup();
		timer1_start();
		timer2_start(TIM2_TOP);
  
	
	// 	I2C	setup	================
		i2c_master_init(16000000, 50000);
	
	//	Checking for running RTC	================	
		timers_int_off();
		
		i2c_rd_reg(ds_address, 7, &temp, 1);
	if (temp != 0b10010000)	// if OUT and SWQ == 0
		{
			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//	setup RTC for 1Hz output
		}
		
		i2c_rd_reg(ds_address, 0, &temp, 1);
		
	//	start RTC if it stopped
	if((temp & 0x80) == 0x80)
	{
		temp = 0;
		i2c_wr_reg(ds_address, 0, &temp, 1);
	}
		timers_int_on();

		_asm ("RIM");  //on interupts
			
	//	main cycle
	while(1)
	{
	}
		return 0;
}
