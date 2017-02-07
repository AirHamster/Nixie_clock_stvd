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
2778                     ; 14 		temp =msg;
2780  001a b703          	ld	_temp,a
2782  001c               L7771:
2783                     ; 15 		while((UART1_SR & 0x80) == 0x00);
2785  001c c65230        	ld	a,_UART1_SR
2786  001f a580          	bcp	a,#128
2787  0021 27f9          	jreq	L7771
2788                     ; 16 		UART1_DR = msg;
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
2850                     ; 21 		temp2 = data - 0x30;
2852  002b a030          	sub	a,#48
2853  002d b708          	ld	_temp2,a
2854                     ; 22 		if (timeset != 0 && timeset <= 5){
2856  002f 3d0f          	tnz	_timeset
2857  0031 2719          	jreq	L1202
2859  0033 b60f          	ld	a,_timeset
2860  0035 a106          	cp	a,#6
2861  0037 2413          	jruge	L1202
2862                     ; 23 			* fresh_data_pointer-- = data-0x30;
2864  0039 7b01          	ld	a,(OFST+1,sp)
2865  003b a030          	sub	a,#48
2866  003d be05          	ldw	x,_fresh_data_pointer
2867  003f 1d0001        	subw	x,#1
2868  0042 bf05          	ldw	_fresh_data_pointer,x
2869  0044 1c0001        	addw	x,#1
2870  0047 f7            	ld	(x),a
2871                     ; 24 			timeset++;
2873  0048 3c0f          	inc	_timeset
2874                     ; 25 			return ;
2877  004a 84            	pop	a
2878  004b 81            	ret
2879  004c               L1202:
2880                     ; 27 		if (timeset == 6){
2882  004c b60f          	ld	a,_timeset
2883  004e a106          	cp	a,#6
2884  0050 2616          	jrne	L3202
2885                     ; 28 			*fresh_data_pointer = data-0x30;
2887  0052 7b01          	ld	a,(OFST+1,sp)
2888  0054 a030          	sub	a,#48
2889  0056 92c705        	ld	[_fresh_data_pointer.w],a
2890                     ; 29 			timeset = 0;
2892  0059 3f0f          	clr	_timeset
2893                     ; 30 			time_write();
2895  005b cd04c4        	call	_time_write
2897                     ; 31 			uart_send('O');
2899  005e a64f          	ld	a,#79
2900  0060 adb7          	call	_uart_send
2902                     ; 32 			uart_send('K');
2904  0062 a64b          	ld	a,#75
2905  0064 adb3          	call	_uart_send
2907                     ; 33 			return;
2910  0066 84            	pop	a
2911  0067 81            	ret
2912  0068               L3202:
2913                     ; 36 		if (data == 's'){
2915  0068 7b01          	ld	a,(OFST+1,sp)
2916  006a a173          	cp	a,#115
2917  006c 260b          	jrne	L5202
2918                     ; 37 			timeset = 1;
2920  006e 3501000f      	mov	_timeset,#1
2921                     ; 38 			fresh_data_pointer = &fresh_hours_dec;
2923  0072 ae0015        	ldw	x,#_fresh_hours_dec
2924  0075 bf05          	ldw	_fresh_data_pointer,x
2925                     ; 39 			return;
2928  0077 84            	pop	a
2929  0078 81            	ret
2930  0079               L5202:
2931                     ; 43 		if (data == 't'){
2933  0079 7b01          	ld	a,(OFST+1,sp)
2934  007b a174          	cp	a,#116
2935  007d 2635          	jrne	L7202
2936                     ; 44 			uart_send(hours_tens+0x30);
2938  007f b609          	ld	a,_hours_tens
2939  0081 ab30          	add	a,#48
2940  0083 ad94          	call	_uart_send
2942                     ; 45 			uart_send(hours+0x30);
2944  0085 b60e          	ld	a,_hours
2945  0087 ab30          	add	a,#48
2946  0089 ad8e          	call	_uart_send
2948                     ; 46 			uart_send(':');	
2950  008b a63a          	ld	a,#58
2951  008d ad8a          	call	_uart_send
2953                     ; 47 			uart_send(minutes_tens+0x30);
2955  008f b60a          	ld	a,_minutes_tens
2956  0091 ab30          	add	a,#48
2957  0093 ad84          	call	_uart_send
2959                     ; 48 			uart_send(minutes+0x30);
2961  0095 b60d          	ld	a,_minutes
2962  0097 ab30          	add	a,#48
2963  0099 cd0019        	call	_uart_send
2965                     ; 49 			uart_send(':'); 
2967  009c a63a          	ld	a,#58
2968  009e cd0019        	call	_uart_send
2970                     ; 50 			uart_send(seconds_tens+0x30);
2972  00a1 b60b          	ld	a,_seconds_tens
2973  00a3 ab30          	add	a,#48
2974  00a5 cd0019        	call	_uart_send
2976                     ; 51 			uart_send(seconds+0x30);
2978  00a8 b60c          	ld	a,_seconds
2979  00aa ab30          	add	a,#48
2980  00ac cd0019        	call	_uart_send
2982                     ; 52 			uart_send(0x0A);
2984  00af a60a          	ld	a,#10
2985  00b1 cd0019        	call	_uart_send
2987  00b4               L7202:
2988                     ; 54 }
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
3862                     ; 10 void timer1_setup(uint16_t tim_freq, uint16_t top)
3862                     ; 11  {
3863                     	switch	.text
3864  02e4               _timer1_setup:
3866  02e4 89            	pushw	x
3867  02e5 5204          	subw	sp,#4
3868       00000004      OFST:	set	4
3871                     ; 12   TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
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
3892                     ; 13   TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; // 16 divider
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
3914                     ; 14   TIM1_ARRH = (top) >> 8; //	overflow frequency = 16М / 8 / 1000 = 2000 Гц
3916  0334 7b09          	ld	a,(OFST+5,sp)
3917  0336 c75262        	ld	_TIM1_ARRH,a
3918                     ; 15   TIM1_ARRL = (top)& 0xFF;
3920  0339 7b0a          	ld	a,(OFST+6,sp)
3921  033b a4ff          	and	a,#255
3922  033d c75263        	ld	_TIM1_ARRL,a
3923                     ; 17   TIM1_CR1 |= TIM1_CR1_URS; //only overflow int
3925  0340 72145250      	bset	_TIM1_CR1,#2
3926                     ; 18   TIM1_EGR |= TIM1_EGR_UG;  //call Update Event
3928  0344 72105257      	bset	_TIM1_EGR,#0
3929                     ; 19   TIM1_IER |= TIM1_IER_UIE; //int enable
3931  0348 72105254      	bset	_TIM1_IER,#0
3932                     ; 20  }
3935  034c 5b06          	addw	sp,#6
3936  034e 81            	ret
3967                     ; 23 void timer2_setup(void)
3967                     ; 24  {
3968                     	switch	.text
3969  034f               _timer2_setup:
3973                     ; 26 		TIM2_CCR1H = dots_upd >> 8;
3975  034f 5500025311    	mov	_TIM2_CCR1H,_dots_upd
3976                     ; 27 		TIM2_CCR1L = dots_upd & 0xFF;
3978  0354 b603          	ld	a,_dots_upd+1
3979  0356 a4ff          	and	a,#255
3980  0358 c75312        	ld	_TIM2_CCR1L,a
3981                     ; 28 		TIM2_CCMR1 |= TIM2_CCMR_OCxPE;	//preload
3983  035b 72165307      	bset	_TIM2_CCMR1,#3
3984                     ; 30     TIM2_IER |=	TIM2_IER_CC1IE | TIM2_IER_UIE;	//overflow int and compare 1   
3986  035f c65303        	ld	a,_TIM2_IER
3987  0362 aa03          	or	a,#3
3988  0364 c75303        	ld	_TIM2_IER,a
3989                     ; 31     TIM2_PSCR = 0;
3991  0367 725f530e      	clr	_TIM2_PSCR
3992                     ; 32     TIM2_ARRH = 0;
3994  036b 725f530f      	clr	_TIM2_ARRH
3995                     ; 33     TIM2_ARRL = 0;
3997  036f 725f5310      	clr	_TIM2_ARRL
3998                     ; 34  } 
4001  0373 81            	ret
4038                     ; 37  void timer1_comp_start(uint16_t val)
4038                     ; 38  {
4039                     	switch	.text
4040  0374               _timer1_comp_start:
4044                     ; 39 		TIM1_IER |= TIM1_IER_CC1IE;
4046  0374 72125254      	bset	_TIM1_IER,#1
4047                     ; 40 		TIM1_CCR1H = val >> 8;
4049  0378 9e            	ld	a,xh
4050  0379 c75265        	ld	_TIM1_CCR1H,a
4051                     ; 41 		TIM1_CCR1L = val & 0xFF;
4053  037c 9f            	ld	a,xl
4054  037d a4ff          	and	a,#255
4055  037f c75266        	ld	_TIM1_CCR1L,a
4056                     ; 42  }
4059  0382 81            	ret
4083                     ; 43  void timer1_comp_stop(void){
4084                     	switch	.text
4085  0383               _timer1_comp_stop:
4089                     ; 44 	 TIM1_IER &= ~TIM1_IER_CC1IE;
4091  0383 72135254      	bres	_TIM1_IER,#1
4092                     ; 45  }
4095  0387 81            	ret
4119                     ; 47  void timer1_start(void)
4119                     ; 48  {
4120                     	switch	.text
4121  0388               _timer1_start:
4125                     ; 49    TIM1_CR1 |= TIM1_CR1_CEN;
4127  0388 72105250      	bset	_TIM1_CR1,#0
4128                     ; 50  }
4131  038c 81            	ret
4168                     ; 52 void timer2_start(uint16_t top_val)
4168                     ; 53 {
4169                     	switch	.text
4170  038d               _timer2_start:
4174                     ; 54   TIM2_ARRH =top_val >>8;
4176  038d 9e            	ld	a,xh
4177  038e c7530f        	ld	_TIM2_ARRH,a
4178                     ; 55   TIM2_ARRL =top_val & 0xFF;
4180  0391 9f            	ld	a,xl
4181  0392 a4ff          	and	a,#255
4182  0394 c75310        	ld	_TIM2_ARRL,a
4183                     ; 56   TIM2_CR1 |= TIM2_CR1_CEN;
4185  0397 72105300      	bset	_TIM2_CR1,#0
4186                     ; 57 }
4189  039b 81            	ret
4222                     ; 60 void Timer2_Overflow (void)
4222                     ; 61 {
4223                     	switch	.text
4224  039c               _Timer2_Overflow:
4228                     ; 62 		TIM2_SR1 &= ~TIM2_SR1_UIF;
4230  039c 72115304      	bres	_TIM2_SR1,#0
4231                     ; 64 		timers_int_off();
4233  03a0 cd04ae        	call	_timers_int_off
4235                     ; 65 		PA_ODR &= (0<<3);
4237  03a3 725f5000      	clr	_PA_ODR
4238                     ; 67 		spi_send(kostil_k155(k155_data));
4240  03a7 b617          	ld	a,_k155_data
4241  03a9 cd0514        	call	_kostil_k155
4243  03ac cd053b        	call	_spi_send
4245                     ; 68 		spi_send(lamp_number_data | dots);
4247  03af b616          	ld	a,_lamp_number_data
4248  03b1 ba01          	or	a,_dots
4249  03b3 cd053b        	call	_spi_send
4252  03b6               L3752:
4253                     ; 69 		while((SPI_SR & SPI_SR_BSY) != 0);
4255  03b6 c65203        	ld	a,_SPI_SR
4256  03b9 a580          	bcp	a,#128
4257  03bb 26f9          	jrne	L3752
4258                     ; 70 		PA_ODR |= (1<<3);
4260  03bd 72165000      	bset	_PA_ODR,#3
4261                     ; 71 		timers_int_on();
4263  03c1 cd04b7        	call	_timers_int_on
4265                     ; 72 }
4268  03c4 81            	ret
4299                     ; 75 void Timer1_overflow (void)
4299                     ; 76 {
4300                     	switch	.text
4301  03c5               _Timer1_overflow:
4305                     ; 77 		TIM1_SR1 &= ~TIM1_SR1_UIF;
4307  03c5 72115255      	bres	_TIM1_SR1,#0
4308                     ; 78 		dots = ~dots & DOTS_MASK;
4310  03c9 b601          	ld	a,_dots
4311  03cb 43            	cpl	a
4312  03cc a410          	and	a,#16
4313  03ce b701          	ld	_dots,a
4314                     ; 80 		time_refresh();
4316  03d0 cd056b        	call	_time_refresh
4318                     ; 82 		if ((minutes == 0) && (shifting == 0)){
4320  03d3 3d0d          	tnz	_minutes
4321  03d5 2610          	jrne	L7062
4323  03d7 3d02          	tnz	_shifting
4324  03d9 260c          	jrne	L7062
4325                     ; 83 			tim1comp = 5950;	//top of tim1/10
4327  03db ae173e        	ldw	x,#5950
4328  03de bf0f          	ldw	_tim1comp,x
4329                     ; 84 			digits_shift_init();	//set every digit to zero
4331  03e0 cd05c9        	call	_digits_shift_init
4333                     ; 85 			timer1_comp_start(tim1comp);	//enable compare interrupt
4335  03e3 be0f          	ldw	x,_tim1comp
4336  03e5 ad8d          	call	_timer1_comp_start
4338  03e7               L7062:
4339                     ; 87 		if (minutes != 0 && minutes != 5){
4341  03e7 3d0d          	tnz	_minutes
4342  03e9 2708          	jreq	L1162
4344  03eb b60d          	ld	a,_minutes
4345  03ed a105          	cp	a,#5
4346  03ef 2702          	jreq	L1162
4347                     ; 88 			shifting = 0;	//disable block when minutes increased
4349  03f1 3f02          	clr	_shifting
4350  03f3               L1162:
4351                     ; 90 }
4354  03f3 81            	ret
4388                     ; 93 void timer1_compare(void){
4389                     	switch	.text
4390  03f4               _timer1_compare:
4394                     ; 94 		TIM1_SR1 &= ~TIM1_SR1_CC1IF;
4396  03f4 72135255      	bres	_TIM1_SR1,#1
4397                     ; 95 		if(hours < 9){
4399  03f8 b60e          	ld	a,_hours
4400  03fa a109          	cp	a,#9
4401  03fc 241a          	jruge	L3262
4402                     ; 96 		seconds_tens++;
4404  03fe 3c0b          	inc	_seconds_tens
4405                     ; 97 		minutes_tens++;
4407  0400 3c0a          	inc	_minutes_tens
4408                     ; 98 		hours_tens++;
4410  0402 3c09          	inc	_hours_tens
4411                     ; 100 		seconds++;
4413  0404 3c0c          	inc	_seconds
4414                     ; 101 		minutes++;
4416  0406 3c0d          	inc	_minutes
4417                     ; 102 		hours++;
4419  0408 3c0e          	inc	_hours
4420                     ; 103 		tim1comp += 5950;
4422  040a be0f          	ldw	x,_tim1comp
4423  040c 1c173e        	addw	x,#5950
4424  040f bf0f          	ldw	_tim1comp,x
4425                     ; 104 		timer1_comp_start(tim1comp);
4427  0411 be0f          	ldw	x,_tim1comp
4428  0413 cd0374        	call	_timer1_comp_start
4431  0416 2007          	jra	L5262
4432  0418               L3262:
4433                     ; 107 			shifting = 1;	//block rolling
4435  0418 35010002      	mov	_shifting,#1
4436                     ; 108 			timer1_comp_stop();
4438  041c cd0383        	call	_timer1_comp_stop
4440  041f               L5262:
4441                     ; 110 }
4444  041f 81            	ret
4484                     ; 112 void timer2_compare(void)
4484                     ; 113 {
4485                     	switch	.text
4486  0420               _timer2_compare:
4490                     ; 114 	TIM2_SR1 &= ~TIM2_SR1_CC1IF;
4492  0420 72135304      	bres	_TIM2_SR1,#1
4493                     ; 115 	IWDG_KR = KEY_REFRESH; //	Watchdog reset
4495  0424 35aa50e0      	mov	_IWDG_KR,#170
4496                     ; 117 	if (schetchik == 1)
4498  0428 b60a          	ld	a,_schetchik
4499  042a a101          	cp	a,#1
4500  042c 2658          	jrne	L7462
4501                     ; 119 	switch (lamp_number)
4503  042e b600          	ld	a,_lamp_number
4505                     ; 132 	break;
4506  0430 4d            	tnz	a
4507  0431 270b          	jreq	L7262
4508  0433 4a            	dec	a
4509  0434 270d          	jreq	L1362
4510  0436 4a            	dec	a
4511  0437 270f          	jreq	L3362
4512  0439 4a            	dec	a
4513  043a 2711          	jreq	L5362
4514  043c 2012          	jra	L3562
4515  043e               L7262:
4516                     ; 121 	case 0:
4516                     ; 122 	k155_data = hours_tens; 
4518  043e 450917        	mov	_k155_data,_hours_tens
4519                     ; 123 	break;
4521  0441 200d          	jra	L3562
4522  0443               L1362:
4523                     ; 124 	case 1:
4523                     ; 125 	k155_data = hours;
4525  0443 450e17        	mov	_k155_data,_hours
4526                     ; 126 	break;
4528  0446 2008          	jra	L3562
4529  0448               L3362:
4530                     ; 127 	case 2:
4530                     ; 128 	k155_data = minutes_tens;
4532  0448 450a17        	mov	_k155_data,_minutes_tens
4533                     ; 129 	break;
4535  044b 2003          	jra	L3562
4536  044d               L5362:
4537                     ; 130 	case 3:
4537                     ; 131 	k155_data = minutes;
4539  044d 450d17        	mov	_k155_data,_minutes
4540                     ; 132 	break;
4542  0450               L3562:
4543                     ; 135 	if (lamp_number < 3)
4545  0450 b600          	ld	a,_lamp_number
4546  0452 a103          	cp	a,#3
4547  0454 2415          	jruge	L5562
4548                     ; 137 			lamp_number_data = (1<<(lamp_number++));
4550  0456 b600          	ld	a,_lamp_number
4551  0458 97            	ld	xl,a
4552  0459 3c00          	inc	_lamp_number
4553  045b 9f            	ld	a,xl
4554  045c 5f            	clrw	x
4555  045d 97            	ld	xl,a
4556  045e a601          	ld	a,#1
4557  0460 5d            	tnzw	x
4558  0461 2704          	jreq	L64
4559  0463               L05:
4560  0463 48            	sll	a
4561  0464 5a            	decw	x
4562  0465 26fc          	jrne	L05
4563  0467               L64:
4564  0467 b716          	ld	_lamp_number_data,a
4566  0469 2017          	jra	L7562
4567  046b               L5562:
4568                     ; 139 		else if (lamp_number >= 3)
4570  046b b600          	ld	a,_lamp_number
4571  046d a103          	cp	a,#3
4572  046f 2511          	jrult	L7562
4573                     ; 141 			lamp_number_data = (1<<(lamp_number));
4575  0471 b600          	ld	a,_lamp_number
4576  0473 5f            	clrw	x
4577  0474 97            	ld	xl,a
4578  0475 a601          	ld	a,#1
4579  0477 5d            	tnzw	x
4580  0478 2704          	jreq	L25
4581  047a               L45:
4582  047a 48            	sll	a
4583  047b 5a            	decw	x
4584  047c 26fc          	jrne	L45
4585  047e               L25:
4586  047e b716          	ld	_lamp_number_data,a
4587                     ; 142 			lamp_number = 0;
4589  0480 3f00          	clr	_lamp_number
4590  0482               L7562:
4591                     ; 145 	schetchik = 0;
4593  0482 3f0a          	clr	_schetchik
4595  0484 2006          	jra	L3662
4596  0486               L7462:
4597                     ; 149 		lamp_number_data = 0;
4599  0486 3f16          	clr	_lamp_number_data
4600                     ; 150 		schetchik = 1;
4602  0488 3501000a      	mov	_schetchik,#1
4603  048c               L3662:
4604                     ; 153 		timers_int_off();
4606  048c ad20          	call	_timers_int_off
4608                     ; 154 		PA_ODR &= (0<<3);
4610  048e 725f5000      	clr	_PA_ODR
4611                     ; 155 		spi_send(kostil_k155(k155_data));
4613  0492 b617          	ld	a,_k155_data
4614  0494 ad7e          	call	_kostil_k155
4616  0496 cd053b        	call	_spi_send
4618                     ; 157 		spi_send(lamp_number_data | dots);
4620  0499 b616          	ld	a,_lamp_number_data
4621  049b ba01          	or	a,_dots
4622  049d cd053b        	call	_spi_send
4625  04a0               L7662:
4626                     ; 158 		while((SPI_SR & SPI_SR_BSY) != 0);
4628  04a0 c65203        	ld	a,_SPI_SR
4629  04a3 a580          	bcp	a,#128
4630  04a5 26f9          	jrne	L7662
4631                     ; 159 		PA_ODR |= (1<<3);
4633  04a7 72165000      	bset	_PA_ODR,#3
4634                     ; 160 		timers_int_on();
4636  04ab ad0a          	call	_timers_int_on
4638                     ; 161 	return;
4641  04ad 81            	ret
4666                     ; 165 void timers_int_off(void)
4666                     ; 166 {
4667                     	switch	.text
4668  04ae               _timers_int_off:
4672                     ; 167 		TIM1_IER &= ~TIM1_IER_UIE;
4674  04ae 72115254      	bres	_TIM1_IER,#0
4675                     ; 168 		TIM2_IER = 0;
4677  04b2 725f5303      	clr	_TIM2_IER
4678                     ; 169 }
4681  04b6 81            	ret
4706                     ; 170 void timers_int_on(void)
4706                     ; 171 {
4707                     	switch	.text
4708  04b7               _timers_int_on:
4712                     ; 172 		TIM1_IER |= TIM1_IER_UIE;
4714  04b7 72105254      	bset	_TIM1_IER,#0
4715                     ; 173 		TIM2_IER |=	TIM2_IER_CC1IE |TIM2_IER_UIE;	//overflow int and compare 1
4717  04bb c65303        	ld	a,_TIM2_IER
4718  04be aa03          	or	a,#3
4719  04c0 c75303        	ld	_TIM2_IER,a
4720                     ; 174 }
4723  04c3 81            	ret
4772                     ; 2 void time_write(void)
4772                     ; 3 {
4773                     	switch	.text
4774  04c4               _time_write:
4778                     ; 4 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
4780  04c4 b615          	ld	a,_fresh_hours_dec
4781  04c6 97            	ld	xl,a
4782  04c7 a610          	ld	a,#16
4783  04c9 42            	mul	x,a
4784  04ca 9f            	ld	a,xl
4785  04cb bb14          	add	a,_fresh_hours
4786  04cd b714          	ld	_fresh_hours,a
4787                     ; 5 	fresh_min = fresh_min + (fresh_min_dec<<4);
4789  04cf b613          	ld	a,_fresh_min_dec
4790  04d1 97            	ld	xl,a
4791  04d2 a610          	ld	a,#16
4792  04d4 42            	mul	x,a
4793  04d5 9f            	ld	a,xl
4794  04d6 bb12          	add	a,_fresh_min
4795  04d8 b712          	ld	_fresh_min,a
4796                     ; 6 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
4798  04da b611          	ld	a,_fresh_sec_dec
4799  04dc 97            	ld	xl,a
4800  04dd a610          	ld	a,#16
4801  04df 42            	mul	x,a
4802  04e0 9f            	ld	a,xl
4803  04e1 bb10          	add	a,_fresh_sec
4804  04e3 b710          	ld	_fresh_sec,a
4805                     ; 7 	timers_int_off();
4807  04e5 adc7          	call	_timers_int_off
4809                     ; 8 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
4811  04e7 4b01          	push	#1
4812  04e9 ae0014        	ldw	x,#_fresh_hours
4813  04ec 89            	pushw	x
4814  04ed aed002        	ldw	x,#53250
4815  04f0 cd013e        	call	_i2c_wr_reg
4817  04f3 5b03          	addw	sp,#3
4818                     ; 9 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
4820  04f5 4b01          	push	#1
4821  04f7 ae0012        	ldw	x,#_fresh_min
4822  04fa 89            	pushw	x
4823  04fb aed001        	ldw	x,#53249
4824  04fe cd013e        	call	_i2c_wr_reg
4826  0501 5b03          	addw	sp,#3
4827                     ; 10 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
4829  0503 4b01          	push	#1
4830  0505 ae0010        	ldw	x,#_fresh_sec
4831  0508 89            	pushw	x
4832  0509 aed000        	ldw	x,#53248
4833  050c cd013e        	call	_i2c_wr_reg
4835  050f 5b03          	addw	sp,#3
4836                     ; 11 	timers_int_on();
4838  0511 ada4          	call	_timers_int_on
4840                     ; 12 }
4843  0513 81            	ret
4895                     ; 14 uint8_t kostil_k155 (uint8_t byte)
4895                     ; 15 {
4896                     	switch	.text
4897  0514               _kostil_k155:
4899  0514 88            	push	a
4900  0515 89            	pushw	x
4901       00000002      OFST:	set	2
4904                     ; 16 	uint8_t tmp = (byte<<1) & 0b00001100;
4906  0516 48            	sll	a
4907  0517 a40c          	and	a,#12
4908  0519 6b01          	ld	(OFST-1,sp),a
4909                     ; 17 	uint8_t tmp2 = (byte>>2) & 0b00000010;
4911  051b 7b03          	ld	a,(OFST+1,sp)
4912  051d 44            	srl	a
4913  051e 44            	srl	a
4914  051f a402          	and	a,#2
4915  0521 6b02          	ld	(OFST+0,sp),a
4916                     ; 18 	byte &= 1;
4918  0523 7b03          	ld	a,(OFST+1,sp)
4919  0525 a401          	and	a,#1
4920  0527 6b03          	ld	(OFST+1,sp),a
4921                     ; 19 	byte |= tmp | tmp2;
4923  0529 7b01          	ld	a,(OFST-1,sp)
4924  052b 1a02          	or	a,(OFST+0,sp)
4925  052d 1a03          	or	a,(OFST+1,sp)
4926  052f 6b03          	ld	(OFST+1,sp),a
4927                     ; 20 	return byte;
4929  0531 7b03          	ld	a,(OFST+1,sp)
4932  0533 5b03          	addw	sp,#3
4933  0535 81            	ret
4974                     ; 1 void spi_setup(void)
4974                     ; 2  {
4975                     	switch	.text
4976  0536               _spi_setup:
4980                     ; 3     SPI_CR1= 0b01000100;//0x7C;       //this
4982  0536 35445200      	mov	_SPI_CR1,#68
4983                     ; 5  }
4986  053a 81            	ret
5022                     ; 8 void spi_send(uint8_t msg)
5022                     ; 9 {
5023                     	switch	.text
5024  053b               _spi_send:
5026  053b 88            	push	a
5027       00000000      OFST:	set	0
5030  053c               L5103:
5031                     ; 11 	while((SPI_SR & SPI_SR_BSY) != 0)
5033  053c c65203        	ld	a,_SPI_SR
5034  053f a580          	bcp	a,#128
5035  0541 26f9          	jrne	L5103
5036                     ; 14 	SPI_DR = msg;
5038  0543 7b01          	ld	a,(OFST+1,sp)
5039  0545 c75204        	ld	_SPI_DR,a
5040                     ; 15 }
5043  0548 84            	pop	a
5044  0549 81            	ret
5086                     ; 4 void UART_Resieved (void)
5086                     ; 5 {
5087                     	switch	.text
5088  054a               _UART_Resieved:
5092                     ; 6 	uart_routine(UART1_DR);
5094  054a c65231        	ld	a,_UART1_DR
5095  054d cd002a        	call	_uart_routine
5097                     ; 7 }
5100  0550 81            	ret
5125                     ; 9 void SPI_Transmitted(void)
5125                     ; 10 {
5126                     	switch	.text
5127  0551               _SPI_Transmitted:
5131                     ; 11 	spi_send(temp3);
5133  0551 b609          	ld	a,_temp3
5134  0553 ade6          	call	_spi_send
5136                     ; 12 }
5139  0555 81            	ret
5162                     ; 14 void I2C_Event(void)
5162                     ; 15 {
5163                     	switch	.text
5164  0556               _I2C_Event:
5168                     ; 16 }
5171  0556 81            	ret
5197                     ; 18 void Keys_switched(void)
5197                     ; 19 {
5198                     	switch	.text
5199  0557               _Keys_switched:
5203                     ; 20 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
5205  0557 c650a0        	ld	a,_EXTI_CR1
5206  055a 43            	cpl	a
5207  055b a430          	and	a,#48
5208  055d c750a0        	ld	_EXTI_CR1,a
5209                     ; 21 	PC_CR2 = 0;
5211  0560 725f500e      	clr	_PC_CR2
5212                     ; 22 	timer2_start(0xff);	
5214  0564 ae00ff        	ldw	x,#255
5215  0567 cd038d        	call	_timer2_start
5217                     ; 23 }
5220  056a 81            	ret
5255                     ; 25 void time_refresh (void)
5255                     ; 26 {
5256                     	switch	.text
5257  056b               _time_refresh:
5261                     ; 28 	timers_int_off();
5263  056b cd04ae        	call	_timers_int_off
5265                     ; 29 	i2c_rd_reg(0xD0, 0, &fresh_sec, 1); 	
5267  056e 4b01          	push	#1
5268  0570 ae0010        	ldw	x,#_fresh_sec
5269  0573 89            	pushw	x
5270  0574 aed000        	ldw	x,#53248
5271  0577 cd01a1        	call	_i2c_rd_reg
5273  057a 5b03          	addw	sp,#3
5274                     ; 30 	i2c_rd_reg(0xD0, 1, &fresh_min, 1);
5276  057c 4b01          	push	#1
5277  057e ae0012        	ldw	x,#_fresh_min
5278  0581 89            	pushw	x
5279  0582 aed001        	ldw	x,#53249
5280  0585 cd01a1        	call	_i2c_rd_reg
5282  0588 5b03          	addw	sp,#3
5283                     ; 31 	i2c_rd_reg(0xD0, 2, &fresh_hours, 1);
5285  058a 4b01          	push	#1
5286  058c ae0014        	ldw	x,#_fresh_hours
5287  058f 89            	pushw	x
5288  0590 aed002        	ldw	x,#53250
5289  0593 cd01a1        	call	_i2c_rd_reg
5291  0596 5b03          	addw	sp,#3
5292                     ; 32 	timers_int_on();
5294  0598 cd04b7        	call	_timers_int_on
5296                     ; 34 	seconds_tens = (fresh_sec & 0xf0)>>4;
5298  059b b610          	ld	a,_fresh_sec
5299  059d a4f0          	and	a,#240
5300  059f 4e            	swap	a
5301  05a0 a40f          	and	a,#15
5302  05a2 b70b          	ld	_seconds_tens,a
5303                     ; 35 	minutes_tens = (fresh_min & 0xf0)>>4;
5305  05a4 b612          	ld	a,_fresh_min
5306  05a6 a4f0          	and	a,#240
5307  05a8 4e            	swap	a
5308  05a9 a40f          	and	a,#15
5309  05ab b70a          	ld	_minutes_tens,a
5310                     ; 36 	hours_tens = (fresh_hours & 0xf0)>>4;
5312  05ad b614          	ld	a,_fresh_hours
5313  05af a4f0          	and	a,#240
5314  05b1 4e            	swap	a
5315  05b2 a40f          	and	a,#15
5316  05b4 b709          	ld	_hours_tens,a
5317                     ; 38 	seconds = fresh_sec & 0x0f;
5319  05b6 b610          	ld	a,_fresh_sec
5320  05b8 a40f          	and	a,#15
5321  05ba b70c          	ld	_seconds,a
5322                     ; 39 	minutes = fresh_min & 0x0f;
5324  05bc b612          	ld	a,_fresh_min
5325  05be a40f          	and	a,#15
5326  05c0 b70d          	ld	_minutes,a
5327                     ; 40 	hours = fresh_hours & 0x0f;
5329  05c2 b614          	ld	a,_fresh_hours
5330  05c4 a40f          	and	a,#15
5331  05c6 b70e          	ld	_hours,a
5332                     ; 41 }
5335  05c8 81            	ret
5364                     ; 43 void digits_shift_init (void)
5364                     ; 44 {
5365                     	switch	.text
5366  05c9               _digits_shift_init:
5370                     ; 46 	seconds_tens = 0;
5372  05c9 3f0b          	clr	_seconds_tens
5373                     ; 47 	minutes_tens = 0;
5375  05cb 3f0a          	clr	_minutes_tens
5376                     ; 48 	hours_tens = 0;
5378  05cd 3f09          	clr	_hours_tens
5379                     ; 50 	seconds = 0;
5381  05cf 3f0c          	clr	_seconds
5382                     ; 51 	minutes = 0;
5384  05d1 3f0d          	clr	_minutes
5385                     ; 52 	hours = 0;
5387  05d3 3f0e          	clr	_hours
5388                     ; 53 }
5391  05d5 81            	ret
5462                     ; 19 int main( void )
5462                     ; 20 {
5463                     	switch	.text
5464  05d6               _main:
5468                     ; 22 		CLK_CKDIVR=0;                //	no dividers
5470  05d6 725f50c6      	clr	_CLK_CKDIVR
5471                     ; 24 		for (i = 0; i < 0xFFFF; i++);	//hotfix for usart
5473  05da 5f            	clrw	x
5474  05db bf0b          	ldw	_i,x
5475  05dd               L5213:
5479  05dd be0b          	ldw	x,_i
5480  05df 1c0001        	addw	x,#1
5481  05e2 bf0b          	ldw	_i,x
5484  05e4 be0b          	ldw	x,_i
5485  05e6 a3ffff        	cpw	x,#65535
5486  05e9 25f2          	jrult	L5213
5487                     ; 26 		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //clocking for TIM1, UART1, SPI i I2C
5489  05eb 35ff50c7      	mov	_CLK_PCKENR1,#255
5490                     ; 29 		IWDG_KR = KEY_ACCESS;         //  Allow the IWDG registers to be programmed.
5492  05ef 355550e0      	mov	_IWDG_KR,#85
5493                     ; 30     IWDG_PR = 0x06;         //  Prescaler is 6 => ~1 sec 
5495  05f3 350650e1      	mov	_IWDG_PR,#6
5496                     ; 31     IWDG_RLR = 0xFF;        //  Counter for 1 sec.
5498  05f7 35ff50e2      	mov	_IWDG_RLR,#255
5499                     ; 32     IWDG_KR = KEY_REFRESH;         //  Reset the counter.
5501  05fb 35aa50e0      	mov	_IWDG_KR,#170
5502                     ; 33 		IWDG_KR = KEY_ENABLE;         //  Start the independent watchdog.
5504  05ff 35cc50e0      	mov	_IWDG_KR,#204
5505                     ; 36     PA_DDR=(1<<3) | (1<<2); //0b000001000; //output for register's latch, input for RTC 1 Hz pulse
5507  0603 350c5002      	mov	_PA_DDR,#12
5508                     ; 37     PA_CR1= 0xff;        //	pull-up on inputs, push-pull on outputs
5510  0607 35ff5003      	mov	_PA_CR1,#255
5511                     ; 38     PA_ODR |= (1<<3);
5513  060b 72165000      	bset	_PA_ODR,#3
5514                     ; 39 		PA_CR2 |=(1<<3);        //	interrupt on PA1 for 1hz
5516  060f 72165004      	bset	_PA_CR2,#3
5517                     ; 41     PC_DDR=0x60; //0b01100000; // buttons pins as input
5519  0613 3560500c      	mov	_PC_DDR,#96
5520                     ; 42     PC_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5522  0617 35ff500d      	mov	_PC_CR1,#255
5523                     ; 43     PC_CR2 |= (1<<4) | (1<<3);        //	interrapts for buttons
5525  061b c6500e        	ld	a,_PC_CR2
5526  061e aa18          	or	a,#24
5527  0620 c7500e        	ld	_PC_CR2,a
5528                     ; 45 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM
5530  0623 35a85011      	mov	_PD_DDR,#168
5531                     ; 46     PD_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5533  0627 35ff5012      	mov	_PD_CR1,#255
5534                     ; 47     PD_ODR = (1 << 3);
5536  062b 3508500f      	mov	_PD_ODR,#8
5537                     ; 51     spi_setup();
5539  062f cd0536        	call	_spi_setup
5541                     ; 54 		uart_setup();
5543  0632 cd0000        	call	_uart_setup
5545                     ; 55 		uart_send('h');
5547  0635 a668          	ld	a,#104
5548  0637 cd0019        	call	_uart_send
5550                     ; 58     timer1_setup(65500,0xffff);//	freq in hz and top value
5552  063a aeffff        	ldw	x,#65535
5553  063d 89            	pushw	x
5554  063e aeffdc        	ldw	x,#65500
5555  0641 cd02e4        	call	_timer1_setup
5557  0644 85            	popw	x
5558                     ; 59 		timer2_setup();
5560  0645 cd034f        	call	_timer2_setup
5562                     ; 62 		i2c_master_init(16000000, 100000);
5564  0648 ae86a0        	ldw	x,#34464
5565  064b 89            	pushw	x
5566  064c ae0001        	ldw	x,#1
5567  064f 89            	pushw	x
5568  0650 ae2400        	ldw	x,#9216
5569  0653 89            	pushw	x
5570  0654 ae00f4        	ldw	x,#244
5571  0657 89            	pushw	x
5572  0658 cd00bc        	call	_i2c_master_init
5574  065b 5b08          	addw	sp,#8
5575                     ; 65 		timers_int_off();
5577  065d cd04ae        	call	_timers_int_off
5579                     ; 66 		i2c_rd_reg(ds_address, 7, &temp, 1);
5581  0660 4b01          	push	#1
5582  0662 ae0003        	ldw	x,#_temp
5583  0665 89            	pushw	x
5584  0666 aed007        	ldw	x,#53255
5585  0669 cd01a1        	call	_i2c_rd_reg
5587  066c 5b03          	addw	sp,#3
5588                     ; 67 	if (temp != 0b10010000)	// if OUT and SWQ == 0
5590  066e b603          	ld	a,_temp
5591  0670 a190          	cp	a,#144
5592  0672 270e          	jreq	L3313
5593                     ; 69 			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//	setup RTC for 1Hz output
5595  0674 4b01          	push	#1
5596  0676 ae000e        	ldw	x,#_ds_cr
5597  0679 89            	pushw	x
5598  067a aed007        	ldw	x,#53255
5599  067d cd013e        	call	_i2c_wr_reg
5601  0680 5b03          	addw	sp,#3
5602  0682               L3313:
5603                     ; 72 		i2c_rd_reg(ds_address, 0, &temp, 1);
5605  0682 4b01          	push	#1
5606  0684 ae0003        	ldw	x,#_temp
5607  0687 89            	pushw	x
5608  0688 aed000        	ldw	x,#53248
5609  068b cd01a1        	call	_i2c_rd_reg
5611  068e 5b03          	addw	sp,#3
5612                     ; 75 	if((temp & 0x80) == 0x80)
5614  0690 b603          	ld	a,_temp
5615  0692 a480          	and	a,#128
5616  0694 a180          	cp	a,#128
5617  0696 2610          	jrne	L5313
5618                     ; 77 			temp = 0;
5620  0698 3f03          	clr	_temp
5621                     ; 78 			i2c_wr_reg(ds_address, 0, &temp, 1);
5623  069a 4b01          	push	#1
5624  069c ae0003        	ldw	x,#_temp
5625  069f 89            	pushw	x
5626  06a0 aed000        	ldw	x,#53248
5627  06a3 cd013e        	call	_i2c_wr_reg
5629  06a6 5b03          	addw	sp,#3
5630  06a8               L5313:
5631                     ; 81 		timers_int_on();
5633  06a8 cd04b7        	call	_timers_int_on
5635                     ; 82 		timer1_start();
5637  06ab cd0388        	call	_timer1_start
5639                     ; 83 		timer2_start(TIM2_TOP);
5641  06ae ae3e80        	ldw	x,#16000
5642  06b1 cd038d        	call	_timer2_start
5644                     ; 85 		_asm ("RIM");  //on interupts
5647  06b4 9a            RIM
5649  06b5               L7313:
5650                     ; 88 	while(1);
5652  06b5 20fe          	jra	L7313
5665                     	xdef	_main
5666                     	xdef	_Keys_switched
5667                     	xdef	_I2C_Event
5668                     	xdef	_SPI_Transmitted
5669                     	xdef	_UART_Resieved
5670                     	xdef	_spi_setup
5671                     	xdef	_timer2_compare
5672                     	xdef	_timer1_compare
5673                     	xdef	_Timer1_overflow
5674                     	xdef	_Timer2_Overflow
5675                     	xdef	_timer2_start
5676                     	xdef	_timer1_start
5677                     	xdef	_timer1_comp_stop
5678                     	xdef	_timer1_comp_start
5679                     	xdef	_timer2_setup
5680                     	xdef	_timer1_setup
5681                     	xdef	_kostil_k155
5682                     	xdef	_digits_shift_init
5683                     	xdef	_time_refresh
5684                     	xdef	_timers_int_on
5685                     	xdef	_timers_int_off
5686                     	xdef	_spi_send
5687                     	xdef	_i2c_rd_reg
5688                     	xdef	_i2c_wr_reg
5689                     	xdef	_i2c_master_init
5690                     	xdef	_Key_interrupt
5691                     	xdef	_uart_routine
5692                     	xdef	_uart_send
5693                     	xdef	_uart_setup
5694                     	xdef	_time_write
5695                     	switch	.ubsct
5696  0000               _i2c_flags:
5697  0000 00            	ds.b	1
5698                     	xdef	_i2c_flags
5699  0001               _flags:
5700  0001 00            	ds.b	1
5701                     	xdef	_flags
5702                     	xdef	_tim1comp
5703  0002               _shifting:
5704  0002 00            	ds.b	1
5705                     	xdef	_shifting
5706                     	xdef	_ds_cr
5707                     	xdef	_schetchik2
5708                     	xdef	_i
5709                     	xdef	_schetchik
5710                     	xdef	_temp3
5711                     	xdef	_temp2
5712  0003               _temp:
5713  0003 00            	ds.b	1
5714                     	xdef	_temp
5715  0004               _pins:
5716  0004 00            	ds.b	1
5717                     	xdef	_pins
5718  0005               _fresh_data_pointer:
5719  0005 0000          	ds.b	2
5720                     	xdef	_fresh_data_pointer
5721  0007               _data_pointer:
5722  0007 0000          	ds.b	2
5723                     	xdef	_data_pointer
5724                     	xdef	_time_pointer
5725  0009               _hours_tens:
5726  0009 00            	ds.b	1
5727                     	xdef	_hours_tens
5728  000a               _minutes_tens:
5729  000a 00            	ds.b	1
5730                     	xdef	_minutes_tens
5731  000b               _seconds_tens:
5732  000b 00            	ds.b	1
5733                     	xdef	_seconds_tens
5734  000c               _seconds:
5735  000c 00            	ds.b	1
5736                     	xdef	_seconds
5737  000d               _minutes:
5738  000d 00            	ds.b	1
5739                     	xdef	_minutes
5740  000e               _hours:
5741  000e 00            	ds.b	1
5742                     	xdef	_hours
5743  000f               _timeset:
5744  000f 00            	ds.b	1
5745                     	xdef	_timeset
5746  0010               _fresh_sec:
5747  0010 00            	ds.b	1
5748                     	xdef	_fresh_sec
5749  0011               _fresh_sec_dec:
5750  0011 00            	ds.b	1
5751                     	xdef	_fresh_sec_dec
5752  0012               _fresh_min:
5753  0012 00            	ds.b	1
5754                     	xdef	_fresh_min
5755  0013               _fresh_min_dec:
5756  0013 00            	ds.b	1
5757                     	xdef	_fresh_min_dec
5758  0014               _fresh_hours:
5759  0014 00            	ds.b	1
5760                     	xdef	_fresh_hours
5761  0015               _fresh_hours_dec:
5762  0015 00            	ds.b	1
5763                     	xdef	_fresh_hours_dec
5764                     	xdef	_dots_on
5765                     	xdef	_dots_upd
5766  0016               _lamp_number_data:
5767  0016 00            	ds.b	1
5768                     	xdef	_lamp_number_data
5769  0017               _k155_data:
5770  0017 00            	ds.b	1
5771                     	xdef	_k155_data
5772                     	xdef	_dots
5773                     	xdef	_lamp_number
5774                     	xref.b	c_lreg
5775                     	xref.b	c_x
5795                     	xref	c_lrsh
5796                     	xref	c_ldiv
5797                     	xref	c_uitolx
5798                     	xref	c_ludv
5799                     	xref	c_rtol
5800                     	xref	c_ltor
5801                     	end
