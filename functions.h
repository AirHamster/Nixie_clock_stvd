
/*void uart_send (unsigned char message)
{
  UART1_DR=message;
} */
//TODO: хуерга, переделать
void time_recalculation(void)
{

  if ((minutes_decades != fresh_min & 0x70) && (((fresh_min & 0x70) >>4 == 3) || ((fresh_min & 0x70) >>4 == 0)))
   {
     flags.time_refresh =1;  //флаг прогона циферок.
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
