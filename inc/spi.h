void spi_setup(void)
 {
    SPI_CR1=0x7C;       //this

 }

//	send byte and wait for complite (not for TXE!!!)
void spi_send(uint8_t msg)
{
	SPI_DR = msg;
	
	while((SPI_SR & SPI_SR_BSY) != 0)
	{
		temp = SPI_SR;
	}
}