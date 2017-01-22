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
   I2C_CR1 &=I2C_CR1_PE;   //запуск и2с
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