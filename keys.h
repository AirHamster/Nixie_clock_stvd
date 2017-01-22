



void Menu_key_pressed(void)
{
	UART_Send('1');
  if (tunning_digits ==1)
   {
     tunning_digits =0;
   }
  else tunning_digits=1;
}
// увеличиваем циферки
void Inc_key_pressed(void)
{
	UART_Send('2');
  if (tunning_digits ==0)
   {
     hours++;
     if (hours == 0x0A)
      {
        hours_decades++;
        hours =0;
        if (hours_decades ==0x03)
         {
           hours_decades =0;
         }
      }
   }
  else if (tunning_digits ==1)
   {
     minutes++;
     if (minutes == 0x0A)
      {
        minutes_decades++;
        minutes =0;
        if (minutes_decades ==0x06)
         {
           minutes_decades =0;
         }
      }
   }
}

void Two_keys_pressed(void)
{

}
