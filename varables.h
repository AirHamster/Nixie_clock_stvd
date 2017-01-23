#ifndef VARABLES
#define VARABLES

#define F_MASTER_MHZ 16
//��������� ���������� �������� � i2c
typedef enum {
    I2C_SUCCESS = 0,
    I2C_TIMEOUT,
    I2C_ERROR
} t_i2c_status;
 
//������� �������� ������� I2C
static unsigned long int i2c_timeout;
 
//������ ������� � �������������
#define set_tmo_us(time)\
  i2c_timeout = (unsigned long int)(F_MASTER_MHZ * time)
 
//������ ������� � �������������
#define set_tmo_ms(time)\
  i2c_timeout = (unsigned long int)(F_MASTER_MHZ * time * 1000)
 
#define tmo               i2c_timeout--
 
//�������� ����������� ������� event
//� ������� ������� timeout � ��
#define wait_event(event, timeout) set_tmo_ms(timeout);\
                                   while(event && i2c_timeout);\
                                   if(!i2c_timeout) return 0;
 
// TODO: �������� ��� ���������� ��������� �� ������� ���������
uint8_t lamp_number = 1;      //����� ����� 1-4

uint8_t lamp1_digit = 0x0;      //������� �� ������ �����
uint8_t lamp2_digit = 0x0;
uint8_t lamp3_digit = 0x0;
uint8_t lamp4_digit = 0x0;
uint8_t dots = 0x80;

uint8_t deshifr_code_out; //��, ��� ������ �� spi
uint8_t lamp_number_out;
uint16_t ds_tacts;

uint8_t fresh_hours_dec, fresh_hours, fresh_min_dec, fresh_min, fresh_sec_dec, fresh_sec, timeset;

uint8_t seconds;                //���� � ���
uint8_t seconds_decades;

uint8_t minutes;
uint8_t minutes_decades;

uint8_t hours;
uint8_t hours_decades;

uint8_t *time_pointer = &seconds;
uint8_t *data_pointer;
uint8_t *fresh_data_pointer;

uint8_t pins;
uint8_t spi_queue;        //������� ������ �� ��������
volatile uint8_t temp;
volatile uint8_t temp2;

uint8_t tunning_digits;
uint8_t two_keys;
uint8_t tunning;
uint8_t ds_address =0xD0;

//i2c peremennie
uint8_t i2c_start_adr;
uint8_t i2c_end_adr;
uint8_t i2c_current_adr;


uint8_t data_type;


#define time 1
#define pin_ctrl =2
#define ram =3

uint8_t cell_address;
#define time_address 0        //������ ����� � �������
#define pin_control_adress 7
#define ram_address 8


//uint8_t rw;
//uint8_t r_w;    //����������� ������ i2c
#define read 1
#define write 0
#define busy 1
#define free 0

struct byte_t
{
  unsigned shift: 1;
  unsigned time_upd: 1;
  unsigned time_ack: 1;
  unsigned time_refresh: 1;
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