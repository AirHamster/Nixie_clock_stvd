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