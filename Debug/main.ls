   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2184                     	bsct
2185  0000               _lamp_number:
2186  0000 01            	dc.b	1
2187  0001               _lamp1_digit:
2188  0001 00            	dc.b	0
2189  0002               _lamp2_digit:
2190  0002 00            	dc.b	0
2191  0003               _lamp3_digit:
2192  0003 00            	dc.b	0
2193  0004               _lamp4_digit:
2194  0004 00            	dc.b	0
2195  0005               _dots:
2196  0005 80            	dc.b	128
2197  0006               _time_pointer:
2198  0006 0017          	dc.w	_seconds
2199  0008               _ds_address:
2200  0008 d0            	dc.b	208
2751                     ; 2  void uart_setup(void)
2751                     ; 3  {
2753                     	switch	.text
2754  0000               _uart_setup:
2758                     ; 4    UART1_BRR1=0x68;     //9600 bod
2760  0000 35685232      	mov	_UART1_BRR1,#104
2761                     ; 5     UART1_BRR2=0x03;
2763  0004 35035233      	mov	_UART1_BRR2,#3
2764                     ; 6     UART1_CR2 |= UART1_CR2_REN; //прием
2766  0008 72145235      	bset	_UART1_CR2,#2
2767                     ; 7     UART1_CR2 |= UART1_CR2_TEN; //передача
2769  000c 72165235      	bset	_UART1_CR2,#3
2770                     ; 8     UART1_CR2 |= UART1_CR2_RIEN; //Прерывание по приему
2772  0010 721a5235      	bset	_UART1_CR2,#5
2773                     ; 9 		UART1_SR = 0;
2775  0014 725f5230      	clr	_UART1_SR
2776                     ; 10  }
2779  0018 81            	ret
2816                     ; 11 void UART_Send (uint8_t msg)
2816                     ; 12  {
2817                     	switch	.text
2818  0019               _UART_Send:
2820  0019 88            	push	a
2821       00000000      OFST:	set	0
2824                     ; 14 	 temp =msg;
2826  001a b70b          	ld	_temp,a
2828  001c               L1302:
2829                     ; 15 	 while((UART1_SR & 0x80) == 0x00);
2831  001c c65230        	ld	a,_UART1_SR
2832  001f a580          	bcp	a,#128
2833  0021 27f9          	jreq	L1302
2834                     ; 16 	 UART1_DR = msg;
2836  0023 7b01          	ld	a,(OFST+1,sp)
2837  0025 c75231        	ld	_UART1_DR,a
2838                     ; 17  }
2841  0028 84            	pop	a
2842  0029 81            	ret
2880                     ; 18  void uart_routine(uint8_t data)
2880                     ; 19  {
2881                     	switch	.text
2882  002a               _uart_routine:
2884  002a 88            	push	a
2885       00000000      OFST:	set	0
2888                     ; 21 	 if (timeset != 0 && timeset <= 5)
2890  002b 3d18          	tnz	_timeset
2891  002d 2719          	jreq	L3502
2893  002f b618          	ld	a,_timeset
2894  0031 a106          	cp	a,#6
2895  0033 2413          	jruge	L3502
2896                     ; 23 		* fresh_data_pointer-- = data-0x30;
2898  0035 7b01          	ld	a,(OFST+1,sp)
2899  0037 a030          	sub	a,#48
2900  0039 be0e          	ldw	x,_fresh_data_pointer
2901  003b 1d0001        	subw	x,#1
2902  003e bf0e          	ldw	_fresh_data_pointer,x
2903  0040 1c0001        	addw	x,#1
2904  0043 f7            	ld	(x),a
2905                     ; 24 		 timeset++;
2907  0044 3c18          	inc	_timeset
2908                     ; 25 		 return ;
2911  0046 84            	pop	a
2912  0047 81            	ret
2913  0048               L3502:
2914                     ; 27 	 if (timeset == 6)
2916  0048 b618          	ld	a,_timeset
2917  004a a106          	cp	a,#6
2918  004c 260c          	jrne	L5502
2919                     ; 29 		 *fresh_data_pointer = data-0x30;
2921  004e 7b01          	ld	a,(OFST+1,sp)
2922  0050 a030          	sub	a,#48
2923  0052 92c70e        	ld	[_fresh_data_pointer.w],a
2924                     ; 30 		 timeset = 0;
2926  0055 3f18          	clr	_timeset
2927                     ; 31 		 time_write();
2929  0057 cd04d8        	call	_time_write
2931  005a               L5502:
2932                     ; 34 	 if (data == 's')
2934  005a 7b01          	ld	a,(OFST+1,sp)
2935  005c a173          	cp	a,#115
2936  005e 2609          	jrne	L7502
2937                     ; 36 			timeset = 1;
2939  0060 35010018      	mov	_timeset,#1
2940                     ; 37 			fresh_data_pointer = &fresh_hours_dec;
2942  0064 ae001e        	ldw	x,#_fresh_hours_dec
2943  0067 bf0e          	ldw	_fresh_data_pointer,x
2944  0069               L7502:
2945                     ; 39 	}
2948  0069 84            	pop	a
2949  006a 81            	ret
2991                     ; 5 void Menu_key_pressed(void)
2991                     ; 6 {
2992                     	switch	.text
2993  006b               _Menu_key_pressed:
2997                     ; 7 	UART_Send('1');
2999  006b a631          	ld	a,#49
3000  006d adaa          	call	_UART_Send
3002                     ; 8   if (tunning_digits ==1)
3004  006f b609          	ld	a,_tunning_digits
3005  0071 a101          	cp	a,#1
3006  0073 2604          	jrne	L7702
3007                     ; 10      tunning_digits =0;
3009  0075 3f09          	clr	_tunning_digits
3011  0077 2004          	jra	L1012
3012  0079               L7702:
3013                     ; 12   else tunning_digits=1;
3015  0079 35010009      	mov	_tunning_digits,#1
3016  007d               L1012:
3017                     ; 13 }
3020  007d 81            	ret
3049                     ; 15 void Inc_key_pressed(void)
3049                     ; 16 {
3050                     	switch	.text
3051  007e               _Inc_key_pressed:
3055                     ; 17 	UART_Send('2');
3057  007e a632          	ld	a,#50
3058  0080 ad97          	call	_UART_Send
3060                     ; 18   if (tunning_digits ==0)
3062  0082 3d09          	tnz	_tunning_digits
3063  0084 2616          	jrne	L3112
3064                     ; 20      hours++;
3066  0086 3c13          	inc	_hours
3067                     ; 21      if (hours == 0x0A)
3069  0088 b613          	ld	a,_hours
3070  008a a10a          	cp	a,#10
3071  008c 2628          	jrne	L1212
3072                     ; 23         hours_decades++;
3074  008e 3c12          	inc	_hours_decades
3075                     ; 24         hours =0;
3077  0090 3f13          	clr	_hours
3078                     ; 25         if (hours_decades ==0x03)
3080  0092 b612          	ld	a,_hours_decades
3081  0094 a103          	cp	a,#3
3082  0096 261e          	jrne	L1212
3083                     ; 27            hours_decades =0;
3085  0098 3f12          	clr	_hours_decades
3086  009a 201a          	jra	L1212
3087  009c               L3112:
3088                     ; 31   else if (tunning_digits ==1)
3090  009c b609          	ld	a,_tunning_digits
3091  009e a101          	cp	a,#1
3092  00a0 2614          	jrne	L1212
3093                     ; 33      minutes++;
3095  00a2 3c15          	inc	_minutes
3096                     ; 34      if (minutes == 0x0A)
3098  00a4 b615          	ld	a,_minutes
3099  00a6 a10a          	cp	a,#10
3100  00a8 260c          	jrne	L1212
3101                     ; 36         minutes_decades++;
3103  00aa 3c14          	inc	_minutes_decades
3104                     ; 37         minutes =0;
3106  00ac 3f15          	clr	_minutes
3107                     ; 38         if (minutes_decades ==0x06)
3109  00ae b614          	ld	a,_minutes_decades
3110  00b0 a106          	cp	a,#6
3111  00b2 2602          	jrne	L1212
3112                     ; 40            minutes_decades =0;
3114  00b4 3f14          	clr	_minutes_decades
3115  00b6               L1212:
3116                     ; 44 }
3119  00b6 81            	ret
3142                     ; 46 void Two_keys_pressed(void)
3142                     ; 47 {
3143                     	switch	.text
3144  00b7               _Two_keys_pressed:
3148                     ; 49 }
3151  00b7 81            	ret
3205                     ; 4 void timer2_start(uint16_t top_val)
3205                     ; 5 {
3206                     	switch	.text
3207  00b8               _timer2_start:
3211                     ; 6   TIM2_ARRH =top_val >>8;
3213  00b8 9e            	ld	a,xh
3214  00b9 c7530f        	ld	_TIM2_ARRH,a
3215                     ; 7   TIM2_ARRL =top_val & 0xFF;
3217  00bc 9f            	ld	a,xl
3218  00bd a4ff          	and	a,#255
3219  00bf c75310        	ld	_TIM2_ARRL,a
3220                     ; 8   TIM2_CR1 |= TIM2_CR1_CEN;
3222  00c2 72105300      	bset	_TIM2_CR1,#0
3223                     ; 9 }
3226  00c6 81            	ret
3259                     ; 11 void Timer2_Overflow (void)
3259                     ; 12 {
3260                     	switch	.text
3261  00c7               _Timer2_Overflow:
3265                     ; 13 	TIM2_SR1 = 0;
3267  00c7 725f5304      	clr	_TIM2_SR1
3268                     ; 14 	UART_Send('k');
3270  00cb a66b          	ld	a,#107
3271  00cd cd0019        	call	_UART_Send
3273                     ; 16   if (pins==PC_IDR)
3275  00d0 b60d          	ld	a,_pins
3276  00d2 c1500b        	cp	a,_PC_IDR
3277  00d5 266a          	jrne	L5712
3278                     ; 18     if(PC_IDR == PC_IDR & (1<<3))
3280  00d7 c6500b        	ld	a,_PC_IDR
3281  00da c1500b        	cp	a,_PC_IDR
3282  00dd 2605          	jrne	L42
3283  00df ae0001        	ldw	x,#1
3284  00e2 2001          	jra	L62
3285  00e4               L42:
3286  00e4 5f            	clrw	x
3287  00e5               L62:
3288  00e5 01            	rrwa	x,a
3289  00e6 a508          	bcp	a,#8
3290  00e8 270a          	jreq	L7712
3291                     ; 20       Menu_key_pressed();
3293  00ea cd006b        	call	_Menu_key_pressed
3295                     ; 21       timer2_start(0xFFF0);     //ставим задержку перед сменой
3297  00ed aefff0        	ldw	x,#65520
3298  00f0 adc6          	call	_timer2_start
3301  00f2 204d          	jra	L5712
3302  00f4               L7712:
3303                     ; 23     else if (PC_IDR == PC_IDR & (1<<4))
3305  00f4 c6500b        	ld	a,_PC_IDR
3306  00f7 c1500b        	cp	a,_PC_IDR
3307  00fa 2605          	jrne	L03
3308  00fc ae0001        	ldw	x,#1
3309  00ff 2001          	jra	L23
3310  0101               L03:
3311  0101 5f            	clrw	x
3312  0102               L23:
3313  0102 01            	rrwa	x,a
3314  0103 a510          	bcp	a,#16
3315  0105 270a          	jreq	L3022
3316                     ; 25       Inc_key_pressed();
3318  0107 cd007e        	call	_Inc_key_pressed
3320                     ; 26       timer2_start(0xFFF0);
3322  010a aefff0        	ldw	x,#65520
3323  010d ada9          	call	_timer2_start
3326  010f 2030          	jra	L5712
3327  0111               L3022:
3328                     ; 28     else if ((PC_IDR== PC_IDR & (1<<3)) && (PC_IDR== PC_IDR & (1<<4)))
3330  0111 c6500b        	ld	a,_PC_IDR
3331  0114 c1500b        	cp	a,_PC_IDR
3332  0117 2605          	jrne	L43
3333  0119 ae0001        	ldw	x,#1
3334  011c 2001          	jra	L63
3335  011e               L43:
3336  011e 5f            	clrw	x
3337  011f               L63:
3338  011f 01            	rrwa	x,a
3339  0120 a508          	bcp	a,#8
3340  0122 271d          	jreq	L5712
3342  0124 c6500b        	ld	a,_PC_IDR
3343  0127 c1500b        	cp	a,_PC_IDR
3344  012a 2605          	jrne	L04
3345  012c ae0001        	ldw	x,#1
3346  012f 2001          	jra	L24
3347  0131               L04:
3348  0131 5f            	clrw	x
3349  0132               L24:
3350  0132 01            	rrwa	x,a
3351  0133 a510          	bcp	a,#16
3352  0135 270a          	jreq	L5712
3353                     ; 30        two_keys =1;
3355  0137 35010008      	mov	_two_keys,#1
3356                     ; 32       timer2_start(0xFFF0);
3358  013b aefff0        	ldw	x,#65520
3359  013e cd00b8        	call	_timer2_start
3361  0141               L5712:
3362                     ; 35   if (pins !=PC_IDR)
3364  0141 b60d          	ld	a,_pins
3365  0143 c1500b        	cp	a,_PC_IDR
3366  0146 270a          	jreq	L1122
3367                     ; 37      if (two_keys ==1)  //пины сменились и оба отжались
3369  0148 b608          	ld	a,_two_keys
3370  014a a101          	cp	a,#1
3371  014c 2604          	jrne	L1122
3372                     ; 39         two_keys =0;
3374  014e 3f08          	clr	_two_keys
3375                     ; 40         tunning=0;
3377  0150 3f07          	clr	_tunning
3378  0152               L1122:
3379                     ; 44 	 PC_CR2 |= (1<<4) | (1<<3);        //есть прерывания
3381  0152 c6500e        	ld	a,_PC_CR2
3382  0155 aa18          	or	a,#24
3383  0157 c7500e        	ld	_PC_CR2,a
3384                     ; 45 }
3387  015a 81            	ret
3418                     ; 47 void Timer1_Compare_1 (void)
3418                     ; 48 {
3419                     	switch	.text
3420  015b               _Timer1_Compare_1:
3424                     ; 49 	TIM1_SR1 = 0;
3426  015b 725f5255      	clr	_TIM1_SR1
3427                     ; 50   lamp_number_out = lamp_number;                //выводим в регистры значения без точек
3429  015f 450021        	mov	_lamp_number_out,_lamp_number
3430                     ; 51 	PD_ODR = ~PD_ODR & 1<<3;;
3432  0162 c6500f        	ld	a,_PD_ODR
3433  0165 43            	cpl	a
3434  0166 a408          	and	a,#8
3435  0168 c7500f        	ld	_PD_ODR,a
3436                     ; 52 	UART_Send('t');
3439  016b a674          	ld	a,#116
3440  016d cd0019        	call	_UART_Send
3442                     ; 54 	data_pointer = &seconds;
3444  0170 ae0017        	ldw	x,#_seconds
3445  0173 bf10          	ldw	_data_pointer,x
3446                     ; 55 	i2c_start(1, 0x00, 0x00);
3448  0175 4b00          	push	#0
3449  0177 ae0100        	ldw	x,#256
3450  017a cd0460        	call	_i2c_start
3452  017d 84            	pop	a
3453                     ; 56 }
3456  017e 81            	ret
3480                     ; 60 void timer1_start(void)
3480                     ; 61  {
3481                     	switch	.text
3482  017f               _timer1_start:
3486                     ; 62    TIM1_CR1 |= TIM1_CR1_CEN; //Запускаем таймер
3488  017f 72105250      	bset	_TIM1_CR1,#0
3489                     ; 63  }
3492  0183 81            	ret
3542                     ; 65 void timer1_setup(uint16_t tim_freq, uint16_t top)
3542                     ; 66  {
3543                     	switch	.text
3544  0184               _timer1_setup:
3546  0184 89            	pushw	x
3547  0185 5204          	subw	sp,#4
3548       00000004      OFST:	set	4
3551                     ; 68   TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
3553  0187 cd0000        	call	c_uitolx
3555  018a 96            	ldw	x,sp
3556  018b 1c0001        	addw	x,#OFST-3
3557  018e cd0000        	call	c_rtol
3559  0191 ae2400        	ldw	x,#9216
3560  0194 bf02          	ldw	c_lreg+2,x
3561  0196 ae00f4        	ldw	x,#244
3562  0199 bf00          	ldw	c_lreg,x
3563  019b 96            	ldw	x,sp
3564  019c 1c0001        	addw	x,#OFST-3
3565  019f cd0000        	call	c_ldiv
3567  01a2 a608          	ld	a,#8
3568  01a4 cd0000        	call	c_lrsh
3570  01a7 b603          	ld	a,c_lreg+3
3571  01a9 c75260        	ld	_TIM1_PSCRH,a
3572                     ; 69   TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; //Делитель на 16
3574  01ac 1e05          	ldw	x,(OFST+1,sp)
3575  01ae cd0000        	call	c_uitolx
3577  01b1 96            	ldw	x,sp
3578  01b2 1c0001        	addw	x,#OFST-3
3579  01b5 cd0000        	call	c_rtol
3581  01b8 ae2400        	ldw	x,#9216
3582  01bb bf02          	ldw	c_lreg+2,x
3583  01bd ae00f4        	ldw	x,#244
3584  01c0 bf00          	ldw	c_lreg,x
3585  01c2 96            	ldw	x,sp
3586  01c3 1c0001        	addw	x,#OFST-3
3587  01c6 cd0000        	call	c_ldiv
3589  01c9 3f02          	clr	c_lreg+2
3590  01cb 3f01          	clr	c_lreg+1
3591  01cd 3f00          	clr	c_lreg
3592  01cf b603          	ld	a,c_lreg+3
3593  01d1 c75261        	ld	_TIM1_PSCRL,a
3594                     ; 70   TIM1_ARRH = (top) >> 8; //Частота переполнений = 16М / 8 / 1000 = 2000 Гц
3596  01d4 7b09          	ld	a,(OFST+5,sp)
3597  01d6 c75262        	ld	_TIM1_ARRH,a
3598                     ; 71   TIM1_ARRL = (top)& 0xFF;
3600  01d9 7b0a          	ld	a,(OFST+6,sp)
3601  01db a4ff          	and	a,#255
3602  01dd c75263        	ld	_TIM1_ARRL,a
3603                     ; 73   TIM1_CR1 |= TIM1_CR1_URS; //Прерывание только по переполнению счетчика
3605  01e0 72145250      	bset	_TIM1_CR1,#2
3606                     ; 74   TIM1_EGR |= TIM1_EGR_UG;  //Вызываем Update Event
3608  01e4 72105257      	bset	_TIM1_EGR,#0
3609                     ; 76   TIM1_IER |= TIM1_IER_UIE; //Разрешаем прерывание
3611  01e8 72105254      	bset	_TIM1_IER,#0
3612                     ; 78  }
3615  01ec 5b06          	addw	sp,#6
3616  01ee 81            	ret
3644                     ; 79 void timer2_setup(void)
3644                     ; 80  {
3645                     	switch	.text
3646  01ef               _timer2_setup:
3650                     ; 82     TIM2_CR1 = TIM2_CR1_URS | TIM2_CR1_OPM;      //в режиме одного импульса
3652  01ef 350c5300      	mov	_TIM2_CR1,#12
3653                     ; 83     TIM2_IER = TIM2_IER_UIE;         //прерывание по переполнению
3655  01f3 35015303      	mov	_TIM2_IER,#1
3656                     ; 84     TIM2_PSCR = 0;
3658  01f7 725f530e      	clr	_TIM2_PSCR
3659                     ; 85     TIM2_ARRH = 0;
3661  01fb 725f530f      	clr	_TIM2_ARRH
3662                     ; 86     TIM2_ARRL = 0x64;
3664  01ff 35645310      	mov	_TIM2_ARRL,#100
3665                     ; 87  }
3668  0203 81            	ret
3694                     ; 89  void Key_interrupt (void)
3694                     ; 90 {
3695                     	switch	.text
3696  0204               _Key_interrupt:
3700                     ; 91   pins = PC_IDR;           //сохранили состояние порта
3702  0204 55500b000d    	mov	_pins,_PC_IDR
3703                     ; 92   timer2_start(0x0064);       //запустили таймер для отфильтровки
3705  0209 ae0064        	ldw	x,#100
3706  020c cd00b8        	call	_timer2_start
3708                     ; 93 }
3711  020f 81            	ret
3790                     ; 7 void i2c_master_init(unsigned long f_master_hz, unsigned long f_i2c_hz){
3791                     	switch	.text
3792  0210               _i2c_master_init:
3794  0210 5208          	subw	sp,#8
3795       00000008      OFST:	set	8
3798                     ; 10   PB_DDR = (0<<4);//PB_DDR_DDR4);
3800  0212 725f5007      	clr	_PB_DDR
3801                     ; 11 	PB_DDR = (0<<5);//PB_DDR_DDR5);
3803  0216 725f5007      	clr	_PB_DDR
3804                     ; 12 	PB_ODR = (1<<5);//PB_ODR_ODR5);  //SDA
3806  021a 35205005      	mov	_PB_ODR,#32
3807                     ; 13   PB_ODR = (1<<4);//PB_ODR_ODR4);  //SCL
3809  021e 35105005      	mov	_PB_ODR,#16
3810                     ; 15   PB_CR1 = (0<<4);//PB_CR1_C14);
3812  0222 725f5008      	clr	_PB_CR1
3813                     ; 16   PB_CR1 = (0<<5);//PB_CR1_C15);
3815  0226 725f5008      	clr	_PB_CR1
3816                     ; 18   PB_CR2 = (0<<4);//PB_CR1_C24);
3818  022a 725f5009      	clr	_PB_CR2
3819                     ; 19   PB_CR2 = (0<<5);//PB_CR1_C25);
3821  022e 725f5009      	clr	_PB_CR2
3822                     ; 22   I2C_FREQR = 16;
3824  0232 35105212      	mov	_I2C_FREQR,#16
3825                     ; 24   I2C_CR1 |=~I2C_CR1_PE;
3827  0236 c65210        	ld	a,_I2C_CR1
3828  0239 aafe          	or	a,#254
3829  023b c75210        	ld	_I2C_CR1,a
3830                     ; 27   I2C_CCRH |=~I2C_CCRH_FS;
3832  023e c6521c        	ld	a,_I2C_CCRH
3833  0241 aa7f          	or	a,#127
3834  0243 c7521c        	ld	_I2C_CCRH,a
3835                     ; 29   ccr = f_master_hz/(2*f_i2c_hz);
3837  0246 96            	ldw	x,sp
3838  0247 1c000f        	addw	x,#OFST+7
3839  024a cd0000        	call	c_ltor
3841  024d 3803          	sll	c_lreg+3
3842  024f 3902          	rlc	c_lreg+2
3843  0251 3901          	rlc	c_lreg+1
3844  0253 3900          	rlc	c_lreg
3845  0255 96            	ldw	x,sp
3846  0256 1c0001        	addw	x,#OFST-7
3847  0259 cd0000        	call	c_rtol
3849  025c 96            	ldw	x,sp
3850  025d 1c000b        	addw	x,#OFST+3
3851  0260 cd0000        	call	c_ltor
3853  0263 96            	ldw	x,sp
3854  0264 1c0001        	addw	x,#OFST-7
3855  0267 cd0000        	call	c_ludv
3857  026a 96            	ldw	x,sp
3858  026b 1c0005        	addw	x,#OFST-3
3859  026e cd0000        	call	c_rtol
3861                     ; 33   I2C_TRISER = 12+1;
3863  0271 350d521d      	mov	_I2C_TRISER,#13
3864                     ; 34   I2C_CCRL = ccr & 0xFF;
3866  0275 7b08          	ld	a,(OFST+0,sp)
3867  0277 a4ff          	and	a,#255
3868  0279 c7521b        	ld	_I2C_CCRL,a
3869                     ; 35   I2C_CCRH = ((ccr >> 8) & 0x0F);
3871  027c 7b07          	ld	a,(OFST-1,sp)
3872  027e a40f          	and	a,#15
3873  0280 c7521c        	ld	_I2C_CCRH,a
3874                     ; 37   I2C_CR1 |=I2C_CR1_PE;
3876  0283 72105210      	bset	_I2C_CR1,#0
3877                     ; 39   I2C_CR2 |=I2C_CR2_ACK;
3879  0287 72145211      	bset	_I2C_CR2,#2
3880                     ; 40 }
3883  028b 5b08          	addw	sp,#8
3884  028d 81            	ret
3978                     ; 46 t_i2c_status i2c_wr_reg(unsigned char address, unsigned char reg_addr,
3978                     ; 47                               char * data, unsigned char length)
3978                     ; 48 {                                  
3979                     	switch	.text
3980  028e               _i2c_wr_reg:
3982  028e 89            	pushw	x
3983       00000000      OFST:	set	0
3986  028f               L1042:
3987                     ; 52   while((I2C_SR3 & I2C_SR3_BUSY) !=0);   
3989  028f c65219        	ld	a,_I2C_SR3
3990  0292 a502          	bcp	a,#2
3991  0294 26f9          	jrne	L1042
3992                     ; 54   I2C_CR2 |= I2C_CR2_START;
3994  0296 72105211      	bset	_I2C_CR2,#0
3996  029a               L7042:
3997                     ; 57   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3999  029a c65217        	ld	a,_I2C_SR1
4000  029d a501          	bcp	a,#1
4001  029f 27f9          	jreq	L7042
4002                     ; 60   I2C_DR = address & 0xFE;
4004  02a1 7b01          	ld	a,(OFST+1,sp)
4005  02a3 a4fe          	and	a,#254
4006  02a5 c75216        	ld	_I2C_DR,a
4008  02a8               L7142:
4009                     ; 63 	while((I2C_SR1 & I2C_SR1_ADDR) == 0);
4011  02a8 c65217        	ld	a,_I2C_SR1
4012  02ab a502          	bcp	a,#2
4013  02ad 27f9          	jreq	L7142
4014                     ; 65   I2C_SR3;
4016  02af c65219        	ld	a,_I2C_SR3
4018  02b2               L5242:
4019                     ; 70   while((I2C_SR1 & I2C_SR1_TXE) ==0);
4021  02b2 c65217        	ld	a,_I2C_SR1
4022  02b5 a580          	bcp	a,#128
4023  02b7 27f9          	jreq	L5242
4024                     ; 72   I2C_DR = reg_addr;
4026  02b9 7b02          	ld	a,(OFST+2,sp)
4027  02bb c75216        	ld	_I2C_DR,a
4029  02be 2015          	jra	L5342
4030  02c0               L3442:
4031                     ; 78     while((I2C_SR1 & I2C_SR1_TXE) == 0);
4033  02c0 c65217        	ld	a,_I2C_SR1
4034  02c3 a580          	bcp	a,#128
4035  02c5 27f9          	jreq	L3442
4036                     ; 80     I2C_DR = *data++;
4038  02c7 1e05          	ldw	x,(OFST+5,sp)
4039  02c9 1c0001        	addw	x,#1
4040  02cc 1f05          	ldw	(OFST+5,sp),x
4041  02ce 1d0001        	subw	x,#1
4042  02d1 f6            	ld	a,(x)
4043  02d2 c75216        	ld	_I2C_DR,a
4044  02d5               L5342:
4045                     ; 75   while(length--){
4047  02d5 7b07          	ld	a,(OFST+7,sp)
4048  02d7 0a07          	dec	(OFST+7,sp)
4049  02d9 4d            	tnz	a
4050  02da 26e4          	jrne	L3442
4052  02dc               L1542:
4053                     ; 85   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
4055  02dc c65217        	ld	a,_I2C_SR1
4056  02df a584          	bcp	a,#132
4057  02e1 27f9          	jreq	L1542
4058                     ; 87   I2C_CR2 |= I2C_CR2_STOP;
4060  02e3 72125211      	bset	_I2C_CR2,#1
4062  02e7               L7542:
4063                     ; 90   while((I2C_CR2 & I2C_CR2_STOP) == 0); 
4065  02e7 c65211        	ld	a,_I2C_CR2
4066  02ea a502          	bcp	a,#2
4067  02ec 27f9          	jreq	L7542
4068                     ; 91   return I2C_SUCCESS;
4070  02ee 4f            	clr	a
4073  02ef 85            	popw	x
4074  02f0 81            	ret
4145                     ; 98 t_i2c_status i2c_rd_reg(unsigned char address, unsigned char reg_addr,
4145                     ; 99                               char * data, unsigned char length)
4145                     ; 100 {
4146                     	switch	.text
4147  02f1               _i2c_rd_reg:
4149  02f1 89            	pushw	x
4150       00000000      OFST:	set	0
4153  02f2               L7152:
4154                     ; 106   while((I2C_SR3 & I2C_SR3_BUSY) != 0);   
4156  02f2 c65219        	ld	a,_I2C_SR3
4157  02f5 a502          	bcp	a,#2
4158  02f7 26f9          	jrne	L7152
4159                     ; 108   I2C_CR2 |= I2C_CR2_ACK;
4161  02f9 72145211      	bset	_I2C_CR2,#2
4162                     ; 111   I2C_CR2 |= I2C_CR2_START;
4164  02fd 72105211      	bset	_I2C_CR2,#0
4166  0301               L5252:
4167                     ; 114   while((I2C_SR1 & I2C_SR1_SB) == 0);  
4169  0301 c65217        	ld	a,_I2C_SR1
4170  0304 a501          	bcp	a,#1
4171  0306 27f9          	jreq	L5252
4172                     ; 116   I2C_DR = address & 0xFE;
4174  0308 7b01          	ld	a,(OFST+1,sp)
4175  030a a4fe          	and	a,#254
4176  030c c75216        	ld	_I2C_DR,a
4178  030f               L5352:
4179                     ; 119   while((I2C_SR1 & I2C_SR1_ADDR) == 0);
4181  030f c65217        	ld	a,_I2C_SR1
4182  0312 a502          	bcp	a,#2
4183  0314 27f9          	jreq	L5352
4184                     ; 121   temp = I2C_SR3;
4186  0316 555219000b    	mov	_temp,_I2C_SR3
4188  031b               L5452:
4189                     ; 125   while((I2C_SR1 & I2C_SR1) == 0); 
4191  031b c65217        	ld	a,_I2C_SR1
4192  031e 5f            	clrw	x
4193  031f 97            	ld	xl,a
4194  0320 a30000        	cpw	x,#0
4195  0323 27f6          	jreq	L5452
4196                     ; 127   I2C_DR = reg_addr;
4198  0325 7b02          	ld	a,(OFST+2,sp)
4199  0327 c75216        	ld	_I2C_DR,a
4201  032a               L5552:
4202                     ; 130   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
4204  032a c65217        	ld	a,_I2C_SR1
4205  032d a584          	bcp	a,#132
4206  032f 27f9          	jreq	L5552
4207                     ; 132   I2C_CR2 |= I2C_CR2_START;
4209  0331 72105211      	bset	_I2C_CR2,#0
4211  0335               L3652:
4212                     ; 135   while((I2C_SR1 & I2C_SR1_SB) == 0); 
4214  0335 c65217        	ld	a,_I2C_SR1
4215  0338 a501          	bcp	a,#1
4216  033a 27f9          	jreq	L3652
4217                     ; 138   I2C_DR = address | 0x01;
4219  033c 7b01          	ld	a,(OFST+1,sp)
4220  033e aa01          	or	a,#1
4221  0340 c75216        	ld	_I2C_DR,a
4222                     ; 142   if(length == 1){
4224  0343 7b07          	ld	a,(OFST+7,sp)
4225  0345 a101          	cp	a,#1
4226  0347 2627          	jrne	L7652
4227                     ; 144     I2C_CR2 &= ~I2C_CR2_ACK;
4229  0349 72155211      	bres	_I2C_CR2,#2
4231  034d               L3752:
4232                     ; 147     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
4234  034d c65217        	ld	a,_I2C_SR1
4235  0350 a502          	bcp	a,#2
4236  0352 27f9          	jreq	L3752
4237                     ; 149     _asm ("SIM");  //on interupts
4240  0354 9b            SIM
4242                     ; 151     temp = I2C_SR3;
4244  0355 555219000b    	mov	_temp,_I2C_SR3
4245                     ; 154     I2C_CR2 |= I2C_CR2_STOP;
4247  035a 72125211      	bset	_I2C_CR2,#1
4248                     ; 156     _asm ("RIM");  //on interupts;
4251  035e 9a            RIM
4254  035f               L1062:
4255                     ; 160     while((I2C_SR1 & I2C_SR1_RXNE) == 0); 
4257  035f c65217        	ld	a,_I2C_SR1
4258  0362 a540          	bcp	a,#64
4259  0364 27f9          	jreq	L1062
4260                     ; 162     *data = I2C_DR;
4262  0366 1e05          	ldw	x,(OFST+5,sp)
4263  0368 c65216        	ld	a,_I2C_DR
4264  036b f7            	ld	(x),a
4266  036c ac510451      	jpf	L5762
4267  0370               L7652:
4268                     ; 165   else if(length == 2){
4270  0370 7b07          	ld	a,(OFST+7,sp)
4271  0372 a102          	cp	a,#2
4272  0374 263b          	jrne	L7062
4273                     ; 167     I2C_CR2 |= I2C_CR2_POS;
4275  0376 72165211      	bset	_I2C_CR2,#3
4277  037a               L3162:
4278                     ; 170     while((I2C_SR1 & I2C_SR1_ADDR) == 0);
4280  037a c65217        	ld	a,_I2C_SR1
4281  037d a502          	bcp	a,#2
4282  037f 27f9          	jreq	L3162
4283                     ; 172     _asm ("SIM");  //on interupts;
4286  0381 9b            SIM
4288                     ; 174     temp = I2C_SR3;
4290  0382 555219000b    	mov	_temp,_I2C_SR3
4291                     ; 176     I2C_CR2 &= ~I2C_CR2_ACK;
4293  0387 72155211      	bres	_I2C_CR2,#2
4294                     ; 178     _asm ("RIM");  //on interupts;
4297  038b 9a            RIM
4300  038c               L1262:
4301                     ; 182     while((I2C_SR1 & I2C_SR1_BTF) == 0); 
4303  038c c65217        	ld	a,_I2C_SR1
4304  038f a504          	bcp	a,#4
4305  0391 27f9          	jreq	L1262
4306                     ; 184     _asm ("SIM");  //on interupts;
4309  0393 9b            SIM
4311                     ; 186     I2C_CR2 |= I2C_CR2_STOP;
4313  0394 72125211      	bset	_I2C_CR2,#1
4314                     ; 188     *data++ = I2C_DR;
4316  0398 1e05          	ldw	x,(OFST+5,sp)
4317  039a 1c0001        	addw	x,#1
4318  039d 1f05          	ldw	(OFST+5,sp),x
4319  039f 1d0001        	subw	x,#1
4320  03a2 c65216        	ld	a,_I2C_DR
4321  03a5 f7            	ld	(x),a
4322                     ; 190     _asm ("RIM");  //on interupts;
4325  03a6 9a            RIM
4327                     ; 191     *data = I2C_DR;
4329  03a7 1e05          	ldw	x,(OFST+5,sp)
4330  03a9 c65216        	ld	a,_I2C_DR
4331  03ac f7            	ld	(x),a
4333  03ad ac510451      	jpf	L5762
4334  03b1               L7062:
4335                     ; 194   else if(length > 2){
4337  03b1 7b07          	ld	a,(OFST+7,sp)
4338  03b3 a103          	cp	a,#3
4339  03b5 2403          	jruge	L66
4340  03b7 cc0451        	jp	L5762
4341  03ba               L66:
4343  03ba               L3362:
4344                     ; 197     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
4346  03ba c65217        	ld	a,_I2C_SR1
4347  03bd a502          	bcp	a,#2
4348  03bf 27f9          	jreq	L3362
4349                     ; 199     _asm ("SIM");  //on interupts;
4352  03c1 9b            SIM
4354                     ; 202     I2C_SR3;
4356  03c2 c65219        	ld	a,_I2C_SR3
4357                     ; 205     _asm ("RIM");  //on interupts;
4360  03c5 9a            RIM
4363  03c6 2015          	jra	L1462
4364  03c8               L7462:
4365                     ; 210       while((I2C_SR1 & I2C_SR1_BTF) == 0);
4367  03c8 c65217        	ld	a,_I2C_SR1
4368  03cb a504          	bcp	a,#4
4369  03cd 27f9          	jreq	L7462
4370                     ; 212       *data++ = I2C_DR;
4372  03cf 1e05          	ldw	x,(OFST+5,sp)
4373  03d1 1c0001        	addw	x,#1
4374  03d4 1f05          	ldw	(OFST+5,sp),x
4375  03d6 1d0001        	subw	x,#1
4376  03d9 c65216        	ld	a,_I2C_DR
4377  03dc f7            	ld	(x),a
4378  03dd               L1462:
4379                     ; 207     while(length-- > 3 && tmo){
4381  03dd 7b07          	ld	a,(OFST+7,sp)
4382  03df 0a07          	dec	(OFST+7,sp)
4383  03e1 a104          	cp	a,#4
4384  03e3 2513          	jrult	L3562
4386  03e5 ae0023        	ldw	x,#L7241_i2c_timeout
4387  03e8 cd0000        	call	c_ltor
4389  03eb ae0023        	ldw	x,#L7241_i2c_timeout
4390  03ee a601          	ld	a,#1
4391  03f0 cd0000        	call	c_lgsbc
4393  03f3 cd0000        	call	c_lrzmp
4395  03f6 26d0          	jrne	L7462
4396  03f8               L3562:
4397                     ; 215     if(!tmo) return I2C_TIMEOUT;
4399  03f8 ae0023        	ldw	x,#L7241_i2c_timeout
4400  03fb cd0000        	call	c_ltor
4402  03fe ae0023        	ldw	x,#L7241_i2c_timeout
4403  0401 a601          	ld	a,#1
4404  0403 cd0000        	call	c_lgsbc
4406  0406 cd0000        	call	c_lrzmp
4408  0409 2604          	jrne	L1662
4411  040b a601          	ld	a,#1
4413  040d 204e          	jra	L46
4414  040f               L1662:
4415                     ; 221     while((I2C_SR1 & I2C_SR1_BTF) == 0);
4417  040f c65217        	ld	a,_I2C_SR1
4418  0412 a504          	bcp	a,#4
4419  0414 27f9          	jreq	L1662
4420                     ; 223     I2C_CR2 &= ~I2C_CR2_ACK;
4422  0416 72155211      	bres	_I2C_CR2,#2
4423                     ; 225     _asm ("SIM");  //on interupts;
4426  041a 9b            SIM
4428                     ; 228     *data++ = I2C_DR;
4430  041b 1e05          	ldw	x,(OFST+5,sp)
4431  041d 1c0001        	addw	x,#1
4432  0420 1f05          	ldw	(OFST+5,sp),x
4433  0422 1d0001        	subw	x,#1
4434  0425 c65216        	ld	a,_I2C_DR
4435  0428 f7            	ld	(x),a
4436                     ; 230     I2C_CR2 |= I2C_CR2_STOP;
4438  0429 72125211      	bset	_I2C_CR2,#1
4439                     ; 232     *data++ = I2C_DR;
4441  042d 1e05          	ldw	x,(OFST+5,sp)
4442  042f 1c0001        	addw	x,#1
4443  0432 1f05          	ldw	(OFST+5,sp),x
4444  0434 1d0001        	subw	x,#1
4445  0437 c65216        	ld	a,_I2C_DR
4446  043a f7            	ld	(x),a
4447                     ; 234     _asm ("RIM");  //on interupts;
4450  043b 9a            RIM
4453  043c               L7662:
4454                     ; 237     while((I2C_SR1 & I2C_SR1_RXNE) == 0);
4456  043c c65217        	ld	a,_I2C_SR1
4457  043f a540          	bcp	a,#64
4458  0441 27f9          	jreq	L7662
4459                     ; 239     *data++ = I2C_DR;
4461  0443 1e05          	ldw	x,(OFST+5,sp)
4462  0445 1c0001        	addw	x,#1
4463  0448 1f05          	ldw	(OFST+5,sp),x
4464  044a 1d0001        	subw	x,#1
4465  044d c65216        	ld	a,_I2C_DR
4466  0450 f7            	ld	(x),a
4467  0451               L5762:
4468                     ; 244   while((I2C_CR2 & I2C_CR2_STOP) == 0);
4470  0451 c65211        	ld	a,_I2C_CR2
4471  0454 a502          	bcp	a,#2
4472  0456 27f9          	jreq	L5762
4473                     ; 246   I2C_CR2 &= ~I2C_CR2_POS;
4475  0458 72175211      	bres	_I2C_CR2,#3
4476                     ; 248   return I2C_SUCCESS;
4478  045c 4f            	clr	a
4480  045d               L46:
4482  045d 85            	popw	x
4483  045e 81            	ret
4506                     ; 254 void i2c_init(void)
4506                     ; 255  {
4507                     	switch	.text
4508  045f               _i2c_init:
4512                     ; 256  }
4515  045f 81            	ret
4549                     ; 257 void i2c_start(uint8_t rorw, uint8_t start_adr, uint8_t end_adr)        // OK
4549                     ; 258  {
4550                     	switch	.text
4551  0460               _i2c_start:
4555                     ; 259  }      //вроде норм
4558  0460 81            	ret
4581                     ; 260 void i2c_send_adress(void)      //   OK
4581                     ; 261  {
4582                     	switch	.text
4583  0461               _i2c_send_adress:
4587                     ; 262  }      //OK
4590  0461 81            	ret
4613                     ; 263 void i2c_send_data()
4613                     ; 264  {
4614                     	switch	.text
4615  0462               _i2c_send_data:
4619                     ; 265  }
4622  0462 81            	ret
4672                     ; 7 void time_recalculation(void)
4672                     ; 8 {
4673                     	switch	.text
4674  0463               _time_recalculation:
4678                     ; 10   if ((minutes_decades != fresh_min & 0x70) && (((fresh_min & 0x70) >>4 == 3) || ((fresh_min & 0x70) >>4 == 0)))
4680  0463 b614          	ld	a,_minutes_decades
4681  0465 b11b          	cp	a,_fresh_min
4682  0467 2705          	jreq	L201
4683  0469 ae0001        	ldw	x,#1
4684  046c 2001          	jra	L401
4685  046e               L201:
4686  046e 5f            	clrw	x
4687  046f               L401:
4688  046f 01            	rrwa	x,a
4689  0470 a570          	bcp	a,#112
4690  0472 2718          	jreq	L5672
4692  0474 b61b          	ld	a,_fresh_min
4693  0476 a470          	and	a,#112
4694  0478 4e            	swap	a
4695  0479 a40f          	and	a,#15
4696  047b 5f            	clrw	x
4697  047c 97            	ld	xl,a
4698  047d a30003        	cpw	x,#3
4699  0480 2706          	jreq	L7672
4701  0482 b61b          	ld	a,_fresh_min
4702  0484 a570          	bcp	a,#112
4703  0486 2604          	jrne	L5672
4704  0488               L7672:
4705                     ; 12      flags.time_refresh =1;  //флаг прогона циферок.
4707  0488 72160001      	bset	_flags,#3
4708  048c               L5672:
4709                     ; 16   seconds = fresh_sec & 0x0F;
4711  048c b619          	ld	a,_fresh_sec
4712  048e a40f          	and	a,#15
4713  0490 b717          	ld	_seconds,a
4714                     ; 17   seconds_decades = fresh_sec & 0x70;
4716  0492 b619          	ld	a,_fresh_sec
4717  0494 a470          	and	a,#112
4718  0496 b716          	ld	_seconds_decades,a
4719                     ; 19   minutes = fresh_min & 0x0F;
4721  0498 b61b          	ld	a,_fresh_min
4722  049a a40f          	and	a,#15
4723  049c b715          	ld	_minutes,a
4724                     ; 20   minutes_decades = fresh_min & 0x70;
4726  049e b61b          	ld	a,_fresh_min
4727  04a0 a470          	and	a,#112
4728  04a2 b714          	ld	_minutes_decades,a
4729                     ; 22   hours = fresh_hours & 0x0F;
4731  04a4 b61d          	ld	a,_fresh_hours
4732  04a6 a40f          	and	a,#15
4733  04a8 b713          	ld	_hours,a
4734                     ; 23   hours_decades = fresh_hours & 0x10;
4736  04aa b61d          	ld	a,_fresh_hours
4737  04ac a410          	and	a,#16
4738  04ae b712          	ld	_hours_decades,a
4739                     ; 25   if (hours_decades <=6)
4741  04b0 b612          	ld	a,_hours_decades
4742  04b2 a107          	cp	a,#7
4743  04b4 2404          	jruge	L1772
4744                     ; 27      flags.night = 1;
4746  04b6 72180001      	bset	_flags,#4
4747  04ba               L1772:
4748                     ; 30 }
4751  04ba 81            	ret
4816                     ; 35 void display(uint8_t lamp1, uint8_t lamp2, uint8_t lamp3, uint8_t lamp4 )
4816                     ; 36 {
4817                     	switch	.text
4818  04bb               _display:
4820  04bb 89            	pushw	x
4821       00000000      OFST:	set	0
4824                     ; 37   if ((lamp3_digit !=lamp3) && (lamp3 == 0x02 || 0x00))
4826  04bc b603          	ld	a,_lamp3_digit
4827  04be 1105          	cp	a,(OFST+5,sp)
4828  04c0 2704          	jreq	L5203
4830  04c2 7b05          	ld	a,(OFST+5,sp)
4831  04c4 a102          	cp	a,#2
4832  04c6               L5203:
4833                     ; 41   lamp1_digit =lamp1;
4835  04c6 7b01          	ld	a,(OFST+1,sp)
4836  04c8 b701          	ld	_lamp1_digit,a
4837                     ; 42   lamp2_digit =lamp2;
4839  04ca 7b02          	ld	a,(OFST+2,sp)
4840  04cc b702          	ld	_lamp2_digit,a
4841                     ; 43   lamp3_digit =lamp3;
4843  04ce 7b05          	ld	a,(OFST+5,sp)
4844  04d0 b703          	ld	_lamp3_digit,a
4845                     ; 44   lamp4_digit =lamp4;
4847  04d2 7b06          	ld	a,(OFST+6,sp)
4848  04d4 b704          	ld	_lamp4_digit,a
4849                     ; 46 }
4852  04d6 85            	popw	x
4853  04d7 81            	ret
4884                     ; 48 void time_write(void)
4884                     ; 49 {
4885                     	switch	.text
4886  04d8               _time_write:
4890                     ; 50 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
4892  04d8 b61e          	ld	a,_fresh_hours_dec
4893  04da 97            	ld	xl,a
4894  04db a610          	ld	a,#16
4895  04dd 42            	mul	x,a
4896  04de 9f            	ld	a,xl
4897  04df bb1d          	add	a,_fresh_hours
4898  04e1 b71d          	ld	_fresh_hours,a
4899                     ; 51 	fresh_min = fresh_min + (fresh_min_dec<<4);
4901  04e3 b61c          	ld	a,_fresh_min_dec
4902  04e5 97            	ld	xl,a
4903  04e6 a610          	ld	a,#16
4904  04e8 42            	mul	x,a
4905  04e9 9f            	ld	a,xl
4906  04ea bb1b          	add	a,_fresh_min
4907  04ec b71b          	ld	_fresh_min,a
4908                     ; 52 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
4910  04ee b61a          	ld	a,_fresh_sec_dec
4911  04f0 97            	ld	xl,a
4912  04f1 a610          	ld	a,#16
4913  04f3 42            	mul	x,a
4914  04f4 9f            	ld	a,xl
4915  04f5 bb19          	add	a,_fresh_sec
4916  04f7 b719          	ld	_fresh_sec,a
4917                     ; 54 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
4919  04f9 4b01          	push	#1
4920  04fb ae001d        	ldw	x,#_fresh_hours
4921  04fe 89            	pushw	x
4922  04ff ae0002        	ldw	x,#2
4923  0502 b608          	ld	a,_ds_address
4924  0504 95            	ld	xh,a
4925  0505 cd028e        	call	_i2c_wr_reg
4927  0508 5b03          	addw	sp,#3
4928                     ; 55 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
4930  050a 4b01          	push	#1
4931  050c ae001b        	ldw	x,#_fresh_min
4932  050f 89            	pushw	x
4933  0510 ae0001        	ldw	x,#1
4934  0513 b608          	ld	a,_ds_address
4935  0515 95            	ld	xh,a
4936  0516 cd028e        	call	_i2c_wr_reg
4938  0519 5b03          	addw	sp,#3
4939                     ; 56 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
4941  051b 4b01          	push	#1
4942  051d ae0019        	ldw	x,#_fresh_sec
4943  0520 89            	pushw	x
4944  0521 5f            	clrw	x
4945  0522 b608          	ld	a,_ds_address
4946  0524 95            	ld	xh,a
4947  0525 cd028e        	call	_i2c_wr_reg
4949  0528 5b03          	addw	sp,#3
4950                     ; 57 }
4953  052a 81            	ret
4995                     ; 1 void spi_setup(void)
4995                     ; 2  {
4996                     	switch	.text
4997  052b               _spi_setup:
5001                     ; 3     SPI_CR1=0x7C;       //ну тип вот
5003  052b 357c5200      	mov	_SPI_CR1,#124
5004                     ; 4 		SPI_ICR = 0x80;
5006  052f 35805202      	mov	_SPI_ICR,#128
5007                     ; 6  }
5010  0533 81            	ret
5036                     ; 7 void SPI_Send1 (void)   //отправка первого байта SPI
5036                     ; 8 {
5037                     	switch	.text
5038  0534               _SPI_Send1:
5042                     ; 9   SPI_DR = deshifr_code_out;
5044  0534 5500225204    	mov	_SPI_DR,_deshifr_code_out
5045                     ; 10   spi_queue++;
5047  0539 3c0c          	inc	_spi_queue
5048                     ; 11 }	
5051  053b 81            	ret
5077                     ; 13 void SPI_Send2 (void)   //отправка второго байта
5077                     ; 14 {
5078                     	switch	.text
5079  053c               _SPI_Send2:
5083                     ; 15   SPI_DR=lamp_number_out;
5085  053c 5500215204    	mov	_SPI_DR,_lamp_number_out
5086                     ; 16   spi_queue = 1;
5088  0541 3501000c      	mov	_spi_queue,#1
5089                     ; 17 }
5092  0545 81            	ret
5127                     ; 19 void SPI_Send(uint8_t msg)
5127                     ; 20 {
5128                     	switch	.text
5129  0546               _SPI_Send:
5133                     ; 21 	SPI_DR = msg;
5135  0546 c75204        	ld	_SPI_DR,a
5136                     ; 22 }
5139  0549 81            	ret
5181                     ; 4 void UART_Resieved (void)
5181                     ; 5 {
5182                     	switch	.text
5183  054a               _UART_Resieved:
5187                     ; 7 	uart_routine(UART1_DR);
5189  054a c65231        	ld	a,_UART1_DR
5190  054d cd002a        	call	_uart_routine
5192                     ; 8 }
5195  0550 81            	ret
5220                     ; 10 void SPI_Transmitted(void)
5220                     ; 11 {
5221                     	switch	.text
5222  0551               _SPI_Transmitted:
5226                     ; 12 	SPI_Send(temp);
5228  0551 b60b          	ld	a,_temp
5229  0553 adf1          	call	_SPI_Send
5231                     ; 13 }
5234  0555 81            	ret
5261                     ; 15 void I2C_Event(void)
5261                     ; 16 {
5262                     	switch	.text
5263  0556               _I2C_Event:
5267                     ; 17 	temp = I2C_SR1;
5269  0556 555217000b    	mov	_temp,_I2C_SR1
5270                     ; 18 	if ((I2C_SR1 & I2C_SR1_SB) == I2C_SR1_SB)
5272  055b c65217        	ld	a,_I2C_SR1
5273  055e a401          	and	a,#1
5274  0560 a101          	cp	a,#1
5275  0562 2605          	jrne	L1513
5276                     ; 20 				i2c_send_adress();
5278  0564 cd0461        	call	_i2c_send_adress
5281  0567 200e          	jra	L3513
5282  0569               L1513:
5283                     ; 22 			else if ((I2C_SR1 & I2C_SR1_ADDR) == I2C_SR1_ADDR)
5285  0569 c65217        	ld	a,_I2C_SR1
5286  056c a402          	and	a,#2
5287  056e a102          	cp	a,#2
5288  0570 2602          	jrne	L5513
5289                     ; 24 				i2c_send_data;
5292  0572 2003          	jra	L3513
5293  0574               L5513:
5294                     ; 26 			else i2c_send_data();
5296  0574 cd0462        	call	_i2c_send_data
5298  0577               L3513:
5299                     ; 27 }
5302  0577 81            	ret
5328                     ; 29 void Keys_switched(void)
5328                     ; 30 {
5329                     	switch	.text
5330  0578               _Keys_switched:
5334                     ; 31 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
5336  0578 c650a0        	ld	a,_EXTI_CR1
5337  057b 43            	cpl	a
5338  057c a430          	and	a,#48
5339  057e c750a0        	ld	_EXTI_CR1,a
5340                     ; 32 	PC_CR2 = 0;
5342  0581 725f500e      	clr	_PC_CR2
5343                     ; 33 	timer2_start(0xff);
5345  0585 ae00ff        	ldw	x,#255
5346  0588 cd00b8        	call	_timer2_start
5348                     ; 78 }
5351  058b 81            	ret
5374                     ; 80 void DS_interrupt (void)
5374                     ; 81 {
5375                     	switch	.text
5376  058c               _DS_interrupt:
5380                     ; 83 }
5383  058c 81            	ret
5450                     ; 27 int main( void )
5450                     ; 28 {
5451                     	switch	.text
5452  058d               _main:
5456                     ; 31 	CLK_CKDIVR=0;                //нет делителей
5458  058d 725f50c6      	clr	_CLK_CKDIVR
5459                     ; 32   CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //тактирование на TIM1, UART1, SPI i I2C
5461  0591 35ff50c7      	mov	_CLK_PCKENR1,#255
5462                     ; 34 	_asm ("SIM"); // off interrupts
5465  0595 9b            SIM
5467                     ; 35 	EXTI_CR1 = 0x10; //(2<<EXTI_CR1_PCIS);
5469  0596 351050a0      	mov	_EXTI_CR1,#16
5470                     ; 39     PA_DDR=0x08; //0b000001000; //выход на защелку регистров, вход на сигнал с ртс
5472  059a 35085002      	mov	_PA_DDR,#8
5473                     ; 40     PA_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
5475  059e 35ff5003      	mov	_PA_CR1,#255
5476                     ; 47     PC_DDR=0x60; //0b01100000; //SPI на выход, кнопочки на вход
5478  05a2 3560500c      	mov	_PC_DDR,#96
5479                     ; 48     PC_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
5481  05a6 35ff500d      	mov	_PC_CR1,#255
5482                     ; 50     PC_CR2 |= (1<<4) | (1<<3);        //есть прерывания
5484  05aa c6500e        	ld	a,_PC_CR2
5485  05ad aa18          	or	a,#24
5486  05af c7500e        	ld	_PC_CR2,a
5487                     ; 52 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM на вход
5489  05b2 35a85011      	mov	_PD_DDR,#168
5490                     ; 53     PD_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
5492  05b6 35ff5012      	mov	_PD_CR1,#255
5493                     ; 54     PD_ODR = (1 << 3);
5495  05ba 3508500f      	mov	_PD_ODR,#8
5496                     ; 60 	i2c_master_init(16000000, 100000);
5498  05be ae86a0        	ldw	x,#34464
5499  05c1 89            	pushw	x
5500  05c2 ae0001        	ldw	x,#1
5501  05c5 89            	pushw	x
5502  05c6 ae2400        	ldw	x,#9216
5503  05c9 89            	pushw	x
5504  05ca ae00f4        	ldw	x,#244
5505  05cd 89            	pushw	x
5506  05ce cd0210        	call	_i2c_master_init
5508  05d1 5b08          	addw	sp,#8
5509                     ; 65 		uart_setup();
5511  05d3 cd0000        	call	_uart_setup
5513                     ; 66 		UART_Send('h');
5515  05d6 a668          	ld	a,#104
5516  05d8 cd0019        	call	_UART_Send
5518                     ; 67     timer1_setup( 65500,0xffff);//частота в гц и топ значение
5520  05db aeffff        	ldw	x,#65535
5521  05de 89            	pushw	x
5522  05df aeffdc        	ldw	x,#65500
5523  05e2 cd0184        	call	_timer1_setup
5525  05e5 85            	popw	x
5526                     ; 68 		timer2_setup();
5528  05e6 cd01ef        	call	_timer2_setup
5530                     ; 72 		timer1_start();
5532  05e9 cd017f        	call	_timer1_start
5534                     ; 74 		temp = 10;
5536  05ec 350a000b      	mov	_temp,#10
5537                     ; 75 		SPI_DR = temp;
5539  05f0 55000b5204    	mov	_SPI_DR,_temp
5540                     ; 76 		i2c_rd_reg(0xD0, 0, time_pointer, 1);
5542  05f5 4b01          	push	#1
5543  05f7 be06          	ldw	x,_time_pointer
5544  05f9 89            	pushw	x
5545  05fa aed000        	ldw	x,#53248
5546  05fd cd02f1        	call	_i2c_rd_reg
5548  0600 5b03          	addw	sp,#3
5549                     ; 79 	if((seconds & 0x80) == 0x80)
5551  0602 b617          	ld	a,_seconds
5552  0604 a480          	and	a,#128
5553  0606 a180          	cp	a,#128
5554  0608 2610          	jrne	L7123
5555                     ; 81 		seconds = 0;
5557  060a 3f17          	clr	_seconds
5558                     ; 82 		i2c_wr_reg(ds_address, 0,time_pointer, 1);
5560  060c 4b01          	push	#1
5561  060e be06          	ldw	x,_time_pointer
5562  0610 89            	pushw	x
5563  0611 5f            	clrw	x
5564  0612 b608          	ld	a,_ds_address
5565  0614 95            	ld	xh,a
5566  0615 cd028e        	call	_i2c_wr_reg
5568  0618 5b03          	addw	sp,#3
5569  061a               L7123:
5570                     ; 84 		i2c_rd_reg(0xD0, 0, &seconds, 1); 	
5572  061a 4b01          	push	#1
5573  061c ae0017        	ldw	x,#_seconds
5574  061f 89            	pushw	x
5575  0620 aed000        	ldw	x,#53248
5576  0623 cd02f1        	call	_i2c_rd_reg
5578  0626 5b03          	addw	sp,#3
5579                     ; 85 		i2c_rd_reg(0xD0, 1, &minutes, 1);
5581  0628 4b01          	push	#1
5582  062a ae0015        	ldw	x,#_minutes
5583  062d 89            	pushw	x
5584  062e aed001        	ldw	x,#53249
5585  0631 cd02f1        	call	_i2c_rd_reg
5587  0634 5b03          	addw	sp,#3
5588                     ; 86 		i2c_rd_reg(0xD0, 2, &hours, 1);
5590  0636 4b01          	push	#1
5591  0638 ae0013        	ldw	x,#_hours
5592  063b 89            	pushw	x
5593  063c aed002        	ldw	x,#53250
5594  063f cd02f1        	call	_i2c_rd_reg
5596  0642 5b03          	addw	sp,#3
5597                     ; 87 			UART_Send(seconds);
5599  0644 b617          	ld	a,_seconds
5600  0646 cd0019        	call	_UART_Send
5602                     ; 89  _asm ("RIM");  //on interupts
5605  0649 9a            RIM
5607  064a               L1223:
5608                     ; 90 while(1);
5610  064a 20fe          	jra	L1223
5623                     	xdef	_main
5624                     	xdef	_DS_interrupt
5625                     	xdef	_Keys_switched
5626                     	xdef	_I2C_Event
5627                     	xdef	_SPI_Transmitted
5628                     	xdef	_UART_Resieved
5629                     	xdef	_SPI_Send
5630                     	xdef	_SPI_Send2
5631                     	xdef	_SPI_Send1
5632                     	xdef	_spi_setup
5633                     	xdef	_display
5634                     	xdef	_time_recalculation
5635                     	xdef	_i2c_send_data
5636                     	xdef	_i2c_send_adress
5637                     	xdef	_i2c_init
5638                     	xdef	_i2c_rd_reg
5639                     	xdef	_i2c_wr_reg
5640                     	xdef	_i2c_master_init
5641                     	xdef	_Key_interrupt
5642                     	xdef	_timer2_setup
5643                     	xdef	_timer1_setup
5644                     	xdef	_timer1_start
5645                     	xdef	_Timer1_Compare_1
5646                     	xdef	_Timer2_Overflow
5647                     	xdef	_timer2_start
5648                     	xdef	_i2c_start
5649                     	xdef	_Two_keys_pressed
5650                     	xdef	_Inc_key_pressed
5651                     	xdef	_Menu_key_pressed
5652                     	xdef	_uart_routine
5653                     	xdef	_UART_Send
5654                     	xdef	_uart_setup
5655                     	xdef	_time_write
5656                     	switch	.ubsct
5657  0000               _i2c_flags:
5658  0000 00            	ds.b	1
5659                     	xdef	_i2c_flags
5660  0001               _flags:
5661  0001 00            	ds.b	1
5662                     	xdef	_flags
5663  0002               _cell_address:
5664  0002 00            	ds.b	1
5665                     	xdef	_cell_address
5666  0003               _data_type:
5667  0003 00            	ds.b	1
5668                     	xdef	_data_type
5669  0004               _i2c_current_adr:
5670  0004 00            	ds.b	1
5671                     	xdef	_i2c_current_adr
5672  0005               _i2c_end_adr:
5673  0005 00            	ds.b	1
5674                     	xdef	_i2c_end_adr
5675  0006               _i2c_start_adr:
5676  0006 00            	ds.b	1
5677                     	xdef	_i2c_start_adr
5678                     	xdef	_ds_address
5679  0007               _tunning:
5680  0007 00            	ds.b	1
5681                     	xdef	_tunning
5682  0008               _two_keys:
5683  0008 00            	ds.b	1
5684                     	xdef	_two_keys
5685  0009               _tunning_digits:
5686  0009 00            	ds.b	1
5687                     	xdef	_tunning_digits
5688  000a               _temp2:
5689  000a 00            	ds.b	1
5690                     	xdef	_temp2
5691  000b               _temp:
5692  000b 00            	ds.b	1
5693                     	xdef	_temp
5694  000c               _spi_queue:
5695  000c 00            	ds.b	1
5696                     	xdef	_spi_queue
5697  000d               _pins:
5698  000d 00            	ds.b	1
5699                     	xdef	_pins
5700  000e               _fresh_data_pointer:
5701  000e 0000          	ds.b	2
5702                     	xdef	_fresh_data_pointer
5703  0010               _data_pointer:
5704  0010 0000          	ds.b	2
5705                     	xdef	_data_pointer
5706                     	xdef	_time_pointer
5707  0012               _hours_decades:
5708  0012 00            	ds.b	1
5709                     	xdef	_hours_decades
5710  0013               _hours:
5711  0013 00            	ds.b	1
5712                     	xdef	_hours
5713  0014               _minutes_decades:
5714  0014 00            	ds.b	1
5715                     	xdef	_minutes_decades
5716  0015               _minutes:
5717  0015 00            	ds.b	1
5718                     	xdef	_minutes
5719  0016               _seconds_decades:
5720  0016 00            	ds.b	1
5721                     	xdef	_seconds_decades
5722  0017               _seconds:
5723  0017 00            	ds.b	1
5724                     	xdef	_seconds
5725  0018               _timeset:
5726  0018 00            	ds.b	1
5727                     	xdef	_timeset
5728  0019               _fresh_sec:
5729  0019 00            	ds.b	1
5730                     	xdef	_fresh_sec
5731  001a               _fresh_sec_dec:
5732  001a 00            	ds.b	1
5733                     	xdef	_fresh_sec_dec
5734  001b               _fresh_min:
5735  001b 00            	ds.b	1
5736                     	xdef	_fresh_min
5737  001c               _fresh_min_dec:
5738  001c 00            	ds.b	1
5739                     	xdef	_fresh_min_dec
5740  001d               _fresh_hours:
5741  001d 00            	ds.b	1
5742                     	xdef	_fresh_hours
5743  001e               _fresh_hours_dec:
5744  001e 00            	ds.b	1
5745                     	xdef	_fresh_hours_dec
5746  001f               _ds_tacts:
5747  001f 0000          	ds.b	2
5748                     	xdef	_ds_tacts
5749  0021               _lamp_number_out:
5750  0021 00            	ds.b	1
5751                     	xdef	_lamp_number_out
5752  0022               _deshifr_code_out:
5753  0022 00            	ds.b	1
5754                     	xdef	_deshifr_code_out
5755                     	xdef	_dots
5756                     	xdef	_lamp4_digit
5757                     	xdef	_lamp3_digit
5758                     	xdef	_lamp2_digit
5759                     	xdef	_lamp1_digit
5760                     	xdef	_lamp_number
5761  0023               L7241_i2c_timeout:
5762  0023 00000000      	ds.b	4
5763                     	xref.b	c_lreg
5764                     	xref.b	c_x
5784                     	xref	c_lrzmp
5785                     	xref	c_lgsbc
5786                     	xref	c_ludv
5787                     	xref	c_ltor
5788                     	xref	c_lrsh
5789                     	xref	c_ldiv
5790                     	xref	c_rtol
5791                     	xref	c_uitolx
5792                     	end
