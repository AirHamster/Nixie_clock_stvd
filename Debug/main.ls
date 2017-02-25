   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2173                     	bsct
2174  0000               _lamp_number:
2175  0000 00            	dc.b	0
2176  0001               _dots:
2177  0001 00            	dc.b	0
2178  0002               _dots_upd:
2179  0002 1f40          	dc.w	8000
2180  0004               _dots_on:
2181  0004 0001          	dc.w	1
2182  0006               _time_pointer:
2183  0006 000c          	dc.w	_seconds
2184  0008               _temp2:
2185  0008 00            	dc.b	0
2186  0009               _temp3:
2187  0009 33            	dc.b	51
2188  000a               _schetchik:
2189  000a 00            	dc.b	0
2190  000b               _i:
2191  000b 0000          	dc.w	0
2192  000d               _schetchik2:
2193  000d 00            	dc.b	0
2194  000e               _ds_cr:
2195  000e 90            	dc.b	144
2196  000f               _correction:
2197  000f 01            	dc.b	1
2198  0010               _tim1comp:
2199  0010 173e          	dc.w	5950
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
2895  005b cd0504        	call	_time_write
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
4233  03a0 cd04ee        	call	_timers_int_off
4235                     ; 65 		PA_ODR &= (0<<3);
4237  03a3 725f5000      	clr	_PA_ODR
4238                     ; 67 		spi_send(kostil_k155(k155_data));
4240  03a7 b617          	ld	a,_k155_data
4241  03a9 cd0554        	call	_kostil_k155
4243  03ac cd057b        	call	_spi_send
4245                     ; 68 		spi_send(lamp_number_data | dots);
4247  03af b616          	ld	a,_lamp_number_data
4248  03b1 ba01          	or	a,_dots
4249  03b3 cd057b        	call	_spi_send
4252  03b6               L3752:
4253                     ; 69 		while((SPI_SR & SPI_SR_BSY) != 0);
4255  03b6 c65203        	ld	a,_SPI_SR
4256  03b9 a580          	bcp	a,#128
4257  03bb 26f9          	jrne	L3752
4258                     ; 70 		PA_ODR |= (1<<3);
4260  03bd 72165000      	bset	_PA_ODR,#3
4261                     ; 71 		timers_int_on();
4263  03c1 cd04f7        	call	_timers_int_on
4265                     ; 72 }
4268  03c4 81            	ret
4304                     ; 75 void Timer1_overflow (void)
4304                     ; 76 {
4305                     	switch	.text
4306  03c5               _Timer1_overflow:
4310                     ; 77 		TIM1_SR1 &= ~TIM1_SR1_UIF;
4312  03c5 72115255      	bres	_TIM1_SR1,#0
4313                     ; 78 		dots = ~dots & DOTS_MASK;
4315  03c9 b601          	ld	a,_dots
4316  03cb 43            	cpl	a
4317  03cc a410          	and	a,#16
4318  03ce b701          	ld	_dots,a
4319                     ; 80 		time_refresh();
4321  03d0 cd05ab        	call	_time_refresh
4323                     ; 82 		if ((minutes == 0) && (shifting == 0)){
4325  03d3 3d0d          	tnz	_minutes
4326  03d5 2610          	jrne	L7062
4328  03d7 3d02          	tnz	_shifting
4329  03d9 260c          	jrne	L7062
4330                     ; 83 			tim1comp = 5950;	//top of tim1/10
4332  03db ae173e        	ldw	x,#5950
4333  03de bf10          	ldw	_tim1comp,x
4334                     ; 84 			digits_shift_init();	//set every digit to zero
4336  03e0 cd0609        	call	_digits_shift_init
4338                     ; 85 			timer1_comp_start(tim1comp);	//enable compare interrupt
4340  03e3 be10          	ldw	x,_tim1comp
4341  03e5 ad8d          	call	_timer1_comp_start
4343  03e7               L7062:
4344                     ; 87 		if (minutes != 0 && minutes != 5){
4346  03e7 3d0d          	tnz	_minutes
4347  03e9 2708          	jreq	L1162
4349  03eb b60d          	ld	a,_minutes
4350  03ed a105          	cp	a,#5
4351  03ef 2702          	jreq	L1162
4352                     ; 88 			shifting = 0;	//disable block when minutes increased
4354  03f1 3f02          	clr	_shifting
4355  03f3               L1162:
4356                     ; 92 		if ((hours == 0) && (minutes == 0) && (seconds == 10) 
4356                     ; 93 																		&& (correction == 1)){
4358  03f3 3d0e          	tnz	_hours
4359  03f5 2626          	jrne	L3162
4361  03f7 3d0d          	tnz	_minutes
4362  03f9 2622          	jrne	L3162
4364  03fb b60c          	ld	a,_seconds
4365  03fd a10a          	cp	a,#10
4366  03ff 261c          	jrne	L3162
4368  0401 b60f          	ld	a,_correction
4369  0403 a101          	cp	a,#1
4370  0405 2616          	jrne	L3162
4371                     ; 94 			correction = 0;
4373  0407 3f0f          	clr	_correction
4374                     ; 95 			temp = 3;
4376  0409 35030003      	mov	_temp,#3
4377                     ; 96 			i2c_wr_reg(ds_address, 0, &temp, 1);
4379  040d 4b01          	push	#1
4380  040f ae0003        	ldw	x,#_temp
4381  0412 89            	pushw	x
4382  0413 aed000        	ldw	x,#53248
4383  0416 cd013e        	call	_i2c_wr_reg
4385  0419 5b03          	addw	sp,#3
4387  041b 2016          	jra	L5162
4388  041d               L3162:
4389                     ; 98 		}else if ((hours == 0) && (minutes == 0) && (seconds == 10) 
4389                     ; 99 																		&& (correction == 0)){
4391  041d 3d0e          	tnz	_hours
4392  041f 2612          	jrne	L5162
4394  0421 3d0d          	tnz	_minutes
4395  0423 260e          	jrne	L5162
4397  0425 b60c          	ld	a,_seconds
4398  0427 a10a          	cp	a,#10
4399  0429 2608          	jrne	L5162
4401  042b 3d0f          	tnz	_correction
4402  042d 2604          	jrne	L5162
4403                     ; 100 			correction = 1;
4405  042f 3501000f      	mov	_correction,#1
4406  0433               L5162:
4407                     ; 102 }
4410  0433 81            	ret
4444                     ; 105 void timer1_compare(void){
4445                     	switch	.text
4446  0434               _timer1_compare:
4450                     ; 106 		TIM1_SR1 &= ~TIM1_SR1_CC1IF;
4452  0434 72135255      	bres	_TIM1_SR1,#1
4453                     ; 107 		if(hours < 9){
4455  0438 b60e          	ld	a,_hours
4456  043a a109          	cp	a,#9
4457  043c 241a          	jruge	L1362
4458                     ; 108 		seconds_tens++;
4460  043e 3c0b          	inc	_seconds_tens
4461                     ; 109 		minutes_tens++;
4463  0440 3c0a          	inc	_minutes_tens
4464                     ; 110 		hours_tens++;
4466  0442 3c09          	inc	_hours_tens
4467                     ; 112 		seconds++;
4469  0444 3c0c          	inc	_seconds
4470                     ; 113 		minutes++;
4472  0446 3c0d          	inc	_minutes
4473                     ; 114 		hours++;
4475  0448 3c0e          	inc	_hours
4476                     ; 115 		tim1comp += 5950;
4478  044a be10          	ldw	x,_tim1comp
4479  044c 1c173e        	addw	x,#5950
4480  044f bf10          	ldw	_tim1comp,x
4481                     ; 116 		timer1_comp_start(tim1comp);
4483  0451 be10          	ldw	x,_tim1comp
4484  0453 cd0374        	call	_timer1_comp_start
4487  0456 2007          	jra	L3362
4488  0458               L1362:
4489                     ; 119 			shifting = 1;	//block rolling
4491  0458 35010002      	mov	_shifting,#1
4492                     ; 120 			timer1_comp_stop();
4494  045c cd0383        	call	_timer1_comp_stop
4496  045f               L3362:
4497                     ; 122 }
4500  045f 81            	ret
4540                     ; 124 void timer2_compare(void)
4540                     ; 125 {
4541                     	switch	.text
4542  0460               _timer2_compare:
4546                     ; 126 	TIM2_SR1 &= ~TIM2_SR1_CC1IF;
4548  0460 72135304      	bres	_TIM2_SR1,#1
4549                     ; 127 	IWDG_KR = KEY_REFRESH; //	Watchdog reset
4551  0464 35aa50e0      	mov	_IWDG_KR,#170
4552                     ; 129 	if (schetchik == 1)
4554  0468 b60a          	ld	a,_schetchik
4555  046a a101          	cp	a,#1
4556  046c 2658          	jrne	L5562
4557                     ; 131 	switch (lamp_number)
4559  046e b600          	ld	a,_lamp_number
4561                     ; 144 	break;
4562  0470 4d            	tnz	a
4563  0471 270b          	jreq	L5362
4564  0473 4a            	dec	a
4565  0474 270d          	jreq	L7362
4566  0476 4a            	dec	a
4567  0477 270f          	jreq	L1462
4568  0479 4a            	dec	a
4569  047a 2711          	jreq	L3462
4570  047c 2012          	jra	L1662
4571  047e               L5362:
4572                     ; 133 	case 0:
4572                     ; 134 	k155_data = hours_tens; 
4574  047e 450917        	mov	_k155_data,_hours_tens
4575                     ; 135 	break;
4577  0481 200d          	jra	L1662
4578  0483               L7362:
4579                     ; 136 	case 1:
4579                     ; 137 	k155_data = hours;
4581  0483 450e17        	mov	_k155_data,_hours
4582                     ; 138 	break;
4584  0486 2008          	jra	L1662
4585  0488               L1462:
4586                     ; 139 	case 2:
4586                     ; 140 	k155_data = minutes_tens;
4588  0488 450a17        	mov	_k155_data,_minutes_tens
4589                     ; 141 	break;
4591  048b 2003          	jra	L1662
4592  048d               L3462:
4593                     ; 142 	case 3:
4593                     ; 143 	k155_data = minutes;
4595  048d 450d17        	mov	_k155_data,_minutes
4596                     ; 144 	break;
4598  0490               L1662:
4599                     ; 147 	if (lamp_number < 3)
4601  0490 b600          	ld	a,_lamp_number
4602  0492 a103          	cp	a,#3
4603  0494 2415          	jruge	L3662
4604                     ; 149 			lamp_number_data = (1<<(lamp_number++));
4606  0496 b600          	ld	a,_lamp_number
4607  0498 97            	ld	xl,a
4608  0499 3c00          	inc	_lamp_number
4609  049b 9f            	ld	a,xl
4610  049c 5f            	clrw	x
4611  049d 97            	ld	xl,a
4612  049e a601          	ld	a,#1
4613  04a0 5d            	tnzw	x
4614  04a1 2704          	jreq	L64
4615  04a3               L05:
4616  04a3 48            	sll	a
4617  04a4 5a            	decw	x
4618  04a5 26fc          	jrne	L05
4619  04a7               L64:
4620  04a7 b716          	ld	_lamp_number_data,a
4622  04a9 2017          	jra	L5662
4623  04ab               L3662:
4624                     ; 151 		else if (lamp_number >= 3)
4626  04ab b600          	ld	a,_lamp_number
4627  04ad a103          	cp	a,#3
4628  04af 2511          	jrult	L5662
4629                     ; 153 			lamp_number_data = (1<<(lamp_number));
4631  04b1 b600          	ld	a,_lamp_number
4632  04b3 5f            	clrw	x
4633  04b4 97            	ld	xl,a
4634  04b5 a601          	ld	a,#1
4635  04b7 5d            	tnzw	x
4636  04b8 2704          	jreq	L25
4637  04ba               L45:
4638  04ba 48            	sll	a
4639  04bb 5a            	decw	x
4640  04bc 26fc          	jrne	L45
4641  04be               L25:
4642  04be b716          	ld	_lamp_number_data,a
4643                     ; 154 			lamp_number = 0;
4645  04c0 3f00          	clr	_lamp_number
4646  04c2               L5662:
4647                     ; 157 	schetchik = 0;
4649  04c2 3f0a          	clr	_schetchik
4651  04c4 2006          	jra	L1762
4652  04c6               L5562:
4653                     ; 161 		lamp_number_data = 0;
4655  04c6 3f16          	clr	_lamp_number_data
4656                     ; 162 		schetchik = 1;
4658  04c8 3501000a      	mov	_schetchik,#1
4659  04cc               L1762:
4660                     ; 165 		timers_int_off();
4662  04cc ad20          	call	_timers_int_off
4664                     ; 166 		PA_ODR &= (0<<3);
4666  04ce 725f5000      	clr	_PA_ODR
4667                     ; 167 		spi_send(kostil_k155(k155_data));
4669  04d2 b617          	ld	a,_k155_data
4670  04d4 ad7e          	call	_kostil_k155
4672  04d6 cd057b        	call	_spi_send
4674                     ; 169 		spi_send(lamp_number_data | dots);
4676  04d9 b616          	ld	a,_lamp_number_data
4677  04db ba01          	or	a,_dots
4678  04dd cd057b        	call	_spi_send
4681  04e0               L5762:
4682                     ; 170 		while((SPI_SR & SPI_SR_BSY) != 0);
4684  04e0 c65203        	ld	a,_SPI_SR
4685  04e3 a580          	bcp	a,#128
4686  04e5 26f9          	jrne	L5762
4687                     ; 171 		PA_ODR |= (1<<3);
4689  04e7 72165000      	bset	_PA_ODR,#3
4690                     ; 172 		timers_int_on();
4692  04eb ad0a          	call	_timers_int_on
4694                     ; 173 	return;
4697  04ed 81            	ret
4722                     ; 177 void timers_int_off(void)
4722                     ; 178 {
4723                     	switch	.text
4724  04ee               _timers_int_off:
4728                     ; 179 		TIM1_IER &= ~TIM1_IER_UIE;
4730  04ee 72115254      	bres	_TIM1_IER,#0
4731                     ; 180 		TIM2_IER = 0;
4733  04f2 725f5303      	clr	_TIM2_IER
4734                     ; 181 }
4737  04f6 81            	ret
4762                     ; 182 void timers_int_on(void)
4762                     ; 183 {
4763                     	switch	.text
4764  04f7               _timers_int_on:
4768                     ; 184 		TIM1_IER |= TIM1_IER_UIE;
4770  04f7 72105254      	bset	_TIM1_IER,#0
4771                     ; 185 		TIM2_IER |=	TIM2_IER_CC1IE |TIM2_IER_UIE;	//overflow int and compare 1
4773  04fb c65303        	ld	a,_TIM2_IER
4774  04fe aa03          	or	a,#3
4775  0500 c75303        	ld	_TIM2_IER,a
4776                     ; 186 }
4779  0503 81            	ret
4828                     ; 2 void time_write(void)
4828                     ; 3 {
4829                     	switch	.text
4830  0504               _time_write:
4834                     ; 4 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
4836  0504 b615          	ld	a,_fresh_hours_dec
4837  0506 97            	ld	xl,a
4838  0507 a610          	ld	a,#16
4839  0509 42            	mul	x,a
4840  050a 9f            	ld	a,xl
4841  050b bb14          	add	a,_fresh_hours
4842  050d b714          	ld	_fresh_hours,a
4843                     ; 5 	fresh_min = fresh_min + (fresh_min_dec<<4);
4845  050f b613          	ld	a,_fresh_min_dec
4846  0511 97            	ld	xl,a
4847  0512 a610          	ld	a,#16
4848  0514 42            	mul	x,a
4849  0515 9f            	ld	a,xl
4850  0516 bb12          	add	a,_fresh_min
4851  0518 b712          	ld	_fresh_min,a
4852                     ; 6 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
4854  051a b611          	ld	a,_fresh_sec_dec
4855  051c 97            	ld	xl,a
4856  051d a610          	ld	a,#16
4857  051f 42            	mul	x,a
4858  0520 9f            	ld	a,xl
4859  0521 bb10          	add	a,_fresh_sec
4860  0523 b710          	ld	_fresh_sec,a
4861                     ; 7 	timers_int_off();
4863  0525 adc7          	call	_timers_int_off
4865                     ; 8 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
4867  0527 4b01          	push	#1
4868  0529 ae0014        	ldw	x,#_fresh_hours
4869  052c 89            	pushw	x
4870  052d aed002        	ldw	x,#53250
4871  0530 cd013e        	call	_i2c_wr_reg
4873  0533 5b03          	addw	sp,#3
4874                     ; 9 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
4876  0535 4b01          	push	#1
4877  0537 ae0012        	ldw	x,#_fresh_min
4878  053a 89            	pushw	x
4879  053b aed001        	ldw	x,#53249
4880  053e cd013e        	call	_i2c_wr_reg
4882  0541 5b03          	addw	sp,#3
4883                     ; 10 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
4885  0543 4b01          	push	#1
4886  0545 ae0010        	ldw	x,#_fresh_sec
4887  0548 89            	pushw	x
4888  0549 aed000        	ldw	x,#53248
4889  054c cd013e        	call	_i2c_wr_reg
4891  054f 5b03          	addw	sp,#3
4892                     ; 11 	timers_int_on();
4894  0551 ada4          	call	_timers_int_on
4896                     ; 12 }
4899  0553 81            	ret
4951                     ; 14 uint8_t kostil_k155 (uint8_t byte)
4951                     ; 15 {
4952                     	switch	.text
4953  0554               _kostil_k155:
4955  0554 88            	push	a
4956  0555 89            	pushw	x
4957       00000002      OFST:	set	2
4960                     ; 16 	uint8_t tmp = (byte<<1) & 0b00001100;
4962  0556 48            	sll	a
4963  0557 a40c          	and	a,#12
4964  0559 6b01          	ld	(OFST-1,sp),a
4965                     ; 17 	uint8_t tmp2 = (byte>>2) & 0b00000010;
4967  055b 7b03          	ld	a,(OFST+1,sp)
4968  055d 44            	srl	a
4969  055e 44            	srl	a
4970  055f a402          	and	a,#2
4971  0561 6b02          	ld	(OFST+0,sp),a
4972                     ; 18 	byte &= 1;
4974  0563 7b03          	ld	a,(OFST+1,sp)
4975  0565 a401          	and	a,#1
4976  0567 6b03          	ld	(OFST+1,sp),a
4977                     ; 19 	byte |= tmp | tmp2;
4979  0569 7b01          	ld	a,(OFST-1,sp)
4980  056b 1a02          	or	a,(OFST+0,sp)
4981  056d 1a03          	or	a,(OFST+1,sp)
4982  056f 6b03          	ld	(OFST+1,sp),a
4983                     ; 20 	return byte;
4985  0571 7b03          	ld	a,(OFST+1,sp)
4988  0573 5b03          	addw	sp,#3
4989  0575 81            	ret
5030                     ; 1 void spi_setup(void)
5030                     ; 2  {
5031                     	switch	.text
5032  0576               _spi_setup:
5036                     ; 3     SPI_CR1= 0b01000100;//0x7C;       //this
5038  0576 35445200      	mov	_SPI_CR1,#68
5039                     ; 5  }
5042  057a 81            	ret
5078                     ; 8 void spi_send(uint8_t msg)
5078                     ; 9 {
5079                     	switch	.text
5080  057b               _spi_send:
5082  057b 88            	push	a
5083       00000000      OFST:	set	0
5086  057c               L3203:
5087                     ; 11 	while((SPI_SR & SPI_SR_BSY) != 0)
5089  057c c65203        	ld	a,_SPI_SR
5090  057f a580          	bcp	a,#128
5091  0581 26f9          	jrne	L3203
5092                     ; 14 	SPI_DR = msg;
5094  0583 7b01          	ld	a,(OFST+1,sp)
5095  0585 c75204        	ld	_SPI_DR,a
5096                     ; 15 }
5099  0588 84            	pop	a
5100  0589 81            	ret
5142                     ; 4 void UART_Resieved (void)
5142                     ; 5 {
5143                     	switch	.text
5144  058a               _UART_Resieved:
5148                     ; 6 	uart_routine(UART1_DR);
5150  058a c65231        	ld	a,_UART1_DR
5151  058d cd002a        	call	_uart_routine
5153                     ; 7 }
5156  0590 81            	ret
5181                     ; 9 void SPI_Transmitted(void)
5181                     ; 10 {
5182                     	switch	.text
5183  0591               _SPI_Transmitted:
5187                     ; 11 	spi_send(temp3);
5189  0591 b609          	ld	a,_temp3
5190  0593 ade6          	call	_spi_send
5192                     ; 12 }
5195  0595 81            	ret
5218                     ; 14 void I2C_Event(void)
5218                     ; 15 {
5219                     	switch	.text
5220  0596               _I2C_Event:
5224                     ; 16 }
5227  0596 81            	ret
5253                     ; 18 void Keys_switched(void)
5253                     ; 19 {
5254                     	switch	.text
5255  0597               _Keys_switched:
5259                     ; 20 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
5261  0597 c650a0        	ld	a,_EXTI_CR1
5262  059a 43            	cpl	a
5263  059b a430          	and	a,#48
5264  059d c750a0        	ld	_EXTI_CR1,a
5265                     ; 21 	PC_CR2 = 0;
5267  05a0 725f500e      	clr	_PC_CR2
5268                     ; 22 	timer2_start(0xff);	
5270  05a4 ae00ff        	ldw	x,#255
5271  05a7 cd038d        	call	_timer2_start
5273                     ; 23 }
5276  05aa 81            	ret
5311                     ; 25 void time_refresh (void)
5311                     ; 26 {
5312                     	switch	.text
5313  05ab               _time_refresh:
5317                     ; 28 	timers_int_off();
5319  05ab cd04ee        	call	_timers_int_off
5321                     ; 29 	i2c_rd_reg(0xD0, 0, &fresh_sec, 1); 	
5323  05ae 4b01          	push	#1
5324  05b0 ae0010        	ldw	x,#_fresh_sec
5325  05b3 89            	pushw	x
5326  05b4 aed000        	ldw	x,#53248
5327  05b7 cd01a1        	call	_i2c_rd_reg
5329  05ba 5b03          	addw	sp,#3
5330                     ; 30 	i2c_rd_reg(0xD0, 1, &fresh_min, 1);
5332  05bc 4b01          	push	#1
5333  05be ae0012        	ldw	x,#_fresh_min
5334  05c1 89            	pushw	x
5335  05c2 aed001        	ldw	x,#53249
5336  05c5 cd01a1        	call	_i2c_rd_reg
5338  05c8 5b03          	addw	sp,#3
5339                     ; 31 	i2c_rd_reg(0xD0, 2, &fresh_hours, 1);
5341  05ca 4b01          	push	#1
5342  05cc ae0014        	ldw	x,#_fresh_hours
5343  05cf 89            	pushw	x
5344  05d0 aed002        	ldw	x,#53250
5345  05d3 cd01a1        	call	_i2c_rd_reg
5347  05d6 5b03          	addw	sp,#3
5348                     ; 32 	timers_int_on();
5350  05d8 cd04f7        	call	_timers_int_on
5352                     ; 34 	seconds_tens = (fresh_sec & 0xf0)>>4;
5354  05db b610          	ld	a,_fresh_sec
5355  05dd a4f0          	and	a,#240
5356  05df 4e            	swap	a
5357  05e0 a40f          	and	a,#15
5358  05e2 b70b          	ld	_seconds_tens,a
5359                     ; 35 	minutes_tens = (fresh_min & 0xf0)>>4;
5361  05e4 b612          	ld	a,_fresh_min
5362  05e6 a4f0          	and	a,#240
5363  05e8 4e            	swap	a
5364  05e9 a40f          	and	a,#15
5365  05eb b70a          	ld	_minutes_tens,a
5366                     ; 36 	hours_tens = (fresh_hours & 0xf0)>>4;
5368  05ed b614          	ld	a,_fresh_hours
5369  05ef a4f0          	and	a,#240
5370  05f1 4e            	swap	a
5371  05f2 a40f          	and	a,#15
5372  05f4 b709          	ld	_hours_tens,a
5373                     ; 38 	seconds = fresh_sec & 0x0f;
5375  05f6 b610          	ld	a,_fresh_sec
5376  05f8 a40f          	and	a,#15
5377  05fa b70c          	ld	_seconds,a
5378                     ; 39 	minutes = fresh_min & 0x0f;
5380  05fc b612          	ld	a,_fresh_min
5381  05fe a40f          	and	a,#15
5382  0600 b70d          	ld	_minutes,a
5383                     ; 40 	hours = fresh_hours & 0x0f;
5385  0602 b614          	ld	a,_fresh_hours
5386  0604 a40f          	and	a,#15
5387  0606 b70e          	ld	_hours,a
5388                     ; 41 }
5391  0608 81            	ret
5420                     ; 43 void digits_shift_init (void)
5420                     ; 44 {
5421                     	switch	.text
5422  0609               _digits_shift_init:
5426                     ; 46 	seconds_tens = 0;
5428  0609 3f0b          	clr	_seconds_tens
5429                     ; 47 	minutes_tens = 0;
5431  060b 3f0a          	clr	_minutes_tens
5432                     ; 48 	hours_tens = 0;
5434  060d 3f09          	clr	_hours_tens
5435                     ; 50 	seconds = 0;
5437  060f 3f0c          	clr	_seconds
5438                     ; 51 	minutes = 0;
5440  0611 3f0d          	clr	_minutes
5441                     ; 52 	hours = 0;
5443  0613 3f0e          	clr	_hours
5444                     ; 53 }
5447  0615 81            	ret
5518                     ; 19 int main( void )
5518                     ; 20 {
5519                     	switch	.text
5520  0616               _main:
5524                     ; 22 		CLK_CKDIVR=0;                //	no dividers
5526  0616 725f50c6      	clr	_CLK_CKDIVR
5527                     ; 24 		for (i = 0; i < 0xFFFF; i++);	//hotfix for usart
5529  061a 5f            	clrw	x
5530  061b bf0b          	ldw	_i,x
5531  061d               L3313:
5535  061d be0b          	ldw	x,_i
5536  061f 1c0001        	addw	x,#1
5537  0622 bf0b          	ldw	_i,x
5540  0624 be0b          	ldw	x,_i
5541  0626 a3ffff        	cpw	x,#65535
5542  0629 25f2          	jrult	L3313
5543                     ; 26 		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //clocking for TIM1, UART1, SPI i I2C
5545  062b 35ff50c7      	mov	_CLK_PCKENR1,#255
5546                     ; 29 		IWDG_KR = KEY_ACCESS;         //  Allow the IWDG registers to be programmed.
5548  062f 355550e0      	mov	_IWDG_KR,#85
5549                     ; 30     IWDG_PR = 0x06;         //  Prescaler is 6 => ~1 sec 
5551  0633 350650e1      	mov	_IWDG_PR,#6
5552                     ; 31     IWDG_RLR = 0xFF;        //  Counter for 1 sec.
5554  0637 35ff50e2      	mov	_IWDG_RLR,#255
5555                     ; 32     IWDG_KR = KEY_REFRESH;         //  Reset the counter.
5557  063b 35aa50e0      	mov	_IWDG_KR,#170
5558                     ; 33 		IWDG_KR = KEY_ENABLE;         //  Start the independent watchdog.
5560  063f 35cc50e0      	mov	_IWDG_KR,#204
5561                     ; 36     PA_DDR=(1<<3) | (1<<2); //0b000001000; //output for register's latch, input for RTC 1 Hz pulse
5563  0643 350c5002      	mov	_PA_DDR,#12
5564                     ; 37     PA_CR1= 0xff;        //	pull-up on inputs, push-pull on outputs
5566  0647 35ff5003      	mov	_PA_CR1,#255
5567                     ; 38     PA_ODR |= (1<<3);
5569  064b 72165000      	bset	_PA_ODR,#3
5570                     ; 39 		PA_CR2 |=(1<<3);        //	interrupt on PA1 for 1hz
5572  064f 72165004      	bset	_PA_CR2,#3
5573                     ; 41     PC_DDR=0x60; //0b01100000; // buttons pins as input
5575  0653 3560500c      	mov	_PC_DDR,#96
5576                     ; 42     PC_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5578  0657 35ff500d      	mov	_PC_CR1,#255
5579                     ; 43     PC_CR2 |= (1<<4) | (1<<3);        //	interrapts for buttons
5581  065b c6500e        	ld	a,_PC_CR2
5582  065e aa18          	or	a,#24
5583  0660 c7500e        	ld	_PC_CR2,a
5584                     ; 45 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM
5586  0663 35a85011      	mov	_PD_DDR,#168
5587                     ; 46     PD_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5589  0667 35ff5012      	mov	_PD_CR1,#255
5590                     ; 47     PD_ODR = (1 << 3);
5592  066b 3508500f      	mov	_PD_ODR,#8
5593                     ; 51     spi_setup();
5595  066f cd0576        	call	_spi_setup
5597                     ; 54 		uart_setup();
5599  0672 cd0000        	call	_uart_setup
5601                     ; 55 		uart_send('h');
5603  0675 a668          	ld	a,#104
5604  0677 cd0019        	call	_uart_send
5606                     ; 58     timer1_setup(65500,0xffff);//	freq in hz and top value
5608  067a aeffff        	ldw	x,#65535
5609  067d 89            	pushw	x
5610  067e aeffdc        	ldw	x,#65500
5611  0681 cd02e4        	call	_timer1_setup
5613  0684 85            	popw	x
5614                     ; 59 		timer2_setup();
5616  0685 cd034f        	call	_timer2_setup
5618                     ; 62 		i2c_master_init(16000000, 100000);
5620  0688 ae86a0        	ldw	x,#34464
5621  068b 89            	pushw	x
5622  068c ae0001        	ldw	x,#1
5623  068f 89            	pushw	x
5624  0690 ae2400        	ldw	x,#9216
5625  0693 89            	pushw	x
5626  0694 ae00f4        	ldw	x,#244
5627  0697 89            	pushw	x
5628  0698 cd00bc        	call	_i2c_master_init
5630  069b 5b08          	addw	sp,#8
5631                     ; 65 		timers_int_off();
5633  069d cd04ee        	call	_timers_int_off
5635                     ; 66 		i2c_rd_reg(ds_address, 7, &temp, 1);
5637  06a0 4b01          	push	#1
5638  06a2 ae0003        	ldw	x,#_temp
5639  06a5 89            	pushw	x
5640  06a6 aed007        	ldw	x,#53255
5641  06a9 cd01a1        	call	_i2c_rd_reg
5643  06ac 5b03          	addw	sp,#3
5644                     ; 67 	if (temp != 0b10010000)	// if OUT and SWQ == 0
5646  06ae b603          	ld	a,_temp
5647  06b0 a190          	cp	a,#144
5648  06b2 270e          	jreq	L1413
5649                     ; 69 			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//	setup RTC for 1Hz output
5651  06b4 4b01          	push	#1
5652  06b6 ae000e        	ldw	x,#_ds_cr
5653  06b9 89            	pushw	x
5654  06ba aed007        	ldw	x,#53255
5655  06bd cd013e        	call	_i2c_wr_reg
5657  06c0 5b03          	addw	sp,#3
5658  06c2               L1413:
5659                     ; 72 		i2c_rd_reg(ds_address, 0, &temp, 1);
5661  06c2 4b01          	push	#1
5662  06c4 ae0003        	ldw	x,#_temp
5663  06c7 89            	pushw	x
5664  06c8 aed000        	ldw	x,#53248
5665  06cb cd01a1        	call	_i2c_rd_reg
5667  06ce 5b03          	addw	sp,#3
5668                     ; 75 	if((temp & 0x80) == 0x80)
5670  06d0 b603          	ld	a,_temp
5671  06d2 a480          	and	a,#128
5672  06d4 a180          	cp	a,#128
5673  06d6 2610          	jrne	L3413
5674                     ; 77 			temp = 0;
5676  06d8 3f03          	clr	_temp
5677                     ; 78 			i2c_wr_reg(ds_address, 0, &temp, 1);
5679  06da 4b01          	push	#1
5680  06dc ae0003        	ldw	x,#_temp
5681  06df 89            	pushw	x
5682  06e0 aed000        	ldw	x,#53248
5683  06e3 cd013e        	call	_i2c_wr_reg
5685  06e6 5b03          	addw	sp,#3
5686  06e8               L3413:
5687                     ; 81 		timers_int_on();
5689  06e8 cd04f7        	call	_timers_int_on
5691                     ; 82 		timer1_start();
5693  06eb cd0388        	call	_timer1_start
5695                     ; 83 		timer2_start(TIM2_TOP);
5697  06ee ae3e80        	ldw	x,#16000
5698  06f1 cd038d        	call	_timer2_start
5700                     ; 85 		_asm ("RIM");  //on interupts
5703  06f4 9a            RIM
5705  06f5               L5413:
5706                     ; 88 	while(1);
5708  06f5 20fe          	jra	L5413
5721                     	xdef	_main
5722                     	xdef	_Keys_switched
5723                     	xdef	_I2C_Event
5724                     	xdef	_SPI_Transmitted
5725                     	xdef	_UART_Resieved
5726                     	xdef	_spi_setup
5727                     	xdef	_timer2_compare
5728                     	xdef	_timer1_compare
5729                     	xdef	_Timer1_overflow
5730                     	xdef	_Timer2_Overflow
5731                     	xdef	_timer2_start
5732                     	xdef	_timer1_start
5733                     	xdef	_timer1_comp_stop
5734                     	xdef	_timer1_comp_start
5735                     	xdef	_timer2_setup
5736                     	xdef	_timer1_setup
5737                     	xdef	_kostil_k155
5738                     	xdef	_digits_shift_init
5739                     	xdef	_time_refresh
5740                     	xdef	_timers_int_on
5741                     	xdef	_timers_int_off
5742                     	xdef	_spi_send
5743                     	xdef	_i2c_rd_reg
5744                     	xdef	_i2c_wr_reg
5745                     	xdef	_i2c_master_init
5746                     	xdef	_Key_interrupt
5747                     	xdef	_uart_routine
5748                     	xdef	_uart_send
5749                     	xdef	_uart_setup
5750                     	xdef	_time_write
5751                     	switch	.ubsct
5752  0000               _i2c_flags:
5753  0000 00            	ds.b	1
5754                     	xdef	_i2c_flags
5755  0001               _flags:
5756  0001 00            	ds.b	1
5757                     	xdef	_flags
5758                     	xdef	_tim1comp
5759                     	xdef	_correction
5760  0002               _shifting:
5761  0002 00            	ds.b	1
5762                     	xdef	_shifting
5763                     	xdef	_ds_cr
5764                     	xdef	_schetchik2
5765                     	xdef	_i
5766                     	xdef	_schetchik
5767                     	xdef	_temp3
5768                     	xdef	_temp2
5769  0003               _temp:
5770  0003 00            	ds.b	1
5771                     	xdef	_temp
5772  0004               _pins:
5773  0004 00            	ds.b	1
5774                     	xdef	_pins
5775  0005               _fresh_data_pointer:
5776  0005 0000          	ds.b	2
5777                     	xdef	_fresh_data_pointer
5778  0007               _data_pointer:
5779  0007 0000          	ds.b	2
5780                     	xdef	_data_pointer
5781                     	xdef	_time_pointer
5782  0009               _hours_tens:
5783  0009 00            	ds.b	1
5784                     	xdef	_hours_tens
5785  000a               _minutes_tens:
5786  000a 00            	ds.b	1
5787                     	xdef	_minutes_tens
5788  000b               _seconds_tens:
5789  000b 00            	ds.b	1
5790                     	xdef	_seconds_tens
5791  000c               _seconds:
5792  000c 00            	ds.b	1
5793                     	xdef	_seconds
5794  000d               _minutes:
5795  000d 00            	ds.b	1
5796                     	xdef	_minutes
5797  000e               _hours:
5798  000e 00            	ds.b	1
5799                     	xdef	_hours
5800  000f               _timeset:
5801  000f 00            	ds.b	1
5802                     	xdef	_timeset
5803  0010               _fresh_sec:
5804  0010 00            	ds.b	1
5805                     	xdef	_fresh_sec
5806  0011               _fresh_sec_dec:
5807  0011 00            	ds.b	1
5808                     	xdef	_fresh_sec_dec
5809  0012               _fresh_min:
5810  0012 00            	ds.b	1
5811                     	xdef	_fresh_min
5812  0013               _fresh_min_dec:
5813  0013 00            	ds.b	1
5814                     	xdef	_fresh_min_dec
5815  0014               _fresh_hours:
5816  0014 00            	ds.b	1
5817                     	xdef	_fresh_hours
5818  0015               _fresh_hours_dec:
5819  0015 00            	ds.b	1
5820                     	xdef	_fresh_hours_dec
5821                     	xdef	_dots_on
5822                     	xdef	_dots_upd
5823  0016               _lamp_number_data:
5824  0016 00            	ds.b	1
5825                     	xdef	_lamp_number_data
5826  0017               _k155_data:
5827  0017 00            	ds.b	1
5828                     	xdef	_k155_data
5829                     	xdef	_dots
5830                     	xdef	_lamp_number
5831                     	xref.b	c_lreg
5832                     	xref.b	c_x
5852                     	xref	c_lrsh
5853                     	xref	c_ldiv
5854                     	xref	c_uitolx
5855                     	xref	c_ludv
5856                     	xref	c_rtol
5857                     	xref	c_ltor
5858                     	end
