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
2198  0006 0015          	dc.w	_seconds
2199  0008               _ds_address:
2200  0008 d0            	dc.b	208
2705                     ; 1  void uart_setup(void)
2705                     ; 2  {
2707                     	switch	.text
2708  0000               _uart_setup:
2712                     ; 3    UART1_BRR1=0x68;     //9600 bod
2714  0000 35685232      	mov	_UART1_BRR1,#104
2715                     ; 4     UART1_BRR2=0x03;
2717  0004 35035233      	mov	_UART1_BRR2,#3
2718                     ; 5     UART1_CR2 |= UART1_CR2_REN; //прием
2720  0008 72145235      	bset	_UART1_CR2,#2
2721                     ; 6     UART1_CR2 |= UART1_CR2_TEN; //передача
2723  000c 72165235      	bset	_UART1_CR2,#3
2724                     ; 7     UART1_CR2 |= UART1_CR2_RIEN; //Прерывание по приему
2726  0010 721a5235      	bset	_UART1_CR2,#5
2727                     ; 8 		UART1_SR = 0;
2729  0014 725f5230      	clr	_UART1_SR
2730                     ; 9  }
2733  0018 81            	ret
2770                     ; 10 void UART_Send (uint8_t msg)
2770                     ; 11  {
2771                     	switch	.text
2772  0019               _UART_Send:
2774  0019 88            	push	a
2775       00000000      OFST:	set	0
2778                     ; 13 	 temp =msg;
2780  001a b70b          	ld	_temp,a
2782  001c               L5002:
2783                     ; 14 	 while((UART1_SR & 0x80) == 0x00);
2785  001c c65230        	ld	a,_UART1_SR
2786  001f a580          	bcp	a,#128
2787  0021 27f9          	jreq	L5002
2788                     ; 15 	 UART1_DR = msg;
2790  0023 7b01          	ld	a,(OFST+1,sp)
2791  0025 c75231        	ld	_UART1_DR,a
2792                     ; 16  }
2795  0028 84            	pop	a
2796  0029 81            	ret
2838                     ; 5 void Menu_key_pressed(void)
2838                     ; 6 {
2839                     	switch	.text
2840  002a               _Menu_key_pressed:
2844                     ; 7 	UART_Send('1');
2846  002a a631          	ld	a,#49
2847  002c adeb          	call	_UART_Send
2849                     ; 8   if (tunning_digits ==1)
2851  002e b609          	ld	a,_tunning_digits
2852  0030 a101          	cp	a,#1
2853  0032 2604          	jrne	L7202
2854                     ; 10      tunning_digits =0;
2856  0034 3f09          	clr	_tunning_digits
2858  0036 2004          	jra	L1302
2859  0038               L7202:
2860                     ; 12   else tunning_digits=1;
2862  0038 35010009      	mov	_tunning_digits,#1
2863  003c               L1302:
2864                     ; 13 }
2867  003c 81            	ret
2896                     ; 15 void Inc_key_pressed(void)
2896                     ; 16 {
2897                     	switch	.text
2898  003d               _Inc_key_pressed:
2902                     ; 17 	UART_Send('2');
2904  003d a632          	ld	a,#50
2905  003f add8          	call	_UART_Send
2907                     ; 18   if (tunning_digits ==0)
2909  0041 3d09          	tnz	_tunning_digits
2910  0043 2616          	jrne	L3402
2911                     ; 20      hours++;
2913  0045 3c11          	inc	_hours
2914                     ; 21      if (hours == 0x0A)
2916  0047 b611          	ld	a,_hours
2917  0049 a10a          	cp	a,#10
2918  004b 2628          	jrne	L1502
2919                     ; 23         hours_decades++;
2921  004d 3c10          	inc	_hours_decades
2922                     ; 24         hours =0;
2924  004f 3f11          	clr	_hours
2925                     ; 25         if (hours_decades ==0x03)
2927  0051 b610          	ld	a,_hours_decades
2928  0053 a103          	cp	a,#3
2929  0055 261e          	jrne	L1502
2930                     ; 27            hours_decades =0;
2932  0057 3f10          	clr	_hours_decades
2933  0059 201a          	jra	L1502
2934  005b               L3402:
2935                     ; 31   else if (tunning_digits ==1)
2937  005b b609          	ld	a,_tunning_digits
2938  005d a101          	cp	a,#1
2939  005f 2614          	jrne	L1502
2940                     ; 33      minutes++;
2942  0061 3c13          	inc	_minutes
2943                     ; 34      if (minutes == 0x0A)
2945  0063 b613          	ld	a,_minutes
2946  0065 a10a          	cp	a,#10
2947  0067 260c          	jrne	L1502
2948                     ; 36         minutes_decades++;
2950  0069 3c12          	inc	_minutes_decades
2951                     ; 37         minutes =0;
2953  006b 3f13          	clr	_minutes
2954                     ; 38         if (minutes_decades ==0x06)
2956  006d b612          	ld	a,_minutes_decades
2957  006f a106          	cp	a,#6
2958  0071 2602          	jrne	L1502
2959                     ; 40            minutes_decades =0;
2961  0073 3f12          	clr	_minutes_decades
2962  0075               L1502:
2963                     ; 44 }
2966  0075 81            	ret
2989                     ; 46 void Two_keys_pressed(void)
2989                     ; 47 {
2990                     	switch	.text
2991  0076               _Two_keys_pressed:
2995                     ; 49 }
2998  0076 81            	ret
3052                     ; 4 void timer2_start(uint16_t top_val)
3052                     ; 5 {
3053                     	switch	.text
3054  0077               _timer2_start:
3058                     ; 6   TIM2_ARRH =top_val >>8;
3060  0077 9e            	ld	a,xh
3061  0078 c7530f        	ld	_TIM2_ARRH,a
3062                     ; 7   TIM2_ARRL =top_val & 0xFF;
3064  007b 9f            	ld	a,xl
3065  007c a4ff          	and	a,#255
3066  007e c75310        	ld	_TIM2_ARRL,a
3067                     ; 8   TIM2_CR1 |= TIM2_CR1_CEN;
3069  0081 72105300      	bset	_TIM2_CR1,#0
3070                     ; 9 }
3073  0085 81            	ret
3106                     ; 11 void Timer2_Overflow (void)
3106                     ; 12 {
3107                     	switch	.text
3108  0086               _Timer2_Overflow:
3112                     ; 13 	TIM2_SR1 = 0;
3114  0086 725f5304      	clr	_TIM2_SR1
3115                     ; 14 	UART_Send('k');
3117  008a a66b          	ld	a,#107
3118  008c ad8b          	call	_UART_Send
3120                     ; 16   if (pins==PC_IDR)
3122  008e b60d          	ld	a,_pins
3123  0090 c1500b        	cp	a,_PC_IDR
3124  0093 2669          	jrne	L5212
3125                     ; 18     if(PC_IDR == PC_IDR & (1<<3))
3127  0095 c6500b        	ld	a,_PC_IDR
3128  0098 c1500b        	cp	a,_PC_IDR
3129  009b 2605          	jrne	L22
3130  009d ae0001        	ldw	x,#1
3131  00a0 2001          	jra	L42
3132  00a2               L22:
3133  00a2 5f            	clrw	x
3134  00a3               L42:
3135  00a3 01            	rrwa	x,a
3136  00a4 a508          	bcp	a,#8
3137  00a6 2709          	jreq	L7212
3138                     ; 20       Menu_key_pressed();
3140  00a8 ad80          	call	_Menu_key_pressed
3142                     ; 21       timer2_start(0xFFF0);     //ставим задержку перед сменой
3144  00aa aefff0        	ldw	x,#65520
3145  00ad adc8          	call	_timer2_start
3148  00af 204d          	jra	L5212
3149  00b1               L7212:
3150                     ; 23     else if (PC_IDR == PC_IDR & (1<<4))
3152  00b1 c6500b        	ld	a,_PC_IDR
3153  00b4 c1500b        	cp	a,_PC_IDR
3154  00b7 2605          	jrne	L62
3155  00b9 ae0001        	ldw	x,#1
3156  00bc 2001          	jra	L03
3157  00be               L62:
3158  00be 5f            	clrw	x
3159  00bf               L03:
3160  00bf 01            	rrwa	x,a
3161  00c0 a510          	bcp	a,#16
3162  00c2 270a          	jreq	L3312
3163                     ; 25       Inc_key_pressed();
3165  00c4 cd003d        	call	_Inc_key_pressed
3167                     ; 26       timer2_start(0xFFF0);
3169  00c7 aefff0        	ldw	x,#65520
3170  00ca adab          	call	_timer2_start
3173  00cc 2030          	jra	L5212
3174  00ce               L3312:
3175                     ; 28     else if ((PC_IDR== PC_IDR & (1<<3)) && (PC_IDR== PC_IDR & (1<<4)))
3177  00ce c6500b        	ld	a,_PC_IDR
3178  00d1 c1500b        	cp	a,_PC_IDR
3179  00d4 2605          	jrne	L23
3180  00d6 ae0001        	ldw	x,#1
3181  00d9 2001          	jra	L43
3182  00db               L23:
3183  00db 5f            	clrw	x
3184  00dc               L43:
3185  00dc 01            	rrwa	x,a
3186  00dd a508          	bcp	a,#8
3187  00df 271d          	jreq	L5212
3189  00e1 c6500b        	ld	a,_PC_IDR
3190  00e4 c1500b        	cp	a,_PC_IDR
3191  00e7 2605          	jrne	L63
3192  00e9 ae0001        	ldw	x,#1
3193  00ec 2001          	jra	L04
3194  00ee               L63:
3195  00ee 5f            	clrw	x
3196  00ef               L04:
3197  00ef 01            	rrwa	x,a
3198  00f0 a510          	bcp	a,#16
3199  00f2 270a          	jreq	L5212
3200                     ; 30        two_keys =1;
3202  00f4 35010008      	mov	_two_keys,#1
3203                     ; 32       timer2_start(0xFFF0);
3205  00f8 aefff0        	ldw	x,#65520
3206  00fb cd0077        	call	_timer2_start
3208  00fe               L5212:
3209                     ; 35   if (pins !=PC_IDR)
3211  00fe b60d          	ld	a,_pins
3212  0100 c1500b        	cp	a,_PC_IDR
3213  0103 270a          	jreq	L1412
3214                     ; 37      if (two_keys ==1)  //пины сменились и оба отжались
3216  0105 b608          	ld	a,_two_keys
3217  0107 a101          	cp	a,#1
3218  0109 2604          	jrne	L1412
3219                     ; 39         two_keys =0;
3221  010b 3f08          	clr	_two_keys
3222                     ; 40         tunning=0;
3224  010d 3f07          	clr	_tunning
3225  010f               L1412:
3226                     ; 44 	 PC_CR2 |= (1<<4) | (1<<3);        //есть прерывания
3228  010f c6500e        	ld	a,_PC_CR2
3229  0112 aa18          	or	a,#24
3230  0114 c7500e        	ld	_PC_CR2,a
3231                     ; 45 }
3234  0117 81            	ret
3265                     ; 47 void Timer1_Compare_1 (void)
3265                     ; 48 {
3266                     	switch	.text
3267  0118               _Timer1_Compare_1:
3271                     ; 49 	TIM1_SR1 = 0;
3273  0118 725f5255      	clr	_TIM1_SR1
3274                     ; 50   lamp_number_out = lamp_number;                //выводим в регистры значения без точек
3276  011c 45001b        	mov	_lamp_number_out,_lamp_number
3277                     ; 51 	PD_ODR = ~PD_ODR & 1<<3;;
3279  011f c6500f        	ld	a,_PD_ODR
3280  0122 43            	cpl	a
3281  0123 a408          	and	a,#8
3282  0125 c7500f        	ld	_PD_ODR,a
3283                     ; 52 	UART_Send('t');
3286  0128 a674          	ld	a,#116
3287  012a cd0019        	call	_UART_Send
3289                     ; 54 	data_pointer = &seconds;
3291  012d ae0015        	ldw	x,#_seconds
3292  0130 bf0e          	ldw	_data_pointer,x
3293                     ; 55 	i2c_start(1, 0x00, 0x00);
3295  0132 4b00          	push	#0
3296  0134 ae0100        	ldw	x,#256
3297  0137 cd0492        	call	_i2c_start
3299  013a 84            	pop	a
3300                     ; 56 }
3303  013b 81            	ret
3327                     ; 60 void timer1_start(void)
3327                     ; 61  {
3328                     	switch	.text
3329  013c               _timer1_start:
3333                     ; 62    TIM1_CR1 |= TIM1_CR1_CEN; //Запускаем таймер
3335  013c 72105250      	bset	_TIM1_CR1,#0
3336                     ; 63  }
3339  0140 81            	ret
3389                     ; 65 void timer1_setup(uint16_t tim_freq, uint16_t top)
3389                     ; 66  {
3390                     	switch	.text
3391  0141               _timer1_setup:
3393  0141 89            	pushw	x
3394  0142 5204          	subw	sp,#4
3395       00000004      OFST:	set	4
3398                     ; 68   TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
3400  0144 cd0000        	call	c_uitolx
3402  0147 96            	ldw	x,sp
3403  0148 1c0001        	addw	x,#OFST-3
3404  014b cd0000        	call	c_rtol
3406  014e ae2400        	ldw	x,#9216
3407  0151 bf02          	ldw	c_lreg+2,x
3408  0153 ae00f4        	ldw	x,#244
3409  0156 bf00          	ldw	c_lreg,x
3410  0158 96            	ldw	x,sp
3411  0159 1c0001        	addw	x,#OFST-3
3412  015c cd0000        	call	c_ldiv
3414  015f a608          	ld	a,#8
3415  0161 cd0000        	call	c_lrsh
3417  0164 b603          	ld	a,c_lreg+3
3418  0166 c75260        	ld	_TIM1_PSCRH,a
3419                     ; 69   TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; //Делитель на 16
3421  0169 1e05          	ldw	x,(OFST+1,sp)
3422  016b cd0000        	call	c_uitolx
3424  016e 96            	ldw	x,sp
3425  016f 1c0001        	addw	x,#OFST-3
3426  0172 cd0000        	call	c_rtol
3428  0175 ae2400        	ldw	x,#9216
3429  0178 bf02          	ldw	c_lreg+2,x
3430  017a ae00f4        	ldw	x,#244
3431  017d bf00          	ldw	c_lreg,x
3432  017f 96            	ldw	x,sp
3433  0180 1c0001        	addw	x,#OFST-3
3434  0183 cd0000        	call	c_ldiv
3436  0186 3f02          	clr	c_lreg+2
3437  0188 3f01          	clr	c_lreg+1
3438  018a 3f00          	clr	c_lreg
3439  018c b603          	ld	a,c_lreg+3
3440  018e c75261        	ld	_TIM1_PSCRL,a
3441                     ; 70   TIM1_ARRH = (top) >> 8; //Частота переполнений = 16М / 8 / 1000 = 2000 Гц
3443  0191 7b09          	ld	a,(OFST+5,sp)
3444  0193 c75262        	ld	_TIM1_ARRH,a
3445                     ; 71   TIM1_ARRL = (top)& 0xFF;
3447  0196 7b0a          	ld	a,(OFST+6,sp)
3448  0198 a4ff          	and	a,#255
3449  019a c75263        	ld	_TIM1_ARRL,a
3450                     ; 73   TIM1_CR1 |= TIM1_CR1_URS; //Прерывание только по переполнению счетчика
3452  019d 72145250      	bset	_TIM1_CR1,#2
3453                     ; 74   TIM1_EGR |= TIM1_EGR_UG;  //Вызываем Update Event
3455  01a1 72105257      	bset	_TIM1_EGR,#0
3456                     ; 76   TIM1_IER |= TIM1_IER_UIE; //Разрешаем прерывание
3458  01a5 72105254      	bset	_TIM1_IER,#0
3459                     ; 78  }
3462  01a9 5b06          	addw	sp,#6
3463  01ab 81            	ret
3491                     ; 79 void timer2_setup(void)
3491                     ; 80  {
3492                     	switch	.text
3493  01ac               _timer2_setup:
3497                     ; 82     TIM2_CR1 = TIM2_CR1_URS | TIM2_CR1_OPM;      //в режиме одного импульса
3499  01ac 350c5300      	mov	_TIM2_CR1,#12
3500                     ; 83     TIM2_IER = TIM2_IER_UIE;         //прерывание по переполнению
3502  01b0 35015303      	mov	_TIM2_IER,#1
3503                     ; 84     TIM2_PSCR = 0;
3505  01b4 725f530e      	clr	_TIM2_PSCR
3506                     ; 85     TIM2_ARRH = 0;
3508  01b8 725f530f      	clr	_TIM2_ARRH
3509                     ; 86     TIM2_ARRL = 0x64;
3511  01bc 35645310      	mov	_TIM2_ARRL,#100
3512                     ; 87  }
3515  01c0 81            	ret
3541                     ; 89  void Key_interrupt (void)
3541                     ; 90 {
3542                     	switch	.text
3543  01c1               _Key_interrupt:
3547                     ; 91   pins = PC_IDR;           //сохранили состояние порта
3549  01c1 55500b000d    	mov	_pins,_PC_IDR
3550                     ; 92   timer2_start(0x0064);       //запустили таймер для отфильтровки
3552  01c6 ae0064        	ldw	x,#100
3553  01c9 cd0077        	call	_timer2_start
3555                     ; 93 }
3558  01cc 81            	ret
3608                     ; 7 void time_recalculation(void)
3608                     ; 8 {
3609                     	switch	.text
3610  01cd               _time_recalculation:
3614                     ; 10   if ((minutes_decades != fresh_min & 0x70) && (((fresh_min & 0x70) >>4 == 3) || ((fresh_min & 0x70) >>4 == 0)))
3616  01cd b612          	ld	a,_minutes_decades
3617  01cf b117          	cp	a,_fresh_min
3618  01d1 2705          	jreq	L65
3619  01d3 ae0001        	ldw	x,#1
3620  01d6 2001          	jra	L06
3621  01d8               L65:
3622  01d8 5f            	clrw	x
3623  01d9               L06:
3624  01d9 01            	rrwa	x,a
3625  01da a570          	bcp	a,#112
3626  01dc 2718          	jreq	L5422
3628  01de b617          	ld	a,_fresh_min
3629  01e0 a470          	and	a,#112
3630  01e2 4e            	swap	a
3631  01e3 a40f          	and	a,#15
3632  01e5 5f            	clrw	x
3633  01e6 97            	ld	xl,a
3634  01e7 a30003        	cpw	x,#3
3635  01ea 2706          	jreq	L7422
3637  01ec b617          	ld	a,_fresh_min
3638  01ee a570          	bcp	a,#112
3639  01f0 2604          	jrne	L5422
3640  01f2               L7422:
3641                     ; 12      flags.time_refresh =1;  //флаг прогона циферок.
3643  01f2 72160001      	bset	_flags,#3
3644  01f6               L5422:
3645                     ; 16   seconds = fresh_sec & 0x0F;
3647  01f6 b618          	ld	a,_fresh_sec
3648  01f8 a40f          	and	a,#15
3649  01fa b715          	ld	_seconds,a
3650                     ; 17   seconds_decades = fresh_sec & 0x70;
3652  01fc b618          	ld	a,_fresh_sec
3653  01fe a470          	and	a,#112
3654  0200 b714          	ld	_seconds_decades,a
3655                     ; 19   minutes = fresh_min & 0x0F;
3657  0202 b617          	ld	a,_fresh_min
3658  0204 a40f          	and	a,#15
3659  0206 b713          	ld	_minutes,a
3660                     ; 20   minutes_decades = fresh_min & 0x70;
3662  0208 b617          	ld	a,_fresh_min
3663  020a a470          	and	a,#112
3664  020c b712          	ld	_minutes_decades,a
3665                     ; 22   hours = fresh_hours & 0x0F;
3667  020e b616          	ld	a,_fresh_hours
3668  0210 a40f          	and	a,#15
3669  0212 b711          	ld	_hours,a
3670                     ; 23   hours_decades = fresh_hours & 0x10;
3672  0214 b616          	ld	a,_fresh_hours
3673  0216 a410          	and	a,#16
3674  0218 b710          	ld	_hours_decades,a
3675                     ; 25   if (hours_decades <=6)
3677  021a b610          	ld	a,_hours_decades
3678  021c a107          	cp	a,#7
3679  021e 2404          	jruge	L1522
3680                     ; 27      flags.night = 1;
3682  0220 72180001      	bset	_flags,#4
3683  0224               L1522:
3684                     ; 30 }
3687  0224 81            	ret
3752                     ; 35 void display(uint8_t lamp1, uint8_t lamp2, uint8_t lamp3, uint8_t lamp4 )
3752                     ; 36 {
3753                     	switch	.text
3754  0225               _display:
3756  0225 89            	pushw	x
3757       00000000      OFST:	set	0
3760                     ; 37   if ((lamp3_digit !=lamp3) && (lamp3 == 0x02 || 0x00))
3762  0226 b603          	ld	a,_lamp3_digit
3763  0228 1105          	cp	a,(OFST+5,sp)
3764  022a 2704          	jreq	L5032
3766  022c 7b05          	ld	a,(OFST+5,sp)
3767  022e a102          	cp	a,#2
3768  0230               L5032:
3769                     ; 41   lamp1_digit =lamp1;
3771  0230 7b01          	ld	a,(OFST+1,sp)
3772  0232 b701          	ld	_lamp1_digit,a
3773                     ; 42   lamp2_digit =lamp2;
3775  0234 7b02          	ld	a,(OFST+2,sp)
3776  0236 b702          	ld	_lamp2_digit,a
3777                     ; 43   lamp3_digit =lamp3;
3779  0238 7b05          	ld	a,(OFST+5,sp)
3780  023a b703          	ld	_lamp3_digit,a
3781                     ; 44   lamp4_digit =lamp4;
3783  023c 7b06          	ld	a,(OFST+6,sp)
3784  023e b704          	ld	_lamp4_digit,a
3785                     ; 46 }
3788  0240 85            	popw	x
3789  0241 81            	ret
3868                     ; 7 void i2c_master_init(unsigned long f_master_hz, unsigned long f_i2c_hz){
3869                     	switch	.text
3870  0242               _i2c_master_init:
3872  0242 5208          	subw	sp,#8
3873       00000008      OFST:	set	8
3876                     ; 10   PB_DDR = (0<<4);//PB_DDR_DDR4);
3878  0244 725f5007      	clr	_PB_DDR
3879                     ; 11 	PB_DDR = (0<<5);//PB_DDR_DDR5);
3881  0248 725f5007      	clr	_PB_DDR
3882                     ; 12 	PB_ODR = (1<<5);//PB_ODR_ODR5);  //SDA
3884  024c 35205005      	mov	_PB_ODR,#32
3885                     ; 13   PB_ODR = (1<<4);//PB_ODR_ODR4);  //SCL
3887  0250 35105005      	mov	_PB_ODR,#16
3888                     ; 15   PB_CR1 = (0<<4);//PB_CR1_C14);
3890  0254 725f5008      	clr	_PB_CR1
3891                     ; 16   PB_CR1 = (0<<5);//PB_CR1_C15);
3893  0258 725f5008      	clr	_PB_CR1
3894                     ; 18   PB_CR2 = (0<<4);//PB_CR1_C24);
3896  025c 725f5009      	clr	_PB_CR2
3897                     ; 19   PB_CR2 = (0<<5);//PB_CR1_C25);
3899  0260 725f5009      	clr	_PB_CR2
3900                     ; 22   I2C_FREQR = 16;
3902  0264 35105212      	mov	_I2C_FREQR,#16
3903                     ; 24   I2C_CR1 |=~I2C_CR1_PE;
3905  0268 c65210        	ld	a,_I2C_CR1
3906  026b aafe          	or	a,#254
3907  026d c75210        	ld	_I2C_CR1,a
3908                     ; 27   I2C_CCRH |=~I2C_CCRH_FS;
3910  0270 c6521c        	ld	a,_I2C_CCRH
3911  0273 aa7f          	or	a,#127
3912  0275 c7521c        	ld	_I2C_CCRH,a
3913                     ; 29   ccr = f_master_hz/(2*f_i2c_hz);
3915  0278 96            	ldw	x,sp
3916  0279 1c000f        	addw	x,#OFST+7
3917  027c cd0000        	call	c_ltor
3919  027f 3803          	sll	c_lreg+3
3920  0281 3902          	rlc	c_lreg+2
3921  0283 3901          	rlc	c_lreg+1
3922  0285 3900          	rlc	c_lreg
3923  0287 96            	ldw	x,sp
3924  0288 1c0001        	addw	x,#OFST-7
3925  028b cd0000        	call	c_rtol
3927  028e 96            	ldw	x,sp
3928  028f 1c000b        	addw	x,#OFST+3
3929  0292 cd0000        	call	c_ltor
3931  0295 96            	ldw	x,sp
3932  0296 1c0001        	addw	x,#OFST-7
3933  0299 cd0000        	call	c_ludv
3935  029c 96            	ldw	x,sp
3936  029d 1c0005        	addw	x,#OFST-3
3937  02a0 cd0000        	call	c_rtol
3939                     ; 33   I2C_TRISER = 12+1;
3941  02a3 350d521d      	mov	_I2C_TRISER,#13
3942                     ; 34   I2C_CCRL = ccr & 0xFF;
3944  02a7 7b08          	ld	a,(OFST+0,sp)
3945  02a9 a4ff          	and	a,#255
3946  02ab c7521b        	ld	_I2C_CCRL,a
3947                     ; 35   I2C_CCRH = ((ccr >> 8) & 0x0F);
3949  02ae 7b07          	ld	a,(OFST-1,sp)
3950  02b0 a40f          	and	a,#15
3951  02b2 c7521c        	ld	_I2C_CCRH,a
3952                     ; 37   I2C_CR1 |=I2C_CR1_PE;
3954  02b5 72105210      	bset	_I2C_CR1,#0
3955                     ; 39   I2C_CR2 |=I2C_CR2_ACK;
3957  02b9 72145211      	bset	_I2C_CR2,#2
3958                     ; 40 }
3961  02bd 5b08          	addw	sp,#8
3962  02bf 81            	ret
4056                     ; 46 t_i2c_status i2c_wr_reg(unsigned char address, unsigned char reg_addr,
4056                     ; 47                               char * data, unsigned char length)
4056                     ; 48 {                                  
4057                     	switch	.text
4058  02c0               _i2c_wr_reg:
4060  02c0 89            	pushw	x
4061       00000000      OFST:	set	0
4064  02c1               L1142:
4065                     ; 52   while((I2C_SR3 & I2C_SR3_BUSY) !=0);   
4067  02c1 c65219        	ld	a,_I2C_SR3
4068  02c4 a502          	bcp	a,#2
4069  02c6 26f9          	jrne	L1142
4070                     ; 54   I2C_CR2 |= I2C_CR2_START;
4072  02c8 72105211      	bset	_I2C_CR2,#0
4074  02cc               L7142:
4075                     ; 57   while((I2C_SR1 & I2C_SR1_SB) == 0); 
4077  02cc c65217        	ld	a,_I2C_SR1
4078  02cf a501          	bcp	a,#1
4079  02d1 27f9          	jreq	L7142
4080                     ; 60   I2C_DR = address & 0xFE;
4082  02d3 7b01          	ld	a,(OFST+1,sp)
4083  02d5 a4fe          	and	a,#254
4084  02d7 c75216        	ld	_I2C_DR,a
4086  02da               L7242:
4087                     ; 63 	while((I2C_SR1 & I2C_SR1_ADDR) == 0);
4089  02da c65217        	ld	a,_I2C_SR1
4090  02dd a502          	bcp	a,#2
4091  02df 27f9          	jreq	L7242
4092                     ; 65   I2C_SR3;
4094  02e1 c65219        	ld	a,_I2C_SR3
4096  02e4               L5342:
4097                     ; 70   while((I2C_SR1 & I2C_SR1_TXE) ==0);
4099  02e4 c65217        	ld	a,_I2C_SR1
4100  02e7 a580          	bcp	a,#128
4101  02e9 27f9          	jreq	L5342
4102                     ; 72   I2C_DR = reg_addr;
4104  02eb 7b02          	ld	a,(OFST+2,sp)
4105  02ed c75216        	ld	_I2C_DR,a
4107  02f0 2015          	jra	L5442
4108  02f2               L3542:
4109                     ; 78     while((I2C_SR1 & I2C_SR1_TXE) == 0);
4111  02f2 c65217        	ld	a,_I2C_SR1
4112  02f5 a580          	bcp	a,#128
4113  02f7 27f9          	jreq	L3542
4114                     ; 80     I2C_DR = *data++;
4116  02f9 1e05          	ldw	x,(OFST+5,sp)
4117  02fb 1c0001        	addw	x,#1
4118  02fe 1f05          	ldw	(OFST+5,sp),x
4119  0300 1d0001        	subw	x,#1
4120  0303 f6            	ld	a,(x)
4121  0304 c75216        	ld	_I2C_DR,a
4122  0307               L5442:
4123                     ; 75   while(length--){
4125  0307 7b07          	ld	a,(OFST+7,sp)
4126  0309 0a07          	dec	(OFST+7,sp)
4127  030b 4d            	tnz	a
4128  030c 26e4          	jrne	L3542
4130  030e               L1642:
4131                     ; 85   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
4133  030e c65217        	ld	a,_I2C_SR1
4134  0311 a584          	bcp	a,#132
4135  0313 27f9          	jreq	L1642
4136                     ; 87   I2C_CR2 |= I2C_CR2_STOP;
4138  0315 72125211      	bset	_I2C_CR2,#1
4140  0319               L7642:
4141                     ; 90   while((I2C_CR2 & I2C_CR2_STOP) == 0); 
4143  0319 c65211        	ld	a,_I2C_CR2
4144  031c a502          	bcp	a,#2
4145  031e 27f9          	jreq	L7642
4146                     ; 91   return I2C_SUCCESS;
4148  0320 4f            	clr	a
4151  0321 85            	popw	x
4152  0322 81            	ret
4223                     ; 98 t_i2c_status i2c_rd_reg(unsigned char address, unsigned char reg_addr,
4223                     ; 99                               char * data, unsigned char length)
4223                     ; 100 {
4224                     	switch	.text
4225  0323               _i2c_rd_reg:
4227  0323 89            	pushw	x
4228       00000000      OFST:	set	0
4231  0324               L7252:
4232                     ; 106   while((I2C_SR3 & I2C_SR3_BUSY) != 0);   
4234  0324 c65219        	ld	a,_I2C_SR3
4235  0327 a502          	bcp	a,#2
4236  0329 26f9          	jrne	L7252
4237                     ; 108   I2C_CR2 |= I2C_CR2_ACK;
4239  032b 72145211      	bset	_I2C_CR2,#2
4240                     ; 111   I2C_CR2 |= I2C_CR2_START;
4242  032f 72105211      	bset	_I2C_CR2,#0
4244  0333               L5352:
4245                     ; 114   while((I2C_SR1 & I2C_SR1_SB) == 0);  
4247  0333 c65217        	ld	a,_I2C_SR1
4248  0336 a501          	bcp	a,#1
4249  0338 27f9          	jreq	L5352
4250                     ; 116   I2C_DR = address & 0xFE;
4252  033a 7b01          	ld	a,(OFST+1,sp)
4253  033c a4fe          	and	a,#254
4254  033e c75216        	ld	_I2C_DR,a
4256  0341               L5452:
4257                     ; 119   while((I2C_SR1 & I2C_SR1_ADDR) == 0);
4259  0341 c65217        	ld	a,_I2C_SR1
4260  0344 a502          	bcp	a,#2
4261  0346 27f9          	jreq	L5452
4262                     ; 121   temp = I2C_SR3;
4264  0348 555219000b    	mov	_temp,_I2C_SR3
4266  034d               L5552:
4267                     ; 125   while((I2C_SR1 & I2C_SR1) == 0); 
4269  034d c65217        	ld	a,_I2C_SR1
4270  0350 5f            	clrw	x
4271  0351 97            	ld	xl,a
4272  0352 a30000        	cpw	x,#0
4273  0355 27f6          	jreq	L5552
4274                     ; 127   I2C_DR = reg_addr;
4276  0357 7b02          	ld	a,(OFST+2,sp)
4277  0359 c75216        	ld	_I2C_DR,a
4279  035c               L5652:
4280                     ; 130   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
4282  035c c65217        	ld	a,_I2C_SR1
4283  035f a584          	bcp	a,#132
4284  0361 27f9          	jreq	L5652
4285                     ; 132   I2C_CR2 |= I2C_CR2_START;
4287  0363 72105211      	bset	_I2C_CR2,#0
4289  0367               L3752:
4290                     ; 135   while((I2C_SR1 & I2C_SR1_SB) == 0); 
4292  0367 c65217        	ld	a,_I2C_SR1
4293  036a a501          	bcp	a,#1
4294  036c 27f9          	jreq	L3752
4295                     ; 138   I2C_DR = address | 0x01;
4297  036e 7b01          	ld	a,(OFST+1,sp)
4298  0370 aa01          	or	a,#1
4299  0372 c75216        	ld	_I2C_DR,a
4300                     ; 142   if(length == 1){
4302  0375 7b07          	ld	a,(OFST+7,sp)
4303  0377 a101          	cp	a,#1
4304  0379 2627          	jrne	L7752
4305                     ; 144     I2C_CR2 &= ~I2C_CR2_ACK;
4307  037b 72155211      	bres	_I2C_CR2,#2
4309  037f               L3062:
4310                     ; 147     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
4312  037f c65217        	ld	a,_I2C_SR1
4313  0382 a502          	bcp	a,#2
4314  0384 27f9          	jreq	L3062
4315                     ; 149     _asm ("SIM");  //on interupts
4318  0386 9b            SIM
4320                     ; 151     temp = I2C_SR3;
4322  0387 555219000b    	mov	_temp,_I2C_SR3
4323                     ; 154     I2C_CR2 |= I2C_CR2_STOP;
4325  038c 72125211      	bset	_I2C_CR2,#1
4326                     ; 156     _asm ("RIM");  //on interupts;
4329  0390 9a            RIM
4332  0391               L1162:
4333                     ; 160     while((I2C_SR1 & I2C_SR1_RXNE) == 0); 
4335  0391 c65217        	ld	a,_I2C_SR1
4336  0394 a540          	bcp	a,#64
4337  0396 27f9          	jreq	L1162
4338                     ; 162     *data = I2C_DR;
4340  0398 1e05          	ldw	x,(OFST+5,sp)
4341  039a c65216        	ld	a,_I2C_DR
4342  039d f7            	ld	(x),a
4344  039e ac830483      	jpf	L5072
4345  03a2               L7752:
4346                     ; 165   else if(length == 2){
4348  03a2 7b07          	ld	a,(OFST+7,sp)
4349  03a4 a102          	cp	a,#2
4350  03a6 263b          	jrne	L7162
4351                     ; 167     I2C_CR2 |= I2C_CR2_POS;
4353  03a8 72165211      	bset	_I2C_CR2,#3
4355  03ac               L3262:
4356                     ; 170     while((I2C_SR1 & I2C_SR1_ADDR) == 0);
4358  03ac c65217        	ld	a,_I2C_SR1
4359  03af a502          	bcp	a,#2
4360  03b1 27f9          	jreq	L3262
4361                     ; 172     _asm ("SIM");  //on interupts;
4364  03b3 9b            SIM
4366                     ; 174     temp = I2C_SR3;
4368  03b4 555219000b    	mov	_temp,_I2C_SR3
4369                     ; 176     I2C_CR2 &= ~I2C_CR2_ACK;
4371  03b9 72155211      	bres	_I2C_CR2,#2
4372                     ; 178     _asm ("RIM");  //on interupts;
4375  03bd 9a            RIM
4378  03be               L1362:
4379                     ; 182     while((I2C_SR1 & I2C_SR1_BTF) == 0); 
4381  03be c65217        	ld	a,_I2C_SR1
4382  03c1 a504          	bcp	a,#4
4383  03c3 27f9          	jreq	L1362
4384                     ; 184     _asm ("SIM");  //on interupts;
4387  03c5 9b            SIM
4389                     ; 186     I2C_CR2 |= I2C_CR2_STOP;
4391  03c6 72125211      	bset	_I2C_CR2,#1
4392                     ; 188     *data++ = I2C_DR;
4394  03ca 1e05          	ldw	x,(OFST+5,sp)
4395  03cc 1c0001        	addw	x,#1
4396  03cf 1f05          	ldw	(OFST+5,sp),x
4397  03d1 1d0001        	subw	x,#1
4398  03d4 c65216        	ld	a,_I2C_DR
4399  03d7 f7            	ld	(x),a
4400                     ; 190     _asm ("RIM");  //on interupts;
4403  03d8 9a            RIM
4405                     ; 191     *data = I2C_DR;
4407  03d9 1e05          	ldw	x,(OFST+5,sp)
4408  03db c65216        	ld	a,_I2C_DR
4409  03de f7            	ld	(x),a
4411  03df ac830483      	jpf	L5072
4412  03e3               L7162:
4413                     ; 194   else if(length > 2){
4415  03e3 7b07          	ld	a,(OFST+7,sp)
4416  03e5 a103          	cp	a,#3
4417  03e7 2403          	jruge	L47
4418  03e9 cc0483        	jp	L5072
4419  03ec               L47:
4421  03ec               L3462:
4422                     ; 197     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
4424  03ec c65217        	ld	a,_I2C_SR1
4425  03ef a502          	bcp	a,#2
4426  03f1 27f9          	jreq	L3462
4427                     ; 199     _asm ("SIM");  //on interupts;
4430  03f3 9b            SIM
4432                     ; 202     I2C_SR3;
4434  03f4 c65219        	ld	a,_I2C_SR3
4435                     ; 205     _asm ("RIM");  //on interupts;
4438  03f7 9a            RIM
4441  03f8 2015          	jra	L1562
4442  03fa               L7562:
4443                     ; 210       while((I2C_SR1 & I2C_SR1_BTF) == 0);
4445  03fa c65217        	ld	a,_I2C_SR1
4446  03fd a504          	bcp	a,#4
4447  03ff 27f9          	jreq	L7562
4448                     ; 212       *data++ = I2C_DR;
4450  0401 1e05          	ldw	x,(OFST+5,sp)
4451  0403 1c0001        	addw	x,#1
4452  0406 1f05          	ldw	(OFST+5,sp),x
4453  0408 1d0001        	subw	x,#1
4454  040b c65216        	ld	a,_I2C_DR
4455  040e f7            	ld	(x),a
4456  040f               L1562:
4457                     ; 207     while(length-- > 3 && tmo){
4459  040f 7b07          	ld	a,(OFST+7,sp)
4460  0411 0a07          	dec	(OFST+7,sp)
4461  0413 a104          	cp	a,#4
4462  0415 2513          	jrult	L3662
4464  0417 ae001d        	ldw	x,#L7241_i2c_timeout
4465  041a cd0000        	call	c_ltor
4467  041d ae001d        	ldw	x,#L7241_i2c_timeout
4468  0420 a601          	ld	a,#1
4469  0422 cd0000        	call	c_lgsbc
4471  0425 cd0000        	call	c_lrzmp
4473  0428 26d0          	jrne	L7562
4474  042a               L3662:
4475                     ; 215     if(!tmo) return I2C_TIMEOUT;
4477  042a ae001d        	ldw	x,#L7241_i2c_timeout
4478  042d cd0000        	call	c_ltor
4480  0430 ae001d        	ldw	x,#L7241_i2c_timeout
4481  0433 a601          	ld	a,#1
4482  0435 cd0000        	call	c_lgsbc
4484  0438 cd0000        	call	c_lrzmp
4486  043b 2604          	jrne	L1762
4489  043d a601          	ld	a,#1
4491  043f 204e          	jra	L27
4492  0441               L1762:
4493                     ; 221     while((I2C_SR1 & I2C_SR1_BTF) == 0);
4495  0441 c65217        	ld	a,_I2C_SR1
4496  0444 a504          	bcp	a,#4
4497  0446 27f9          	jreq	L1762
4498                     ; 223     I2C_CR2 &= ~I2C_CR2_ACK;
4500  0448 72155211      	bres	_I2C_CR2,#2
4501                     ; 225     _asm ("SIM");  //on interupts;
4504  044c 9b            SIM
4506                     ; 228     *data++ = I2C_DR;
4508  044d 1e05          	ldw	x,(OFST+5,sp)
4509  044f 1c0001        	addw	x,#1
4510  0452 1f05          	ldw	(OFST+5,sp),x
4511  0454 1d0001        	subw	x,#1
4512  0457 c65216        	ld	a,_I2C_DR
4513  045a f7            	ld	(x),a
4514                     ; 230     I2C_CR2 |= I2C_CR2_STOP;
4516  045b 72125211      	bset	_I2C_CR2,#1
4517                     ; 232     *data++ = I2C_DR;
4519  045f 1e05          	ldw	x,(OFST+5,sp)
4520  0461 1c0001        	addw	x,#1
4521  0464 1f05          	ldw	(OFST+5,sp),x
4522  0466 1d0001        	subw	x,#1
4523  0469 c65216        	ld	a,_I2C_DR
4524  046c f7            	ld	(x),a
4525                     ; 234     _asm ("RIM");  //on interupts;
4528  046d 9a            RIM
4531  046e               L7762:
4532                     ; 237     while((I2C_SR1 & I2C_SR1_RXNE) == 0);
4534  046e c65217        	ld	a,_I2C_SR1
4535  0471 a540          	bcp	a,#64
4536  0473 27f9          	jreq	L7762
4537                     ; 239     *data++ = I2C_DR;
4539  0475 1e05          	ldw	x,(OFST+5,sp)
4540  0477 1c0001        	addw	x,#1
4541  047a 1f05          	ldw	(OFST+5,sp),x
4542  047c 1d0001        	subw	x,#1
4543  047f c65216        	ld	a,_I2C_DR
4544  0482 f7            	ld	(x),a
4545  0483               L5072:
4546                     ; 244   while((I2C_CR2 & I2C_CR2_STOP) == 0);
4548  0483 c65211        	ld	a,_I2C_CR2
4549  0486 a502          	bcp	a,#2
4550  0488 27f9          	jreq	L5072
4551                     ; 246   I2C_CR2 &= ~I2C_CR2_POS;
4553  048a 72175211      	bres	_I2C_CR2,#3
4554                     ; 248   return I2C_SUCCESS;
4556  048e 4f            	clr	a
4558  048f               L27:
4560  048f 85            	popw	x
4561  0490 81            	ret
4584                     ; 254 void i2c_init(void)
4584                     ; 255  {
4585                     	switch	.text
4586  0491               _i2c_init:
4590                     ; 256  }
4593  0491 81            	ret
4627                     ; 257 void i2c_start(uint8_t rorw, uint8_t start_adr, uint8_t end_adr)        // OK
4627                     ; 258  {
4628                     	switch	.text
4629  0492               _i2c_start:
4633                     ; 259  }      //вроде норм
4636  0492 81            	ret
4659                     ; 260 void i2c_send_adress(void)      //   OK
4659                     ; 261  {
4660                     	switch	.text
4661  0493               _i2c_send_adress:
4665                     ; 262  }      //OK
4668  0493 81            	ret
4691                     ; 263 void i2c_send_data()
4691                     ; 264  {
4692                     	switch	.text
4693  0494               _i2c_send_data:
4697                     ; 265  }
4700  0494 81            	ret
4742                     ; 1 void spi_setup(void)
4742                     ; 2  {
4743                     	switch	.text
4744  0495               _spi_setup:
4748                     ; 3     SPI_CR1=0x7C;       //ну тип вот
4750  0495 357c5200      	mov	_SPI_CR1,#124
4751                     ; 4 		SPI_ICR = 0x80;
4753  0499 35805202      	mov	_SPI_ICR,#128
4754                     ; 6  }
4757  049d 81            	ret
4783                     ; 7 void SPI_Send1 (void)   //отправка первого байта SPI
4783                     ; 8 {
4784                     	switch	.text
4785  049e               _SPI_Send1:
4789                     ; 9   SPI_DR = deshifr_code_out;
4791  049e 55001c5204    	mov	_SPI_DR,_deshifr_code_out
4792                     ; 10   spi_queue++;
4794  04a3 3c0c          	inc	_spi_queue
4795                     ; 11 }	
4798  04a5 81            	ret
4824                     ; 13 void SPI_Send2 (void)   //отправка второго байта
4824                     ; 14 {
4825                     	switch	.text
4826  04a6               _SPI_Send2:
4830                     ; 15   SPI_DR=lamp_number_out;
4832  04a6 55001b5204    	mov	_SPI_DR,_lamp_number_out
4833                     ; 16   spi_queue = 1;
4835  04ab 3501000c      	mov	_spi_queue,#1
4836                     ; 17 }
4839  04af 81            	ret
4874                     ; 19 void SPI_Send(uint8_t msg)
4874                     ; 20 {
4875                     	switch	.text
4876  04b0               _SPI_Send:
4880                     ; 21 	SPI_DR = msg;
4882  04b0 c75204        	ld	_SPI_DR,a
4883                     ; 22 }
4886  04b3 81            	ret
4928                     ; 4 void UART_Resieved (void)
4928                     ; 5 {
4929                     	switch	.text
4930  04b4               _UART_Resieved:
4934                     ; 6 	UART_Send(UART1_DR);
4936  04b4 c65231        	ld	a,_UART1_DR
4937  04b7 cd0019        	call	_UART_Send
4939                     ; 7 }
4942  04ba 81            	ret
4967                     ; 9 void SPI_Transmitted(void)
4967                     ; 10 {
4968                     	switch	.text
4969  04bb               _SPI_Transmitted:
4973                     ; 11 	SPI_Send(temp);
4975  04bb b60b          	ld	a,_temp
4976  04bd adf1          	call	_SPI_Send
4978                     ; 12 }
4981  04bf 81            	ret
5008                     ; 14 void I2C_Event(void)
5008                     ; 15 {
5009                     	switch	.text
5010  04c0               _I2C_Event:
5014                     ; 16 	temp = I2C_SR1;
5016  04c0 555217000b    	mov	_temp,_I2C_SR1
5017                     ; 17 	if ((I2C_SR1 & I2C_SR1_SB) == I2C_SR1_SB)
5019  04c5 c65217        	ld	a,_I2C_SR1
5020  04c8 a401          	and	a,#1
5021  04ca a101          	cp	a,#1
5022  04cc 2604          	jrne	L1703
5023                     ; 19 				i2c_send_adress();
5025  04ce adc3          	call	_i2c_send_adress
5028  04d0 200d          	jra	L3703
5029  04d2               L1703:
5030                     ; 21 			else if ((I2C_SR1 & I2C_SR1_ADDR) == I2C_SR1_ADDR)
5032  04d2 c65217        	ld	a,_I2C_SR1
5033  04d5 a402          	and	a,#2
5034  04d7 a102          	cp	a,#2
5035  04d9 2602          	jrne	L5703
5036                     ; 23 				i2c_send_data;
5039  04db 2002          	jra	L3703
5040  04dd               L5703:
5041                     ; 25 			else i2c_send_data();
5043  04dd adb5          	call	_i2c_send_data
5045  04df               L3703:
5046                     ; 26 }
5049  04df 81            	ret
5075                     ; 28 void Keys_switched(void)
5075                     ; 29 {
5076                     	switch	.text
5077  04e0               _Keys_switched:
5081                     ; 30 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
5083  04e0 c650a0        	ld	a,_EXTI_CR1
5084  04e3 43            	cpl	a
5085  04e4 a430          	and	a,#48
5086  04e6 c750a0        	ld	_EXTI_CR1,a
5087                     ; 31 	PC_CR2 = 0;
5089  04e9 725f500e      	clr	_PC_CR2
5090                     ; 32 	timer2_start(0xff);
5092  04ed ae00ff        	ldw	x,#255
5093  04f0 cd0077        	call	_timer2_start
5095                     ; 77 }
5098  04f3 81            	ret
5121                     ; 79 void DS_interrupt (void)
5121                     ; 80 {
5122                     	switch	.text
5123  04f4               _DS_interrupt:
5127                     ; 82 }
5130  04f4 81            	ret
5195                     ; 26 int main( void )
5195                     ; 27 {
5196                     	switch	.text
5197  04f5               _main:
5201                     ; 30 	CLK_CKDIVR=0;                //нет делителей
5203  04f5 725f50c6      	clr	_CLK_CKDIVR
5204                     ; 31   CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //тактирование на TIM1, UART1, SPI i I2C
5206  04f9 35ff50c7      	mov	_CLK_PCKENR1,#255
5207                     ; 33 	_asm ("SIM"); // off interrupts
5210  04fd 9b            SIM
5212                     ; 34 	EXTI_CR1 = 0x10; //(2<<EXTI_CR1_PCIS);
5214  04fe 351050a0      	mov	_EXTI_CR1,#16
5215                     ; 38     PA_DDR=0x08; //0b000001000; //выход на защелку регистров, вход на сигнал с ртс
5217  0502 35085002      	mov	_PA_DDR,#8
5218                     ; 39     PA_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
5220  0506 35ff5003      	mov	_PA_CR1,#255
5221                     ; 46     PC_DDR=0x60; //0b01100000; //SPI на выход, кнопочки на вход
5223  050a 3560500c      	mov	_PC_DDR,#96
5224                     ; 47     PC_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
5226  050e 35ff500d      	mov	_PC_CR1,#255
5227                     ; 49     PC_CR2 |= (1<<4) | (1<<3);        //есть прерывания
5229  0512 c6500e        	ld	a,_PC_CR2
5230  0515 aa18          	or	a,#24
5231  0517 c7500e        	ld	_PC_CR2,a
5232                     ; 51 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM на вход
5234  051a 35a85011      	mov	_PD_DDR,#168
5235                     ; 52     PD_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
5237  051e 35ff5012      	mov	_PD_CR1,#255
5238                     ; 53     PD_ODR = (1 << 3);
5240  0522 3508500f      	mov	_PD_ODR,#8
5241                     ; 59 	i2c_master_init(16000000, 100000);
5243  0526 ae86a0        	ldw	x,#34464
5244  0529 89            	pushw	x
5245  052a ae0001        	ldw	x,#1
5246  052d 89            	pushw	x
5247  052e ae2400        	ldw	x,#9216
5248  0531 89            	pushw	x
5249  0532 ae00f4        	ldw	x,#244
5250  0535 89            	pushw	x
5251  0536 cd0242        	call	_i2c_master_init
5253  0539 5b08          	addw	sp,#8
5254                     ; 64 		uart_setup();
5256  053b cd0000        	call	_uart_setup
5258                     ; 65 		UART_Send('h');
5260  053e a668          	ld	a,#104
5261  0540 cd0019        	call	_UART_Send
5263                     ; 66     timer1_setup( 65500,0xffff);//частота в гц и топ значение
5265  0543 aeffff        	ldw	x,#65535
5266  0546 89            	pushw	x
5267  0547 aeffdc        	ldw	x,#65500
5268  054a cd0141        	call	_timer1_setup
5270  054d 85            	popw	x
5271                     ; 67 		timer2_setup();
5273  054e cd01ac        	call	_timer2_setup
5275                     ; 71 		timer1_start();
5277  0551 cd013c        	call	_timer1_start
5279                     ; 73 		temp = 10;
5281  0554 350a000b      	mov	_temp,#10
5282                     ; 74 		SPI_DR = temp;
5284  0558 55000b5204    	mov	_SPI_DR,_temp
5285                     ; 75 		i2c_rd_reg(0xD0, 0, time_pointer, 1);
5287  055d 4b01          	push	#1
5288  055f be06          	ldw	x,_time_pointer
5289  0561 89            	pushw	x
5290  0562 aed000        	ldw	x,#53248
5291  0565 cd0323        	call	_i2c_rd_reg
5293  0568 5b03          	addw	sp,#3
5294                     ; 78 	if((seconds & 0x80) == 0x80)
5296  056a b615          	ld	a,_seconds
5297  056c a480          	and	a,#128
5298  056e a180          	cp	a,#128
5299  0570 2610          	jrne	L7313
5300                     ; 80 		seconds = 0;
5302  0572 3f15          	clr	_seconds
5303                     ; 81 		i2c_wr_reg(ds_address, 0,time_pointer, 1);
5305  0574 4b01          	push	#1
5306  0576 be06          	ldw	x,_time_pointer
5307  0578 89            	pushw	x
5308  0579 5f            	clrw	x
5309  057a b608          	ld	a,_ds_address
5310  057c 95            	ld	xh,a
5311  057d cd02c0        	call	_i2c_wr_reg
5313  0580 5b03          	addw	sp,#3
5314  0582               L7313:
5315                     ; 83 		i2c_rd_reg(0xD0, 0, time_pointer, 1); 	
5317  0582 4b01          	push	#1
5318  0584 be06          	ldw	x,_time_pointer
5319  0586 89            	pushw	x
5320  0587 aed000        	ldw	x,#53248
5321  058a cd0323        	call	_i2c_rd_reg
5323  058d 5b03          	addw	sp,#3
5324                     ; 84 			UART_Send(seconds);
5326  058f b615          	ld	a,_seconds
5327  0591 cd0019        	call	_UART_Send
5329                     ; 86  _asm ("RIM");  //on interupts
5332  0594 9a            RIM
5334  0595               L1413:
5335                     ; 87 while(1);
5337  0595 20fe          	jra	L1413
5350                     	xdef	_main
5351                     	xdef	_DS_interrupt
5352                     	xdef	_Keys_switched
5353                     	xdef	_I2C_Event
5354                     	xdef	_SPI_Transmitted
5355                     	xdef	_UART_Resieved
5356                     	xdef	_SPI_Send
5357                     	xdef	_SPI_Send2
5358                     	xdef	_SPI_Send1
5359                     	xdef	_spi_setup
5360                     	xdef	_i2c_send_data
5361                     	xdef	_i2c_send_adress
5362                     	xdef	_i2c_init
5363                     	xdef	_i2c_rd_reg
5364                     	xdef	_i2c_wr_reg
5365                     	xdef	_i2c_master_init
5366                     	xdef	_display
5367                     	xdef	_time_recalculation
5368                     	xdef	_Key_interrupt
5369                     	xdef	_timer2_setup
5370                     	xdef	_timer1_setup
5371                     	xdef	_timer1_start
5372                     	xdef	_Timer1_Compare_1
5373                     	xdef	_Timer2_Overflow
5374                     	xdef	_timer2_start
5375                     	xdef	_i2c_start
5376                     	xdef	_Two_keys_pressed
5377                     	xdef	_Inc_key_pressed
5378                     	xdef	_Menu_key_pressed
5379                     	xdef	_UART_Send
5380                     	xdef	_uart_setup
5381                     	switch	.ubsct
5382  0000               _i2c_flags:
5383  0000 00            	ds.b	1
5384                     	xdef	_i2c_flags
5385  0001               _flags:
5386  0001 00            	ds.b	1
5387                     	xdef	_flags
5388  0002               _cell_address:
5389  0002 00            	ds.b	1
5390                     	xdef	_cell_address
5391  0003               _data_type:
5392  0003 00            	ds.b	1
5393                     	xdef	_data_type
5394  0004               _i2c_current_adr:
5395  0004 00            	ds.b	1
5396                     	xdef	_i2c_current_adr
5397  0005               _i2c_end_adr:
5398  0005 00            	ds.b	1
5399                     	xdef	_i2c_end_adr
5400  0006               _i2c_start_adr:
5401  0006 00            	ds.b	1
5402                     	xdef	_i2c_start_adr
5403                     	xdef	_ds_address
5404  0007               _tunning:
5405  0007 00            	ds.b	1
5406                     	xdef	_tunning
5407  0008               _two_keys:
5408  0008 00            	ds.b	1
5409                     	xdef	_two_keys
5410  0009               _tunning_digits:
5411  0009 00            	ds.b	1
5412                     	xdef	_tunning_digits
5413  000a               _temp2:
5414  000a 00            	ds.b	1
5415                     	xdef	_temp2
5416  000b               _temp:
5417  000b 00            	ds.b	1
5418                     	xdef	_temp
5419  000c               _spi_queue:
5420  000c 00            	ds.b	1
5421                     	xdef	_spi_queue
5422  000d               _pins:
5423  000d 00            	ds.b	1
5424                     	xdef	_pins
5425  000e               _data_pointer:
5426  000e 0000          	ds.b	2
5427                     	xdef	_data_pointer
5428                     	xdef	_time_pointer
5429  0010               _hours_decades:
5430  0010 00            	ds.b	1
5431                     	xdef	_hours_decades
5432  0011               _hours:
5433  0011 00            	ds.b	1
5434                     	xdef	_hours
5435  0012               _minutes_decades:
5436  0012 00            	ds.b	1
5437                     	xdef	_minutes_decades
5438  0013               _minutes:
5439  0013 00            	ds.b	1
5440                     	xdef	_minutes
5441  0014               _seconds_decades:
5442  0014 00            	ds.b	1
5443                     	xdef	_seconds_decades
5444  0015               _seconds:
5445  0015 00            	ds.b	1
5446                     	xdef	_seconds
5447  0016               _fresh_hours:
5448  0016 00            	ds.b	1
5449                     	xdef	_fresh_hours
5450  0017               _fresh_min:
5451  0017 00            	ds.b	1
5452                     	xdef	_fresh_min
5453  0018               _fresh_sec:
5454  0018 00            	ds.b	1
5455                     	xdef	_fresh_sec
5456  0019               _ds_tacts:
5457  0019 0000          	ds.b	2
5458                     	xdef	_ds_tacts
5459  001b               _lamp_number_out:
5460  001b 00            	ds.b	1
5461                     	xdef	_lamp_number_out
5462  001c               _deshifr_code_out:
5463  001c 00            	ds.b	1
5464                     	xdef	_deshifr_code_out
5465                     	xdef	_dots
5466                     	xdef	_lamp4_digit
5467                     	xdef	_lamp3_digit
5468                     	xdef	_lamp2_digit
5469                     	xdef	_lamp1_digit
5470                     	xdef	_lamp_number
5471  001d               L7241_i2c_timeout:
5472  001d 00000000      	ds.b	4
5473                     	xref.b	c_lreg
5474                     	xref.b	c_x
5494                     	xref	c_lrzmp
5495                     	xref	c_lgsbc
5496                     	xref	c_ludv
5497                     	xref	c_ltor
5498                     	xref	c_lrsh
5499                     	xref	c_ldiv
5500                     	xref	c_rtol
5501                     	xref	c_uitolx
5502                     	end
