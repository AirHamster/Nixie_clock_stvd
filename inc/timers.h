
void i2c_start(uint8_t, uint8_t, uint8_t);
void spi_send(uint8_t);
void timers_int_off(void);
void timers_int_on(void);
void time_refresh(void);

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
	TIM2_SR1 = 0;
	
	if (lamp_number <= 3)
		{
			lamp_number_data = (1<<(lamp_number++));
		}
		else if (lamp_number >= 4)
		{
			lamp_number = 1;
			lamp_number_data = (1<<(lamp_number++));
		}
	
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
	timers_int_off();
	PA_ODR &= (0<<3);
	
	spi_send(k155_data);
		
	spi_send(lamp_number_data);
	
	PA_ODR |= (1<<3);
	timers_int_on();
	return;
}

void Timer1_Compare_1 (void)
{
	TIM1_SR1 = 0;
	time_refresh();
}

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
  
    TIM2_IER |= TIM2_IER_UIE;	//overflow int   
    TIM2_PSCR = 0;
    TIM2_ARRH = 0;
    TIM2_ARRL = 0;
 }
 
//	hotfix for i2c transmitting
void timers_int_off(void)
{
	TIM1_IER &= ~TIM1_IER_UIE;
	TIM2_IER &= ~TIM2_IER_UIE;
}

void timers_int_on(void)
{
	TIM1_IER |= TIM1_IER_UIE;
	TIM2_IER |= TIM2_IER_UIE;
}