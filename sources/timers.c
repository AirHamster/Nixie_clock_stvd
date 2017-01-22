void timer2_start(uint16_t top_val)
{
  TIM2_ARRH =top_val >>8;
  TIM2_ARRL =top_val & 0xFF;
  TIM2_CR1 |= TIM2_CR1_CEN;
}

void Timer2_Overflow (void)
{
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
}

void Timer1_Compare_1 (void)
{
  lamp_number_out = lamp_number;                //выводим в регистры значения без точек
//  SPI_Send1();
}



void timer1_start(void)
 {
   TIM1_CR1 |= TIM1_CR1_CEN; //Запускаем таймер
 }

void timer1_setup(void)
 {
   //CLK_PCKENR2_bit.PCKEN21 = 1; //Включаем тактирование таймера 1
  TIM1_PSCRH = 0;
  TIM1_PSCRL = 7; //Делитель на 16
  TIM1_ARRH = (1000) >> 8; //Частота переполнений = 16М / 8 / 1000 = 2000 Гц
  TIM1_ARRL = (1000)& 0xFF;

  TIM1_CR1 |= TIM1_CR1_URS; //Прерывание только по переполнению счетчика
  TIM1_EGR |= TIM1_EGR_UG;  //Вызываем Update Event

  TIM1_IER |= TIM1_IER_UIE; //Разрешаем прерывание
  //TIM1_CR1_bit.CEN = 1; //Запускаем таймер
 }
void timer2_setup(void)
 {
  //TIM2==========================
    TIM2_CR1=0x0E;      //в режиме одного импульса
    TIM2_IER=1;         //прерывание по переполнению
    TIM2_PSCR=0;
    TIM2_ARRH=0;
    TIM2_ARRL=0x64;
 }