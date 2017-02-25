void i2c_start(uint8_t, uint8_t, uint8_t);
void spi_send(uint8_t);
void timers_int_off(void);
void timers_int_on(void);
void time_refresh(void);
void 		digits_shift_init(void);
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
		TIM2_CCR1H = dots_upd >> 8;
		TIM2_CCR1L = dots_upd & 0xFF;
		TIM2_CCMR1 |= TIM2_CCMR_OCxPE;	//preload
		
    TIM2_IER |=	TIM2_IER_CC1IE | TIM2_IER_UIE;	//overflow int and compare 1   
    TIM2_PSCR = 0;
    TIM2_ARRH = 0;
    TIM2_ARRL = 0;
 } 
 
 // compare for numbers rolling (~10Hz)
 void timer1_comp_start(uint16_t val)
 {
		TIM1_IER |= TIM1_IER_CC1IE;
		TIM1_CCR1H = val >> 8;
		TIM1_CCR1L = val & 0xFF;
 }
 void timer1_comp_stop(void){
	 TIM1_IER &= ~TIM1_IER_CC1IE;
 }
 
 void timer1_start(void)
 {
   TIM1_CR1 |= TIM1_CR1_CEN;
 }
 
void timer2_start(uint16_t top_val)
{
  TIM2_ARRH =top_val >>8;
  TIM2_ARRL =top_val & 0xFF;
  TIM2_CR1 |= TIM2_CR1_CEN;
}

//1kHz timer ovwrflowed - swith on dots and digits
void Timer2_Overflow (void)
{
		TIM2_SR1 &= ~TIM2_SR1_UIF;
	
		timers_int_off();
		PA_ODR &= (0<<3);
		//spi_send(kostil_k155(temp2));	/* for debug */
		spi_send(kostil_k155(k155_data));
		spi_send(lamp_number_data | dots);
		while((SPI_SR & SPI_SR_BSY) != 0);
		PA_ODR |= (1<<3);
		timers_int_on();
}

// 1 Hz timer overflow - get time from rtc
void Timer1_overflow (void)
{
		TIM1_SR1 &= ~TIM1_SR1_UIF;
		dots = ~dots & DOTS_MASK;
	
		time_refresh();
		//roll numbers every 10 minutes
		if ((minutes == 0) && (shifting == 0)){
			tim1comp = 5950;	//top of tim1/10
			digits_shift_init();	//set every digit to zero
			timer1_comp_start(tim1comp);	//enable compare interrupt
			}
		if (minutes != 0 && minutes != 5){
			shifting = 0;	//disable block when minutes increased
			}
			
						/* time cprrection every day */
		if ((hours == 0) && (minutes == 0) && (seconds == 10) 
																		&& (correction == 1)){
			correction = 0;
			temp = 3;
			i2c_wr_reg(ds_address, 0, &temp, 1);
			
		}else if ((hours == 0) && (minutes == 0) && (seconds == 10) 
																		&& (correction == 0)){
			correction = 1;
		} 
}

//compare - swithing numbers
void timer1_compare(void){
		TIM1_SR1 &= ~TIM1_SR1_CC1IF;
		if(hours < 9){
		seconds_tens++;
		minutes_tens++;
		hours_tens++;
	
		seconds++;
		minutes++;
		hours++;
		tim1comp += 5950;
		timer1_comp_start(tim1comp);
		}
		else {					//stop rolling when 9 reached 
			shifting = 1;	//block rolling
			timer1_comp_stop();
			}
}

void timer2_compare(void)
{
	TIM2_SR1 &= ~TIM2_SR1_CC1IF;
	IWDG_KR = KEY_REFRESH; //	Watchdog reset
	
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
	schetchik = 0;
}
	else 
	{
		lamp_number_data = 0;
		schetchik = 1;
	}

		timers_int_off();
		PA_ODR &= (0<<3);
		spi_send(kostil_k155(k155_data));
		//spi_send(kostil_k155(temp2));	/* for debug */ 
		spi_send(lamp_number_data | dots);
		while((SPI_SR & SPI_SR_BSY) != 0);
		PA_ODR |= (1<<3);
		timers_int_on();
	return;
}

//	hotfix for i2c transmitting
void timers_int_off(void)
{
		TIM1_IER &= ~TIM1_IER_UIE;
		TIM2_IER = 0;
}
void timers_int_on(void)
{
		TIM1_IER |= TIM1_IER_UIE;
		TIM2_IER |=	TIM2_IER_CC1IE |TIM2_IER_UIE;	//overflow int and compare 1
}