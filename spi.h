void spi_setup(void)
 {
    SPI_CR1= 0b01110100;//0x7C;       //this
		// реверсим порядок отправки байт
 }

//	send byte and wait for complite (not for TXE!!!)
void spi_send(uint8_t msg)
{
	
	while((SPI_SR & SPI_SR_BSY) != 0)
	{
	}
	SPI_DR = msg;
}