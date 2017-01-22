void spi_setup(void)
 {
    SPI_CR1=0x7C;       //�� ��� ���
		SPI_ICR = 0x80;
		
 }
void SPI_Send1 (void)   //�������� ������� ����� SPI
{
  SPI_DR = deshifr_code_out;
  spi_queue++;
}	

void SPI_Send2 (void)   //�������� ������� �����
{
  SPI_DR=lamp_number_out;
  spi_queue = 1;
}

void SPI_Send(uint8_t msg)
{
	SPI_DR = msg;
}