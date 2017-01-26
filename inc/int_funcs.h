void i2c_send_adress(void);
void i2c_send_data(void);

void UART_Resieved (void)
{
	uart_routine(UART1_DR);
}

void SPI_Transmitted(void)
{
	spi_send(temp3);
}

void I2C_Event(void)
{

}

void Keys_switched(void)
{
	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
	PC_CR2 = 0;
	timer2_start(0xff);	
}

void time_refresh (void)
{
	//let's read time
	i2c_rd_reg(0xD0, 0, &fresh_sec, 1); 	
	i2c_rd_reg(0xD0, 1, &fresh_min, 1);
	i2c_rd_reg(0xD0, 2, &fresh_hours, 1);
	
	//divide into tens and units
	seconds_tens = (fresh_sec & 0xf0)>>4;
	minutes_tens = (fresh_min & 0xf0)>>4;
	hours_tens = (fresh_hours & 0xf0)>>4;
	
	seconds = fresh_sec & 0x0f;
	minutes = fresh_min & 0x0f;
	hours = fresh_hours & 0x0f;
}