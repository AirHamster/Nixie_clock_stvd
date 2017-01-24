/*	BASIC INTERRUPT VECTOR TABLE FOR STM8 devices
 *	Copyright (c) 2007 STMicroelectronics
 */
 #include "stm8s.h"
//#include <stdio.h>
//#include <stdlib.h>
 #include "iostm8s103.h"
// #include "varables.h"
extern void uart_setup(void);
extern void SPI_Transmitted(void);
extern void UART_Resieved(void);
extern void I2C_Event(void);
extern void Keys_switched(void);
extern void DS_clock_handler (void);
extern void Timer1_Compare_1(void);
extern void Timer2_Overflow (void);

//extern void SPI_Transmitted (void);
//extern void UART_Resieved (void);

typedef void @far (*interrupt_handler_t)(void);

struct interrupt_vector {
	unsigned char interrupt_instruction;
	interrupt_handler_t interrupt_handler;
};

@far @interrupt void NonHandledInterrupt (void)
{
	/* in order to detect unexpected events during development, 
	   it is recommended to set a breakpoint on the following instruction
	*/
	return;
}

@far @interrupt void Keys_switched_interrupt(void)
{
	Keys_switched();
//	EXTI_CR1_PCIS = ~PCIS; //Invert interrupt sensivity
	return;
}

//@far @interrupt void DS_clock_handler(void)
//{
	//DS_interrupt();
//	return;
//}

@far @interrupt void UART_Resieved_Handler (void)
{	
		//temp = UART1_DR;
		UART_Resieved();
	
	return;
}

@far @interrupt void SPI_Transmitted_Handler (void)
{	
	SPI_Transmitted();
	return;
}
@far @interrupt void I2C_Handler(void)
{
	//I2C_Event();
	return;
}

@far @interrupt void Timer1_overflow_handler(void)
{
	Timer1_Compare_1();
}


@far @interrupt void Timer2_overflow_handler(void)
{
	Timer2_Overflow();
}

extern void _stext();     /* startup routine */

struct interrupt_vector const _vectab[] = {
	{0x82, (interrupt_handler_t)_stext}, /* reset */
	{0x82, NonHandledInterrupt}, /* trap  */
	{0x82, NonHandledInterrupt}, /* irq0  */
	{0x82, NonHandledInterrupt}, /* irq1  */
	{0x82, NonHandledInterrupt}, /* irq2  */
	{0x82, NonHandledInterrupt}, /* irq3  */
	{0x82, NonHandledInterrupt}, /* irq4  */
	{0x82, Keys_switched_interrupt}, /* irq5  */
	{0x82, NonHandledInterrupt}, /* irq6  */
	{0x82, NonHandledInterrupt}, /* irq7  */
	{0x82, NonHandledInterrupt}, /* irq8  */
	{0x82, NonHandledInterrupt}, /* irq9  */
	{0x82, SPI_Transmitted_Handler}, /* irq10 */
	{0x82, Timer1_overflow_handler}, /* irq11 */
	{0x82, NonHandledInterrupt}, /* irq12 */
	{0x82, Timer2_overflow_handler}, /* irq13 */
	{0x82, NonHandledInterrupt}, /* irq14 */
	{0x82, NonHandledInterrupt}, /* irq15 */
	{0x82, NonHandledInterrupt}, /* irq16 */
	{0x82, NonHandledInterrupt}, /* irq17 */
	{0x82, UART_Resieved_Handler}, /* irq18 */
	{0x82, I2C_Handler}, /* irq19 */
	{0x82, NonHandledInterrupt}, /* irq20 */
	{0x82, NonHandledInterrupt}, /* irq21 */
	{0x82, NonHandledInterrupt}, /* irq22 */
	{0x82, NonHandledInterrupt}, /* irq23 */
	{0x82, NonHandledInterrupt}, /* irq24 */
	{0x82, NonHandledInterrupt}, /* irq25 */
	{0x82, NonHandledInterrupt}, /* irq26 */
	{0x82, NonHandledInterrupt}, /* irq27 */
	{0x82, NonHandledInterrupt}, /* irq28 */
	{0x82, NonHandledInterrupt}, /* irq29 */
};
