
void i2c_start(uint8_t, uint8_t, uint8_t);

void timer2_start(uint16_t top_val)
{
  TIM2_ARRH =top_val >>8;
  TIM2_ARRL =top_val & 0xFF;
  TIM2_CR1 |= TIM2_CR1_CEN;
}

void Timer2_Overflow (void)
{
	TIM2_SR1 = 0;
	UART_Send('k');
	
  if (pins==PC_IDR)
  {
    if(PC_IDR == PC_IDR & (1<<3))
    {
      Menu_key_pressed();
      timer2_start(0xFFF0);     //������ �������� ����� ������
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
     if (two_keys ==1)  //���� ��������� � ��� ��������
      {
        two_keys =0;
        tunning=0;
//        i2c_write_time();
      }
   }
	 PC_CR2 |= (1<<4) | (1<<3);        //���� ����������
}

void Timer1_Compare_1 (void)
{
	TIM1_SR1 = 0;
  lamp_number_out = lamp_number;                //������� � �������� �������� ��� �����
	PD_ODR = ~PD_ODR & 1<<3;;
	UART_Send('t');
//  SPI_Send1();
	data_pointer = &seconds;
	i2c_start(1, 0x00, 0x00);
}



void timer1_start(void)
 {
   TIM1_CR1 |= TIM1_CR1_CEN; //��������� ������
 }

void timer1_setup(uint16_t tim_freq, uint16_t top)
 {
   //CLK_PCKENR2_bit.PCKEN21 = 1; //�������� ������������ ������� 1
  TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: ������� ������������ ���!!!!
  TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; //�������� �� 16
  TIM1_ARRH = (top) >> 8; //������� ������������ = 16� / 8 / 1000 = 2000 ��
  TIM1_ARRL = (top)& 0xFF;

  TIM1_CR1 |= TIM1_CR1_URS; //���������� ������ �� ������������ ��������
  TIM1_EGR |= TIM1_EGR_UG;  //�������� Update Event

  TIM1_IER |= TIM1_IER_UIE; //��������� ����������
  //TIM1_CR1_bit.CEN = 1; //��������� ������
 }
void timer2_setup(void)
 {
  //TIM2==========================
    TIM2_CR1 = TIM2_CR1_URS | TIM2_CR1_OPM;      //� ������ ������ ��������
    TIM2_IER = TIM2_IER_UIE;         //���������� �� ������������
    TIM2_PSCR = 0;
    TIM2_ARRH = 0;
    TIM2_ARRL = 0x64;
 }
 
 void Key_interrupt (void)
{
  pins = PC_IDR;           //��������� ��������� �����
  timer2_start(0x0064);       //��������� ������ ��� ������������
}