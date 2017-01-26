
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
		

  //��������� ������================
    PA_DDR=(1<<3) | (1<<2); //0b000001000; //����� �� ������� ���������, ���� �� ������ � ���
    PA_CR1= 0xff;        //�� ������ �������, �� ������ ���-����
    PA_ODR |= (1<<3);
		PA_CR2 |=(1<<3);        //���� ���������� �� PA1 ��� 1hz

    PC_DDR=0x60; //0b01100000; // �������� �� ����
    PC_CR1=0xff;        //�� ������ �������, �� ������ ���-����
    PC_CR2 |= (1<<4) | (1<<3);        //���� ���������� �� �������

		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM �� ����
    PD_CR1=0xff;        //�� ������ �������, �� ������ ���-����
    PD_ODR = (1 << 3);
		
		

		
	//��������� SPI ================
    spi_setup();
		
	//��������� UART
		uart_setup();
		UART_Send('h');
		
  //��������� �������� ===========
    timer1_setup( 65500,0xffff);//������� � �� � ��� ��������
		timer2_setup();
		timer1_start();
		timer2_start(TIM2_TOP);
  
	
		 //��������� I2C ================
   
		i2c_master_init(16000000, 100000);
	//�������� ���������� ���	
		timers_int_off();
		
		i2c_rd_reg(ds_address, 7, &temp, 1);
	if (temp != 0b10010000)	// if OUT and SWQ == 0
		{
			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//��������� 1Hz ������
		}
		
		i2c_rd_reg(ds_address, 0, time_pointer, 1);
		
	//���������, ���� ����� �� �����
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
		
		EXTI_CR1 = 0b00110011;//((1<<4) | (1<<0));//0x10;	//������� ���������� �� ������ � � � �� ����������� ������ 
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
