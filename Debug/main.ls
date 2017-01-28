   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2184                     	bsct
2185  0000               _lamp_number:
2186  0000 00            	dc.b	0
2187  0001               _dots:
2188  0001 10            	dc.b	16
2189  0002               _time_pointer:
2190  0002 000b          	dc.w	_seconds
2191  0004               _temp2:
2192  0004 00            	dc.b	0
2193  0005               _temp3:
2194  0005 33            	dc.b	51
2195  0006               _schetchik:
2196  0006 01            	dc.b	1
2197  0007               _i:
2198  0007 0000          	dc.w	0
2199  0009               _schetchik2:
2200  0009 00            	dc.b	0
2201  000a               _ds_cr:
2202  000a 90            	dc.b	144
2663                     ; 2  void uart_setup(void)
2663                     ; 3  {
2665                     	switch	.text
2666  0000               _uart_setup:
2670                     ; 4 		UART1_BRR1=0x68;     //9600 bod
2672  0000 35685232      	mov	_UART1_BRR1,#104
2673                     ; 5     UART1_BRR2=0x03;
2675  0004 35035233      	mov	_UART1_BRR2,#3
2676                     ; 6     UART1_CR2 |= UART1_CR2_REN; //reseiving
2678  0008 72145235      	bset	_UART1_CR2,#2
2679                     ; 7     UART1_CR2 |= UART1_CR2_TEN; //transmiting 
2681  000c 72165235      	bset	_UART1_CR2,#3
2682                     ; 8     UART1_CR2 |= UART1_CR2_RIEN; //reseive int
2684  0010 721a5235      	bset	_UART1_CR2,#5
2685                     ; 9 		UART1_SR = 0;
2687  0014 725f5230      	clr	_UART1_SR
2688                     ; 10  }
2691  0018 81            	ret
2728                     ; 12 void uart_send(uint8_t msg)
2728                     ; 13  {
2729                     	switch	.text
2730  0019               _uart_send:
2732  0019 88            	push	a
2733       00000000      OFST:	set	0
2736                     ; 14 	 temp =msg;
2738  001a b702          	ld	_temp,a
2740  001c               L7571:
2741                     ; 15 	 while((UART1_SR & 0x80) == 0x00);
2743  001c c65230        	ld	a,_UART1_SR
2744  001f a580          	bcp	a,#128
2745  0021 27f9          	jreq	L7571
2746                     ; 16 	 UART1_DR = msg;
2748  0023 7b01          	ld	a,(OFST+1,sp)
2749  0025 c75231        	ld	_UART1_DR,a
2750                     ; 17  }
2753  0028 84            	pop	a
2754  0029 81            	ret
2800                     ; 18  void uart_routine(uint8_t data)
2800                     ; 19  {
2801                     	switch	.text
2802  002a               _uart_routine:
2804  002a 88            	push	a
2805       00000000      OFST:	set	0
2808                     ; 21 	 temp2 = data - 0x30;
2810  002b a030          	sub	a,#48
2811  002d b704          	ld	_temp2,a
2812                     ; 22 	 if (timeset != 0 && timeset <= 5)
2814  002f 3d0e          	tnz	_timeset
2815  0031 2719          	jreq	L1002
2817  0033 b60e          	ld	a,_timeset
2818  0035 a106          	cp	a,#6
2819  0037 2413          	jruge	L1002
2820                     ; 24 		* fresh_data_pointer-- = data-0x30;
2822  0039 7b01          	ld	a,(OFST+1,sp)
2823  003b a030          	sub	a,#48
2824  003d be04          	ldw	x,_fresh_data_pointer
2825  003f 1d0001        	subw	x,#1
2826  0042 bf04          	ldw	_fresh_data_pointer,x
2827  0044 1c0001        	addw	x,#1
2828  0047 f7            	ld	(x),a
2829                     ; 25 		 timeset++;
2831  0048 3c0e          	inc	_timeset
2832                     ; 26 		 return ;
2835  004a 84            	pop	a
2836  004b 81            	ret
2837  004c               L1002:
2838                     ; 28 	 if (timeset == 6)
2840  004c b60e          	ld	a,_timeset
2841  004e a106          	cp	a,#6
2842  0050 2616          	jrne	L3002
2843                     ; 30 		 *fresh_data_pointer = data-0x30;
2845  0052 7b01          	ld	a,(OFST+1,sp)
2846  0054 a030          	sub	a,#48
2847  0056 92c704        	ld	[_fresh_data_pointer.w],a
2848                     ; 31 		 timeset = 0;
2850  0059 3f0e          	clr	_timeset
2851                     ; 32 		 time_write();
2853  005b cd0456        	call	_time_write
2855                     ; 33 		 uart_send('O');
2857  005e a64f          	ld	a,#79
2858  0060 adb7          	call	_uart_send
2860                     ; 34 		 uart_send('K');
2862  0062 a64b          	ld	a,#75
2863  0064 adb3          	call	_uart_send
2865                     ; 35 		 return;
2868  0066 84            	pop	a
2869  0067 81            	ret
2870  0068               L3002:
2871                     ; 38 	 if (data == 's')
2873  0068 7b01          	ld	a,(OFST+1,sp)
2874  006a a173          	cp	a,#115
2875  006c 260b          	jrne	L5002
2876                     ; 40 			timeset = 1;
2878  006e 3501000e      	mov	_timeset,#1
2879                     ; 41 			fresh_data_pointer = &fresh_hours_dec;
2881  0072 ae0014        	ldw	x,#_fresh_hours_dec
2882  0075 bf04          	ldw	_fresh_data_pointer,x
2883                     ; 42 			return;
2886  0077 84            	pop	a
2887  0078 81            	ret
2888  0079               L5002:
2889                     ; 46 		if (data == 't')
2891  0079 7b01          	ld	a,(OFST+1,sp)
2892  007b a174          	cp	a,#116
2893  007d 2635          	jrne	L7002
2894                     ; 48 			uart_send(hours_tens+0x30);
2896  007f b608          	ld	a,_hours_tens
2897  0081 ab30          	add	a,#48
2898  0083 ad94          	call	_uart_send
2900                     ; 49 			uart_send(hours+0x30);
2902  0085 b60d          	ld	a,_hours
2903  0087 ab30          	add	a,#48
2904  0089 ad8e          	call	_uart_send
2906                     ; 50 			uart_send(':');	
2908  008b a63a          	ld	a,#58
2909  008d ad8a          	call	_uart_send
2911                     ; 51 			uart_send(minutes_tens+0x30);
2913  008f b609          	ld	a,_minutes_tens
2914  0091 ab30          	add	a,#48
2915  0093 ad84          	call	_uart_send
2917                     ; 52 			uart_send(minutes+0x30);
2919  0095 b60c          	ld	a,_minutes
2920  0097 ab30          	add	a,#48
2921  0099 cd0019        	call	_uart_send
2923                     ; 53 			uart_send(':'); 
2925  009c a63a          	ld	a,#58
2926  009e cd0019        	call	_uart_send
2928                     ; 54 			uart_send(seconds_tens+0x30);
2930  00a1 b60a          	ld	a,_seconds_tens
2931  00a3 ab30          	add	a,#48
2932  00a5 cd0019        	call	_uart_send
2934                     ; 55 			uart_send(seconds+0x30);
2936  00a8 b60b          	ld	a,_seconds
2937  00aa ab30          	add	a,#48
2938  00ac cd0019        	call	_uart_send
2940                     ; 56 			uart_send(0x0A);
2942  00af a60a          	ld	a,#10
2943  00b1 cd0019        	call	_uart_send
2945  00b4               L7002:
2946                     ; 58 	}
2949  00b4 84            	pop	a
2950  00b5 81            	ret
2992                     ; 1  void Key_interrupt (void)
2992                     ; 2 {
2993                     	switch	.text
2994  00b6               _Key_interrupt:
2998                     ; 4   pins = PC_IDR;
3000  00b6 55500b0003    	mov	_pins,_PC_IDR
3001                     ; 5 }
3004  00bb 81            	ret
3083                     ; 7 void i2c_master_init(unsigned long f_master_hz, unsigned long f_i2c_hz){
3084                     	switch	.text
3085  00bc               _i2c_master_init:
3087  00bc 5208          	subw	sp,#8
3088       00000008      OFST:	set	8
3091                     ; 9 	I2C_CR1 &= ~I2C_CR1_PE;
3093  00be 72115210      	bres	_I2C_CR1,#0
3094                     ; 10 	I2C_CR2 |= I2C_CR2_SWRST;
3096  00c2 721e5211      	bset	_I2C_CR2,#7
3097                     ; 11   PB_DDR = (0<<4);//PB_DDR_DDR4);
3099  00c6 725f5007      	clr	_PB_DDR
3100                     ; 12 	PB_DDR = (0<<5);//PB_DDR_DDR5);
3102  00ca 725f5007      	clr	_PB_DDR
3103                     ; 13 	PB_ODR = (1<<5);//PB_ODR_ODR5);  //SDA
3105  00ce 35205005      	mov	_PB_ODR,#32
3106                     ; 14   PB_ODR = (1<<4);//PB_ODR_ODR4);  //SCL
3108  00d2 35105005      	mov	_PB_ODR,#16
3109                     ; 16   PB_CR1 = (0<<4);//PB_CR1_C14);
3111  00d6 725f5008      	clr	_PB_CR1
3112                     ; 17   PB_CR1 = (0<<5);//PB_CR1_C15);
3114  00da 725f5008      	clr	_PB_CR1
3115                     ; 19   PB_CR2 = (0<<4);//PB_CR1_C24);
3117  00de 725f5009      	clr	_PB_CR2
3118                     ; 20   PB_CR2 = (0<<5);//PB_CR1_C25);
3120  00e2 725f5009      	clr	_PB_CR2
3121                     ; 21   I2C_CR2 &= ~I2C_CR2_SWRST;
3123  00e6 721f5211      	bres	_I2C_CR2,#7
3124                     ; 23   I2C_FREQR = 16;
3126  00ea 35105212      	mov	_I2C_FREQR,#16
3127                     ; 28   I2C_CCRH |=~I2C_CCRH_FS;
3129  00ee c6521c        	ld	a,_I2C_CCRH
3130  00f1 aa7f          	or	a,#127
3131  00f3 c7521c        	ld	_I2C_CCRH,a
3132                     ; 30   ccr = f_master_hz/(2*f_i2c_hz);
3134  00f6 96            	ldw	x,sp
3135  00f7 1c000f        	addw	x,#OFST+7
3136  00fa cd0000        	call	c_ltor
3138  00fd 3803          	sll	c_lreg+3
3139  00ff 3902          	rlc	c_lreg+2
3140  0101 3901          	rlc	c_lreg+1
3141  0103 3900          	rlc	c_lreg
3142  0105 96            	ldw	x,sp
3143  0106 1c0001        	addw	x,#OFST-7
3144  0109 cd0000        	call	c_rtol
3146  010c 96            	ldw	x,sp
3147  010d 1c000b        	addw	x,#OFST+3
3148  0110 cd0000        	call	c_ltor
3150  0113 96            	ldw	x,sp
3151  0114 1c0001        	addw	x,#OFST-7
3152  0117 cd0000        	call	c_ludv
3154  011a 96            	ldw	x,sp
3155  011b 1c0005        	addw	x,#OFST-3
3156  011e cd0000        	call	c_rtol
3158                     ; 34   I2C_TRISER = 12+1;
3160  0121 350d521d      	mov	_I2C_TRISER,#13
3161                     ; 35   I2C_CCRL = ccr & 0xFF;
3163  0125 7b08          	ld	a,(OFST+0,sp)
3164  0127 a4ff          	and	a,#255
3165  0129 c7521b        	ld	_I2C_CCRL,a
3166                     ; 36   I2C_CCRH = ((ccr >> 8) & 0x0F);
3168  012c 7b07          	ld	a,(OFST-1,sp)
3169  012e a40f          	and	a,#15
3170  0130 c7521c        	ld	_I2C_CCRH,a
3171                     ; 39   I2C_CR1 |=I2C_CR1_PE;
3173  0133 72105210      	bset	_I2C_CR1,#0
3174                     ; 42   I2C_CR2 |=I2C_CR2_ACK;
3176  0137 72145211      	bset	_I2C_CR2,#2
3177                     ; 43 }
3180  013b 5b08          	addw	sp,#8
3181  013d 81            	ret
3275                     ; 49 t_i2c_status i2c_wr_reg(unsigned char address, unsigned char reg_addr,
3275                     ; 50                               char * data, unsigned char length)
3275                     ; 51 {                                  
3276                     	switch	.text
3277  013e               _i2c_wr_reg:
3279  013e 89            	pushw	x
3280       00000000      OFST:	set	0
3283  013f               L1312:
3284                     ; 55   while((I2C_SR3 & I2C_SR3_BUSY) !=0);   
3286  013f c65219        	ld	a,_I2C_SR3
3287  0142 a502          	bcp	a,#2
3288  0144 26f9          	jrne	L1312
3289                     ; 57   I2C_CR2 |= I2C_CR2_START;
3291  0146 72105211      	bset	_I2C_CR2,#0
3293  014a               L7312:
3294                     ; 60   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3296  014a c65217        	ld	a,_I2C_SR1
3297  014d a501          	bcp	a,#1
3298  014f 27f9          	jreq	L7312
3299                     ; 63   I2C_DR = address & 0xFE;
3301  0151 7b01          	ld	a,(OFST+1,sp)
3302  0153 a4fe          	and	a,#254
3303  0155 c75216        	ld	_I2C_DR,a
3305  0158               L7412:
3306                     ; 66 	while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3308  0158 c65217        	ld	a,_I2C_SR1
3309  015b a502          	bcp	a,#2
3310  015d 27f9          	jreq	L7412
3311                     ; 68   I2C_SR3;
3313  015f c65219        	ld	a,_I2C_SR3
3315  0162               L5512:
3316                     ; 73   while((I2C_SR1 & I2C_SR1_TXE) ==0);
3318  0162 c65217        	ld	a,_I2C_SR1
3319  0165 a580          	bcp	a,#128
3320  0167 27f9          	jreq	L5512
3321                     ; 75   I2C_DR = reg_addr;
3323  0169 7b02          	ld	a,(OFST+2,sp)
3324  016b c75216        	ld	_I2C_DR,a
3326  016e 2015          	jra	L5612
3327  0170               L3712:
3328                     ; 81     while((I2C_SR1 & I2C_SR1_TXE) == 0);
3330  0170 c65217        	ld	a,_I2C_SR1
3331  0173 a580          	bcp	a,#128
3332  0175 27f9          	jreq	L3712
3333                     ; 83     I2C_DR = *data++;
3335  0177 1e05          	ldw	x,(OFST+5,sp)
3336  0179 1c0001        	addw	x,#1
3337  017c 1f05          	ldw	(OFST+5,sp),x
3338  017e 1d0001        	subw	x,#1
3339  0181 f6            	ld	a,(x)
3340  0182 c75216        	ld	_I2C_DR,a
3341  0185               L5612:
3342                     ; 78   while(length--){
3344  0185 7b07          	ld	a,(OFST+7,sp)
3345  0187 0a07          	dec	(OFST+7,sp)
3346  0189 4d            	tnz	a
3347  018a 26e4          	jrne	L3712
3349  018c               L1022:
3350                     ; 88   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3352  018c c65217        	ld	a,_I2C_SR1
3353  018f a584          	bcp	a,#132
3354  0191 27f9          	jreq	L1022
3355                     ; 90   I2C_CR2 |= I2C_CR2_STOP;
3357  0193 72125211      	bset	_I2C_CR2,#1
3359  0197               L7022:
3360                     ; 93   while((I2C_CR2 & I2C_CR2_STOP) == 0); 
3362  0197 c65211        	ld	a,_I2C_CR2
3363  019a a502          	bcp	a,#2
3364  019c 27f9          	jreq	L7022
3365                     ; 94   return I2C_SUCCESS;
3367  019e 4f            	clr	a
3370  019f 85            	popw	x
3371  01a0 81            	ret
3441                     ; 101 t_i2c_status i2c_rd_reg(unsigned char address, unsigned char reg_addr,
3441                     ; 102                               char * data, unsigned char length)
3441                     ; 103 {
3442                     	switch	.text
3443  01a1               _i2c_rd_reg:
3445  01a1 89            	pushw	x
3446       00000000      OFST:	set	0
3449  01a2               L7422:
3450                     ; 109   while((I2C_SR3 & I2C_SR3_BUSY) != 0);   
3452  01a2 c65219        	ld	a,_I2C_SR3
3453  01a5 a502          	bcp	a,#2
3454  01a7 26f9          	jrne	L7422
3455                     ; 111   I2C_CR2 |= I2C_CR2_ACK;
3457  01a9 72145211      	bset	_I2C_CR2,#2
3458                     ; 114   I2C_CR2 |= I2C_CR2_START;
3460  01ad 72105211      	bset	_I2C_CR2,#0
3462  01b1               L5522:
3463                     ; 117   while((I2C_SR1 & I2C_SR1_SB) == 0);  
3465  01b1 c65217        	ld	a,_I2C_SR1
3466  01b4 a501          	bcp	a,#1
3467  01b6 27f9          	jreq	L5522
3468                     ; 119   I2C_DR = address & 0xFE;
3470  01b8 7b01          	ld	a,(OFST+1,sp)
3471  01ba a4fe          	and	a,#254
3472  01bc c75216        	ld	_I2C_DR,a
3474  01bf               L5622:
3475                     ; 122   while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3477  01bf c65217        	ld	a,_I2C_SR1
3478  01c2 a502          	bcp	a,#2
3479  01c4 27f9          	jreq	L5622
3480                     ; 124   temp = I2C_SR3;
3482  01c6 5552190002    	mov	_temp,_I2C_SR3
3484  01cb               L5722:
3485                     ; 128   while((I2C_SR1 & I2C_SR1) == 0); 
3487  01cb c65217        	ld	a,_I2C_SR1
3488  01ce 5f            	clrw	x
3489  01cf 97            	ld	xl,a
3490  01d0 a30000        	cpw	x,#0
3491  01d3 27f6          	jreq	L5722
3492                     ; 130   I2C_DR = reg_addr;
3494  01d5 7b02          	ld	a,(OFST+2,sp)
3495  01d7 c75216        	ld	_I2C_DR,a
3497  01da               L5032:
3498                     ; 133   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3500  01da c65217        	ld	a,_I2C_SR1
3501  01dd a584          	bcp	a,#132
3502  01df 27f9          	jreq	L5032
3503                     ; 135   I2C_CR2 |= I2C_CR2_START;
3505  01e1 72105211      	bset	_I2C_CR2,#0
3507  01e5               L3132:
3508                     ; 138   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3510  01e5 c65217        	ld	a,_I2C_SR1
3511  01e8 a501          	bcp	a,#1
3512  01ea 27f9          	jreq	L3132
3513                     ; 141   I2C_DR = address | 0x01;
3515  01ec 7b01          	ld	a,(OFST+1,sp)
3516  01ee aa01          	or	a,#1
3517  01f0 c75216        	ld	_I2C_DR,a
3518                     ; 145   if(length == 1){
3520  01f3 7b07          	ld	a,(OFST+7,sp)
3521  01f5 a101          	cp	a,#1
3522  01f7 2627          	jrne	L7132
3523                     ; 147     I2C_CR2 &= ~I2C_CR2_ACK;
3525  01f9 72155211      	bres	_I2C_CR2,#2
3527  01fd               L3232:
3528                     ; 150     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3530  01fd c65217        	ld	a,_I2C_SR1
3531  0200 a502          	bcp	a,#2
3532  0202 27f9          	jreq	L3232
3533                     ; 152     _asm ("SIM");  //on interupts
3536  0204 9b            SIM
3538                     ; 154     temp = I2C_SR3;
3540  0205 5552190002    	mov	_temp,_I2C_SR3
3541                     ; 157     I2C_CR2 |= I2C_CR2_STOP;
3543  020a 72125211      	bset	_I2C_CR2,#1
3544                     ; 159     _asm ("RIM");  //on interupts;
3547  020e 9a            RIM
3550  020f               L1332:
3551                     ; 163     while((I2C_SR1 & I2C_SR1_RXNE) == 0); 
3553  020f c65217        	ld	a,_I2C_SR1
3554  0212 a540          	bcp	a,#64
3555  0214 27f9          	jreq	L1332
3556                     ; 165     *data = I2C_DR;
3558  0216 1e05          	ldw	x,(OFST+5,sp)
3559  0218 c65216        	ld	a,_I2C_DR
3560  021b f7            	ld	(x),a
3562  021c acd202d2      	jpf	L5332
3563  0220               L7132:
3564                     ; 168   else if(length == 2){
3566  0220 7b07          	ld	a,(OFST+7,sp)
3567  0222 a102          	cp	a,#2
3568  0224 2639          	jrne	L7332
3569                     ; 170     I2C_CR2 |= I2C_CR2_POS;
3571  0226 72165211      	bset	_I2C_CR2,#3
3573  022a               L3432:
3574                     ; 173     while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3576  022a c65217        	ld	a,_I2C_SR1
3577  022d a502          	bcp	a,#2
3578  022f 27f9          	jreq	L3432
3579                     ; 175     _asm ("SIM");  //on interupts;
3582  0231 9b            SIM
3584                     ; 177     temp = I2C_SR3;
3586  0232 5552190002    	mov	_temp,_I2C_SR3
3587                     ; 179     I2C_CR2 &= ~I2C_CR2_ACK;
3589  0237 72155211      	bres	_I2C_CR2,#2
3590                     ; 181     _asm ("RIM");  //on interupts;
3593  023b 9a            RIM
3596  023c               L1532:
3597                     ; 185     while((I2C_SR1 & I2C_SR1_BTF) == 0); 
3599  023c c65217        	ld	a,_I2C_SR1
3600  023f a504          	bcp	a,#4
3601  0241 27f9          	jreq	L1532
3602                     ; 187     _asm ("SIM");  //on interupts;
3605  0243 9b            SIM
3607                     ; 189     I2C_CR2 |= I2C_CR2_STOP;
3609  0244 72125211      	bset	_I2C_CR2,#1
3610                     ; 191     *data++ = I2C_DR;
3612  0248 1e05          	ldw	x,(OFST+5,sp)
3613  024a 1c0001        	addw	x,#1
3614  024d 1f05          	ldw	(OFST+5,sp),x
3615  024f 1d0001        	subw	x,#1
3616  0252 c65216        	ld	a,_I2C_DR
3617  0255 f7            	ld	(x),a
3618                     ; 193     _asm ("RIM");  //on interupts;
3621  0256 9a            RIM
3623                     ; 194     *data = I2C_DR;
3625  0257 1e05          	ldw	x,(OFST+5,sp)
3626  0259 c65216        	ld	a,_I2C_DR
3627  025c f7            	ld	(x),a
3629  025d 2073          	jra	L5332
3630  025f               L7332:
3631                     ; 197   else if(length > 2){
3633  025f 7b07          	ld	a,(OFST+7,sp)
3634  0261 a103          	cp	a,#3
3635  0263 256d          	jrult	L5332
3637  0265               L3632:
3638                     ; 200     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3640  0265 c65217        	ld	a,_I2C_SR1
3641  0268 a502          	bcp	a,#2
3642  026a 27f9          	jreq	L3632
3643                     ; 202     _asm ("SIM");  //on interupts;
3646  026c 9b            SIM
3648                     ; 205     I2C_SR3;
3650  026d c65219        	ld	a,_I2C_SR3
3651                     ; 208     _asm ("RIM");  //on interupts;
3654  0270 9a            RIM
3657  0271 2015          	jra	L1732
3658  0273               L7732:
3659                     ; 213       while((I2C_SR1 & I2C_SR1_BTF) == 0);
3661  0273 c65217        	ld	a,_I2C_SR1
3662  0276 a504          	bcp	a,#4
3663  0278 27f9          	jreq	L7732
3664                     ; 215       *data++ = I2C_DR;
3666  027a 1e05          	ldw	x,(OFST+5,sp)
3667  027c 1c0001        	addw	x,#1
3668  027f 1f05          	ldw	(OFST+5,sp),x
3669  0281 1d0001        	subw	x,#1
3670  0284 c65216        	ld	a,_I2C_DR
3671  0287 f7            	ld	(x),a
3672  0288               L1732:
3673                     ; 210     while(length-- > 3){
3675  0288 7b07          	ld	a,(OFST+7,sp)
3676  028a 0a07          	dec	(OFST+7,sp)
3677  028c a104          	cp	a,#4
3678  028e 24e3          	jruge	L7732
3680  0290               L5042:
3681                     ; 224     while((I2C_SR1 & I2C_SR1_BTF) == 0);
3683  0290 c65217        	ld	a,_I2C_SR1
3684  0293 a504          	bcp	a,#4
3685  0295 27f9          	jreq	L5042
3686                     ; 226     I2C_CR2 &= ~I2C_CR2_ACK;
3688  0297 72155211      	bres	_I2C_CR2,#2
3689                     ; 228     _asm ("SIM");  //on interupts;
3692  029b 9b            SIM
3694                     ; 231     *data++ = I2C_DR;
3696  029c 1e05          	ldw	x,(OFST+5,sp)
3697  029e 1c0001        	addw	x,#1
3698  02a1 1f05          	ldw	(OFST+5,sp),x
3699  02a3 1d0001        	subw	x,#1
3700  02a6 c65216        	ld	a,_I2C_DR
3701  02a9 f7            	ld	(x),a
3702                     ; 233     I2C_CR2 |= I2C_CR2_STOP;
3704  02aa 72125211      	bset	_I2C_CR2,#1
3705                     ; 235     *data++ = I2C_DR;
3707  02ae 1e05          	ldw	x,(OFST+5,sp)
3708  02b0 1c0001        	addw	x,#1
3709  02b3 1f05          	ldw	(OFST+5,sp),x
3710  02b5 1d0001        	subw	x,#1
3711  02b8 c65216        	ld	a,_I2C_DR
3712  02bb f7            	ld	(x),a
3713                     ; 237     _asm ("RIM");  //on interupts;
3716  02bc 9a            RIM
3719  02bd               L3142:
3720                     ; 240     while((I2C_SR1 & I2C_SR1_RXNE) == 0);
3722  02bd c65217        	ld	a,_I2C_SR1
3723  02c0 a540          	bcp	a,#64
3724  02c2 27f9          	jreq	L3142
3725                     ; 242     *data++ = I2C_DR;
3727  02c4 1e05          	ldw	x,(OFST+5,sp)
3728  02c6 1c0001        	addw	x,#1
3729  02c9 1f05          	ldw	(OFST+5,sp),x
3730  02cb 1d0001        	subw	x,#1
3731  02ce c65216        	ld	a,_I2C_DR
3732  02d1 f7            	ld	(x),a
3733  02d2               L5332:
3734                     ; 245 	 I2C_CR2 |= I2C_CR2_STOP;
3736  02d2 72125211      	bset	_I2C_CR2,#1
3738  02d6               L1242:
3739                     ; 248   while((I2C_CR2 & I2C_CR2_STOP) == 0);
3741  02d6 c65211        	ld	a,_I2C_CR2
3742  02d9 a502          	bcp	a,#2
3743  02db 27f9          	jreq	L1242
3744                     ; 250   I2C_CR2 &= ~I2C_CR2_POS;
3746  02dd 72175211      	bres	_I2C_CR2,#3
3747                     ; 252   return I2C_SUCCESS;
3749  02e1 4f            	clr	a
3752  02e2 85            	popw	x
3753  02e3 81            	ret
3794                     ; 10 void timer1_start(void)
3794                     ; 11  {
3795                     	switch	.text
3796  02e4               _timer1_start:
3800                     ; 12    TIM1_CR1 |= TIM1_CR1_CEN; //Запускаем таймер
3802  02e4 72105250      	bset	_TIM1_CR1,#0
3803                     ; 13  }
3806  02e8 81            	ret
3843                     ; 15 void timer2_start(uint16_t top_val)
3843                     ; 16 {
3844                     	switch	.text
3845  02e9               _timer2_start:
3849                     ; 17   TIM2_ARRH =top_val >>8;
3851  02e9 9e            	ld	a,xh
3852  02ea c7530f        	ld	_TIM2_ARRH,a
3853                     ; 18   TIM2_ARRL =top_val & 0xFF;
3855  02ed 9f            	ld	a,xl
3856  02ee a4ff          	and	a,#255
3857  02f0 c75310        	ld	_TIM2_ARRL,a
3858                     ; 19   TIM2_CR1 |= TIM2_CR1_CEN;
3860  02f3 72105300      	bset	_TIM2_CR1,#0
3861                     ; 20 }
3864  02f7 81            	ret
3904                     ; 22 void Timer2_Overflow (void)
3904                     ; 23 {
3905                     	switch	.text
3906  02f8               _Timer2_Overflow:
3910                     ; 24 	TIM2_SR1 = 0;
3912  02f8 725f5304      	clr	_TIM2_SR1
3913                     ; 25 	if (schetchik ==1)
3915  02fc b606          	ld	a,_schetchik
3916  02fe a101          	cp	a,#1
3917  0300 2703          	jreq	L04
3918  0302 cc0391        	jp	L1052
3919  0305               L04:
3920                     ; 27 	switch (lamp_number)
3922  0305 b600          	ld	a,_lamp_number
3924                     ; 40 	break;
3925  0307 4d            	tnz	a
3926  0308 270b          	jreq	L1642
3927  030a 4a            	dec	a
3928  030b 270d          	jreq	L3642
3929  030d 4a            	dec	a
3930  030e 270f          	jreq	L5642
3931  0310 4a            	dec	a
3932  0311 2711          	jreq	L7642
3933  0313 2012          	jra	L5052
3934  0315               L1642:
3935                     ; 29 	case 0:
3935                     ; 30 	k155_data = hours_tens; 
3937  0315 450816        	mov	_k155_data,_hours_tens
3938                     ; 31 	break;
3940  0318 200d          	jra	L5052
3941  031a               L3642:
3942                     ; 32 	case 1:
3942                     ; 33 	k155_data = hours;
3944  031a 450d16        	mov	_k155_data,_hours
3945                     ; 34 	break;
3947  031d 2008          	jra	L5052
3948  031f               L5642:
3949                     ; 35 	case 2:
3949                     ; 36 	k155_data = minutes_tens;
3951  031f 450916        	mov	_k155_data,_minutes_tens
3952                     ; 37 	break;
3954  0322 2003          	jra	L5052
3955  0324               L7642:
3956                     ; 38 	case 3:
3956                     ; 39 	k155_data = minutes;
3958  0324 450c16        	mov	_k155_data,_minutes
3959                     ; 40 	break;
3961  0327               L5052:
3962                     ; 43 	if (lamp_number < 3)
3964  0327 b600          	ld	a,_lamp_number
3965  0329 a103          	cp	a,#3
3966  032b 2415          	jruge	L7052
3967                     ; 45 			lamp_number_data = (1<<(lamp_number++));
3969  032d b600          	ld	a,_lamp_number
3970  032f 97            	ld	xl,a
3971  0330 3c00          	inc	_lamp_number
3972  0332 9f            	ld	a,xl
3973  0333 5f            	clrw	x
3974  0334 97            	ld	xl,a
3975  0335 a601          	ld	a,#1
3976  0337 5d            	tnzw	x
3977  0338 2704          	jreq	L03
3978  033a               L23:
3979  033a 48            	sll	a
3980  033b 5a            	decw	x
3981  033c 26fc          	jrne	L23
3982  033e               L03:
3983  033e b715          	ld	_lamp_number_data,a
3985  0340 2017          	jra	L1152
3986  0342               L7052:
3987                     ; 47 		else if (lamp_number >= 3)
3989  0342 b600          	ld	a,_lamp_number
3990  0344 a103          	cp	a,#3
3991  0346 2511          	jrult	L1152
3992                     ; 49 			lamp_number_data = (1<<(lamp_number));
3994  0348 b600          	ld	a,_lamp_number
3995  034a 5f            	clrw	x
3996  034b 97            	ld	xl,a
3997  034c a601          	ld	a,#1
3998  034e 5d            	tnzw	x
3999  034f 2704          	jreq	L43
4000  0351               L63:
4001  0351 48            	sll	a
4002  0352 5a            	decw	x
4003  0353 26fc          	jrne	L63
4004  0355               L43:
4005  0355 b715          	ld	_lamp_number_data,a
4006                     ; 50 			lamp_number = 0;
4008  0357 3f00          	clr	_lamp_number
4009  0359               L1152:
4010                     ; 53 			timers_int_off();
4012  0359 cd0444        	call	_timers_int_off
4014                     ; 54 	PA_ODR &= (0<<3);
4016  035c 725f5000      	clr	_PA_ODR
4017                     ; 57 	spi_send(kostil_k155(k155_data));
4019  0360 b616          	ld	a,_k155_data
4020  0362 cd04a6        	call	_kostil_k155
4022  0365 cd04cd        	call	_spi_send
4024                     ; 58 	if (schetchik2++ <= 4)
4026  0368 b609          	ld	a,_schetchik2
4027  036a 3c09          	inc	_schetchik2
4028  036c a105          	cp	a,#5
4029  036e 2407          	jruge	L5152
4030                     ; 60 	spi_send(lamp_number_data);
4032  0370 b615          	ld	a,_lamp_number_data
4033  0372 cd04cd        	call	_spi_send
4036  0375 2009          	jra	L3252
4037  0377               L5152:
4038                     ; 64 		spi_send(lamp_number_data | dots);
4040  0377 b615          	ld	a,_lamp_number_data
4041  0379 ba01          	or	a,_dots
4042  037b cd04cd        	call	_spi_send
4044                     ; 65 		schetchik2 = 0;
4046  037e 3f09          	clr	_schetchik2
4047  0380               L3252:
4048                     ; 68 	while((SPI_SR & SPI_SR_BSY) != 0);
4050  0380 c65203        	ld	a,_SPI_SR
4051  0383 a580          	bcp	a,#128
4052  0385 26f9          	jrne	L3252
4053                     ; 69 	PA_ODR |= (1<<3);
4055  0387 72165000      	bset	_PA_ODR,#3
4056                     ; 70 	timers_int_on();
4058  038b cd044d        	call	_timers_int_on
4060                     ; 72 	schetchik = 0;
4062  038e 3f06          	clr	_schetchik
4064  0390               L7252:
4065                     ; 104 	return;
4068  0390 81            	ret
4069  0391               L1052:
4070                     ; 76 		schetchik = 1;
4072  0391 35010006      	mov	_schetchik,#1
4073                     ; 77 	timers_int_off();
4075  0395 cd0444        	call	_timers_int_off
4077                     ; 78 	PA_ODR &= (0<<3);
4079  0398 725f5000      	clr	_PA_ODR
4080                     ; 82 	spi_send(kostil_k155(k155_data));
4082  039c b616          	ld	a,_k155_data
4083  039e cd04a6        	call	_kostil_k155
4085  03a1 cd04cd        	call	_spi_send
4087                     ; 83 	spi_send(0);
4089  03a4 4f            	clr	a
4090  03a5 cd04cd        	call	_spi_send
4093  03a8               L3352:
4094                     ; 85 	while((SPI_SR & SPI_SR_BSY) != 0);
4096  03a8 c65203        	ld	a,_SPI_SR
4097  03ab a580          	bcp	a,#128
4098  03ad 26f9          	jrne	L3352
4099                     ; 86 	PA_ODR |= (1<<3);
4101  03af 72165000      	bset	_PA_ODR,#3
4102                     ; 87 	timers_int_on();
4104  03b3 cd044d        	call	_timers_int_on
4106  03b6 20d8          	jra	L7252
4132                     ; 107 void Timer1_Compare_1 (void)
4132                     ; 108 {
4133                     	switch	.text
4134  03b8               _Timer1_Compare_1:
4138                     ; 109 	TIM1_SR1 = 0;
4140  03b8 725f5255      	clr	_TIM1_SR1
4141                     ; 110 	dots = ~dots;
4143  03bc 3301          	cpl	_dots
4144                     ; 111 	dots &= 0b00010000;
4146  03be b601          	ld	a,_dots
4147  03c0 a410          	and	a,#16
4148  03c2 b701          	ld	_dots,a
4149                     ; 112 	time_refresh();
4151  03c4 cd04fd        	call	_time_refresh
4153                     ; 113 }
4156  03c7 81            	ret
4206                     ; 116 void timer1_setup(uint16_t tim_freq, uint16_t top)
4206                     ; 117  {
4207                     	switch	.text
4208  03c8               _timer1_setup:
4210  03c8 89            	pushw	x
4211  03c9 5204          	subw	sp,#4
4212       00000004      OFST:	set	4
4215                     ; 118   TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
4217  03cb cd0000        	call	c_uitolx
4219  03ce 96            	ldw	x,sp
4220  03cf 1c0001        	addw	x,#OFST-3
4221  03d2 cd0000        	call	c_rtol
4223  03d5 ae2400        	ldw	x,#9216
4224  03d8 bf02          	ldw	c_lreg+2,x
4225  03da ae00f4        	ldw	x,#244
4226  03dd bf00          	ldw	c_lreg,x
4227  03df 96            	ldw	x,sp
4228  03e0 1c0001        	addw	x,#OFST-3
4229  03e3 cd0000        	call	c_ldiv
4231  03e6 a608          	ld	a,#8
4232  03e8 cd0000        	call	c_lrsh
4234  03eb b603          	ld	a,c_lreg+3
4235  03ed c75260        	ld	_TIM1_PSCRH,a
4236                     ; 119   TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; // 16 divider
4238  03f0 1e05          	ldw	x,(OFST+1,sp)
4239  03f2 cd0000        	call	c_uitolx
4241  03f5 96            	ldw	x,sp
4242  03f6 1c0001        	addw	x,#OFST-3
4243  03f9 cd0000        	call	c_rtol
4245  03fc ae2400        	ldw	x,#9216
4246  03ff bf02          	ldw	c_lreg+2,x
4247  0401 ae00f4        	ldw	x,#244
4248  0404 bf00          	ldw	c_lreg,x
4249  0406 96            	ldw	x,sp
4250  0407 1c0001        	addw	x,#OFST-3
4251  040a cd0000        	call	c_ldiv
4253  040d 3f02          	clr	c_lreg+2
4254  040f 3f01          	clr	c_lreg+1
4255  0411 3f00          	clr	c_lreg
4256  0413 b603          	ld	a,c_lreg+3
4257  0415 c75261        	ld	_TIM1_PSCRL,a
4258                     ; 120   TIM1_ARRH = (top) >> 8; //	overflow frequency = 16М / 8 / 1000 = 2000 Гц
4260  0418 7b09          	ld	a,(OFST+5,sp)
4261  041a c75262        	ld	_TIM1_ARRH,a
4262                     ; 121   TIM1_ARRL = (top)& 0xFF;
4264  041d 7b0a          	ld	a,(OFST+6,sp)
4265  041f a4ff          	and	a,#255
4266  0421 c75263        	ld	_TIM1_ARRL,a
4267                     ; 123   TIM1_CR1 |= TIM1_CR1_URS; //only overflow int
4269  0424 72145250      	bset	_TIM1_CR1,#2
4270                     ; 124   TIM1_EGR |= TIM1_EGR_UG;  //call Update Event
4272  0428 72105257      	bset	_TIM1_EGR,#0
4273                     ; 125   TIM1_IER |= TIM1_IER_UIE; //int enable
4275  042c 72105254      	bset	_TIM1_IER,#0
4276                     ; 126  }
4279  0430 5b06          	addw	sp,#6
4280  0432 81            	ret
4307                     ; 129 void timer2_setup(void)
4307                     ; 130  {
4308                     	switch	.text
4309  0433               _timer2_setup:
4313                     ; 132     TIM2_IER |= TIM2_IER_UIE;	//overflow int   
4315  0433 72105303      	bset	_TIM2_IER,#0
4316                     ; 133     TIM2_PSCR = 0;
4318  0437 725f530e      	clr	_TIM2_PSCR
4319                     ; 134     TIM2_ARRH = 0;
4321  043b 725f530f      	clr	_TIM2_ARRH
4322                     ; 135     TIM2_ARRL = 0;
4324  043f 725f5310      	clr	_TIM2_ARRL
4325                     ; 136  }
4328  0443 81            	ret
4353                     ; 139 void timers_int_off(void)
4353                     ; 140 {
4354                     	switch	.text
4355  0444               _timers_int_off:
4359                     ; 141 	TIM1_IER &= ~TIM1_IER_UIE;
4361  0444 72115254      	bres	_TIM1_IER,#0
4362                     ; 142 	TIM2_IER &= ~TIM2_IER_UIE;
4364  0448 72115303      	bres	_TIM2_IER,#0
4365                     ; 143 }
4368  044c 81            	ret
4393                     ; 145 void timers_int_on(void)
4393                     ; 146 {
4394                     	switch	.text
4395  044d               _timers_int_on:
4399                     ; 147 	TIM1_IER |= TIM1_IER_UIE;
4401  044d 72105254      	bset	_TIM1_IER,#0
4402                     ; 148 	TIM2_IER |= TIM2_IER_UIE;
4404  0451 72105303      	bset	_TIM2_IER,#0
4405                     ; 149 }
4408  0455 81            	ret
4457                     ; 1 void time_write(void)
4457                     ; 2 {
4458                     	switch	.text
4459  0456               _time_write:
4463                     ; 5 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
4465  0456 b614          	ld	a,_fresh_hours_dec
4466  0458 97            	ld	xl,a
4467  0459 a610          	ld	a,#16
4468  045b 42            	mul	x,a
4469  045c 9f            	ld	a,xl
4470  045d bb13          	add	a,_fresh_hours
4471  045f b713          	ld	_fresh_hours,a
4472                     ; 6 	fresh_min = fresh_min + (fresh_min_dec<<4);
4474  0461 b612          	ld	a,_fresh_min_dec
4475  0463 97            	ld	xl,a
4476  0464 a610          	ld	a,#16
4477  0466 42            	mul	x,a
4478  0467 9f            	ld	a,xl
4479  0468 bb11          	add	a,_fresh_min
4480  046a b711          	ld	_fresh_min,a
4481                     ; 7 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
4483  046c b610          	ld	a,_fresh_sec_dec
4484  046e 97            	ld	xl,a
4485  046f a610          	ld	a,#16
4486  0471 42            	mul	x,a
4487  0472 9f            	ld	a,xl
4488  0473 bb0f          	add	a,_fresh_sec
4489  0475 b70f          	ld	_fresh_sec,a
4490                     ; 8 	timers_int_off();
4492  0477 adcb          	call	_timers_int_off
4494                     ; 9 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
4496  0479 4b01          	push	#1
4497  047b ae0013        	ldw	x,#_fresh_hours
4498  047e 89            	pushw	x
4499  047f aed002        	ldw	x,#53250
4500  0482 cd013e        	call	_i2c_wr_reg
4502  0485 5b03          	addw	sp,#3
4503                     ; 10 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
4505  0487 4b01          	push	#1
4506  0489 ae0011        	ldw	x,#_fresh_min
4507  048c 89            	pushw	x
4508  048d aed001        	ldw	x,#53249
4509  0490 cd013e        	call	_i2c_wr_reg
4511  0493 5b03          	addw	sp,#3
4512                     ; 11 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
4514  0495 4b01          	push	#1
4515  0497 ae000f        	ldw	x,#_fresh_sec
4516  049a 89            	pushw	x
4517  049b aed000        	ldw	x,#53248
4518  049e cd013e        	call	_i2c_wr_reg
4520  04a1 5b03          	addw	sp,#3
4521                     ; 12 	timers_int_on();
4523  04a3 ada8          	call	_timers_int_on
4525                     ; 13 }
4528  04a5 81            	ret
4580                     ; 15 uint8_t kostil_k155 (uint8_t byte)
4580                     ; 16 {
4581                     	switch	.text
4582  04a6               _kostil_k155:
4584  04a6 88            	push	a
4585  04a7 89            	pushw	x
4586       00000002      OFST:	set	2
4589                     ; 17 	uint8_t tmp = (byte<<1) & 0b00001100;
4591  04a8 48            	sll	a
4592  04a9 a40c          	and	a,#12
4593  04ab 6b01          	ld	(OFST-1,sp),a
4594                     ; 18 	uint8_t tmp2 = (byte>>2) & 0b00000010;
4596  04ad 7b03          	ld	a,(OFST+1,sp)
4597  04af 44            	srl	a
4598  04b0 44            	srl	a
4599  04b1 a402          	and	a,#2
4600  04b3 6b02          	ld	(OFST+0,sp),a
4601                     ; 19 	byte &= 1;
4603  04b5 7b03          	ld	a,(OFST+1,sp)
4604  04b7 a401          	and	a,#1
4605  04b9 6b03          	ld	(OFST+1,sp),a
4606                     ; 20 	byte |= tmp | tmp2;
4608  04bb 7b01          	ld	a,(OFST-1,sp)
4609  04bd 1a02          	or	a,(OFST+0,sp)
4610  04bf 1a03          	or	a,(OFST+1,sp)
4611  04c1 6b03          	ld	(OFST+1,sp),a
4612                     ; 21 	return byte;
4614  04c3 7b03          	ld	a,(OFST+1,sp)
4617  04c5 5b03          	addw	sp,#3
4618  04c7 81            	ret
4659                     ; 1 void spi_setup(void)
4659                     ; 2  {
4660                     	switch	.text
4661  04c8               _spi_setup:
4665                     ; 3     SPI_CR1= 0b01110100;//0x7C;       //this
4667  04c8 35745200      	mov	_SPI_CR1,#116
4668                     ; 5  }
4671  04cc 81            	ret
4707                     ; 8 void spi_send(uint8_t msg)
4707                     ; 9 {
4708                     	switch	.text
4709  04cd               _spi_send:
4711  04cd 88            	push	a
4712       00000000      OFST:	set	0
4715  04ce               L3272:
4716                     ; 11 	while((SPI_SR & SPI_SR_BSY) != 0)
4718  04ce c65203        	ld	a,_SPI_SR
4719  04d1 a580          	bcp	a,#128
4720  04d3 26f9          	jrne	L3272
4721                     ; 14 	SPI_DR = msg;
4723  04d5 7b01          	ld	a,(OFST+1,sp)
4724  04d7 c75204        	ld	_SPI_DR,a
4725                     ; 15 }
4728  04da 84            	pop	a
4729  04db 81            	ret
4771                     ; 4 void UART_Resieved (void)
4771                     ; 5 {
4772                     	switch	.text
4773  04dc               _UART_Resieved:
4777                     ; 6 	uart_routine(UART1_DR);
4779  04dc c65231        	ld	a,_UART1_DR
4780  04df cd002a        	call	_uart_routine
4782                     ; 7 }
4785  04e2 81            	ret
4810                     ; 9 void SPI_Transmitted(void)
4810                     ; 10 {
4811                     	switch	.text
4812  04e3               _SPI_Transmitted:
4816                     ; 11 	spi_send(temp3);
4818  04e3 b605          	ld	a,_temp3
4819  04e5 ade6          	call	_spi_send
4821                     ; 12 }
4824  04e7 81            	ret
4847                     ; 14 void I2C_Event(void)
4847                     ; 15 {
4848                     	switch	.text
4849  04e8               _I2C_Event:
4853                     ; 17 }
4856  04e8 81            	ret
4882                     ; 19 void Keys_switched(void)
4882                     ; 20 {
4883                     	switch	.text
4884  04e9               _Keys_switched:
4888                     ; 21 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
4890  04e9 c650a0        	ld	a,_EXTI_CR1
4891  04ec 43            	cpl	a
4892  04ed a430          	and	a,#48
4893  04ef c750a0        	ld	_EXTI_CR1,a
4894                     ; 22 	PC_CR2 = 0;
4896  04f2 725f500e      	clr	_PC_CR2
4897                     ; 23 	timer2_start(0xff);	
4899  04f6 ae00ff        	ldw	x,#255
4900  04f9 cd02e9        	call	_timer2_start
4902                     ; 24 }
4905  04fc 81            	ret
4940                     ; 26 void time_refresh (void)
4940                     ; 27 {
4941                     	switch	.text
4942  04fd               _time_refresh:
4946                     ; 29 	timers_int_off();
4948  04fd cd0444        	call	_timers_int_off
4950                     ; 30 	i2c_rd_reg(0xD0, 0, &fresh_sec, 1); 	
4952  0500 4b01          	push	#1
4953  0502 ae000f        	ldw	x,#_fresh_sec
4954  0505 89            	pushw	x
4955  0506 aed000        	ldw	x,#53248
4956  0509 cd01a1        	call	_i2c_rd_reg
4958  050c 5b03          	addw	sp,#3
4959                     ; 31 	i2c_rd_reg(0xD0, 1, &fresh_min, 1);
4961  050e 4b01          	push	#1
4962  0510 ae0011        	ldw	x,#_fresh_min
4963  0513 89            	pushw	x
4964  0514 aed001        	ldw	x,#53249
4965  0517 cd01a1        	call	_i2c_rd_reg
4967  051a 5b03          	addw	sp,#3
4968                     ; 32 	i2c_rd_reg(0xD0, 2, &fresh_hours, 1);
4970  051c 4b01          	push	#1
4971  051e ae0013        	ldw	x,#_fresh_hours
4972  0521 89            	pushw	x
4973  0522 aed002        	ldw	x,#53250
4974  0525 cd01a1        	call	_i2c_rd_reg
4976  0528 5b03          	addw	sp,#3
4977                     ; 33 	timers_int_on();
4979  052a cd044d        	call	_timers_int_on
4981                     ; 35 	seconds_tens = (fresh_sec & 0xf0)>>4;
4983  052d b60f          	ld	a,_fresh_sec
4984  052f a4f0          	and	a,#240
4985  0531 4e            	swap	a
4986  0532 a40f          	and	a,#15
4987  0534 b70a          	ld	_seconds_tens,a
4988                     ; 36 	minutes_tens = (fresh_min & 0xf0)>>4;
4990  0536 b611          	ld	a,_fresh_min
4991  0538 a4f0          	and	a,#240
4992  053a 4e            	swap	a
4993  053b a40f          	and	a,#15
4994  053d b709          	ld	_minutes_tens,a
4995                     ; 37 	hours_tens = (fresh_hours & 0xf0)>>4;
4997  053f b613          	ld	a,_fresh_hours
4998  0541 a4f0          	and	a,#240
4999  0543 4e            	swap	a
5000  0544 a40f          	and	a,#15
5001  0546 b708          	ld	_hours_tens,a
5002                     ; 39 	seconds = fresh_sec & 0x0f;
5004  0548 b60f          	ld	a,_fresh_sec
5005  054a a40f          	and	a,#15
5006  054c b70b          	ld	_seconds,a
5007                     ; 40 	minutes = fresh_min & 0x0f;
5009  054e b611          	ld	a,_fresh_min
5010  0550 a40f          	and	a,#15
5011  0552 b70c          	ld	_minutes,a
5012                     ; 41 	hours = fresh_hours & 0x0f;
5014  0554 b613          	ld	a,_fresh_hours
5015  0556 a40f          	and	a,#15
5016  0558 b70d          	ld	_hours,a
5017                     ; 42 }
5020  055a 81            	ret
5088                     ; 21 int main( void )
5088                     ; 22 {
5089                     	switch	.text
5090  055b               _main:
5094                     ; 24 		CLK_CKDIVR=0;                //	no dividers
5096  055b 725f50c6      	clr	_CLK_CKDIVR
5097                     ; 26 		for (i = 0; i < 0xFFFF; i++);
5099  055f 5f            	clrw	x
5100  0560 bf07          	ldw	_i,x
5101  0562               L3203:
5105  0562 be07          	ldw	x,_i
5106  0564 1c0001        	addw	x,#1
5107  0567 bf07          	ldw	_i,x
5110  0569 be07          	ldw	x,_i
5111  056b a3ffff        	cpw	x,#65535
5112  056e 25f2          	jrult	L3203
5113                     ; 27 		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //clocking for TIM1, UART1, SPI i I2C
5115  0570 35ff50c7      	mov	_CLK_PCKENR1,#255
5116                     ; 30     PA_DDR=(1<<3) | (1<<2); //0b000001000; //output for register's latch, input for RTC 1 Hz pulse
5118  0574 350c5002      	mov	_PA_DDR,#12
5119                     ; 31     PA_CR1= 0xff;        //	pull-up on inputs, push-pull on outputs
5121  0578 35ff5003      	mov	_PA_CR1,#255
5122                     ; 32     PA_ODR |= (1<<3);
5124  057c 72165000      	bset	_PA_ODR,#3
5125                     ; 33 		PA_CR2 |=(1<<3);        //	interrupt on PA1 for 1hz
5127  0580 72165004      	bset	_PA_CR2,#3
5128                     ; 35     PC_DDR=0x60; //0b01100000; // buttons pins as input
5130  0584 3560500c      	mov	_PC_DDR,#96
5131                     ; 36     PC_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5133  0588 35ff500d      	mov	_PC_CR1,#255
5134                     ; 37     PC_CR2 |= (1<<4) | (1<<3);        //	interrapts for buttons
5136  058c c6500e        	ld	a,_PC_CR2
5137  058f aa18          	or	a,#24
5138  0591 c7500e        	ld	_PC_CR2,a
5139                     ; 39 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM
5141  0594 35a85011      	mov	_PD_DDR,#168
5142                     ; 40     PD_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5144  0598 35ff5012      	mov	_PD_CR1,#255
5145                     ; 41     PD_ODR = (1 << 3);
5147  059c 3508500f      	mov	_PD_ODR,#8
5148                     ; 45     spi_setup();
5150  05a0 cd04c8        	call	_spi_setup
5152                     ; 48 		uart_setup();
5154  05a3 cd0000        	call	_uart_setup
5156                     ; 49 		uart_send('h');
5158  05a6 a668          	ld	a,#104
5159  05a8 cd0019        	call	_uart_send
5161                     ; 52     timer1_setup( 65500,0xffff);//	freq in hz and top value
5163  05ab aeffff        	ldw	x,#65535
5164  05ae 89            	pushw	x
5165  05af aeffdc        	ldw	x,#65500
5166  05b2 cd03c8        	call	_timer1_setup
5168  05b5 85            	popw	x
5169                     ; 53 		timer2_setup();
5171  05b6 cd0433        	call	_timer2_setup
5173                     ; 54 		timer1_start();
5175  05b9 cd02e4        	call	_timer1_start
5177                     ; 55 		timer2_start(TIM2_TOP);
5179  05bc ae3e80        	ldw	x,#16000
5180  05bf cd02e9        	call	_timer2_start
5182                     ; 59 		i2c_master_init(16000000, 50000);
5184  05c2 aec350        	ldw	x,#50000
5185  05c5 89            	pushw	x
5186  05c6 ae0000        	ldw	x,#0
5187  05c9 89            	pushw	x
5188  05ca ae2400        	ldw	x,#9216
5189  05cd 89            	pushw	x
5190  05ce ae00f4        	ldw	x,#244
5191  05d1 89            	pushw	x
5192  05d2 cd00bc        	call	_i2c_master_init
5194  05d5 5b08          	addw	sp,#8
5195                     ; 62 		timers_int_off();
5197  05d7 cd0444        	call	_timers_int_off
5199                     ; 64 		i2c_rd_reg(ds_address, 7, &temp, 1);
5201  05da 4b01          	push	#1
5202  05dc ae0002        	ldw	x,#_temp
5203  05df 89            	pushw	x
5204  05e0 aed007        	ldw	x,#53255
5205  05e3 cd01a1        	call	_i2c_rd_reg
5207  05e6 5b03          	addw	sp,#3
5208                     ; 65 	if (temp != 0b10010000)	// if OUT and SWQ == 0
5210  05e8 b602          	ld	a,_temp
5211  05ea a190          	cp	a,#144
5212  05ec 270e          	jreq	L1303
5213                     ; 67 			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//	setup RTC for 1Hz output
5215  05ee 4b01          	push	#1
5216  05f0 ae000a        	ldw	x,#_ds_cr
5217  05f3 89            	pushw	x
5218  05f4 aed007        	ldw	x,#53255
5219  05f7 cd013e        	call	_i2c_wr_reg
5221  05fa 5b03          	addw	sp,#3
5222  05fc               L1303:
5223                     ; 70 		i2c_rd_reg(ds_address, 0, &temp, 1);
5225  05fc 4b01          	push	#1
5226  05fe ae0002        	ldw	x,#_temp
5227  0601 89            	pushw	x
5228  0602 aed000        	ldw	x,#53248
5229  0605 cd01a1        	call	_i2c_rd_reg
5231  0608 5b03          	addw	sp,#3
5232                     ; 73 	if((temp & 0x80) == 0x80)
5234  060a b602          	ld	a,_temp
5235  060c a480          	and	a,#128
5236  060e a180          	cp	a,#128
5237  0610 2610          	jrne	L3303
5238                     ; 75 		temp = 0;
5240  0612 3f02          	clr	_temp
5241                     ; 76 		i2c_wr_reg(ds_address, 0, &temp, 1);
5243  0614 4b01          	push	#1
5244  0616 ae0002        	ldw	x,#_temp
5245  0619 89            	pushw	x
5246  061a aed000        	ldw	x,#53248
5247  061d cd013e        	call	_i2c_wr_reg
5249  0620 5b03          	addw	sp,#3
5250  0622               L3303:
5251                     ; 78 		timers_int_on();
5253  0622 cd044d        	call	_timers_int_on
5255                     ; 80 		_asm ("RIM");  //on interupts
5258  0625 9a            RIM
5260  0626               L5303:
5262  0626 20fe          	jra	L5303
5275                     	xdef	_main
5276                     	xdef	_Keys_switched
5277                     	xdef	_I2C_Event
5278                     	xdef	_SPI_Transmitted
5279                     	xdef	_UART_Resieved
5280                     	xdef	_spi_setup
5281                     	xdef	_timer2_setup
5282                     	xdef	_timer1_setup
5283                     	xdef	_Timer1_Compare_1
5284                     	xdef	_Timer2_Overflow
5285                     	xdef	_timer2_start
5286                     	xdef	_timer1_start
5287                     	xdef	_kostil_k155
5288                     	xdef	_time_refresh
5289                     	xdef	_timers_int_on
5290                     	xdef	_timers_int_off
5291                     	xdef	_spi_send
5292                     	xdef	_i2c_rd_reg
5293                     	xdef	_i2c_wr_reg
5294                     	xdef	_i2c_master_init
5295                     	xdef	_Key_interrupt
5296                     	xdef	_uart_routine
5297                     	xdef	_uart_send
5298                     	xdef	_uart_setup
5299                     	xdef	_time_write
5300                     	switch	.ubsct
5301  0000               _i2c_flags:
5302  0000 00            	ds.b	1
5303                     	xdef	_i2c_flags
5304  0001               _flags:
5305  0001 00            	ds.b	1
5306                     	xdef	_flags
5307                     	xdef	_ds_cr
5308                     	xdef	_schetchik2
5309                     	xdef	_i
5310                     	xdef	_schetchik
5311                     	xdef	_temp3
5312                     	xdef	_temp2
5313  0002               _temp:
5314  0002 00            	ds.b	1
5315                     	xdef	_temp
5316  0003               _pins:
5317  0003 00            	ds.b	1
5318                     	xdef	_pins
5319  0004               _fresh_data_pointer:
5320  0004 0000          	ds.b	2
5321                     	xdef	_fresh_data_pointer
5322  0006               _data_pointer:
5323  0006 0000          	ds.b	2
5324                     	xdef	_data_pointer
5325                     	xdef	_time_pointer
5326  0008               _hours_tens:
5327  0008 00            	ds.b	1
5328                     	xdef	_hours_tens
5329  0009               _minutes_tens:
5330  0009 00            	ds.b	1
5331                     	xdef	_minutes_tens
5332  000a               _seconds_tens:
5333  000a 00            	ds.b	1
5334                     	xdef	_seconds_tens
5335  000b               _seconds:
5336  000b 00            	ds.b	1
5337                     	xdef	_seconds
5338  000c               _minutes:
5339  000c 00            	ds.b	1
5340                     	xdef	_minutes
5341  000d               _hours:
5342  000d 00            	ds.b	1
5343                     	xdef	_hours
5344  000e               _timeset:
5345  000e 00            	ds.b	1
5346                     	xdef	_timeset
5347  000f               _fresh_sec:
5348  000f 00            	ds.b	1
5349                     	xdef	_fresh_sec
5350  0010               _fresh_sec_dec:
5351  0010 00            	ds.b	1
5352                     	xdef	_fresh_sec_dec
5353  0011               _fresh_min:
5354  0011 00            	ds.b	1
5355                     	xdef	_fresh_min
5356  0012               _fresh_min_dec:
5357  0012 00            	ds.b	1
5358                     	xdef	_fresh_min_dec
5359  0013               _fresh_hours:
5360  0013 00            	ds.b	1
5361                     	xdef	_fresh_hours
5362  0014               _fresh_hours_dec:
5363  0014 00            	ds.b	1
5364                     	xdef	_fresh_hours_dec
5365  0015               _lamp_number_data:
5366  0015 00            	ds.b	1
5367                     	xdef	_lamp_number_data
5368  0016               _k155_data:
5369  0016 00            	ds.b	1
5370                     	xdef	_k155_data
5371                     	xdef	_dots
5372                     	xdef	_lamp_number
5373                     	xref.b	c_lreg
5374                     	xref.b	c_x
5394                     	xref	c_lrsh
5395                     	xref	c_ldiv
5396                     	xref	c_uitolx
5397                     	xref	c_ludv
5398                     	xref	c_rtol
5399                     	xref	c_ltor
5400                     	end
