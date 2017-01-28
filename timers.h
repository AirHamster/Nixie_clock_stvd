
void i2c_start(uint8_t, uint8_t, uint8_t);
void spi_send(uint8_t);
void timers_int_off(void);
void timers_int_on(void);
void time_refresh(void);
uint8_t kostil_k155(uint8_t);

// 1Hz timer
void timer1_setup(uint16_t tim_freq, uint16_t top)
 {
  TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
  TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; // 16 divider
  TIM1_ARRH = (top) >> 8; //	overflow frequency = 16М / 8 / 1000 = 2000 Гц
  TIM1_ARRL = (top)& 0xFF;

  TIM1_CR1 |= TIM1_CR1_URS; //only overflow int
  TIM1_EGR |= TIM1_EGR_UG;  //call Update Event
  TIM1_IER |= TIM1_IER_UIE; //int enable
 }
 
 //1kHz for lamp changing
void timer2_setup(void)
 {
		//compare for smooth dots switch
	//	TIM2_CCR1H = dots_upd >> 8;
	//	TIM2_CCR1L = dots_upd & 0xFF;
	//	TIM2_CCMR1 |= TIM2_CCMR_OCxPE;	//preload
		
    TIM2_IER |= TIM2_IER_UIE;;	//overflow int and compare 1   
    TIM2_PSCR = 0;
    TIM2_ARRH = 0;
    TIM2_ARRL = 0;
		
	
 }
 
 void timer1_start(void)
 {
   TIM1_CR1 |= TIM1_CR1_CEN; //Запускаем таймер
 }
 
void timer2_start(uint16_t top_val)
{
  TIM2_ARRH =top_val >>8;
  TIM2_ARRL =top_val & 0xFF;
  TIM2_CR1 |= TIM2_CR1_CEN;
}

void Timer2_Overflow (void)
{
	TIM2_SR1 &= ~TIM2_SR1_UIF;
	
	/*
	switch (lamp_number)
	{
	case 0:
	k155_data = hours_tens; 
	break;
	case 1:
	k155_data = hours;
	break;
	case 2:
	k155_data = minutes_tens;
	break;
	case 3:
	k155_data = minutes;
	break;
	}

	if (lamp_number < 3)
		{
			lamp_number_data = (1<<(lamp_number++));
		}
		else if (lamp_number >= 3)
		{
			lamp_number_data = (1<<(lamp_number));
			lamp_number = 0;
			
		}
		*/
	if (schetchik == 1)
	{
	switch (lamp_number)
	{
	case 0:
	k155_data = hours_tens; 
	break;
	case 1:
	k155_data = hours;
	break;
	case 2:
	k155_data = minutes_tens;
	break;
	case 3:
	k155_data = minutes;
	break;
	}

	if (lamp_number < 3)
		{
			lamp_number_data = (1<<(lamp_number++));
		}
		else if (lamp_number >= 3)
		{
			lamp_number_data = (1<<(lamp_number));
			lamp_number = 0;
			
		}
			timers_int_off();
	PA_ODR &= (0<<3);
	
		//spi_send(kostil_k155(temp2));
	spi_send(kostil_k155(k155_data));
	if (schetchik2++ <= 4)
	{
	spi_send(lamp_number_data);
}
	else
	{
		spi_send(lamp_number_data | dots);
		schetchik2 = 0;
	}
	
	while((SPI_SR & SPI_SR_BSY) != 0);
	PA_ODR |= (1<<3);
	timers_int_on();
	
	schetchik = 0;
}
	else 
	{
		schetchik = 1;
	timers_int_off();
	PA_ODR &= (0<<3);
	
	
	//spi_send(kostil_k155(temp2));
	spi_send(kostil_k155(k155_data));
	//spi_send(0);
	spi_send(0);
	
	while((SPI_SR & SPI_SR_BSY) != 0);
	PA_ODR |= (1<<3);
	timers_int_on();
	}
	return;
}

void Timer1_overflow (void){
	TIM1_SR1 = 0;
	if (dots_on == 0){
		dots_on = 1;
		dots = 0b00010000;
	}
	else{
		dots_on = 0;
		dots = 0;
	}
	//dots = ~dots;
	//dots &= 0b00010000;
	time_refresh();
}

void timer2_compare(void)
{
	TIM2_SR1 &= ~TIM2_SR1_CC1IF;
		
		switch (lamp_number)
	{
	case 0:
	k155_data = hours_tens; 
	break;
	case 1:
	k155_data = hours;
	break;
	case 2:
	k155_data = minutes_tens;
	break;
	case 3:
	k155_data = minutes;
	break;
	}

	if (lamp_number < 3)
		{
			lamp_number_data = (1<<(lamp_number++));
		}
		else if (lamp_number >= 3)
		{
			lamp_number_data = (1<<(lamp_number));
			lamp_number = 0;
		}
		
	if (dots_on == 1){
		if (dots_upd < 15000){
			dots_upd +=15;
			TIM2_CCR1H = dots_upd >> 8;
			TIM2_CCR1L = dots_upd & 0xFF;
			
			timers_int_off();
			PA_ODR &= (0<<3);
			spi_send(kostil_k155(k155_data));
			spi_send(lamp_number_data | dots);
			PA_ODR |= (1<<3);
			timers_int_on();
		}
	}
		else{
			if (dots_upd > 0)
			{
				dots_upd -= 15;
				TIM2_CCR1H = dots_upd >> 8;
				TIM2_CCR1L = dots_upd & 0xFF;
				
				timers_int_off();
				PA_ODR &= (0<<3);
				spi_send(kostil_k155(k155_data));
				spi_send(lamp_number_data | dots);
				while((SPI_SR & SPI_SR_BSY) != 0);
				PA_ODR |= (1<<3);
				timers_int_on();
				
			}
		}
	return;
}

//	hotfix for i2c transmitting
void timers_int_off(void)
{
	TIM1_IER &= ~TIM1_IER_UIE;
	//TIM2_IER &= ~TIM2_IER_UIE;
	TIM2_IER = 0;
}


void timers_int_on(void)
{
	TIM1_IER |= TIM1_IER_UIE;
	TIM2_IER |= TIM2_IER_UIE; //TIM2_IER_CC1IE;	//overflow int and compare 1
}