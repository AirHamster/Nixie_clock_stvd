#define CLOCK_FREQ 16000000
#include "stm8s.h"
#include <stdio.h>
#include <stdlib.h>
#include "iostm8s103.h"
#include "varables.h" 
#include "uart.h"

#include "keys.h"
#include "timers.h"
#include "functions.h"
#include "i2c.h"
#include "spi.h"
#include "stm8s_itc.h"

#include "int_funcs.h"



/*extern void spi_setup(void);
extern void uart_setup(void);
extern void i2c_read_data(uint8_t);
extern void i2c_exeption(void);
extern void i2c_write_data(uint8_t);
*/ 
int main( void )
{
	

	CLK_CKDIVR=0;                //нет делителей
  CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //тактирование на TIM1, UART1, SPI i I2C
	//CCR |= (1<<5) | (1<<3);
	_asm ("SIM"); // off interrupts
	EXTI_CR1 = 0x10; //(2<<EXTI_CR1_PCIS);
//	while(1);

  //Настройка портов================
    PA_DDR=0x08; //0b000001000; //выход на защелку регистров, вход на сигнал с ртс
    PA_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
    //PA_CR2=0xff;        //есть прерывания

   // PB_DDR=; //
   // PB_CR1=;        //на входах подтяги, на выходе пуш-пулл
   // PB_CR2=;        //есть прерывания

    PC_DDR=0x60; //0b01100000; //SPI на выход, кнопочки на вход
    PC_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
		
    PC_CR2 |= (1<<4) | (1<<3);        //есть прерывания

		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM на вход
    PD_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
    PD_ODR = (1 << 3);
		//PD_CR2=0xff;        //есть прерывания

  //Настройка I2C ================
   // i2c_init();
		//i2c_stupid_read();
	i2c_master_init(16000000, 100000);
 //Настройка SPI ================
    //spi_setup();

  //Настройка таймеров ===========
		uart_setup();
		UART_Send('h');
    timer1_setup( 65500,0xffff);//частота в гц и топ значение
		timer2_setup();
		//timer2_start(0xff);
    
    //TODO настроить вход-выход
		timer1_start();
   // _asm ("RIM");  //on interupts
		temp = 10;
		SPI_DR = temp;
		i2c_rd_reg(0xD0, 0, time_pointer, 1);
		
	//	temp = *time_pointer;
	if((seconds & 0x80) == 0x80)
	{
		seconds = 0;
		i2c_wr_reg(ds_address, 0,time_pointer, 1);
	}
		i2c_rd_reg(0xD0, 0, time_pointer, 1); 	
			UART_Send(seconds);
//		i2c_start(0,0,0);
 _asm ("RIM");  //on interupts
while(1);
//{
	
	//temp = UART1_SR;
	//temp &= 0x20;
	
//};
   /* data_pointer = &temp;
    i2c_read_data(time_address);
       while (i2c_flags.status ==busy)
    {
    }
    if (i2c_flags.error ==1)
     {
       i2c_exeption();
     }
    if (temp & 0x80 ==0)
     {
       temp = 0x80;
       i2c_write_data(time_address);
     }

*/

    while (1)
     {
       _asm ("NOP");
     }

    return 0;
		
}



//#include "uart.h"
//#include "interrupts.h"
