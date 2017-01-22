
//******************************************************************************
// Инициализация I2C интерфейса      
// f_master_hz - частота тактирования периферии Fmaster          
// f_i2c_hz - скорость передачи данных по I2C             
//******************************************************************************                                   
void i2c_master_init(unsigned long f_master_hz, unsigned long f_i2c_hz){
  unsigned long int ccr;
   
  PB_DDR = (0<<4);//PB_DDR_DDR4);
	PB_DDR = (0<<5);//PB_DDR_DDR5);
	PB_ODR = (1<<5);//PB_ODR_ODR5);  //SDA
  PB_ODR = (1<<4);//PB_ODR_ODR4);  //SCL
   
  PB_CR1 = (0<<4);//PB_CR1_C14);
  PB_CR1 = (0<<5);//PB_CR1_C15);
   
  PB_CR2 = (0<<4);//PB_CR1_C24);
  PB_CR2 = (0<<5);//PB_CR1_C25);
   
  //Частота тактирования периферии MHz
  I2C_FREQR = 16;
  //Отключаем I2C
  I2C_CR1 |=~I2C_CR1_PE;
  //В стандартном режиме скорость I2C max = 100 кбит/с
  //Выбираем стандартный режим 
  I2C_CCRH |=~I2C_CCRH_FS;
  //CCR = Fmaster/2*Fiic= 12MHz/2*100kHz
  ccr = f_master_hz/(2*f_i2c_hz);
  //Set Maximum Rise Time: 1000ns max in Standard Mode
  //= [1000ns/(1/InputClockFrequencyMHz.10e6)]+1
  //= InputClockFrequencyMHz+1
  I2C_TRISER = 12+1;
  I2C_CCRL = ccr & 0xFF;
  I2C_CCRH = ((ccr >> 8) & 0x0F);
  //Включаем I2C
  I2C_CR1 |=I2C_CR1_PE;
	/*
	   I2C_FREQR =0x10;     //16MHz perif
   I2C_ITR =0x07;
   I2C_CCRL =0x50;      //100kHz i2c
   I2C_CCRH =0;
   I2C_TRISER =0x11;
   I2C_CR1 |=I2C_CR1_PE;   //запуск и2с
  */
	//Разрешаем подтверждение в конце посылки
  I2C_CR2 |=I2C_CR2_ACK;
}
 

//******************************************************************************
// Запись регистра slave-устройства
//******************************************************************************                                   
t_i2c_status i2c_wr_reg(unsigned char address, unsigned char reg_addr,
                              char * data, unsigned char length)
{                                  
                                 
  //Ждем освобождения шины I2C
  wait_event(I2C_SR3_BUSY, 10);
     
  //Генерация СТАРТ-посылки
  I2C_CR2 |= I2C_CR2_START;
  //Ждем установки бита SB
  wait_event(!I2C_SR1_SB, 1);
   
   
  //Записываем в регистр данных адрес ведомого устройства
  I2C_DR = address & 0xFE;
  //Ждем подтверждения передачи адреса
  wait_event(!I2C_SR1_ADDR, 1);
  //Очистка бита ADDR чтением регистра SR3
  I2C_SR3;
   
   
  //Ждем освобождения регистра данных
  wait_event(!I2C_SR1_TXE, 1);
  //Отправляем адрес регистра
  I2C_DR = reg_addr;
   
  //Отправка данных
  while(length--){
    //Ждем освобождения регистра данных
    wait_event(!I2C_SR1_TXE, 1);
    //Отправляем адрес регистра
    I2C_DR = *data++;
  }
   
  //Ловим момент, когда DR освободился и данные попали в сдвиговый регистр
  wait_event(!(I2C_SR1_TXE && I2C_SR1_BTF), 1);
   
  //Посылаем СТОП-посылку
  I2C_CR2 |= I2C_CR2_STOP;
  //Ждем выполнения условия СТОП
  wait_event(I2C_CR2_STOP, 1);
   
  return I2C_SUCCESS;
}
 
//******************************************************************************
// Чтение регистра slave-устройства
// Start -> Slave Addr -> Reg. addr -> Restart -> Slave Addr <- data ... -> Stop 
//******************************************************************************                                   
t_i2c_status i2c_rd_reg(unsigned char address, unsigned char reg_addr,
                              char * data, unsigned char length)
{
   
  //Ждем освобождения шины I2C
  //wait_event(I2C_SR3_BUSY, 10);
  while((I2C_SR3 & I2C_SR3_BUSY) != 0);   
  //Разрешаем подтверждение в конце посылки
  I2C_CR2 |= I2C_CR2_ACK;
   
  //Генерация СТАРТ-посылки
  I2C_CR2 |= I2C_CR2_START;
  //Ждем установки бита SB
  //wait_event(!I2C_SR1_SB, 1);
  while((I2C_SR1 & I2C_SR1_SB) == 0);  
  //Записываем в регистр данных адрес ведомого устройства
  I2C_DR = address & 0xFE;
  //Ждем подтверждения передачи адреса
  //wait_event(!I2C_SR1_ADDR, 1);
  while((I2C_SR1 & I2C_SR1_ADDR) == 0);
	//Очистка бита ADDR чтением регистра SR3
  temp = I2C_SR3;
   
  //Ждем освобождения регистра данных RD
  //wait_event(!I2C_SR1_TXE, 1);
  while((I2C_SR1 & I2C_SR1) == 0); 
  //Передаем адрес регистра slave-устройства, который хотим прочитать
  I2C_DR = reg_addr;
  //Ловим момент, когда DR освободился и данные попали в сдвиговый регистр
  //wait_event(!(I2C_SR1_TXE && I2C_SR1_BTF), 1);
  while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
  //Генерация СТАРТ-посылки (рестарт)
  I2C_CR2 |= I2C_CR2_START;
  //Ждем установки бита SB
  //wait_event(!I2C_SR1_SB, 1);
  while((I2C_SR1 & I2C_SR1_SB) == 0); 
  //Записываем в регистр данных адрес ведомого устройства и переходим
  //в режим чтения (установкой младшего бита в 1)
  I2C_DR = address | 0x01;
   
  //Дальше алгоритм зависит от количества принимаемых байт
  //N=1
  if(length == 1){
    //Запрещаем подтверждение в конце посылки
    I2C_CR2 |= I2C_CR2_ACK;
    //Ждем подтверждения передачи адреса
    //wait_event(!I2C_SR1_ADDR, 1);
    while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
    //Заплатка из Errata
    _asm ("SIM");  //on interupts
    //Очистка бита ADDR чтением регистра SR3
    temp = I2C_SR3;
     
    //Устанавлием бит STOP
    I2C_CR2 |= I2C_CR2_STOP;
    //Заплатка из Errata
    _asm ("RIM");  //on interupts;
     
    //Ждем прихода данных в RD
    //wait_event(!I2C_SR1_RXNE, 1);
    while((I2C_SR1 & I2C_SR1_RXNE) == 0); 
    //Читаем принятый байт
    *data = I2C_DR;
  } 
  //N=2
  else if(length == 2){
    //Бит который разрешает NACK на следующем принятом байте
    I2C_CR2 |= I2C_CR2_POS;
    //Ждем подтверждения передачи адреса
    wait_event(!I2C_SR1_ADDR, 1);
    //Заплатка из Errata
    _asm ("SIM");  //on interupts;
    //Очистка бита ADDR чтением регистра SR3
    I2C_SR3;
    //Запрещаем подтверждение в конце посылки
    I2C_CR2 &= ~I2C_CR2_ACK;
    //Заплатка из Errata
    _asm ("RIM");  //on interupts;
    //Ждем момента, когда первый байт окажется в DR,
    //а второй в сдвиговом регистре
    wait_event(!I2C_SR1_BTF, 1);
     
    //Заплатка из Errata
    _asm ("SIM");  //on interupts;
    //Устанавлием бит STOP
    I2C_CR2 |= I2C_CR2_STOP;
    //Читаем принятые байты
    *data++ = I2C_DR;
    //Заплатка из Errata
    _asm ("RIM");  //on interupts;
    *data = I2C_DR;
  } 
  //N>2
  else if(length > 2){
    //Ждем подтверждения передачи адреса
    wait_event(!I2C_SR1_ADDR, 1);
     
    //Заплатка из Errata
    _asm ("SIM");  //on interupts;
     
    //Очистка бита ADDR чтением регистра SR3
    I2C_SR3;
     
    //Заплатка из Errata
    _asm ("RIM");  //on interupts;
     
    while(length-- > 3 && tmo){
      //Ожидаем появления данных в DR и сдвиговом регистре
      wait_event(!I2C_SR1_BTF, 1);
      //Читаем принятый байт из DR
      *data++ = I2C_DR;
    }
    //Время таймаута вышло
    if(!tmo) return I2C_TIMEOUT;
     
    //Осталось принять 3 последних байта
    //Ждем, когда в DR окажется N-2 байт, а в сдвиговом регистре
    //окажется N-1 байт
    wait_event(!I2C_SR1_BTF, 1);
    //Запрещаем подтверждение в конце посылки
    I2C_CR2 &= ~I2C_CR2_ACK;
    //Заплатка из Errata
    _asm ("SIM");  //on interupts;
    //Читаем N-2 байт из RD, тем самым позволяя принять в сдвиговый
    //регистр байт N, но теперь в конце приема отправится посылка NACK
    *data++ = I2C_DR;
    //Посылка STOP
    I2C_CR2 |= I2C_CR2_STOP;
    //Читаем N-1 байт
    *data++ = I2C_DR;
    //Заплатка из Errata
    _asm ("RIM");  //on interupts;
    //Ждем, когда N-й байт попадет в DR из сдвигового регистра
    wait_event(!I2C_SR1_RXNE, 1);
    //Читаем N байт
    *data++ = I2C_DR;
  }
   
  //Ждем отправки СТОП посылки
  //wait_event(I2C_CR2_STOP, 1);
  while((I2C_CR2 & I2C_CR2_STOP) == 0);
	//Сбрасывает бит POS, если вдруг он был установлен
  I2C_CR2 &= ~I2C_CR2_POS;
   
  return I2C_SUCCESS;
}












int sI2C_Send_data (unsigned char address, unsigned char data, unsigned char direction )
{

}
//--------------I2C_functions-------------------
void i2c_init(void)
 {
   I2C_FREQR =0x10;     //16MHz perif
   I2C_ITR =0x07;
   I2C_CCRL =0x50;      //100kHz i2c
   I2C_CCRH =0;
   I2C_TRISER =0x11;
   I2C_CR1 |=I2C_CR1_PE;   //запуск и2с
 }

void i2c_start(uint8_t rorw, uint8_t start_adr, uint8_t end_adr)        // OK
 {
   i2c_flags.status =busy;
   i2c_flags.rw =rorw;
   i2c_start_adr =start_adr;
   i2c_end_adr =end_adr;

   if ((rorw == 1) && (i2c_flags.first_send) !=1)
    {
      i2c_flags.first_send =1;
      i2c_current_adr =start_adr;
    }

   I2C_CR2 |= I2C_CR2_START;
 }      //вроде норм



void i2c_send_adress(void)      //   OK
 {
   if (i2c_flags.rw == read && i2c_flags.first_send ==1)
    {I2C_DR =ds_address || write;}

   else if (i2c_flags.rw ==read && i2c_flags.first_send ==0)
    {I2C_DR =ds_address || read;}

   else if (i2c_flags.rw == write)
    {I2C_DR =ds_address || write;}

   //i2c_first_send =1;
 }      //OK

void i2c_send_data()
 {
   if (i2c_flags.rw == write)
    {
   if   (i2c_flags.first_send == 1)
    {
      I2C_DR = i2c_current_adr++;
      i2c_flags.first_send =0;
      return;
    }
  else if (i2c_flags.first_send ==0)
   {
     if (i2c_current_adr++ <= i2c_end_adr-1)
      {
        I2C_DR = *(data_pointer++);
      }
     else
      {
        I2C_CR2 &= ~I2C_CR2_ACK;       //NACK для прекращения обмена
        I2C_CR2 |= I2C_CR2_STOP;      //завершаем
        I2C_DR =*data_pointer;
      }
      }
    }
  else if (i2c_flags.rw ==read)
   {

   if   (i2c_flags.first_send == 1)
    {
      I2C_DR = i2c_current_adr++;
      //i2c_first_send =0;
      return;
    }
  else if (i2c_flags.first_send ==0)
   {
     if (i2c_current_adr++ < i2c_end_adr-1)
      {
        *(data_pointer++) =I2C_DR;
      }
     else
      {
        I2C_CR2 &= ~I2C_CR2_ACK;       //NACK для прекращения обмена
        I2C_CR2 |= I2C_CR2_STOP;      //завершаем
        *(data_pointer) =I2C_DR;
				UART_Send(seconds);
      }

   }
  }






   if (data_type == 1 && time_pointer != &hours)
    {
      I2C_CR2 |= I2C_CR2_ACK;       //вернем АСК для продолжения приема
      I2C_DR = (*time_pointer || (*(time_pointer+1) <<4)) || 0x80;
      time_pointer +=2;

      //если приблизились к отправке последнего байта времени
        if (time_pointer == &hours)
      {
        I2C_CR2 &= ~I2C_CR2_ACK;       //NACK для прекращения обмена
        I2C_CR2 |= I2C_CR2_STOP;      //завершаем
        I2C_DR = (*time_pointer || (*(time_pointer+1) <<4)) || 0x80;
        time_pointer =&hours;
      }
    }
   if (data_type ==2)
    {
      I2C_CR2 &= ~I2C_CR2_ACK;       //NACK для прекращения обмена
        I2C_CR2 |= I2C_CR2_STOP;      //завершаем
      I2C_DR = 0x11;            //тупо настроили выход с ножки
    }
 }

void i2c_read_data(uint8_t address)
 {
   i2c_start(read, address, address);
 }

void i2c_write_data (uint8_t address)
 {
   i2c_start(write, address, address);
 }
void I2C_ack_time(void)
 {
   data_pointer = &fresh_sec;
   flags.time_ack =1;
   i2c_flags.rw =1;    //бит направление данных
   i2c_start(read, time_address, time_address+2);

 }
void  i2c_write_time(void)
 {
  data_pointer =&fresh_sec;     ////////????????????????????????
  i2c_flags.rw =0;      //бит направление данных
  i2c_start(write, time_address, time_address+2);
 }

void i2c_exeption(void)
 {
   // TODO: обработка ошибки
 }
 
 void i2c_stupid_read(void)
 {
	 I2C_CR2 = I2C_CR2_START;
		while ((I2C_SR1 & 1) == 0);
			I2C->DR = ds_address || 1;
				while (I2C_SR1 != 2)//(I2C_SR1 & I2C_SR1_ADDR) == 0)
				{
				temp = I2C_SR1;	
			};
				
				temp = I2C_SR3;
				I2C_CR2 = I2C_CR2_STOP;
				while ((I2C_SR1 & I2C_SR1_BTF) == 0);
					temp = I2C_DR;
					UART_Send(temp);
				}
				
				