   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2184                     	bsct
2185  0000               _lamp_number:
2186  0000 00            	dc.b	0
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
2198  0006 0014          	dc.w	_seconds
2199  0008               _temp2:
2200  0008 aa            	dc.b	170
2201  0009               _temp3:
2202  0009 33            	dc.b	51
2203  000a               _ds_address:
2204  000a d0            	dc.b	208
2205  000b               _ds_cr:
2206  000b 90            	dc.b	144
2775                     ; 2  void uart_setup(void)
2775                     ; 3  {
2777                     	switch	.text
2778  0000               _uart_setup:
2782                     ; 4    UART1_BRR1=0x68;     //9600 bod
2784  0000 35685232      	mov	_UART1_BRR1,#104
2785                     ; 5     UART1_BRR2=0x03;
2787  0004 35035233      	mov	_UART1_BRR2,#3
2788                     ; 6     UART1_CR2 |= UART1_CR2_REN; //прием
2790  0008 72145235      	bset	_UART1_CR2,#2
2791                     ; 7     UART1_CR2 |= UART1_CR2_TEN; //передача
2793  000c 72165235      	bset	_UART1_CR2,#3
2794                     ; 8     UART1_CR2 |= UART1_CR2_RIEN; //Прерывание по приему
2796  0010 721a5235      	bset	_UART1_CR2,#5
2797                     ; 9 		UART1_SR = 0;
2799  0014 725f5230      	clr	_UART1_SR
2800                     ; 10  }
2803  0018 81            	ret
2840                     ; 11 void UART_Send (uint8_t msg)
2840                     ; 12  {
2841                     	switch	.text
2842  0019               _UART_Send:
2844  0019 88            	push	a
2845       00000000      OFST:	set	0
2848                     ; 14 	 temp =msg;
2850  001a b70a          	ld	_temp,a
2852  001c               L1402:
2853                     ; 15 	 while((UART1_SR & 0x80) == 0x00);
2855  001c c65230        	ld	a,_UART1_SR
2856  001f a580          	bcp	a,#128
2857  0021 27f9          	jreq	L1402
2858                     ; 16 	 UART1_DR = msg;
2860  0023 7b01          	ld	a,(OFST+1,sp)
2861  0025 c75231        	ld	_UART1_DR,a
2862                     ; 17  }
2865  0028 84            	pop	a
2866  0029 81            	ret
2911                     ; 18  void uart_routine(uint8_t data)
2911                     ; 19  {
2912                     	switch	.text
2913  002a               _uart_routine:
2915  002a 88            	push	a
2916       00000000      OFST:	set	0
2919                     ; 21 	 if (timeset != 0 && timeset <= 5)
2921  002b 3d17          	tnz	_timeset
2922  002d 2719          	jreq	L3602
2924  002f b617          	ld	a,_timeset
2925  0031 a106          	cp	a,#6
2926  0033 2413          	jruge	L3602
2927                     ; 23 		* fresh_data_pointer-- = data-0x30;
2929  0035 7b01          	ld	a,(OFST+1,sp)
2930  0037 a030          	sub	a,#48
2931  0039 be0d          	ldw	x,_fresh_data_pointer
2932  003b 1d0001        	subw	x,#1
2933  003e bf0d          	ldw	_fresh_data_pointer,x
2934  0040 1c0001        	addw	x,#1
2935  0043 f7            	ld	(x),a
2936                     ; 24 		 timeset++;
2938  0044 3c17          	inc	_timeset
2939                     ; 25 		 return ;
2942  0046 84            	pop	a
2943  0047 81            	ret
2944  0048               L3602:
2945                     ; 27 	 if (timeset == 6)
2947  0048 b617          	ld	a,_timeset
2948  004a a106          	cp	a,#6
2949  004c 260e          	jrne	L5602
2950                     ; 29 		 *fresh_data_pointer = data-0x30;
2952  004e 7b01          	ld	a,(OFST+1,sp)
2953  0050 a030          	sub	a,#48
2954  0052 92c70d        	ld	[_fresh_data_pointer.w],a
2955                     ; 30 		 timeset = 0;
2957  0055 3f17          	clr	_timeset
2958                     ; 31 		 time_write();
2960  0057 cd0539        	call	_time_write
2962                     ; 32 		 return;
2965  005a 84            	pop	a
2966  005b 81            	ret
2967  005c               L5602:
2968                     ; 35 	 if (data == 's')
2970  005c 7b01          	ld	a,(OFST+1,sp)
2971  005e a173          	cp	a,#115
2972  0060 260b          	jrne	L7602
2973                     ; 37 			timeset = 1;
2975  0062 35010017      	mov	_timeset,#1
2976                     ; 38 			fresh_data_pointer = &fresh_hours_dec;
2978  0066 ae001d        	ldw	x,#_fresh_hours_dec
2979  0069 bf0d          	ldw	_fresh_data_pointer,x
2980                     ; 39 			return;
2983  006b 84            	pop	a
2984  006c 81            	ret
2985  006d               L7602:
2986                     ; 42 		if (data == 't')
2988  006d 7b01          	ld	a,(OFST+1,sp)
2989  006f a174          	cp	a,#116
2990  0071 2632          	jrne	L1702
2991                     ; 44 			UART_Send(hours_decades+0x30);
2993  0073 b611          	ld	a,_hours_decades
2994  0075 ab30          	add	a,#48
2995  0077 ada0          	call	_UART_Send
2997                     ; 45 			UART_Send(hours+0x30);
2999  0079 b616          	ld	a,_hours
3000  007b ab30          	add	a,#48
3001  007d ad9a          	call	_UART_Send
3003                     ; 46 			UART_Send(':');	
3005  007f a63a          	ld	a,#58
3006  0081 ad96          	call	_UART_Send
3008                     ; 47 			UART_Send(minutes_decades+0x30);
3010  0083 b612          	ld	a,_minutes_decades
3011  0085 ab30          	add	a,#48
3012  0087 ad90          	call	_UART_Send
3014                     ; 48 			UART_Send(minutes+0x30);
3016  0089 b615          	ld	a,_minutes
3017  008b ab30          	add	a,#48
3018  008d ad8a          	call	_UART_Send
3020                     ; 49 			UART_Send(':'); 
3022  008f a63a          	ld	a,#58
3023  0091 ad86          	call	_UART_Send
3025                     ; 50 			UART_Send(seconds_decades+0x30);
3027  0093 b613          	ld	a,_seconds_decades
3028  0095 ab30          	add	a,#48
3029  0097 ad80          	call	_UART_Send
3031                     ; 51 			UART_Send(seconds+0x30);
3033  0099 b614          	ld	a,_seconds
3034  009b ab30          	add	a,#48
3035  009d cd0019        	call	_UART_Send
3037                     ; 52 			UART_Send(0x0A);
3039  00a0 a60a          	ld	a,#10
3040  00a2 cd0019        	call	_UART_Send
3042  00a5               L1702:
3043                     ; 54 	}
3046  00a5 84            	pop	a
3047  00a6 81            	ret
3089                     ; 5 void Menu_key_pressed(void)
3089                     ; 6 {
3090                     	switch	.text
3091  00a7               _Menu_key_pressed:
3095                     ; 7 	UART_Send('1');
3097  00a7 a631          	ld	a,#49
3098  00a9 cd0019        	call	_UART_Send
3100                     ; 8   if (tunning_digits ==1)
3102  00ac b609          	ld	a,_tunning_digits
3103  00ae a101          	cp	a,#1
3104  00b0 2604          	jrne	L1112
3105                     ; 10      tunning_digits =0;
3107  00b2 3f09          	clr	_tunning_digits
3109  00b4 2004          	jra	L3112
3110  00b6               L1112:
3111                     ; 12   else tunning_digits=1;
3113  00b6 35010009      	mov	_tunning_digits,#1
3114  00ba               L3112:
3115                     ; 13 }
3118  00ba 81            	ret
3147                     ; 15 void Inc_key_pressed(void)
3147                     ; 16 {
3148                     	switch	.text
3149  00bb               _Inc_key_pressed:
3153                     ; 17 	UART_Send('2');
3155  00bb a632          	ld	a,#50
3156  00bd cd0019        	call	_UART_Send
3158                     ; 18   if (tunning_digits ==0)
3160  00c0 3d09          	tnz	_tunning_digits
3161  00c2 2616          	jrne	L5212
3162                     ; 20      hours++;
3164  00c4 3c16          	inc	_hours
3165                     ; 21      if (hours == 0x0A)
3167  00c6 b616          	ld	a,_hours
3168  00c8 a10a          	cp	a,#10
3169  00ca 2628          	jrne	L3312
3170                     ; 23         hours_decades++;
3172  00cc 3c11          	inc	_hours_decades
3173                     ; 24         hours =0;
3175  00ce 3f16          	clr	_hours
3176                     ; 25         if (hours_decades ==0x03)
3178  00d0 b611          	ld	a,_hours_decades
3179  00d2 a103          	cp	a,#3
3180  00d4 261e          	jrne	L3312
3181                     ; 27            hours_decades =0;
3183  00d6 3f11          	clr	_hours_decades
3184  00d8 201a          	jra	L3312
3185  00da               L5212:
3186                     ; 31   else if (tunning_digits ==1)
3188  00da b609          	ld	a,_tunning_digits
3189  00dc a101          	cp	a,#1
3190  00de 2614          	jrne	L3312
3191                     ; 33      minutes++;
3193  00e0 3c15          	inc	_minutes
3194                     ; 34      if (minutes == 0x0A)
3196  00e2 b615          	ld	a,_minutes
3197  00e4 a10a          	cp	a,#10
3198  00e6 260c          	jrne	L3312
3199                     ; 36         minutes_decades++;
3201  00e8 3c12          	inc	_minutes_decades
3202                     ; 37         minutes =0;
3204  00ea 3f15          	clr	_minutes
3205                     ; 38         if (minutes_decades ==0x06)
3207  00ec b612          	ld	a,_minutes_decades
3208  00ee a106          	cp	a,#6
3209  00f0 2602          	jrne	L3312
3210                     ; 40            minutes_decades =0;
3212  00f2 3f12          	clr	_minutes_decades
3213  00f4               L3312:
3214                     ; 44 }
3217  00f4 81            	ret
3240                     ; 46 void Two_keys_pressed(void)
3240                     ; 47 {
3241                     	switch	.text
3242  00f5               _Two_keys_pressed:
3246                     ; 49 }
3249  00f5 81            	ret
3328                     ; 7 void i2c_master_init(unsigned long f_master_hz, unsigned long f_i2c_hz){
3329                     	switch	.text
3330  00f6               _i2c_master_init:
3332  00f6 5208          	subw	sp,#8
3333       00000008      OFST:	set	8
3336                     ; 10   PB_DDR = (0<<4);//PB_DDR_DDR4);
3338  00f8 725f5007      	clr	_PB_DDR
3339                     ; 11 	PB_DDR = (0<<5);//PB_DDR_DDR5);
3341  00fc 725f5007      	clr	_PB_DDR
3342                     ; 12 	PB_ODR = (1<<5);//PB_ODR_ODR5);  //SDA
3344  0100 35205005      	mov	_PB_ODR,#32
3345                     ; 13   PB_ODR = (1<<4);//PB_ODR_ODR4);  //SCL
3347  0104 35105005      	mov	_PB_ODR,#16
3348                     ; 15   PB_CR1 = (0<<4);//PB_CR1_C14);
3350  0108 725f5008      	clr	_PB_CR1
3351                     ; 16   PB_CR1 = (0<<5);//PB_CR1_C15);
3353  010c 725f5008      	clr	_PB_CR1
3354                     ; 18   PB_CR2 = (0<<4);//PB_CR1_C24);
3356  0110 725f5009      	clr	_PB_CR2
3357                     ; 19   PB_CR2 = (0<<5);//PB_CR1_C25);
3359  0114 725f5009      	clr	_PB_CR2
3360                     ; 22   I2C_FREQR = 16;
3362  0118 35105212      	mov	_I2C_FREQR,#16
3363                     ; 24   I2C_CR1 |=~I2C_CR1_PE;
3365  011c c65210        	ld	a,_I2C_CR1
3366  011f aafe          	or	a,#254
3367  0121 c75210        	ld	_I2C_CR1,a
3368                     ; 27   I2C_CCRH |=~I2C_CCRH_FS;
3370  0124 c6521c        	ld	a,_I2C_CCRH
3371  0127 aa7f          	or	a,#127
3372  0129 c7521c        	ld	_I2C_CCRH,a
3373                     ; 29   ccr = f_master_hz/(2*f_i2c_hz);
3375  012c 96            	ldw	x,sp
3376  012d 1c000f        	addw	x,#OFST+7
3377  0130 cd0000        	call	c_ltor
3379  0133 3803          	sll	c_lreg+3
3380  0135 3902          	rlc	c_lreg+2
3381  0137 3901          	rlc	c_lreg+1
3382  0139 3900          	rlc	c_lreg
3383  013b 96            	ldw	x,sp
3384  013c 1c0001        	addw	x,#OFST-7
3385  013f cd0000        	call	c_rtol
3387  0142 96            	ldw	x,sp
3388  0143 1c000b        	addw	x,#OFST+3
3389  0146 cd0000        	call	c_ltor
3391  0149 96            	ldw	x,sp
3392  014a 1c0001        	addw	x,#OFST-7
3393  014d cd0000        	call	c_ludv
3395  0150 96            	ldw	x,sp
3396  0151 1c0005        	addw	x,#OFST-3
3397  0154 cd0000        	call	c_rtol
3399                     ; 33   I2C_TRISER = 12+1;
3401  0157 350d521d      	mov	_I2C_TRISER,#13
3402                     ; 34   I2C_CCRL = ccr & 0xFF;
3404  015b 7b08          	ld	a,(OFST+0,sp)
3405  015d a4ff          	and	a,#255
3406  015f c7521b        	ld	_I2C_CCRL,a
3407                     ; 35   I2C_CCRH = ((ccr >> 8) & 0x0F);
3409  0162 7b07          	ld	a,(OFST-1,sp)
3410  0164 a40f          	and	a,#15
3411  0166 c7521c        	ld	_I2C_CCRH,a
3412                     ; 37   I2C_CR1 |=I2C_CR1_PE;
3414  0169 72105210      	bset	_I2C_CR1,#0
3415                     ; 39   I2C_CR2 |=I2C_CR2_ACK;
3417  016d 72145211      	bset	_I2C_CR2,#2
3418                     ; 40 }
3421  0171 5b08          	addw	sp,#8
3422  0173 81            	ret
3516                     ; 46 t_i2c_status i2c_wr_reg(unsigned char address, unsigned char reg_addr,
3516                     ; 47                               char * data, unsigned char length)
3516                     ; 48 {                                  
3517                     	switch	.text
3518  0174               _i2c_wr_reg:
3520  0174 89            	pushw	x
3521       00000000      OFST:	set	0
3524  0175               L5522:
3525                     ; 52   while((I2C_SR3 & I2C_SR3_BUSY) !=0);   
3527  0175 c65219        	ld	a,_I2C_SR3
3528  0178 a502          	bcp	a,#2
3529  017a 26f9          	jrne	L5522
3530                     ; 54   I2C_CR2 |= I2C_CR2_START;
3532  017c 72105211      	bset	_I2C_CR2,#0
3534  0180               L3622:
3535                     ; 57   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3537  0180 c65217        	ld	a,_I2C_SR1
3538  0183 a501          	bcp	a,#1
3539  0185 27f9          	jreq	L3622
3540                     ; 60   I2C_DR = address & 0xFE;
3542  0187 7b01          	ld	a,(OFST+1,sp)
3543  0189 a4fe          	and	a,#254
3544  018b c75216        	ld	_I2C_DR,a
3546  018e               L3722:
3547                     ; 63 	while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3549  018e c65217        	ld	a,_I2C_SR1
3550  0191 a502          	bcp	a,#2
3551  0193 27f9          	jreq	L3722
3552                     ; 65   I2C_SR3;
3554  0195 c65219        	ld	a,_I2C_SR3
3556  0198               L1032:
3557                     ; 70   while((I2C_SR1 & I2C_SR1_TXE) ==0);
3559  0198 c65217        	ld	a,_I2C_SR1
3560  019b a580          	bcp	a,#128
3561  019d 27f9          	jreq	L1032
3562                     ; 72   I2C_DR = reg_addr;
3564  019f 7b02          	ld	a,(OFST+2,sp)
3565  01a1 c75216        	ld	_I2C_DR,a
3567  01a4 2015          	jra	L1132
3568  01a6               L7132:
3569                     ; 78     while((I2C_SR1 & I2C_SR1_TXE) == 0);
3571  01a6 c65217        	ld	a,_I2C_SR1
3572  01a9 a580          	bcp	a,#128
3573  01ab 27f9          	jreq	L7132
3574                     ; 80     I2C_DR = *data++;
3576  01ad 1e05          	ldw	x,(OFST+5,sp)
3577  01af 1c0001        	addw	x,#1
3578  01b2 1f05          	ldw	(OFST+5,sp),x
3579  01b4 1d0001        	subw	x,#1
3580  01b7 f6            	ld	a,(x)
3581  01b8 c75216        	ld	_I2C_DR,a
3582  01bb               L1132:
3583                     ; 75   while(length--){
3585  01bb 7b07          	ld	a,(OFST+7,sp)
3586  01bd 0a07          	dec	(OFST+7,sp)
3587  01bf 4d            	tnz	a
3588  01c0 26e4          	jrne	L7132
3590  01c2               L5232:
3591                     ; 85   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3593  01c2 c65217        	ld	a,_I2C_SR1
3594  01c5 a584          	bcp	a,#132
3595  01c7 27f9          	jreq	L5232
3596                     ; 87   I2C_CR2 |= I2C_CR2_STOP;
3598  01c9 72125211      	bset	_I2C_CR2,#1
3600  01cd               L3332:
3601                     ; 90   while((I2C_CR2 & I2C_CR2_STOP) == 0); 
3603  01cd c65211        	ld	a,_I2C_CR2
3604  01d0 a502          	bcp	a,#2
3605  01d2 27f9          	jreq	L3332
3606                     ; 91   return I2C_SUCCESS;
3608  01d4 4f            	clr	a
3611  01d5 85            	popw	x
3612  01d6 81            	ret
3683                     ; 98 t_i2c_status i2c_rd_reg(unsigned char address, unsigned char reg_addr,
3683                     ; 99                               char * data, unsigned char length)
3683                     ; 100 {
3684                     	switch	.text
3685  01d7               _i2c_rd_reg:
3687  01d7 89            	pushw	x
3688       00000000      OFST:	set	0
3691  01d8               L3732:
3692                     ; 106   while((I2C_SR3 & I2C_SR3_BUSY) != 0);   
3694  01d8 c65219        	ld	a,_I2C_SR3
3695  01db a502          	bcp	a,#2
3696  01dd 26f9          	jrne	L3732
3697                     ; 108   I2C_CR2 |= I2C_CR2_ACK;
3699  01df 72145211      	bset	_I2C_CR2,#2
3700                     ; 111   I2C_CR2 |= I2C_CR2_START;
3702  01e3 72105211      	bset	_I2C_CR2,#0
3704  01e7               L1042:
3705                     ; 114   while((I2C_SR1 & I2C_SR1_SB) == 0);  
3707  01e7 c65217        	ld	a,_I2C_SR1
3708  01ea a501          	bcp	a,#1
3709  01ec 27f9          	jreq	L1042
3710                     ; 116   I2C_DR = address & 0xFE;
3712  01ee 7b01          	ld	a,(OFST+1,sp)
3713  01f0 a4fe          	and	a,#254
3714  01f2 c75216        	ld	_I2C_DR,a
3716  01f5               L1142:
3717                     ; 119   while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3719  01f5 c65217        	ld	a,_I2C_SR1
3720  01f8 a502          	bcp	a,#2
3721  01fa 27f9          	jreq	L1142
3722                     ; 121   temp = I2C_SR3;
3724  01fc 555219000a    	mov	_temp,_I2C_SR3
3726  0201               L1242:
3727                     ; 125   while((I2C_SR1 & I2C_SR1) == 0); 
3729  0201 c65217        	ld	a,_I2C_SR1
3730  0204 5f            	clrw	x
3731  0205 97            	ld	xl,a
3732  0206 a30000        	cpw	x,#0
3733  0209 27f6          	jreq	L1242
3734                     ; 127   I2C_DR = reg_addr;
3736  020b 7b02          	ld	a,(OFST+2,sp)
3737  020d c75216        	ld	_I2C_DR,a
3739  0210               L1342:
3740                     ; 130   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3742  0210 c65217        	ld	a,_I2C_SR1
3743  0213 a584          	bcp	a,#132
3744  0215 27f9          	jreq	L1342
3745                     ; 132   I2C_CR2 |= I2C_CR2_START;
3747  0217 72105211      	bset	_I2C_CR2,#0
3749  021b               L7342:
3750                     ; 135   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3752  021b c65217        	ld	a,_I2C_SR1
3753  021e a501          	bcp	a,#1
3754  0220 27f9          	jreq	L7342
3755                     ; 138   I2C_DR = address | 0x01;
3757  0222 7b01          	ld	a,(OFST+1,sp)
3758  0224 aa01          	or	a,#1
3759  0226 c75216        	ld	_I2C_DR,a
3760                     ; 142   if(length == 1){
3762  0229 7b07          	ld	a,(OFST+7,sp)
3763  022b a101          	cp	a,#1
3764  022d 2627          	jrne	L3442
3765                     ; 144     I2C_CR2 &= ~I2C_CR2_ACK;
3767  022f 72155211      	bres	_I2C_CR2,#2
3769  0233               L7442:
3770                     ; 147     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3772  0233 c65217        	ld	a,_I2C_SR1
3773  0236 a502          	bcp	a,#2
3774  0238 27f9          	jreq	L7442
3775                     ; 149     _asm ("SIM");  //on interupts
3778  023a 9b            SIM
3780                     ; 151     temp = I2C_SR3;
3782  023b 555219000a    	mov	_temp,_I2C_SR3
3783                     ; 154     I2C_CR2 |= I2C_CR2_STOP;
3785  0240 72125211      	bset	_I2C_CR2,#1
3786                     ; 156     _asm ("RIM");  //on interupts;
3789  0244 9a            RIM
3792  0245               L5542:
3793                     ; 160     while((I2C_SR1 & I2C_SR1_RXNE) == 0); 
3795  0245 c65217        	ld	a,_I2C_SR1
3796  0248 a540          	bcp	a,#64
3797  024a 27f9          	jreq	L5542
3798                     ; 162     *data = I2C_DR;
3800  024c 1e05          	ldw	x,(OFST+5,sp)
3801  024e c65216        	ld	a,_I2C_DR
3802  0251 f7            	ld	(x),a
3804  0252 ac370337      	jpf	L1552
3805  0256               L3442:
3806                     ; 165   else if(length == 2){
3808  0256 7b07          	ld	a,(OFST+7,sp)
3809  0258 a102          	cp	a,#2
3810  025a 263b          	jrne	L3642
3811                     ; 167     I2C_CR2 |= I2C_CR2_POS;
3813  025c 72165211      	bset	_I2C_CR2,#3
3815  0260               L7642:
3816                     ; 170     while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3818  0260 c65217        	ld	a,_I2C_SR1
3819  0263 a502          	bcp	a,#2
3820  0265 27f9          	jreq	L7642
3821                     ; 172     _asm ("SIM");  //on interupts;
3824  0267 9b            SIM
3826                     ; 174     temp = I2C_SR3;
3828  0268 555219000a    	mov	_temp,_I2C_SR3
3829                     ; 176     I2C_CR2 &= ~I2C_CR2_ACK;
3831  026d 72155211      	bres	_I2C_CR2,#2
3832                     ; 178     _asm ("RIM");  //on interupts;
3835  0271 9a            RIM
3838  0272               L5742:
3839                     ; 182     while((I2C_SR1 & I2C_SR1_BTF) == 0); 
3841  0272 c65217        	ld	a,_I2C_SR1
3842  0275 a504          	bcp	a,#4
3843  0277 27f9          	jreq	L5742
3844                     ; 184     _asm ("SIM");  //on interupts;
3847  0279 9b            SIM
3849                     ; 186     I2C_CR2 |= I2C_CR2_STOP;
3851  027a 72125211      	bset	_I2C_CR2,#1
3852                     ; 188     *data++ = I2C_DR;
3854  027e 1e05          	ldw	x,(OFST+5,sp)
3855  0280 1c0001        	addw	x,#1
3856  0283 1f05          	ldw	(OFST+5,sp),x
3857  0285 1d0001        	subw	x,#1
3858  0288 c65216        	ld	a,_I2C_DR
3859  028b f7            	ld	(x),a
3860                     ; 190     _asm ("RIM");  //on interupts;
3863  028c 9a            RIM
3865                     ; 191     *data = I2C_DR;
3867  028d 1e05          	ldw	x,(OFST+5,sp)
3868  028f c65216        	ld	a,_I2C_DR
3869  0292 f7            	ld	(x),a
3871  0293 ac370337      	jpf	L1552
3872  0297               L3642:
3873                     ; 194   else if(length > 2){
3875  0297 7b07          	ld	a,(OFST+7,sp)
3876  0299 a103          	cp	a,#3
3877  029b 2403          	jruge	L03
3878  029d cc0337        	jp	L1552
3879  02a0               L03:
3881  02a0               L7052:
3882                     ; 197     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3884  02a0 c65217        	ld	a,_I2C_SR1
3885  02a3 a502          	bcp	a,#2
3886  02a5 27f9          	jreq	L7052
3887                     ; 199     _asm ("SIM");  //on interupts;
3890  02a7 9b            SIM
3892                     ; 202     I2C_SR3;
3894  02a8 c65219        	ld	a,_I2C_SR3
3895                     ; 205     _asm ("RIM");  //on interupts;
3898  02ab 9a            RIM
3901  02ac 2015          	jra	L5152
3902  02ae               L3252:
3903                     ; 210       while((I2C_SR1 & I2C_SR1_BTF) == 0);
3905  02ae c65217        	ld	a,_I2C_SR1
3906  02b1 a504          	bcp	a,#4
3907  02b3 27f9          	jreq	L3252
3908                     ; 212       *data++ = I2C_DR;
3910  02b5 1e05          	ldw	x,(OFST+5,sp)
3911  02b7 1c0001        	addw	x,#1
3912  02ba 1f05          	ldw	(OFST+5,sp),x
3913  02bc 1d0001        	subw	x,#1
3914  02bf c65216        	ld	a,_I2C_DR
3915  02c2 f7            	ld	(x),a
3916  02c3               L5152:
3917                     ; 207     while(length-- > 3 && tmo){
3919  02c3 7b07          	ld	a,(OFST+7,sp)
3920  02c5 0a07          	dec	(OFST+7,sp)
3921  02c7 a104          	cp	a,#4
3922  02c9 2513          	jrult	L7252
3924  02cb ae0022        	ldw	x,#L7241_i2c_timeout
3925  02ce cd0000        	call	c_ltor
3927  02d1 ae0022        	ldw	x,#L7241_i2c_timeout
3928  02d4 a601          	ld	a,#1
3929  02d6 cd0000        	call	c_lgsbc
3931  02d9 cd0000        	call	c_lrzmp
3933  02dc 26d0          	jrne	L3252
3934  02de               L7252:
3935                     ; 215     if(!tmo) return I2C_TIMEOUT;
3937  02de ae0022        	ldw	x,#L7241_i2c_timeout
3938  02e1 cd0000        	call	c_ltor
3940  02e4 ae0022        	ldw	x,#L7241_i2c_timeout
3941  02e7 a601          	ld	a,#1
3942  02e9 cd0000        	call	c_lgsbc
3944  02ec cd0000        	call	c_lrzmp
3946  02ef 2604          	jrne	L5352
3949  02f1 a601          	ld	a,#1
3951  02f3 204e          	jra	L62
3952  02f5               L5352:
3953                     ; 221     while((I2C_SR1 & I2C_SR1_BTF) == 0);
3955  02f5 c65217        	ld	a,_I2C_SR1
3956  02f8 a504          	bcp	a,#4
3957  02fa 27f9          	jreq	L5352
3958                     ; 223     I2C_CR2 &= ~I2C_CR2_ACK;
3960  02fc 72155211      	bres	_I2C_CR2,#2
3961                     ; 225     _asm ("SIM");  //on interupts;
3964  0300 9b            SIM
3966                     ; 228     *data++ = I2C_DR;
3968  0301 1e05          	ldw	x,(OFST+5,sp)
3969  0303 1c0001        	addw	x,#1
3970  0306 1f05          	ldw	(OFST+5,sp),x
3971  0308 1d0001        	subw	x,#1
3972  030b c65216        	ld	a,_I2C_DR
3973  030e f7            	ld	(x),a
3974                     ; 230     I2C_CR2 |= I2C_CR2_STOP;
3976  030f 72125211      	bset	_I2C_CR2,#1
3977                     ; 232     *data++ = I2C_DR;
3979  0313 1e05          	ldw	x,(OFST+5,sp)
3980  0315 1c0001        	addw	x,#1
3981  0318 1f05          	ldw	(OFST+5,sp),x
3982  031a 1d0001        	subw	x,#1
3983  031d c65216        	ld	a,_I2C_DR
3984  0320 f7            	ld	(x),a
3985                     ; 234     _asm ("RIM");  //on interupts;
3988  0321 9a            RIM
3991  0322               L3452:
3992                     ; 237     while((I2C_SR1 & I2C_SR1_RXNE) == 0);
3994  0322 c65217        	ld	a,_I2C_SR1
3995  0325 a540          	bcp	a,#64
3996  0327 27f9          	jreq	L3452
3997                     ; 239     *data++ = I2C_DR;
3999  0329 1e05          	ldw	x,(OFST+5,sp)
4000  032b 1c0001        	addw	x,#1
4001  032e 1f05          	ldw	(OFST+5,sp),x
4002  0330 1d0001        	subw	x,#1
4003  0333 c65216        	ld	a,_I2C_DR
4004  0336 f7            	ld	(x),a
4005  0337               L1552:
4006                     ; 244   while((I2C_CR2 & I2C_CR2_STOP) == 0);
4008  0337 c65211        	ld	a,_I2C_CR2
4009  033a a502          	bcp	a,#2
4010  033c 27f9          	jreq	L1552
4011                     ; 246   I2C_CR2 &= ~I2C_CR2_POS;
4013  033e 72175211      	bres	_I2C_CR2,#3
4014                     ; 248   return I2C_SUCCESS;
4016  0342 4f            	clr	a
4018  0343               L62:
4020  0343 85            	popw	x
4021  0344 81            	ret
4044                     ; 254 void i2c_init(void)
4044                     ; 255  {
4045                     	switch	.text
4046  0345               _i2c_init:
4050                     ; 256  }
4053  0345 81            	ret
4087                     ; 257 void i2c_start(uint8_t rorw, uint8_t start_adr, uint8_t end_adr)        // OK
4087                     ; 258  {
4088                     	switch	.text
4089  0346               _i2c_start:
4093                     ; 259  }      //вроде норм
4096  0346 81            	ret
4119                     ; 260 void i2c_send_adress(void)      //   OK
4119                     ; 261  {
4120                     	switch	.text
4121  0347               _i2c_send_adress:
4125                     ; 262  }      //OK
4128  0347 81            	ret
4151                     ; 263 void i2c_send_data()
4151                     ; 264  {
4152                     	switch	.text
4153  0348               _i2c_send_data:
4157                     ; 265  }
4160  0348 81            	ret
4201                     ; 7 void timer1_start(void)
4201                     ; 8  {
4202                     	switch	.text
4203  0349               _timer1_start:
4207                     ; 9    TIM1_CR1 |= TIM1_CR1_CEN; //Запускаем таймер
4209  0349 72105250      	bset	_TIM1_CR1,#0
4210                     ; 10  }
4213  034d 81            	ret
4250                     ; 12 void timer2_start(uint16_t top_val)
4250                     ; 13 {
4251                     	switch	.text
4252  034e               _timer2_start:
4256                     ; 14   TIM2_ARRH =top_val >>8;
4258  034e 9e            	ld	a,xh
4259  034f c7530f        	ld	_TIM2_ARRH,a
4260                     ; 15   TIM2_ARRL =top_val & 0xFF;
4262  0352 9f            	ld	a,xl
4263  0353 a4ff          	and	a,#255
4264  0355 c75310        	ld	_TIM2_ARRL,a
4265                     ; 16   TIM2_CR1 |= TIM2_CR1_CEN;
4267  0358 72105300      	bset	_TIM2_CR1,#0
4268                     ; 17 }
4271  035c 81            	ret
4306                     ; 19 void Timer2_Overflow (void)
4306                     ; 20 {
4307                     	switch	.text
4308  035d               _Timer2_Overflow:
4312                     ; 21 	TIM2_SR1 = 0;
4314  035d 725f5304      	clr	_TIM2_SR1
4315                     ; 23 	if (lamp_number <= 3)
4317  0361 b600          	ld	a,_lamp_number
4318  0363 a104          	cp	a,#4
4319  0365 2415          	jruge	L7762
4320                     ; 25 			lamp_number_data = (1<<(lamp_number++));
4322  0367 b600          	ld	a,_lamp_number
4323  0369 97            	ld	xl,a
4324  036a 3c00          	inc	_lamp_number
4325  036c 9f            	ld	a,xl
4326  036d 5f            	clrw	x
4327  036e 97            	ld	xl,a
4328  036f a601          	ld	a,#1
4329  0371 5d            	tnzw	x
4330  0372 2704          	jreq	L05
4331  0374               L25:
4332  0374 48            	sll	a
4333  0375 5a            	decw	x
4334  0376 26fc          	jrne	L25
4335  0378               L05:
4336  0378 b720          	ld	_lamp_number_data,a
4338  037a 201d          	jra	L1072
4339  037c               L7762:
4340                     ; 27 		else if (lamp_number >= 4)
4342  037c b600          	ld	a,_lamp_number
4343  037e a104          	cp	a,#4
4344  0380 2517          	jrult	L1072
4345                     ; 29 			lamp_number = 1;
4347  0382 35010000      	mov	_lamp_number,#1
4348                     ; 30 			lamp_number_data = (1<<(lamp_number++));
4350  0386 b600          	ld	a,_lamp_number
4351  0388 97            	ld	xl,a
4352  0389 3c00          	inc	_lamp_number
4353  038b 9f            	ld	a,xl
4354  038c 5f            	clrw	x
4355  038d 97            	ld	xl,a
4356  038e a601          	ld	a,#1
4357  0390 5d            	tnzw	x
4358  0391 2704          	jreq	L45
4359  0393               L65:
4360  0393 48            	sll	a
4361  0394 5a            	decw	x
4362  0395 26fc          	jrne	L65
4363  0397               L45:
4364  0397 b720          	ld	_lamp_number_data,a
4365  0399               L1072:
4366                     ; 33 	switch (lamp_number)
4368  0399 b600          	ld	a,_lamp_number
4370                     ; 46 	break;
4371  039b 4d            	tnz	a
4372  039c 270b          	jreq	L7562
4373  039e 4a            	dec	a
4374  039f 270d          	jreq	L1662
4375  03a1 4a            	dec	a
4376  03a2 270f          	jreq	L3662
4377  03a4 4a            	dec	a
4378  03a5 2711          	jreq	L5662
4379  03a7 2012          	jra	L7072
4380  03a9               L7562:
4381                     ; 35 	case 0:
4381                     ; 36 	k155_data = hours_decades; 
4383  03a9 451121        	mov	_k155_data,_hours_decades
4384                     ; 37 	break;
4386  03ac 200d          	jra	L7072
4387  03ae               L1662:
4388                     ; 38 	case 1:
4388                     ; 39 	k155_data = hours;
4390  03ae 451621        	mov	_k155_data,_hours
4391                     ; 40 	break;
4393  03b1 2008          	jra	L7072
4394  03b3               L3662:
4395                     ; 41 	case 2:
4395                     ; 42 	k155_data = minutes_decades;
4397  03b3 451221        	mov	_k155_data,_minutes_decades
4398                     ; 43 	break;
4400  03b6 2003          	jra	L7072
4401  03b8               L5662:
4402                     ; 44 	case 3:
4402                     ; 45 	k155_data = minutes;
4404  03b8 451521        	mov	_k155_data,_minutes
4405                     ; 46 	break;
4407  03bb               L7072:
4408                     ; 48 	timers_int_off();
4410  03bb cd04b2        	call	_timers_int_off
4412                     ; 49 	PA_ODR &= (0<<3);
4414  03be 725f5000      	clr	_PA_ODR
4415                     ; 51 	SPI_Send(k155_data);
4417  03c2 b621          	ld	a,_k155_data
4418  03c4 cd05a9        	call	_SPI_Send
4420                     ; 53 	SPI_Send(lamp_number_data);
4422  03c7 b620          	ld	a,_lamp_number_data
4423  03c9 cd05a9        	call	_SPI_Send
4425                     ; 55 	PA_ODR |= (1<<3);
4427  03cc 72165000      	bset	_PA_ODR,#3
4428                     ; 56 	timers_int_on();
4430  03d0 cd04bb        	call	_timers_int_on
4432                     ; 57 	return;
4435  03d3 81            	ret
4466                     ; 60 void Timer1_Compare_1 (void)
4466                     ; 61 {
4467                     	switch	.text
4468  03d4               _Timer1_Compare_1:
4472                     ; 62 	TIM1_SR1 = 0;
4474  03d4 725f5255      	clr	_TIM1_SR1
4475                     ; 64 	i2c_rd_reg(0xD0, 0, &seconds, 1); 	
4477  03d8 4b01          	push	#1
4478  03da ae0014        	ldw	x,#_seconds
4479  03dd 89            	pushw	x
4480  03de aed000        	ldw	x,#53248
4481  03e1 cd01d7        	call	_i2c_rd_reg
4483  03e4 5b03          	addw	sp,#3
4484                     ; 65 	i2c_rd_reg(0xD0, 1, &minutes, 1);
4486  03e6 4b01          	push	#1
4487  03e8 ae0015        	ldw	x,#_minutes
4488  03eb 89            	pushw	x
4489  03ec aed001        	ldw	x,#53249
4490  03ef cd01d7        	call	_i2c_rd_reg
4492  03f2 5b03          	addw	sp,#3
4493                     ; 66 	i2c_rd_reg(0xD0, 2, &hours, 1);
4495  03f4 4b01          	push	#1
4496  03f6 ae0016        	ldw	x,#_hours
4497  03f9 89            	pushw	x
4498  03fa aed002        	ldw	x,#53250
4499  03fd cd01d7        	call	_i2c_rd_reg
4501  0400 5b03          	addw	sp,#3
4502                     ; 69 	seconds_decades = (seconds & 0xf0)>>4;
4504  0402 b614          	ld	a,_seconds
4505  0404 a4f0          	and	a,#240
4506  0406 4e            	swap	a
4507  0407 a40f          	and	a,#15
4508  0409 b713          	ld	_seconds_decades,a
4509                     ; 70 	minutes_decades = (minutes & 0xf0)>>4;
4511  040b b615          	ld	a,_minutes
4512  040d a4f0          	and	a,#240
4513  040f 4e            	swap	a
4514  0410 a40f          	and	a,#15
4515  0412 b712          	ld	_minutes_decades,a
4516                     ; 71 	hours_decades = (hours & 0xf0)>>4;
4518  0414 b616          	ld	a,_hours
4519  0416 a4f0          	and	a,#240
4520  0418 4e            	swap	a
4521  0419 a40f          	and	a,#15
4522  041b b711          	ld	_hours_decades,a
4523                     ; 73 	seconds &= 0x0f;
4525  041d b614          	ld	a,_seconds
4526  041f a40f          	and	a,#15
4527  0421 b714          	ld	_seconds,a
4528                     ; 74 	minutes &= 0x0f;
4530  0423 b615          	ld	a,_minutes
4531  0425 a40f          	and	a,#15
4532  0427 b715          	ld	_minutes,a
4533                     ; 75 	hours &= 0x0f;
4535  0429 b616          	ld	a,_hours
4536  042b a40f          	and	a,#15
4537  042d b716          	ld	_hours,a
4538                     ; 76 }
4541  042f 81            	ret
4591                     ; 83 void timer1_setup(uint16_t tim_freq, uint16_t top)
4591                     ; 84  {
4592                     	switch	.text
4593  0430               _timer1_setup:
4595  0430 89            	pushw	x
4596  0431 5204          	subw	sp,#4
4597       00000004      OFST:	set	4
4600                     ; 85   TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
4602  0433 cd0000        	call	c_uitolx
4604  0436 96            	ldw	x,sp
4605  0437 1c0001        	addw	x,#OFST-3
4606  043a cd0000        	call	c_rtol
4608  043d ae2400        	ldw	x,#9216
4609  0440 bf02          	ldw	c_lreg+2,x
4610  0442 ae00f4        	ldw	x,#244
4611  0445 bf00          	ldw	c_lreg,x
4612  0447 96            	ldw	x,sp
4613  0448 1c0001        	addw	x,#OFST-3
4614  044b cd0000        	call	c_ldiv
4616  044e a608          	ld	a,#8
4617  0450 cd0000        	call	c_lrsh
4619  0453 b603          	ld	a,c_lreg+3
4620  0455 c75260        	ld	_TIM1_PSCRH,a
4621                     ; 86   TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; //Делитель на 16
4623  0458 1e05          	ldw	x,(OFST+1,sp)
4624  045a cd0000        	call	c_uitolx
4626  045d 96            	ldw	x,sp
4627  045e 1c0001        	addw	x,#OFST-3
4628  0461 cd0000        	call	c_rtol
4630  0464 ae2400        	ldw	x,#9216
4631  0467 bf02          	ldw	c_lreg+2,x
4632  0469 ae00f4        	ldw	x,#244
4633  046c bf00          	ldw	c_lreg,x
4634  046e 96            	ldw	x,sp
4635  046f 1c0001        	addw	x,#OFST-3
4636  0472 cd0000        	call	c_ldiv
4638  0475 3f02          	clr	c_lreg+2
4639  0477 3f01          	clr	c_lreg+1
4640  0479 3f00          	clr	c_lreg
4641  047b b603          	ld	a,c_lreg+3
4642  047d c75261        	ld	_TIM1_PSCRL,a
4643                     ; 87   TIM1_ARRH = (top) >> 8; //Частота переполнений = 16М / 8 / 1000 = 2000 Гц
4645  0480 7b09          	ld	a,(OFST+5,sp)
4646  0482 c75262        	ld	_TIM1_ARRH,a
4647                     ; 88   TIM1_ARRL = (top)& 0xFF;
4649  0485 7b0a          	ld	a,(OFST+6,sp)
4650  0487 a4ff          	and	a,#255
4651  0489 c75263        	ld	_TIM1_ARRL,a
4652                     ; 90   TIM1_CR1 |= TIM1_CR1_URS; //Прерывание только по переполнению счетчика
4654  048c 72145250      	bset	_TIM1_CR1,#2
4655                     ; 91   TIM1_EGR |= TIM1_EGR_UG;  //Вызываем Update Event
4657  0490 72105257      	bset	_TIM1_EGR,#0
4658                     ; 92   TIM1_IER |= TIM1_IER_UIE; //Разрешаем прерывание
4660  0494 72105254      	bset	_TIM1_IER,#0
4661                     ; 93  }
4664  0498 5b06          	addw	sp,#6
4665  049a 81            	ret
4692                     ; 96 void timer2_setup(void)
4692                     ; 97  {
4693                     	switch	.text
4694  049b               _timer2_setup:
4698                     ; 99     TIM2_IER |= TIM2_IER_UIE;         //прерывание по переполнению
4700  049b 72105303      	bset	_TIM2_IER,#0
4701                     ; 100     TIM2_PSCR = 0;
4703  049f 725f530e      	clr	_TIM2_PSCR
4704                     ; 101     TIM2_ARRH = 0;
4706  04a3 725f530f      	clr	_TIM2_ARRH
4707                     ; 102     TIM2_ARRL = 0;
4709  04a7 725f5310      	clr	_TIM2_ARRL
4710                     ; 103  }
4713  04ab 81            	ret
4738                     ; 105  void Key_interrupt (void)
4738                     ; 106 {
4739                     	switch	.text
4740  04ac               _Key_interrupt:
4744                     ; 107   pins = PC_IDR;           //сохранили состояние порта
4746  04ac 55500b000c    	mov	_pins,_PC_IDR
4747                     ; 109 }
4750  04b1 81            	ret
4775                     ; 113 void timers_int_off(void)
4775                     ; 114 {
4776                     	switch	.text
4777  04b2               _timers_int_off:
4781                     ; 115 	TIM1_IER &= ~TIM1_IER_UIE;
4783  04b2 72115254      	bres	_TIM1_IER,#0
4784                     ; 116 	TIM2_IER &= ~TIM2_IER_UIE;
4786  04b6 72115303      	bres	_TIM2_IER,#0
4787                     ; 117 }
4790  04ba 81            	ret
4815                     ; 119 void timers_int_on(void)
4815                     ; 120 {
4816                     	switch	.text
4817  04bb               _timers_int_on:
4821                     ; 121 	TIM1_IER |= TIM1_IER_UIE;
4823  04bb 72105254      	bset	_TIM1_IER,#0
4824                     ; 122 	TIM2_IER |= TIM2_IER_UIE;
4826  04bf 72105303      	bset	_TIM2_IER,#0
4827                     ; 123 }
4830  04c3 81            	ret
4880                     ; 7 void time_recalculation(void)
4880                     ; 8 {
4881                     	switch	.text
4882  04c4               _time_recalculation:
4886                     ; 10   if ((minutes_decades != fresh_min & 0x70) && (((fresh_min & 0x70) >>4 == 3) || ((fresh_min & 0x70) >>4 == 0)))
4888  04c4 b612          	ld	a,_minutes_decades
4889  04c6 b11a          	cp	a,_fresh_min
4890  04c8 2705          	jreq	L67
4891  04ca ae0001        	ldw	x,#1
4892  04cd 2001          	jra	L001
4893  04cf               L67:
4894  04cf 5f            	clrw	x
4895  04d0               L001:
4896  04d0 01            	rrwa	x,a
4897  04d1 a570          	bcp	a,#112
4898  04d3 2718          	jreq	L1203
4900  04d5 b61a          	ld	a,_fresh_min
4901  04d7 a470          	and	a,#112
4902  04d9 4e            	swap	a
4903  04da a40f          	and	a,#15
4904  04dc 5f            	clrw	x
4905  04dd 97            	ld	xl,a
4906  04de a30003        	cpw	x,#3
4907  04e1 2706          	jreq	L3203
4909  04e3 b61a          	ld	a,_fresh_min
4910  04e5 a570          	bcp	a,#112
4911  04e7 2604          	jrne	L1203
4912  04e9               L3203:
4913                     ; 12      flags.time_refresh =1;  //флаг прогона циферок.
4915  04e9 72160001      	bset	_flags,#3
4916  04ed               L1203:
4917                     ; 16   seconds = fresh_sec & 0x0F;
4919  04ed b618          	ld	a,_fresh_sec
4920  04ef a40f          	and	a,#15
4921  04f1 b714          	ld	_seconds,a
4922                     ; 17   seconds_decades = fresh_sec & 0x70;
4924  04f3 b618          	ld	a,_fresh_sec
4925  04f5 a470          	and	a,#112
4926  04f7 b713          	ld	_seconds_decades,a
4927                     ; 19   minutes = fresh_min & 0x0F;
4929  04f9 b61a          	ld	a,_fresh_min
4930  04fb a40f          	and	a,#15
4931  04fd b715          	ld	_minutes,a
4932                     ; 20   minutes_decades = fresh_min & 0x70;
4934  04ff b61a          	ld	a,_fresh_min
4935  0501 a470          	and	a,#112
4936  0503 b712          	ld	_minutes_decades,a
4937                     ; 22   hours = fresh_hours & 0x0F;
4939  0505 b61c          	ld	a,_fresh_hours
4940  0507 a40f          	and	a,#15
4941  0509 b716          	ld	_hours,a
4942                     ; 23   hours_decades = fresh_hours & 0x10;
4944  050b b61c          	ld	a,_fresh_hours
4945  050d a410          	and	a,#16
4946  050f b711          	ld	_hours_decades,a
4947                     ; 25   if (hours_decades <=6)
4949  0511 b611          	ld	a,_hours_decades
4950  0513 a107          	cp	a,#7
4951  0515 2404          	jruge	L5203
4952                     ; 27      flags.night = 1;
4954  0517 72180001      	bset	_flags,#4
4955  051b               L5203:
4956                     ; 30 }
4959  051b 81            	ret
5024                     ; 35 void display(uint8_t lamp1, uint8_t lamp2, uint8_t lamp3, uint8_t lamp4 )
5024                     ; 36 {
5025                     	switch	.text
5026  051c               _display:
5028  051c 89            	pushw	x
5029       00000000      OFST:	set	0
5032                     ; 37   if ((lamp3_digit !=lamp3) && (lamp3 == 0x02 || 0x00))
5034  051d b603          	ld	a,_lamp3_digit
5035  051f 1105          	cp	a,(OFST+5,sp)
5036  0521 2704          	jreq	L1603
5038  0523 7b05          	ld	a,(OFST+5,sp)
5039  0525 a102          	cp	a,#2
5040  0527               L1603:
5041                     ; 41   lamp1_digit =lamp1;
5043  0527 7b01          	ld	a,(OFST+1,sp)
5044  0529 b701          	ld	_lamp1_digit,a
5045                     ; 42   lamp2_digit =lamp2;
5047  052b 7b02          	ld	a,(OFST+2,sp)
5048  052d b702          	ld	_lamp2_digit,a
5049                     ; 43   lamp3_digit =lamp3;
5051  052f 7b05          	ld	a,(OFST+5,sp)
5052  0531 b703          	ld	_lamp3_digit,a
5053                     ; 44   lamp4_digit =lamp4;
5055  0533 7b06          	ld	a,(OFST+6,sp)
5056  0535 b704          	ld	_lamp4_digit,a
5057                     ; 46 }
5060  0537 85            	popw	x
5061  0538 81            	ret
5094                     ; 48 void time_write(void)
5094                     ; 49 {
5095                     	switch	.text
5096  0539               _time_write:
5100                     ; 50 	timers_int_off();
5102  0539 cd04b2        	call	_timers_int_off
5104                     ; 52 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
5106  053c b61d          	ld	a,_fresh_hours_dec
5107  053e 97            	ld	xl,a
5108  053f a610          	ld	a,#16
5109  0541 42            	mul	x,a
5110  0542 9f            	ld	a,xl
5111  0543 bb1c          	add	a,_fresh_hours
5112  0545 b71c          	ld	_fresh_hours,a
5113                     ; 53 	fresh_min = fresh_min + (fresh_min_dec<<4);
5115  0547 b61b          	ld	a,_fresh_min_dec
5116  0549 97            	ld	xl,a
5117  054a a610          	ld	a,#16
5118  054c 42            	mul	x,a
5119  054d 9f            	ld	a,xl
5120  054e bb1a          	add	a,_fresh_min
5121  0550 b71a          	ld	_fresh_min,a
5122                     ; 54 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
5124  0552 b619          	ld	a,_fresh_sec_dec
5125  0554 97            	ld	xl,a
5126  0555 a610          	ld	a,#16
5127  0557 42            	mul	x,a
5128  0558 9f            	ld	a,xl
5129  0559 bb18          	add	a,_fresh_sec
5130  055b b718          	ld	_fresh_sec,a
5131                     ; 56 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
5133  055d 4b01          	push	#1
5134  055f ae001c        	ldw	x,#_fresh_hours
5135  0562 89            	pushw	x
5136  0563 ae0002        	ldw	x,#2
5137  0566 b60a          	ld	a,_ds_address
5138  0568 95            	ld	xh,a
5139  0569 cd0174        	call	_i2c_wr_reg
5141  056c 5b03          	addw	sp,#3
5142                     ; 57 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
5144  056e 4b01          	push	#1
5145  0570 ae001a        	ldw	x,#_fresh_min
5146  0573 89            	pushw	x
5147  0574 ae0001        	ldw	x,#1
5148  0577 b60a          	ld	a,_ds_address
5149  0579 95            	ld	xh,a
5150  057a cd0174        	call	_i2c_wr_reg
5152  057d 5b03          	addw	sp,#3
5153                     ; 58 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
5155  057f 4b01          	push	#1
5156  0581 ae0018        	ldw	x,#_fresh_sec
5157  0584 89            	pushw	x
5158  0585 5f            	clrw	x
5159  0586 b60a          	ld	a,_ds_address
5160  0588 95            	ld	xh,a
5161  0589 cd0174        	call	_i2c_wr_reg
5163  058c 5b03          	addw	sp,#3
5164                     ; 59 	timers_int_on();
5166  058e cd04bb        	call	_timers_int_on
5168                     ; 60 }
5171  0591 81            	ret
5212                     ; 1 void spi_setup(void)
5212                     ; 2  {
5213                     	switch	.text
5214  0592               _spi_setup:
5218                     ; 3     SPI_CR1=0x7C;       //ну тип вот
5220  0592 357c5200      	mov	_SPI_CR1,#124
5221                     ; 7  }
5224  0596 81            	ret
5250                     ; 8 void SPI_Send1 (void)   //отправка первого байта SPI
5250                     ; 9 {
5251                     	switch	.text
5252  0597               _SPI_Send1:
5256                     ; 10   SPI_DR = k155_data;
5258  0597 5500215204    	mov	_SPI_DR,_k155_data
5259                     ; 11   spi_queue++;
5261  059c 3c0b          	inc	_spi_queue
5262                     ; 12 }	
5265  059e 81            	ret
5291                     ; 14 void SPI_Send2 (void)   //отправка второго байта
5291                     ; 15 {
5292                     	switch	.text
5293  059f               _SPI_Send2:
5297                     ; 16   SPI_DR=lamp_number_data;
5299  059f 5500205204    	mov	_SPI_DR,_lamp_number_data
5300                     ; 17   spi_queue = 1;
5302  05a4 3501000b      	mov	_spi_queue,#1
5303                     ; 18 }
5306  05a8 81            	ret
5343                     ; 20 void SPI_Send(uint8_t msg)
5343                     ; 21 {
5344                     	switch	.text
5345  05a9               _SPI_Send:
5349                     ; 22 	SPI_DR = msg;
5351  05a9 c75204        	ld	_SPI_DR,a
5353  05ac 2005          	jra	L3513
5354  05ae               L7413:
5355                     ; 26 		temp = SPI_SR;
5357  05ae 555203000a    	mov	_temp,_SPI_SR
5358  05b3               L3513:
5359                     ; 24 	while((SPI_SR & SPI_SR_BSY) != 0)
5361  05b3 c65203        	ld	a,_SPI_SR
5362  05b6 a580          	bcp	a,#128
5363  05b8 26f4          	jrne	L7413
5364                     ; 28 }
5367  05ba 81            	ret
5409                     ; 4 void UART_Resieved (void)
5409                     ; 5 {
5410                     	switch	.text
5411  05bb               _UART_Resieved:
5415                     ; 7 	uart_routine(UART1_DR);
5417  05bb c65231        	ld	a,_UART1_DR
5418  05be cd002a        	call	_uart_routine
5420                     ; 8 }
5423  05c1 81            	ret
5448                     ; 10 void SPI_Transmitted(void)
5448                     ; 11 {
5449                     	switch	.text
5450  05c2               _SPI_Transmitted:
5454                     ; 15 	SPI_Send(temp3);
5456  05c2 b609          	ld	a,_temp3
5457  05c4 ade3          	call	_SPI_Send
5459                     ; 17 }
5462  05c6 81            	ret
5489                     ; 19 void I2C_Event(void)
5489                     ; 20 {
5490                     	switch	.text
5491  05c7               _I2C_Event:
5495                     ; 21 	temp = I2C_SR1;
5497  05c7 555217000a    	mov	_temp,_I2C_SR1
5498                     ; 22 	if ((I2C_SR1 & I2C_SR1_SB) == I2C_SR1_SB)
5500  05cc c65217        	ld	a,_I2C_SR1
5501  05cf a401          	and	a,#1
5502  05d1 a101          	cp	a,#1
5503  05d3 2605          	jrne	L5123
5504                     ; 24 				i2c_send_adress();
5506  05d5 cd0347        	call	_i2c_send_adress
5509  05d8 200e          	jra	L7123
5510  05da               L5123:
5511                     ; 26 			else if ((I2C_SR1 & I2C_SR1_ADDR) == I2C_SR1_ADDR)
5513  05da c65217        	ld	a,_I2C_SR1
5514  05dd a402          	and	a,#2
5515  05df a102          	cp	a,#2
5516  05e1 2602          	jrne	L1223
5517                     ; 28 				i2c_send_data;
5520  05e3 2003          	jra	L7123
5521  05e5               L1223:
5522                     ; 30 			else i2c_send_data();
5524  05e5 cd0348        	call	_i2c_send_data
5526  05e8               L7123:
5527                     ; 31 }
5530  05e8 81            	ret
5556                     ; 33 void Keys_switched(void)
5556                     ; 34 {
5557                     	switch	.text
5558  05e9               _Keys_switched:
5562                     ; 35 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
5564  05e9 c650a0        	ld	a,_EXTI_CR1
5565  05ec 43            	cpl	a
5566  05ed a430          	and	a,#48
5567  05ef c750a0        	ld	_EXTI_CR1,a
5568                     ; 36 	PC_CR2 = 0;
5570  05f2 725f500e      	clr	_PC_CR2
5571                     ; 37 	timer2_start(0xff);	
5573  05f6 ae00ff        	ldw	x,#255
5574  05f9 cd034e        	call	_timer2_start
5576                     ; 38 }
5579  05fc 81            	ret
5609                     ; 40 void time_refresh (void)
5609                     ; 41 {
5610                     	switch	.text
5611  05fd               _time_refresh:
5615                     ; 43 	i2c_rd_reg(0xD0, 0, &seconds, 1); 	
5617  05fd 4b01          	push	#1
5618  05ff ae0014        	ldw	x,#_seconds
5619  0602 89            	pushw	x
5620  0603 aed000        	ldw	x,#53248
5621  0606 cd01d7        	call	_i2c_rd_reg
5623  0609 5b03          	addw	sp,#3
5624                     ; 44 	i2c_rd_reg(0xD0, 1, &minutes, 1);
5626  060b 4b01          	push	#1
5627  060d ae0015        	ldw	x,#_minutes
5628  0610 89            	pushw	x
5629  0611 aed001        	ldw	x,#53249
5630  0614 cd01d7        	call	_i2c_rd_reg
5632  0617 5b03          	addw	sp,#3
5633                     ; 45 	i2c_rd_reg(0xD0, 2, &hours, 1);
5635  0619 4b01          	push	#1
5636  061b ae0016        	ldw	x,#_hours
5637  061e 89            	pushw	x
5638  061f aed002        	ldw	x,#53250
5639  0622 cd01d7        	call	_i2c_rd_reg
5641  0625 5b03          	addw	sp,#3
5642                     ; 48 	seconds_decades = (seconds & 0xf0)>>4;
5644  0627 b614          	ld	a,_seconds
5645  0629 a4f0          	and	a,#240
5646  062b 4e            	swap	a
5647  062c a40f          	and	a,#15
5648  062e b713          	ld	_seconds_decades,a
5649                     ; 49 	minutes_decades = (minutes & 0xf0)>>4;
5651  0630 b615          	ld	a,_minutes
5652  0632 a4f0          	and	a,#240
5653  0634 4e            	swap	a
5654  0635 a40f          	and	a,#15
5655  0637 b712          	ld	_minutes_decades,a
5656                     ; 50 	hours_decades = (hours & 0xf0)>>4;
5658  0639 b616          	ld	a,_hours
5659  063b a4f0          	and	a,#240
5660  063d 4e            	swap	a
5661  063e a40f          	and	a,#15
5662  0640 b711          	ld	_hours_decades,a
5663                     ; 52 	seconds &= 0x0f;
5665  0642 b614          	ld	a,_seconds
5666  0644 a40f          	and	a,#15
5667  0646 b714          	ld	_seconds,a
5668                     ; 53 	minutes &= 0x0f;
5670  0648 b615          	ld	a,_minutes
5671  064a a40f          	and	a,#15
5672  064c b715          	ld	_minutes,a
5673                     ; 54 	hours &= 0x0f;
5675  064e b616          	ld	a,_hours
5676  0650 a40f          	and	a,#15
5677  0652 b716          	ld	_hours,a
5678                     ; 55 }
5681  0654 81            	ret
5756                     ; 19 int main( void )
5756                     ; 20 {
5757                     	switch	.text
5758  0655               _main:
5762                     ; 21 		CLK_CKDIVR=0;                //нет делителей
5764  0655 725f50c6      	clr	_CLK_CKDIVR
5765                     ; 22 		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //тактирование на TIM1, UART1, SPI i I2C
5767  0659 35ff50c7      	mov	_CLK_PCKENR1,#255
5768                     ; 26     PA_DDR=(1<<3) | (1<<2); //0b000001000; //выход на защелку регистров, вход на сигнал с ртс
5770  065d 350c5002      	mov	_PA_DDR,#12
5771                     ; 27     PA_CR1= 0xff;        //на входах подтяги, на выходе пуш-пулл
5773  0661 35ff5003      	mov	_PA_CR1,#255
5774                     ; 28     PA_ODR |= (1<<3);
5776  0665 72165000      	bset	_PA_ODR,#3
5777                     ; 29 		PA_CR2 |=(1<<3);        //есть прерывания на PA1 для 1hz
5779  0669 72165004      	bset	_PA_CR2,#3
5780                     ; 31     PC_DDR=0x60; //0b01100000; // кнопочки на вход
5782  066d 3560500c      	mov	_PC_DDR,#96
5783                     ; 32     PC_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
5785  0671 35ff500d      	mov	_PC_CR1,#255
5786                     ; 33     PC_CR2 |= (1<<4) | (1<<3);        //есть прерывания на кнопках
5788  0675 c6500e        	ld	a,_PC_CR2
5789  0678 aa18          	or	a,#24
5790  067a c7500e        	ld	_PC_CR2,a
5791                     ; 35 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM на вход
5793  067d 35a85011      	mov	_PD_DDR,#168
5794                     ; 36     PD_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
5796  0681 35ff5012      	mov	_PD_CR1,#255
5797                     ; 37     PD_ODR = (1 << 3);
5799  0685 3508500f      	mov	_PD_ODR,#8
5800                     ; 43     spi_setup();
5802  0689 cd0592        	call	_spi_setup
5804                     ; 46 		uart_setup();
5806  068c cd0000        	call	_uart_setup
5808                     ; 47 		UART_Send('h');
5810  068f a668          	ld	a,#104
5811  0691 cd0019        	call	_UART_Send
5813                     ; 50     timer1_setup( 65500,0xffff);//частота в гц и топ значение
5815  0694 aeffff        	ldw	x,#65535
5816  0697 89            	pushw	x
5817  0698 aeffdc        	ldw	x,#65500
5818  069b cd0430        	call	_timer1_setup
5820  069e 85            	popw	x
5821                     ; 51 		timer2_setup();
5823  069f cd049b        	call	_timer2_setup
5825                     ; 52 		timer1_start();
5827  06a2 cd0349        	call	_timer1_start
5829                     ; 53 		timer2_start(TIM2_TOP);
5831  06a5 ae3e80        	ldw	x,#16000
5832  06a8 cd034e        	call	_timer2_start
5834                     ; 58 		i2c_master_init(16000000, 100000);
5836  06ab ae86a0        	ldw	x,#34464
5837  06ae 89            	pushw	x
5838  06af ae0001        	ldw	x,#1
5839  06b2 89            	pushw	x
5840  06b3 ae2400        	ldw	x,#9216
5841  06b6 89            	pushw	x
5842  06b7 ae00f4        	ldw	x,#244
5843  06ba 89            	pushw	x
5844  06bb cd00f6        	call	_i2c_master_init
5846  06be 5b08          	addw	sp,#8
5847                     ; 60 		timers_int_off();
5849  06c0 cd04b2        	call	_timers_int_off
5851                     ; 62 		i2c_rd_reg(ds_address, 7, &temp, 1);
5853  06c3 4b01          	push	#1
5854  06c5 ae000a        	ldw	x,#_temp
5855  06c8 89            	pushw	x
5856  06c9 ae0007        	ldw	x,#7
5857  06cc b60a          	ld	a,_ds_address
5858  06ce 95            	ld	xh,a
5859  06cf cd01d7        	call	_i2c_rd_reg
5861  06d2 5b03          	addw	sp,#3
5862                     ; 63 	if (temp != 0b10010000)	// if OUT and SWQ == 0
5864  06d4 b60a          	ld	a,_temp
5865  06d6 a190          	cp	a,#144
5866  06d8 2711          	jreq	L3623
5867                     ; 65 			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//Настройка 1Hz выхода
5869  06da 4b01          	push	#1
5870  06dc ae000b        	ldw	x,#_ds_cr
5871  06df 89            	pushw	x
5872  06e0 ae0007        	ldw	x,#7
5873  06e3 b60a          	ld	a,_ds_address
5874  06e5 95            	ld	xh,a
5875  06e6 cd0174        	call	_i2c_wr_reg
5877  06e9 5b03          	addw	sp,#3
5878  06eb               L3623:
5879                     ; 68 		i2c_rd_reg(ds_address, 0, time_pointer, 1);
5881  06eb 4b01          	push	#1
5882  06ed be06          	ldw	x,_time_pointer
5883  06ef 89            	pushw	x
5884  06f0 5f            	clrw	x
5885  06f1 b60a          	ld	a,_ds_address
5886  06f3 95            	ld	xh,a
5887  06f4 cd01d7        	call	_i2c_rd_reg
5889  06f7 5b03          	addw	sp,#3
5890                     ; 71 	if((seconds & 0x80) == 0x80)
5892  06f9 b614          	ld	a,_seconds
5893  06fb a480          	and	a,#128
5894  06fd a180          	cp	a,#128
5895  06ff 2610          	jrne	L5623
5896                     ; 73 		seconds = 0;
5898  0701 3f14          	clr	_seconds
5899                     ; 74 		i2c_wr_reg(ds_address, 0,time_pointer, 1);
5901  0703 4b01          	push	#1
5902  0705 be06          	ldw	x,_time_pointer
5903  0707 89            	pushw	x
5904  0708 5f            	clrw	x
5905  0709 b60a          	ld	a,_ds_address
5906  070b 95            	ld	xh,a
5907  070c cd0174        	call	_i2c_wr_reg
5909  070f 5b03          	addw	sp,#3
5910  0711               L5623:
5911                     ; 76 		i2c_rd_reg(ds_address, 0, &seconds, 1); 	
5913  0711 4b01          	push	#1
5914  0713 ae0014        	ldw	x,#_seconds
5915  0716 89            	pushw	x
5916  0717 5f            	clrw	x
5917  0718 b60a          	ld	a,_ds_address
5918  071a 95            	ld	xh,a
5919  071b cd01d7        	call	_i2c_rd_reg
5921  071e 5b03          	addw	sp,#3
5922                     ; 77 		i2c_rd_reg(ds_address, 1, &minutes, 1);
5924  0720 4b01          	push	#1
5925  0722 ae0015        	ldw	x,#_minutes
5926  0725 89            	pushw	x
5927  0726 ae0001        	ldw	x,#1
5928  0729 b60a          	ld	a,_ds_address
5929  072b 95            	ld	xh,a
5930  072c cd01d7        	call	_i2c_rd_reg
5932  072f 5b03          	addw	sp,#3
5933                     ; 78 		i2c_rd_reg(ds_address, 2, &hours, 1);
5935  0731 4b01          	push	#1
5936  0733 ae0016        	ldw	x,#_hours
5937  0736 89            	pushw	x
5938  0737 ae0002        	ldw	x,#2
5939  073a b60a          	ld	a,_ds_address
5940  073c 95            	ld	xh,a
5941  073d cd01d7        	call	_i2c_rd_reg
5943  0740 5b03          	addw	sp,#3
5944                     ; 80 		timers_int_on();
5946  0742 cd04bb        	call	_timers_int_on
5948                     ; 85 		_asm ("RIM");  //on interupts
5951  0745 9a            RIM
5953                     ; 87 		EXTI_CR1 = 0b00110011;//((1<<4) | (1<<0));//0x10;	//внешние прерывания на портах А и С по восходящему фронту 
5955  0746 353350a0      	mov	_EXTI_CR1,#51
5956                     ; 88 		EXTI_CR2 = 0b00000100;
5958  074a 350450a1      	mov	_EXTI_CR2,#4
5959  074e               L7623:
5960                     ; 91 		temp = PA_IDR;
5962  074e 555001000a    	mov	_temp,_PA_IDR
5963                     ; 92 		if(temp & 0b00000010 == 0b00000010)
5965  0753 b60a          	ld	a,_temp
5966  0755 a501          	bcp	a,#1
5967  0757 2707          	jreq	L3723
5968                     ; 94 			temp = PA_IDR;
5970  0759 555001000a    	mov	_temp,_PA_IDR
5972  075e 20ee          	jra	L7623
5973  0760               L3723:
5974                     ; 96 		else if ((temp & 0b00000000 == 0b00000000))
5976  0760 b60a          	ld	a,_temp
5977  0762 a501          	bcp	a,#1
5978  0764 27e8          	jreq	L7623
5979                     ; 98 			temp = PA_IDR;
5981  0766 555001000a    	mov	_temp,_PA_IDR
5982  076b 20e1          	jra	L7623
5995                     	xdef	_main
5996                     	xdef	_time_refresh
5997                     	xdef	_Keys_switched
5998                     	xdef	_I2C_Event
5999                     	xdef	_SPI_Transmitted
6000                     	xdef	_UART_Resieved
6001                     	xdef	_SPI_Send2
6002                     	xdef	_SPI_Send1
6003                     	xdef	_spi_setup
6004                     	xdef	_display
6005                     	xdef	_time_recalculation
6006                     	xdef	_Key_interrupt
6007                     	xdef	_timer2_setup
6008                     	xdef	_timer1_setup
6009                     	xdef	_Timer1_Compare_1
6010                     	xdef	_Timer2_Overflow
6011                     	xdef	_timer2_start
6012                     	xdef	_timer1_start
6013                     	xdef	_timers_int_on
6014                     	xdef	_timers_int_off
6015                     	xdef	_SPI_Send
6016                     	xdef	_i2c_send_data
6017                     	xdef	_i2c_send_adress
6018                     	xdef	_i2c_start
6019                     	xdef	_i2c_init
6020                     	xdef	_i2c_rd_reg
6021                     	xdef	_i2c_wr_reg
6022                     	xdef	_i2c_master_init
6023                     	xdef	_Two_keys_pressed
6024                     	xdef	_Inc_key_pressed
6025                     	xdef	_Menu_key_pressed
6026                     	xdef	_uart_routine
6027                     	xdef	_UART_Send
6028                     	xdef	_uart_setup
6029                     	xdef	_time_write
6030                     	switch	.ubsct
6031  0000               _i2c_flags:
6032  0000 00            	ds.b	1
6033                     	xdef	_i2c_flags
6034  0001               _flags:
6035  0001 00            	ds.b	1
6036                     	xdef	_flags
6037  0002               _cell_address:
6038  0002 00            	ds.b	1
6039                     	xdef	_cell_address
6040  0003               _data_type:
6041  0003 00            	ds.b	1
6042                     	xdef	_data_type
6043                     	xdef	_ds_cr
6044  0004               _i2c_current_adr:
6045  0004 00            	ds.b	1
6046                     	xdef	_i2c_current_adr
6047  0005               _i2c_end_adr:
6048  0005 00            	ds.b	1
6049                     	xdef	_i2c_end_adr
6050  0006               _i2c_start_adr:
6051  0006 00            	ds.b	1
6052                     	xdef	_i2c_start_adr
6053                     	xdef	_ds_address
6054  0007               _tunning:
6055  0007 00            	ds.b	1
6056                     	xdef	_tunning
6057  0008               _two_keys:
6058  0008 00            	ds.b	1
6059                     	xdef	_two_keys
6060  0009               _tunning_digits:
6061  0009 00            	ds.b	1
6062                     	xdef	_tunning_digits
6063                     	xdef	_temp3
6064                     	xdef	_temp2
6065  000a               _temp:
6066  000a 00            	ds.b	1
6067                     	xdef	_temp
6068  000b               _spi_queue:
6069  000b 00            	ds.b	1
6070                     	xdef	_spi_queue
6071  000c               _pins:
6072  000c 00            	ds.b	1
6073                     	xdef	_pins
6074  000d               _fresh_data_pointer:
6075  000d 0000          	ds.b	2
6076                     	xdef	_fresh_data_pointer
6077  000f               _data_pointer:
6078  000f 0000          	ds.b	2
6079                     	xdef	_data_pointer
6080                     	xdef	_time_pointer
6081  0011               _hours_decades:
6082  0011 00            	ds.b	1
6083                     	xdef	_hours_decades
6084  0012               _minutes_decades:
6085  0012 00            	ds.b	1
6086                     	xdef	_minutes_decades
6087  0013               _seconds_decades:
6088  0013 00            	ds.b	1
6089                     	xdef	_seconds_decades
6090  0014               _seconds:
6091  0014 00            	ds.b	1
6092                     	xdef	_seconds
6093  0015               _minutes:
6094  0015 00            	ds.b	1
6095                     	xdef	_minutes
6096  0016               _hours:
6097  0016 00            	ds.b	1
6098                     	xdef	_hours
6099  0017               _timeset:
6100  0017 00            	ds.b	1
6101                     	xdef	_timeset
6102  0018               _fresh_sec:
6103  0018 00            	ds.b	1
6104                     	xdef	_fresh_sec
6105  0019               _fresh_sec_dec:
6106  0019 00            	ds.b	1
6107                     	xdef	_fresh_sec_dec
6108  001a               _fresh_min:
6109  001a 00            	ds.b	1
6110                     	xdef	_fresh_min
6111  001b               _fresh_min_dec:
6112  001b 00            	ds.b	1
6113                     	xdef	_fresh_min_dec
6114  001c               _fresh_hours:
6115  001c 00            	ds.b	1
6116                     	xdef	_fresh_hours
6117  001d               _fresh_hours_dec:
6118  001d 00            	ds.b	1
6119                     	xdef	_fresh_hours_dec
6120  001e               _ds_tacts:
6121  001e 0000          	ds.b	2
6122                     	xdef	_ds_tacts
6123  0020               _lamp_number_data:
6124  0020 00            	ds.b	1
6125                     	xdef	_lamp_number_data
6126  0021               _k155_data:
6127  0021 00            	ds.b	1
6128                     	xdef	_k155_data
6129                     	xdef	_dots
6130                     	xdef	_lamp4_digit
6131                     	xdef	_lamp3_digit
6132                     	xdef	_lamp2_digit
6133                     	xdef	_lamp1_digit
6134                     	xdef	_lamp_number
6135  0022               L7241_i2c_timeout:
6136  0022 00000000      	ds.b	4
6137                     	xref.b	c_lreg
6138                     	xref.b	c_x
6158                     	xref	c_lrsh
6159                     	xref	c_ldiv
6160                     	xref	c_uitolx
6161                     	xref	c_lrzmp
6162                     	xref	c_lgsbc
6163                     	xref	c_ludv
6164                     	xref	c_rtol
6165                     	xref	c_ltor
6166                     	end
