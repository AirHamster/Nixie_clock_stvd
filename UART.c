void uart_setup(void)
 {
   UART1_BRR1=0x68;     //9600 bod
    UART1_BRR2=0x03;
    UART1_CR2 |= UART1_CR2_REN; //�����
    UART1_CR2 |= UART1_CR2_TEN; //��������
    UART1_CR2 |= UART1_CR2_RIEN; //���������� �� ������
		UART1_SR = 0;
 }
void UART_Send (void)
 {
//	 uint8_t temp = UART1_DR;
	 UART1_DR = temp;
 }