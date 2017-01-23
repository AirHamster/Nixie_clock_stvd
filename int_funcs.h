void i2c_send_adress(void);
void i2c_send_data(void);

void UART_Resieved (void)
{
	//UART_Send(UART1_DR);
	uart_routine(UART1_DR);
}

void SPI_Transmitted(void)
{
	SPI_Send(temp);
}

void I2C_Event(void)
{
	temp = I2C_SR1;
	if ((I2C_SR1 & I2C_SR1_SB) == I2C_SR1_SB)
			{
				i2c_send_adress();
			}
			else if ((I2C_SR1 & I2C_SR1_ADDR) == I2C_SR1_ADDR)
			{
				i2c_send_data;
			}
			else i2c_send_data();
}

void Keys_switched(void)
{
	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
	PC_CR2 = 0;
	timer2_start(0xff);
	/*if ((EXTI_CR1 & 0b00110000) == 0b00100000)
		
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
		*/
	
}

void DS_interrupt (void)
{
	
}