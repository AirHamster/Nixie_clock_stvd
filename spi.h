void spi_setup(void)
 {
    SPI_CR1= 0b01000100;//0x7C;       //this
	//	SPI_CR2 |= SPI_CR2_SSM | SPI_CR2_SSI;
		// реверсим порядок отправки байт
 }

//	send byte and wait for complite (not for TXE!!!)
void spi_send (void)
{
	
	//while((SPI_SR & SPI_SR_BSY) != 0)
	//{
	//}
	//SPI_DR = msg;
	SPI_SR = 0;
//	SPI_CR2 &= ~SPI_CR2_SSI;
	PA_ODR &= (0<<3);
	SPI_DR = k155_data;
	SPI_ICR |= SPI_ICR_TXEI;
}
void spi_send2 (void)
{
	SPI_SR = 0;
	SPI_ICR = 0;
	SPI_DR = lamp_number_data;
	while((SPI_SR & SPI_SR_BSY) != 0);
	PA_ODR |= (1<<3);
	//SPI_CR2 |= SPI_CR2_SSI;
}