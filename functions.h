//Writing new time in RTC
void time_write(void)
{
	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
	fresh_min = fresh_min + (fresh_min_dec<<4);
	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
	timers_int_off();
	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
	timers_int_on();
}
// PCD bugfix
uint8_t kostil_k155 (uint8_t byte)
{
	uint8_t tmp = (byte<<1) & 0b00001100;
	uint8_t tmp2 = (byte>>2) & 0b00000010;
	byte &= 1;
	byte |= tmp | tmp2;
	return byte;
}