   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2184                     	bsct
2185  0000               _lamp_number:
2186  0000 00            	dc.b	0
2187  0001               _dots:
2188  0001 00            	dc.b	0
2189  0002               _dots_upd:
2190  0002 1f40          	dc.w	8000
2191  0004               _dots_on:
2192  0004 0001          	dc.w	1
2193  0006               _time_pointer:
2194  0006 000c          	dc.w	_seconds
2195  0008               _temp2:
2196  0008 00            	dc.b	0
2197  0009               _temp3:
2198  0009 33            	dc.b	51
2199  000a               _schetchik:
2200  000a 00            	dc.b	0
2201  000b               _i:
2202  000b 0000          	dc.w	0
2203  000d               _schetchik2:
2204  000d 00            	dc.b	0
2205  000e               _ds_cr:
2206  000e 90            	dc.b	144
2207  000f               _tim1comp:
2208  000f 173e          	dc.w	5950
2705                     ; 2  void uart_setup(void)
2705                     ; 3  {
2707                     	switch	.text
2708  0000               _uart_setup:
2712                     ; 4 		UART1_BRR1=0x68;     //9600 bod
2714  0000 35685232      	mov	_UART1_BRR1,#104
2715                     ; 5     UART1_BRR2=0x03;
2717  0004 35035233      	mov	_UART1_BRR2,#3
2718                     ; 6     UART1_CR2 |= UART1_CR2_REN; //reseiving
2720  0008 72145235      	bset	_UART1_CR2,#2
2721                     ; 7     UART1_CR2 |= UART1_CR2_TEN; //transmiting 
2723  000c 72165235      	bset	_UART1_CR2,#3
2724                     ; 8     UART1_CR2 |= UART1_CR2_RIEN; //reseive int
2726  0010 721a5235      	bset	_UART1_CR2,#5
2727                     ; 9 		UART1_SR = 0;
2729  0014 725f5230      	clr	_UART1_SR
2730                     ; 10  }
2733  0018 81            	ret
2770                     ; 12 void uart_send(uint8_t msg)
2770                     ; 13  {
2771                     	switch	.text
2772  0019               _uart_send:
2774  0019 88            	push	a
2775       00000000      OFST:	set	0
2778                     ; 14 	 temp =msg;
2780  001a b703          	ld	_temp,a
2782  001c               L7771:
2783                     ; 15 	 while((UART1_SR & 0x80) == 0x00);
2785  001c c65230        	ld	a,_UART1_SR
2786  001f a580          	bcp	a,#128
2787  0021 27f9          	jreq	L7771
2788                     ; 16 	 UART1_DR = msg;
2790  0023 7b01          	ld	a,(OFST+1,sp)
2791  0025 c75231        	ld	_UART1_DR,a
2792                     ; 17  }
2795  0028 84            	pop	a
2796  0029 81            	ret
2842                     ; 18  void uart_routine(uint8_t data)
2842                     ; 19  {
2843                     	switch	.text
2844  002a               _uart_routine:
2846  002a 88            	push	a
2847       00000000      OFST:	set	0
2850                     ; 21 	 temp2 = data - 0x30;
2852  002b a030          	sub	a,#48
2853  002d b708          	ld	_temp2,a
2854                     ; 22 	 if (timeset != 0 && timeset <= 5)
2856  002f 3d0f          	tnz	_timeset
2857  0031 2719          	jreq	L1202
2859  0033 b60f          	ld	a,_timeset
2860  0035 a106          	cp	a,#6
2861  0037 2413          	jruge	L1202
2862                     ; 24 		* fresh_data_pointer-- = data-0x30;
2864  0039 7b01          	ld	a,(OFST+1,sp)
2865  003b a030          	sub	a,#48
2866  003d be05          	ldw	x,_fresh_data_pointer
2867  003f 1d0001        	subw	x,#1
2868  0042 bf05          	ldw	_fresh_data_pointer,x
2869  0044 1c0001        	addw	x,#1
2870  0047 f7            	ld	(x),a
2871                     ; 25 		 timeset++;
2873  0048 3c0f          	inc	_timeset
2874                     ; 26 		 return ;
2877  004a 84            	pop	a
2878  004b 81            	ret
2879  004c               L1202:
2880                     ; 28 	 if (timeset == 6)
2882  004c b60f          	ld	a,_timeset
2883  004e a106          	cp	a,#6
2884  0050 2616          	jrne	L3202
2885                     ; 30 		 *fresh_data_pointer = data-0x30;
2887  0052 7b01          	ld	a,(OFST+1,sp)
2888  0054 a030          	sub	a,#48
2889  0056 92c705        	ld	[_fresh_data_pointer.w],a
2890                     ; 31 		 timeset = 0;
2892  0059 3f0f          	clr	_timeset
2893                     ; 32 		 time_write();
2895  005b cd050c        	call	_time_write
2897                     ; 33 		 uart_send('O');
2899  005e a64f          	ld	a,#79
2900  0060 adb7          	call	_uart_send
2902                     ; 34 		 uart_send('K');
2904  0062 a64b          	ld	a,#75
2905  0064 adb3          	call	_uart_send
2907                     ; 35 		 return;
2910  0066 84            	pop	a
2911  0067 81            	ret
2912  0068               L3202:
2913                     ; 38 	 if (data == 's')
2915  0068 7b01          	ld	a,(OFST+1,sp)
2916  006a a173          	cp	a,#115
2917  006c 260b          	jrne	L5202
2918                     ; 40 			timeset = 1;
2920  006e 3501000f      	mov	_timeset,#1
2921                     ; 41 			fresh_data_pointer = &fresh_hours_dec;
2923  0072 ae0015        	ldw	x,#_fresh_hours_dec
2924  0075 bf05          	ldw	_fresh_data_pointer,x
2925                     ; 42 			return;
2928  0077 84            	pop	a
2929  0078 81            	ret
2930  0079               L5202:
2931                     ; 46 		if (data == 't')
2933  0079 7b01          	ld	a,(OFST+1,sp)
2934  007b a174          	cp	a,#116
2935  007d 2635          	jrne	L7202
2936                     ; 48 			uart_send(hours_tens+0x30);
2938  007f b609          	ld	a,_hours_tens
2939  0081 ab30          	add	a,#48
2940  0083 ad94          	call	_uart_send
2942                     ; 49 			uart_send(hours+0x30);
2944  0085 b60e          	ld	a,_hours
2945  0087 ab30          	add	a,#48
2946  0089 ad8e          	call	_uart_send
2948                     ; 50 			uart_send(':');	
2950  008b a63a          	ld	a,#58
2951  008d ad8a          	call	_uart_send
2953                     ; 51 			uart_send(minutes_tens+0x30);
2955  008f b60a          	ld	a,_minutes_tens
2956  0091 ab30          	add	a,#48
2957  0093 ad84          	call	_uart_send
2959                     ; 52 			uart_send(minutes+0x30);
2961  0095 b60d          	ld	a,_minutes
2962  0097 ab30          	add	a,#48
2963  0099 cd0019        	call	_uart_send
2965                     ; 53 			uart_send(':'); 
2967  009c a63a          	ld	a,#58
2968  009e cd0019        	call	_uart_send
2970                     ; 54 			uart_send(seconds_tens+0x30);
2972  00a1 b60b          	ld	a,_seconds_tens
2973  00a3 ab30          	add	a,#48
2974  00a5 cd0019        	call	_uart_send
2976                     ; 55 			uart_send(seconds+0x30);
2978  00a8 b60c          	ld	a,_seconds
2979  00aa ab30          	add	a,#48
2980  00ac cd0019        	call	_uart_send
2982                     ; 56 			uart_send(0x0A);
2984  00af a60a          	ld	a,#10
2985  00b1 cd0019        	call	_uart_send
2987  00b4               L7202:
2988                     ; 58 	}
2991  00b4 84            	pop	a
2992  00b5 81            	ret
3034                     ; 1  void Key_interrupt (void)
3034                     ; 2 {
3035                     	switch	.text
3036  00b6               _Key_interrupt:
3040                     ; 4   pins = PC_IDR;
3042  00b6 55500b0004    	mov	_pins,_PC_IDR
3043                     ; 5 }
3046  00bb 81            	ret
3125                     ; 7 void i2c_master_init(unsigned long f_master_hz, unsigned long f_i2c_hz){
3126                     	switch	.text
3127  00bc               _i2c_master_init:
3129  00bc 5208          	subw	sp,#8
3130       00000008      OFST:	set	8
3133                     ; 9 	I2C_CR1 &= ~I2C_CR1_PE;
3135  00be 72115210      	bres	_I2C_CR1,#0
3136                     ; 10 	I2C_CR2 |= I2C_CR2_SWRST;
3138  00c2 721e5211      	bset	_I2C_CR2,#7
3139                     ; 11   PB_DDR = (0<<4);//PB_DDR_DDR4);
3141  00c6 725f5007      	clr	_PB_DDR
3142                     ; 12 	PB_DDR = (0<<5);//PB_DDR_DDR5);
3144  00ca 725f5007      	clr	_PB_DDR
3145                     ; 13 	PB_ODR = (1<<5);//PB_ODR_ODR5);  //SDA
3147  00ce 35205005      	mov	_PB_ODR,#32
3148                     ; 14   PB_ODR = (1<<4);//PB_ODR_ODR4);  //SCL
3150  00d2 35105005      	mov	_PB_ODR,#16
3151                     ; 16   PB_CR1 = (0<<4);//PB_CR1_C14);
3153  00d6 725f5008      	clr	_PB_CR1
3154                     ; 17   PB_CR1 = (0<<5);//PB_CR1_C15);
3156  00da 725f5008      	clr	_PB_CR1
3157                     ; 19   PB_CR2 = (0<<4);//PB_CR1_C24);
3159  00de 725f5009      	clr	_PB_CR2
3160                     ; 20   PB_CR2 = (0<<5);//PB_CR1_C25);
3162  00e2 725f5009      	clr	_PB_CR2
3163                     ; 21   I2C_CR2 &= ~I2C_CR2_SWRST;
3165  00e6 721f5211      	bres	_I2C_CR2,#7
3166                     ; 23   I2C_FREQR = 16;
3168  00ea 35105212      	mov	_I2C_FREQR,#16
3169                     ; 28   I2C_CCRH |=~I2C_CCRH_FS;
3171  00ee c6521c        	ld	a,_I2C_CCRH
3172  00f1 aa7f          	or	a,#127
3173  00f3 c7521c        	ld	_I2C_CCRH,a
3174                     ; 30   ccr = f_master_hz/(2*f_i2c_hz);
3176  00f6 96            	ldw	x,sp
3177  00f7 1c000f        	addw	x,#OFST+7
3178  00fa cd0000        	call	c_ltor
3180  00fd 3803          	sll	c_lreg+3
3181  00ff 3902          	rlc	c_lreg+2
3182  0101 3901          	rlc	c_lreg+1
3183  0103 3900          	rlc	c_lreg
3184  0105 96            	ldw	x,sp
3185  0106 1c0001        	addw	x,#OFST-7
3186  0109 cd0000        	call	c_rtol
3188  010c 96            	ldw	x,sp
3189  010d 1c000b        	addw	x,#OFST+3
3190  0110 cd0000        	call	c_ltor
3192  0113 96            	ldw	x,sp
3193  0114 1c0001        	addw	x,#OFST-7
3194  0117 cd0000        	call	c_ludv
3196  011a 96            	ldw	x,sp
3197  011b 1c0005        	addw	x,#OFST-3
3198  011e cd0000        	call	c_rtol
3200                     ; 34   I2C_TRISER = 12+1;
3202  0121 350d521d      	mov	_I2C_TRISER,#13
3203                     ; 35   I2C_CCRL = ccr & 0xFF;
3205  0125 7b08          	ld	a,(OFST+0,sp)
3206  0127 a4ff          	and	a,#255
3207  0129 c7521b        	ld	_I2C_CCRL,a
3208                     ; 36   I2C_CCRH = ((ccr >> 8) & 0x0F);
3210  012c 7b07          	ld	a,(OFST-1,sp)
3211  012e a40f          	and	a,#15
3212  0130 c7521c        	ld	_I2C_CCRH,a
3213                     ; 39   I2C_CR1 |=I2C_CR1_PE;
3215  0133 72105210      	bset	_I2C_CR1,#0
3216                     ; 42   I2C_CR2 |=I2C_CR2_ACK;
3218  0137 72145211      	bset	_I2C_CR2,#2
3219                     ; 43 }
3222  013b 5b08          	addw	sp,#8
3223  013d 81            	ret
3317                     ; 49 t_i2c_status i2c_wr_reg(unsigned char address, unsigned char reg_addr,
3317                     ; 50                               char * data, unsigned char length)
3317                     ; 51 {                                  
3318                     	switch	.text
3319  013e               _i2c_wr_reg:
3321  013e 89            	pushw	x
3322       00000000      OFST:	set	0
3325  013f               L1512:
3326                     ; 55   while((I2C_SR3 & I2C_SR3_BUSY) !=0);   
3328  013f c65219        	ld	a,_I2C_SR3
3329  0142 a502          	bcp	a,#2
3330  0144 26f9          	jrne	L1512
3331                     ; 57   I2C_CR2 |= I2C_CR2_START;
3333  0146 72105211      	bset	_I2C_CR2,#0
3335  014a               L7512:
3336                     ; 60   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3338  014a c65217        	ld	a,_I2C_SR1
3339  014d a501          	bcp	a,#1
3340  014f 27f9          	jreq	L7512
3341                     ; 63   I2C_DR = address & 0xFE;
3343  0151 7b01          	ld	a,(OFST+1,sp)
3344  0153 a4fe          	and	a,#254
3345  0155 c75216        	ld	_I2C_DR,a
3347  0158               L7612:
3348                     ; 66 	while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3350  0158 c65217        	ld	a,_I2C_SR1
3351  015b a502          	bcp	a,#2
3352  015d 27f9          	jreq	L7612
3353                     ; 68   I2C_SR3;
3355  015f c65219        	ld	a,_I2C_SR3
3357  0162               L5712:
3358                     ; 73   while((I2C_SR1 & I2C_SR1_TXE) ==0);
3360  0162 c65217        	ld	a,_I2C_SR1
3361  0165 a580          	bcp	a,#128
3362  0167 27f9          	jreq	L5712
3363                     ; 75   I2C_DR = reg_addr;
3365  0169 7b02          	ld	a,(OFST+2,sp)
3366  016b c75216        	ld	_I2C_DR,a
3368  016e 2015          	jra	L5022
3369  0170               L3122:
3370                     ; 81     while((I2C_SR1 & I2C_SR1_TXE) == 0);
3372  0170 c65217        	ld	a,_I2C_SR1
3373  0173 a580          	bcp	a,#128
3374  0175 27f9          	jreq	L3122
3375                     ; 83     I2C_DR = *data++;
3377  0177 1e05          	ldw	x,(OFST+5,sp)
3378  0179 1c0001        	addw	x,#1
3379  017c 1f05          	ldw	(OFST+5,sp),x
3380  017e 1d0001        	subw	x,#1
3381  0181 f6            	ld	a,(x)
3382  0182 c75216        	ld	_I2C_DR,a
3383  0185               L5022:
3384                     ; 78   while(length--){
3386  0185 7b07          	ld	a,(OFST+7,sp)
3387  0187 0a07          	dec	(OFST+7,sp)
3388  0189 4d            	tnz	a
3389  018a 26e4          	jrne	L3122
3391  018c               L1222:
3392                     ; 88   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3394  018c c65217        	ld	a,_I2C_SR1
3395  018f a584          	bcp	a,#132
3396  0191 27f9          	jreq	L1222
3397                     ; 90   I2C_CR2 |= I2C_CR2_STOP;
3399  0193 72125211      	bset	_I2C_CR2,#1
3401  0197               L7222:
3402                     ; 93   while((I2C_CR2 & I2C_CR2_STOP) == 0); 
3404  0197 c65211        	ld	a,_I2C_CR2
3405  019a a502          	bcp	a,#2
3406  019c 27f9          	jreq	L7222
3407                     ; 94   return I2C_SUCCESS;
3409  019e 4f            	clr	a
3412  019f 85            	popw	x
3413  01a0 81            	ret
3483                     ; 101 t_i2c_status i2c_rd_reg(unsigned char address, unsigned char reg_addr,
3483                     ; 102                               char * data, unsigned char length)
3483                     ; 103 {
3484                     	switch	.text
3485  01a1               _i2c_rd_reg:
3487  01a1 89            	pushw	x
3488       00000000      OFST:	set	0
3491  01a2               L7622:
3492                     ; 109   while((I2C_SR3 & I2C_SR3_BUSY) != 0);   
3494  01a2 c65219        	ld	a,_I2C_SR3
3495  01a5 a502          	bcp	a,#2
3496  01a7 26f9          	jrne	L7622
3497                     ; 111   I2C_CR2 |= I2C_CR2_ACK;
3499  01a9 72145211      	bset	_I2C_CR2,#2
3500                     ; 114   I2C_CR2 |= I2C_CR2_START;
3502  01ad 72105211      	bset	_I2C_CR2,#0
3504  01b1               L5722:
3505                     ; 117   while((I2C_SR1 & I2C_SR1_SB) == 0);  
3507  01b1 c65217        	ld	a,_I2C_SR1
3508  01b4 a501          	bcp	a,#1
3509  01b6 27f9          	jreq	L5722
3510                     ; 119   I2C_DR = address & 0xFE;
3512  01b8 7b01          	ld	a,(OFST+1,sp)
3513  01ba a4fe          	and	a,#254
3514  01bc c75216        	ld	_I2C_DR,a
3516  01bf               L5032:
3517                     ; 122   while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3519  01bf c65217        	ld	a,_I2C_SR1
3520  01c2 a502          	bcp	a,#2
3521  01c4 27f9          	jreq	L5032
3522                     ; 124   temp = I2C_SR3;
3524  01c6 5552190003    	mov	_temp,_I2C_SR3
3526  01cb               L5132:
3527                     ; 128   while((I2C_SR1 & I2C_SR1) == 0); 
3529  01cb c65217        	ld	a,_I2C_SR1
3530  01ce 5f            	clrw	x
3531  01cf 97            	ld	xl,a
3532  01d0 a30000        	cpw	x,#0
3533  01d3 27f6          	jreq	L5132
3534                     ; 130   I2C_DR = reg_addr;
3536  01d5 7b02          	ld	a,(OFST+2,sp)
3537  01d7 c75216        	ld	_I2C_DR,a
3539  01da               L5232:
3540                     ; 133   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3542  01da c65217        	ld	a,_I2C_SR1
3543  01dd a584          	bcp	a,#132
3544  01df 27f9          	jreq	L5232
3545                     ; 135   I2C_CR2 |= I2C_CR2_START;
3547  01e1 72105211      	bset	_I2C_CR2,#0
3549  01e5               L3332:
3550                     ; 138   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3552  01e5 c65217        	ld	a,_I2C_SR1
3553  01e8 a501          	bcp	a,#1
3554  01ea 27f9          	jreq	L3332
3555                     ; 141   I2C_DR = address | 0x01;
3557  01ec 7b01          	ld	a,(OFST+1,sp)
3558  01ee aa01          	or	a,#1
3559  01f0 c75216        	ld	_I2C_DR,a
3560                     ; 145   if(length == 1){
3562  01f3 7b07          	ld	a,(OFST+7,sp)
3563  01f5 a101          	cp	a,#1
3564  01f7 2627          	jrne	L7332
3565                     ; 147     I2C_CR2 &= ~I2C_CR2_ACK;
3567  01f9 72155211      	bres	_I2C_CR2,#2
3569  01fd               L3432:
3570                     ; 150     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3572  01fd c65217        	ld	a,_I2C_SR1
3573  0200 a502          	bcp	a,#2
3574  0202 27f9          	jreq	L3432
3575                     ; 152     _asm ("SIM");  //on interupts
3578  0204 9b            SIM
3580                     ; 154     temp = I2C_SR3;
3582  0205 5552190003    	mov	_temp,_I2C_SR3
3583                     ; 157     I2C_CR2 |= I2C_CR2_STOP;
3585  020a 72125211      	bset	_I2C_CR2,#1
3586                     ; 159     _asm ("RIM");  //on interupts;
3589  020e 9a            RIM
3592  020f               L1532:
3593                     ; 163     while((I2C_SR1 & I2C_SR1_RXNE) == 0); 
3595  020f c65217        	ld	a,_I2C_SR1
3596  0212 a540          	bcp	a,#64
3597  0214 27f9          	jreq	L1532
3598                     ; 165     *data = I2C_DR;
3600  0216 1e05          	ldw	x,(OFST+5,sp)
3601  0218 c65216        	ld	a,_I2C_DR
3602  021b f7            	ld	(x),a
3604  021c acd202d2      	jpf	L5532
3605  0220               L7332:
3606                     ; 168   else if(length == 2){
3608  0220 7b07          	ld	a,(OFST+7,sp)
3609  0222 a102          	cp	a,#2
3610  0224 2639          	jrne	L7532
3611                     ; 170     I2C_CR2 |= I2C_CR2_POS;
3613  0226 72165211      	bset	_I2C_CR2,#3
3615  022a               L3632:
3616                     ; 173     while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3618  022a c65217        	ld	a,_I2C_SR1
3619  022d a502          	bcp	a,#2
3620  022f 27f9          	jreq	L3632
3621                     ; 175     _asm ("SIM");  //on interupts;
3624  0231 9b            SIM
3626                     ; 177     temp = I2C_SR3;
3628  0232 5552190003    	mov	_temp,_I2C_SR3
3629                     ; 179     I2C_CR2 &= ~I2C_CR2_ACK;
3631  0237 72155211      	bres	_I2C_CR2,#2
3632                     ; 181     _asm ("RIM");  //on interupts;
3635  023b 9a            RIM
3638  023c               L1732:
3639                     ; 185     while((I2C_SR1 & I2C_SR1_BTF) == 0); 
3641  023c c65217        	ld	a,_I2C_SR1
3642  023f a504          	bcp	a,#4
3643  0241 27f9          	jreq	L1732
3644                     ; 187     _asm ("SIM");  //on interupts;
3647  0243 9b            SIM
3649                     ; 189     I2C_CR2 |= I2C_CR2_STOP;
3651  0244 72125211      	bset	_I2C_CR2,#1
3652                     ; 191     *data++ = I2C_DR;
3654  0248 1e05          	ldw	x,(OFST+5,sp)
3655  024a 1c0001        	addw	x,#1
3656  024d 1f05          	ldw	(OFST+5,sp),x
3657  024f 1d0001        	subw	x,#1
3658  0252 c65216        	ld	a,_I2C_DR
3659  0255 f7            	ld	(x),a
3660                     ; 193     _asm ("RIM");  //on interupts;
3663  0256 9a            RIM
3665                     ; 194     *data = I2C_DR;
3667  0257 1e05          	ldw	x,(OFST+5,sp)
3668  0259 c65216        	ld	a,_I2C_DR
3669  025c f7            	ld	(x),a
3671  025d 2073          	jra	L5532
3672  025f               L7532:
3673                     ; 197   else if(length > 2){
3675  025f 7b07          	ld	a,(OFST+7,sp)
3676  0261 a103          	cp	a,#3
3677  0263 256d          	jrult	L5532
3679  0265               L3042:
3680                     ; 200     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3682  0265 c65217        	ld	a,_I2C_SR1
3683  0268 a502          	bcp	a,#2
3684  026a 27f9          	jreq	L3042
3685                     ; 202     _asm ("SIM");  //on interupts;
3688  026c 9b            SIM
3690                     ; 205     I2C_SR3;
3692  026d c65219        	ld	a,_I2C_SR3
3693                     ; 208     _asm ("RIM");  //on interupts;
3696  0270 9a            RIM
3699  0271 2015          	jra	L1142
3700  0273               L7142:
3701                     ; 213       while((I2C_SR1 & I2C_SR1_BTF) == 0);
3703  0273 c65217        	ld	a,_I2C_SR1
3704  0276 a504          	bcp	a,#4
3705  0278 27f9          	jreq	L7142
3706                     ; 215       *data++ = I2C_DR;
3708  027a 1e05          	ldw	x,(OFST+5,sp)
3709  027c 1c0001        	addw	x,#1
3710  027f 1f05          	ldw	(OFST+5,sp),x
3711  0281 1d0001        	subw	x,#1
3712  0284 c65216        	ld	a,_I2C_DR
3713  0287 f7            	ld	(x),a
3714  0288               L1142:
3715                     ; 210     while(length-- > 3){
3717  0288 7b07          	ld	a,(OFST+7,sp)
3718  028a 0a07          	dec	(OFST+7,sp)
3719  028c a104          	cp	a,#4
3720  028e 24e3          	jruge	L7142
3722  0290               L5242:
3723                     ; 224     while((I2C_SR1 & I2C_SR1_BTF) == 0);
3725  0290 c65217        	ld	a,_I2C_SR1
3726  0293 a504          	bcp	a,#4
3727  0295 27f9          	jreq	L5242
3728                     ; 226     I2C_CR2 &= ~I2C_CR2_ACK;
3730  0297 72155211      	bres	_I2C_CR2,#2
3731                     ; 228     _asm ("SIM");  //on interupts;
3734  029b 9b            SIM
3736                     ; 231     *data++ = I2C_DR;
3738  029c 1e05          	ldw	x,(OFST+5,sp)
3739  029e 1c0001        	addw	x,#1
3740  02a1 1f05          	ldw	(OFST+5,sp),x
3741  02a3 1d0001        	subw	x,#1
3742  02a6 c65216        	ld	a,_I2C_DR
3743  02a9 f7            	ld	(x),a
3744                     ; 233     I2C_CR2 |= I2C_CR2_STOP;
3746  02aa 72125211      	bset	_I2C_CR2,#1
3747                     ; 235     *data++ = I2C_DR;
3749  02ae 1e05          	ldw	x,(OFST+5,sp)
3750  02b0 1c0001        	addw	x,#1
3751  02b3 1f05          	ldw	(OFST+5,sp),x
3752  02b5 1d0001        	subw	x,#1
3753  02b8 c65216        	ld	a,_I2C_DR
3754  02bb f7            	ld	(x),a
3755                     ; 237     _asm ("RIM");  //on interupts;
3758  02bc 9a            RIM
3761  02bd               L3342:
3762                     ; 240     while((I2C_SR1 & I2C_SR1_RXNE) == 0);
3764  02bd c65217        	ld	a,_I2C_SR1
3765  02c0 a540          	bcp	a,#64
3766  02c2 27f9          	jreq	L3342
3767                     ; 242     *data++ = I2C_DR;
3769  02c4 1e05          	ldw	x,(OFST+5,sp)
3770  02c6 1c0001        	addw	x,#1
3771  02c9 1f05          	ldw	(OFST+5,sp),x
3772  02cb 1d0001        	subw	x,#1
3773  02ce c65216        	ld	a,_I2C_DR
3774  02d1 f7            	ld	(x),a
3775  02d2               L5532:
3776                     ; 245 	 I2C_CR2 |= I2C_CR2_STOP;
3778  02d2 72125211      	bset	_I2C_CR2,#1
3780  02d6               L1442:
3781                     ; 248   while((I2C_CR2 & I2C_CR2_STOP) == 0);
3783  02d6 c65211        	ld	a,_I2C_CR2
3784  02d9 a502          	bcp	a,#2
3785  02db 27f9          	jreq	L1442
3786                     ; 250   I2C_CR2 &= ~I2C_CR2_POS;
3788  02dd 72175211      	bres	_I2C_CR2,#3
3789                     ; 252   return I2C_SUCCESS;
3791  02e1 4f            	clr	a
3794  02e2 85            	popw	x
3795  02e3 81            	ret
3862                     ; 11 void timer1_setup(uint16_t tim_freq, uint16_t top)
3862                     ; 12  {
3863                     	switch	.text
3864  02e4               _timer1_setup:
3866  02e4 89            	pushw	x
3867  02e5 5204          	subw	sp,#4
3868       00000004      OFST:	set	4
3871                     ; 13   TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
3873  02e7 cd0000        	call	c_uitolx
3875  02ea 96            	ldw	x,sp
3876  02eb 1c0001        	addw	x,#OFST-3
3877  02ee cd0000        	call	c_rtol
3879  02f1 ae2400        	ldw	x,#9216
3880  02f4 bf02          	ldw	c_lreg+2,x
3881  02f6 ae00f4        	ldw	x,#244
3882  02f9 bf00          	ldw	c_lreg,x
3883  02fb 96            	ldw	x,sp
3884  02fc 1c0001        	addw	x,#OFST-3
3885  02ff cd0000        	call	c_ldiv
3887  0302 a608          	ld	a,#8
3888  0304 cd0000        	call	c_lrsh
3890  0307 b603          	ld	a,c_lreg+3
3891  0309 c75260        	ld	_TIM1_PSCRH,a
3892                     ; 14   TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; // 16 divider
3894  030c 1e05          	ldw	x,(OFST+1,sp)
3895  030e cd0000        	call	c_uitolx
3897  0311 96            	ldw	x,sp
3898  0312 1c0001        	addw	x,#OFST-3
3899  0315 cd0000        	call	c_rtol
3901  0318 ae2400        	ldw	x,#9216
3902  031b bf02          	ldw	c_lreg+2,x
3903  031d ae00f4        	ldw	x,#244
3904  0320 bf00          	ldw	c_lreg,x
3905  0322 96            	ldw	x,sp
3906  0323 1c0001        	addw	x,#OFST-3
3907  0326 cd0000        	call	c_ldiv
3909  0329 3f02          	clr	c_lreg+2
3910  032b 3f01          	clr	c_lreg+1
3911  032d 3f00          	clr	c_lreg
3912  032f b603          	ld	a,c_lreg+3
3913  0331 c75261        	ld	_TIM1_PSCRL,a
3914                     ; 15   TIM1_ARRH = (top) >> 8; //	overflow frequency = 16М / 8 / 1000 = 2000 Гц
3916  0334 7b09          	ld	a,(OFST+5,sp)
3917  0336 c75262        	ld	_TIM1_ARRH,a
3918                     ; 16   TIM1_ARRL = (top)& 0xFF;
3920  0339 7b0a          	ld	a,(OFST+6,sp)
3921  033b a4ff          	and	a,#255
3922  033d c75263        	ld	_TIM1_ARRL,a
3923                     ; 18   TIM1_CR1 |= TIM1_CR1_URS; //only overflow int
3925  0340 72145250      	bset	_TIM1_CR1,#2
3926                     ; 19   TIM1_EGR |= TIM1_EGR_UG;  //call Update Event
3928  0344 72105257      	bset	_TIM1_EGR,#0
3929                     ; 20   TIM1_IER |= TIM1_IER_UIE; //int enable
3931  0348 72105254      	bset	_TIM1_IER,#0
3932                     ; 21  }
3935  034c 5b06          	addw	sp,#6
3936  034e 81            	ret
3967                     ; 24 void timer2_setup(void)
3967                     ; 25  {
3968                     	switch	.text
3969  034f               _timer2_setup:
3973                     ; 27 		TIM2_CCR1H = dots_upd >> 8;
3975  034f 5500025311    	mov	_TIM2_CCR1H,_dots_upd
3976                     ; 28 		TIM2_CCR1L = dots_upd & 0xFF;
3978  0354 b603          	ld	a,_dots_upd+1
3979  0356 a4ff          	and	a,#255
3980  0358 c75312        	ld	_TIM2_CCR1L,a
3981                     ; 29 		TIM2_CCMR1 |= TIM2_CCMR_OCxPE;	//preload
3983  035b 72165307      	bset	_TIM2_CCMR1,#3
3984                     ; 31     TIM2_IER |=	TIM2_IER_CC1IE | TIM2_IER_UIE;	//overflow int and compare 1   
3986  035f c65303        	ld	a,_TIM2_IER
3987  0362 aa03          	or	a,#3
3988  0364 c75303        	ld	_TIM2_IER,a
3989                     ; 32     TIM2_PSCR = 0;
3991  0367 725f530e      	clr	_TIM2_PSCR
3992                     ; 33     TIM2_ARRH = 0;
3994  036b 725f530f      	clr	_TIM2_ARRH
3995                     ; 34     TIM2_ARRL = 0;
3997  036f 725f5310      	clr	_TIM2_ARRL
3998                     ; 35  }
4001  0373 81            	ret
4026                     ; 37  void timer4_setup(void)
4026                     ; 38  {
4027                     	switch	.text
4028  0374               _timer4_setup:
4032                     ; 39 	 TIM4_CR1 |= TIM4_CR1_ARPE;
4034  0374 721e5340      	bset	_TIM4_CR1,#7
4035                     ; 40 	 TIM4_IER |= TIM4_IER_UIE;
4037  0378 72105343      	bset	_TIM4_IER,#0
4038                     ; 41  }
4041  037c 81            	ret
4078                     ; 43  void timer1_comp_start(uint16_t val)
4078                     ; 44  {
4079                     	switch	.text
4080  037d               _timer1_comp_start:
4084                     ; 45 		TIM1_IER |= TIM1_IER_CC1IE;
4086  037d 72125254      	bset	_TIM1_IER,#1
4087                     ; 46 		TIM1_CCR1H = val >> 8;
4089  0381 9e            	ld	a,xh
4090  0382 c75265        	ld	_TIM1_CCR1H,a
4091                     ; 47 		TIM1_CCR1L = val & 0xFF;
4093  0385 9f            	ld	a,xl
4094  0386 a4ff          	and	a,#255
4095  0388 c75266        	ld	_TIM1_CCR1L,a
4096                     ; 48  }
4099  038b 81            	ret
4123                     ; 49  void timer1_comp_stop(void){
4124                     	switch	.text
4125  038c               _timer1_comp_stop:
4129                     ; 50 	 TIM1_IER &= ~TIM1_IER_CC1IE;
4131  038c 72135254      	bres	_TIM1_IER,#1
4132                     ; 51  }
4135  0390 81            	ret
4159                     ; 53  void timer1_start(void)
4159                     ; 54  {
4160                     	switch	.text
4161  0391               _timer1_start:
4165                     ; 55    TIM1_CR1 |= TIM1_CR1_CEN; //Запускаем таймер
4167  0391 72105250      	bset	_TIM1_CR1,#0
4168                     ; 56  }
4171  0395 81            	ret
4208                     ; 58 void timer2_start(uint16_t top_val)
4208                     ; 59 {
4209                     	switch	.text
4210  0396               _timer2_start:
4214                     ; 60   TIM2_ARRH =top_val >>8;
4216  0396 9e            	ld	a,xh
4217  0397 c7530f        	ld	_TIM2_ARRH,a
4218                     ; 61   TIM2_ARRL =top_val & 0xFF;
4220  039a 9f            	ld	a,xl
4221  039b a4ff          	and	a,#255
4222  039d c75310        	ld	_TIM2_ARRL,a
4223                     ; 62   TIM2_CR1 |= TIM2_CR1_CEN;
4225  03a0 72105300      	bset	_TIM2_CR1,#0
4226                     ; 63 }
4229  03a4 81            	ret
4262                     ; 65 void Timer2_Overflow (void)
4262                     ; 66 {
4263                     	switch	.text
4264  03a5               _Timer2_Overflow:
4268                     ; 67 	TIM2_SR1 &= ~TIM2_SR1_UIF;
4270  03a5 72115304      	bres	_TIM2_SR1,#0
4271                     ; 69 			timers_int_off();
4273  03a9 cd04f6        	call	_timers_int_off
4275                     ; 70 			PA_ODR &= (0<<3);
4277  03ac 725f5000      	clr	_PA_ODR
4278                     ; 71 			spi_send(kostil_k155(k155_data));
4280  03b0 b617          	ld	a,_k155_data
4281  03b2 cd055c        	call	_kostil_k155
4283  03b5 cd0583        	call	_spi_send
4285                     ; 72 			spi_send(lamp_number_data | dots);
4287  03b8 b616          	ld	a,_lamp_number_data
4288  03ba ba01          	or	a,_dots
4289  03bc cd0583        	call	_spi_send
4292  03bf               L3062:
4293                     ; 73 			while((SPI_SR & SPI_SR_BSY) != 0);
4295  03bf c65203        	ld	a,_SPI_SR
4296  03c2 a580          	bcp	a,#128
4297  03c4 26f9          	jrne	L3062
4298                     ; 74 			PA_ODR |= (1<<3);
4300  03c6 72165000      	bset	_PA_ODR,#3
4301                     ; 75 			timers_int_on();
4303  03ca cd04ff        	call	_timers_int_on
4305                     ; 76 }
4308  03cd 81            	ret
4339                     ; 78 void Timer1_overflow (void){
4340                     	switch	.text
4341  03ce               _Timer1_overflow:
4345                     ; 79 	TIM1_SR1 &= ~TIM1_SR1_UIF;
4347  03ce 72115255      	bres	_TIM1_SR1,#0
4348                     ; 80 	if (dots_on == 0){
4350  03d2 be04          	ldw	x,_dots_on
4351  03d4 2607          	jrne	L7162
4352                     ; 81 		dots_on = 1;
4354  03d6 ae0001        	ldw	x,#1
4355  03d9 bf04          	ldw	_dots_on,x
4357  03db 2003          	jra	L1262
4358  03dd               L7162:
4359                     ; 85 		dots_on = 0;
4361  03dd 5f            	clrw	x
4362  03de bf04          	ldw	_dots_on,x
4363  03e0               L1262:
4364                     ; 90 	time_refresh();
4366  03e0 cd05b3        	call	_time_refresh
4368                     ; 91 	if ((minutes == 0) && (shifting == 0)){
4370  03e3 3d0d          	tnz	_minutes
4371  03e5 2614          	jrne	L3262
4373  03e7 3d02          	tnz	_shifting
4374  03e9 2610          	jrne	L3262
4375                     ; 92 		shifting = 1;
4377  03eb 35010002      	mov	_shifting,#1
4378                     ; 93 		tim1comp = 5950;
4380  03ef ae173e        	ldw	x,#5950
4381  03f2 bf0f          	ldw	_tim1comp,x
4382                     ; 94 		digits_shift_init();
4384  03f4 cd0611        	call	_digits_shift_init
4386                     ; 95 		timer1_comp_start(tim1comp);
4388  03f7 be0f          	ldw	x,_tim1comp
4389  03f9 ad82          	call	_timer1_comp_start
4391  03fb               L3262:
4392                     ; 97 	if (minutes != 0 && minutes != 5){
4394  03fb 3d0d          	tnz	_minutes
4395  03fd 2708          	jreq	L5262
4397  03ff b60d          	ld	a,_minutes
4398  0401 a105          	cp	a,#5
4399  0403 2702          	jreq	L5262
4400                     ; 98 		shifting = 0;
4402  0405 3f02          	clr	_shifting
4403  0407               L5262:
4404                     ; 100 }
4407  0407 81            	ret
4440                     ; 102 void timer1_compare(void){
4441                     	switch	.text
4442  0408               _timer1_compare:
4446                     ; 103 	TIM1_SR1 &= ~TIM1_SR1_CC1IF;
4448  0408 72135255      	bres	_TIM1_SR1,#1
4449                     ; 104 	if(hours < 9){
4451  040c b60e          	ld	a,_hours
4452  040e a109          	cp	a,#9
4453  0410 241a          	jruge	L7362
4454                     ; 105 	seconds_tens++;
4456  0412 3c0b          	inc	_seconds_tens
4457                     ; 106 	minutes_tens++;
4459  0414 3c0a          	inc	_minutes_tens
4460                     ; 107 	hours_tens++;
4462  0416 3c09          	inc	_hours_tens
4463                     ; 109 	seconds++;
4465  0418 3c0c          	inc	_seconds
4466                     ; 110 	minutes++;
4468  041a 3c0d          	inc	_minutes
4469                     ; 111 	hours++;
4471  041c 3c0e          	inc	_hours
4472                     ; 112 	tim1comp += 5950;
4474  041e be0f          	ldw	x,_tim1comp
4475  0420 1c173e        	addw	x,#5950
4476  0423 bf0f          	ldw	_tim1comp,x
4477                     ; 113 	timer1_comp_start(tim1comp);
4479  0425 be0f          	ldw	x,_tim1comp
4480  0427 cd037d        	call	_timer1_comp_start
4483  042a 2003          	jra	L1462
4484  042c               L7362:
4485                     ; 116 		timer1_comp_stop();
4487  042c cd038c        	call	_timer1_comp_stop
4489  042f               L1462:
4490                     ; 118 }
4493  042f 81            	ret
4536                     ; 120 void timer2_compare(void)
4536                     ; 121 {
4537                     	switch	.text
4538  0430               _timer2_compare:
4542                     ; 122 	TIM2_SR1 &= ~TIM2_SR1_CC1IF;
4544  0430 72135304      	bres	_TIM2_SR1,#1
4545                     ; 124 	if (schetchik == 1)
4547  0434 b60a          	ld	a,_schetchik
4548  0436 a101          	cp	a,#1
4549  0438 2658          	jrne	L3662
4550                     ; 126 	switch (lamp_number)
4552  043a b600          	ld	a,_lamp_number
4554                     ; 139 	break;
4555  043c 4d            	tnz	a
4556  043d 270b          	jreq	L3462
4557  043f 4a            	dec	a
4558  0440 270d          	jreq	L5462
4559  0442 4a            	dec	a
4560  0443 270f          	jreq	L7462
4561  0445 4a            	dec	a
4562  0446 2711          	jreq	L1562
4563  0448 2012          	jra	L7662
4564  044a               L3462:
4565                     ; 128 	case 0:
4565                     ; 129 	k155_data = hours_tens; 
4567  044a 450917        	mov	_k155_data,_hours_tens
4568                     ; 130 	break;
4570  044d 200d          	jra	L7662
4571  044f               L5462:
4572                     ; 131 	case 1:
4572                     ; 132 	k155_data = hours;
4574  044f 450e17        	mov	_k155_data,_hours
4575                     ; 133 	break;
4577  0452 2008          	jra	L7662
4578  0454               L7462:
4579                     ; 134 	case 2:
4579                     ; 135 	k155_data = minutes_tens;
4581  0454 450a17        	mov	_k155_data,_minutes_tens
4582                     ; 136 	break;
4584  0457 2003          	jra	L7662
4585  0459               L1562:
4586                     ; 137 	case 3:
4586                     ; 138 	k155_data = minutes;
4588  0459 450d17        	mov	_k155_data,_minutes
4589                     ; 139 	break;
4591  045c               L7662:
4592                     ; 142 	if (lamp_number < 3)
4594  045c b600          	ld	a,_lamp_number
4595  045e a103          	cp	a,#3
4596  0460 2415          	jruge	L1762
4597                     ; 144 			lamp_number_data = (1<<(lamp_number++));
4599  0462 b600          	ld	a,_lamp_number
4600  0464 97            	ld	xl,a
4601  0465 3c00          	inc	_lamp_number
4602  0467 9f            	ld	a,xl
4603  0468 5f            	clrw	x
4604  0469 97            	ld	xl,a
4605  046a a601          	ld	a,#1
4606  046c 5d            	tnzw	x
4607  046d 2704          	jreq	L05
4608  046f               L25:
4609  046f 48            	sll	a
4610  0470 5a            	decw	x
4611  0471 26fc          	jrne	L25
4612  0473               L05:
4613  0473 b716          	ld	_lamp_number_data,a
4615  0475 2017          	jra	L3762
4616  0477               L1762:
4617                     ; 146 		else if (lamp_number >= 3)
4619  0477 b600          	ld	a,_lamp_number
4620  0479 a103          	cp	a,#3
4621  047b 2511          	jrult	L3762
4622                     ; 148 			lamp_number_data = (1<<(lamp_number));
4624  047d b600          	ld	a,_lamp_number
4625  047f 5f            	clrw	x
4626  0480 97            	ld	xl,a
4627  0481 a601          	ld	a,#1
4628  0483 5d            	tnzw	x
4629  0484 2704          	jreq	L45
4630  0486               L65:
4631  0486 48            	sll	a
4632  0487 5a            	decw	x
4633  0488 26fc          	jrne	L65
4634  048a               L45:
4635  048a b716          	ld	_lamp_number_data,a
4636                     ; 149 			lamp_number = 0;
4638  048c 3f00          	clr	_lamp_number
4639  048e               L3762:
4640                     ; 152 	schetchik = 0;
4642  048e 3f0a          	clr	_schetchik
4644  0490 2006          	jra	L7762
4645  0492               L3662:
4646                     ; 156 		lamp_number_data = 0;
4648  0492 3f16          	clr	_lamp_number_data
4649                     ; 157 		schetchik = 1;
4651  0494 3501000a      	mov	_schetchik,#1
4652  0498               L7762:
4653                     ; 161 	if (dots_on == 1){
4655  0498 be04          	ldw	x,_dots_on
4656  049a a30001        	cpw	x,#1
4657  049d 261c          	jrne	L1072
4658                     ; 162 		if (dots_upd < 10000){
4660  049f be02          	ldw	x,_dots_upd
4661  04a1 a32710        	cpw	x,#10000
4662  04a4 242c          	jruge	L5072
4663                     ; 163 			dots_upd +=10;
4665  04a6 be02          	ldw	x,_dots_upd
4666  04a8 1c000a        	addw	x,#10
4667  04ab bf02          	ldw	_dots_upd,x
4668                     ; 164 			TIM2_CCR1H = dots_upd >> 8;
4670  04ad 5500025311    	mov	_TIM2_CCR1H,_dots_upd
4671                     ; 165 			TIM2_CCR1L = dots_upd & 0xFF;
4673  04b2 b603          	ld	a,_dots_upd+1
4674  04b4 a4ff          	and	a,#255
4675  04b6 c75312        	ld	_TIM2_CCR1L,a
4676  04b9 2017          	jra	L5072
4677  04bb               L1072:
4678                     ; 169 			if (dots_upd > 0){
4680  04bb be02          	ldw	x,_dots_upd
4681  04bd 2713          	jreq	L5072
4682                     ; 170 				dots_upd -= 10;
4684  04bf be02          	ldw	x,_dots_upd
4685  04c1 1d000a        	subw	x,#10
4686  04c4 bf02          	ldw	_dots_upd,x
4687                     ; 171 				TIM2_CCR1H = dots_upd >> 8;
4689  04c6 5500025311    	mov	_TIM2_CCR1H,_dots_upd
4690                     ; 172 				TIM2_CCR1L = dots_upd & 0xFF;
4692  04cb b603          	ld	a,_dots_upd+1
4693  04cd a4ff          	and	a,#255
4694  04cf c75312        	ld	_TIM2_CCR1L,a
4695  04d2               L5072:
4696                     ; 176 			timers_int_off();
4698  04d2 ad22          	call	_timers_int_off
4700                     ; 177 			PA_ODR &= (0<<3);
4702  04d4 725f5000      	clr	_PA_ODR
4703                     ; 178 			spi_send(kostil_k155(k155_data));
4705  04d8 b617          	ld	a,_k155_data
4706  04da cd055c        	call	_kostil_k155
4708  04dd cd0583        	call	_spi_send
4710                     ; 180 			spi_send(lamp_number_data & ~dots);
4712  04e0 b601          	ld	a,_dots
4713  04e2 43            	cpl	a
4714  04e3 b416          	and	a,_lamp_number_data
4715  04e5 cd0583        	call	_spi_send
4718  04e8               L3172:
4719                     ; 181 			while((SPI_SR & SPI_SR_BSY) != 0);
4721  04e8 c65203        	ld	a,_SPI_SR
4722  04eb a580          	bcp	a,#128
4723  04ed 26f9          	jrne	L3172
4724                     ; 182 			PA_ODR |= (1<<3);
4726  04ef 72165000      	bset	_PA_ODR,#3
4727                     ; 183 			timers_int_on();
4729  04f3 ad0a          	call	_timers_int_on
4731                     ; 184 	return;
4734  04f5 81            	ret
4759                     ; 188 void timers_int_off(void)
4759                     ; 189 {
4760                     	switch	.text
4761  04f6               _timers_int_off:
4765                     ; 190 	TIM1_IER &= ~TIM1_IER_UIE;
4767  04f6 72115254      	bres	_TIM1_IER,#0
4768                     ; 192 	TIM2_IER = 0;
4770  04fa 725f5303      	clr	_TIM2_IER
4771                     ; 193 }
4774  04fe 81            	ret
4799                     ; 196 void timers_int_on(void)
4799                     ; 197 {
4800                     	switch	.text
4801  04ff               _timers_int_on:
4805                     ; 198 	TIM1_IER |= TIM1_IER_UIE;
4807  04ff 72105254      	bset	_TIM1_IER,#0
4808                     ; 199 	TIM2_IER |=	TIM2_IER_CC1IE |TIM2_IER_UIE;	//overflow int and compare 1
4810  0503 c65303        	ld	a,_TIM2_IER
4811  0506 aa03          	or	a,#3
4812  0508 c75303        	ld	_TIM2_IER,a
4813                     ; 200 }
4816  050b 81            	ret
4865                     ; 1 void time_write(void)
4865                     ; 2 {
4866                     	switch	.text
4867  050c               _time_write:
4871                     ; 5 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
4873  050c b615          	ld	a,_fresh_hours_dec
4874  050e 97            	ld	xl,a
4875  050f a610          	ld	a,#16
4876  0511 42            	mul	x,a
4877  0512 9f            	ld	a,xl
4878  0513 bb14          	add	a,_fresh_hours
4879  0515 b714          	ld	_fresh_hours,a
4880                     ; 6 	fresh_min = fresh_min + (fresh_min_dec<<4);
4882  0517 b613          	ld	a,_fresh_min_dec
4883  0519 97            	ld	xl,a
4884  051a a610          	ld	a,#16
4885  051c 42            	mul	x,a
4886  051d 9f            	ld	a,xl
4887  051e bb12          	add	a,_fresh_min
4888  0520 b712          	ld	_fresh_min,a
4889                     ; 7 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
4891  0522 b611          	ld	a,_fresh_sec_dec
4892  0524 97            	ld	xl,a
4893  0525 a610          	ld	a,#16
4894  0527 42            	mul	x,a
4895  0528 9f            	ld	a,xl
4896  0529 bb10          	add	a,_fresh_sec
4897  052b b710          	ld	_fresh_sec,a
4898                     ; 8 	timers_int_off();
4900  052d adc7          	call	_timers_int_off
4902                     ; 9 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
4904  052f 4b01          	push	#1
4905  0531 ae0014        	ldw	x,#_fresh_hours
4906  0534 89            	pushw	x
4907  0535 aed002        	ldw	x,#53250
4908  0538 cd013e        	call	_i2c_wr_reg
4910  053b 5b03          	addw	sp,#3
4911                     ; 10 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
4913  053d 4b01          	push	#1
4914  053f ae0012        	ldw	x,#_fresh_min
4915  0542 89            	pushw	x
4916  0543 aed001        	ldw	x,#53249
4917  0546 cd013e        	call	_i2c_wr_reg
4919  0549 5b03          	addw	sp,#3
4920                     ; 11 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
4922  054b 4b01          	push	#1
4923  054d ae0010        	ldw	x,#_fresh_sec
4924  0550 89            	pushw	x
4925  0551 aed000        	ldw	x,#53248
4926  0554 cd013e        	call	_i2c_wr_reg
4928  0557 5b03          	addw	sp,#3
4929                     ; 12 	timers_int_on();
4931  0559 ada4          	call	_timers_int_on
4933                     ; 13 }
4936  055b 81            	ret
4988                     ; 15 uint8_t kostil_k155 (uint8_t byte)
4988                     ; 16 {
4989                     	switch	.text
4990  055c               _kostil_k155:
4992  055c 88            	push	a
4993  055d 89            	pushw	x
4994       00000002      OFST:	set	2
4997                     ; 17 	uint8_t tmp = (byte<<1) & 0b00001100;
4999  055e 48            	sll	a
5000  055f a40c          	and	a,#12
5001  0561 6b01          	ld	(OFST-1,sp),a
5002                     ; 18 	uint8_t tmp2 = (byte>>2) & 0b00000010;
5004  0563 7b03          	ld	a,(OFST+1,sp)
5005  0565 44            	srl	a
5006  0566 44            	srl	a
5007  0567 a402          	and	a,#2
5008  0569 6b02          	ld	(OFST+0,sp),a
5009                     ; 19 	byte &= 1;
5011  056b 7b03          	ld	a,(OFST+1,sp)
5012  056d a401          	and	a,#1
5013  056f 6b03          	ld	(OFST+1,sp),a
5014                     ; 20 	byte |= tmp | tmp2;
5016  0571 7b01          	ld	a,(OFST-1,sp)
5017  0573 1a02          	or	a,(OFST+0,sp)
5018  0575 1a03          	or	a,(OFST+1,sp)
5019  0577 6b03          	ld	(OFST+1,sp),a
5020                     ; 21 	return byte;
5022  0579 7b03          	ld	a,(OFST+1,sp)
5025  057b 5b03          	addw	sp,#3
5026  057d 81            	ret
5067                     ; 1 void spi_setup(void)
5067                     ; 2  {
5068                     	switch	.text
5069  057e               _spi_setup:
5073                     ; 3     SPI_CR1= 0b01000100;//0x7C;       //this
5075  057e 35445200      	mov	_SPI_CR1,#68
5076                     ; 5  }
5079  0582 81            	ret
5115                     ; 8 void spi_send(uint8_t msg)
5115                     ; 9 {
5116                     	switch	.text
5117  0583               _spi_send:
5119  0583 88            	push	a
5120       00000000      OFST:	set	0
5123  0584               L1403:
5124                     ; 11 	while((SPI_SR & SPI_SR_BSY) != 0)
5126  0584 c65203        	ld	a,_SPI_SR
5127  0587 a580          	bcp	a,#128
5128  0589 26f9          	jrne	L1403
5129                     ; 14 	SPI_DR = msg;
5131  058b 7b01          	ld	a,(OFST+1,sp)
5132  058d c75204        	ld	_SPI_DR,a
5133                     ; 15 }
5136  0590 84            	pop	a
5137  0591 81            	ret
5179                     ; 4 void UART_Resieved (void)
5179                     ; 5 {
5180                     	switch	.text
5181  0592               _UART_Resieved:
5185                     ; 6 	uart_routine(UART1_DR);
5187  0592 c65231        	ld	a,_UART1_DR
5188  0595 cd002a        	call	_uart_routine
5190                     ; 7 }
5193  0598 81            	ret
5218                     ; 9 void SPI_Transmitted(void)
5218                     ; 10 {
5219                     	switch	.text
5220  0599               _SPI_Transmitted:
5224                     ; 11 	spi_send(temp3);
5226  0599 b609          	ld	a,_temp3
5227  059b ade6          	call	_spi_send
5229                     ; 12 }
5232  059d 81            	ret
5255                     ; 14 void I2C_Event(void)
5255                     ; 15 {
5256                     	switch	.text
5257  059e               _I2C_Event:
5261                     ; 17 }
5264  059e 81            	ret
5290                     ; 19 void Keys_switched(void)
5290                     ; 20 {
5291                     	switch	.text
5292  059f               _Keys_switched:
5296                     ; 21 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
5298  059f c650a0        	ld	a,_EXTI_CR1
5299  05a2 43            	cpl	a
5300  05a3 a430          	and	a,#48
5301  05a5 c750a0        	ld	_EXTI_CR1,a
5302                     ; 22 	PC_CR2 = 0;
5304  05a8 725f500e      	clr	_PC_CR2
5305                     ; 23 	timer2_start(0xff);	
5307  05ac ae00ff        	ldw	x,#255
5308  05af cd0396        	call	_timer2_start
5310                     ; 24 }
5313  05b2 81            	ret
5348                     ; 26 void time_refresh (void)
5348                     ; 27 {
5349                     	switch	.text
5350  05b3               _time_refresh:
5354                     ; 29 	timers_int_off();
5356  05b3 cd04f6        	call	_timers_int_off
5358                     ; 30 	i2c_rd_reg(0xD0, 0, &fresh_sec, 1); 	
5360  05b6 4b01          	push	#1
5361  05b8 ae0010        	ldw	x,#_fresh_sec
5362  05bb 89            	pushw	x
5363  05bc aed000        	ldw	x,#53248
5364  05bf cd01a1        	call	_i2c_rd_reg
5366  05c2 5b03          	addw	sp,#3
5367                     ; 31 	i2c_rd_reg(0xD0, 1, &fresh_min, 1);
5369  05c4 4b01          	push	#1
5370  05c6 ae0012        	ldw	x,#_fresh_min
5371  05c9 89            	pushw	x
5372  05ca aed001        	ldw	x,#53249
5373  05cd cd01a1        	call	_i2c_rd_reg
5375  05d0 5b03          	addw	sp,#3
5376                     ; 32 	i2c_rd_reg(0xD0, 2, &fresh_hours, 1);
5378  05d2 4b01          	push	#1
5379  05d4 ae0014        	ldw	x,#_fresh_hours
5380  05d7 89            	pushw	x
5381  05d8 aed002        	ldw	x,#53250
5382  05db cd01a1        	call	_i2c_rd_reg
5384  05de 5b03          	addw	sp,#3
5385                     ; 33 	timers_int_on();
5387  05e0 cd04ff        	call	_timers_int_on
5389                     ; 35 	seconds_tens = (fresh_sec & 0xf0)>>4;
5391  05e3 b610          	ld	a,_fresh_sec
5392  05e5 a4f0          	and	a,#240
5393  05e7 4e            	swap	a
5394  05e8 a40f          	and	a,#15
5395  05ea b70b          	ld	_seconds_tens,a
5396                     ; 36 	minutes_tens = (fresh_min & 0xf0)>>4;
5398  05ec b612          	ld	a,_fresh_min
5399  05ee a4f0          	and	a,#240
5400  05f0 4e            	swap	a
5401  05f1 a40f          	and	a,#15
5402  05f3 b70a          	ld	_minutes_tens,a
5403                     ; 37 	hours_tens = (fresh_hours & 0xf0)>>4;
5405  05f5 b614          	ld	a,_fresh_hours
5406  05f7 a4f0          	and	a,#240
5407  05f9 4e            	swap	a
5408  05fa a40f          	and	a,#15
5409  05fc b709          	ld	_hours_tens,a
5410                     ; 39 	seconds = fresh_sec & 0x0f;
5412  05fe b610          	ld	a,_fresh_sec
5413  0600 a40f          	and	a,#15
5414  0602 b70c          	ld	_seconds,a
5415                     ; 40 	minutes = fresh_min & 0x0f;
5417  0604 b612          	ld	a,_fresh_min
5418  0606 a40f          	and	a,#15
5419  0608 b70d          	ld	_minutes,a
5420                     ; 41 	hours = fresh_hours & 0x0f;
5422  060a b614          	ld	a,_fresh_hours
5423  060c a40f          	and	a,#15
5424  060e b70e          	ld	_hours,a
5425                     ; 42 }
5428  0610 81            	ret
5457                     ; 44 void digits_shift_init (void)
5457                     ; 45 {
5458                     	switch	.text
5459  0611               _digits_shift_init:
5463                     ; 47 	seconds_tens = 0;
5465  0611 3f0b          	clr	_seconds_tens
5466                     ; 48 	minutes_tens = 0;
5468  0613 3f0a          	clr	_minutes_tens
5469                     ; 49 	hours_tens = 0;
5471  0615 3f09          	clr	_hours_tens
5472                     ; 51 	seconds = 0;
5474  0617 3f0c          	clr	_seconds
5475                     ; 52 	minutes = 0;
5477  0619 3f0d          	clr	_minutes
5478                     ; 53 	hours = 0;
5480  061b 3f0e          	clr	_hours
5481                     ; 54 }
5484  061d 81            	ret
5552                     ; 21 int main( void )
5552                     ; 22 {
5553                     	switch	.text
5554  061e               _main:
5558                     ; 24 		CLK_CKDIVR=0;                //	no dividers
5560  061e 725f50c6      	clr	_CLK_CKDIVR
5561                     ; 26 		for (i = 0; i < 0xFFFF; i++);
5563  0622 5f            	clrw	x
5564  0623 bf0b          	ldw	_i,x
5565  0625               L1513:
5569  0625 be0b          	ldw	x,_i
5570  0627 1c0001        	addw	x,#1
5571  062a bf0b          	ldw	_i,x
5574  062c be0b          	ldw	x,_i
5575  062e a3ffff        	cpw	x,#65535
5576  0631 25f2          	jrult	L1513
5577                     ; 27 		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //clocking for TIM1, UART1, SPI i I2C
5579  0633 35ff50c7      	mov	_CLK_PCKENR1,#255
5580                     ; 30     PA_DDR=(1<<3) | (1<<2); //0b000001000; //output for register's latch, input for RTC 1 Hz pulse
5582  0637 350c5002      	mov	_PA_DDR,#12
5583                     ; 31     PA_CR1= 0xff;        //	pull-up on inputs, push-pull on outputs
5585  063b 35ff5003      	mov	_PA_CR1,#255
5586                     ; 32     PA_ODR |= (1<<3);
5588  063f 72165000      	bset	_PA_ODR,#3
5589                     ; 33 		PA_CR2 |=(1<<3);        //	interrupt on PA1 for 1hz
5591  0643 72165004      	bset	_PA_CR2,#3
5592                     ; 35     PC_DDR=0x60; //0b01100000; // buttons pins as input
5594  0647 3560500c      	mov	_PC_DDR,#96
5595                     ; 36     PC_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5597  064b 35ff500d      	mov	_PC_CR1,#255
5598                     ; 37     PC_CR2 |= (1<<4) | (1<<3);        //	interrapts for buttons
5600  064f c6500e        	ld	a,_PC_CR2
5601  0652 aa18          	or	a,#24
5602  0654 c7500e        	ld	_PC_CR2,a
5603                     ; 39 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM
5605  0657 35a85011      	mov	_PD_DDR,#168
5606                     ; 40     PD_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5608  065b 35ff5012      	mov	_PD_CR1,#255
5609                     ; 41     PD_ODR = (1 << 3);
5611  065f 3508500f      	mov	_PD_ODR,#8
5612                     ; 45     spi_setup();
5614  0663 cd057e        	call	_spi_setup
5616                     ; 48 		uart_setup();
5618  0666 cd0000        	call	_uart_setup
5620                     ; 49 		uart_send('h');
5622  0669 a668          	ld	a,#104
5623  066b cd0019        	call	_uart_send
5625                     ; 52     timer1_setup(65500,0xffff);//	freq in hz and top value
5627  066e aeffff        	ldw	x,#65535
5628  0671 89            	pushw	x
5629  0672 aeffdc        	ldw	x,#65500
5630  0675 cd02e4        	call	_timer1_setup
5632  0678 85            	popw	x
5633                     ; 53 		timer2_setup();
5635  0679 cd034f        	call	_timer2_setup
5637                     ; 58 		i2c_master_init(16000000, 100000);
5639  067c ae86a0        	ldw	x,#34464
5640  067f 89            	pushw	x
5641  0680 ae0001        	ldw	x,#1
5642  0683 89            	pushw	x
5643  0684 ae2400        	ldw	x,#9216
5644  0687 89            	pushw	x
5645  0688 ae00f4        	ldw	x,#244
5646  068b 89            	pushw	x
5647  068c cd00bc        	call	_i2c_master_init
5649  068f 5b08          	addw	sp,#8
5650                     ; 62 		timers_int_off();
5652  0691 cd04f6        	call	_timers_int_off
5654                     ; 63 		i2c_rd_reg(ds_address, 7, &temp, 1);
5656  0694 4b01          	push	#1
5657  0696 ae0003        	ldw	x,#_temp
5658  0699 89            	pushw	x
5659  069a aed007        	ldw	x,#53255
5660  069d cd01a1        	call	_i2c_rd_reg
5662  06a0 5b03          	addw	sp,#3
5663                     ; 64 	if (temp != 0b10010000)	// if OUT and SWQ == 0
5665  06a2 b603          	ld	a,_temp
5666  06a4 a190          	cp	a,#144
5667  06a6 270e          	jreq	L7513
5668                     ; 66 			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//	setup RTC for 1Hz output
5670  06a8 4b01          	push	#1
5671  06aa ae000e        	ldw	x,#_ds_cr
5672  06ad 89            	pushw	x
5673  06ae aed007        	ldw	x,#53255
5674  06b1 cd013e        	call	_i2c_wr_reg
5676  06b4 5b03          	addw	sp,#3
5677  06b6               L7513:
5678                     ; 69 		i2c_rd_reg(ds_address, 0, &temp, 1);
5680  06b6 4b01          	push	#1
5681  06b8 ae0003        	ldw	x,#_temp
5682  06bb 89            	pushw	x
5683  06bc aed000        	ldw	x,#53248
5684  06bf cd01a1        	call	_i2c_rd_reg
5686  06c2 5b03          	addw	sp,#3
5687                     ; 72 	if((temp & 0x80) == 0x80)
5689  06c4 b603          	ld	a,_temp
5690  06c6 a480          	and	a,#128
5691  06c8 a180          	cp	a,#128
5692  06ca 2610          	jrne	L1613
5693                     ; 74 			temp = 0;
5695  06cc 3f03          	clr	_temp
5696                     ; 75 			i2c_wr_reg(ds_address, 0, &temp, 1);
5698  06ce 4b01          	push	#1
5699  06d0 ae0003        	ldw	x,#_temp
5700  06d3 89            	pushw	x
5701  06d4 aed000        	ldw	x,#53248
5702  06d7 cd013e        	call	_i2c_wr_reg
5704  06da 5b03          	addw	sp,#3
5705  06dc               L1613:
5706                     ; 78 		timers_int_on();
5708  06dc cd04ff        	call	_timers_int_on
5710                     ; 79 		timer1_start();
5712  06df cd0391        	call	_timer1_start
5714                     ; 80 		timer2_start(TIM2_TOP);
5716  06e2 ae3e80        	ldw	x,#16000
5717  06e5 cd0396        	call	_timer2_start
5719                     ; 81 		_asm ("RIM");  //on interupts
5722  06e8 9a            RIM
5724  06e9               L3613:
5726  06e9 20fe          	jra	L3613
5739                     	xdef	_main
5740                     	xdef	_Keys_switched
5741                     	xdef	_I2C_Event
5742                     	xdef	_SPI_Transmitted
5743                     	xdef	_UART_Resieved
5744                     	xdef	_spi_setup
5745                     	xdef	_timer2_compare
5746                     	xdef	_timer1_compare
5747                     	xdef	_Timer1_overflow
5748                     	xdef	_Timer2_Overflow
5749                     	xdef	_timer2_start
5750                     	xdef	_timer1_start
5751                     	xdef	_timer1_comp_stop
5752                     	xdef	_timer1_comp_start
5753                     	xdef	_timer4_setup
5754                     	xdef	_timer2_setup
5755                     	xdef	_timer1_setup
5756                     	xdef	_kostil_k155
5757                     	xdef	_digits_shift_init
5758                     	xdef	_time_refresh
5759                     	xdef	_timers_int_on
5760                     	xdef	_timers_int_off
5761                     	xdef	_spi_send
5762                     	xdef	_i2c_rd_reg
5763                     	xdef	_i2c_wr_reg
5764                     	xdef	_i2c_master_init
5765                     	xdef	_Key_interrupt
5766                     	xdef	_uart_routine
5767                     	xdef	_uart_send
5768                     	xdef	_uart_setup
5769                     	xdef	_time_write
5770                     	switch	.ubsct
5771  0000               _i2c_flags:
5772  0000 00            	ds.b	1
5773                     	xdef	_i2c_flags
5774  0001               _flags:
5775  0001 00            	ds.b	1
5776                     	xdef	_flags
5777                     	xdef	_tim1comp
5778  0002               _shifting:
5779  0002 00            	ds.b	1
5780                     	xdef	_shifting
5781                     	xdef	_ds_cr
5782                     	xdef	_schetchik2
5783                     	xdef	_i
5784                     	xdef	_schetchik
5785                     	xdef	_temp3
5786                     	xdef	_temp2
5787  0003               _temp:
5788  0003 00            	ds.b	1
5789                     	xdef	_temp
5790  0004               _pins:
5791  0004 00            	ds.b	1
5792                     	xdef	_pins
5793  0005               _fresh_data_pointer:
5794  0005 0000          	ds.b	2
5795                     	xdef	_fresh_data_pointer
5796  0007               _data_pointer:
5797  0007 0000          	ds.b	2
5798                     	xdef	_data_pointer
5799                     	xdef	_time_pointer
5800  0009               _hours_tens:
5801  0009 00            	ds.b	1
5802                     	xdef	_hours_tens
5803  000a               _minutes_tens:
5804  000a 00            	ds.b	1
5805                     	xdef	_minutes_tens
5806  000b               _seconds_tens:
5807  000b 00            	ds.b	1
5808                     	xdef	_seconds_tens
5809  000c               _seconds:
5810  000c 00            	ds.b	1
5811                     	xdef	_seconds
5812  000d               _minutes:
5813  000d 00            	ds.b	1
5814                     	xdef	_minutes
5815  000e               _hours:
5816  000e 00            	ds.b	1
5817                     	xdef	_hours
5818  000f               _timeset:
5819  000f 00            	ds.b	1
5820                     	xdef	_timeset
5821  0010               _fresh_sec:
5822  0010 00            	ds.b	1
5823                     	xdef	_fresh_sec
5824  0011               _fresh_sec_dec:
5825  0011 00            	ds.b	1
5826                     	xdef	_fresh_sec_dec
5827  0012               _fresh_min:
5828  0012 00            	ds.b	1
5829                     	xdef	_fresh_min
5830  0013               _fresh_min_dec:
5831  0013 00            	ds.b	1
5832                     	xdef	_fresh_min_dec
5833  0014               _fresh_hours:
5834  0014 00            	ds.b	1
5835                     	xdef	_fresh_hours
5836  0015               _fresh_hours_dec:
5837  0015 00            	ds.b	1
5838                     	xdef	_fresh_hours_dec
5839                     	xdef	_dots_on
5840                     	xdef	_dots_upd
5841  0016               _lamp_number_data:
5842  0016 00            	ds.b	1
5843                     	xdef	_lamp_number_data
5844  0017               _k155_data:
5845  0017 00            	ds.b	1
5846                     	xdef	_k155_data
5847                     	xdef	_dots
5848                     	xdef	_lamp_number
5849                     	xref.b	c_lreg
5850                     	xref.b	c_x
5870                     	xref	c_lrsh
5871                     	xref	c_ldiv
5872                     	xref	c_uitolx
5873                     	xref	c_ludv
5874                     	xref	c_rtol
5875                     	xref	c_ltor
5876                     	end
