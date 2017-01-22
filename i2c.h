
//******************************************************************************
// ������������� I2C ����������      
// f_master_hz - ������� ������������ ��������� Fmaster          
// f_i2c_hz - �������� �������� ������ �� I2C             
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
   
  //������� ������������ ��������� MHz
  I2C_FREQR = 16;
  //��������� I2C
  I2C_CR1 |=~I2C_CR1_PE;
  //� ����������� ������ �������� I2C max = 100 ����/�
  //�������� ����������� ����� 
  I2C_CCRH |=~I2C_CCRH_FS;
  //CCR = Fmaster/2*Fiic= 12MHz/2*100kHz
  ccr = f_master_hz/(2*f_i2c_hz);
  //Set Maximum Rise Time: 1000ns max in Standard Mode
  //= [1000ns/(1/InputClockFrequencyMHz.10e6)]+1
  //= InputClockFrequencyMHz+1
  I2C_TRISER = 12+1;
  I2C_CCRL = ccr & 0xFF;
  I2C_CCRH = ((ccr >> 8) & 0x0F);
  //�������� I2C
  I2C_CR1 |=I2C_CR1_PE;
	/*
	   I2C_FREQR =0x10;     //16MHz perif
   I2C_ITR =0x07;
   I2C_CCRL =0x50;      //100kHz i2c
   I2C_CCRH =0;
   I2C_TRISER =0x11;
   I2C_CR1 |=I2C_CR1_PE;   //������ �2�
  */
	//��������� ������������� � ����� �������
  I2C_CR2 |=I2C_CR2_ACK;
}
 

//******************************************************************************
// ������ �������� slave-����������
//******************************************************************************                                   
t_i2c_status i2c_wr_reg(unsigned char address, unsigned char reg_addr,
                              char * data, unsigned char length)
{                                  
                                 
  //���� ������������ ���� I2C
  wait_event(I2C_SR3_BUSY, 10);
     
  //��������� �����-�������
  I2C_CR2 |= I2C_CR2_START;
  //���� ��������� ���� SB
  wait_event(!I2C_SR1_SB, 1);
   
   
  //���������� � ������� ������ ����� �������� ����������
  I2C_DR = address & 0xFE;
  //���� ������������� �������� ������
  wait_event(!I2C_SR1_ADDR, 1);
  //������� ���� ADDR ������� �������� SR3
  I2C_SR3;
   
   
  //���� ������������ �������� ������
  wait_event(!I2C_SR1_TXE, 1);
  //���������� ����� ��������
  I2C_DR = reg_addr;
   
  //�������� ������
  while(length--){
    //���� ������������ �������� ������
    wait_event(!I2C_SR1_TXE, 1);
    //���������� ����� ��������
    I2C_DR = *data++;
  }
   
  //����� ������, ����� DR ����������� � ������ ������ � ��������� �������
  wait_event(!(I2C_SR1_TXE && I2C_SR1_BTF), 1);
   
  //�������� ����-�������
  I2C_CR2 |= I2C_CR2_STOP;
  //���� ���������� ������� ����
  wait_event(I2C_CR2_STOP, 1);
   
  return I2C_SUCCESS;
}
 
//******************************************************************************
// ������ �������� slave-����������
// Start -> Slave Addr -> Reg. addr -> Restart -> Slave Addr <- data ... -> Stop 
//******************************************************************************                                   
t_i2c_status i2c_rd_reg(unsigned char address, unsigned char reg_addr,
                              char * data, unsigned char length)
{
   
  //���� ������������ ���� I2C
  //wait_event(I2C_SR3_BUSY, 10);
  while((I2C_SR3 & I2C_SR3_BUSY) != 0);   
  //��������� ������������� � ����� �������
  I2C_CR2 |= I2C_CR2_ACK;
   
  //��������� �����-�������
  I2C_CR2 |= I2C_CR2_START;
  //���� ��������� ���� SB
  //wait_event(!I2C_SR1_SB, 1);
  while((I2C_SR1 & I2C_SR1_SB) == 0);  
  //���������� � ������� ������ ����� �������� ����������
  I2C_DR = address & 0xFE;
  //���� ������������� �������� ������
  //wait_event(!I2C_SR1_ADDR, 1);
  while((I2C_SR1 & I2C_SR1_ADDR) == 0);
	//������� ���� ADDR ������� �������� SR3
  temp = I2C_SR3;
   
  //���� ������������ �������� ������ RD
  //wait_event(!I2C_SR1_TXE, 1);
  while((I2C_SR1 & I2C_SR1) == 0); 
  //�������� ����� �������� slave-����������, ������� ����� ���������
  I2C_DR = reg_addr;
  //����� ������, ����� DR ����������� � ������ ������ � ��������� �������
  //wait_event(!(I2C_SR1_TXE && I2C_SR1_BTF), 1);
  while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
  //��������� �����-������� (�������)
  I2C_CR2 |= I2C_CR2_START;
  //���� ��������� ���� SB
  //wait_event(!I2C_SR1_SB, 1);
  while((I2C_SR1 & I2C_SR1_SB) == 0); 
  //���������� � ������� ������ ����� �������� ���������� � ���������
  //� ����� ������ (���������� �������� ���� � 1)
  I2C_DR = address | 0x01;
   
  //������ �������� ������� �� ���������� ����������� ����
  //N=1
  if(length == 1){
    //��������� ������������� � ����� �������
    I2C_CR2 |= I2C_CR2_ACK;
    //���� ������������� �������� ������
    //wait_event(!I2C_SR1_ADDR, 1);
    while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
    //�������� �� Errata
    _asm ("SIM");  //on interupts
    //������� ���� ADDR ������� �������� SR3
    temp = I2C_SR3;
     
    //����������� ��� STOP
    I2C_CR2 |= I2C_CR2_STOP;
    //�������� �� Errata
    _asm ("RIM");  //on interupts;
     
    //���� ������� ������ � RD
    //wait_event(!I2C_SR1_RXNE, 1);
    while((I2C_SR1 & I2C_SR1_RXNE) == 0); 
    //������ �������� ����
    *data = I2C_DR;
  } 
  //N=2
  else if(length == 2){
    //��� ������� ��������� NACK �� ��������� �������� �����
    I2C_CR2 |= I2C_CR2_POS;
    //���� ������������� �������� ������
    wait_event(!I2C_SR1_ADDR, 1);
    //�������� �� Errata
    _asm ("SIM");  //on interupts;
    //������� ���� ADDR ������� �������� SR3
    I2C_SR3;
    //��������� ������������� � ����� �������
    I2C_CR2 &= ~I2C_CR2_ACK;
    //�������� �� Errata
    _asm ("RIM");  //on interupts;
    //���� �������, ����� ������ ���� �������� � DR,
    //� ������ � ��������� ��������
    wait_event(!I2C_SR1_BTF, 1);
     
    //�������� �� Errata
    _asm ("SIM");  //on interupts;
    //����������� ��� STOP
    I2C_CR2 |= I2C_CR2_STOP;
    //������ �������� �����
    *data++ = I2C_DR;
    //�������� �� Errata
    _asm ("RIM");  //on interupts;
    *data = I2C_DR;
  } 
  //N>2
  else if(length > 2){
    //���� ������������� �������� ������
    wait_event(!I2C_SR1_ADDR, 1);
     
    //�������� �� Errata
    _asm ("SIM");  //on interupts;
     
    //������� ���� ADDR ������� �������� SR3
    I2C_SR3;
     
    //�������� �� Errata
    _asm ("RIM");  //on interupts;
     
    while(length-- > 3 && tmo){
      //������� ��������� ������ � DR � ��������� ��������
      wait_event(!I2C_SR1_BTF, 1);
      //������ �������� ���� �� DR
      *data++ = I2C_DR;
    }
    //����� �������� �����
    if(!tmo) return I2C_TIMEOUT;
     
    //�������� ������� 3 ��������� �����
    //����, ����� � DR �������� N-2 ����, � � ��������� ��������
    //�������� N-1 ����
    wait_event(!I2C_SR1_BTF, 1);
    //��������� ������������� � ����� �������
    I2C_CR2 &= ~I2C_CR2_ACK;
    //�������� �� Errata
    _asm ("SIM");  //on interupts;
    //������ N-2 ���� �� RD, ��� ����� �������� ������� � ���������
    //������� ���� N, �� ������ � ����� ������ ���������� ������� NACK
    *data++ = I2C_DR;
    //������� STOP
    I2C_CR2 |= I2C_CR2_STOP;
    //������ N-1 ����
    *data++ = I2C_DR;
    //�������� �� Errata
    _asm ("RIM");  //on interupts;
    //����, ����� N-� ���� ������� � DR �� ���������� ��������
    wait_event(!I2C_SR1_RXNE, 1);
    //������ N ����
    *data++ = I2C_DR;
  }
   
  //���� �������� ���� �������
  //wait_event(I2C_CR2_STOP, 1);
  while((I2C_CR2 & I2C_CR2_STOP) == 0);
	//���������� ��� POS, ���� ����� �� ��� ����������
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
   I2C_CR1 |=I2C_CR1_PE;   //������ �2�
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
 }      //����� ����



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
        I2C_CR2 &= ~I2C_CR2_ACK;       //NACK ��� ����������� ������
        I2C_CR2 |= I2C_CR2_STOP;      //���������
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
        I2C_CR2 &= ~I2C_CR2_ACK;       //NACK ��� ����������� ������
        I2C_CR2 |= I2C_CR2_STOP;      //���������
        *(data_pointer) =I2C_DR;
				UART_Send(seconds);
      }

   }
  }






   if (data_type == 1 && time_pointer != &hours)
    {
      I2C_CR2 |= I2C_CR2_ACK;       //������ ��� ��� ����������� ������
      I2C_DR = (*time_pointer || (*(time_pointer+1) <<4)) || 0x80;
      time_pointer +=2;

      //���� ������������ � �������� ���������� ����� �������
        if (time_pointer == &hours)
      {
        I2C_CR2 &= ~I2C_CR2_ACK;       //NACK ��� ����������� ������
        I2C_CR2 |= I2C_CR2_STOP;      //���������
        I2C_DR = (*time_pointer || (*(time_pointer+1) <<4)) || 0x80;
        time_pointer =&hours;
      }
    }
   if (data_type ==2)
    {
      I2C_CR2 &= ~I2C_CR2_ACK;       //NACK ��� ����������� ������
        I2C_CR2 |= I2C_CR2_STOP;      //���������
      I2C_DR = 0x11;            //���� ��������� ����� � �����
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
   i2c_flags.rw =1;    //��� ����������� ������
   i2c_start(read, time_address, time_address+2);

 }
void  i2c_write_time(void)
 {
  data_pointer =&fresh_sec;     ////////????????????????????????
  i2c_flags.rw =0;      //��� ����������� ������
  i2c_start(write, time_address, time_address+2);
 }

void i2c_exeption(void)
 {
   // TODO: ��������� ������
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
				
				