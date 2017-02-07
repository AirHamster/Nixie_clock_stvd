 void time_write(void);
 void uart_setup(void)
 {
		UART1_BRR1=0x68;     //9600 bod
    UART1_BRR2=0x03;
    UART1_CR2 |= UART1_CR2_REN; //reseiving
    UART1_CR2 |= UART1_CR2_TEN; //transmiting 
    UART1_CR2 |= UART1_CR2_RIEN; //reseive int
		UART1_SR = 0;
 }
 
void uart_send(uint8_t msg)
 {
		temp =msg;
		while((UART1_SR & 0x80) == 0x00);
		UART1_DR = msg;
 }
 void uart_routine(uint8_t data)
 {
		// if need to setup time
		temp2 = data - 0x30;
		if (timeset != 0 && timeset <= 5){
			* fresh_data_pointer-- = data-0x30;
			timeset++;
			return ;
			}
		if (timeset == 6){
			*fresh_data_pointer = data-0x30;
			timeset = 0;
			time_write();
			uart_send('O');
			uart_send('K');
			return;
		}
		// s - setup time
		if (data == 's'){
			timeset = 1;
			fresh_data_pointer = &fresh_hours_dec;
			return;
			}
		
		// t - time request
		if (data == 't'){
			uart_send(hours_tens+0x30);
			uart_send(hours+0x30);
			uart_send(':');	
			uart_send(minutes_tens+0x30);
			uart_send(minutes+0x30);
			uart_send(':'); 
			uart_send(seconds_tens+0x30);
			uart_send(seconds+0x30);
			uart_send(0x0A);
			}	
}