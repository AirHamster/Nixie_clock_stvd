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
2198  0006 0016          	dc.w	_seconds
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
2999  0079 b612          	ld	a,_hours
3000  007b ab30          	add	a,#48
3001  007d ad9a          	call	_UART_Send
3003                     ; 46 			UART_Send(':');	
3005  007f a63a          	ld	a,#58
3006  0081 ad96          	call	_UART_Send
3008                     ; 47 			UART_Send(minutes_decades+0x30);
3010  0083 b613          	ld	a,_minutes_decades
3011  0085 ab30          	add	a,#48
3012  0087 ad90          	call	_UART_Send
3014                     ; 48 			UART_Send(minutes+0x30);
3016  0089 b614          	ld	a,_minutes
3017  008b ab30          	add	a,#48
3018  008d ad8a          	call	_UART_Send
3020                     ; 49 			UART_Send(':'); 
3022  008f a63a          	ld	a,#58
3023  0091 ad86          	call	_UART_Send
3025                     ; 50 			UART_Send(seconds_decades+0x30);
3027  0093 b615          	ld	a,_seconds_decades
3028  0095 ab30          	add	a,#48
3029  0097 ad80          	call	_UART_Send
3031                     ; 51 			UART_Send(seconds+0x30);
3033  0099 b616          	ld	a,_seconds
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
3164  00c4 3c12          	inc	_hours
3165                     ; 21      if (hours == 0x0A)
3167  00c6 b612          	ld	a,_hours
3168  00c8 a10a          	cp	a,#10
3169  00ca 2628          	jrne	L3312
3170                     ; 23         hours_decades++;
3172  00cc 3c11          	inc	_hours_decades
3173                     ; 24         hours =0;
3175  00ce 3f12          	clr	_hours
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
3193  00e0 3c14          	inc	_minutes
3194                     ; 34      if (minutes == 0x0A)
3196  00e2 b614          	ld	a,_minutes
3197  00e4 a10a          	cp	a,#10
3198  00e6 260c          	jrne	L3312
3199                     ; 36         minutes_decades++;
3201  00e8 3c13          	inc	_minutes_decades
3202                     ; 37         minutes =0;
3204  00ea 3f14          	clr	_minutes
3205                     ; 38         if (minutes_decades ==0x06)
3207  00ec b613          	ld	a,_minutes_decades
3208  00ee a106          	cp	a,#6
3209  00f0 2602          	jrne	L3312
3210                     ; 40            minutes_decades =0;
3212  00f2 3f13          	clr	_minutes_decades
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
4308                     ; 19 void Timer2_Overflow (void)
4308                     ; 20 {
4309                     	switch	.text
4310  035d               _Timer2_Overflow:
4314                     ; 21 	TIM2_SR1 = 0;
4316  035d 725f5304      	clr	_TIM2_SR1
4317                     ; 23 	if (lamp_number <= 3)
4319  0361 b600          	ld	a,_lamp_number
4320  0363 a104          	cp	a,#4
4321  0365 2415          	jruge	L7762
4322                     ; 25 			lamp_number_data = (1<<(lamp_number++));
4324  0367 b600          	ld	a,_lamp_number
4325  0369 97            	ld	xl,a
4326  036a 3c00          	inc	_lamp_number
4327  036c 9f            	ld	a,xl
4328  036d 5f            	clrw	x
4329  036e 97            	ld	xl,a
4330  036f a601          	ld	a,#1
4331  0371 5d            	tnzw	x
4332  0372 2704          	jreq	L05
4333  0374               L25:
4334  0374 48            	sll	a
4335  0375 5a            	decw	x
4336  0376 26fc          	jrne	L25
4337  0378               L05:
4338  0378 b720          	ld	_lamp_number_data,a
4340  037a 201d          	jra	L1072
4341  037c               L7762:
4342                     ; 27 		else if (lamp_number >= 4)
4344  037c b600          	ld	a,_lamp_number
4345  037e a104          	cp	a,#4
4346  0380 2517          	jrult	L1072
4347                     ; 29 			lamp_number = 1;
4349  0382 35010000      	mov	_lamp_number,#1
4350                     ; 30 			lamp_number_data = (1<<(lamp_number++));
4352  0386 b600          	ld	a,_lamp_number
4353  0388 97            	ld	xl,a
4354  0389 3c00          	inc	_lamp_number
4355  038b 9f            	ld	a,xl
4356  038c 5f            	clrw	x
4357  038d 97            	ld	xl,a
4358  038e a601          	ld	a,#1
4359  0390 5d            	tnzw	x
4360  0391 2704          	jreq	L45
4361  0393               L65:
4362  0393 48            	sll	a
4363  0394 5a            	decw	x
4364  0395 26fc          	jrne	L65
4365  0397               L45:
4366  0397 b720          	ld	_lamp_number_data,a
4367  0399               L1072:
4368                     ; 33 	switch (lamp_number)
4370  0399 b600          	ld	a,_lamp_number
4372                     ; 46 	break;
4373  039b 4d            	tnz	a
4374  039c 270b          	jreq	L7562
4375  039e 4a            	dec	a
4376  039f 270d          	jreq	L1662
4377  03a1 4a            	dec	a
4378  03a2 270f          	jreq	L3662
4379  03a4 4a            	dec	a
4380  03a5 2711          	jreq	L5662
4381  03a7 2012          	jra	L7072
4382  03a9               L7562:
4383                     ; 35 	case 0:
4383                     ; 36 	k155_data = hours_decades; 
4385  03a9 451121        	mov	_k155_data,_hours_decades
4386                     ; 37 	break;
4388  03ac 200d          	jra	L7072
4389  03ae               L1662:
4390                     ; 38 	case 1:
4390                     ; 39 	k155_data = hours;
4392  03ae 451221        	mov	_k155_data,_hours
4393                     ; 40 	break;
4395  03b1 2008          	jra	L7072
4396  03b3               L3662:
4397                     ; 41 	case 2:
4397                     ; 42 	k155_data = minutes_decades;
4399  03b3 451321        	mov	_k155_data,_minutes_decades
4400                     ; 43 	break;
4402  03b6 2003          	jra	L7072
4403  03b8               L5662:
4404                     ; 44 	case 3:
4404                     ; 45 	k155_data = minutes;
4406  03b8 451421        	mov	_k155_data,_minutes
4407                     ; 46 	break;
4409  03bb               L7072:
4410                     ; 48 	timers_int_off();
4412  03bb cd04b2        	call	_timers_int_off
4414                     ; 49 	PA_ODR &= (0<<3);
4416  03be 725f5000      	clr	_PA_ODR
4417                     ; 51 	SPI_Send(temp2);
4419  03c2 b608          	ld	a,_temp2
4420  03c4 cd05a9        	call	_SPI_Send
4422                     ; 53 	SPI_Send(temp3);
4424  03c7 b609          	ld	a,_temp3
4425  03c9 cd05a9        	call	_SPI_Send
4427                     ; 55 	PA_ODR |= (1<<3);
4429  03cc 72165000      	bset	_PA_ODR,#3
4430                     ; 56 	timers_int_on();
4432  03d0 cd04bb        	call	_timers_int_on
4434                     ; 57 	return;
4437  03d3 81            	ret
4468                     ; 60 void Timer1_Compare_1 (void)
4468                     ; 61 {
4469                     	switch	.text
4470  03d4               _Timer1_Compare_1:
4474                     ; 62 	TIM1_SR1 = 0;
4476  03d4 725f5255      	clr	_TIM1_SR1
4477                     ; 67 	i2c_rd_reg(0xD0, 0, &seconds, 1); 	
4479  03d8 4b01          	push	#1
4480  03da ae0016        	ldw	x,#_seconds
4481  03dd 89            	pushw	x
4482  03de aed000        	ldw	x,#53248
4483  03e1 cd01d7        	call	_i2c_rd_reg
4485  03e4 5b03          	addw	sp,#3
4486                     ; 68 	i2c_rd_reg(0xD0, 1, &minutes, 1);
4488  03e6 4b01          	push	#1
4489  03e8 ae0014        	ldw	x,#_minutes
4490  03eb 89            	pushw	x
4491  03ec aed001        	ldw	x,#53249
4492  03ef cd01d7        	call	_i2c_rd_reg
4494  03f2 5b03          	addw	sp,#3
4495                     ; 69 	i2c_rd_reg(0xD0, 2, &hours, 1);
4497  03f4 4b01          	push	#1
4498  03f6 ae0012        	ldw	x,#_hours
4499  03f9 89            	pushw	x
4500  03fa aed002        	ldw	x,#53250
4501  03fd cd01d7        	call	_i2c_rd_reg
4503  0400 5b03          	addw	sp,#3
4504                     ; 72 	seconds_decades = (seconds & 0xf0)>>4;
4506  0402 b616          	ld	a,_seconds
4507  0404 a4f0          	and	a,#240
4508  0406 4e            	swap	a
4509  0407 a40f          	and	a,#15
4510  0409 b715          	ld	_seconds_decades,a
4511                     ; 73 	minutes_decades = (minutes & 0xf0)>>4;
4513  040b b614          	ld	a,_minutes
4514  040d a4f0          	and	a,#240
4515  040f 4e            	swap	a
4516  0410 a40f          	and	a,#15
4517  0412 b713          	ld	_minutes_decades,a
4518                     ; 74 	hours_decades = (hours & 0xf0)>>4;
4520  0414 b612          	ld	a,_hours
4521  0416 a4f0          	and	a,#240
4522  0418 4e            	swap	a
4523  0419 a40f          	and	a,#15
4524  041b b711          	ld	_hours_decades,a
4525                     ; 76 	seconds &= 0x0f;
4527  041d b616          	ld	a,_seconds
4528  041f a40f          	and	a,#15
4529  0421 b716          	ld	_seconds,a
4530                     ; 77 	minutes &= 0x0f;
4532  0423 b614          	ld	a,_minutes
4533  0425 a40f          	and	a,#15
4534  0427 b714          	ld	_minutes,a
4535                     ; 78 	hours &= 0x0f;
4537  0429 b612          	ld	a,_hours
4538  042b a40f          	and	a,#15
4539  042d b712          	ld	_hours,a
4540                     ; 79 }
4543  042f 81            	ret
4593                     ; 86 void timer1_setup(uint16_t tim_freq, uint16_t top)
4593                     ; 87  {
4594                     	switch	.text
4595  0430               _timer1_setup:
4597  0430 89            	pushw	x
4598  0431 5204          	subw	sp,#4
4599       00000004      OFST:	set	4
4602                     ; 88   TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
4604  0433 cd0000        	call	c_uitolx
4606  0436 96            	ldw	x,sp
4607  0437 1c0001        	addw	x,#OFST-3
4608  043a cd0000        	call	c_rtol
4610  043d ae2400        	ldw	x,#9216
4611  0440 bf02          	ldw	c_lreg+2,x
4612  0442 ae00f4        	ldw	x,#244
4613  0445 bf00          	ldw	c_lreg,x
4614  0447 96            	ldw	x,sp
4615  0448 1c0001        	addw	x,#OFST-3
4616  044b cd0000        	call	c_ldiv
4618  044e a608          	ld	a,#8
4619  0450 cd0000        	call	c_lrsh
4621  0453 b603          	ld	a,c_lreg+3
4622  0455 c75260        	ld	_TIM1_PSCRH,a
4623                     ; 89   TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; //Делитель на 16
4625  0458 1e05          	ldw	x,(OFST+1,sp)
4626  045a cd0000        	call	c_uitolx
4628  045d 96            	ldw	x,sp
4629  045e 1c0001        	addw	x,#OFST-3
4630  0461 cd0000        	call	c_rtol
4632  0464 ae2400        	ldw	x,#9216
4633  0467 bf02          	ldw	c_lreg+2,x
4634  0469 ae00f4        	ldw	x,#244
4635  046c bf00          	ldw	c_lreg,x
4636  046e 96            	ldw	x,sp
4637  046f 1c0001        	addw	x,#OFST-3
4638  0472 cd0000        	call	c_ldiv
4640  0475 3f02          	clr	c_lreg+2
4641  0477 3f01          	clr	c_lreg+1
4642  0479 3f00          	clr	c_lreg
4643  047b b603          	ld	a,c_lreg+3
4644  047d c75261        	ld	_TIM1_PSCRL,a
4645                     ; 90   TIM1_ARRH = (top) >> 8; //Частота переполнений = 16М / 8 / 1000 = 2000 Гц
4647  0480 7b09          	ld	a,(OFST+5,sp)
4648  0482 c75262        	ld	_TIM1_ARRH,a
4649                     ; 91   TIM1_ARRL = (top)& 0xFF;
4651  0485 7b0a          	ld	a,(OFST+6,sp)
4652  0487 a4ff          	and	a,#255
4653  0489 c75263        	ld	_TIM1_ARRL,a
4654                     ; 93   TIM1_CR1 |= TIM1_CR1_URS; //Прерывание только по переполнению счетчика
4656  048c 72145250      	bset	_TIM1_CR1,#2
4657                     ; 94   TIM1_EGR |= TIM1_EGR_UG;  //Вызываем Update Event
4659  0490 72105257      	bset	_TIM1_EGR,#0
4660                     ; 95   TIM1_IER |= TIM1_IER_UIE; //Разрешаем прерывание
4662  0494 72105254      	bset	_TIM1_IER,#0
4663                     ; 96  }
4666  0498 5b06          	addw	sp,#6
4667  049a 81            	ret
4694                     ; 99 void timer2_setup(void)
4694                     ; 100  {
4695                     	switch	.text
4696  049b               _timer2_setup:
4700                     ; 102     TIM2_IER |= TIM2_IER_UIE;         //прерывание по переполнению
4702  049b 72105303      	bset	_TIM2_IER,#0
4703                     ; 103     TIM2_PSCR = 0;
4705  049f 725f530e      	clr	_TIM2_PSCR
4706                     ; 104     TIM2_ARRH = 0;
4708  04a3 725f530f      	clr	_TIM2_ARRH
4709                     ; 105     TIM2_ARRL = 0;
4711  04a7 725f5310      	clr	_TIM2_ARRL
4712                     ; 106  }
4715  04ab 81            	ret
4740                     ; 108  void Key_interrupt (void)
4740                     ; 109 {
4741                     	switch	.text
4742  04ac               _Key_interrupt:
4746                     ; 110   pins = PC_IDR;           //сохранили состояние порта
4748  04ac 55500b000c    	mov	_pins,_PC_IDR
4749                     ; 112 }
4752  04b1 81            	ret
4777                     ; 116 void timers_int_off(void)
4777                     ; 117 {
4778                     	switch	.text
4779  04b2               _timers_int_off:
4783                     ; 118 	TIM1_IER &= ~TIM1_IER_UIE;
4785  04b2 72115254      	bres	_TIM1_IER,#0
4786                     ; 119 	TIM2_IER &= ~TIM2_IER_UIE;
4788  04b6 72115303      	bres	_TIM2_IER,#0
4789                     ; 120 }
4792  04ba 81            	ret
4817                     ; 122 void timers_int_on(void)
4817                     ; 123 {
4818                     	switch	.text
4819  04bb               _timers_int_on:
4823                     ; 124 	TIM1_IER |= TIM1_IER_UIE;
4825  04bb 72105254      	bset	_TIM1_IER,#0
4826                     ; 125 	TIM2_IER |= TIM2_IER_UIE;
4828  04bf 72105303      	bset	_TIM2_IER,#0
4829                     ; 126 }
4832  04c3 81            	ret
4882                     ; 7 void time_recalculation(void)
4882                     ; 8 {
4883                     	switch	.text
4884  04c4               _time_recalculation:
4888                     ; 10   if ((minutes_decades != fresh_min & 0x70) && (((fresh_min & 0x70) >>4 == 3) || ((fresh_min & 0x70) >>4 == 0)))
4890  04c4 b613          	ld	a,_minutes_decades
4891  04c6 b11a          	cp	a,_fresh_min
4892  04c8 2705          	jreq	L67
4893  04ca ae0001        	ldw	x,#1
4894  04cd 2001          	jra	L001
4895  04cf               L67:
4896  04cf 5f            	clrw	x
4897  04d0               L001:
4898  04d0 01            	rrwa	x,a
4899  04d1 a570          	bcp	a,#112
4900  04d3 2718          	jreq	L1203
4902  04d5 b61a          	ld	a,_fresh_min
4903  04d7 a470          	and	a,#112
4904  04d9 4e            	swap	a
4905  04da a40f          	and	a,#15
4906  04dc 5f            	clrw	x
4907  04dd 97            	ld	xl,a
4908  04de a30003        	cpw	x,#3
4909  04e1 2706          	jreq	L3203
4911  04e3 b61a          	ld	a,_fresh_min
4912  04e5 a570          	bcp	a,#112
4913  04e7 2604          	jrne	L1203
4914  04e9               L3203:
4915                     ; 12      flags.time_refresh =1;  //флаг прогона циферок.
4917  04e9 72160001      	bset	_flags,#3
4918  04ed               L1203:
4919                     ; 16   seconds = fresh_sec & 0x0F;
4921  04ed b618          	ld	a,_fresh_sec
4922  04ef a40f          	and	a,#15
4923  04f1 b716          	ld	_seconds,a
4924                     ; 17   seconds_decades = fresh_sec & 0x70;
4926  04f3 b618          	ld	a,_fresh_sec
4927  04f5 a470          	and	a,#112
4928  04f7 b715          	ld	_seconds_decades,a
4929                     ; 19   minutes = fresh_min & 0x0F;
4931  04f9 b61a          	ld	a,_fresh_min
4932  04fb a40f          	and	a,#15
4933  04fd b714          	ld	_minutes,a
4934                     ; 20   minutes_decades = fresh_min & 0x70;
4936  04ff b61a          	ld	a,_fresh_min
4937  0501 a470          	and	a,#112
4938  0503 b713          	ld	_minutes_decades,a
4939                     ; 22   hours = fresh_hours & 0x0F;
4941  0505 b61c          	ld	a,_fresh_hours
4942  0507 a40f          	and	a,#15
4943  0509 b712          	ld	_hours,a
4944                     ; 23   hours_decades = fresh_hours & 0x10;
4946  050b b61c          	ld	a,_fresh_hours
4947  050d a410          	and	a,#16
4948  050f b711          	ld	_hours_decades,a
4949                     ; 25   if (hours_decades <=6)
4951  0511 b611          	ld	a,_hours_decades
4952  0513 a107          	cp	a,#7
4953  0515 2404          	jruge	L5203
4954                     ; 27      flags.night = 1;
4956  0517 72180001      	bset	_flags,#4
4957  051b               L5203:
4958                     ; 30 }
4961  051b 81            	ret
5026                     ; 35 void display(uint8_t lamp1, uint8_t lamp2, uint8_t lamp3, uint8_t lamp4 )
5026                     ; 36 {
5027                     	switch	.text
5028  051c               _display:
5030  051c 89            	pushw	x
5031       00000000      OFST:	set	0
5034                     ; 37   if ((lamp3_digit !=lamp3) && (lamp3 == 0x02 || 0x00))
5036  051d b603          	ld	a,_lamp3_digit
5037  051f 1105          	cp	a,(OFST+5,sp)
5038  0521 2704          	jreq	L1603
5040  0523 7b05          	ld	a,(OFST+5,sp)
5041  0525 a102          	cp	a,#2
5042  0527               L1603:
5043                     ; 41   lamp1_digit =lamp1;
5045  0527 7b01          	ld	a,(OFST+1,sp)
5046  0529 b701          	ld	_lamp1_digit,a
5047                     ; 42   lamp2_digit =lamp2;
5049  052b 7b02          	ld	a,(OFST+2,sp)
5050  052d b702          	ld	_lamp2_digit,a
5051                     ; 43   lamp3_digit =lamp3;
5053  052f 7b05          	ld	a,(OFST+5,sp)
5054  0531 b703          	ld	_lamp3_digit,a
5055                     ; 44   lamp4_digit =lamp4;
5057  0533 7b06          	ld	a,(OFST+6,sp)
5058  0535 b704          	ld	_lamp4_digit,a
5059                     ; 46 }
5062  0537 85            	popw	x
5063  0538 81            	ret
5096                     ; 48 void time_write(void)
5096                     ; 49 {
5097                     	switch	.text
5098  0539               _time_write:
5102                     ; 50 	timers_int_off();
5104  0539 cd04b2        	call	_timers_int_off
5106                     ; 52 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
5108  053c b61d          	ld	a,_fresh_hours_dec
5109  053e 97            	ld	xl,a
5110  053f a610          	ld	a,#16
5111  0541 42            	mul	x,a
5112  0542 9f            	ld	a,xl
5113  0543 bb1c          	add	a,_fresh_hours
5114  0545 b71c          	ld	_fresh_hours,a
5115                     ; 53 	fresh_min = fresh_min + (fresh_min_dec<<4);
5117  0547 b61b          	ld	a,_fresh_min_dec
5118  0549 97            	ld	xl,a
5119  054a a610          	ld	a,#16
5120  054c 42            	mul	x,a
5121  054d 9f            	ld	a,xl
5122  054e bb1a          	add	a,_fresh_min
5123  0550 b71a          	ld	_fresh_min,a
5124                     ; 54 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
5126  0552 b619          	ld	a,_fresh_sec_dec
5127  0554 97            	ld	xl,a
5128  0555 a610          	ld	a,#16
5129  0557 42            	mul	x,a
5130  0558 9f            	ld	a,xl
5131  0559 bb18          	add	a,_fresh_sec
5132  055b b718          	ld	_fresh_sec,a
5133                     ; 56 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
5135  055d 4b01          	push	#1
5136  055f ae001c        	ldw	x,#_fresh_hours
5137  0562 89            	pushw	x
5138  0563 ae0002        	ldw	x,#2
5139  0566 b60a          	ld	a,_ds_address
5140  0568 95            	ld	xh,a
5141  0569 cd0174        	call	_i2c_wr_reg
5143  056c 5b03          	addw	sp,#3
5144                     ; 57 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
5146  056e 4b01          	push	#1
5147  0570 ae001a        	ldw	x,#_fresh_min
5148  0573 89            	pushw	x
5149  0574 ae0001        	ldw	x,#1
5150  0577 b60a          	ld	a,_ds_address
5151  0579 95            	ld	xh,a
5152  057a cd0174        	call	_i2c_wr_reg
5154  057d 5b03          	addw	sp,#3
5155                     ; 58 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
5157  057f 4b01          	push	#1
5158  0581 ae0018        	ldw	x,#_fresh_sec
5159  0584 89            	pushw	x
5160  0585 5f            	clrw	x
5161  0586 b60a          	ld	a,_ds_address
5162  0588 95            	ld	xh,a
5163  0589 cd0174        	call	_i2c_wr_reg
5165  058c 5b03          	addw	sp,#3
5166                     ; 59 	timers_int_on();
5168  058e cd04bb        	call	_timers_int_on
5170                     ; 60 }
5173  0591 81            	ret
5214                     ; 1 void spi_setup(void)
5214                     ; 2  {
5215                     	switch	.text
5216  0592               _spi_setup:
5220                     ; 3     SPI_CR1=0x7C;       //ну тип вот
5222  0592 357c5200      	mov	_SPI_CR1,#124
5223                     ; 7  }
5226  0596 81            	ret
5252                     ; 8 void SPI_Send1 (void)   //отправка первого байта SPI
5252                     ; 9 {
5253                     	switch	.text
5254  0597               _SPI_Send1:
5258                     ; 10   SPI_DR = k155_data;
5260  0597 5500215204    	mov	_SPI_DR,_k155_data
5261                     ; 11   spi_queue++;
5263  059c 3c0b          	inc	_spi_queue
5264                     ; 12 }	
5267  059e 81            	ret
5293                     ; 14 void SPI_Send2 (void)   //отправка второго байта
5293                     ; 15 {
5294                     	switch	.text
5295  059f               _SPI_Send2:
5299                     ; 16   SPI_DR=lamp_number_data;
5301  059f 5500205204    	mov	_SPI_DR,_lamp_number_data
5302                     ; 17   spi_queue = 1;
5304  05a4 3501000b      	mov	_spi_queue,#1
5305                     ; 18 }
5308  05a8 81            	ret
5345                     ; 20 void SPI_Send(uint8_t msg)
5345                     ; 21 {
5346                     	switch	.text
5347  05a9               _SPI_Send:
5351                     ; 22 	SPI_DR = msg;
5353  05a9 c75204        	ld	_SPI_DR,a
5355  05ac 2005          	jra	L3513
5356  05ae               L7413:
5357                     ; 26 		temp = SPI_SR;
5359  05ae 555203000a    	mov	_temp,_SPI_SR
5360  05b3               L3513:
5361                     ; 24 	while((SPI_SR & SPI_SR_BSY) != 0)
5363  05b3 c65203        	ld	a,_SPI_SR
5364  05b6 a580          	bcp	a,#128
5365  05b8 26f4          	jrne	L7413
5366                     ; 28 }
5369  05ba 81            	ret
5411                     ; 4 void UART_Resieved (void)
5411                     ; 5 {
5412                     	switch	.text
5413  05bb               _UART_Resieved:
5417                     ; 7 	uart_routine(UART1_DR);
5419  05bb c65231        	ld	a,_UART1_DR
5420  05be cd002a        	call	_uart_routine
5422                     ; 8 }
5425  05c1 81            	ret
5450                     ; 10 void SPI_Transmitted(void)
5450                     ; 11 {
5451                     	switch	.text
5452  05c2               _SPI_Transmitted:
5456                     ; 15 	SPI_Send(temp3);
5458  05c2 b609          	ld	a,_temp3
5459  05c4 ade3          	call	_SPI_Send
5461                     ; 17 }
5464  05c6 81            	ret
5491                     ; 19 void I2C_Event(void)
5491                     ; 20 {
5492                     	switch	.text
5493  05c7               _I2C_Event:
5497                     ; 21 	temp = I2C_SR1;
5499  05c7 555217000a    	mov	_temp,_I2C_SR1
5500                     ; 22 	if ((I2C_SR1 & I2C_SR1_SB) == I2C_SR1_SB)
5502  05cc c65217        	ld	a,_I2C_SR1
5503  05cf a401          	and	a,#1
5504  05d1 a101          	cp	a,#1
5505  05d3 2605          	jrne	L5123
5506                     ; 24 				i2c_send_adress();
5508  05d5 cd0347        	call	_i2c_send_adress
5511  05d8 200e          	jra	L7123
5512  05da               L5123:
5513                     ; 26 			else if ((I2C_SR1 & I2C_SR1_ADDR) == I2C_SR1_ADDR)
5515  05da c65217        	ld	a,_I2C_SR1
5516  05dd a402          	and	a,#2
5517  05df a102          	cp	a,#2
5518  05e1 2602          	jrne	L1223
5519                     ; 28 				i2c_send_data;
5522  05e3 2003          	jra	L7123
5523  05e5               L1223:
5524                     ; 30 			else i2c_send_data();
5526  05e5 cd0348        	call	_i2c_send_data
5528  05e8               L7123:
5529                     ; 31 }
5532  05e8 81            	ret
5558                     ; 33 void Keys_switched(void)
5558                     ; 34 {
5559                     	switch	.text
5560  05e9               _Keys_switched:
5564                     ; 35 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
5566  05e9 c650a0        	ld	a,_EXTI_CR1
5567  05ec 43            	cpl	a
5568  05ed a430          	and	a,#48
5569  05ef c750a0        	ld	_EXTI_CR1,a
5570                     ; 36 	PC_CR2 = 0;
5572  05f2 725f500e      	clr	_PC_CR2
5573                     ; 37 	timer2_start(0xff);	
5575  05f6 ae00ff        	ldw	x,#255
5576  05f9 cd034e        	call	_timer2_start
5578                     ; 38 }
5581  05fc 81            	ret
5604                     ; 40 void DS_interrupt (void)
5604                     ; 41 {
5605                     	switch	.text
5606  05fd               _DS_interrupt:
5610                     ; 43 }
5613  05fd 81            	ret
5684                     ; 19 int main( void )
5684                     ; 20 {
5685                     	switch	.text
5686  05fe               _main:
5690                     ; 21 	CLK_CKDIVR=0;                //нет делителей
5692  05fe 725f50c6      	clr	_CLK_CKDIVR
5693                     ; 22   CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //тактирование на TIM1, UART1, SPI i I2C
5695  0602 35ff50c7      	mov	_CLK_PCKENR1,#255
5696                     ; 24 	EXTI_CR1 = 0x10; 
5698  0606 351050a0      	mov	_EXTI_CR1,#16
5699                     ; 27     PA_DDR=0x08; //0b000001000; //выход на защелку регистров, вход на сигнал с ртс
5701  060a 35085002      	mov	_PA_DDR,#8
5702                     ; 28     PA_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
5704  060e 35ff5003      	mov	_PA_CR1,#255
5705                     ; 29     PA_ODR |= (1<<3);
5707  0612 72165000      	bset	_PA_ODR,#3
5708                     ; 36     PC_DDR=0x60; //0b01100000; //SPI на выход, кнопочки на вход
5710  0616 3560500c      	mov	_PC_DDR,#96
5711                     ; 37     PC_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
5713  061a 35ff500d      	mov	_PC_CR1,#255
5714                     ; 39     PC_CR2 |= (1<<4) | (1<<3);        //есть прерывания
5716  061e c6500e        	ld	a,_PC_CR2
5717  0621 aa18          	or	a,#24
5718  0623 c7500e        	ld	_PC_CR2,a
5719                     ; 41 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM на вход
5721  0626 35a85011      	mov	_PD_DDR,#168
5722                     ; 42     PD_CR1=0xff;        //на входах подтяги, на выходе пуш-пулл
5724  062a 35ff5012      	mov	_PD_CR1,#255
5725                     ; 43     PD_ODR = (1 << 3);
5727  062e 3508500f      	mov	_PD_ODR,#8
5728                     ; 48 		i2c_master_init(16000000, 100000);
5730  0632 ae86a0        	ldw	x,#34464
5731  0635 89            	pushw	x
5732  0636 ae0001        	ldw	x,#1
5733  0639 89            	pushw	x
5734  063a ae2400        	ldw	x,#9216
5735  063d 89            	pushw	x
5736  063e ae00f4        	ldw	x,#244
5737  0641 89            	pushw	x
5738  0642 cd00f6        	call	_i2c_master_init
5740  0645 5b08          	addw	sp,#8
5741                     ; 50 		timers_int_off();
5743  0647 cd04b2        	call	_timers_int_off
5745                     ; 52 		i2c_rd_reg(0xD0, 0, time_pointer, 1);
5747  064a 4b01          	push	#1
5748  064c be06          	ldw	x,_time_pointer
5749  064e 89            	pushw	x
5750  064f aed000        	ldw	x,#53248
5751  0652 cd01d7        	call	_i2c_rd_reg
5753  0655 5b03          	addw	sp,#3
5754                     ; 53 		i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//Настройка 1Hz выхода
5756  0657 4b01          	push	#1
5757  0659 ae000b        	ldw	x,#_ds_cr
5758  065c 89            	pushw	x
5759  065d ae0007        	ldw	x,#7
5760  0660 b60a          	ld	a,_ds_address
5761  0662 95            	ld	xh,a
5762  0663 cd0174        	call	_i2c_wr_reg
5764  0666 5b03          	addw	sp,#3
5765                     ; 55 	if((seconds & 0x80) == 0x80)
5767  0668 b616          	ld	a,_seconds
5768  066a a480          	and	a,#128
5769  066c a180          	cp	a,#128
5770  066e 2610          	jrne	L3623
5771                     ; 57 		seconds = 0;
5773  0670 3f16          	clr	_seconds
5774                     ; 58 		i2c_wr_reg(ds_address, 0,time_pointer, 1);
5776  0672 4b01          	push	#1
5777  0674 be06          	ldw	x,_time_pointer
5778  0676 89            	pushw	x
5779  0677 5f            	clrw	x
5780  0678 b60a          	ld	a,_ds_address
5781  067a 95            	ld	xh,a
5782  067b cd0174        	call	_i2c_wr_reg
5784  067e 5b03          	addw	sp,#3
5785  0680               L3623:
5786                     ; 60 		i2c_rd_reg(0xD0, 0, &seconds, 1); 	
5788  0680 4b01          	push	#1
5789  0682 ae0016        	ldw	x,#_seconds
5790  0685 89            	pushw	x
5791  0686 aed000        	ldw	x,#53248
5792  0689 cd01d7        	call	_i2c_rd_reg
5794  068c 5b03          	addw	sp,#3
5795                     ; 61 		i2c_rd_reg(0xD0, 1, &minutes, 1);
5797  068e 4b01          	push	#1
5798  0690 ae0014        	ldw	x,#_minutes
5799  0693 89            	pushw	x
5800  0694 aed001        	ldw	x,#53249
5801  0697 cd01d7        	call	_i2c_rd_reg
5803  069a 5b03          	addw	sp,#3
5804                     ; 62 		i2c_rd_reg(0xD0, 2, &hours, 1);
5806  069c 4b01          	push	#1
5807  069e ae0012        	ldw	x,#_hours
5808  06a1 89            	pushw	x
5809  06a2 aed002        	ldw	x,#53250
5810  06a5 cd01d7        	call	_i2c_rd_reg
5812  06a8 5b03          	addw	sp,#3
5813                     ; 64 		timers_int_on();
5815  06aa cd04bb        	call	_timers_int_on
5817                     ; 67     spi_setup();
5819  06ad cd0592        	call	_spi_setup
5821                     ; 72 		uart_setup();
5823  06b0 cd0000        	call	_uart_setup
5825                     ; 73 		UART_Send('h');
5827  06b3 a668          	ld	a,#104
5828  06b5 cd0019        	call	_UART_Send
5830                     ; 76     timer1_setup( 65500,0xffff);//частота в гц и топ значение
5832  06b8 aeffff        	ldw	x,#65535
5833  06bb 89            	pushw	x
5834  06bc aeffdc        	ldw	x,#65500
5835  06bf cd0430        	call	_timer1_setup
5837  06c2 85            	popw	x
5838                     ; 77 		timer2_setup();
5840  06c3 cd049b        	call	_timer2_setup
5842                     ; 78 		timer1_start();
5844  06c6 cd0349        	call	_timer1_start
5846                     ; 79 		timer2_start(TIM2_TOP);
5848  06c9 ae3e80        	ldw	x,#16000
5849  06cc cd034e        	call	_timer2_start
5851                     ; 83 		UART_Send(seconds);
5853  06cf b616          	ld	a,_seconds
5854  06d1 cd0019        	call	_UART_Send
5856                     ; 85 		_asm ("RIM");  //on interupts
5859  06d4 9a            RIM
5861  06d5               L5623:
5862                     ; 90 	while(1);
5864  06d5 20fe          	jra	L5623
5877                     	xdef	_main
5878                     	xdef	_DS_interrupt
5879                     	xdef	_Keys_switched
5880                     	xdef	_I2C_Event
5881                     	xdef	_SPI_Transmitted
5882                     	xdef	_UART_Resieved
5883                     	xdef	_SPI_Send2
5884                     	xdef	_SPI_Send1
5885                     	xdef	_spi_setup
5886                     	xdef	_display
5887                     	xdef	_time_recalculation
5888                     	xdef	_Key_interrupt
5889                     	xdef	_timer2_setup
5890                     	xdef	_timer1_setup
5891                     	xdef	_Timer1_Compare_1
5892                     	xdef	_Timer2_Overflow
5893                     	xdef	_timer2_start
5894                     	xdef	_timer1_start
5895                     	xdef	_timers_int_on
5896                     	xdef	_timers_int_off
5897                     	xdef	_SPI_Send
5898                     	xdef	_i2c_send_data
5899                     	xdef	_i2c_send_adress
5900                     	xdef	_i2c_start
5901                     	xdef	_i2c_init
5902                     	xdef	_i2c_rd_reg
5903                     	xdef	_i2c_wr_reg
5904                     	xdef	_i2c_master_init
5905                     	xdef	_Two_keys_pressed
5906                     	xdef	_Inc_key_pressed
5907                     	xdef	_Menu_key_pressed
5908                     	xdef	_uart_routine
5909                     	xdef	_UART_Send
5910                     	xdef	_uart_setup
5911                     	xdef	_time_write
5912                     	switch	.ubsct
5913  0000               _i2c_flags:
5914  0000 00            	ds.b	1
5915                     	xdef	_i2c_flags
5916  0001               _flags:
5917  0001 00            	ds.b	1
5918                     	xdef	_flags
5919  0002               _cell_address:
5920  0002 00            	ds.b	1
5921                     	xdef	_cell_address
5922  0003               _data_type:
5923  0003 00            	ds.b	1
5924                     	xdef	_data_type
5925                     	xdef	_ds_cr
5926  0004               _i2c_current_adr:
5927  0004 00            	ds.b	1
5928                     	xdef	_i2c_current_adr
5929  0005               _i2c_end_adr:
5930  0005 00            	ds.b	1
5931                     	xdef	_i2c_end_adr
5932  0006               _i2c_start_adr:
5933  0006 00            	ds.b	1
5934                     	xdef	_i2c_start_adr
5935                     	xdef	_ds_address
5936  0007               _tunning:
5937  0007 00            	ds.b	1
5938                     	xdef	_tunning
5939  0008               _two_keys:
5940  0008 00            	ds.b	1
5941                     	xdef	_two_keys
5942  0009               _tunning_digits:
5943  0009 00            	ds.b	1
5944                     	xdef	_tunning_digits
5945                     	xdef	_temp3
5946                     	xdef	_temp2
5947  000a               _temp:
5948  000a 00            	ds.b	1
5949                     	xdef	_temp
5950  000b               _spi_queue:
5951  000b 00            	ds.b	1
5952                     	xdef	_spi_queue
5953  000c               _pins:
5954  000c 00            	ds.b	1
5955                     	xdef	_pins
5956  000d               _fresh_data_pointer:
5957  000d 0000          	ds.b	2
5958                     	xdef	_fresh_data_pointer
5959  000f               _data_pointer:
5960  000f 0000          	ds.b	2
5961                     	xdef	_data_pointer
5962                     	xdef	_time_pointer
5963  0011               _hours_decades:
5964  0011 00            	ds.b	1
5965                     	xdef	_hours_decades
5966  0012               _hours:
5967  0012 00            	ds.b	1
5968                     	xdef	_hours
5969  0013               _minutes_decades:
5970  0013 00            	ds.b	1
5971                     	xdef	_minutes_decades
5972  0014               _minutes:
5973  0014 00            	ds.b	1
5974                     	xdef	_minutes
5975  0015               _seconds_decades:
5976  0015 00            	ds.b	1
5977                     	xdef	_seconds_decades
5978  0016               _seconds:
5979  0016 00            	ds.b	1
5980                     	xdef	_seconds
5981  0017               _timeset:
5982  0017 00            	ds.b	1
5983                     	xdef	_timeset
5984  0018               _fresh_sec:
5985  0018 00            	ds.b	1
5986                     	xdef	_fresh_sec
5987  0019               _fresh_sec_dec:
5988  0019 00            	ds.b	1
5989                     	xdef	_fresh_sec_dec
5990  001a               _fresh_min:
5991  001a 00            	ds.b	1
5992                     	xdef	_fresh_min
5993  001b               _fresh_min_dec:
5994  001b 00            	ds.b	1
5995                     	xdef	_fresh_min_dec
5996  001c               _fresh_hours:
5997  001c 00            	ds.b	1
5998                     	xdef	_fresh_hours
5999  001d               _fresh_hours_dec:
6000  001d 00            	ds.b	1
6001                     	xdef	_fresh_hours_dec
6002  001e               _ds_tacts:
6003  001e 0000          	ds.b	2
6004                     	xdef	_ds_tacts
6005  0020               _lamp_number_data:
6006  0020 00            	ds.b	1
6007                     	xdef	_lamp_number_data
6008  0021               _k155_data:
6009  0021 00            	ds.b	1
6010                     	xdef	_k155_data
6011                     	xdef	_dots
6012                     	xdef	_lamp4_digit
6013                     	xdef	_lamp3_digit
6014                     	xdef	_lamp2_digit
6015                     	xdef	_lamp1_digit
6016                     	xdef	_lamp_number
6017  0022               L7241_i2c_timeout:
6018  0022 00000000      	ds.b	4
6019                     	xref.b	c_lreg
6020                     	xref.b	c_x
6040                     	xref	c_lrsh
6041                     	xref	c_ldiv
6042                     	xref	c_uitolx
6043                     	xref	c_lrzmp
6044                     	xref	c_lgsbc
6045                     	xref	c_ludv
6046                     	xref	c_rtol
6047                     	xref	c_ltor
6048                     	end
