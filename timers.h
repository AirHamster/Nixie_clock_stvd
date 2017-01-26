
void i2c_start(uint8_t, uint8_t, uint8_t);
void SPI_Send(uint8_t);
void timers_int_off(void);
void timers_int_on(void);

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
	k155_data = hours_decades; 
	break;
	case 1:
	k155_data = hours;
	break;
	case 2:
	k155_data = minutes_decades;
	break;
	case 3:
	k155_data = minutes;
	break;
}
	timers_int_off();
	PA_ODR &= (0<<3);
	
	SPI_Send(k155_data);
		
	SPI_Send(lamp_number_data);
	
	PA_ODR |= (1<<3);
	timers_int_on();
	return;
}

void Timer1_Compare_1 (void)
{
	TIM1_SR1 = 0;
		//погнали читать время
	i2c_rd_reg(0xD0, 0, &seconds, 1); 	
	i2c_rd_reg(0xD0, 1, &minutes, 1);
	i2c_rd_reg(0xD0, 2, &hours, 1);
	
	//делим на декады и еденицы
	seconds_decades = (seconds & 0xf0)>>4;
	minutes_decades = (minutes & 0xf0)>>4;
	hours_decades = (hours & 0xf0)>>4;
	
	seconds &= 0x0f;
	minutes &= 0x0f;
	hours &= 0x0f;
}





//односекундный таймер
void timer1_setup(uint16_t tim_freq, uint16_t top)
 {
  TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
  TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; //Делитель на 16
  TIM1_ARRH = (top) >> 8; //Частота переполнений = 16М / 8 / 1000 = 2000 Гц
  TIM1_ARRL = (top)& 0xFF;

  TIM1_CR1 |= TIM1_CR1_URS; //Прерывание только по переполнению счетчика
  TIM1_EGR |= TIM1_EGR_UG;  //Вызываем Update Event
  TIM1_IER |= TIM1_IER_UIE; //Разрешаем прерывание
 }
 
 //1kHz для смены ламп
void timer2_setup(void)
 {
  
    TIM2_IER |= TIM2_IER_UIE;         //прерывание по переполнению
    TIM2_PSCR = 0;
    TIM2_ARRH = 0;
    TIM2_ARRL = 0;
 }
 
 void Key_interrupt (void)
{
  pins = PC_IDR;           //сохранили состояние порта
 
}


//костыли для спокойного общения по i2c
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






//код для обработки кнопок


/*
	TIM2_SR1 = 0;
	UART_Send('k');
	
  if (pins==PC_IDR)
  {
    if(PC_IDR == PC_IDR & (1<<3))
    {
      Menu_key_pressed();
      timer2_start(0xFFF0);     //ставим задержку перед сменой
    }
    else if (PC_IDR == PC_IDR & (1<<4))
    {
      Inc_key_pressed();
      timer2_start(0xFFF0);
    }
    else if ((PC_IDR== PC_IDR & (1<<3)) && (PC_IDR== PC_IDR & (1<<4)))
     {
       two_keys =1;
       //Two_keys_pressed();
      timer2_start(0xFFF0);
     }
  }
  if (pins !=PC_IDR)
   {
     if (two_keys ==1)  //пины сменились и оба отжались
      {
        two_keys =0;
        tunning=0;
//        i2c_write_time();
      }
   }
	 PC_CR2 |= (1<<4) | (1<<3);        //есть прерывания
*/