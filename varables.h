#ifndef VARABLES
#define VARABLES
#define CLOCK_FREQ 16000000
#define F_MASTER_MHZ 16

//	i2c operation result
typedef enum {
    I2C_SUCCESS = 0,
    I2C_TIMEOUT,
    I2C_ERROR
} t_i2c_status;

// TODO: заменить все переменные состояний на битовые структуры
volatile uint8_t lamp_number = 0;      //	lamp number 1-4
volatile uint8_t dots = 0b00010000;	// dots mask

//	spi data:
volatile uint8_t k155_data; 
volatile uint8_t lamp_number_data;
volatile uint16_t dots_upd = 8000;
volatile dots_on = 1;
//	info from rtc
volatile uint8_t fresh_hours_dec, fresh_hours, fresh_min_dec, fresh_min, fresh_sec_dec, fresh_sec, timeset;

volatile uint8_t hours, minutes, seconds;
volatile uint8_t seconds_tens;
volatile uint8_t minutes_tens;
volatile uint8_t hours_tens;

uint8_t *time_pointer = &seconds;
uint8_t *data_pointer;
uint8_t *fresh_data_pointer;

volatile uint8_t pins;
volatile uint8_t temp;
volatile uint8_t temp2 = 0b00000000;
volatile uint8_t temp3 = 0b00110011;
volatile uint8_t schetchik = 0;
uint16_t i = 0;
volatile uint8_t schetchik2 = 0;
//i2c peremennie
uint8_t ds_cr = 0b10010000;

#define  ds_address 0xD0
#define TIM2_TOP 0x3E80 //0x6D60//0x3E80 --1kHz
#define time 1
#define pin_ctrl =2
#define ram =3

// ds memory cells addresses
#define time_address 0        
#define pin_control_adress 7
#define ram_address 8

struct byte_t
{
  unsigned shift: 1;
  unsigned time_upd: 1;
  unsigned time_ack: 1;
  unsigned time1_refresh: 1;
  unsigned night: 1;
  unsigned flag6: 1;
  unsigned flag7: 1;
  unsigned flag8: 1;
}flags;

struct i2cf
 {
   unsigned status: 1;
   unsigned rw:   1;
   unsigned error: 1;
   unsigned first_send: 1;
 }i2c_flags;
 
 
 #endif