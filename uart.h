 void time_write(void);
 void uart_setup(void)
 {
   UART1_BRR1=0x68;     //9600 bod
    UART1_BRR2=0x03;
    UART1_CR2 |= UART1_CR2_REN; //прием
    UART1_CR2 |= UART1_CR2_TEN; //передача
    UART1_CR2 |= UART1_CR2_RIEN; //Прерывание по приему
		UART1_SR = 0;
 }
void UART_Send (uint8_t msg)
 {
	 //uint8_t temp = UART1_DR;
	 temp =msg;
	 while((UART1_SR & 0x80) == 0x00);
	 UART1_DR = msg;
 }
 void uart_routine(uint8_t data)
 {
	 // Если нужно установить время
	 if (timeset != 0 && timeset <= 5)
	 {
		* fresh_data_pointer-- = data-0x30;
		 timeset++;
		 return ;
	 }
	 if (timeset == 6)
	 {
		 *fresh_data_pointer = data-0x30;
		 timeset = 0;
		 time_write();
	 }
	 
	 if (data == 's')
		{
			timeset = 1;
			fresh_data_pointer = &fresh_hours_dec;
		}
	}