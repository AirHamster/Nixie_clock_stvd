#ifndef i2c
#define i2c

void i2c_init(void);
void i2c_start(uint8_t, uint8_t, uint8_t);
void i2c_send_adress(void);
void i2c_send_data();
void i2c_read_data(uint8_t);
void i2c_write_data (uint8_t);
void I2C_ack_time(void);
void i2c_write_time(void);
void i2c_exeption(void);

#endif