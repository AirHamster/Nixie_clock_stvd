
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
		CLK_CKDIVR=0;                //нет делителей
		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //тактирование на TIM1, UART1, SPI i I2C
		

  //Настройка портов================
    PA_DDR=(1<<3) | (1<<2); //0b000001000; //выход на защелку регистров, вход на сигнал с ртс
    PA_CR1= 0xff;        //на входах подтяги, на выходе пуш-пулл
    PA_ODR |= (1<<3);
		PA_CR2 |=(1<<3);        //есть прерывания на PA1 для 1hz

    PC_DDR=0x60; //0b01100000; // кнопочки на вход
    PC_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
    PC_CR2 |= (1<<4) | (1<<3);        //есть прерывания на кнопках

		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM на вход
    PD_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
    PD_ODR = (1 << 3);
		
		

		
	//Настройка SPI ================
    spi_setup();
		
	//Настройка UART
		uart_setup();
		UART_Send('h');
		
  //Настройка таймеров ===========
    timer1_setup( 65500,0xffff);//частота в гц и топ значение
		timer2_setup();
		timer1_start();
		timer2_start(TIM2_TOP);
  
	
		 //Настройка I2C ================
   
		i2c_master_init(16000000, 100000);
	//проверка активности ртс	
		timers_int_off();
		
		i2c_rd_reg(ds_address, 7, &temp, 1);
	if (temp != 0b10010000)	// if OUT and SWQ == 0
		{
			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//Настройка 1Hz выхода
		}
		
		i2c_rd_reg(ds_address, 0, time_pointer, 1);
		
	//запускаем, если стоят на месте
	if((seconds & 0x80) == 0x80)
	{
		seconds = 0;
		i2c_wr_reg(ds_address, 0,time_pointer, 1);
	}
		i2c_rd_reg(ds_address, 0, &seconds, 1); 	
		i2c_rd_reg(ds_address, 1, &minutes, 1);
		i2c_rd_reg(ds_address, 2, &hours, 1);
		
		timers_int_on();
		
		
		//UART_Send(seconds);

		_asm ("RIM");  //on interupts
		
		EXTI_CR1 = 0b00110011;//((1<<4) | (1<<0));//0x10;	//внешние прерывания на портах А и С по восходящему фронту 
		EXTI_CR2 = 0b00000100;
	while(1)
	{
		temp = PA_IDR;
		if(temp & 0b00000010 == 0b00000010)
		{
			temp = PA_IDR;
		}
		else if ((temp & 0b00000000 == 0b00000000))
		{
			temp = PA_IDR;
		}
	}
		return 0;
}
