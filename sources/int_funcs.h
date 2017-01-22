void UART_Resieved (void)
{
	UART_Send(UART1_DR);
}

void SPI_Transmitted(void)
{
	SPI_Send(temp);
}

void I2C_Event(void)
{
	
}

void Keys_switched(void)
{
	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
	
	if ((EXTI_CR1 & 0b00110000) == 0b00100000)
		
		{
			UART_Send('r');
		}
		else // ((EXTI_CR1 & 0b00110000) == 0b00010000)
		{
			UART_Send('f');
		}
		
		temp2 = 0;
		//for (temp2 = 0; temp2 <= 80000; temp2++)
		do
		{
			temp2++;
			_asm ("NOP");
			_asm ("NOP");
			
			_asm ("NOP");
			_asm ("NOP");
			_asm ("NOP");
			_asm ("NOP");
			
			_asm ("NOP");
			_asm ("NOP");
			_asm ("NOP");
			
			_asm ("NOP");
			_asm ("NOP");
			_asm ("NOP");
			_asm ("NOP");
			
			_asm ("NOP");
			_asm ("NOP");
			_asm ("NOP");

			
		}
		while (temp2 <= 250);
	
	_asm ("NOP");
	temp2 = 0;
		
	
}

void DS_interrupt (void)
{
	
}