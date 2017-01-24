
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
	CLK_CKDIVR=0;                //��� ���������
  CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //������������ �� TIM1, UART1, SPI i I2C
	
	EXTI_CR1 = 0x10; 

  //��������� ������================
    PA_DDR=0x08; //0b000001000; //����� �� ������� ���������, ���� �� ������ � ���
    PA_CR1=0xff;        //�� ������ �������, �� ������ ���-����
    PA_ODR |= (1<<3);
		//PA_CR2=0xff;        //���� ����������

   // PB_DDR=; //
   // PB_CR1=;        //�� ������ �������, �� ������ ���-����
   // PB_CR2=;        //���� ����������

    PC_DDR=0x60; //0b01100000; //SPI �� �����, �������� �� ����
    PC_CR1=0xff;        //�� ������ �������, �� ������ ���-����
		
    PC_CR2 |= (1<<4) | (1<<3);        //���� ����������

		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM �� ����
    PD_CR1=0xff;        //�� ������ �������, �� ������ ���-����
    PD_ODR = (1 << 3);
		//PD_CR2=0xff;        //���� ����������

  //��������� I2C ================
   
		i2c_master_init(16000000, 100000);
		
		timers_int_off();
	//�������� ���������� ���
		i2c_rd_reg(0xD0, 0, time_pointer, 1);
		i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//��������� 1Hz ������
	//���������, ���� ����� �� �����
	if((seconds & 0x80) == 0x80)
	{
		seconds = 0;
		i2c_wr_reg(ds_address, 0,time_pointer, 1);
	}
		i2c_rd_reg(0xD0, 0, &seconds, 1); 	
		i2c_rd_reg(0xD0, 1, &minutes, 1);
		i2c_rd_reg(0xD0, 2, &hours, 1);
		
		timers_int_on();
		
 //��������� SPI ================
    spi_setup();
	//	SPI_CR2 |= SPI_CR2_SSI;
		
		//SPI_Send(0b10101010);
	//��������� UART
		uart_setup();
		UART_Send('h');
		
  //��������� �������� ===========
    timer1_setup( 65500,0xffff);//������� � �� � ��� ��������
		timer2_setup();
		timer1_start();
		timer2_start(TIM2_TOP);
  
		
		
		UART_Send(seconds);

		_asm ("RIM");  //on interupts
//		SPI_CR2 |= SPI_CR2_SSI;
		//SPI_CR2 &=~ SPI_CR2_SSI;
		
	//	SPI_Send(temp2);
	while(1);

    return 0;
		
}
