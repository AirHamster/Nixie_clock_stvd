void i2c_send_adress(void);
void i2c_send_data(void);

void UART_Resieved (void)
{
	//UART_Send(UART1_DR);
	uart_routine(UART1_DR);
}

void SPI_Transmitted(void)
{
	//PA_ODR |= (1<<3);
	//SPI_ICR &= ~SPI_ICR_TXEI;
	//SPI_CR2 &=~ SPI_CR2_SSI;
	SPI_Send(temp3);
//SPI_CR2 &= ~SPI_CR2_SSI;
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
}

void time_refresh (void)
{
		//погнали читать время
	i2c_rd_reg(0xD0, 0, &seconds, 1); 	
	i2c_rd_reg(0xD0, 1, &minutes, 1);
	i2c_rd_reg(0xD0, 2, &hours, 1);
	
	//делим на декады и еденицы
	seconds_decades = (seconds & 0xf0)>>4;
	minutes_decades = (minutes & 0xf0)>>4;
	hours_decades = (hours & 0xf0)>>4;
	
	seconds &= 0x0f;
	minutes &= 0x0f;
	hours &= 0x0f;
}