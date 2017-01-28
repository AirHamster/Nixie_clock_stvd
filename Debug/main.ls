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
2197  0007               _ds_cr:
2198  0007 90            	dc.b	144
2641                     ; 2  void uart_setup(void)
2641                     ; 3  {
2643                     	switch	.text
2644  0000               _uart_setup:
2648                     ; 4 		UART1_BRR1=0x68;     //9600 bod
2650  0000 35685232      	mov	_UART1_BRR1,#104
2651                     ; 5     UART1_BRR2=0x03;
2653  0004 35035233      	mov	_UART1_BRR2,#3
2654                     ; 6     UART1_CR2 |= UART1_CR2_REN; //reseiving
2656  0008 72145235      	bset	_UART1_CR2,#2
2657                     ; 7     UART1_CR2 |= UART1_CR2_TEN; //transmiting 
2659  000c 72165235      	bset	_UART1_CR2,#3
2660                     ; 8     UART1_CR2 |= UART1_CR2_RIEN; //reseive int
2662  0010 721a5235      	bset	_UART1_CR2,#5
2663                     ; 9 		UART1_SR = 0;
2665  0014 725f5230      	clr	_UART1_SR
2666                     ; 10  }
2669  0018 81            	ret
2706                     ; 12 void uart_send(uint8_t msg)
2706                     ; 13  {
2707                     	switch	.text
2708  0019               _uart_send:
2710  0019 88            	push	a
2711       00000000      OFST:	set	0
2714                     ; 14 	 temp =msg;
2716  001a b702          	ld	_temp,a
2718  001c               L7471:
2719                     ; 15 	 while((UART1_SR & 0x80) == 0x00);
2721  001c c65230        	ld	a,_UART1_SR
2722  001f a580          	bcp	a,#128
2723  0021 27f9          	jreq	L7471
2724                     ; 16 	 UART1_DR = msg;
2726  0023 7b01          	ld	a,(OFST+1,sp)
2727  0025 c75231        	ld	_UART1_DR,a
2728                     ; 17  }
2731  0028 84            	pop	a
2732  0029 81            	ret
2778                     ; 18  void uart_routine(uint8_t data)
2778                     ; 19  {
2779                     	switch	.text
2780  002a               _uart_routine:
2782  002a 88            	push	a
2783       00000000      OFST:	set	0
2786                     ; 21 	 temp2 = data - 0x30;
2788  002b a030          	sub	a,#48
2789  002d b704          	ld	_temp2,a
2790                     ; 22 	 if (timeset != 0 && timeset <= 5)
2792  002f 3d0e          	tnz	_timeset
2793  0031 2719          	jreq	L1771
2795  0033 b60e          	ld	a,_timeset
2796  0035 a106          	cp	a,#6
2797  0037 2413          	jruge	L1771
2798                     ; 24 		* fresh_data_pointer-- = data-0x30;
2800  0039 7b01          	ld	a,(OFST+1,sp)
2801  003b a030          	sub	a,#48
2802  003d be04          	ldw	x,_fresh_data_pointer
2803  003f 1d0001        	subw	x,#1
2804  0042 bf04          	ldw	_fresh_data_pointer,x
2805  0044 1c0001        	addw	x,#1
2806  0047 f7            	ld	(x),a
2807                     ; 25 		 timeset++;
2809  0048 3c0e          	inc	_timeset
2810                     ; 26 		 return ;
2813  004a 84            	pop	a
2814  004b 81            	ret
2815  004c               L1771:
2816                     ; 28 	 if (timeset == 6)
2818  004c b60e          	ld	a,_timeset
2819  004e a106          	cp	a,#6
2820  0050 2616          	jrne	L3771
2821                     ; 30 		 *fresh_data_pointer = data-0x30;
2823  0052 7b01          	ld	a,(OFST+1,sp)
2824  0054 a030          	sub	a,#48
2825  0056 92c704        	ld	[_fresh_data_pointer.w],a
2826                     ; 31 		 timeset = 0;
2828  0059 3f0e          	clr	_timeset
2829                     ; 32 		 time_write();
2831  005b cd0442        	call	_time_write
2833                     ; 33 		 uart_send('O');
2835  005e a64f          	ld	a,#79
2836  0060 adb7          	call	_uart_send
2838                     ; 34 		 uart_send('K');
2840  0062 a64b          	ld	a,#75
2841  0064 adb3          	call	_uart_send
2843                     ; 35 		 return;
2846  0066 84            	pop	a
2847  0067 81            	ret
2848  0068               L3771:
2849                     ; 38 	 if (data == 's')
2851  0068 7b01          	ld	a,(OFST+1,sp)
2852  006a a173          	cp	a,#115
2853  006c 260b          	jrne	L5771
2854                     ; 40 			timeset = 1;
2856  006e 3501000e      	mov	_timeset,#1
2857                     ; 41 			fresh_data_pointer = &fresh_hours_dec;
2859  0072 ae0014        	ldw	x,#_fresh_hours_dec
2860  0075 bf04          	ldw	_fresh_data_pointer,x
2861                     ; 42 			return;
2864  0077 84            	pop	a
2865  0078 81            	ret
2866  0079               L5771:
2867                     ; 46 		if (data == 't')
2869  0079 7b01          	ld	a,(OFST+1,sp)
2870  007b a174          	cp	a,#116
2871  007d 2635          	jrne	L7771
2872                     ; 48 			uart_send(hours_tens+0x30);
2874  007f b608          	ld	a,_hours_tens
2875  0081 ab30          	add	a,#48
2876  0083 ad94          	call	_uart_send
2878                     ; 49 			uart_send(hours+0x30);
2880  0085 b60d          	ld	a,_hours
2881  0087 ab30          	add	a,#48
2882  0089 ad8e          	call	_uart_send
2884                     ; 50 			uart_send(':');	
2886  008b a63a          	ld	a,#58
2887  008d ad8a          	call	_uart_send
2889                     ; 51 			uart_send(minutes_tens+0x30);
2891  008f b609          	ld	a,_minutes_tens
2892  0091 ab30          	add	a,#48
2893  0093 ad84          	call	_uart_send
2895                     ; 52 			uart_send(minutes+0x30);
2897  0095 b60c          	ld	a,_minutes
2898  0097 ab30          	add	a,#48
2899  0099 cd0019        	call	_uart_send
2901                     ; 53 			uart_send(':'); 
2903  009c a63a          	ld	a,#58
2904  009e cd0019        	call	_uart_send
2906                     ; 54 			uart_send(seconds_tens+0x30);
2908  00a1 b60a          	ld	a,_seconds_tens
2909  00a3 ab30          	add	a,#48
2910  00a5 cd0019        	call	_uart_send
2912                     ; 55 			uart_send(seconds+0x30);
2914  00a8 b60b          	ld	a,_seconds
2915  00aa ab30          	add	a,#48
2916  00ac cd0019        	call	_uart_send
2918                     ; 56 			uart_send(0x0A);
2920  00af a60a          	ld	a,#10
2921  00b1 cd0019        	call	_uart_send
2923  00b4               L7771:
2924                     ; 58 	}
2927  00b4 84            	pop	a
2928  00b5 81            	ret
2970                     ; 1  void Key_interrupt (void)
2970                     ; 2 {
2971                     	switch	.text
2972  00b6               _Key_interrupt:
2976                     ; 4   pins = PC_IDR;
2978  00b6 55500b0003    	mov	_pins,_PC_IDR
2979                     ; 5 }
2982  00bb 81            	ret
3061                     ; 7 void i2c_master_init(unsigned long f_master_hz, unsigned long f_i2c_hz){
3062                     	switch	.text
3063  00bc               _i2c_master_init:
3065  00bc 5208          	subw	sp,#8
3066       00000008      OFST:	set	8
3069                     ; 9 	I2C_CR1 &= ~I2C_CR1_PE;
3071  00be 72115210      	bres	_I2C_CR1,#0
3072                     ; 10 	I2C_CR2 |= I2C_CR2_SWRST;
3074  00c2 721e5211      	bset	_I2C_CR2,#7
3075                     ; 11   PB_DDR = (0<<4);//PB_DDR_DDR4);
3077  00c6 725f5007      	clr	_PB_DDR
3078                     ; 12 	PB_DDR = (0<<5);//PB_DDR_DDR5);
3080  00ca 725f5007      	clr	_PB_DDR
3081                     ; 13 	PB_ODR = (1<<5);//PB_ODR_ODR5);  //SDA
3083  00ce 35205005      	mov	_PB_ODR,#32
3084                     ; 14   PB_ODR = (1<<4);//PB_ODR_ODR4);  //SCL
3086  00d2 35105005      	mov	_PB_ODR,#16
3087                     ; 16   PB_CR1 = (0<<4);//PB_CR1_C14);
3089  00d6 725f5008      	clr	_PB_CR1
3090                     ; 17   PB_CR1 = (0<<5);//PB_CR1_C15);
3092  00da 725f5008      	clr	_PB_CR1
3093                     ; 19   PB_CR2 = (0<<4);//PB_CR1_C24);
3095  00de 725f5009      	clr	_PB_CR2
3096                     ; 20   PB_CR2 = (0<<5);//PB_CR1_C25);
3098  00e2 725f5009      	clr	_PB_CR2
3099                     ; 21   I2C_CR2 &= ~I2C_CR2_SWRST;
3101  00e6 721f5211      	bres	_I2C_CR2,#7
3102                     ; 23   I2C_FREQR = 16;
3104  00ea 35105212      	mov	_I2C_FREQR,#16
3105                     ; 28   I2C_CCRH |=~I2C_CCRH_FS;
3107  00ee c6521c        	ld	a,_I2C_CCRH
3108  00f1 aa7f          	or	a,#127
3109  00f3 c7521c        	ld	_I2C_CCRH,a
3110                     ; 30   ccr = f_master_hz/(2*f_i2c_hz);
3112  00f6 96            	ldw	x,sp
3113  00f7 1c000f        	addw	x,#OFST+7
3114  00fa cd0000        	call	c_ltor
3116  00fd 3803          	sll	c_lreg+3
3117  00ff 3902          	rlc	c_lreg+2
3118  0101 3901          	rlc	c_lreg+1
3119  0103 3900          	rlc	c_lreg
3120  0105 96            	ldw	x,sp
3121  0106 1c0001        	addw	x,#OFST-7
3122  0109 cd0000        	call	c_rtol
3124  010c 96            	ldw	x,sp
3125  010d 1c000b        	addw	x,#OFST+3
3126  0110 cd0000        	call	c_ltor
3128  0113 96            	ldw	x,sp
3129  0114 1c0001        	addw	x,#OFST-7
3130  0117 cd0000        	call	c_ludv
3132  011a 96            	ldw	x,sp
3133  011b 1c0005        	addw	x,#OFST-3
3134  011e cd0000        	call	c_rtol
3136                     ; 34   I2C_TRISER = 12+1;
3138  0121 350d521d      	mov	_I2C_TRISER,#13
3139                     ; 35   I2C_CCRL = ccr & 0xFF;
3141  0125 7b08          	ld	a,(OFST+0,sp)
3142  0127 a4ff          	and	a,#255
3143  0129 c7521b        	ld	_I2C_CCRL,a
3144                     ; 36   I2C_CCRH = ((ccr >> 8) & 0x0F);
3146  012c 7b07          	ld	a,(OFST-1,sp)
3147  012e a40f          	and	a,#15
3148  0130 c7521c        	ld	_I2C_CCRH,a
3149                     ; 39   I2C_CR1 |=I2C_CR1_PE;
3151  0133 72105210      	bset	_I2C_CR1,#0
3152                     ; 42   I2C_CR2 |=I2C_CR2_ACK;
3154  0137 72145211      	bset	_I2C_CR2,#2
3155                     ; 43 }
3158  013b 5b08          	addw	sp,#8
3159  013d 81            	ret
3253                     ; 49 t_i2c_status i2c_wr_reg(unsigned char address, unsigned char reg_addr,
3253                     ; 50                               char * data, unsigned char length)
3253                     ; 51 {                                  
3254                     	switch	.text
3255  013e               _i2c_wr_reg:
3257  013e 89            	pushw	x
3258       00000000      OFST:	set	0
3261  013f               L1212:
3262                     ; 55   while((I2C_SR3 & I2C_SR3_BUSY) !=0);   
3264  013f c65219        	ld	a,_I2C_SR3
3265  0142 a502          	bcp	a,#2
3266  0144 26f9          	jrne	L1212
3267                     ; 57   I2C_CR2 |= I2C_CR2_START;
3269  0146 72105211      	bset	_I2C_CR2,#0
3271  014a               L7212:
3272                     ; 60   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3274  014a c65217        	ld	a,_I2C_SR1
3275  014d a501          	bcp	a,#1
3276  014f 27f9          	jreq	L7212
3277                     ; 63   I2C_DR = address & 0xFE;
3279  0151 7b01          	ld	a,(OFST+1,sp)
3280  0153 a4fe          	and	a,#254
3281  0155 c75216        	ld	_I2C_DR,a
3283  0158               L7312:
3284                     ; 66 	while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3286  0158 c65217        	ld	a,_I2C_SR1
3287  015b a502          	bcp	a,#2
3288  015d 27f9          	jreq	L7312
3289                     ; 68   I2C_SR3;
3291  015f c65219        	ld	a,_I2C_SR3
3293  0162               L5412:
3294                     ; 73   while((I2C_SR1 & I2C_SR1_TXE) ==0);
3296  0162 c65217        	ld	a,_I2C_SR1
3297  0165 a580          	bcp	a,#128
3298  0167 27f9          	jreq	L5412
3299                     ; 75   I2C_DR = reg_addr;
3301  0169 7b02          	ld	a,(OFST+2,sp)
3302  016b c75216        	ld	_I2C_DR,a
3304  016e 2015          	jra	L5512
3305  0170               L3612:
3306                     ; 81     while((I2C_SR1 & I2C_SR1_TXE) == 0);
3308  0170 c65217        	ld	a,_I2C_SR1
3309  0173 a580          	bcp	a,#128
3310  0175 27f9          	jreq	L3612
3311                     ; 83     I2C_DR = *data++;
3313  0177 1e05          	ldw	x,(OFST+5,sp)
3314  0179 1c0001        	addw	x,#1
3315  017c 1f05          	ldw	(OFST+5,sp),x
3316  017e 1d0001        	subw	x,#1
3317  0181 f6            	ld	a,(x)
3318  0182 c75216        	ld	_I2C_DR,a
3319  0185               L5512:
3320                     ; 78   while(length--){
3322  0185 7b07          	ld	a,(OFST+7,sp)
3323  0187 0a07          	dec	(OFST+7,sp)
3324  0189 4d            	tnz	a
3325  018a 26e4          	jrne	L3612
3327  018c               L1712:
3328                     ; 88   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3330  018c c65217        	ld	a,_I2C_SR1
3331  018f a584          	bcp	a,#132
3332  0191 27f9          	jreq	L1712
3333                     ; 90   I2C_CR2 |= I2C_CR2_STOP;
3335  0193 72125211      	bset	_I2C_CR2,#1
3337  0197               L7712:
3338                     ; 93   while((I2C_CR2 & I2C_CR2_STOP) == 0); 
3340  0197 c65211        	ld	a,_I2C_CR2
3341  019a a502          	bcp	a,#2
3342  019c 27f9          	jreq	L7712
3343                     ; 94   return I2C_SUCCESS;
3345  019e 4f            	clr	a
3348  019f 85            	popw	x
3349  01a0 81            	ret
3419                     ; 101 t_i2c_status i2c_rd_reg(unsigned char address, unsigned char reg_addr,
3419                     ; 102                               char * data, unsigned char length)
3419                     ; 103 {
3420                     	switch	.text
3421  01a1               _i2c_rd_reg:
3423  01a1 89            	pushw	x
3424       00000000      OFST:	set	0
3427  01a2               L7322:
3428                     ; 109   while((I2C_SR3 & I2C_SR3_BUSY) != 0);   
3430  01a2 c65219        	ld	a,_I2C_SR3
3431  01a5 a502          	bcp	a,#2
3432  01a7 26f9          	jrne	L7322
3433                     ; 111   I2C_CR2 |= I2C_CR2_ACK;
3435  01a9 72145211      	bset	_I2C_CR2,#2
3436                     ; 114   I2C_CR2 |= I2C_CR2_START;
3438  01ad 72105211      	bset	_I2C_CR2,#0
3440  01b1               L5422:
3441                     ; 117   while((I2C_SR1 & I2C_SR1_SB) == 0);  
3443  01b1 c65217        	ld	a,_I2C_SR1
3444  01b4 a501          	bcp	a,#1
3445  01b6 27f9          	jreq	L5422
3446                     ; 119   I2C_DR = address & 0xFE;
3448  01b8 7b01          	ld	a,(OFST+1,sp)
3449  01ba a4fe          	and	a,#254
3450  01bc c75216        	ld	_I2C_DR,a
3452  01bf               L5522:
3453                     ; 122   while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3455  01bf c65217        	ld	a,_I2C_SR1
3456  01c2 a502          	bcp	a,#2
3457  01c4 27f9          	jreq	L5522
3458                     ; 124   temp = I2C_SR3;
3460  01c6 5552190002    	mov	_temp,_I2C_SR3
3462  01cb               L5622:
3463                     ; 128   while((I2C_SR1 & I2C_SR1) == 0); 
3465  01cb c65217        	ld	a,_I2C_SR1
3466  01ce 5f            	clrw	x
3467  01cf 97            	ld	xl,a
3468  01d0 a30000        	cpw	x,#0
3469  01d3 27f6          	jreq	L5622
3470                     ; 130   I2C_DR = reg_addr;
3472  01d5 7b02          	ld	a,(OFST+2,sp)
3473  01d7 c75216        	ld	_I2C_DR,a
3475  01da               L5722:
3476                     ; 133   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3478  01da c65217        	ld	a,_I2C_SR1
3479  01dd a584          	bcp	a,#132
3480  01df 27f9          	jreq	L5722
3481                     ; 135   I2C_CR2 |= I2C_CR2_START;
3483  01e1 72105211      	bset	_I2C_CR2,#0
3485  01e5               L3032:
3486                     ; 138   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3488  01e5 c65217        	ld	a,_I2C_SR1
3489  01e8 a501          	bcp	a,#1
3490  01ea 27f9          	jreq	L3032
3491                     ; 141   I2C_DR = address | 0x01;
3493  01ec 7b01          	ld	a,(OFST+1,sp)
3494  01ee aa01          	or	a,#1
3495  01f0 c75216        	ld	_I2C_DR,a
3496                     ; 145   if(length == 1){
3498  01f3 7b07          	ld	a,(OFST+7,sp)
3499  01f5 a101          	cp	a,#1
3500  01f7 2627          	jrne	L7032
3501                     ; 147     I2C_CR2 &= ~I2C_CR2_ACK;
3503  01f9 72155211      	bres	_I2C_CR2,#2
3505  01fd               L3132:
3506                     ; 150     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3508  01fd c65217        	ld	a,_I2C_SR1
3509  0200 a502          	bcp	a,#2
3510  0202 27f9          	jreq	L3132
3511                     ; 152     _asm ("SIM");  //on interupts
3514  0204 9b            SIM
3516                     ; 154     temp = I2C_SR3;
3518  0205 5552190002    	mov	_temp,_I2C_SR3
3519                     ; 157     I2C_CR2 |= I2C_CR2_STOP;
3521  020a 72125211      	bset	_I2C_CR2,#1
3522                     ; 159     _asm ("RIM");  //on interupts;
3525  020e 9a            RIM
3528  020f               L1232:
3529                     ; 163     while((I2C_SR1 & I2C_SR1_RXNE) == 0); 
3531  020f c65217        	ld	a,_I2C_SR1
3532  0212 a540          	bcp	a,#64
3533  0214 27f9          	jreq	L1232
3534                     ; 165     *data = I2C_DR;
3536  0216 1e05          	ldw	x,(OFST+5,sp)
3537  0218 c65216        	ld	a,_I2C_DR
3538  021b f7            	ld	(x),a
3540  021c acd202d2      	jpf	L5232
3541  0220               L7032:
3542                     ; 168   else if(length == 2){
3544  0220 7b07          	ld	a,(OFST+7,sp)
3545  0222 a102          	cp	a,#2
3546  0224 2639          	jrne	L7232
3547                     ; 170     I2C_CR2 |= I2C_CR2_POS;
3549  0226 72165211      	bset	_I2C_CR2,#3
3551  022a               L3332:
3552                     ; 173     while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3554  022a c65217        	ld	a,_I2C_SR1
3555  022d a502          	bcp	a,#2
3556  022f 27f9          	jreq	L3332
3557                     ; 175     _asm ("SIM");  //on interupts;
3560  0231 9b            SIM
3562                     ; 177     temp = I2C_SR3;
3564  0232 5552190002    	mov	_temp,_I2C_SR3
3565                     ; 179     I2C_CR2 &= ~I2C_CR2_ACK;
3567  0237 72155211      	bres	_I2C_CR2,#2
3568                     ; 181     _asm ("RIM");  //on interupts;
3571  023b 9a            RIM
3574  023c               L1432:
3575                     ; 185     while((I2C_SR1 & I2C_SR1_BTF) == 0); 
3577  023c c65217        	ld	a,_I2C_SR1
3578  023f a504          	bcp	a,#4
3579  0241 27f9          	jreq	L1432
3580                     ; 187     _asm ("SIM");  //on interupts;
3583  0243 9b            SIM
3585                     ; 189     I2C_CR2 |= I2C_CR2_STOP;
3587  0244 72125211      	bset	_I2C_CR2,#1
3588                     ; 191     *data++ = I2C_DR;
3590  0248 1e05          	ldw	x,(OFST+5,sp)
3591  024a 1c0001        	addw	x,#1
3592  024d 1f05          	ldw	(OFST+5,sp),x
3593  024f 1d0001        	subw	x,#1
3594  0252 c65216        	ld	a,_I2C_DR
3595  0255 f7            	ld	(x),a
3596                     ; 193     _asm ("RIM");  //on interupts;
3599  0256 9a            RIM
3601                     ; 194     *data = I2C_DR;
3603  0257 1e05          	ldw	x,(OFST+5,sp)
3604  0259 c65216        	ld	a,_I2C_DR
3605  025c f7            	ld	(x),a
3607  025d 2073          	jra	L5232
3608  025f               L7232:
3609                     ; 197   else if(length > 2){
3611  025f 7b07          	ld	a,(OFST+7,sp)
3612  0261 a103          	cp	a,#3
3613  0263 256d          	jrult	L5232
3615  0265               L3532:
3616                     ; 200     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3618  0265 c65217        	ld	a,_I2C_SR1
3619  0268 a502          	bcp	a,#2
3620  026a 27f9          	jreq	L3532
3621                     ; 202     _asm ("SIM");  //on interupts;
3624  026c 9b            SIM
3626                     ; 205     I2C_SR3;
3628  026d c65219        	ld	a,_I2C_SR3
3629                     ; 208     _asm ("RIM");  //on interupts;
3632  0270 9a            RIM
3635  0271 2015          	jra	L1632
3636  0273               L7632:
3637                     ; 213       while((I2C_SR1 & I2C_SR1_BTF) == 0);
3639  0273 c65217        	ld	a,_I2C_SR1
3640  0276 a504          	bcp	a,#4
3641  0278 27f9          	jreq	L7632
3642                     ; 215       *data++ = I2C_DR;
3644  027a 1e05          	ldw	x,(OFST+5,sp)
3645  027c 1c0001        	addw	x,#1
3646  027f 1f05          	ldw	(OFST+5,sp),x
3647  0281 1d0001        	subw	x,#1
3648  0284 c65216        	ld	a,_I2C_DR
3649  0287 f7            	ld	(x),a
3650  0288               L1632:
3651                     ; 210     while(length-- > 3){
3653  0288 7b07          	ld	a,(OFST+7,sp)
3654  028a 0a07          	dec	(OFST+7,sp)
3655  028c a104          	cp	a,#4
3656  028e 24e3          	jruge	L7632
3658  0290               L5732:
3659                     ; 224     while((I2C_SR1 & I2C_SR1_BTF) == 0);
3661  0290 c65217        	ld	a,_I2C_SR1
3662  0293 a504          	bcp	a,#4
3663  0295 27f9          	jreq	L5732
3664                     ; 226     I2C_CR2 &= ~I2C_CR2_ACK;
3666  0297 72155211      	bres	_I2C_CR2,#2
3667                     ; 228     _asm ("SIM");  //on interupts;
3670  029b 9b            SIM
3672                     ; 231     *data++ = I2C_DR;
3674  029c 1e05          	ldw	x,(OFST+5,sp)
3675  029e 1c0001        	addw	x,#1
3676  02a1 1f05          	ldw	(OFST+5,sp),x
3677  02a3 1d0001        	subw	x,#1
3678  02a6 c65216        	ld	a,_I2C_DR
3679  02a9 f7            	ld	(x),a
3680                     ; 233     I2C_CR2 |= I2C_CR2_STOP;
3682  02aa 72125211      	bset	_I2C_CR2,#1
3683                     ; 235     *data++ = I2C_DR;
3685  02ae 1e05          	ldw	x,(OFST+5,sp)
3686  02b0 1c0001        	addw	x,#1
3687  02b3 1f05          	ldw	(OFST+5,sp),x
3688  02b5 1d0001        	subw	x,#1
3689  02b8 c65216        	ld	a,_I2C_DR
3690  02bb f7            	ld	(x),a
3691                     ; 237     _asm ("RIM");  //on interupts;
3694  02bc 9a            RIM
3697  02bd               L3042:
3698                     ; 240     while((I2C_SR1 & I2C_SR1_RXNE) == 0);
3700  02bd c65217        	ld	a,_I2C_SR1
3701  02c0 a540          	bcp	a,#64
3702  02c2 27f9          	jreq	L3042
3703                     ; 242     *data++ = I2C_DR;
3705  02c4 1e05          	ldw	x,(OFST+5,sp)
3706  02c6 1c0001        	addw	x,#1
3707  02c9 1f05          	ldw	(OFST+5,sp),x
3708  02cb 1d0001        	subw	x,#1
3709  02ce c65216        	ld	a,_I2C_DR
3710  02d1 f7            	ld	(x),a
3711  02d2               L5232:
3712                     ; 245 	 I2C_CR2 |= I2C_CR2_STOP;
3714  02d2 72125211      	bset	_I2C_CR2,#1
3716  02d6               L1142:
3717                     ; 248   while((I2C_CR2 & I2C_CR2_STOP) == 0);
3719  02d6 c65211        	ld	a,_I2C_CR2
3720  02d9 a502          	bcp	a,#2
3721  02db 27f9          	jreq	L1142
3722                     ; 250   I2C_CR2 &= ~I2C_CR2_POS;
3724  02dd 72175211      	bres	_I2C_CR2,#3
3725                     ; 252   return I2C_SUCCESS;
3727  02e1 4f            	clr	a
3730  02e2 85            	popw	x
3731  02e3 81            	ret
3772                     ; 10 void timer1_start(void)
3772                     ; 11  {
3773                     	switch	.text
3774  02e4               _timer1_start:
3778                     ; 12    TIM1_CR1 |= TIM1_CR1_CEN; //Запускаем таймер
3780  02e4 72105250      	bset	_TIM1_CR1,#0
3781                     ; 13  }
3784  02e8 81            	ret
3821                     ; 15 void timer2_start(uint16_t top_val)
3821                     ; 16 {
3822                     	switch	.text
3823  02e9               _timer2_start:
3827                     ; 17   TIM2_ARRH =top_val >>8;
3829  02e9 9e            	ld	a,xh
3830  02ea c7530f        	ld	_TIM2_ARRH,a
3831                     ; 18   TIM2_ARRL =top_val & 0xFF;
3833  02ed 9f            	ld	a,xl
3834  02ee a4ff          	and	a,#255
3835  02f0 c75310        	ld	_TIM2_ARRL,a
3836                     ; 19   TIM2_CR1 |= TIM2_CR1_CEN;
3838  02f3 72105300      	bset	_TIM2_CR1,#0
3839                     ; 20 }
3842  02f7 81            	ret
3881                     ; 22 void Timer2_Overflow (void)
3881                     ; 23 {
3882                     	switch	.text
3883  02f8               _Timer2_Overflow:
3887                     ; 24 	TIM2_SR1 = 0;
3889  02f8 725f5304      	clr	_TIM2_SR1
3890                     ; 25 	if (schetchik ==1)
3892  02fc b606          	ld	a,_schetchik
3893  02fe a101          	cp	a,#1
3894  0300 267b          	jrne	L1742
3895                     ; 27 	switch (lamp_number)
3897  0302 b600          	ld	a,_lamp_number
3899                     ; 40 	break;
3900  0304 4d            	tnz	a
3901  0305 270b          	jreq	L1542
3902  0307 4a            	dec	a
3903  0308 270d          	jreq	L3542
3904  030a 4a            	dec	a
3905  030b 270f          	jreq	L5542
3906  030d 4a            	dec	a
3907  030e 2711          	jreq	L7542
3908  0310 2012          	jra	L5742
3909  0312               L1542:
3910                     ; 29 	case 0:
3910                     ; 30 	k155_data = hours_tens; 
3912  0312 450816        	mov	_k155_data,_hours_tens
3913                     ; 31 	break;
3915  0315 200d          	jra	L5742
3916  0317               L3542:
3917                     ; 32 	case 1:
3917                     ; 33 	k155_data = hours;
3919  0317 450d16        	mov	_k155_data,_hours
3920                     ; 34 	break;
3922  031a 2008          	jra	L5742
3923  031c               L5542:
3924                     ; 35 	case 2:
3924                     ; 36 	k155_data = minutes_tens;
3926  031c 450916        	mov	_k155_data,_minutes_tens
3927                     ; 37 	break;
3929  031f 2003          	jra	L5742
3930  0321               L7542:
3931                     ; 38 	case 3:
3931                     ; 39 	k155_data = minutes;
3933  0321 450c16        	mov	_k155_data,_minutes
3934                     ; 40 	break;
3936  0324               L5742:
3937                     ; 43 	if (lamp_number < 3)
3939  0324 b600          	ld	a,_lamp_number
3940  0326 a103          	cp	a,#3
3941  0328 2415          	jruge	L7742
3942                     ; 45 			lamp_number_data = (1<<(lamp_number++));
3944  032a b600          	ld	a,_lamp_number
3945  032c 97            	ld	xl,a
3946  032d 3c00          	inc	_lamp_number
3947  032f 9f            	ld	a,xl
3948  0330 5f            	clrw	x
3949  0331 97            	ld	xl,a
3950  0332 a601          	ld	a,#1
3951  0334 5d            	tnzw	x
3952  0335 2704          	jreq	L03
3953  0337               L23:
3954  0337 48            	sll	a
3955  0338 5a            	decw	x
3956  0339 26fc          	jrne	L23
3957  033b               L03:
3958  033b b715          	ld	_lamp_number_data,a
3960  033d 2017          	jra	L1052
3961  033f               L7742:
3962                     ; 47 		else if (lamp_number >= 3)
3964  033f b600          	ld	a,_lamp_number
3965  0341 a103          	cp	a,#3
3966  0343 2511          	jrult	L1052
3967                     ; 49 			lamp_number_data = (1<<(lamp_number));
3969  0345 b600          	ld	a,_lamp_number
3970  0347 5f            	clrw	x
3971  0348 97            	ld	xl,a
3972  0349 a601          	ld	a,#1
3973  034b 5d            	tnzw	x
3974  034c 2704          	jreq	L43
3975  034e               L63:
3976  034e 48            	sll	a
3977  034f 5a            	decw	x
3978  0350 26fc          	jrne	L63
3979  0352               L43:
3980  0352 b715          	ld	_lamp_number_data,a
3981                     ; 50 			lamp_number = 0;
3983  0354 3f00          	clr	_lamp_number
3984  0356               L1052:
3985                     ; 53 			timers_int_off();
3987  0356 cd0430        	call	_timers_int_off
3989                     ; 54 	PA_ODR &= (0<<3);
3991  0359 725f5000      	clr	_PA_ODR
3992                     ; 58 	spi_send(kostil_k155(k155_data));
3994  035d b616          	ld	a,_k155_data
3995  035f cd0492        	call	_kostil_k155
3997  0362 cd04b9        	call	_spi_send
3999                     ; 59 	spi_send(lamp_number_data | dots);
4001  0365 b615          	ld	a,_lamp_number_data
4002  0367 ba01          	or	a,_dots
4003  0369 cd04b9        	call	_spi_send
4006  036c               L7052:
4007                     ; 61 	while((SPI_SR & SPI_SR_BSY) != 0);
4009  036c c65203        	ld	a,_SPI_SR
4010  036f a580          	bcp	a,#128
4011  0371 26f9          	jrne	L7052
4012                     ; 62 	PA_ODR |= (1<<3);
4014  0373 72165000      	bset	_PA_ODR,#3
4015                     ; 63 	timers_int_on();
4017  0377 cd0439        	call	_timers_int_on
4019                     ; 65 	schetchik = 0;
4021  037a 3f06          	clr	_schetchik
4023  037c               L3152:
4024                     ; 97 	return;
4027  037c 81            	ret
4028  037d               L1742:
4029                     ; 69 		schetchik = 1;
4031  037d 35010006      	mov	_schetchik,#1
4032                     ; 70 	timers_int_off();
4034  0381 cd0430        	call	_timers_int_off
4036                     ; 71 	PA_ODR &= (0<<3);
4038  0384 725f5000      	clr	_PA_ODR
4039                     ; 75 	spi_send(kostil_k155(k155_data));
4041  0388 b616          	ld	a,_k155_data
4042  038a cd0492        	call	_kostil_k155
4044  038d cd04b9        	call	_spi_send
4046                     ; 76 	spi_send(0);
4048  0390 4f            	clr	a
4049  0391 cd04b9        	call	_spi_send
4052  0394               L7152:
4053                     ; 78 	while((SPI_SR & SPI_SR_BSY) != 0);
4055  0394 c65203        	ld	a,_SPI_SR
4056  0397 a580          	bcp	a,#128
4057  0399 26f9          	jrne	L7152
4058                     ; 79 	PA_ODR |= (1<<3);
4060  039b 72165000      	bset	_PA_ODR,#3
4061                     ; 80 	timers_int_on();
4063  039f cd0439        	call	_timers_int_on
4065  03a2 20d8          	jra	L3152
4091                     ; 100 void Timer1_Compare_1 (void)
4091                     ; 101 {
4092                     	switch	.text
4093  03a4               _Timer1_Compare_1:
4097                     ; 102 	TIM1_SR1 = 0;
4099  03a4 725f5255      	clr	_TIM1_SR1
4100                     ; 103 	dots = ~dots;
4102  03a8 3301          	cpl	_dots
4103                     ; 104 	dots &= 0b00010000;
4105  03aa b601          	ld	a,_dots
4106  03ac a410          	and	a,#16
4107  03ae b701          	ld	_dots,a
4108                     ; 105 	time_refresh();
4110  03b0 cd04e9        	call	_time_refresh
4112                     ; 106 }
4115  03b3 81            	ret
4165                     ; 109 void timer1_setup(uint16_t tim_freq, uint16_t top)
4165                     ; 110  {
4166                     	switch	.text
4167  03b4               _timer1_setup:
4169  03b4 89            	pushw	x
4170  03b5 5204          	subw	sp,#4
4171       00000004      OFST:	set	4
4174                     ; 111   TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
4176  03b7 cd0000        	call	c_uitolx
4178  03ba 96            	ldw	x,sp
4179  03bb 1c0001        	addw	x,#OFST-3
4180  03be cd0000        	call	c_rtol
4182  03c1 ae2400        	ldw	x,#9216
4183  03c4 bf02          	ldw	c_lreg+2,x
4184  03c6 ae00f4        	ldw	x,#244
4185  03c9 bf00          	ldw	c_lreg,x
4186  03cb 96            	ldw	x,sp
4187  03cc 1c0001        	addw	x,#OFST-3
4188  03cf cd0000        	call	c_ldiv
4190  03d2 a608          	ld	a,#8
4191  03d4 cd0000        	call	c_lrsh
4193  03d7 b603          	ld	a,c_lreg+3
4194  03d9 c75260        	ld	_TIM1_PSCRH,a
4195                     ; 112   TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; // 16 divider
4197  03dc 1e05          	ldw	x,(OFST+1,sp)
4198  03de cd0000        	call	c_uitolx
4200  03e1 96            	ldw	x,sp
4201  03e2 1c0001        	addw	x,#OFST-3
4202  03e5 cd0000        	call	c_rtol
4204  03e8 ae2400        	ldw	x,#9216
4205  03eb bf02          	ldw	c_lreg+2,x
4206  03ed ae00f4        	ldw	x,#244
4207  03f0 bf00          	ldw	c_lreg,x
4208  03f2 96            	ldw	x,sp
4209  03f3 1c0001        	addw	x,#OFST-3
4210  03f6 cd0000        	call	c_ldiv
4212  03f9 3f02          	clr	c_lreg+2
4213  03fb 3f01          	clr	c_lreg+1
4214  03fd 3f00          	clr	c_lreg
4215  03ff b603          	ld	a,c_lreg+3
4216  0401 c75261        	ld	_TIM1_PSCRL,a
4217                     ; 113   TIM1_ARRH = (top) >> 8; //	overflow frequency = 16М / 8 / 1000 = 2000 Гц
4219  0404 7b09          	ld	a,(OFST+5,sp)
4220  0406 c75262        	ld	_TIM1_ARRH,a
4221                     ; 114   TIM1_ARRL = (top)& 0xFF;
4223  0409 7b0a          	ld	a,(OFST+6,sp)
4224  040b a4ff          	and	a,#255
4225  040d c75263        	ld	_TIM1_ARRL,a
4226                     ; 116   TIM1_CR1 |= TIM1_CR1_URS; //only overflow int
4228  0410 72145250      	bset	_TIM1_CR1,#2
4229                     ; 117   TIM1_EGR |= TIM1_EGR_UG;  //call Update Event
4231  0414 72105257      	bset	_TIM1_EGR,#0
4232                     ; 118   TIM1_IER |= TIM1_IER_UIE; //int enable
4234  0418 72105254      	bset	_TIM1_IER,#0
4235                     ; 119  }
4238  041c 5b06          	addw	sp,#6
4239  041e 81            	ret
4266                     ; 122 void timer2_setup(void)
4266                     ; 123  {
4267                     	switch	.text
4268  041f               _timer2_setup:
4272                     ; 125     TIM2_IER |= TIM2_IER_UIE;	//overflow int   
4274  041f 72105303      	bset	_TIM2_IER,#0
4275                     ; 126     TIM2_PSCR = 1;
4277  0423 3501530e      	mov	_TIM2_PSCR,#1
4278                     ; 127     TIM2_ARRH = 0;
4280  0427 725f530f      	clr	_TIM2_ARRH
4281                     ; 128     TIM2_ARRL = 0;
4283  042b 725f5310      	clr	_TIM2_ARRL
4284                     ; 129  }
4287  042f 81            	ret
4312                     ; 132 void timers_int_off(void)
4312                     ; 133 {
4313                     	switch	.text
4314  0430               _timers_int_off:
4318                     ; 134 	TIM1_IER &= ~TIM1_IER_UIE;
4320  0430 72115254      	bres	_TIM1_IER,#0
4321                     ; 135 	TIM2_IER &= ~TIM2_IER_UIE;
4323  0434 72115303      	bres	_TIM2_IER,#0
4324                     ; 136 }
4327  0438 81            	ret
4352                     ; 138 void timers_int_on(void)
4352                     ; 139 {
4353                     	switch	.text
4354  0439               _timers_int_on:
4358                     ; 140 	TIM1_IER |= TIM1_IER_UIE;
4360  0439 72105254      	bset	_TIM1_IER,#0
4361                     ; 141 	TIM2_IER |= TIM2_IER_UIE;
4363  043d 72105303      	bset	_TIM2_IER,#0
4364                     ; 142 }
4367  0441 81            	ret
4416                     ; 1 void time_write(void)
4416                     ; 2 {
4417                     	switch	.text
4418  0442               _time_write:
4422                     ; 5 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
4424  0442 b614          	ld	a,_fresh_hours_dec
4425  0444 97            	ld	xl,a
4426  0445 a610          	ld	a,#16
4427  0447 42            	mul	x,a
4428  0448 9f            	ld	a,xl
4429  0449 bb13          	add	a,_fresh_hours
4430  044b b713          	ld	_fresh_hours,a
4431                     ; 6 	fresh_min = fresh_min + (fresh_min_dec<<4);
4433  044d b612          	ld	a,_fresh_min_dec
4434  044f 97            	ld	xl,a
4435  0450 a610          	ld	a,#16
4436  0452 42            	mul	x,a
4437  0453 9f            	ld	a,xl
4438  0454 bb11          	add	a,_fresh_min
4439  0456 b711          	ld	_fresh_min,a
4440                     ; 7 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
4442  0458 b610          	ld	a,_fresh_sec_dec
4443  045a 97            	ld	xl,a
4444  045b a610          	ld	a,#16
4445  045d 42            	mul	x,a
4446  045e 9f            	ld	a,xl
4447  045f bb0f          	add	a,_fresh_sec
4448  0461 b70f          	ld	_fresh_sec,a
4449                     ; 8 	timers_int_off();
4451  0463 adcb          	call	_timers_int_off
4453                     ; 9 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
4455  0465 4b01          	push	#1
4456  0467 ae0013        	ldw	x,#_fresh_hours
4457  046a 89            	pushw	x
4458  046b aed002        	ldw	x,#53250
4459  046e cd013e        	call	_i2c_wr_reg
4461  0471 5b03          	addw	sp,#3
4462                     ; 10 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
4464  0473 4b01          	push	#1
4465  0475 ae0011        	ldw	x,#_fresh_min
4466  0478 89            	pushw	x
4467  0479 aed001        	ldw	x,#53249
4468  047c cd013e        	call	_i2c_wr_reg
4470  047f 5b03          	addw	sp,#3
4471                     ; 11 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
4473  0481 4b01          	push	#1
4474  0483 ae000f        	ldw	x,#_fresh_sec
4475  0486 89            	pushw	x
4476  0487 aed000        	ldw	x,#53248
4477  048a cd013e        	call	_i2c_wr_reg
4479  048d 5b03          	addw	sp,#3
4480                     ; 12 	timers_int_on();
4482  048f ada8          	call	_timers_int_on
4484                     ; 13 }
4487  0491 81            	ret
4539                     ; 15 uint8_t kostil_k155 (uint8_t byte)
4539                     ; 16 {
4540                     	switch	.text
4541  0492               _kostil_k155:
4543  0492 88            	push	a
4544  0493 89            	pushw	x
4545       00000002      OFST:	set	2
4548                     ; 17 	uint8_t tmp = (byte<<1) & 0b00001100;
4550  0494 48            	sll	a
4551  0495 a40c          	and	a,#12
4552  0497 6b01          	ld	(OFST-1,sp),a
4553                     ; 18 	uint8_t tmp2 = (byte>>2) & 0b00000010;
4555  0499 7b03          	ld	a,(OFST+1,sp)
4556  049b 44            	srl	a
4557  049c 44            	srl	a
4558  049d a402          	and	a,#2
4559  049f 6b02          	ld	(OFST+0,sp),a
4560                     ; 19 	byte &= 1;
4562  04a1 7b03          	ld	a,(OFST+1,sp)
4563  04a3 a401          	and	a,#1
4564  04a5 6b03          	ld	(OFST+1,sp),a
4565                     ; 20 	byte |= tmp | tmp2;
4567  04a7 7b01          	ld	a,(OFST-1,sp)
4568  04a9 1a02          	or	a,(OFST+0,sp)
4569  04ab 1a03          	or	a,(OFST+1,sp)
4570  04ad 6b03          	ld	(OFST+1,sp),a
4571                     ; 21 	return byte;
4573  04af 7b03          	ld	a,(OFST+1,sp)
4576  04b1 5b03          	addw	sp,#3
4577  04b3 81            	ret
4618                     ; 1 void spi_setup(void)
4618                     ; 2  {
4619                     	switch	.text
4620  04b4               _spi_setup:
4624                     ; 3     SPI_CR1= 0b01110100;//0x7C;       //this
4626  04b4 35745200      	mov	_SPI_CR1,#116
4627                     ; 5  }
4630  04b8 81            	ret
4666                     ; 8 void spi_send(uint8_t msg)
4666                     ; 9 {
4667                     	switch	.text
4668  04b9               _spi_send:
4670  04b9 88            	push	a
4671       00000000      OFST:	set	0
4674  04ba               L7072:
4675                     ; 11 	while((SPI_SR & SPI_SR_BSY) != 0)
4677  04ba c65203        	ld	a,_SPI_SR
4678  04bd a580          	bcp	a,#128
4679  04bf 26f9          	jrne	L7072
4680                     ; 14 	SPI_DR = msg;
4682  04c1 7b01          	ld	a,(OFST+1,sp)
4683  04c3 c75204        	ld	_SPI_DR,a
4684                     ; 15 }
4687  04c6 84            	pop	a
4688  04c7 81            	ret
4730                     ; 4 void UART_Resieved (void)
4730                     ; 5 {
4731                     	switch	.text
4732  04c8               _UART_Resieved:
4736                     ; 6 	uart_routine(UART1_DR);
4738  04c8 c65231        	ld	a,_UART1_DR
4739  04cb cd002a        	call	_uart_routine
4741                     ; 7 }
4744  04ce 81            	ret
4769                     ; 9 void SPI_Transmitted(void)
4769                     ; 10 {
4770                     	switch	.text
4771  04cf               _SPI_Transmitted:
4775                     ; 11 	spi_send(temp3);
4777  04cf b605          	ld	a,_temp3
4778  04d1 ade6          	call	_spi_send
4780                     ; 12 }
4783  04d3 81            	ret
4806                     ; 14 void I2C_Event(void)
4806                     ; 15 {
4807                     	switch	.text
4808  04d4               _I2C_Event:
4812                     ; 17 }
4815  04d4 81            	ret
4841                     ; 19 void Keys_switched(void)
4841                     ; 20 {
4842                     	switch	.text
4843  04d5               _Keys_switched:
4847                     ; 21 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
4849  04d5 c650a0        	ld	a,_EXTI_CR1
4850  04d8 43            	cpl	a
4851  04d9 a430          	and	a,#48
4852  04db c750a0        	ld	_EXTI_CR1,a
4853                     ; 22 	PC_CR2 = 0;
4855  04de 725f500e      	clr	_PC_CR2
4856                     ; 23 	timer2_start(0xff);	
4858  04e2 ae00ff        	ldw	x,#255
4859  04e5 cd02e9        	call	_timer2_start
4861                     ; 24 }
4864  04e8 81            	ret
4899                     ; 26 void time_refresh (void)
4899                     ; 27 {
4900                     	switch	.text
4901  04e9               _time_refresh:
4905                     ; 29 	timers_int_off();
4907  04e9 cd0430        	call	_timers_int_off
4909                     ; 30 	i2c_rd_reg(0xD0, 0, &fresh_sec, 1); 	
4911  04ec 4b01          	push	#1
4912  04ee ae000f        	ldw	x,#_fresh_sec
4913  04f1 89            	pushw	x
4914  04f2 aed000        	ldw	x,#53248
4915  04f5 cd01a1        	call	_i2c_rd_reg
4917  04f8 5b03          	addw	sp,#3
4918                     ; 31 	i2c_rd_reg(0xD0, 1, &fresh_min, 1);
4920  04fa 4b01          	push	#1
4921  04fc ae0011        	ldw	x,#_fresh_min
4922  04ff 89            	pushw	x
4923  0500 aed001        	ldw	x,#53249
4924  0503 cd01a1        	call	_i2c_rd_reg
4926  0506 5b03          	addw	sp,#3
4927                     ; 32 	i2c_rd_reg(0xD0, 2, &fresh_hours, 1);
4929  0508 4b01          	push	#1
4930  050a ae0013        	ldw	x,#_fresh_hours
4931  050d 89            	pushw	x
4932  050e aed002        	ldw	x,#53250
4933  0511 cd01a1        	call	_i2c_rd_reg
4935  0514 5b03          	addw	sp,#3
4936                     ; 33 	timers_int_on();
4938  0516 cd0439        	call	_timers_int_on
4940                     ; 35 	seconds_tens = (fresh_sec & 0xf0)>>4;
4942  0519 b60f          	ld	a,_fresh_sec
4943  051b a4f0          	and	a,#240
4944  051d 4e            	swap	a
4945  051e a40f          	and	a,#15
4946  0520 b70a          	ld	_seconds_tens,a
4947                     ; 36 	minutes_tens = (fresh_min & 0xf0)>>4;
4949  0522 b611          	ld	a,_fresh_min
4950  0524 a4f0          	and	a,#240
4951  0526 4e            	swap	a
4952  0527 a40f          	and	a,#15
4953  0529 b709          	ld	_minutes_tens,a
4954                     ; 37 	hours_tens = (fresh_hours & 0xf0)>>4;
4956  052b b613          	ld	a,_fresh_hours
4957  052d a4f0          	and	a,#240
4958  052f 4e            	swap	a
4959  0530 a40f          	and	a,#15
4960  0532 b708          	ld	_hours_tens,a
4961                     ; 39 	seconds = fresh_sec & 0x0f;
4963  0534 b60f          	ld	a,_fresh_sec
4964  0536 a40f          	and	a,#15
4965  0538 b70b          	ld	_seconds,a
4966                     ; 40 	minutes = fresh_min & 0x0f;
4968  053a b611          	ld	a,_fresh_min
4969  053c a40f          	and	a,#15
4970  053e b70c          	ld	_minutes,a
4971                     ; 41 	hours = fresh_hours & 0x0f;
4973  0540 b613          	ld	a,_fresh_hours
4974  0542 a40f          	and	a,#15
4975  0544 b70d          	ld	_hours,a
4976                     ; 42 }
4979  0546 81            	ret
5046                     ; 21 int main( void )
5046                     ; 22 {
5047                     	switch	.text
5048  0547               _main:
5052                     ; 24 		CLK_CKDIVR=0;                //	no dividers
5054  0547 725f50c6      	clr	_CLK_CKDIVR
5055                     ; 25 		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //clocking for TIM1, UART1, SPI i I2C
5057  054b 35ff50c7      	mov	_CLK_PCKENR1,#255
5058                     ; 28     PA_DDR=(1<<3) | (1<<2); //0b000001000; //output for register's latch, input for RTC 1 Hz pulse
5060  054f 350c5002      	mov	_PA_DDR,#12
5061                     ; 29     PA_CR1= 0xff;        //	pull-up on inputs, push-pull on outputs
5063  0553 35ff5003      	mov	_PA_CR1,#255
5064                     ; 30     PA_ODR |= (1<<3);
5066  0557 72165000      	bset	_PA_ODR,#3
5067                     ; 31 		PA_CR2 |=(1<<3);        //	interrupt on PA1 for 1hz
5069  055b 72165004      	bset	_PA_CR2,#3
5070                     ; 33     PC_DDR=0x60; //0b01100000; // buttons pins as input
5072  055f 3560500c      	mov	_PC_DDR,#96
5073                     ; 34     PC_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5075  0563 35ff500d      	mov	_PC_CR1,#255
5076                     ; 35     PC_CR2 |= (1<<4) | (1<<3);        //	interrapts for buttons
5078  0567 c6500e        	ld	a,_PC_CR2
5079  056a aa18          	or	a,#24
5080  056c c7500e        	ld	_PC_CR2,a
5081                     ; 37 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM
5083  056f 35a85011      	mov	_PD_DDR,#168
5084                     ; 38     PD_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5086  0573 35ff5012      	mov	_PD_CR1,#255
5087                     ; 39     PD_ODR = (1 << 3);
5089  0577 3508500f      	mov	_PD_ODR,#8
5090                     ; 43     spi_setup();
5092  057b cd04b4        	call	_spi_setup
5094                     ; 46 		uart_setup();
5096  057e cd0000        	call	_uart_setup
5098                     ; 47 		uart_send('h');
5100  0581 a668          	ld	a,#104
5101  0583 cd0019        	call	_uart_send
5103                     ; 50     timer1_setup( 65500,0xffff);//	freq in hz and top value
5105  0586 aeffff        	ldw	x,#65535
5106  0589 89            	pushw	x
5107  058a aeffdc        	ldw	x,#65500
5108  058d cd03b4        	call	_timer1_setup
5110  0590 85            	popw	x
5111                     ; 51 		timer2_setup();
5113  0591 cd041f        	call	_timer2_setup
5115                     ; 52 		timer1_start();
5117  0594 cd02e4        	call	_timer1_start
5119                     ; 53 		timer2_start(TIM2_TOP);
5121  0597 ae6d60        	ldw	x,#28000
5122  059a cd02e9        	call	_timer2_start
5124                     ; 57 		i2c_master_init(16000000, 50000);
5126  059d aec350        	ldw	x,#50000
5127  05a0 89            	pushw	x
5128  05a1 ae0000        	ldw	x,#0
5129  05a4 89            	pushw	x
5130  05a5 ae2400        	ldw	x,#9216
5131  05a8 89            	pushw	x
5132  05a9 ae00f4        	ldw	x,#244
5133  05ac 89            	pushw	x
5134  05ad cd00bc        	call	_i2c_master_init
5136  05b0 5b08          	addw	sp,#8
5137                     ; 60 		timers_int_off();
5139  05b2 cd0430        	call	_timers_int_off
5141                     ; 62 		i2c_rd_reg(ds_address, 7, &temp, 1);
5143  05b5 4b01          	push	#1
5144  05b7 ae0002        	ldw	x,#_temp
5145  05ba 89            	pushw	x
5146  05bb aed007        	ldw	x,#53255
5147  05be cd01a1        	call	_i2c_rd_reg
5149  05c1 5b03          	addw	sp,#3
5150                     ; 63 	if (temp != 0b10010000)	// if OUT and SWQ == 0
5152  05c3 b602          	ld	a,_temp
5153  05c5 a190          	cp	a,#144
5154  05c7 270e          	jreq	L7003
5155                     ; 65 			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//	setup RTC for 1Hz output
5157  05c9 4b01          	push	#1
5158  05cb ae0007        	ldw	x,#_ds_cr
5159  05ce 89            	pushw	x
5160  05cf aed007        	ldw	x,#53255
5161  05d2 cd013e        	call	_i2c_wr_reg
5163  05d5 5b03          	addw	sp,#3
5164  05d7               L7003:
5165                     ; 68 		i2c_rd_reg(ds_address, 0, &temp, 1);
5167  05d7 4b01          	push	#1
5168  05d9 ae0002        	ldw	x,#_temp
5169  05dc 89            	pushw	x
5170  05dd aed000        	ldw	x,#53248
5171  05e0 cd01a1        	call	_i2c_rd_reg
5173  05e3 5b03          	addw	sp,#3
5174                     ; 71 	if((temp & 0x80) == 0x80)
5176  05e5 b602          	ld	a,_temp
5177  05e7 a480          	and	a,#128
5178  05e9 a180          	cp	a,#128
5179  05eb 2610          	jrne	L1103
5180                     ; 73 		temp = 0;
5182  05ed 3f02          	clr	_temp
5183                     ; 74 		i2c_wr_reg(ds_address, 0, &temp, 1);
5185  05ef 4b01          	push	#1
5186  05f1 ae0002        	ldw	x,#_temp
5187  05f4 89            	pushw	x
5188  05f5 aed000        	ldw	x,#53248
5189  05f8 cd013e        	call	_i2c_wr_reg
5191  05fb 5b03          	addw	sp,#3
5192  05fd               L1103:
5193                     ; 76 		timers_int_on();
5195  05fd cd0439        	call	_timers_int_on
5197                     ; 78 		_asm ("RIM");  //on interupts
5200  0600 9a            RIM
5202  0601               L3103:
5204  0601 20fe          	jra	L3103
5217                     	xdef	_main
5218                     	xdef	_Keys_switched
5219                     	xdef	_I2C_Event
5220                     	xdef	_SPI_Transmitted
5221                     	xdef	_UART_Resieved
5222                     	xdef	_spi_setup
5223                     	xdef	_timer2_setup
5224                     	xdef	_timer1_setup
5225                     	xdef	_Timer1_Compare_1
5226                     	xdef	_Timer2_Overflow
5227                     	xdef	_timer2_start
5228                     	xdef	_timer1_start
5229                     	xdef	_kostil_k155
5230                     	xdef	_time_refresh
5231                     	xdef	_timers_int_on
5232                     	xdef	_timers_int_off
5233                     	xdef	_spi_send
5234                     	xdef	_i2c_rd_reg
5235                     	xdef	_i2c_wr_reg
5236                     	xdef	_i2c_master_init
5237                     	xdef	_Key_interrupt
5238                     	xdef	_uart_routine
5239                     	xdef	_uart_send
5240                     	xdef	_uart_setup
5241                     	xdef	_time_write
5242                     	switch	.ubsct
5243  0000               _i2c_flags:
5244  0000 00            	ds.b	1
5245                     	xdef	_i2c_flags
5246  0001               _flags:
5247  0001 00            	ds.b	1
5248                     	xdef	_flags
5249                     	xdef	_ds_cr
5250                     	xdef	_schetchik
5251                     	xdef	_temp3
5252                     	xdef	_temp2
5253  0002               _temp:
5254  0002 00            	ds.b	1
5255                     	xdef	_temp
5256  0003               _pins:
5257  0003 00            	ds.b	1
5258                     	xdef	_pins
5259  0004               _fresh_data_pointer:
5260  0004 0000          	ds.b	2
5261                     	xdef	_fresh_data_pointer
5262  0006               _data_pointer:
5263  0006 0000          	ds.b	2
5264                     	xdef	_data_pointer
5265                     	xdef	_time_pointer
5266  0008               _hours_tens:
5267  0008 00            	ds.b	1
5268                     	xdef	_hours_tens
5269  0009               _minutes_tens:
5270  0009 00            	ds.b	1
5271                     	xdef	_minutes_tens
5272  000a               _seconds_tens:
5273  000a 00            	ds.b	1
5274                     	xdef	_seconds_tens
5275  000b               _seconds:
5276  000b 00            	ds.b	1
5277                     	xdef	_seconds
5278  000c               _minutes:
5279  000c 00            	ds.b	1
5280                     	xdef	_minutes
5281  000d               _hours:
5282  000d 00            	ds.b	1
5283                     	xdef	_hours
5284  000e               _timeset:
5285  000e 00            	ds.b	1
5286                     	xdef	_timeset
5287  000f               _fresh_sec:
5288  000f 00            	ds.b	1
5289                     	xdef	_fresh_sec
5290  0010               _fresh_sec_dec:
5291  0010 00            	ds.b	1
5292                     	xdef	_fresh_sec_dec
5293  0011               _fresh_min:
5294  0011 00            	ds.b	1
5295                     	xdef	_fresh_min
5296  0012               _fresh_min_dec:
5297  0012 00            	ds.b	1
5298                     	xdef	_fresh_min_dec
5299  0013               _fresh_hours:
5300  0013 00            	ds.b	1
5301                     	xdef	_fresh_hours
5302  0014               _fresh_hours_dec:
5303  0014 00            	ds.b	1
5304                     	xdef	_fresh_hours_dec
5305  0015               _lamp_number_data:
5306  0015 00            	ds.b	1
5307                     	xdef	_lamp_number_data
5308  0016               _k155_data:
5309  0016 00            	ds.b	1
5310                     	xdef	_k155_data
5311                     	xdef	_dots
5312                     	xdef	_lamp_number
5313                     	xref.b	c_lreg
5314                     	xref.b	c_x
5334                     	xref	c_lrsh
5335                     	xref	c_ldiv
5336                     	xref	c_uitolx
5337                     	xref	c_ludv
5338                     	xref	c_rtol
5339                     	xref	c_ltor
5340                     	end
