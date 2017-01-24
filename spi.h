void spi_setup(void)
 {
    SPI_CR1=0x7C;       //ну тип вот
		//SPI_CR2 |= SPI_CR2_SSM;	//включен режим дрыганья ногой SS по биту SS
		//SPI_ICR |= SPI_ICR_TXEI;
		//SPI_CR2 |= SPI_CR2_SSM;
 }
void SPI_Send1 (void)   //отправка первого байта SPI
{
  SPI_DR = k155_data;
  spi_queue++;
}	

void SPI_Send2 (void)   //отправка второго байта
{
  SPI_DR=lamp_number_data;
  spi_queue = 1;
}

void SPI_Send(uint8_t msg)
{
	SPI_DR = msg;
	
	while((SPI_SR & SPI_SR_BSY) != 0)
	{
		temp = SPI_SR;
	}
}