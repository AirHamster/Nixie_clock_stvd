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
3297  0137 cd056f        	call	_i2c_start
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
3955                     ; 47   I2C_CR2 |=I2C_CR2_ACK;
3957  02b9 72145211      	bset	_I2C_CR2,#2
3958                     ; 48 }
3961  02bd 5b08          	addw	sp,#8
3962  02bf 81            	ret
4056                     ; 54 t_i2c_status i2c_wr_reg(unsigned char address, unsigned char reg_addr,
4056                     ; 55                               char * data, unsigned char length)
4056                     ; 56 {                                  
4057                     	switch	.text
4058  02c0               _i2c_wr_reg:
4060  02c0 89            	pushw	x
4061       00000000      OFST:	set	0
4064                     ; 59   wait_event(I2C_SR3_BUSY, 10);
4066  02c1 ae7100        	ldw	x,#28928
4067  02c4 bf1f          	ldw	L7241_i2c_timeout+2,x
4068  02c6 ae0000        	ldw	x,#0
4069  02c9 bf1d          	ldw	L7241_i2c_timeout,x
4070  02cb               L7042:
4074  02cb ae001d        	ldw	x,#L7241_i2c_timeout
4075  02ce cd0000        	call	c_lzmp
4077  02d1 26f8          	jrne	L7042
4080  02d3 ae001d        	ldw	x,#L7241_i2c_timeout
4081  02d6 cd0000        	call	c_lzmp
4083  02d9 2603          	jrne	L5142
4086  02db 4f            	clr	a
4088  02dc 2017          	jra	L07
4089  02de               L5142:
4090                     ; 62   I2C_CR2 |= I2C_CR2_START;
4093  02de 72105211      	bset	_I2C_CR2,#0
4094                     ; 64   wait_event(!I2C_SR1_SB, 1);
4097  02e2 ae3e80        	ldw	x,#16000
4098  02e5 bf1f          	ldw	L7241_i2c_timeout+2,x
4099  02e7 ae0000        	ldw	x,#0
4100  02ea bf1d          	ldw	L7241_i2c_timeout,x
4103  02ec ae001d        	ldw	x,#L7241_i2c_timeout
4104  02ef cd0000        	call	c_lzmp
4106  02f2 2603          	jrne	L7142
4109  02f4 4f            	clr	a
4111  02f5               L07:
4113  02f5 85            	popw	x
4114  02f6 81            	ret
4115  02f7               L7142:
4116                     ; 68   I2C_DR = address & 0xFE;
4119  02f7 7b01          	ld	a,(OFST+1,sp)
4120  02f9 a4fe          	and	a,#254
4121  02fb c75216        	ld	_I2C_DR,a
4122                     ; 70   wait_event(!I2C_SR1_ADDR, 1);
4125  02fe ae3e80        	ldw	x,#16000
4126  0301 bf1f          	ldw	L7241_i2c_timeout+2,x
4127  0303 ae0000        	ldw	x,#0
4128  0306 bf1d          	ldw	L7241_i2c_timeout,x
4131  0308 ae001d        	ldw	x,#L7241_i2c_timeout
4132  030b cd0000        	call	c_lzmp
4134  030e 2603          	jrne	L1242
4137  0310 4f            	clr	a
4139  0311 20e2          	jra	L07
4140  0313               L1242:
4141                     ; 72   I2C_SR3;
4144  0313 c65219        	ld	a,_I2C_SR3
4145                     ; 76   wait_event(!I2C_SR1_TXE, 1);
4148  0316 ae3e80        	ldw	x,#16000
4149  0319 bf1f          	ldw	L7241_i2c_timeout+2,x
4150  031b ae0000        	ldw	x,#0
4151  031e bf1d          	ldw	L7241_i2c_timeout,x
4154  0320 ae001d        	ldw	x,#L7241_i2c_timeout
4155  0323 cd0000        	call	c_lzmp
4157  0326 2603          	jrne	L3242
4160  0328 4f            	clr	a
4162  0329 20ca          	jra	L07
4163  032b               L3242:
4164                     ; 78   I2C_DR = reg_addr;
4167  032b 7b02          	ld	a,(OFST+2,sp)
4168  032d c75216        	ld	_I2C_DR,a
4170  0330 2023          	jra	L1342
4171  0332               L5242:
4172                     ; 83     wait_event(!I2C_SR1_TXE, 1);
4175  0332 ae3e80        	ldw	x,#16000
4176  0335 bf1f          	ldw	L7241_i2c_timeout+2,x
4177  0337 ae0000        	ldw	x,#0
4178  033a bf1d          	ldw	L7241_i2c_timeout,x
4181  033c ae001d        	ldw	x,#L7241_i2c_timeout
4182  033f cd0000        	call	c_lzmp
4184  0342 2603          	jrne	L5342
4187  0344 4f            	clr	a
4189  0345 20ae          	jra	L07
4190  0347               L5342:
4191                     ; 85     I2C_DR = *data++;
4194  0347 1e05          	ldw	x,(OFST+5,sp)
4195  0349 1c0001        	addw	x,#1
4196  034c 1f05          	ldw	(OFST+5,sp),x
4197  034e 1d0001        	subw	x,#1
4198  0351 f6            	ld	a,(x)
4199  0352 c75216        	ld	_I2C_DR,a
4200  0355               L1342:
4201                     ; 81   while(length--){
4203  0355 7b07          	ld	a,(OFST+7,sp)
4204  0357 0a07          	dec	(OFST+7,sp)
4205  0359 4d            	tnz	a
4206  035a 26d6          	jrne	L5242
4207                     ; 89   wait_event(!(I2C_SR1_TXE && I2C_SR1_BTF), 1);
4210  035c ae3e80        	ldw	x,#16000
4211  035f bf1f          	ldw	L7241_i2c_timeout+2,x
4212  0361 ae0000        	ldw	x,#0
4213  0364 bf1d          	ldw	L7241_i2c_timeout,x
4216  0366 ae001d        	ldw	x,#L7241_i2c_timeout
4217  0369 cd0000        	call	c_lzmp
4219  036c 2603          	jrne	L7342
4222  036e 4f            	clr	a
4224  036f 201f          	jra	L27
4225  0371               L7342:
4226                     ; 92   I2C_CR2 |= I2C_CR2_STOP;
4229  0371 72125211      	bset	_I2C_CR2,#1
4230                     ; 94   wait_event(I2C_CR2_STOP, 1);
4232  0375 ae3e80        	ldw	x,#16000
4233  0378 bf1f          	ldw	L7241_i2c_timeout+2,x
4234  037a ae0000        	ldw	x,#0
4235  037d bf1d          	ldw	L7241_i2c_timeout,x
4236  037f               L1442:
4240  037f ae001d        	ldw	x,#L7241_i2c_timeout
4241  0382 cd0000        	call	c_lzmp
4243  0385 26f8          	jrne	L1442
4246  0387 ae001d        	ldw	x,#L7241_i2c_timeout
4247  038a cd0000        	call	c_lzmp
4249  038d 2603          	jrne	L7442
4252  038f 4f            	clr	a
4254  0390               L27:
4256  0390 85            	popw	x
4257  0391 81            	ret
4258  0392               L7442:
4259                     ; 96   return I2C_SUCCESS;
4262  0392 4f            	clr	a
4264  0393 20fb          	jra	L27
4335                     ; 103 t_i2c_status i2c_rd_reg(unsigned char address, unsigned char reg_addr,
4335                     ; 104                               char * data, unsigned char length)
4335                     ; 105 {
4336                     	switch	.text
4337  0395               _i2c_rd_reg:
4339  0395 89            	pushw	x
4340       00000000      OFST:	set	0
4343  0396               L5052:
4344                     ; 109   while((I2C_SR3 & I2C_SR3_BUSY) != 0);   
4346  0396 c65219        	ld	a,_I2C_SR3
4347  0399 a502          	bcp	a,#2
4348  039b 26f9          	jrne	L5052
4349                     ; 111   I2C_CR2 |= I2C_CR2_ACK;
4351  039d 72145211      	bset	_I2C_CR2,#2
4352                     ; 114   I2C_CR2 |= I2C_CR2_START;
4354  03a1 72105211      	bset	_I2C_CR2,#0
4356  03a5               L3152:
4357                     ; 117   while((I2C_SR1 & I2C_SR1_SB) == 0);  
4359  03a5 c65217        	ld	a,_I2C_SR1
4360  03a8 a501          	bcp	a,#1
4361  03aa 27f9          	jreq	L3152
4362                     ; 119   I2C_DR = address & 0xFE;
4364  03ac 7b01          	ld	a,(OFST+1,sp)
4365  03ae a4fe          	and	a,#254
4366  03b0 c75216        	ld	_I2C_DR,a
4368  03b3               L3252:
4369                     ; 122   while((I2C_SR1 & I2C_SR1_ADDR) == 0);
4371  03b3 c65217        	ld	a,_I2C_SR1
4372  03b6 a502          	bcp	a,#2
4373  03b8 27f9          	jreq	L3252
4374                     ; 124   temp = I2C_SR3;
4376  03ba 555219000b    	mov	_temp,_I2C_SR3
4378  03bf               L3352:
4379                     ; 128   while((I2C_SR1 & I2C_SR1) == 0); 
4381  03bf c65217        	ld	a,_I2C_SR1
4382  03c2 5f            	clrw	x
4383  03c3 97            	ld	xl,a
4384  03c4 a30000        	cpw	x,#0
4385  03c7 27f6          	jreq	L3352
4386                     ; 130   I2C_DR = reg_addr;
4388  03c9 7b02          	ld	a,(OFST+2,sp)
4389  03cb c75216        	ld	_I2C_DR,a
4391  03ce               L3452:
4392                     ; 133   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
4394  03ce c65217        	ld	a,_I2C_SR1
4395  03d1 a584          	bcp	a,#132
4396  03d3 27f9          	jreq	L3452
4397                     ; 135   I2C_CR2 |= I2C_CR2_START;
4399  03d5 72105211      	bset	_I2C_CR2,#0
4401  03d9               L1552:
4402                     ; 138   while((I2C_SR1 & I2C_SR1_SB) == 0); 
4404  03d9 c65217        	ld	a,_I2C_SR1
4405  03dc a501          	bcp	a,#1
4406  03de 27f9          	jreq	L1552
4407                     ; 141   I2C_DR = address | 0x01;
4409  03e0 7b01          	ld	a,(OFST+1,sp)
4410  03e2 aa01          	or	a,#1
4411  03e4 c75216        	ld	_I2C_DR,a
4412                     ; 145   if(length == 1){
4414  03e7 7b07          	ld	a,(OFST+7,sp)
4415  03e9 a101          	cp	a,#1
4416  03eb 2627          	jrne	L5552
4417                     ; 147     I2C_CR2 |= I2C_CR2_ACK;
4419  03ed 72145211      	bset	_I2C_CR2,#2
4421  03f1               L1652:
4422                     ; 150     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
4424  03f1 c65217        	ld	a,_I2C_SR1
4425  03f4 a502          	bcp	a,#2
4426  03f6 27f9          	jreq	L1652
4427                     ; 152     _asm ("SIM");  //on interupts
4430  03f8 9b            SIM
4432                     ; 154     temp = I2C_SR3;
4434  03f9 555219000b    	mov	_temp,_I2C_SR3
4435                     ; 157     I2C_CR2 |= I2C_CR2_STOP;
4437  03fe 72125211      	bset	_I2C_CR2,#1
4438                     ; 159     _asm ("RIM");  //on interupts;
4441  0402 9a            RIM
4444  0403               L7652:
4445                     ; 163     while((I2C_SR1 & I2C_SR1_RXNE) == 0); 
4447  0403 c65217        	ld	a,_I2C_SR1
4448  0406 a540          	bcp	a,#64
4449  0408 27f9          	jreq	L7652
4450                     ; 165     *data = I2C_DR;
4452  040a 1e05          	ldw	x,(OFST+5,sp)
4453  040c c65216        	ld	a,_I2C_DR
4454  040f f7            	ld	(x),a
4456  0410 ac470547      	jpf	L3362
4457  0414               L5552:
4458                     ; 168   else if(length == 2){
4460  0414 7b07          	ld	a,(OFST+7,sp)
4461  0416 a102          	cp	a,#2
4462  0418 2655          	jrne	L5752
4463                     ; 170     I2C_CR2 |= I2C_CR2_POS;
4465  041a 72165211      	bset	_I2C_CR2,#3
4466                     ; 172     wait_event(!I2C_SR1_ADDR, 1);
4469  041e ae3e80        	ldw	x,#16000
4470  0421 bf1f          	ldw	L7241_i2c_timeout+2,x
4471  0423 ae0000        	ldw	x,#0
4472  0426 bf1d          	ldw	L7241_i2c_timeout,x
4475  0428 ae001d        	ldw	x,#L7241_i2c_timeout
4476  042b cd0000        	call	c_lzmp
4478  042e 2603          	jrne	L7752
4481  0430 4f            	clr	a
4483  0431 201c          	jra	L67
4484  0433               L7752:
4485                     ; 174     _asm ("SIM");  //on interupts;
4489  0433 9b            SIM
4491                     ; 176     I2C_SR3;
4493  0434 c65219        	ld	a,_I2C_SR3
4494                     ; 178     I2C_CR2 &= ~I2C_CR2_ACK;
4496  0437 72155211      	bres	_I2C_CR2,#2
4497                     ; 180     _asm ("RIM");  //on interupts;
4500  043b 9a            RIM
4502                     ; 183     wait_event(!I2C_SR1_BTF, 1);
4505  043c ae3e80        	ldw	x,#16000
4506  043f bf1f          	ldw	L7241_i2c_timeout+2,x
4507  0441 ae0000        	ldw	x,#0
4508  0444 bf1d          	ldw	L7241_i2c_timeout,x
4511  0446 ae001d        	ldw	x,#L7241_i2c_timeout
4512  0449 cd0000        	call	c_lzmp
4514  044c 2603          	jrne	L1062
4517  044e 4f            	clr	a
4519  044f               L67:
4521  044f 85            	popw	x
4522  0450 81            	ret
4523  0451               L1062:
4524                     ; 186     _asm ("SIM");  //on interupts;
4528  0451 9b            SIM
4530                     ; 188     I2C_CR2 |= I2C_CR2_STOP;
4532  0452 72125211      	bset	_I2C_CR2,#1
4533                     ; 190     *data++ = I2C_DR;
4535  0456 1e05          	ldw	x,(OFST+5,sp)
4536  0458 1c0001        	addw	x,#1
4537  045b 1f05          	ldw	(OFST+5,sp),x
4538  045d 1d0001        	subw	x,#1
4539  0460 c65216        	ld	a,_I2C_DR
4540  0463 f7            	ld	(x),a
4541                     ; 192     _asm ("RIM");  //on interupts;
4544  0464 9a            RIM
4546                     ; 193     *data = I2C_DR;
4548  0465 1e05          	ldw	x,(OFST+5,sp)
4549  0467 c65216        	ld	a,_I2C_DR
4550  046a f7            	ld	(x),a
4552  046b ac470547      	jpf	L3362
4553  046f               L5752:
4554                     ; 196   else if(length > 2){
4556  046f 7b07          	ld	a,(OFST+7,sp)
4557  0471 a103          	cp	a,#3
4558  0473 2403          	jruge	L201
4559  0475 cc0547        	jp	L3362
4560  0478               L201:
4561                     ; 198     wait_event(!I2C_SR1_ADDR, 1);
4564  0478 ae3e80        	ldw	x,#16000
4565  047b bf1f          	ldw	L7241_i2c_timeout+2,x
4566  047d ae0000        	ldw	x,#0
4567  0480 bf1d          	ldw	L7241_i2c_timeout,x
4570  0482 ae001d        	ldw	x,#L7241_i2c_timeout
4571  0485 cd0000        	call	c_lzmp
4573  0488 2603          	jrne	L7062
4576  048a 4f            	clr	a
4578  048b 20c2          	jra	L67
4579  048d               L7062:
4580                     ; 201     _asm ("SIM");  //on interupts;
4584  048d 9b            SIM
4586                     ; 204     I2C_SR3;
4588  048e c65219        	ld	a,_I2C_SR3
4589                     ; 207     _asm ("RIM");  //on interupts;
4592  0491 9a            RIM
4595  0492 2023          	jra	L3162
4596  0494               L1162:
4597                     ; 211       wait_event(!I2C_SR1_BTF, 1);
4600  0494 ae3e80        	ldw	x,#16000
4601  0497 bf1f          	ldw	L7241_i2c_timeout+2,x
4602  0499 ae0000        	ldw	x,#0
4603  049c bf1d          	ldw	L7241_i2c_timeout,x
4606  049e ae001d        	ldw	x,#L7241_i2c_timeout
4607  04a1 cd0000        	call	c_lzmp
4609  04a4 2603          	jrne	L7162
4612  04a6 4f            	clr	a
4614  04a7 20a6          	jra	L67
4615  04a9               L7162:
4616                     ; 213       *data++ = I2C_DR;
4619  04a9 1e05          	ldw	x,(OFST+5,sp)
4620  04ab 1c0001        	addw	x,#1
4621  04ae 1f05          	ldw	(OFST+5,sp),x
4622  04b0 1d0001        	subw	x,#1
4623  04b3 c65216        	ld	a,_I2C_DR
4624  04b6 f7            	ld	(x),a
4625  04b7               L3162:
4626                     ; 209     while(length-- > 3 && tmo){
4628  04b7 7b07          	ld	a,(OFST+7,sp)
4629  04b9 0a07          	dec	(OFST+7,sp)
4630  04bb a104          	cp	a,#4
4631  04bd 2513          	jrult	L1262
4633  04bf ae001d        	ldw	x,#L7241_i2c_timeout
4634  04c2 cd0000        	call	c_ltor
4636  04c5 ae001d        	ldw	x,#L7241_i2c_timeout
4637  04c8 a601          	ld	a,#1
4638  04ca cd0000        	call	c_lgsbc
4640  04cd cd0000        	call	c_lrzmp
4642  04d0 26c2          	jrne	L1162
4643  04d2               L1262:
4644                     ; 216     if(!tmo) return I2C_TIMEOUT;
4646  04d2 ae001d        	ldw	x,#L7241_i2c_timeout
4647  04d5 cd0000        	call	c_ltor
4649  04d8 ae001d        	ldw	x,#L7241_i2c_timeout
4650  04db a601          	ld	a,#1
4651  04dd cd0000        	call	c_lgsbc
4653  04e0 cd0000        	call	c_lrzmp
4655  04e3 2604          	jrne	L3262
4658  04e5 a601          	ld	a,#1
4660  04e7 2013          	jra	L001
4661  04e9               L3262:
4662                     ; 221     wait_event(!I2C_SR1_BTF, 1);
4665  04e9 ae3e80        	ldw	x,#16000
4666  04ec bf1f          	ldw	L7241_i2c_timeout+2,x
4667  04ee ae0000        	ldw	x,#0
4668  04f1 bf1d          	ldw	L7241_i2c_timeout,x
4671  04f3 ae001d        	ldw	x,#L7241_i2c_timeout
4672  04f6 cd0000        	call	c_lzmp
4674  04f9 2603          	jrne	L5262
4677  04fb 4f            	clr	a
4679  04fc               L001:
4681  04fc 85            	popw	x
4682  04fd 81            	ret
4683  04fe               L5262:
4684                     ; 223     I2C_CR2 &= ~I2C_CR2_ACK;
4687  04fe 72155211      	bres	_I2C_CR2,#2
4688                     ; 225     _asm ("SIM");  //on interupts;
4691  0502 9b            SIM
4693                     ; 228     *data++ = I2C_DR;
4695  0503 1e05          	ldw	x,(OFST+5,sp)
4696  0505 1c0001        	addw	x,#1
4697  0508 1f05          	ldw	(OFST+5,sp),x
4698  050a 1d0001        	subw	x,#1
4699  050d c65216        	ld	a,_I2C_DR
4700  0510 f7            	ld	(x),a
4701                     ; 230     I2C_CR2 |= I2C_CR2_STOP;
4703  0511 72125211      	bset	_I2C_CR2,#1
4704                     ; 232     *data++ = I2C_DR;
4706  0515 1e05          	ldw	x,(OFST+5,sp)
4707  0517 1c0001        	addw	x,#1
4708  051a 1f05          	ldw	(OFST+5,sp),x
4709  051c 1d0001        	subw	x,#1
4710  051f c65216        	ld	a,_I2C_DR
4711  0522 f7            	ld	(x),a
4712                     ; 234     _asm ("RIM");  //on interupts;
4715  0523 9a            RIM
4717                     ; 236     wait_event(!I2C_SR1_RXNE, 1);
4720  0524 ae3e80        	ldw	x,#16000
4721  0527 bf1f          	ldw	L7241_i2c_timeout+2,x
4722  0529 ae0000        	ldw	x,#0
4723  052c bf1d          	ldw	L7241_i2c_timeout,x
4726  052e ae001d        	ldw	x,#L7241_i2c_timeout
4727  0531 cd0000        	call	c_lzmp
4729  0534 2603          	jrne	L7262
4732  0536 4f            	clr	a
4734  0537 20c3          	jra	L001
4735  0539               L7262:
4736                     ; 238     *data++ = I2C_DR;
4739  0539 1e05          	ldw	x,(OFST+5,sp)
4740  053b 1c0001        	addw	x,#1
4741  053e 1f05          	ldw	(OFST+5,sp),x
4742  0540 1d0001        	subw	x,#1
4743  0543 c65216        	ld	a,_I2C_DR
4744  0546 f7            	ld	(x),a
4745  0547               L3362:
4746                     ; 243   while((I2C_CR2 & I2C_CR2_STOP) == 0);
4748  0547 c65211        	ld	a,_I2C_CR2
4749  054a a502          	bcp	a,#2
4750  054c 27f9          	jreq	L3362
4751                     ; 245   I2C_CR2 &= ~I2C_CR2_POS;
4753  054e 72175211      	bres	_I2C_CR2,#3
4754                     ; 247   return I2C_SUCCESS;
4756  0552 4f            	clr	a
4758  0553 20a7          	jra	L001
4792                     ; 261 int sI2C_Send_data (unsigned char address, unsigned char data, unsigned char direction )
4792                     ; 262 {
4793                     	switch	.text
4794  0555               _sI2C_Send_data:
4798                     ; 264 }
4801  0555 81            	ret
4830                     ; 266 void i2c_init(void)
4830                     ; 267  {
4831                     	switch	.text
4832  0556               _i2c_init:
4836                     ; 268    I2C_FREQR =0x10;     //16MHz perif
4838  0556 35105212      	mov	_I2C_FREQR,#16
4839                     ; 269    I2C_ITR =0x07;
4841  055a 3507521a      	mov	_I2C_ITR,#7
4842                     ; 270    I2C_CCRL =0x50;      //100kHz i2c
4844  055e 3550521b      	mov	_I2C_CCRL,#80
4845                     ; 271    I2C_CCRH =0;
4847  0562 725f521c      	clr	_I2C_CCRH
4848                     ; 272    I2C_TRISER =0x11;
4850  0566 3511521d      	mov	_I2C_TRISER,#17
4851                     ; 273    I2C_CR1 |=I2C_CR1_PE;   //запуск и2с
4853  056a 72105210      	bset	_I2C_CR1,#0
4854                     ; 274  }
4857  056e 81            	ret
4914                     ; 276 void i2c_start(uint8_t rorw, uint8_t start_adr, uint8_t end_adr)        // OK
4914                     ; 277  {
4915                     	switch	.text
4916  056f               _i2c_start:
4918  056f 89            	pushw	x
4919       00000000      OFST:	set	0
4922                     ; 278    i2c_flags.status =busy;
4924  0570 72100000      	bset	_i2c_flags,#0
4925                     ; 279    i2c_flags.rw =rorw;
4927  0574 9e            	ld	a,xh
4928  0575 44            	srl	a
4929  0576 90130000      	bccm	_i2c_flags,#1
4930                     ; 280    i2c_start_adr =start_adr;
4932  057a 9f            	ld	a,xl
4933  057b b706          	ld	_i2c_start_adr,a
4934                     ; 281    i2c_end_adr =end_adr;
4936  057d 7b05          	ld	a,(OFST+5,sp)
4937  057f b705          	ld	_i2c_end_adr,a
4938                     ; 283    if ((rorw == 1) && (i2c_flags.first_send) !=1)
4940  0581 9e            	ld	a,xh
4941  0582 a101          	cp	a,#1
4942  0584 260d          	jrne	L3172
4944  0586 b600          	ld	a,_i2c_flags
4945  0588 a508          	bcp	a,#8
4946  058a 2607          	jrne	L3172
4947                     ; 285       i2c_flags.first_send =1;
4949  058c 72160000      	bset	_i2c_flags,#3
4950                     ; 286       i2c_current_adr =start_adr;
4952  0590 9f            	ld	a,xl
4953  0591 b704          	ld	_i2c_current_adr,a
4954  0593               L3172:
4955                     ; 289    I2C_CR2 |= I2C_CR2_START;
4957  0593 72105211      	bset	_I2C_CR2,#0
4958                     ; 290  }      //вроде норм
4961  0597 85            	popw	x
4962  0598 81            	ret
4988                     ; 294 void i2c_send_adress(void)      //   OK
4988                     ; 295  {
4989                     	switch	.text
4990  0599               _i2c_send_adress:
4994                     ; 296    if (i2c_flags.rw == read && i2c_flags.first_send ==1)
4996  0599 b600          	ld	a,_i2c_flags
4997  059b a502          	bcp	a,#2
4998  059d 2714          	jreq	L5272
5000  059f b600          	ld	a,_i2c_flags
5001  05a1 a508          	bcp	a,#8
5002  05a3 270e          	jreq	L5272
5003                     ; 297     {I2C_DR =ds_address || write;}
5005  05a5 3d08          	tnz	_ds_address
5006  05a7 2704          	jreq	L411
5007  05a9 a601          	ld	a,#1
5008  05ab 2001          	jra	L611
5009  05ad               L411:
5010  05ad 4f            	clr	a
5011  05ae               L611:
5012  05ae c75216        	ld	_I2C_DR,a
5014  05b1 2024          	jra	L7272
5015  05b3               L5272:
5016                     ; 299    else if (i2c_flags.rw ==read && i2c_flags.first_send ==0)
5018  05b3 b600          	ld	a,_i2c_flags
5019  05b5 a502          	bcp	a,#2
5020  05b7 270c          	jreq	L1372
5022  05b9 b600          	ld	a,_i2c_flags
5023  05bb a508          	bcp	a,#8
5024  05bd 2606          	jrne	L1372
5025                     ; 300     {I2C_DR =ds_address || read;}
5027  05bf 35015216      	mov	_I2C_DR,#1
5029  05c3 2012          	jra	L7272
5030  05c5               L1372:
5031                     ; 302    else if (i2c_flags.rw == write)
5033  05c5 b600          	ld	a,_i2c_flags
5034  05c7 a502          	bcp	a,#2
5035  05c9 260c          	jrne	L7272
5036                     ; 303     {I2C_DR =ds_address || write;}
5038  05cb 3d08          	tnz	_ds_address
5039  05cd 2704          	jreq	L021
5040  05cf a601          	ld	a,#1
5041  05d1 2001          	jra	L221
5042  05d3               L021:
5043  05d3 4f            	clr	a
5044  05d4               L221:
5045  05d4 c75216        	ld	_I2C_DR,a
5046  05d7               L7272:
5047                     ; 306  }      //OK
5050  05d7 81            	ret
5084                     ; 308 void i2c_send_data()
5084                     ; 309  {
5085                     	switch	.text
5086  05d8               _i2c_send_data:
5090                     ; 310    if (i2c_flags.rw == write)
5092  05d8 b600          	ld	a,_i2c_flags
5093  05da a502          	bcp	a,#2
5094  05dc 2651          	jrne	L7472
5095                     ; 312    if   (i2c_flags.first_send == 1)
5097  05de b600          	ld	a,_i2c_flags
5098  05e0 a508          	bcp	a,#8
5099  05e2 270c          	jreq	L1572
5100                     ; 314       I2C_DR = i2c_current_adr++;
5102  05e4 b604          	ld	a,_i2c_current_adr
5103  05e6 3c04          	inc	_i2c_current_adr
5104  05e8 c75216        	ld	_I2C_DR,a
5105                     ; 315       i2c_flags.first_send =0;
5107  05eb 72170000      	bres	_i2c_flags,#3
5108                     ; 316       return;
5111  05ef 81            	ret
5112  05f0               L1572:
5113                     ; 318   else if (i2c_flags.first_send ==0)
5115  05f0 b600          	ld	a,_i2c_flags
5116  05f2 a508          	bcp	a,#8
5117  05f4 2703cc0682    	jrne	L3672
5118                     ; 320      if (i2c_current_adr++ <= i2c_end_adr-1)
5120  05f9 9c            	rvf
5121  05fa b604          	ld	a,_i2c_current_adr
5122  05fc 3c04          	inc	_i2c_current_adr
5123  05fe 5f            	clrw	x
5124  05ff 97            	ld	xl,a
5125  0600 b605          	ld	a,_i2c_end_adr
5126  0602 905f          	clrw	y
5127  0604 9097          	ld	yl,a
5128  0606 905a          	decw	y
5129  0608 90bf00        	ldw	c_y,y
5130  060b b300          	cpw	x,c_y
5131  060d 2c10          	jrsgt	L7572
5132                     ; 322         I2C_DR = *(data_pointer++);
5134  060f be0e          	ldw	x,_data_pointer
5135  0611 1c0001        	addw	x,#1
5136  0614 bf0e          	ldw	_data_pointer,x
5137  0616 1d0001        	subw	x,#1
5138  0619 f6            	ld	a,(x)
5139  061a c75216        	ld	_I2C_DR,a
5141  061d 2063          	jra	L3672
5142  061f               L7572:
5143                     ; 326         I2C_CR2 &= ~I2C_CR2_ACK;       //NACK для прекращения обмена
5145  061f 72155211      	bres	_I2C_CR2,#2
5146                     ; 327         I2C_CR2 |= I2C_CR2_STOP;      //завершаем
5148  0623 72125211      	bset	_I2C_CR2,#1
5149                     ; 328         I2C_DR =*data_pointer;
5151  0627 92c60e        	ld	a,[_data_pointer.w]
5152  062a c75216        	ld	_I2C_DR,a
5153  062d 2053          	jra	L3672
5154  062f               L7472:
5155                     ; 332   else if (i2c_flags.rw ==read)
5157  062f b600          	ld	a,_i2c_flags
5158  0631 a502          	bcp	a,#2
5159  0633 274d          	jreq	L3672
5160                     ; 335    if   (i2c_flags.first_send == 1)
5162  0635 b600          	ld	a,_i2c_flags
5163  0637 a508          	bcp	a,#8
5164  0639 2708          	jreq	L7672
5165                     ; 337       I2C_DR = i2c_current_adr++;
5167  063b b604          	ld	a,_i2c_current_adr
5168  063d 3c04          	inc	_i2c_current_adr
5169  063f c75216        	ld	_I2C_DR,a
5170                     ; 339       return;
5173  0642 81            	ret
5174  0643               L7672:
5175                     ; 341   else if (i2c_flags.first_send ==0)
5177  0643 b600          	ld	a,_i2c_flags
5178  0645 a508          	bcp	a,#8
5179  0647 2639          	jrne	L3672
5180                     ; 343      if (i2c_current_adr++ < i2c_end_adr-1)
5182  0649 9c            	rvf
5183  064a b604          	ld	a,_i2c_current_adr
5184  064c 3c04          	inc	_i2c_current_adr
5185  064e 5f            	clrw	x
5186  064f 97            	ld	xl,a
5187  0650 b605          	ld	a,_i2c_end_adr
5188  0652 905f          	clrw	y
5189  0654 9097          	ld	yl,a
5190  0656 905a          	decw	y
5191  0658 90bf00        	ldw	c_y,y
5192  065b b300          	cpw	x,c_y
5193  065d 2e10          	jrsge	L5772
5194                     ; 345         *(data_pointer++) =I2C_DR;
5196  065f be0e          	ldw	x,_data_pointer
5197  0661 1c0001        	addw	x,#1
5198  0664 bf0e          	ldw	_data_pointer,x
5199  0666 1d0001        	subw	x,#1
5200  0669 c65216        	ld	a,_I2C_DR
5201  066c f7            	ld	(x),a
5203  066d 2013          	jra	L3672
5204  066f               L5772:
5205                     ; 349         I2C_CR2 &= ~I2C_CR2_ACK;       //NACK для прекращения обмена
5207  066f 72155211      	bres	_I2C_CR2,#2
5208                     ; 350         I2C_CR2 |= I2C_CR2_STOP;      //завершаем
5210  0673 72125211      	bset	_I2C_CR2,#1
5211                     ; 351         *(data_pointer) =I2C_DR;
5213  0677 c65216        	ld	a,_I2C_DR
5214  067a 92c70e        	ld	[_data_pointer.w],a
5215                     ; 352 				UART_Send(seconds);
5217  067d b615          	ld	a,_seconds
5218  067f cd0019        	call	_UART_Send
5220  0682               L3672:
5221                     ; 363    if (data_type == 1 && time_pointer != &hours)
5223  0682 b603          	ld	a,_data_type
5224  0684 a101          	cp	a,#1
5225  0686 262e          	jrne	L1003
5227  0688 be06          	ldw	x,_time_pointer
5228  068a a30011        	cpw	x,#_hours
5229  068d 2727          	jreq	L1003
5230                     ; 365       I2C_CR2 |= I2C_CR2_ACK;       //вернем АСК для продолжения приема
5232  068f 72145211      	bset	_I2C_CR2,#2
5233                     ; 366       I2C_DR = (*time_pointer || (*(time_pointer+1) <<4)) || 0x80;
5235  0693 35015216      	mov	_I2C_DR,#1
5236                     ; 367       time_pointer +=2;
5238  0697 be06          	ldw	x,_time_pointer
5239  0699 1c0002        	addw	x,#2
5240  069c bf06          	ldw	_time_pointer,x
5241                     ; 370         if (time_pointer == &hours)
5243  069e be06          	ldw	x,_time_pointer
5244  06a0 a30011        	cpw	x,#_hours
5245  06a3 2611          	jrne	L1003
5246                     ; 372         I2C_CR2 &= ~I2C_CR2_ACK;       //NACK для прекращения обмена
5248  06a5 72155211      	bres	_I2C_CR2,#2
5249                     ; 373         I2C_CR2 |= I2C_CR2_STOP;      //завершаем
5251  06a9 72125211      	bset	_I2C_CR2,#1
5252                     ; 374         I2C_DR = (*time_pointer || (*(time_pointer+1) <<4)) || 0x80;
5254  06ad 35015216      	mov	_I2C_DR,#1
5255                     ; 375         time_pointer =&hours;
5257  06b1 ae0011        	ldw	x,#_hours
5258  06b4 bf06          	ldw	_time_pointer,x
5259  06b6               L1003:
5260                     ; 378    if (data_type ==2)
5262  06b6 b603          	ld	a,_data_type
5263  06b8 a102          	cp	a,#2
5264  06ba 260c          	jrne	L5003
5265                     ; 380       I2C_CR2 &= ~I2C_CR2_ACK;       //NACK для прекращения обмена
5267  06bc 72155211      	bres	_I2C_CR2,#2
5268                     ; 381         I2C_CR2 |= I2C_CR2_STOP;      //завершаем
5270  06c0 72125211      	bset	_I2C_CR2,#1
5271                     ; 382       I2C_DR = 0x11;            //тупо настроили выход с ножки
5273  06c4 35115216      	mov	_I2C_DR,#17
5274  06c8               L5003:
5275                     ; 384  }
5278  06c8 81            	ret
5313                     ; 386 void i2c_read_data(uint8_t address)
5313                     ; 387  {
5314                     	switch	.text
5315  06c9               _i2c_read_data:
5319                     ; 388    i2c_start(read, address, address);
5321  06c9 88            	push	a
5322  06ca 97            	ld	xl,a
5323  06cb a601          	ld	a,#1
5324  06cd 95            	ld	xh,a
5325  06ce cd056f        	call	_i2c_start
5327  06d1 84            	pop	a
5328                     ; 389  }
5331  06d2 81            	ret
5366                     ; 391 void i2c_write_data (uint8_t address)
5366                     ; 392  {
5367                     	switch	.text
5368  06d3               _i2c_write_data:
5372                     ; 393    i2c_start(write, address, address);
5374  06d3 88            	push	a
5375  06d4 97            	ld	xl,a
5376  06d5 4f            	clr	a
5377  06d6 95            	ld	xh,a
5378  06d7 cd056f        	call	_i2c_start
5380  06da 84            	pop	a
5381                     ; 394  }
5384  06db 81            	ret
5412                     ; 395 void I2C_ack_time(void)
5412                     ; 396  {
5413                     	switch	.text
5414  06dc               _I2C_ack_time:
5418                     ; 397    data_pointer = &fresh_sec;
5420  06dc ae0018        	ldw	x,#_fresh_sec
5421  06df bf0e          	ldw	_data_pointer,x
5422                     ; 398    flags.time_ack =1;
5424  06e1 72140001      	bset	_flags,#2
5425                     ; 399    i2c_flags.rw =1;    //бит направление данных
5427  06e5 72120000      	bset	_i2c_flags,#1
5428                     ; 400    i2c_start(read, time_address, time_address+2);
5430  06e9 4b02          	push	#2
5431  06eb ae0100        	ldw	x,#256
5432  06ee cd056f        	call	_i2c_start
5434  06f1 84            	pop	a
5435                     ; 402  }
5438  06f2 81            	ret
5465                     ; 403 void  i2c_write_time(void)
5465                     ; 404  {
5466                     	switch	.text
5467  06f3               _i2c_write_time:
5471                     ; 405   data_pointer =&fresh_sec;     ////////????????????????????????
5473  06f3 ae0018        	ldw	x,#_fresh_sec
5474  06f6 bf0e          	ldw	_data_pointer,x
5475                     ; 406   i2c_flags.rw =0;      //бит направление данных
5477  06f8 72130000      	bres	_i2c_flags,#1
5478                     ; 407   i2c_start(write, time_address, time_address+2);
5480  06fc 4b02          	push	#2
5481  06fe 5f            	clrw	x
5482  06ff cd056f        	call	_i2c_start
5484  0702 84            	pop	a
5485                     ; 408  }
5488  0703 81            	ret
5511                     ; 410 void i2c_exeption(void)
5511                     ; 411  {
5512                     	switch	.text
5513  0704               _i2c_exeption:
5517                     ; 413  }
5520  0704 81            	ret
5550                     ; 415  void i2c_stupid_read(void)
5550                     ; 416  {
5551                     	switch	.text
5552  0705               _i2c_stupid_read:
5556                     ; 417 	 I2C_CR2 = I2C_CR2_START;
5558  0705 35015211      	mov	_I2C_CR2,#1
5560  0709               L7013:
5561                     ; 418 		while ((I2C_SR1 & 1) == 0);
5563  0709 c65217        	ld	a,_I2C_SR1
5564  070c a501          	bcp	a,#1
5565  070e 27f9          	jreq	L7013
5566                     ; 419 			I2C->DR = ds_address || 1;
5568  0710 35015216      	mov	21014,#1
5570  0714 2005          	jra	L7113
5571  0716               L3113:
5572                     ; 422 				temp = I2C_SR1;	
5574  0716 555217000b    	mov	_temp,_I2C_SR1
5575  071b               L7113:
5576                     ; 420 				while (I2C_SR1 != 2)//(I2C_SR1 & I2C_SR1_ADDR) == 0)
5578  071b c65217        	ld	a,_I2C_SR1
5579  071e a102          	cp	a,#2
5580  0720 26f4          	jrne	L3113
5581                     ; 425 				temp = I2C_SR3;
5584  0722 555219000b    	mov	_temp,_I2C_SR3
5585                     ; 426 				I2C_CR2 = I2C_CR2_STOP;
5587  0727 35025211      	mov	_I2C_CR2,#2
5589  072b               L7213:
5590                     ; 427 				while ((I2C_SR1 & I2C_SR1_BTF) == 0);
5592  072b c65217        	ld	a,_I2C_SR1
5593  072e a504          	bcp	a,#4
5594  0730 27f9          	jreq	L7213
5595                     ; 428 					temp = I2C_DR;
5597  0732 555216000b    	mov	_temp,_I2C_DR
5598                     ; 429 					UART_Send(temp);
5600  0737 b60b          	ld	a,_temp
5601  0739 cd0019        	call	_UART_Send
5603                     ; 430 				}
5606  073c 81            	ret
5648                     ; 1 void spi_setup(void)
5648                     ; 2  {
5649                     	switch	.text
5650  073d               _spi_setup:
5654                     ; 3     SPI_CR1=0x7C;       //ну тип вот
5656  073d 357c5200      	mov	_SPI_CR1,#124
5657                     ; 4 		SPI_ICR = 0x80;
5659  0741 35805202      	mov	_SPI_ICR,#128
5660                     ; 6  }
5663  0745 81            	ret
5689                     ; 7 void SPI_Send1 (void)   //отправка первого байта SPI
5689                     ; 8 {
5690                     	switch	.text
5691  0746               _SPI_Send1:
5695                     ; 9   SPI_DR = deshifr_code_out;
5697  0746 55001c5204    	mov	_SPI_DR,_deshifr_code_out
5698                     ; 10   spi_queue++;
5700  074b 3c0c          	inc	_spi_queue
5701                     ; 11 }	
5704  074d 81            	ret
5730                     ; 13 void SPI_Send2 (void)   //отправка второго байта
5730                     ; 14 {
5731                     	switch	.text
5732  074e               _SPI_Send2:
5736                     ; 15   SPI_DR=lamp_number_out;
5738  074e 55001b5204    	mov	_SPI_DR,_lamp_number_out
5739                     ; 16   spi_queue = 1;
5741  0753 3501000c      	mov	_spi_queue,#1
5742                     ; 17 }
5745  0757 81            	ret
5780                     ; 19 void SPI_Send(uint8_t msg)
5780                     ; 20 {
5781                     	switch	.text
5782  0758               _SPI_Send:
5786                     ; 21 	SPI_DR = msg;
5788  0758 c75204        	ld	_SPI_DR,a
5789                     ; 22 }
5792  075b 81            	ret
5834                     ; 4 void UART_Resieved (void)
5834                     ; 5 {
5835                     	switch	.text
5836  075c               _UART_Resieved:
5840                     ; 6 	UART_Send(UART1_DR);
5842  075c c65231        	ld	a,_UART1_DR
5843  075f cd0019        	call	_UART_Send
5845                     ; 7 }
5848  0762 81            	ret
5873                     ; 9 void SPI_Transmitted(void)
5873                     ; 10 {
5874                     	switch	.text
5875  0763               _SPI_Transmitted:
5879                     ; 11 	SPI_Send(temp);
5881  0763 b60b          	ld	a,_temp
5882  0765 adf1          	call	_SPI_Send
5884                     ; 12 }
5887  0767 81            	ret
5914                     ; 14 void I2C_Event(void)
5914                     ; 15 {
5915                     	switch	.text
5916  0768               _I2C_Event:
5920                     ; 16 	temp = I2C_SR1;
5922  0768 555217000b    	mov	_temp,_I2C_SR1
5923                     ; 17 	if ((I2C_SR1 & I2C_SR1_SB) == I2C_SR1_SB)
5925  076d c65217        	ld	a,_I2C_SR1
5926  0770 a401          	and	a,#1
5927  0772 a101          	cp	a,#1
5928  0774 2605          	jrne	L5423
5929                     ; 19 				i2c_send_adress();
5931  0776 cd0599        	call	_i2c_send_adress
5934  0779 200e          	jra	L7423
5935  077b               L5423:
5936                     ; 21 			else if ((I2C_SR1 & I2C_SR1_ADDR) == I2C_SR1_ADDR)
5938  077b c65217        	ld	a,_I2C_SR1
5939  077e a402          	and	a,#2
5940  0780 a102          	cp	a,#2
5941  0782 2602          	jrne	L1523
5942                     ; 23 				i2c_send_data;
5945  0784 2003          	jra	L7423
5946  0786               L1523:
5947                     ; 25 			else i2c_send_data();
5949  0786 cd05d8        	call	_i2c_send_data
5951  0789               L7423:
5952                     ; 26 }
5955  0789 81            	ret
5981                     ; 28 void Keys_switched(void)
5981                     ; 29 {
5982                     	switch	.text
5983  078a               _Keys_switched:
5987                     ; 30 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
5989  078a c650a0        	ld	a,_EXTI_CR1
5990  078d 43            	cpl	a
5991  078e a430          	and	a,#48
5992  0790 c750a0        	ld	_EXTI_CR1,a
5993                     ; 31 	PC_CR2 = 0;
5995  0793 725f500e      	clr	_PC_CR2
5996                     ; 32 	timer2_start(0xff);
5998  0797 ae00ff        	ldw	x,#255
5999  079a cd0077        	call	_timer2_start
6001                     ; 77 }
6004  079d 81            	ret
6027                     ; 79 void DS_interrupt (void)
6027                     ; 80 {
6028                     	switch	.text
6029  079e               _DS_interrupt:
6033                     ; 82 }
6036  079e 81            	ret
6099                     ; 26 int main( void )
6099                     ; 27 {
6100                     	switch	.text
6101  079f               _main:
6105                     ; 30 	CLK_CKDIVR=0;                //нет делителей
6107  079f 725f50c6      	clr	_CLK_CKDIVR
6108                     ; 31   CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //тактирование на TIM1, UART1, SPI i I2C
6110  07a3 35ff50c7      	mov	_CLK_PCKENR1,#255
6111                     ; 33 	_asm ("SIM"); // off interrupts
6114  07a7 9b            SIM
6116                     ; 34 	EXTI_CR1 = 0x10; //(2<<EXTI_CR1_PCIS);
6118  07a8 351050a0      	mov	_EXTI_CR1,#16
6119                     ; 38     PA_DDR=0x08; //0b000001000; //выход на защелку регистров, вход на сигнал с ртс
6121  07ac 35085002      	mov	_PA_DDR,#8
6122                     ; 39     PA_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
6124  07b0 35ff5003      	mov	_PA_CR1,#255
6125                     ; 46     PC_DDR=0x60; //0b01100000; //SPI на выход, кнопочки на вход
6127  07b4 3560500c      	mov	_PC_DDR,#96
6128                     ; 47     PC_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
6130  07b8 35ff500d      	mov	_PC_CR1,#255
6131                     ; 49     PC_CR2 |= (1<<4) | (1<<3);        //есть прерывания
6133  07bc c6500e        	ld	a,_PC_CR2
6134  07bf aa18          	or	a,#24
6135  07c1 c7500e        	ld	_PC_CR2,a
6136                     ; 51 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM на вход
6138  07c4 35a85011      	mov	_PD_DDR,#168
6139                     ; 52     PD_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
6141  07c8 35ff5012      	mov	_PD_CR1,#255
6142                     ; 53     PD_ODR = (1 << 3);
6144  07cc 3508500f      	mov	_PD_ODR,#8
6145                     ; 59 	i2c_master_init(16000000, 100000);
6147  07d0 ae86a0        	ldw	x,#34464
6148  07d3 89            	pushw	x
6149  07d4 ae0001        	ldw	x,#1
6150  07d7 89            	pushw	x
6151  07d8 ae2400        	ldw	x,#9216
6152  07db 89            	pushw	x
6153  07dc ae00f4        	ldw	x,#244
6154  07df 89            	pushw	x
6155  07e0 cd0242        	call	_i2c_master_init
6157  07e3 5b08          	addw	sp,#8
6158                     ; 64 		uart_setup();
6160  07e5 cd0000        	call	_uart_setup
6162                     ; 65 		UART_Send('h');
6164  07e8 a668          	ld	a,#104
6165  07ea cd0019        	call	_UART_Send
6167                     ; 66     timer1_setup( 65500,0xffff);//частота в гц и топ значение
6169  07ed aeffff        	ldw	x,#65535
6170  07f0 89            	pushw	x
6171  07f1 aeffdc        	ldw	x,#65500
6172  07f4 cd0141        	call	_timer1_setup
6174  07f7 85            	popw	x
6175                     ; 67 		timer2_setup();
6177  07f8 cd01ac        	call	_timer2_setup
6179                     ; 71 		timer1_start();
6181  07fb cd013c        	call	_timer1_start
6183                     ; 73 		temp = 10;
6185  07fe 350a000b      	mov	_temp,#10
6186                     ; 74 		SPI_DR = temp;
6188  0802 55000b5204    	mov	_SPI_DR,_temp
6189                     ; 75 		i2c_rd_reg(0xD0, 0, time_pointer, 1);
6191  0807 4b01          	push	#1
6192  0809 be06          	ldw	x,_time_pointer
6193  080b 89            	pushw	x
6194  080c aed000        	ldw	x,#53248
6195  080f cd0395        	call	_i2c_rd_reg
6197  0812 5b03          	addw	sp,#3
6198                     ; 78 			UART_Send(seconds);
6200  0814 b615          	ld	a,_seconds
6201  0816 cd0019        	call	_UART_Send
6203                     ; 80  _asm ("RIM");  //on interupts
6206  0819 9a            RIM
6208  081a               L3133:
6209                     ; 81 while(1);
6211  081a 20fe          	jra	L3133
6224                     	xdef	_main
6225                     	xdef	_DS_interrupt
6226                     	xdef	_Keys_switched
6227                     	xdef	_I2C_Event
6228                     	xdef	_SPI_Transmitted
6229                     	xdef	_UART_Resieved
6230                     	xdef	_SPI_Send
6231                     	xdef	_SPI_Send2
6232                     	xdef	_SPI_Send1
6233                     	xdef	_spi_setup
6234                     	xdef	_i2c_stupid_read
6235                     	xdef	_i2c_exeption
6236                     	xdef	_i2c_write_time
6237                     	xdef	_I2C_ack_time
6238                     	xdef	_i2c_write_data
6239                     	xdef	_i2c_read_data
6240                     	xdef	_i2c_send_data
6241                     	xdef	_i2c_send_adress
6242                     	xdef	_i2c_init
6243                     	xdef	_sI2C_Send_data
6244                     	xdef	_i2c_rd_reg
6245                     	xdef	_i2c_wr_reg
6246                     	xdef	_i2c_master_init
6247                     	xdef	_display
6248                     	xdef	_time_recalculation
6249                     	xdef	_Key_interrupt
6250                     	xdef	_timer2_setup
6251                     	xdef	_timer1_setup
6252                     	xdef	_timer1_start
6253                     	xdef	_Timer1_Compare_1
6254                     	xdef	_Timer2_Overflow
6255                     	xdef	_timer2_start
6256                     	xdef	_i2c_start
6257                     	xdef	_Two_keys_pressed
6258                     	xdef	_Inc_key_pressed
6259                     	xdef	_Menu_key_pressed
6260                     	xdef	_UART_Send
6261                     	xdef	_uart_setup
6262                     	switch	.ubsct
6263  0000               _i2c_flags:
6264  0000 00            	ds.b	1
6265                     	xdef	_i2c_flags
6266  0001               _flags:
6267  0001 00            	ds.b	1
6268                     	xdef	_flags
6269  0002               _cell_address:
6270  0002 00            	ds.b	1
6271                     	xdef	_cell_address
6272  0003               _data_type:
6273  0003 00            	ds.b	1
6274                     	xdef	_data_type
6275  0004               _i2c_current_adr:
6276  0004 00            	ds.b	1
6277                     	xdef	_i2c_current_adr
6278  0005               _i2c_end_adr:
6279  0005 00            	ds.b	1
6280                     	xdef	_i2c_end_adr
6281  0006               _i2c_start_adr:
6282  0006 00            	ds.b	1
6283                     	xdef	_i2c_start_adr
6284                     	xdef	_ds_address
6285  0007               _tunning:
6286  0007 00            	ds.b	1
6287                     	xdef	_tunning
6288  0008               _two_keys:
6289  0008 00            	ds.b	1
6290                     	xdef	_two_keys
6291  0009               _tunning_digits:
6292  0009 00            	ds.b	1
6293                     	xdef	_tunning_digits
6294  000a               _temp2:
6295  000a 00            	ds.b	1
6296                     	xdef	_temp2
6297  000b               _temp:
6298  000b 00            	ds.b	1
6299                     	xdef	_temp
6300  000c               _spi_queue:
6301  000c 00            	ds.b	1
6302                     	xdef	_spi_queue
6303  000d               _pins:
6304  000d 00            	ds.b	1
6305                     	xdef	_pins
6306  000e               _data_pointer:
6307  000e 0000          	ds.b	2
6308                     	xdef	_data_pointer
6309                     	xdef	_time_pointer
6310  0010               _hours_decades:
6311  0010 00            	ds.b	1
6312                     	xdef	_hours_decades
6313  0011               _hours:
6314  0011 00            	ds.b	1
6315                     	xdef	_hours
6316  0012               _minutes_decades:
6317  0012 00            	ds.b	1
6318                     	xdef	_minutes_decades
6319  0013               _minutes:
6320  0013 00            	ds.b	1
6321                     	xdef	_minutes
6322  0014               _seconds_decades:
6323  0014 00            	ds.b	1
6324                     	xdef	_seconds_decades
6325  0015               _seconds:
6326  0015 00            	ds.b	1
6327                     	xdef	_seconds
6328  0016               _fresh_hours:
6329  0016 00            	ds.b	1
6330                     	xdef	_fresh_hours
6331  0017               _fresh_min:
6332  0017 00            	ds.b	1
6333                     	xdef	_fresh_min
6334  0018               _fresh_sec:
6335  0018 00            	ds.b	1
6336                     	xdef	_fresh_sec
6337  0019               _ds_tacts:
6338  0019 0000          	ds.b	2
6339                     	xdef	_ds_tacts
6340  001b               _lamp_number_out:
6341  001b 00            	ds.b	1
6342                     	xdef	_lamp_number_out
6343  001c               _deshifr_code_out:
6344  001c 00            	ds.b	1
6345                     	xdef	_deshifr_code_out
6346                     	xdef	_dots
6347                     	xdef	_lamp4_digit
6348                     	xdef	_lamp3_digit
6349                     	xdef	_lamp2_digit
6350                     	xdef	_lamp1_digit
6351                     	xdef	_lamp_number
6352  001d               L7241_i2c_timeout:
6353  001d 00000000      	ds.b	4
6354                     	xref.b	c_lreg
6355                     	xref.b	c_x
6356                     	xref.b	c_y
6376                     	xref	c_lrzmp
6377                     	xref	c_lgsbc
6378                     	xref	c_lzmp
6379                     	xref	c_ludv
6380                     	xref	c_ltor
6381                     	xref	c_lrsh
6382                     	xref	c_ldiv
6383                     	xref	c_rtol
6384                     	xref	c_uitolx
6385                     	end
