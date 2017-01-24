
/*void uart_send (unsigned char message)
{
  UART1_DR=message;
} */
//TODO: ������, ����������
void time_recalculation(void)
{

  if ((minutes_decades != fresh_min & 0x70) && (((fresh_min & 0x70) >>4 == 3) || ((fresh_min & 0x70) >>4 == 0)))
   {
     flags.time_refresh =1;  //���� ������� �������.
   }


  seconds = fresh_sec & 0x0F;
  seconds_decades = fresh_sec & 0x70;

  minutes = fresh_min & 0x0F;
  minutes_decades = fresh_min & 0x70;

  hours = fresh_hours & 0x0F;
  hours_decades = fresh_hours & 0x10;

  if (hours_decades <=6)
   {
     flags.night = 1;
   }

}




void display(uint8_t lamp1, uint8_t lamp2, uint8_t lamp3, uint8_t lamp4 )
{
  if ((lamp3_digit !=lamp3) && (lamp3 == 0x02 || 0x00))
   {
     //flags.shift =1;
   }
  lamp1_digit =lamp1;
  lamp2_digit =lamp2;
  lamp3_digit =lamp3;
  lamp4_digit =lamp4;

}

void time_write(void)
{
	timers_int_off();
	
	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
	fresh_min = fresh_min + (fresh_min_dec<<4);
	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
	
	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
	timers_int_on();
}