void spi_setup(void)
 {
    SPI_CR1=0x7C;       //ну тип вот
		SPI_ICR = 0x80;
		
 }
void SPI_Send1 (void)   //отправка первого байта SPI
{
  SPI_DR = deshifr_code_out;
  spi_queue++;
}	

void SPI_Send2 (void)   //отправка второго байта
{
  SPI_DR=lamp_number_out;
  spi_queue = 1;
}

void SPI_Send(uint8_t msg)
{
	SPI_DR = msg;
}