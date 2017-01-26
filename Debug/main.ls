   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2184                     	bsct
2185  0000               _lamp_number:
2186  0000 00            	dc.b	0
2187  0001               _dots:
2188  0001 80            	dc.b	128
2189  0002               _time_pointer:
2190  0002 000b          	dc.w	_seconds
2191  0004               _temp2:
2192  0004 aa            	dc.b	170
2193  0005               _temp3:
2194  0005 33            	dc.b	51
2195  0006               _ds_cr:
2196  0006 90            	dc.b	144
2630                     ; 2  void uart_setup(void)
2630                     ; 3  {
2632                     	switch	.text
2633  0000               _uart_setup:
2637                     ; 4 		UART1_BRR1=0x68;     //9600 bod
2639  0000 35685232      	mov	_UART1_BRR1,#104
2640                     ; 5     UART1_BRR2=0x03;
2642  0004 35035233      	mov	_UART1_BRR2,#3
2643                     ; 6     UART1_CR2 |= UART1_CR2_REN; //reseiving
2645  0008 72145235      	bset	_UART1_CR2,#2
2646                     ; 7     UART1_CR2 |= UART1_CR2_TEN; //transmiting 
2648  000c 72165235      	bset	_UART1_CR2,#3
2649                     ; 8     UART1_CR2 |= UART1_CR2_RIEN; //reseive int
2651  0010 721a5235      	bset	_UART1_CR2,#5
2652                     ; 9 		UART1_SR = 0;
2654  0014 725f5230      	clr	_UART1_SR
2655                     ; 10  }
2658  0018 81            	ret
2695                     ; 12 void uart_send(uint8_t msg)
2695                     ; 13  {
2696                     	switch	.text
2697  0019               _uart_send:
2699  0019 88            	push	a
2700       00000000      OFST:	set	0
2703                     ; 14 	 temp =msg;
2705  001a b702          	ld	_temp,a
2707  001c               L3471:
2708                     ; 15 	 while((UART1_SR & 0x80) == 0x00);
2710  001c c65230        	ld	a,_UART1_SR
2711  001f a580          	bcp	a,#128
2712  0021 27f9          	jreq	L3471
2713                     ; 16 	 UART1_DR = msg;
2715  0023 7b01          	ld	a,(OFST+1,sp)
2716  0025 c75231        	ld	_UART1_DR,a
2717                     ; 17  }
2720  0028 84            	pop	a
2721  0029 81            	ret
2766                     ; 18  void uart_routine(uint8_t data)
2766                     ; 19  {
2767                     	switch	.text
2768  002a               _uart_routine:
2770  002a 88            	push	a
2771       00000000      OFST:	set	0
2774                     ; 21 	 if (timeset != 0 && timeset <= 5)
2776  002b 3d0e          	tnz	_timeset
2777  002d 2719          	jreq	L5671
2779  002f b60e          	ld	a,_timeset
2780  0031 a106          	cp	a,#6
2781  0033 2413          	jruge	L5671
2782                     ; 23 		* fresh_data_pointer-- = data-0x30;
2784  0035 7b01          	ld	a,(OFST+1,sp)
2785  0037 a030          	sub	a,#48
2786  0039 be04          	ldw	x,_fresh_data_pointer
2787  003b 1d0001        	subw	x,#1
2788  003e bf04          	ldw	_fresh_data_pointer,x
2789  0040 1c0001        	addw	x,#1
2790  0043 f7            	ld	(x),a
2791                     ; 24 		 timeset++;
2793  0044 3c0e          	inc	_timeset
2794                     ; 25 		 return ;
2797  0046 84            	pop	a
2798  0047 81            	ret
2799  0048               L5671:
2800                     ; 27 	 if (timeset == 6)
2802  0048 b60e          	ld	a,_timeset
2803  004a a106          	cp	a,#6
2804  004c 2616          	jrne	L7671
2805                     ; 29 		 *fresh_data_pointer = data-0x30;
2807  004e 7b01          	ld	a,(OFST+1,sp)
2808  0050 a030          	sub	a,#48
2809  0052 92c704        	ld	[_fresh_data_pointer.w],a
2810                     ; 30 		 timeset = 0;
2812  0055 3f0e          	clr	_timeset
2813                     ; 31 		 time_write();
2815  0057 cd03f8        	call	_time_write
2817                     ; 32 		 uart_send('O');
2819  005a a64f          	ld	a,#79
2820  005c adbb          	call	_uart_send
2822                     ; 33 		 uart_send('K');
2824  005e a64b          	ld	a,#75
2825  0060 adb7          	call	_uart_send
2827                     ; 34 		 return;
2830  0062 84            	pop	a
2831  0063 81            	ret
2832  0064               L7671:
2833                     ; 37 	 if (data == 's')
2835  0064 7b01          	ld	a,(OFST+1,sp)
2836  0066 a173          	cp	a,#115
2837  0068 260b          	jrne	L1771
2838                     ; 39 			timeset = 1;
2840  006a 3501000e      	mov	_timeset,#1
2841                     ; 40 			fresh_data_pointer = &fresh_hours_dec;
2843  006e ae0014        	ldw	x,#_fresh_hours_dec
2844  0071 bf04          	ldw	_fresh_data_pointer,x
2845                     ; 41 			return;
2848  0073 84            	pop	a
2849  0074 81            	ret
2850  0075               L1771:
2851                     ; 45 		if (data == 't')
2853  0075 7b01          	ld	a,(OFST+1,sp)
2854  0077 a174          	cp	a,#116
2855  0079 2634          	jrne	L3771
2856                     ; 47 			uart_send(hours_tens+0x30);
2858  007b b608          	ld	a,_hours_tens
2859  007d ab30          	add	a,#48
2860  007f ad98          	call	_uart_send
2862                     ; 48 			uart_send(hours+0x30);
2864  0081 b60d          	ld	a,_hours
2865  0083 ab30          	add	a,#48
2866  0085 ad92          	call	_uart_send
2868                     ; 49 			uart_send(':');	
2870  0087 a63a          	ld	a,#58
2871  0089 ad8e          	call	_uart_send
2873                     ; 50 			uart_send(minutes_tens+0x30);
2875  008b b609          	ld	a,_minutes_tens
2876  008d ab30          	add	a,#48
2877  008f ad88          	call	_uart_send
2879                     ; 51 			uart_send(minutes+0x30);
2881  0091 b60c          	ld	a,_minutes
2882  0093 ab30          	add	a,#48
2883  0095 ad82          	call	_uart_send
2885                     ; 52 			uart_send(':'); 
2887  0097 a63a          	ld	a,#58
2888  0099 cd0019        	call	_uart_send
2890                     ; 53 			uart_send(seconds_tens+0x30);
2892  009c b60a          	ld	a,_seconds_tens
2893  009e ab30          	add	a,#48
2894  00a0 cd0019        	call	_uart_send
2896                     ; 54 			uart_send(seconds+0x30);
2898  00a3 b60b          	ld	a,_seconds
2899  00a5 ab30          	add	a,#48
2900  00a7 cd0019        	call	_uart_send
2902                     ; 55 			uart_send(0x0A);
2904  00aa a60a          	ld	a,#10
2905  00ac cd0019        	call	_uart_send
2907  00af               L3771:
2908                     ; 57 	}
2911  00af 84            	pop	a
2912  00b0 81            	ret
2954                     ; 1  void Key_interrupt (void)
2954                     ; 2 {
2955                     	switch	.text
2956  00b1               _Key_interrupt:
2960                     ; 4   pins = PC_IDR;
2962  00b1 55500b0003    	mov	_pins,_PC_IDR
2963                     ; 5 }
2966  00b6 81            	ret
3045                     ; 7 void i2c_master_init(unsigned long f_master_hz, unsigned long f_i2c_hz){
3046                     	switch	.text
3047  00b7               _i2c_master_init:
3049  00b7 5208          	subw	sp,#8
3050       00000008      OFST:	set	8
3053                     ; 10   PB_DDR = (0<<4);//PB_DDR_DDR4);
3055  00b9 725f5007      	clr	_PB_DDR
3056                     ; 11 	PB_DDR = (0<<5);//PB_DDR_DDR5);
3058  00bd 725f5007      	clr	_PB_DDR
3059                     ; 12 	PB_ODR = (1<<5);//PB_ODR_ODR5);  //SDA
3061  00c1 35205005      	mov	_PB_ODR,#32
3062                     ; 13   PB_ODR = (1<<4);//PB_ODR_ODR4);  //SCL
3064  00c5 35105005      	mov	_PB_ODR,#16
3065                     ; 15   PB_CR1 = (0<<4);//PB_CR1_C14);
3067  00c9 725f5008      	clr	_PB_CR1
3068                     ; 16   PB_CR1 = (0<<5);//PB_CR1_C15);
3070  00cd 725f5008      	clr	_PB_CR1
3071                     ; 18   PB_CR2 = (0<<4);//PB_CR1_C24);
3073  00d1 725f5009      	clr	_PB_CR2
3074                     ; 19   PB_CR2 = (0<<5);//PB_CR1_C25);
3076  00d5 725f5009      	clr	_PB_CR2
3077                     ; 22   I2C_FREQR = 16;
3079  00d9 35105212      	mov	_I2C_FREQR,#16
3080                     ; 24   I2C_CR1 |=~I2C_CR1_PE;
3082  00dd c65210        	ld	a,_I2C_CR1
3083  00e0 aafe          	or	a,#254
3084  00e2 c75210        	ld	_I2C_CR1,a
3085                     ; 27   I2C_CCRH |=~I2C_CCRH_FS;
3087  00e5 c6521c        	ld	a,_I2C_CCRH
3088  00e8 aa7f          	or	a,#127
3089  00ea c7521c        	ld	_I2C_CCRH,a
3090                     ; 29   ccr = f_master_hz/(2*f_i2c_hz);
3092  00ed 96            	ldw	x,sp
3093  00ee 1c000f        	addw	x,#OFST+7
3094  00f1 cd0000        	call	c_ltor
3096  00f4 3803          	sll	c_lreg+3
3097  00f6 3902          	rlc	c_lreg+2
3098  00f8 3901          	rlc	c_lreg+1
3099  00fa 3900          	rlc	c_lreg
3100  00fc 96            	ldw	x,sp
3101  00fd 1c0001        	addw	x,#OFST-7
3102  0100 cd0000        	call	c_rtol
3104  0103 96            	ldw	x,sp
3105  0104 1c000b        	addw	x,#OFST+3
3106  0107 cd0000        	call	c_ltor
3108  010a 96            	ldw	x,sp
3109  010b 1c0001        	addw	x,#OFST-7
3110  010e cd0000        	call	c_ludv
3112  0111 96            	ldw	x,sp
3113  0112 1c0005        	addw	x,#OFST-3
3114  0115 cd0000        	call	c_rtol
3116                     ; 33   I2C_TRISER = 12+1;
3118  0118 350d521d      	mov	_I2C_TRISER,#13
3119                     ; 34   I2C_CCRL = ccr & 0xFF;
3121  011c 7b08          	ld	a,(OFST+0,sp)
3122  011e a4ff          	and	a,#255
3123  0120 c7521b        	ld	_I2C_CCRL,a
3124                     ; 35   I2C_CCRH = ((ccr >> 8) & 0x0F);
3126  0123 7b07          	ld	a,(OFST-1,sp)
3127  0125 a40f          	and	a,#15
3128  0127 c7521c        	ld	_I2C_CCRH,a
3129                     ; 37   I2C_CR1 |=I2C_CR1_PE;
3131  012a 72105210      	bset	_I2C_CR1,#0
3132                     ; 39   I2C_CR2 |=I2C_CR2_ACK;
3134  012e 72145211      	bset	_I2C_CR2,#2
3135                     ; 40 }
3138  0132 5b08          	addw	sp,#8
3139  0134 81            	ret
3233                     ; 46 t_i2c_status i2c_wr_reg(unsigned char address, unsigned char reg_addr,
3233                     ; 47                               char * data, unsigned char length)
3233                     ; 48 {                                  
3234                     	switch	.text
3235  0135               _i2c_wr_reg:
3237  0135 89            	pushw	x
3238       00000000      OFST:	set	0
3241  0136               L5112:
3242                     ; 52   while((I2C_SR3 & I2C_SR3_BUSY) !=0);   
3244  0136 c65219        	ld	a,_I2C_SR3
3245  0139 a502          	bcp	a,#2
3246  013b 26f9          	jrne	L5112
3247                     ; 54   I2C_CR2 |= I2C_CR2_START;
3249  013d 72105211      	bset	_I2C_CR2,#0
3251  0141               L3212:
3252                     ; 57   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3254  0141 c65217        	ld	a,_I2C_SR1
3255  0144 a501          	bcp	a,#1
3256  0146 27f9          	jreq	L3212
3257                     ; 60   I2C_DR = address & 0xFE;
3259  0148 7b01          	ld	a,(OFST+1,sp)
3260  014a a4fe          	and	a,#254
3261  014c c75216        	ld	_I2C_DR,a
3263  014f               L3312:
3264                     ; 63 	while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3266  014f c65217        	ld	a,_I2C_SR1
3267  0152 a502          	bcp	a,#2
3268  0154 27f9          	jreq	L3312
3269                     ; 65   I2C_SR3;
3271  0156 c65219        	ld	a,_I2C_SR3
3273  0159               L1412:
3274                     ; 70   while((I2C_SR1 & I2C_SR1_TXE) ==0);
3276  0159 c65217        	ld	a,_I2C_SR1
3277  015c a580          	bcp	a,#128
3278  015e 27f9          	jreq	L1412
3279                     ; 72   I2C_DR = reg_addr;
3281  0160 7b02          	ld	a,(OFST+2,sp)
3282  0162 c75216        	ld	_I2C_DR,a
3284  0165 2015          	jra	L1512
3285  0167               L7512:
3286                     ; 78     while((I2C_SR1 & I2C_SR1_TXE) == 0);
3288  0167 c65217        	ld	a,_I2C_SR1
3289  016a a580          	bcp	a,#128
3290  016c 27f9          	jreq	L7512
3291                     ; 80     I2C_DR = *data++;
3293  016e 1e05          	ldw	x,(OFST+5,sp)
3294  0170 1c0001        	addw	x,#1
3295  0173 1f05          	ldw	(OFST+5,sp),x
3296  0175 1d0001        	subw	x,#1
3297  0178 f6            	ld	a,(x)
3298  0179 c75216        	ld	_I2C_DR,a
3299  017c               L1512:
3300                     ; 75   while(length--){
3302  017c 7b07          	ld	a,(OFST+7,sp)
3303  017e 0a07          	dec	(OFST+7,sp)
3304  0180 4d            	tnz	a
3305  0181 26e4          	jrne	L7512
3307  0183               L5612:
3308                     ; 85   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3310  0183 c65217        	ld	a,_I2C_SR1
3311  0186 a584          	bcp	a,#132
3312  0188 27f9          	jreq	L5612
3313                     ; 87   I2C_CR2 |= I2C_CR2_STOP;
3315  018a 72125211      	bset	_I2C_CR2,#1
3317  018e               L3712:
3318                     ; 90   while((I2C_CR2 & I2C_CR2_STOP) == 0); 
3320  018e c65211        	ld	a,_I2C_CR2
3321  0191 a502          	bcp	a,#2
3322  0193 27f9          	jreq	L3712
3323                     ; 91   return I2C_SUCCESS;
3325  0195 4f            	clr	a
3328  0196 85            	popw	x
3329  0197 81            	ret
3399                     ; 98 t_i2c_status i2c_rd_reg(unsigned char address, unsigned char reg_addr,
3399                     ; 99                               char * data, unsigned char length)
3399                     ; 100 {
3400                     	switch	.text
3401  0198               _i2c_rd_reg:
3403  0198 89            	pushw	x
3404       00000000      OFST:	set	0
3407  0199               L3322:
3408                     ; 106   while((I2C_SR3 & I2C_SR3_BUSY) != 0);   
3410  0199 c65219        	ld	a,_I2C_SR3
3411  019c a502          	bcp	a,#2
3412  019e 26f9          	jrne	L3322
3413                     ; 108   I2C_CR2 |= I2C_CR2_ACK;
3415  01a0 72145211      	bset	_I2C_CR2,#2
3416                     ; 111   I2C_CR2 |= I2C_CR2_START;
3418  01a4 72105211      	bset	_I2C_CR2,#0
3420  01a8               L1422:
3421                     ; 114   while((I2C_SR1 & I2C_SR1_SB) == 0);  
3423  01a8 c65217        	ld	a,_I2C_SR1
3424  01ab a501          	bcp	a,#1
3425  01ad 27f9          	jreq	L1422
3426                     ; 116   I2C_DR = address & 0xFE;
3428  01af 7b01          	ld	a,(OFST+1,sp)
3429  01b1 a4fe          	and	a,#254
3430  01b3 c75216        	ld	_I2C_DR,a
3432  01b6               L1522:
3433                     ; 119   while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3435  01b6 c65217        	ld	a,_I2C_SR1
3436  01b9 a502          	bcp	a,#2
3437  01bb 27f9          	jreq	L1522
3438                     ; 121   temp = I2C_SR3;
3440  01bd 5552190002    	mov	_temp,_I2C_SR3
3442  01c2               L1622:
3443                     ; 125   while((I2C_SR1 & I2C_SR1) == 0); 
3445  01c2 c65217        	ld	a,_I2C_SR1
3446  01c5 5f            	clrw	x
3447  01c6 97            	ld	xl,a
3448  01c7 a30000        	cpw	x,#0
3449  01ca 27f6          	jreq	L1622
3450                     ; 127   I2C_DR = reg_addr;
3452  01cc 7b02          	ld	a,(OFST+2,sp)
3453  01ce c75216        	ld	_I2C_DR,a
3455  01d1               L1722:
3456                     ; 130   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3458  01d1 c65217        	ld	a,_I2C_SR1
3459  01d4 a584          	bcp	a,#132
3460  01d6 27f9          	jreq	L1722
3461                     ; 132   I2C_CR2 |= I2C_CR2_START;
3463  01d8 72105211      	bset	_I2C_CR2,#0
3465  01dc               L7722:
3466                     ; 135   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3468  01dc c65217        	ld	a,_I2C_SR1
3469  01df a501          	bcp	a,#1
3470  01e1 27f9          	jreq	L7722
3471                     ; 138   I2C_DR = address | 0x01;
3473  01e3 7b01          	ld	a,(OFST+1,sp)
3474  01e5 aa01          	or	a,#1
3475  01e7 c75216        	ld	_I2C_DR,a
3476                     ; 142   if(length == 1){
3478  01ea 7b07          	ld	a,(OFST+7,sp)
3479  01ec a101          	cp	a,#1
3480  01ee 2627          	jrne	L3032
3481                     ; 144     I2C_CR2 &= ~I2C_CR2_ACK;
3483  01f0 72155211      	bres	_I2C_CR2,#2
3485  01f4               L7032:
3486                     ; 147     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3488  01f4 c65217        	ld	a,_I2C_SR1
3489  01f7 a502          	bcp	a,#2
3490  01f9 27f9          	jreq	L7032
3491                     ; 149     _asm ("SIM");  //on interupts
3494  01fb 9b            SIM
3496                     ; 151     temp = I2C_SR3;
3498  01fc 5552190002    	mov	_temp,_I2C_SR3
3499                     ; 154     I2C_CR2 |= I2C_CR2_STOP;
3501  0201 72125211      	bset	_I2C_CR2,#1
3502                     ; 156     _asm ("RIM");  //on interupts;
3505  0205 9a            RIM
3508  0206               L5132:
3509                     ; 160     while((I2C_SR1 & I2C_SR1_RXNE) == 0); 
3511  0206 c65217        	ld	a,_I2C_SR1
3512  0209 a540          	bcp	a,#64
3513  020b 27f9          	jreq	L5132
3514                     ; 162     *data = I2C_DR;
3516  020d 1e05          	ldw	x,(OFST+5,sp)
3517  020f c65216        	ld	a,_I2C_DR
3518  0212 f7            	ld	(x),a
3520  0213 acc902c9      	jpf	L5042
3521  0217               L3032:
3522                     ; 165   else if(length == 2){
3524  0217 7b07          	ld	a,(OFST+7,sp)
3525  0219 a102          	cp	a,#2
3526  021b 2639          	jrne	L3232
3527                     ; 167     I2C_CR2 |= I2C_CR2_POS;
3529  021d 72165211      	bset	_I2C_CR2,#3
3531  0221               L7232:
3532                     ; 170     while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3534  0221 c65217        	ld	a,_I2C_SR1
3535  0224 a502          	bcp	a,#2
3536  0226 27f9          	jreq	L7232
3537                     ; 172     _asm ("SIM");  //on interupts;
3540  0228 9b            SIM
3542                     ; 174     temp = I2C_SR3;
3544  0229 5552190002    	mov	_temp,_I2C_SR3
3545                     ; 176     I2C_CR2 &= ~I2C_CR2_ACK;
3547  022e 72155211      	bres	_I2C_CR2,#2
3548                     ; 178     _asm ("RIM");  //on interupts;
3551  0232 9a            RIM
3554  0233               L5332:
3555                     ; 182     while((I2C_SR1 & I2C_SR1_BTF) == 0); 
3557  0233 c65217        	ld	a,_I2C_SR1
3558  0236 a504          	bcp	a,#4
3559  0238 27f9          	jreq	L5332
3560                     ; 184     _asm ("SIM");  //on interupts;
3563  023a 9b            SIM
3565                     ; 186     I2C_CR2 |= I2C_CR2_STOP;
3567  023b 72125211      	bset	_I2C_CR2,#1
3568                     ; 188     *data++ = I2C_DR;
3570  023f 1e05          	ldw	x,(OFST+5,sp)
3571  0241 1c0001        	addw	x,#1
3572  0244 1f05          	ldw	(OFST+5,sp),x
3573  0246 1d0001        	subw	x,#1
3574  0249 c65216        	ld	a,_I2C_DR
3575  024c f7            	ld	(x),a
3576                     ; 190     _asm ("RIM");  //on interupts;
3579  024d 9a            RIM
3581                     ; 191     *data = I2C_DR;
3583  024e 1e05          	ldw	x,(OFST+5,sp)
3584  0250 c65216        	ld	a,_I2C_DR
3585  0253 f7            	ld	(x),a
3587  0254 2073          	jra	L5042
3588  0256               L3232:
3589                     ; 194   else if(length > 2){
3591  0256 7b07          	ld	a,(OFST+7,sp)
3592  0258 a103          	cp	a,#3
3593  025a 256d          	jrult	L5042
3595  025c               L7432:
3596                     ; 197     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3598  025c c65217        	ld	a,_I2C_SR1
3599  025f a502          	bcp	a,#2
3600  0261 27f9          	jreq	L7432
3601                     ; 199     _asm ("SIM");  //on interupts;
3604  0263 9b            SIM
3606                     ; 202     I2C_SR3;
3608  0264 c65219        	ld	a,_I2C_SR3
3609                     ; 205     _asm ("RIM");  //on interupts;
3612  0267 9a            RIM
3615  0268 2015          	jra	L5532
3616  026a               L3632:
3617                     ; 210       while((I2C_SR1 & I2C_SR1_BTF) == 0);
3619  026a c65217        	ld	a,_I2C_SR1
3620  026d a504          	bcp	a,#4
3621  026f 27f9          	jreq	L3632
3622                     ; 212       *data++ = I2C_DR;
3624  0271 1e05          	ldw	x,(OFST+5,sp)
3625  0273 1c0001        	addw	x,#1
3626  0276 1f05          	ldw	(OFST+5,sp),x
3627  0278 1d0001        	subw	x,#1
3628  027b c65216        	ld	a,_I2C_DR
3629  027e f7            	ld	(x),a
3630  027f               L5532:
3631                     ; 207     while(length-- > 3){
3633  027f 7b07          	ld	a,(OFST+7,sp)
3634  0281 0a07          	dec	(OFST+7,sp)
3635  0283 a104          	cp	a,#4
3636  0285 24e3          	jruge	L3632
3638  0287               L1732:
3639                     ; 221     while((I2C_SR1 & I2C_SR1_BTF) == 0);
3641  0287 c65217        	ld	a,_I2C_SR1
3642  028a a504          	bcp	a,#4
3643  028c 27f9          	jreq	L1732
3644                     ; 223     I2C_CR2 &= ~I2C_CR2_ACK;
3646  028e 72155211      	bres	_I2C_CR2,#2
3647                     ; 225     _asm ("SIM");  //on interupts;
3650  0292 9b            SIM
3652                     ; 228     *data++ = I2C_DR;
3654  0293 1e05          	ldw	x,(OFST+5,sp)
3655  0295 1c0001        	addw	x,#1
3656  0298 1f05          	ldw	(OFST+5,sp),x
3657  029a 1d0001        	subw	x,#1
3658  029d c65216        	ld	a,_I2C_DR
3659  02a0 f7            	ld	(x),a
3660                     ; 230     I2C_CR2 |= I2C_CR2_STOP;
3662  02a1 72125211      	bset	_I2C_CR2,#1
3663                     ; 232     *data++ = I2C_DR;
3665  02a5 1e05          	ldw	x,(OFST+5,sp)
3666  02a7 1c0001        	addw	x,#1
3667  02aa 1f05          	ldw	(OFST+5,sp),x
3668  02ac 1d0001        	subw	x,#1
3669  02af c65216        	ld	a,_I2C_DR
3670  02b2 f7            	ld	(x),a
3671                     ; 234     _asm ("RIM");  //on interupts;
3674  02b3 9a            RIM
3677  02b4               L7732:
3678                     ; 237     while((I2C_SR1 & I2C_SR1_RXNE) == 0);
3680  02b4 c65217        	ld	a,_I2C_SR1
3681  02b7 a540          	bcp	a,#64
3682  02b9 27f9          	jreq	L7732
3683                     ; 239     *data++ = I2C_DR;
3685  02bb 1e05          	ldw	x,(OFST+5,sp)
3686  02bd 1c0001        	addw	x,#1
3687  02c0 1f05          	ldw	(OFST+5,sp),x
3688  02c2 1d0001        	subw	x,#1
3689  02c5 c65216        	ld	a,_I2C_DR
3690  02c8 f7            	ld	(x),a
3691  02c9               L5042:
3692                     ; 244   while((I2C_CR2 & I2C_CR2_STOP) == 0);
3694  02c9 c65211        	ld	a,_I2C_CR2
3695  02cc a502          	bcp	a,#2
3696  02ce 27f9          	jreq	L5042
3697                     ; 246   I2C_CR2 &= ~I2C_CR2_POS;
3699  02d0 72175211      	bres	_I2C_CR2,#3
3700                     ; 248   return I2C_SUCCESS;
3702  02d4 4f            	clr	a
3705  02d5 85            	popw	x
3706  02d6 81            	ret
3747                     ; 8 void timer1_start(void)
3747                     ; 9  {
3748                     	switch	.text
3749  02d7               _timer1_start:
3753                     ; 10    TIM1_CR1 |= TIM1_CR1_CEN; //Запускаем таймер
3755  02d7 72105250      	bset	_TIM1_CR1,#0
3756                     ; 11  }
3759  02db 81            	ret
3796                     ; 13 void timer2_start(uint16_t top_val)
3796                     ; 14 {
3797                     	switch	.text
3798  02dc               _timer2_start:
3802                     ; 15   TIM2_ARRH =top_val >>8;
3804  02dc 9e            	ld	a,xh
3805  02dd c7530f        	ld	_TIM2_ARRH,a
3806                     ; 16   TIM2_ARRL =top_val & 0xFF;
3808  02e0 9f            	ld	a,xl
3809  02e1 a4ff          	and	a,#255
3810  02e3 c75310        	ld	_TIM2_ARRL,a
3811                     ; 17   TIM2_CR1 |= TIM2_CR1_CEN;
3813  02e6 72105300      	bset	_TIM2_CR1,#0
3814                     ; 18 }
3817  02ea 81            	ret
3852                     ; 20 void Timer2_Overflow (void)
3852                     ; 21 {
3853                     	switch	.text
3854  02eb               _Timer2_Overflow:
3858                     ; 22 	TIM2_SR1 = 0;
3860  02eb 725f5304      	clr	_TIM2_SR1
3861                     ; 24 	if (lamp_number <= 3)
3863  02ef b600          	ld	a,_lamp_number
3864  02f1 a104          	cp	a,#4
3865  02f3 2415          	jruge	L5642
3866                     ; 26 			lamp_number_data = (1<<(lamp_number++));
3868  02f5 b600          	ld	a,_lamp_number
3869  02f7 97            	ld	xl,a
3870  02f8 3c00          	inc	_lamp_number
3871  02fa 9f            	ld	a,xl
3872  02fb 5f            	clrw	x
3873  02fc 97            	ld	xl,a
3874  02fd a601          	ld	a,#1
3875  02ff 5d            	tnzw	x
3876  0300 2704          	jreq	L03
3877  0302               L23:
3878  0302 48            	sll	a
3879  0303 5a            	decw	x
3880  0304 26fc          	jrne	L23
3881  0306               L03:
3882  0306 b715          	ld	_lamp_number_data,a
3884  0308 201d          	jra	L7642
3885  030a               L5642:
3886                     ; 28 		else if (lamp_number >= 4)
3888  030a b600          	ld	a,_lamp_number
3889  030c a104          	cp	a,#4
3890  030e 2517          	jrult	L7642
3891                     ; 30 			lamp_number = 1;
3893  0310 35010000      	mov	_lamp_number,#1
3894                     ; 31 			lamp_number_data = (1<<(lamp_number++));
3896  0314 b600          	ld	a,_lamp_number
3897  0316 97            	ld	xl,a
3898  0317 3c00          	inc	_lamp_number
3899  0319 9f            	ld	a,xl
3900  031a 5f            	clrw	x
3901  031b 97            	ld	xl,a
3902  031c a601          	ld	a,#1
3903  031e 5d            	tnzw	x
3904  031f 2704          	jreq	L43
3905  0321               L63:
3906  0321 48            	sll	a
3907  0322 5a            	decw	x
3908  0323 26fc          	jrne	L63
3909  0325               L43:
3910  0325 b715          	ld	_lamp_number_data,a
3911  0327               L7642:
3912                     ; 34 	switch (lamp_number)
3914  0327 b600          	ld	a,_lamp_number
3916                     ; 47 	break;
3917  0329 4d            	tnz	a
3918  032a 270b          	jreq	L5442
3919  032c 4a            	dec	a
3920  032d 270d          	jreq	L7442
3921  032f 4a            	dec	a
3922  0330 270f          	jreq	L1542
3923  0332 4a            	dec	a
3924  0333 2711          	jreq	L3542
3925  0335 2012          	jra	L5742
3926  0337               L5442:
3927                     ; 36 	case 0:
3927                     ; 37 	k155_data = hours_tens; 
3929  0337 450816        	mov	_k155_data,_hours_tens
3930                     ; 38 	break;
3932  033a 200d          	jra	L5742
3933  033c               L7442:
3934                     ; 39 	case 1:
3934                     ; 40 	k155_data = hours;
3936  033c 450d16        	mov	_k155_data,_hours
3937                     ; 41 	break;
3939  033f 2008          	jra	L5742
3940  0341               L1542:
3941                     ; 42 	case 2:
3941                     ; 43 	k155_data = minutes_tens;
3943  0341 450916        	mov	_k155_data,_minutes_tens
3944                     ; 44 	break;
3946  0344 2003          	jra	L5742
3947  0346               L3542:
3948                     ; 45 	case 3:
3948                     ; 46 	k155_data = minutes;
3950  0346 450c16        	mov	_k155_data,_minutes
3951                     ; 47 	break;
3953  0349               L5742:
3954                     ; 49 	timers_int_off();
3956  0349 cd03e6        	call	_timers_int_off
3958                     ; 50 	PA_ODR &= (0<<3);
3960  034c 725f5000      	clr	_PA_ODR
3961                     ; 52 	spi_send(k155_data);
3963  0350 b616          	ld	a,_k155_data
3964  0352 cd044d        	call	_spi_send
3966                     ; 54 	spi_send(lamp_number_data);
3968  0355 b615          	ld	a,_lamp_number_data
3969  0357 cd044d        	call	_spi_send
3971                     ; 56 	PA_ODR |= (1<<3);
3973  035a 72165000      	bset	_PA_ODR,#3
3974                     ; 57 	timers_int_on();
3976  035e cd03ef        	call	_timers_int_on
3978                     ; 58 	return;
3981  0361 81            	ret
4006                     ; 61 void Timer1_Compare_1 (void)
4006                     ; 62 {
4007                     	switch	.text
4008  0362               _Timer1_Compare_1:
4012                     ; 63 	TIM1_SR1 = 0;
4014  0362 725f5255      	clr	_TIM1_SR1
4015                     ; 64 	time_refresh();
4017  0366 cd0480        	call	_time_refresh
4019                     ; 65 }
4022  0369 81            	ret
4072                     ; 68 void timer1_setup(uint16_t tim_freq, uint16_t top)
4072                     ; 69  {
4073                     	switch	.text
4074  036a               _timer1_setup:
4076  036a 89            	pushw	x
4077  036b 5204          	subw	sp,#4
4078       00000004      OFST:	set	4
4081                     ; 70   TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
4083  036d cd0000        	call	c_uitolx
4085  0370 96            	ldw	x,sp
4086  0371 1c0001        	addw	x,#OFST-3
4087  0374 cd0000        	call	c_rtol
4089  0377 ae2400        	ldw	x,#9216
4090  037a bf02          	ldw	c_lreg+2,x
4091  037c ae00f4        	ldw	x,#244
4092  037f bf00          	ldw	c_lreg,x
4093  0381 96            	ldw	x,sp
4094  0382 1c0001        	addw	x,#OFST-3
4095  0385 cd0000        	call	c_ldiv
4097  0388 a608          	ld	a,#8
4098  038a cd0000        	call	c_lrsh
4100  038d b603          	ld	a,c_lreg+3
4101  038f c75260        	ld	_TIM1_PSCRH,a
4102                     ; 71   TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; // 16 divider
4104  0392 1e05          	ldw	x,(OFST+1,sp)
4105  0394 cd0000        	call	c_uitolx
4107  0397 96            	ldw	x,sp
4108  0398 1c0001        	addw	x,#OFST-3
4109  039b cd0000        	call	c_rtol
4111  039e ae2400        	ldw	x,#9216
4112  03a1 bf02          	ldw	c_lreg+2,x
4113  03a3 ae00f4        	ldw	x,#244
4114  03a6 bf00          	ldw	c_lreg,x
4115  03a8 96            	ldw	x,sp
4116  03a9 1c0001        	addw	x,#OFST-3
4117  03ac cd0000        	call	c_ldiv
4119  03af 3f02          	clr	c_lreg+2
4120  03b1 3f01          	clr	c_lreg+1
4121  03b3 3f00          	clr	c_lreg
4122  03b5 b603          	ld	a,c_lreg+3
4123  03b7 c75261        	ld	_TIM1_PSCRL,a
4124                     ; 72   TIM1_ARRH = (top) >> 8; //	overflow frequency = 16М / 8 / 1000 = 2000 Гц
4126  03ba 7b09          	ld	a,(OFST+5,sp)
4127  03bc c75262        	ld	_TIM1_ARRH,a
4128                     ; 73   TIM1_ARRL = (top)& 0xFF;
4130  03bf 7b0a          	ld	a,(OFST+6,sp)
4131  03c1 a4ff          	and	a,#255
4132  03c3 c75263        	ld	_TIM1_ARRL,a
4133                     ; 75   TIM1_CR1 |= TIM1_CR1_URS; //only overflow int
4135  03c6 72145250      	bset	_TIM1_CR1,#2
4136                     ; 76   TIM1_EGR |= TIM1_EGR_UG;  //call Update Event
4138  03ca 72105257      	bset	_TIM1_EGR,#0
4139                     ; 77   TIM1_IER |= TIM1_IER_UIE; //int enable
4141  03ce 72105254      	bset	_TIM1_IER,#0
4142                     ; 78  }
4145  03d2 5b06          	addw	sp,#6
4146  03d4 81            	ret
4173                     ; 81 void timer2_setup(void)
4173                     ; 82  {
4174                     	switch	.text
4175  03d5               _timer2_setup:
4179                     ; 84     TIM2_IER |= TIM2_IER_UIE;	//overflow int   
4181  03d5 72105303      	bset	_TIM2_IER,#0
4182                     ; 85     TIM2_PSCR = 0;
4184  03d9 725f530e      	clr	_TIM2_PSCR
4185                     ; 86     TIM2_ARRH = 0;
4187  03dd 725f530f      	clr	_TIM2_ARRH
4188                     ; 87     TIM2_ARRL = 0;
4190  03e1 725f5310      	clr	_TIM2_ARRL
4191                     ; 88  }
4194  03e5 81            	ret
4219                     ; 91 void timers_int_off(void)
4219                     ; 92 {
4220                     	switch	.text
4221  03e6               _timers_int_off:
4225                     ; 93 	TIM1_IER &= ~TIM1_IER_UIE;
4227  03e6 72115254      	bres	_TIM1_IER,#0
4228                     ; 94 	TIM2_IER &= ~TIM2_IER_UIE;
4230  03ea 72115303      	bres	_TIM2_IER,#0
4231                     ; 95 }
4234  03ee 81            	ret
4259                     ; 97 void timers_int_on(void)
4259                     ; 98 {
4260                     	switch	.text
4261  03ef               _timers_int_on:
4265                     ; 99 	TIM1_IER |= TIM1_IER_UIE;
4267  03ef 72105254      	bset	_TIM1_IER,#0
4268                     ; 100 	TIM2_IER |= TIM2_IER_UIE;
4270  03f3 72105303      	bset	_TIM2_IER,#0
4271                     ; 101 }
4274  03f7 81            	ret
4323                     ; 1 void time_write(void)
4323                     ; 2 {
4324                     	switch	.text
4325  03f8               _time_write:
4329                     ; 3 	timers_int_off();
4331  03f8 adec          	call	_timers_int_off
4333                     ; 5 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
4335  03fa b614          	ld	a,_fresh_hours_dec
4336  03fc 97            	ld	xl,a
4337  03fd a610          	ld	a,#16
4338  03ff 42            	mul	x,a
4339  0400 9f            	ld	a,xl
4340  0401 bb13          	add	a,_fresh_hours
4341  0403 b713          	ld	_fresh_hours,a
4342                     ; 6 	fresh_min = fresh_min + (fresh_min_dec<<4);
4344  0405 b612          	ld	a,_fresh_min_dec
4345  0407 97            	ld	xl,a
4346  0408 a610          	ld	a,#16
4347  040a 42            	mul	x,a
4348  040b 9f            	ld	a,xl
4349  040c bb11          	add	a,_fresh_min
4350  040e b711          	ld	_fresh_min,a
4351                     ; 7 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
4353  0410 b610          	ld	a,_fresh_sec_dec
4354  0412 97            	ld	xl,a
4355  0413 a610          	ld	a,#16
4356  0415 42            	mul	x,a
4357  0416 9f            	ld	a,xl
4358  0417 bb0f          	add	a,_fresh_sec
4359  0419 b70f          	ld	_fresh_sec,a
4360                     ; 9 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
4362  041b 4b01          	push	#1
4363  041d ae0013        	ldw	x,#_fresh_hours
4364  0420 89            	pushw	x
4365  0421 aed002        	ldw	x,#53250
4366  0424 cd0135        	call	_i2c_wr_reg
4368  0427 5b03          	addw	sp,#3
4369                     ; 10 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
4371  0429 4b01          	push	#1
4372  042b ae0011        	ldw	x,#_fresh_min
4373  042e 89            	pushw	x
4374  042f aed001        	ldw	x,#53249
4375  0432 cd0135        	call	_i2c_wr_reg
4377  0435 5b03          	addw	sp,#3
4378                     ; 11 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
4380  0437 4b01          	push	#1
4381  0439 ae000f        	ldw	x,#_fresh_sec
4382  043c 89            	pushw	x
4383  043d aed000        	ldw	x,#53248
4384  0440 cd0135        	call	_i2c_wr_reg
4386  0443 5b03          	addw	sp,#3
4387                     ; 12 	timers_int_on();
4389  0445 ada8          	call	_timers_int_on
4391                     ; 13 }
4394  0447 81            	ret
4435                     ; 1 void spi_setup(void)
4435                     ; 2  {
4436                     	switch	.text
4437  0448               _spi_setup:
4441                     ; 3     SPI_CR1=0x7C;       //this
4443  0448 357c5200      	mov	_SPI_CR1,#124
4444                     ; 5  }
4447  044c 81            	ret
4484                     ; 8 void spi_send(uint8_t msg)
4484                     ; 9 {
4485                     	switch	.text
4486  044d               _spi_send:
4490                     ; 10 	SPI_DR = msg;
4492  044d c75204        	ld	_SPI_DR,a
4494  0450 2005          	jra	L7362
4495  0452               L3362:
4496                     ; 14 		temp = SPI_SR;
4498  0452 5552030002    	mov	_temp,_SPI_SR
4499  0457               L7362:
4500                     ; 12 	while((SPI_SR & SPI_SR_BSY) != 0)
4502  0457 c65203        	ld	a,_SPI_SR
4503  045a a580          	bcp	a,#128
4504  045c 26f4          	jrne	L3362
4505                     ; 16 }
4508  045e 81            	ret
4550                     ; 4 void UART_Resieved (void)
4550                     ; 5 {
4551                     	switch	.text
4552  045f               _UART_Resieved:
4556                     ; 6 	uart_routine(UART1_DR);
4558  045f c65231        	ld	a,_UART1_DR
4559  0462 cd002a        	call	_uart_routine
4561                     ; 7 }
4564  0465 81            	ret
4589                     ; 9 void SPI_Transmitted(void)
4589                     ; 10 {
4590                     	switch	.text
4591  0466               _SPI_Transmitted:
4595                     ; 11 	spi_send(temp3);
4597  0466 b605          	ld	a,_temp3
4598  0468 ade3          	call	_spi_send
4600                     ; 12 }
4603  046a 81            	ret
4626                     ; 14 void I2C_Event(void)
4626                     ; 15 {
4627                     	switch	.text
4628  046b               _I2C_Event:
4632                     ; 17 }
4635  046b 81            	ret
4661                     ; 19 void Keys_switched(void)
4661                     ; 20 {
4662                     	switch	.text
4663  046c               _Keys_switched:
4667                     ; 21 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
4669  046c c650a0        	ld	a,_EXTI_CR1
4670  046f 43            	cpl	a
4671  0470 a430          	and	a,#48
4672  0472 c750a0        	ld	_EXTI_CR1,a
4673                     ; 22 	PC_CR2 = 0;
4675  0475 725f500e      	clr	_PC_CR2
4676                     ; 23 	timer2_start(0xff);	
4678  0479 ae00ff        	ldw	x,#255
4679  047c cd02dc        	call	_timer2_start
4681                     ; 24 }
4684  047f 81            	ret
4717                     ; 26 void time_refresh (void)
4717                     ; 27 {
4718                     	switch	.text
4719  0480               _time_refresh:
4723                     ; 29 	i2c_rd_reg(0xD0, 0, &fresh_sec, 1); 	
4725  0480 4b01          	push	#1
4726  0482 ae000f        	ldw	x,#_fresh_sec
4727  0485 89            	pushw	x
4728  0486 aed000        	ldw	x,#53248
4729  0489 cd0198        	call	_i2c_rd_reg
4731  048c 5b03          	addw	sp,#3
4732                     ; 30 	i2c_rd_reg(0xD0, 1, &fresh_min, 1);
4734  048e 4b01          	push	#1
4735  0490 ae0011        	ldw	x,#_fresh_min
4736  0493 89            	pushw	x
4737  0494 aed001        	ldw	x,#53249
4738  0497 cd0198        	call	_i2c_rd_reg
4740  049a 5b03          	addw	sp,#3
4741                     ; 31 	i2c_rd_reg(0xD0, 2, &fresh_hours, 1);
4743  049c 4b01          	push	#1
4744  049e ae0013        	ldw	x,#_fresh_hours
4745  04a1 89            	pushw	x
4746  04a2 aed002        	ldw	x,#53250
4747  04a5 cd0198        	call	_i2c_rd_reg
4749  04a8 5b03          	addw	sp,#3
4750                     ; 34 	seconds_tens = (fresh_sec & 0xf0)>>4;
4752  04aa b60f          	ld	a,_fresh_sec
4753  04ac a4f0          	and	a,#240
4754  04ae 4e            	swap	a
4755  04af a40f          	and	a,#15
4756  04b1 b70a          	ld	_seconds_tens,a
4757                     ; 35 	minutes_tens = (fresh_min & 0xf0)>>4;
4759  04b3 b611          	ld	a,_fresh_min
4760  04b5 a4f0          	and	a,#240
4761  04b7 4e            	swap	a
4762  04b8 a40f          	and	a,#15
4763  04ba b709          	ld	_minutes_tens,a
4764                     ; 36 	hours_tens = (fresh_hours & 0xf0)>>4;
4766  04bc b613          	ld	a,_fresh_hours
4767  04be a4f0          	and	a,#240
4768  04c0 4e            	swap	a
4769  04c1 a40f          	and	a,#15
4770  04c3 b708          	ld	_hours_tens,a
4771                     ; 38 	seconds = fresh_sec & 0x0f;
4773  04c5 b60f          	ld	a,_fresh_sec
4774  04c7 a40f          	and	a,#15
4775  04c9 b70b          	ld	_seconds,a
4776                     ; 39 	minutes = fresh_min & 0x0f;
4778  04cb b611          	ld	a,_fresh_min
4779  04cd a40f          	and	a,#15
4780  04cf b70c          	ld	_minutes,a
4781                     ; 40 	hours = fresh_hours & 0x0f;
4783  04d1 b613          	ld	a,_fresh_hours
4784  04d3 a40f          	and	a,#15
4785  04d5 b70d          	ld	_hours,a
4786                     ; 41 }
4789  04d7 81            	ret
4858                     ; 21 int main( void )
4858                     ; 22 {
4859                     	switch	.text
4860  04d8               _main:
4864                     ; 24 		CLK_CKDIVR=0;                //	no dividers
4866  04d8 725f50c6      	clr	_CLK_CKDIVR
4867                     ; 25 		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //clocking for TIM1, UART1, SPI i I2C
4869  04dc 35ff50c7      	mov	_CLK_PCKENR1,#255
4870                     ; 28     PA_DDR=(1<<3) | (1<<2); //0b000001000; //output for register's latch, input for RTC 1 Hz pulse
4872  04e0 350c5002      	mov	_PA_DDR,#12
4873                     ; 29     PA_CR1= 0xff;        //	pull-up on inputs, push-pull on outputs
4875  04e4 35ff5003      	mov	_PA_CR1,#255
4876                     ; 30     PA_ODR |= (1<<3);
4878  04e8 72165000      	bset	_PA_ODR,#3
4879                     ; 31 		PA_CR2 |=(1<<3);        //	interrupt on PA1 for 1hz
4881  04ec 72165004      	bset	_PA_CR2,#3
4882                     ; 33     PC_DDR=0x60; //0b01100000; // buttons pins as input
4884  04f0 3560500c      	mov	_PC_DDR,#96
4885                     ; 34     PC_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
4887  04f4 35ff500d      	mov	_PC_CR1,#255
4888                     ; 35     PC_CR2 |= (1<<4) | (1<<3);        //	interrapts for buttons
4890  04f8 c6500e        	ld	a,_PC_CR2
4891  04fb aa18          	or	a,#24
4892  04fd c7500e        	ld	_PC_CR2,a
4893                     ; 37 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM
4895  0500 35a85011      	mov	_PD_DDR,#168
4896                     ; 38     PD_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
4898  0504 35ff5012      	mov	_PD_CR1,#255
4899                     ; 39     PD_ODR = (1 << 3);
4901  0508 3508500f      	mov	_PD_ODR,#8
4902                     ; 43     spi_setup();
4904  050c cd0448        	call	_spi_setup
4906                     ; 46 		uart_setup();
4908  050f cd0000        	call	_uart_setup
4910                     ; 47 		uart_send('h');
4912  0512 a668          	ld	a,#104
4913  0514 cd0019        	call	_uart_send
4915                     ; 50     timer1_setup( 65500,0xffff);//	freq in hz and top value
4917  0517 aeffff        	ldw	x,#65535
4918  051a 89            	pushw	x
4919  051b aeffdc        	ldw	x,#65500
4920  051e cd036a        	call	_timer1_setup
4922  0521 85            	popw	x
4923                     ; 51 		timer2_setup();
4925  0522 cd03d5        	call	_timer2_setup
4927                     ; 52 		timer1_start();
4929  0525 cd02d7        	call	_timer1_start
4931                     ; 53 		timer2_start(TIM2_TOP);
4933  0528 ae3e80        	ldw	x,#16000
4934  052b cd02dc        	call	_timer2_start
4936                     ; 57 		i2c_master_init(16000000, 100000);
4938  052e ae86a0        	ldw	x,#34464
4939  0531 89            	pushw	x
4940  0532 ae0001        	ldw	x,#1
4941  0535 89            	pushw	x
4942  0536 ae2400        	ldw	x,#9216
4943  0539 89            	pushw	x
4944  053a ae00f4        	ldw	x,#244
4945  053d 89            	pushw	x
4946  053e cd00b7        	call	_i2c_master_init
4948  0541 5b08          	addw	sp,#8
4949                     ; 60 		timers_int_off();
4951  0543 cd03e6        	call	_timers_int_off
4953                     ; 62 		i2c_rd_reg(ds_address, 7, &temp, 1);
4955  0546 4b01          	push	#1
4956  0548 ae0002        	ldw	x,#_temp
4957  054b 89            	pushw	x
4958  054c aed007        	ldw	x,#53255
4959  054f cd0198        	call	_i2c_rd_reg
4961  0552 5b03          	addw	sp,#3
4962                     ; 63 	if (temp != 0b10010000)	// if OUT and SWQ == 0
4964  0554 b602          	ld	a,_temp
4965  0556 a190          	cp	a,#144
4966  0558 270e          	jreq	L7372
4967                     ; 65 			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//	setup RTC for 1Hz output
4969  055a 4b01          	push	#1
4970  055c ae0006        	ldw	x,#_ds_cr
4971  055f 89            	pushw	x
4972  0560 aed007        	ldw	x,#53255
4973  0563 cd0135        	call	_i2c_wr_reg
4975  0566 5b03          	addw	sp,#3
4976  0568               L7372:
4977                     ; 68 		i2c_rd_reg(ds_address, 0, &temp, 1);
4979  0568 4b01          	push	#1
4980  056a ae0002        	ldw	x,#_temp
4981  056d 89            	pushw	x
4982  056e aed000        	ldw	x,#53248
4983  0571 cd0198        	call	_i2c_rd_reg
4985  0574 5b03          	addw	sp,#3
4986                     ; 71 	if((temp & 0x80) == 0x80)
4988  0576 b602          	ld	a,_temp
4989  0578 a480          	and	a,#128
4990  057a a180          	cp	a,#128
4991  057c 2610          	jrne	L1472
4992                     ; 73 		temp = 0;
4994  057e 3f02          	clr	_temp
4995                     ; 74 		i2c_wr_reg(ds_address, 0, &temp, 1);
4997  0580 4b01          	push	#1
4998  0582 ae0002        	ldw	x,#_temp
4999  0585 89            	pushw	x
5000  0586 aed000        	ldw	x,#53248
5001  0589 cd0135        	call	_i2c_wr_reg
5003  058c 5b03          	addw	sp,#3
5004  058e               L1472:
5005                     ; 76 		timers_int_on();
5007  058e cd03ef        	call	_timers_int_on
5009                     ; 78 		_asm ("RIM");  //on interupts
5012  0591 9a            RIM
5014                     ; 81 		EXTI_CR1 = 0b00110011;//((1<<4) | (1<<0));//0x10;	//	external interrupts on ports А and С on raising fronts 
5016  0592 353350a0      	mov	_EXTI_CR1,#51
5017                     ; 82 		EXTI_CR2 = 0b00000100;
5019  0596 350450a1      	mov	_EXTI_CR2,#4
5020  059a               L3472:
5022  059a 20fe          	jra	L3472
5035                     	xdef	_main
5036                     	xdef	_Keys_switched
5037                     	xdef	_I2C_Event
5038                     	xdef	_SPI_Transmitted
5039                     	xdef	_UART_Resieved
5040                     	xdef	_spi_setup
5041                     	xdef	_timer2_setup
5042                     	xdef	_timer1_setup
5043                     	xdef	_Timer1_Compare_1
5044                     	xdef	_Timer2_Overflow
5045                     	xdef	_timer2_start
5046                     	xdef	_timer1_start
5047                     	xdef	_time_refresh
5048                     	xdef	_timers_int_on
5049                     	xdef	_timers_int_off
5050                     	xdef	_spi_send
5051                     	xdef	_i2c_rd_reg
5052                     	xdef	_i2c_wr_reg
5053                     	xdef	_i2c_master_init
5054                     	xdef	_Key_interrupt
5055                     	xdef	_uart_routine
5056                     	xdef	_uart_send
5057                     	xdef	_uart_setup
5058                     	xdef	_time_write
5059                     	switch	.ubsct
5060  0000               _i2c_flags:
5061  0000 00            	ds.b	1
5062                     	xdef	_i2c_flags
5063  0001               _flags:
5064  0001 00            	ds.b	1
5065                     	xdef	_flags
5066                     	xdef	_ds_cr
5067                     	xdef	_temp3
5068                     	xdef	_temp2
5069  0002               _temp:
5070  0002 00            	ds.b	1
5071                     	xdef	_temp
5072  0003               _pins:
5073  0003 00            	ds.b	1
5074                     	xdef	_pins
5075  0004               _fresh_data_pointer:
5076  0004 0000          	ds.b	2
5077                     	xdef	_fresh_data_pointer
5078  0006               _data_pointer:
5079  0006 0000          	ds.b	2
5080                     	xdef	_data_pointer
5081                     	xdef	_time_pointer
5082  0008               _hours_tens:
5083  0008 00            	ds.b	1
5084                     	xdef	_hours_tens
5085  0009               _minutes_tens:
5086  0009 00            	ds.b	1
5087                     	xdef	_minutes_tens
5088  000a               _seconds_tens:
5089  000a 00            	ds.b	1
5090                     	xdef	_seconds_tens
5091  000b               _seconds:
5092  000b 00            	ds.b	1
5093                     	xdef	_seconds
5094  000c               _minutes:
5095  000c 00            	ds.b	1
5096                     	xdef	_minutes
5097  000d               _hours:
5098  000d 00            	ds.b	1
5099                     	xdef	_hours
5100  000e               _timeset:
5101  000e 00            	ds.b	1
5102                     	xdef	_timeset
5103  000f               _fresh_sec:
5104  000f 00            	ds.b	1
5105                     	xdef	_fresh_sec
5106  0010               _fresh_sec_dec:
5107  0010 00            	ds.b	1
5108                     	xdef	_fresh_sec_dec
5109  0011               _fresh_min:
5110  0011 00            	ds.b	1
5111                     	xdef	_fresh_min
5112  0012               _fresh_min_dec:
5113  0012 00            	ds.b	1
5114                     	xdef	_fresh_min_dec
5115  0013               _fresh_hours:
5116  0013 00            	ds.b	1
5117                     	xdef	_fresh_hours
5118  0014               _fresh_hours_dec:
5119  0014 00            	ds.b	1
5120                     	xdef	_fresh_hours_dec
5121  0015               _lamp_number_data:
5122  0015 00            	ds.b	1
5123                     	xdef	_lamp_number_data
5124  0016               _k155_data:
5125  0016 00            	ds.b	1
5126                     	xdef	_k155_data
5127                     	xdef	_dots
5128                     	xdef	_lamp_number
5129                     	xref.b	c_lreg
5130                     	xref.b	c_x
5150                     	xref	c_lrsh
5151                     	xref	c_ldiv
5152                     	xref	c_uitolx
5153                     	xref	c_ludv
5154                     	xref	c_rtol
5155                     	xref	c_ltor
5156                     	end
