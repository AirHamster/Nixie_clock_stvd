//I2C_interrupts ------------------------------

//#pragma vector = I2C_SB_vector
@interrupt void Start_bit_sent(void)
 {

   i2c_send_adress();
 }

//#pragma vector =I2C_BTF_vector
@interrupt void i2c_data_send(void)
 {
   if(i2c_flags.rw ==read && i2c_flags.first_send ==1)
    {
      i2c_start (1, i2c_start_adr, i2c_end_adr);
      i2c_flags.first_send =0;
    }
   else
    {
      i2c_send_data();
    }
 }

//#pragma vector =I2C_BERR_vector
@interrupt void i2c_bus_error(void)
 {
   //сброс всего в ноль
 }

#pragma vector =I2C_ADDR_vector
@interrupt void i2c_address_send(void)
 {
  i2c_send_data();
 }




//---UART------------------------
#pragma vector =UART1_R_RXNE_vector
@interrupt void UART_RX_COMPLETE(void) // По UART пришел байт
{
uart_send('Y');

}

#pragma vector =TIM1_OVR_UIF_vector
@interrupt void Timer1_Overflow (void)
{

}

#pragma vector =EXTI0_vector
@interrupt void DS_signal (void)
{
  ds_tacts++;
  if (lamp_number == 4)
   {
     lamp_number =1;
   }
  else
   {
     lamp_number++;
   }

    temp=1;
  for (char i = 1; i <= lamp_number; i++)         //сдвинули еденицу на нужный номер оптопары
  {
    lamp_number_out =  temp<<1;
  }

  temp = dots;
  lamp_number_out = lamp_number_out | temp; //добивили значение точек

  switch(lamp_number)
    {
    case 1: deshifr_code_out = lamp1_digit;       break;
    case 2: deshifr_code_out = lamp2_digit;       break;
    case 3: deshifr_code_out = lamp3_digit;       break;
    case 4: deshifr_code_out = lamp4_digit;       break;
    }

  //spi_update
   SPI_Send1();
  //TODO:
//  timer1_start();     не сейчас

  if (ds_tacts == 0x1000)
  {
    ds_tacts = 0;
    I2C_ack_time();
    flags.time_upd =1;
  }

}

#pragma vector =EXTI2_vector
@interrupt void Key_press (void)
{
//time_setup
  pins=PC_IDR;           //сохранили состояние порта
  timer2_start(0x64);       //запустили таймер для отфильтровки
}

#pragma vector =SPI_TXE_vector
@interrupt void SPI_Send_Complete (void)
{
  if(spi_queue==2)
  {
    SPI_Send2();
      spi_queue = 1;
  }
}

//TODO :
#pragma vector =TIM2_OVR_UIF_vector
@interrupt void Timer2_Overflow (void)
{
  if (pins==PC_IDR)
  {
    if(PC_IDR_bit.IDR3==1)
    {
      Menu_key_pressed();
      timer2_start(0xFFF0);     //ставим задержку перед сменой
    }
    else if (PC_IDR_bit.IDR4==1)
    {
      Inc_key_pressed();
      timer2_start(0xFFF0);
    }
    else if ((PC_IDR_bit.IDR3==1) && (PC_IDR_bit.IDR4==1))
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
        i2c_write_time();
      }
   }
}

#pragma vector = TIM1_CAPCOM_CC1IF_vector       //шимка для точек
@interrupt void Timer1_Compare_1 (void)
{
  lamp_number_out = lamp_number;                //выводим в регистры значения без точек
  SPI_Send1();
}

