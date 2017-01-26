
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
  //wait_event(I2C_SR3_BUSY, 10);
  while((I2C_SR3 & I2C_SR3_BUSY) !=0);   
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
  I2C_SR3;
   
   
  //Ждем освобождения регистра данных
  //wait_event(!I2C_SR1_TXE, 1);
  while((I2C_SR1 & I2C_SR1_TXE) ==0);
	//Отправляем адрес регистра
  I2C_DR = reg_addr;
   
  //Отправка данных
  while(length--){
    //Ждем освобождения регистра данных
    //wait_event(!I2C_SR1_TXE, 1);
    while((I2C_SR1 & I2C_SR1_TXE) == 0);
		//Отправляем адрес регистра
    I2C_DR = *data++;
  }
   
  //Ловим момент, когда DR освободился и данные попали в сдвиговый регистр
  //wait_event(!(I2C_SR1_TXE && I2C_SR1_BTF), 1);
  while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
  //Посылаем СТОП-посылку
  I2C_CR2 |= I2C_CR2_STOP;
  //Ждем выполнения условия СТОП
  //wait_event(I2C_CR2_STOP, 1);
  while((I2C_CR2 & I2C_CR2_STOP) == 0); 
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
	//I2C_CR1 &= ~I2C_CR1_PE;
	//I2C_CR1 |= I2C_CR1_PE;
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
    I2C_CR2 &= ~I2C_CR2_ACK;
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
   // wait_event(!I2C_SR1_ADDR, 1);
    while((I2C_SR1 & I2C_SR1_ADDR) == 0);
		//Заплатка из Errata
    _asm ("SIM");  //on interupts;
    //Очистка бита ADDR чтением регистра SR3
    temp = I2C_SR3;
    //Запрещаем подтверждение в конце посылки
    I2C_CR2 &= ~I2C_CR2_ACK;
    //Заплатка из Errata
    _asm ("RIM");  //on interupts;
    //Ждем момента, когда первый байт окажется в DR,
    //а второй в сдвиговом регистре
    //wait_event(!I2C_SR1_BTF, 1);
    while((I2C_SR1 & I2C_SR1_BTF) == 0); 
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
    //wait_event(!I2C_SR1_ADDR, 1);
    while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
    //Заплатка из Errata
    _asm ("SIM");  //on interupts;
     
    //Очистка бита ADDR чтением регистра SR3
    I2C_SR3;
     
    //Заплатка из Errata
    _asm ("RIM");  //on interupts;
     
    while(length-- > 3){
      //Ожидаем появления данных в DR и сдвиговом регистре
      //wait_event(!I2C_SR1_BTF, 1);
      while((I2C_SR1 & I2C_SR1_BTF) == 0);
			//Читаем принятый байт из DR
      *data++ = I2C_DR;
    }
    //Время таймаута вышло
  //  if(!tmo) return I2C_TIMEOUT;
     
    //Осталось принять 3 последних байта
    //Ждем, когда в DR окажется N-2 байт, а в сдвиговом регистре
    //окажется N-1 байт
    //wait_event(!I2C_SR1_BTF, 1);
    while((I2C_SR1 & I2C_SR1_BTF) == 0);
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
    //wait_event(!I2C_SR1_RXNE, 1);
    while((I2C_SR1 & I2C_SR1_RXNE) == 0);
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