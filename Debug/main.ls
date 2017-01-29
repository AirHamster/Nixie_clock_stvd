   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2184                     	bsct
2185  0000               _lamp_number:
2186  0000 00            	dc.b	0
2187  0001               _dots:
2188  0001 10            	dc.b	16
2189  0002               _dots_upd:
2190  0002 1f40          	dc.w	8000
2191  0004               _dots_on:
2192  0004 0001          	dc.w	1
2193  0006               _time_pointer:
2194  0006 000b          	dc.w	_seconds
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
2685                     ; 2  void uart_setup(void)
2685                     ; 3  {
2687                     	switch	.text
2688  0000               _uart_setup:
2692                     ; 4 		UART1_BRR1=0x68;     //9600 bod
2694  0000 35685232      	mov	_UART1_BRR1,#104
2695                     ; 5     UART1_BRR2=0x03;
2697  0004 35035233      	mov	_UART1_BRR2,#3
2698                     ; 6     UART1_CR2 |= UART1_CR2_REN; //reseiving
2700  0008 72145235      	bset	_UART1_CR2,#2
2701                     ; 7     UART1_CR2 |= UART1_CR2_TEN; //transmiting 
2703  000c 72165235      	bset	_UART1_CR2,#3
2704                     ; 8     UART1_CR2 |= UART1_CR2_RIEN; //reseive int
2706  0010 721a5235      	bset	_UART1_CR2,#5
2707                     ; 9 		UART1_SR = 0;
2709  0014 725f5230      	clr	_UART1_SR
2710                     ; 10  }
2713  0018 81            	ret
2750                     ; 12 void uart_send(uint8_t msg)
2750                     ; 13  {
2751                     	switch	.text
2752  0019               _uart_send:
2754  0019 88            	push	a
2755       00000000      OFST:	set	0
2758                     ; 14 	 temp =msg;
2760  001a b702          	ld	_temp,a
2762  001c               L7671:
2763                     ; 15 	 while((UART1_SR & 0x80) == 0x00);
2765  001c c65230        	ld	a,_UART1_SR
2766  001f a580          	bcp	a,#128
2767  0021 27f9          	jreq	L7671
2768                     ; 16 	 UART1_DR = msg;
2770  0023 7b01          	ld	a,(OFST+1,sp)
2771  0025 c75231        	ld	_UART1_DR,a
2772                     ; 17  }
2775  0028 84            	pop	a
2776  0029 81            	ret
2822                     ; 18  void uart_routine(uint8_t data)
2822                     ; 19  {
2823                     	switch	.text
2824  002a               _uart_routine:
2826  002a 88            	push	a
2827       00000000      OFST:	set	0
2830                     ; 21 	 temp2 = data - 0x30;
2832  002b a030          	sub	a,#48
2833  002d b708          	ld	_temp2,a
2834                     ; 22 	 if (timeset != 0 && timeset <= 5)
2836  002f 3d0e          	tnz	_timeset
2837  0031 2719          	jreq	L1102
2839  0033 b60e          	ld	a,_timeset
2840  0035 a106          	cp	a,#6
2841  0037 2413          	jruge	L1102
2842                     ; 24 		* fresh_data_pointer-- = data-0x30;
2844  0039 7b01          	ld	a,(OFST+1,sp)
2845  003b a030          	sub	a,#48
2846  003d be04          	ldw	x,_fresh_data_pointer
2847  003f 1d0001        	subw	x,#1
2848  0042 bf04          	ldw	_fresh_data_pointer,x
2849  0044 1c0001        	addw	x,#1
2850  0047 f7            	ld	(x),a
2851                     ; 25 		 timeset++;
2853  0048 3c0e          	inc	_timeset
2854                     ; 26 		 return ;
2857  004a 84            	pop	a
2858  004b 81            	ret
2859  004c               L1102:
2860                     ; 28 	 if (timeset == 6)
2862  004c b60e          	ld	a,_timeset
2863  004e a106          	cp	a,#6
2864  0050 2616          	jrne	L3102
2865                     ; 30 		 *fresh_data_pointer = data-0x30;
2867  0052 7b01          	ld	a,(OFST+1,sp)
2868  0054 a030          	sub	a,#48
2869  0056 92c704        	ld	[_fresh_data_pointer.w],a
2870                     ; 31 		 timeset = 0;
2872  0059 3f0e          	clr	_timeset
2873                     ; 32 		 time_write();
2875  005b cd04a3        	call	_time_write
2877                     ; 33 		 uart_send('O');
2879  005e a64f          	ld	a,#79
2880  0060 adb7          	call	_uart_send
2882                     ; 34 		 uart_send('K');
2884  0062 a64b          	ld	a,#75
2885  0064 adb3          	call	_uart_send
2887                     ; 35 		 return;
2890  0066 84            	pop	a
2891  0067 81            	ret
2892  0068               L3102:
2893                     ; 38 	 if (data == 's')
2895  0068 7b01          	ld	a,(OFST+1,sp)
2896  006a a173          	cp	a,#115
2897  006c 260b          	jrne	L5102
2898                     ; 40 			timeset = 1;
2900  006e 3501000e      	mov	_timeset,#1
2901                     ; 41 			fresh_data_pointer = &fresh_hours_dec;
2903  0072 ae0014        	ldw	x,#_fresh_hours_dec
2904  0075 bf04          	ldw	_fresh_data_pointer,x
2905                     ; 42 			return;
2908  0077 84            	pop	a
2909  0078 81            	ret
2910  0079               L5102:
2911                     ; 46 		if (data == 't')
2913  0079 7b01          	ld	a,(OFST+1,sp)
2914  007b a174          	cp	a,#116
2915  007d 2635          	jrne	L7102
2916                     ; 48 			uart_send(hours_tens+0x30);
2918  007f b608          	ld	a,_hours_tens
2919  0081 ab30          	add	a,#48
2920  0083 ad94          	call	_uart_send
2922                     ; 49 			uart_send(hours+0x30);
2924  0085 b60d          	ld	a,_hours
2925  0087 ab30          	add	a,#48
2926  0089 ad8e          	call	_uart_send
2928                     ; 50 			uart_send(':');	
2930  008b a63a          	ld	a,#58
2931  008d ad8a          	call	_uart_send
2933                     ; 51 			uart_send(minutes_tens+0x30);
2935  008f b609          	ld	a,_minutes_tens
2936  0091 ab30          	add	a,#48
2937  0093 ad84          	call	_uart_send
2939                     ; 52 			uart_send(minutes+0x30);
2941  0095 b60c          	ld	a,_minutes
2942  0097 ab30          	add	a,#48
2943  0099 cd0019        	call	_uart_send
2945                     ; 53 			uart_send(':'); 
2947  009c a63a          	ld	a,#58
2948  009e cd0019        	call	_uart_send
2950                     ; 54 			uart_send(seconds_tens+0x30);
2952  00a1 b60a          	ld	a,_seconds_tens
2953  00a3 ab30          	add	a,#48
2954  00a5 cd0019        	call	_uart_send
2956                     ; 55 			uart_send(seconds+0x30);
2958  00a8 b60b          	ld	a,_seconds
2959  00aa ab30          	add	a,#48
2960  00ac cd0019        	call	_uart_send
2962                     ; 56 			uart_send(0x0A);
2964  00af a60a          	ld	a,#10
2965  00b1 cd0019        	call	_uart_send
2967  00b4               L7102:
2968                     ; 58 	}
2971  00b4 84            	pop	a
2972  00b5 81            	ret
3014                     ; 1  void Key_interrupt (void)
3014                     ; 2 {
3015                     	switch	.text
3016  00b6               _Key_interrupt:
3020                     ; 4   pins = PC_IDR;
3022  00b6 55500b0003    	mov	_pins,_PC_IDR
3023                     ; 5 }
3026  00bb 81            	ret
3105                     ; 7 void i2c_master_init(unsigned long f_master_hz, unsigned long f_i2c_hz){
3106                     	switch	.text
3107  00bc               _i2c_master_init:
3109  00bc 5208          	subw	sp,#8
3110       00000008      OFST:	set	8
3113                     ; 9 	I2C_CR1 &= ~I2C_CR1_PE;
3115  00be 72115210      	bres	_I2C_CR1,#0
3116                     ; 10 	I2C_CR2 |= I2C_CR2_SWRST;
3118  00c2 721e5211      	bset	_I2C_CR2,#7
3119                     ; 11   PB_DDR = (0<<4);//PB_DDR_DDR4);
3121  00c6 725f5007      	clr	_PB_DDR
3122                     ; 12 	PB_DDR = (0<<5);//PB_DDR_DDR5);
3124  00ca 725f5007      	clr	_PB_DDR
3125                     ; 13 	PB_ODR = (1<<5);//PB_ODR_ODR5);  //SDA
3127  00ce 35205005      	mov	_PB_ODR,#32
3128                     ; 14   PB_ODR = (1<<4);//PB_ODR_ODR4);  //SCL
3130  00d2 35105005      	mov	_PB_ODR,#16
3131                     ; 16   PB_CR1 = (0<<4);//PB_CR1_C14);
3133  00d6 725f5008      	clr	_PB_CR1
3134                     ; 17   PB_CR1 = (0<<5);//PB_CR1_C15);
3136  00da 725f5008      	clr	_PB_CR1
3137                     ; 19   PB_CR2 = (0<<4);//PB_CR1_C24);
3139  00de 725f5009      	clr	_PB_CR2
3140                     ; 20   PB_CR2 = (0<<5);//PB_CR1_C25);
3142  00e2 725f5009      	clr	_PB_CR2
3143                     ; 21   I2C_CR2 &= ~I2C_CR2_SWRST;
3145  00e6 721f5211      	bres	_I2C_CR2,#7
3146                     ; 23   I2C_FREQR = 16;
3148  00ea 35105212      	mov	_I2C_FREQR,#16
3149                     ; 28   I2C_CCRH |=~I2C_CCRH_FS;
3151  00ee c6521c        	ld	a,_I2C_CCRH
3152  00f1 aa7f          	or	a,#127
3153  00f3 c7521c        	ld	_I2C_CCRH,a
3154                     ; 30   ccr = f_master_hz/(2*f_i2c_hz);
3156  00f6 96            	ldw	x,sp
3157  00f7 1c000f        	addw	x,#OFST+7
3158  00fa cd0000        	call	c_ltor
3160  00fd 3803          	sll	c_lreg+3
3161  00ff 3902          	rlc	c_lreg+2
3162  0101 3901          	rlc	c_lreg+1
3163  0103 3900          	rlc	c_lreg
3164  0105 96            	ldw	x,sp
3165  0106 1c0001        	addw	x,#OFST-7
3166  0109 cd0000        	call	c_rtol
3168  010c 96            	ldw	x,sp
3169  010d 1c000b        	addw	x,#OFST+3
3170  0110 cd0000        	call	c_ltor
3172  0113 96            	ldw	x,sp
3173  0114 1c0001        	addw	x,#OFST-7
3174  0117 cd0000        	call	c_ludv
3176  011a 96            	ldw	x,sp
3177  011b 1c0005        	addw	x,#OFST-3
3178  011e cd0000        	call	c_rtol
3180                     ; 34   I2C_TRISER = 12+1;
3182  0121 350d521d      	mov	_I2C_TRISER,#13
3183                     ; 35   I2C_CCRL = ccr & 0xFF;
3185  0125 7b08          	ld	a,(OFST+0,sp)
3186  0127 a4ff          	and	a,#255
3187  0129 c7521b        	ld	_I2C_CCRL,a
3188                     ; 36   I2C_CCRH = ((ccr >> 8) & 0x0F);
3190  012c 7b07          	ld	a,(OFST-1,sp)
3191  012e a40f          	and	a,#15
3192  0130 c7521c        	ld	_I2C_CCRH,a
3193                     ; 39   I2C_CR1 |=I2C_CR1_PE;
3195  0133 72105210      	bset	_I2C_CR1,#0
3196                     ; 42   I2C_CR2 |=I2C_CR2_ACK;
3198  0137 72145211      	bset	_I2C_CR2,#2
3199                     ; 43 }
3202  013b 5b08          	addw	sp,#8
3203  013d 81            	ret
3297                     ; 49 t_i2c_status i2c_wr_reg(unsigned char address, unsigned char reg_addr,
3297                     ; 50                               char * data, unsigned char length)
3297                     ; 51 {                                  
3298                     	switch	.text
3299  013e               _i2c_wr_reg:
3301  013e 89            	pushw	x
3302       00000000      OFST:	set	0
3305  013f               L1412:
3306                     ; 55   while((I2C_SR3 & I2C_SR3_BUSY) !=0);   
3308  013f c65219        	ld	a,_I2C_SR3
3309  0142 a502          	bcp	a,#2
3310  0144 26f9          	jrne	L1412
3311                     ; 57   I2C_CR2 |= I2C_CR2_START;
3313  0146 72105211      	bset	_I2C_CR2,#0
3315  014a               L7412:
3316                     ; 60   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3318  014a c65217        	ld	a,_I2C_SR1
3319  014d a501          	bcp	a,#1
3320  014f 27f9          	jreq	L7412
3321                     ; 63   I2C_DR = address & 0xFE;
3323  0151 7b01          	ld	a,(OFST+1,sp)
3324  0153 a4fe          	and	a,#254
3325  0155 c75216        	ld	_I2C_DR,a
3327  0158               L7512:
3328                     ; 66 	while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3330  0158 c65217        	ld	a,_I2C_SR1
3331  015b a502          	bcp	a,#2
3332  015d 27f9          	jreq	L7512
3333                     ; 68   I2C_SR3;
3335  015f c65219        	ld	a,_I2C_SR3
3337  0162               L5612:
3338                     ; 73   while((I2C_SR1 & I2C_SR1_TXE) ==0);
3340  0162 c65217        	ld	a,_I2C_SR1
3341  0165 a580          	bcp	a,#128
3342  0167 27f9          	jreq	L5612
3343                     ; 75   I2C_DR = reg_addr;
3345  0169 7b02          	ld	a,(OFST+2,sp)
3346  016b c75216        	ld	_I2C_DR,a
3348  016e 2015          	jra	L5712
3349  0170               L3022:
3350                     ; 81     while((I2C_SR1 & I2C_SR1_TXE) == 0);
3352  0170 c65217        	ld	a,_I2C_SR1
3353  0173 a580          	bcp	a,#128
3354  0175 27f9          	jreq	L3022
3355                     ; 83     I2C_DR = *data++;
3357  0177 1e05          	ldw	x,(OFST+5,sp)
3358  0179 1c0001        	addw	x,#1
3359  017c 1f05          	ldw	(OFST+5,sp),x
3360  017e 1d0001        	subw	x,#1
3361  0181 f6            	ld	a,(x)
3362  0182 c75216        	ld	_I2C_DR,a
3363  0185               L5712:
3364                     ; 78   while(length--){
3366  0185 7b07          	ld	a,(OFST+7,sp)
3367  0187 0a07          	dec	(OFST+7,sp)
3368  0189 4d            	tnz	a
3369  018a 26e4          	jrne	L3022
3371  018c               L1122:
3372                     ; 88   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3374  018c c65217        	ld	a,_I2C_SR1
3375  018f a584          	bcp	a,#132
3376  0191 27f9          	jreq	L1122
3377                     ; 90   I2C_CR2 |= I2C_CR2_STOP;
3379  0193 72125211      	bset	_I2C_CR2,#1
3381  0197               L7122:
3382                     ; 93   while((I2C_CR2 & I2C_CR2_STOP) == 0); 
3384  0197 c65211        	ld	a,_I2C_CR2
3385  019a a502          	bcp	a,#2
3386  019c 27f9          	jreq	L7122
3387                     ; 94   return I2C_SUCCESS;
3389  019e 4f            	clr	a
3392  019f 85            	popw	x
3393  01a0 81            	ret
3463                     ; 101 t_i2c_status i2c_rd_reg(unsigned char address, unsigned char reg_addr,
3463                     ; 102                               char * data, unsigned char length)
3463                     ; 103 {
3464                     	switch	.text
3465  01a1               _i2c_rd_reg:
3467  01a1 89            	pushw	x
3468       00000000      OFST:	set	0
3471  01a2               L7522:
3472                     ; 109   while((I2C_SR3 & I2C_SR3_BUSY) != 0);   
3474  01a2 c65219        	ld	a,_I2C_SR3
3475  01a5 a502          	bcp	a,#2
3476  01a7 26f9          	jrne	L7522
3477                     ; 111   I2C_CR2 |= I2C_CR2_ACK;
3479  01a9 72145211      	bset	_I2C_CR2,#2
3480                     ; 114   I2C_CR2 |= I2C_CR2_START;
3482  01ad 72105211      	bset	_I2C_CR2,#0
3484  01b1               L5622:
3485                     ; 117   while((I2C_SR1 & I2C_SR1_SB) == 0);  
3487  01b1 c65217        	ld	a,_I2C_SR1
3488  01b4 a501          	bcp	a,#1
3489  01b6 27f9          	jreq	L5622
3490                     ; 119   I2C_DR = address & 0xFE;
3492  01b8 7b01          	ld	a,(OFST+1,sp)
3493  01ba a4fe          	and	a,#254
3494  01bc c75216        	ld	_I2C_DR,a
3496  01bf               L5722:
3497                     ; 122   while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3499  01bf c65217        	ld	a,_I2C_SR1
3500  01c2 a502          	bcp	a,#2
3501  01c4 27f9          	jreq	L5722
3502                     ; 124   temp = I2C_SR3;
3504  01c6 5552190002    	mov	_temp,_I2C_SR3
3506  01cb               L5032:
3507                     ; 128   while((I2C_SR1 & I2C_SR1) == 0); 
3509  01cb c65217        	ld	a,_I2C_SR1
3510  01ce 5f            	clrw	x
3511  01cf 97            	ld	xl,a
3512  01d0 a30000        	cpw	x,#0
3513  01d3 27f6          	jreq	L5032
3514                     ; 130   I2C_DR = reg_addr;
3516  01d5 7b02          	ld	a,(OFST+2,sp)
3517  01d7 c75216        	ld	_I2C_DR,a
3519  01da               L5132:
3520                     ; 133   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3522  01da c65217        	ld	a,_I2C_SR1
3523  01dd a584          	bcp	a,#132
3524  01df 27f9          	jreq	L5132
3525                     ; 135   I2C_CR2 |= I2C_CR2_START;
3527  01e1 72105211      	bset	_I2C_CR2,#0
3529  01e5               L3232:
3530                     ; 138   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3532  01e5 c65217        	ld	a,_I2C_SR1
3533  01e8 a501          	bcp	a,#1
3534  01ea 27f9          	jreq	L3232
3535                     ; 141   I2C_DR = address | 0x01;
3537  01ec 7b01          	ld	a,(OFST+1,sp)
3538  01ee aa01          	or	a,#1
3539  01f0 c75216        	ld	_I2C_DR,a
3540                     ; 145   if(length == 1){
3542  01f3 7b07          	ld	a,(OFST+7,sp)
3543  01f5 a101          	cp	a,#1
3544  01f7 2627          	jrne	L7232
3545                     ; 147     I2C_CR2 &= ~I2C_CR2_ACK;
3547  01f9 72155211      	bres	_I2C_CR2,#2
3549  01fd               L3332:
3550                     ; 150     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3552  01fd c65217        	ld	a,_I2C_SR1
3553  0200 a502          	bcp	a,#2
3554  0202 27f9          	jreq	L3332
3555                     ; 152     _asm ("SIM");  //on interupts
3558  0204 9b            SIM
3560                     ; 154     temp = I2C_SR3;
3562  0205 5552190002    	mov	_temp,_I2C_SR3
3563                     ; 157     I2C_CR2 |= I2C_CR2_STOP;
3565  020a 72125211      	bset	_I2C_CR2,#1
3566                     ; 159     _asm ("RIM");  //on interupts;
3569  020e 9a            RIM
3572  020f               L1432:
3573                     ; 163     while((I2C_SR1 & I2C_SR1_RXNE) == 0); 
3575  020f c65217        	ld	a,_I2C_SR1
3576  0212 a540          	bcp	a,#64
3577  0214 27f9          	jreq	L1432
3578                     ; 165     *data = I2C_DR;
3580  0216 1e05          	ldw	x,(OFST+5,sp)
3581  0218 c65216        	ld	a,_I2C_DR
3582  021b f7            	ld	(x),a
3584  021c acd202d2      	jpf	L5432
3585  0220               L7232:
3586                     ; 168   else if(length == 2){
3588  0220 7b07          	ld	a,(OFST+7,sp)
3589  0222 a102          	cp	a,#2
3590  0224 2639          	jrne	L7432
3591                     ; 170     I2C_CR2 |= I2C_CR2_POS;
3593  0226 72165211      	bset	_I2C_CR2,#3
3595  022a               L3532:
3596                     ; 173     while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3598  022a c65217        	ld	a,_I2C_SR1
3599  022d a502          	bcp	a,#2
3600  022f 27f9          	jreq	L3532
3601                     ; 175     _asm ("SIM");  //on interupts;
3604  0231 9b            SIM
3606                     ; 177     temp = I2C_SR3;
3608  0232 5552190002    	mov	_temp,_I2C_SR3
3609                     ; 179     I2C_CR2 &= ~I2C_CR2_ACK;
3611  0237 72155211      	bres	_I2C_CR2,#2
3612                     ; 181     _asm ("RIM");  //on interupts;
3615  023b 9a            RIM
3618  023c               L1632:
3619                     ; 185     while((I2C_SR1 & I2C_SR1_BTF) == 0); 
3621  023c c65217        	ld	a,_I2C_SR1
3622  023f a504          	bcp	a,#4
3623  0241 27f9          	jreq	L1632
3624                     ; 187     _asm ("SIM");  //on interupts;
3627  0243 9b            SIM
3629                     ; 189     I2C_CR2 |= I2C_CR2_STOP;
3631  0244 72125211      	bset	_I2C_CR2,#1
3632                     ; 191     *data++ = I2C_DR;
3634  0248 1e05          	ldw	x,(OFST+5,sp)
3635  024a 1c0001        	addw	x,#1
3636  024d 1f05          	ldw	(OFST+5,sp),x
3637  024f 1d0001        	subw	x,#1
3638  0252 c65216        	ld	a,_I2C_DR
3639  0255 f7            	ld	(x),a
3640                     ; 193     _asm ("RIM");  //on interupts;
3643  0256 9a            RIM
3645                     ; 194     *data = I2C_DR;
3647  0257 1e05          	ldw	x,(OFST+5,sp)
3648  0259 c65216        	ld	a,_I2C_DR
3649  025c f7            	ld	(x),a
3651  025d 2073          	jra	L5432
3652  025f               L7432:
3653                     ; 197   else if(length > 2){
3655  025f 7b07          	ld	a,(OFST+7,sp)
3656  0261 a103          	cp	a,#3
3657  0263 256d          	jrult	L5432
3659  0265               L3732:
3660                     ; 200     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3662  0265 c65217        	ld	a,_I2C_SR1
3663  0268 a502          	bcp	a,#2
3664  026a 27f9          	jreq	L3732
3665                     ; 202     _asm ("SIM");  //on interupts;
3668  026c 9b            SIM
3670                     ; 205     I2C_SR3;
3672  026d c65219        	ld	a,_I2C_SR3
3673                     ; 208     _asm ("RIM");  //on interupts;
3676  0270 9a            RIM
3679  0271 2015          	jra	L1042
3680  0273               L7042:
3681                     ; 213       while((I2C_SR1 & I2C_SR1_BTF) == 0);
3683  0273 c65217        	ld	a,_I2C_SR1
3684  0276 a504          	bcp	a,#4
3685  0278 27f9          	jreq	L7042
3686                     ; 215       *data++ = I2C_DR;
3688  027a 1e05          	ldw	x,(OFST+5,sp)
3689  027c 1c0001        	addw	x,#1
3690  027f 1f05          	ldw	(OFST+5,sp),x
3691  0281 1d0001        	subw	x,#1
3692  0284 c65216        	ld	a,_I2C_DR
3693  0287 f7            	ld	(x),a
3694  0288               L1042:
3695                     ; 210     while(length-- > 3){
3697  0288 7b07          	ld	a,(OFST+7,sp)
3698  028a 0a07          	dec	(OFST+7,sp)
3699  028c a104          	cp	a,#4
3700  028e 24e3          	jruge	L7042
3702  0290               L5142:
3703                     ; 224     while((I2C_SR1 & I2C_SR1_BTF) == 0);
3705  0290 c65217        	ld	a,_I2C_SR1
3706  0293 a504          	bcp	a,#4
3707  0295 27f9          	jreq	L5142
3708                     ; 226     I2C_CR2 &= ~I2C_CR2_ACK;
3710  0297 72155211      	bres	_I2C_CR2,#2
3711                     ; 228     _asm ("SIM");  //on interupts;
3714  029b 9b            SIM
3716                     ; 231     *data++ = I2C_DR;
3718  029c 1e05          	ldw	x,(OFST+5,sp)
3719  029e 1c0001        	addw	x,#1
3720  02a1 1f05          	ldw	(OFST+5,sp),x
3721  02a3 1d0001        	subw	x,#1
3722  02a6 c65216        	ld	a,_I2C_DR
3723  02a9 f7            	ld	(x),a
3724                     ; 233     I2C_CR2 |= I2C_CR2_STOP;
3726  02aa 72125211      	bset	_I2C_CR2,#1
3727                     ; 235     *data++ = I2C_DR;
3729  02ae 1e05          	ldw	x,(OFST+5,sp)
3730  02b0 1c0001        	addw	x,#1
3731  02b3 1f05          	ldw	(OFST+5,sp),x
3732  02b5 1d0001        	subw	x,#1
3733  02b8 c65216        	ld	a,_I2C_DR
3734  02bb f7            	ld	(x),a
3735                     ; 237     _asm ("RIM");  //on interupts;
3738  02bc 9a            RIM
3741  02bd               L3242:
3742                     ; 240     while((I2C_SR1 & I2C_SR1_RXNE) == 0);
3744  02bd c65217        	ld	a,_I2C_SR1
3745  02c0 a540          	bcp	a,#64
3746  02c2 27f9          	jreq	L3242
3747                     ; 242     *data++ = I2C_DR;
3749  02c4 1e05          	ldw	x,(OFST+5,sp)
3750  02c6 1c0001        	addw	x,#1
3751  02c9 1f05          	ldw	(OFST+5,sp),x
3752  02cb 1d0001        	subw	x,#1
3753  02ce c65216        	ld	a,_I2C_DR
3754  02d1 f7            	ld	(x),a
3755  02d2               L5432:
3756                     ; 245 	 I2C_CR2 |= I2C_CR2_STOP;
3758  02d2 72125211      	bset	_I2C_CR2,#1
3760  02d6               L1342:
3761                     ; 248   while((I2C_CR2 & I2C_CR2_STOP) == 0);
3763  02d6 c65211        	ld	a,_I2C_CR2
3764  02d9 a502          	bcp	a,#2
3765  02db 27f9          	jreq	L1342
3766                     ; 250   I2C_CR2 &= ~I2C_CR2_POS;
3768  02dd 72175211      	bres	_I2C_CR2,#3
3769                     ; 252   return I2C_SUCCESS;
3771  02e1 4f            	clr	a
3774  02e2 85            	popw	x
3775  02e3 81            	ret
3842                     ; 10 void timer1_setup(uint16_t tim_freq, uint16_t top)
3842                     ; 11  {
3843                     	switch	.text
3844  02e4               _timer1_setup:
3846  02e4 89            	pushw	x
3847  02e5 5204          	subw	sp,#4
3848       00000004      OFST:	set	4
3851                     ; 12   TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
3853  02e7 cd0000        	call	c_uitolx
3855  02ea 96            	ldw	x,sp
3856  02eb 1c0001        	addw	x,#OFST-3
3857  02ee cd0000        	call	c_rtol
3859  02f1 ae2400        	ldw	x,#9216
3860  02f4 bf02          	ldw	c_lreg+2,x
3861  02f6 ae00f4        	ldw	x,#244
3862  02f9 bf00          	ldw	c_lreg,x
3863  02fb 96            	ldw	x,sp
3864  02fc 1c0001        	addw	x,#OFST-3
3865  02ff cd0000        	call	c_ldiv
3867  0302 a608          	ld	a,#8
3868  0304 cd0000        	call	c_lrsh
3870  0307 b603          	ld	a,c_lreg+3
3871  0309 c75260        	ld	_TIM1_PSCRH,a
3872                     ; 13   TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; // 16 divider
3874  030c 1e05          	ldw	x,(OFST+1,sp)
3875  030e cd0000        	call	c_uitolx
3877  0311 96            	ldw	x,sp
3878  0312 1c0001        	addw	x,#OFST-3
3879  0315 cd0000        	call	c_rtol
3881  0318 ae2400        	ldw	x,#9216
3882  031b bf02          	ldw	c_lreg+2,x
3883  031d ae00f4        	ldw	x,#244
3884  0320 bf00          	ldw	c_lreg,x
3885  0322 96            	ldw	x,sp
3886  0323 1c0001        	addw	x,#OFST-3
3887  0326 cd0000        	call	c_ldiv
3889  0329 3f02          	clr	c_lreg+2
3890  032b 3f01          	clr	c_lreg+1
3891  032d 3f00          	clr	c_lreg
3892  032f b603          	ld	a,c_lreg+3
3893  0331 c75261        	ld	_TIM1_PSCRL,a
3894                     ; 14   TIM1_ARRH = (top) >> 8; //	overflow frequency = 16М / 8 / 1000 = 2000 Гц
3896  0334 7b09          	ld	a,(OFST+5,sp)
3897  0336 c75262        	ld	_TIM1_ARRH,a
3898                     ; 15   TIM1_ARRL = (top)& 0xFF;
3900  0339 7b0a          	ld	a,(OFST+6,sp)
3901  033b a4ff          	and	a,#255
3902  033d c75263        	ld	_TIM1_ARRL,a
3903                     ; 17   TIM1_CR1 |= TIM1_CR1_URS; //only overflow int
3905  0340 72145250      	bset	_TIM1_CR1,#2
3906                     ; 18   TIM1_EGR |= TIM1_EGR_UG;  //call Update Event
3908  0344 72105257      	bset	_TIM1_EGR,#0
3909                     ; 19   TIM1_IER |= TIM1_IER_UIE; //int enable
3911  0348 72105254      	bset	_TIM1_IER,#0
3912                     ; 20  }
3915  034c 5b06          	addw	sp,#6
3916  034e 81            	ret
3947                     ; 23 void timer2_setup(void)
3947                     ; 24  {
3948                     	switch	.text
3949  034f               _timer2_setup:
3953                     ; 26 		TIM2_CCR1H = dots_upd >> 8;
3955  034f 5500025311    	mov	_TIM2_CCR1H,_dots_upd
3956                     ; 27 		TIM2_CCR1L = dots_upd & 0xFF;
3958  0354 b603          	ld	a,_dots_upd+1
3959  0356 a4ff          	and	a,#255
3960  0358 c75312        	ld	_TIM2_CCR1L,a
3961                     ; 28 		TIM2_CCMR1 |= TIM2_CCMR_OCxPE;	//preload
3963  035b 72165307      	bset	_TIM2_CCMR1,#3
3964                     ; 30     TIM2_IER |=	TIM2_IER_CC1IE | TIM2_IER_UIE;	//overflow int and compare 1   
3966  035f c65303        	ld	a,_TIM2_IER
3967  0362 aa03          	or	a,#3
3968  0364 c75303        	ld	_TIM2_IER,a
3969                     ; 31     TIM2_PSCR = 0;
3971  0367 725f530e      	clr	_TIM2_PSCR
3972                     ; 32     TIM2_ARRH = 0;
3974  036b 725f530f      	clr	_TIM2_ARRH
3975                     ; 33     TIM2_ARRL = 0;
3977  036f 725f5310      	clr	_TIM2_ARRL
3978                     ; 34  }
3981  0373 81            	ret
4005                     ; 36  void timer1_start(void)
4005                     ; 37  {
4006                     	switch	.text
4007  0374               _timer1_start:
4011                     ; 38    TIM1_CR1 |= TIM1_CR1_CEN; //Запускаем таймер
4013  0374 72105250      	bset	_TIM1_CR1,#0
4014                     ; 39  }
4017  0378 81            	ret
4054                     ; 41 void timer2_start(uint16_t top_val)
4054                     ; 42 {
4055                     	switch	.text
4056  0379               _timer2_start:
4060                     ; 43   TIM2_ARRH =top_val >>8;
4062  0379 9e            	ld	a,xh
4063  037a c7530f        	ld	_TIM2_ARRH,a
4064                     ; 44   TIM2_ARRL =top_val & 0xFF;
4066  037d 9f            	ld	a,xl
4067  037e a4ff          	and	a,#255
4068  0380 c75310        	ld	_TIM2_ARRL,a
4069                     ; 45   TIM2_CR1 |= TIM2_CR1_CEN;
4071  0383 72105300      	bset	_TIM2_CR1,#0
4072                     ; 46 }
4075  0387 81            	ret
4108                     ; 48 void Timer2_Overflow (void)
4108                     ; 49 {
4109                     	switch	.text
4110  0388               _Timer2_Overflow:
4114                     ; 50 	TIM2_SR1 &= ~TIM2_SR1_UIF;
4116  0388 72115304      	bres	_TIM2_SR1,#0
4117                     ; 52 			timers_int_off();
4119  038c cd048d        	call	_timers_int_off
4121                     ; 53 			PA_ODR &= (0<<3);
4123  038f 725f5000      	clr	_PA_ODR
4124                     ; 54 			spi_send(kostil_k155(k155_data));
4126  0393 b616          	ld	a,_k155_data
4127  0395 cd04f3        	call	_kostil_k155
4129  0398 cd051a        	call	_spi_send
4131                     ; 55 			spi_send(lamp_number_data | dots);
4133  039b b615          	ld	a,_lamp_number_data
4134  039d ba01          	or	a,_dots
4135  039f cd051a        	call	_spi_send
4138  03a2               L5352:
4139                     ; 56 			while((SPI_SR & SPI_SR_BSY) != 0);
4141  03a2 c65203        	ld	a,_SPI_SR
4142  03a5 a580          	bcp	a,#128
4143  03a7 26f9          	jrne	L5352
4144                     ; 57 			PA_ODR |= (1<<3);
4146  03a9 72165000      	bset	_PA_ODR,#3
4147                     ; 58 			timers_int_on();
4149  03ad cd0496        	call	_timers_int_on
4151                     ; 59 }
4154  03b0 81            	ret
4180                     ; 61 void Timer1_overflow (void){
4181                     	switch	.text
4182  03b1               _Timer1_overflow:
4186                     ; 62 	TIM1_SR1 = 0;
4188  03b1 725f5255      	clr	_TIM1_SR1
4189                     ; 63 	if (dots_on == 0){
4191  03b5 be04          	ldw	x,_dots_on
4192  03b7 2607          	jrne	L1552
4193                     ; 64 		dots_on = 1;
4195  03b9 ae0001        	ldw	x,#1
4196  03bc bf04          	ldw	_dots_on,x
4198  03be 2003          	jra	L3552
4199  03c0               L1552:
4200                     ; 68 		dots_on = 0;
4202  03c0 5f            	clrw	x
4203  03c1 bf04          	ldw	_dots_on,x
4204  03c3               L3552:
4205                     ; 73 	time_refresh();
4207  03c3 cd054a        	call	_time_refresh
4209                     ; 74 }
4212  03c6 81            	ret
4255                     ; 76 void timer2_compare(void)
4255                     ; 77 {
4256                     	switch	.text
4257  03c7               _timer2_compare:
4261                     ; 78 	TIM2_SR1 &= ~TIM2_SR1_CC1IF;
4263  03c7 72135304      	bres	_TIM2_SR1,#1
4264                     ; 80 	if (schetchik == 1)
4266  03cb b60a          	ld	a,_schetchik
4267  03cd a101          	cp	a,#1
4268  03cf 2658          	jrne	L5752
4269                     ; 82 	switch (lamp_number)
4271  03d1 b600          	ld	a,_lamp_number
4273                     ; 95 	break;
4274  03d3 4d            	tnz	a
4275  03d4 270b          	jreq	L5552
4276  03d6 4a            	dec	a
4277  03d7 270d          	jreq	L7552
4278  03d9 4a            	dec	a
4279  03da 270f          	jreq	L1652
4280  03dc 4a            	dec	a
4281  03dd 2711          	jreq	L3652
4282  03df 2012          	jra	L1062
4283  03e1               L5552:
4284                     ; 84 	case 0:
4284                     ; 85 	k155_data = hours_tens; 
4286  03e1 450816        	mov	_k155_data,_hours_tens
4287                     ; 86 	break;
4289  03e4 200d          	jra	L1062
4290  03e6               L7552:
4291                     ; 87 	case 1:
4291                     ; 88 	k155_data = hours;
4293  03e6 450d16        	mov	_k155_data,_hours
4294                     ; 89 	break;
4296  03e9 2008          	jra	L1062
4297  03eb               L1652:
4298                     ; 90 	case 2:
4298                     ; 91 	k155_data = minutes_tens;
4300  03eb 450916        	mov	_k155_data,_minutes_tens
4301                     ; 92 	break;
4303  03ee 2003          	jra	L1062
4304  03f0               L3652:
4305                     ; 93 	case 3:
4305                     ; 94 	k155_data = minutes;
4307  03f0 450c16        	mov	_k155_data,_minutes
4308                     ; 95 	break;
4310  03f3               L1062:
4311                     ; 98 	if (lamp_number < 3)
4313  03f3 b600          	ld	a,_lamp_number
4314  03f5 a103          	cp	a,#3
4315  03f7 2415          	jruge	L3062
4316                     ; 100 			lamp_number_data = (1<<(lamp_number++));
4318  03f9 b600          	ld	a,_lamp_number
4319  03fb 97            	ld	xl,a
4320  03fc 3c00          	inc	_lamp_number
4321  03fe 9f            	ld	a,xl
4322  03ff 5f            	clrw	x
4323  0400 97            	ld	xl,a
4324  0401 a601          	ld	a,#1
4325  0403 5d            	tnzw	x
4326  0404 2704          	jreq	L04
4327  0406               L24:
4328  0406 48            	sll	a
4329  0407 5a            	decw	x
4330  0408 26fc          	jrne	L24
4331  040a               L04:
4332  040a b715          	ld	_lamp_number_data,a
4334  040c 2017          	jra	L5062
4335  040e               L3062:
4336                     ; 102 		else if (lamp_number >= 3)
4338  040e b600          	ld	a,_lamp_number
4339  0410 a103          	cp	a,#3
4340  0412 2511          	jrult	L5062
4341                     ; 104 			lamp_number_data = (1<<(lamp_number));
4343  0414 b600          	ld	a,_lamp_number
4344  0416 5f            	clrw	x
4345  0417 97            	ld	xl,a
4346  0418 a601          	ld	a,#1
4347  041a 5d            	tnzw	x
4348  041b 2704          	jreq	L44
4349  041d               L64:
4350  041d 48            	sll	a
4351  041e 5a            	decw	x
4352  041f 26fc          	jrne	L64
4353  0421               L44:
4354  0421 b715          	ld	_lamp_number_data,a
4355                     ; 105 			lamp_number = 0;
4357  0423 3f00          	clr	_lamp_number
4358  0425               L5062:
4359                     ; 108 	schetchik = 0;
4361  0425 3f0a          	clr	_schetchik
4363  0427 2006          	jra	L1162
4364  0429               L5752:
4365                     ; 112 		lamp_number_data = 0;
4367  0429 3f15          	clr	_lamp_number_data
4368                     ; 113 		schetchik = 1;
4370  042b 3501000a      	mov	_schetchik,#1
4371  042f               L1162:
4372                     ; 117 	if (dots_on == 1){
4374  042f be04          	ldw	x,_dots_on
4375  0431 a30001        	cpw	x,#1
4376  0434 261c          	jrne	L3162
4377                     ; 118 		if (dots_upd < 10000){
4379  0436 be02          	ldw	x,_dots_upd
4380  0438 a32710        	cpw	x,#10000
4381  043b 242c          	jruge	L7162
4382                     ; 119 			dots_upd +=10;
4384  043d be02          	ldw	x,_dots_upd
4385  043f 1c000a        	addw	x,#10
4386  0442 bf02          	ldw	_dots_upd,x
4387                     ; 120 			TIM2_CCR1H = dots_upd >> 8;
4389  0444 5500025311    	mov	_TIM2_CCR1H,_dots_upd
4390                     ; 121 			TIM2_CCR1L = dots_upd & 0xFF;
4392  0449 b603          	ld	a,_dots_upd+1
4393  044b a4ff          	and	a,#255
4394  044d c75312        	ld	_TIM2_CCR1L,a
4395  0450 2017          	jra	L7162
4396  0452               L3162:
4397                     ; 125 			if (dots_upd > 0){
4399  0452 be02          	ldw	x,_dots_upd
4400  0454 2713          	jreq	L7162
4401                     ; 126 				dots_upd -= 10;
4403  0456 be02          	ldw	x,_dots_upd
4404  0458 1d000a        	subw	x,#10
4405  045b bf02          	ldw	_dots_upd,x
4406                     ; 127 				TIM2_CCR1H = dots_upd >> 8;
4408  045d 5500025311    	mov	_TIM2_CCR1H,_dots_upd
4409                     ; 128 				TIM2_CCR1L = dots_upd & 0xFF;
4411  0462 b603          	ld	a,_dots_upd+1
4412  0464 a4ff          	and	a,#255
4413  0466 c75312        	ld	_TIM2_CCR1L,a
4414  0469               L7162:
4415                     ; 132 			timers_int_off();
4417  0469 ad22          	call	_timers_int_off
4419                     ; 133 			PA_ODR &= (0<<3);
4421  046b 725f5000      	clr	_PA_ODR
4422                     ; 134 			spi_send(kostil_k155(k155_data));
4424  046f b616          	ld	a,_k155_data
4425  0471 cd04f3        	call	_kostil_k155
4427  0474 cd051a        	call	_spi_send
4429                     ; 135 			spi_send(lamp_number_data & ~dots);
4431  0477 b601          	ld	a,_dots
4432  0479 43            	cpl	a
4433  047a b415          	and	a,_lamp_number_data
4434  047c cd051a        	call	_spi_send
4437  047f               L5262:
4438                     ; 136 			while((SPI_SR & SPI_SR_BSY) != 0);
4440  047f c65203        	ld	a,_SPI_SR
4441  0482 a580          	bcp	a,#128
4442  0484 26f9          	jrne	L5262
4443                     ; 137 			PA_ODR |= (1<<3);
4445  0486 72165000      	bset	_PA_ODR,#3
4446                     ; 138 			timers_int_on();
4448  048a ad0a          	call	_timers_int_on
4450                     ; 139 	return;
4453  048c 81            	ret
4478                     ; 143 void timers_int_off(void)
4478                     ; 144 {
4479                     	switch	.text
4480  048d               _timers_int_off:
4484                     ; 145 	TIM1_IER &= ~TIM1_IER_UIE;
4486  048d 72115254      	bres	_TIM1_IER,#0
4487                     ; 147 	TIM2_IER = 0;
4489  0491 725f5303      	clr	_TIM2_IER
4490                     ; 148 }
4493  0495 81            	ret
4518                     ; 151 void timers_int_on(void)
4518                     ; 152 {
4519                     	switch	.text
4520  0496               _timers_int_on:
4524                     ; 153 	TIM1_IER |= TIM1_IER_UIE;
4526  0496 72105254      	bset	_TIM1_IER,#0
4527                     ; 154 	TIM2_IER |=	TIM2_IER_CC1IE |TIM2_IER_UIE;	//overflow int and compare 1
4529  049a c65303        	ld	a,_TIM2_IER
4530  049d aa03          	or	a,#3
4531  049f c75303        	ld	_TIM2_IER,a
4532                     ; 155 }
4535  04a2 81            	ret
4584                     ; 1 void time_write(void)
4584                     ; 2 {
4585                     	switch	.text
4586  04a3               _time_write:
4590                     ; 5 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
4592  04a3 b614          	ld	a,_fresh_hours_dec
4593  04a5 97            	ld	xl,a
4594  04a6 a610          	ld	a,#16
4595  04a8 42            	mul	x,a
4596  04a9 9f            	ld	a,xl
4597  04aa bb13          	add	a,_fresh_hours
4598  04ac b713          	ld	_fresh_hours,a
4599                     ; 6 	fresh_min = fresh_min + (fresh_min_dec<<4);
4601  04ae b612          	ld	a,_fresh_min_dec
4602  04b0 97            	ld	xl,a
4603  04b1 a610          	ld	a,#16
4604  04b3 42            	mul	x,a
4605  04b4 9f            	ld	a,xl
4606  04b5 bb11          	add	a,_fresh_min
4607  04b7 b711          	ld	_fresh_min,a
4608                     ; 7 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
4610  04b9 b610          	ld	a,_fresh_sec_dec
4611  04bb 97            	ld	xl,a
4612  04bc a610          	ld	a,#16
4613  04be 42            	mul	x,a
4614  04bf 9f            	ld	a,xl
4615  04c0 bb0f          	add	a,_fresh_sec
4616  04c2 b70f          	ld	_fresh_sec,a
4617                     ; 8 	timers_int_off();
4619  04c4 adc7          	call	_timers_int_off
4621                     ; 9 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
4623  04c6 4b01          	push	#1
4624  04c8 ae0013        	ldw	x,#_fresh_hours
4625  04cb 89            	pushw	x
4626  04cc aed002        	ldw	x,#53250
4627  04cf cd013e        	call	_i2c_wr_reg
4629  04d2 5b03          	addw	sp,#3
4630                     ; 10 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
4632  04d4 4b01          	push	#1
4633  04d6 ae0011        	ldw	x,#_fresh_min
4634  04d9 89            	pushw	x
4635  04da aed001        	ldw	x,#53249
4636  04dd cd013e        	call	_i2c_wr_reg
4638  04e0 5b03          	addw	sp,#3
4639                     ; 11 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
4641  04e2 4b01          	push	#1
4642  04e4 ae000f        	ldw	x,#_fresh_sec
4643  04e7 89            	pushw	x
4644  04e8 aed000        	ldw	x,#53248
4645  04eb cd013e        	call	_i2c_wr_reg
4647  04ee 5b03          	addw	sp,#3
4648                     ; 12 	timers_int_on();
4650  04f0 ada4          	call	_timers_int_on
4652                     ; 13 }
4655  04f2 81            	ret
4707                     ; 15 uint8_t kostil_k155 (uint8_t byte)
4707                     ; 16 {
4708                     	switch	.text
4709  04f3               _kostil_k155:
4711  04f3 88            	push	a
4712  04f4 89            	pushw	x
4713       00000002      OFST:	set	2
4716                     ; 17 	uint8_t tmp = (byte<<1) & 0b00001100;
4718  04f5 48            	sll	a
4719  04f6 a40c          	and	a,#12
4720  04f8 6b01          	ld	(OFST-1,sp),a
4721                     ; 18 	uint8_t tmp2 = (byte>>2) & 0b00000010;
4723  04fa 7b03          	ld	a,(OFST+1,sp)
4724  04fc 44            	srl	a
4725  04fd 44            	srl	a
4726  04fe a402          	and	a,#2
4727  0500 6b02          	ld	(OFST+0,sp),a
4728                     ; 19 	byte &= 1;
4730  0502 7b03          	ld	a,(OFST+1,sp)
4731  0504 a401          	and	a,#1
4732  0506 6b03          	ld	(OFST+1,sp),a
4733                     ; 20 	byte |= tmp | tmp2;
4735  0508 7b01          	ld	a,(OFST-1,sp)
4736  050a 1a02          	or	a,(OFST+0,sp)
4737  050c 1a03          	or	a,(OFST+1,sp)
4738  050e 6b03          	ld	(OFST+1,sp),a
4739                     ; 21 	return byte;
4741  0510 7b03          	ld	a,(OFST+1,sp)
4744  0512 5b03          	addw	sp,#3
4745  0514 81            	ret
4786                     ; 1 void spi_setup(void)
4786                     ; 2  {
4787                     	switch	.text
4788  0515               _spi_setup:
4792                     ; 3     SPI_CR1= 0b01000100;//0x7C;       //this
4794  0515 35445200      	mov	_SPI_CR1,#68
4795                     ; 5  }
4798  0519 81            	ret
4834                     ; 8 void spi_send(uint8_t msg)
4834                     ; 9 {
4835                     	switch	.text
4836  051a               _spi_send:
4838  051a 88            	push	a
4839       00000000      OFST:	set	0
4842  051b               L3572:
4843                     ; 11 	while((SPI_SR & SPI_SR_BSY) != 0)
4845  051b c65203        	ld	a,_SPI_SR
4846  051e a580          	bcp	a,#128
4847  0520 26f9          	jrne	L3572
4848                     ; 14 	SPI_DR = msg;
4850  0522 7b01          	ld	a,(OFST+1,sp)
4851  0524 c75204        	ld	_SPI_DR,a
4852                     ; 15 }
4855  0527 84            	pop	a
4856  0528 81            	ret
4898                     ; 4 void UART_Resieved (void)
4898                     ; 5 {
4899                     	switch	.text
4900  0529               _UART_Resieved:
4904                     ; 6 	uart_routine(UART1_DR);
4906  0529 c65231        	ld	a,_UART1_DR
4907  052c cd002a        	call	_uart_routine
4909                     ; 7 }
4912  052f 81            	ret
4937                     ; 9 void SPI_Transmitted(void)
4937                     ; 10 {
4938                     	switch	.text
4939  0530               _SPI_Transmitted:
4943                     ; 11 	spi_send(temp3);
4945  0530 b609          	ld	a,_temp3
4946  0532 ade6          	call	_spi_send
4948                     ; 12 }
4951  0534 81            	ret
4974                     ; 14 void I2C_Event(void)
4974                     ; 15 {
4975                     	switch	.text
4976  0535               _I2C_Event:
4980                     ; 17 }
4983  0535 81            	ret
5009                     ; 19 void Keys_switched(void)
5009                     ; 20 {
5010                     	switch	.text
5011  0536               _Keys_switched:
5015                     ; 21 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
5017  0536 c650a0        	ld	a,_EXTI_CR1
5018  0539 43            	cpl	a
5019  053a a430          	and	a,#48
5020  053c c750a0        	ld	_EXTI_CR1,a
5021                     ; 22 	PC_CR2 = 0;
5023  053f 725f500e      	clr	_PC_CR2
5024                     ; 23 	timer2_start(0xff);	
5026  0543 ae00ff        	ldw	x,#255
5027  0546 cd0379        	call	_timer2_start
5029                     ; 24 }
5032  0549 81            	ret
5067                     ; 26 void time_refresh (void)
5067                     ; 27 {
5068                     	switch	.text
5069  054a               _time_refresh:
5073                     ; 29 	timers_int_off();
5075  054a cd048d        	call	_timers_int_off
5077                     ; 30 	i2c_rd_reg(0xD0, 0, &fresh_sec, 1); 	
5079  054d 4b01          	push	#1
5080  054f ae000f        	ldw	x,#_fresh_sec
5081  0552 89            	pushw	x
5082  0553 aed000        	ldw	x,#53248
5083  0556 cd01a1        	call	_i2c_rd_reg
5085  0559 5b03          	addw	sp,#3
5086                     ; 31 	i2c_rd_reg(0xD0, 1, &fresh_min, 1);
5088  055b 4b01          	push	#1
5089  055d ae0011        	ldw	x,#_fresh_min
5090  0560 89            	pushw	x
5091  0561 aed001        	ldw	x,#53249
5092  0564 cd01a1        	call	_i2c_rd_reg
5094  0567 5b03          	addw	sp,#3
5095                     ; 32 	i2c_rd_reg(0xD0, 2, &fresh_hours, 1);
5097  0569 4b01          	push	#1
5098  056b ae0013        	ldw	x,#_fresh_hours
5099  056e 89            	pushw	x
5100  056f aed002        	ldw	x,#53250
5101  0572 cd01a1        	call	_i2c_rd_reg
5103  0575 5b03          	addw	sp,#3
5104                     ; 33 	timers_int_on();
5106  0577 cd0496        	call	_timers_int_on
5108                     ; 35 	seconds_tens = (fresh_sec & 0xf0)>>4;
5110  057a b60f          	ld	a,_fresh_sec
5111  057c a4f0          	and	a,#240
5112  057e 4e            	swap	a
5113  057f a40f          	and	a,#15
5114  0581 b70a          	ld	_seconds_tens,a
5115                     ; 36 	minutes_tens = (fresh_min & 0xf0)>>4;
5117  0583 b611          	ld	a,_fresh_min
5118  0585 a4f0          	and	a,#240
5119  0587 4e            	swap	a
5120  0588 a40f          	and	a,#15
5121  058a b709          	ld	_minutes_tens,a
5122                     ; 37 	hours_tens = (fresh_hours & 0xf0)>>4;
5124  058c b613          	ld	a,_fresh_hours
5125  058e a4f0          	and	a,#240
5126  0590 4e            	swap	a
5127  0591 a40f          	and	a,#15
5128  0593 b708          	ld	_hours_tens,a
5129                     ; 39 	seconds = fresh_sec & 0x0f;
5131  0595 b60f          	ld	a,_fresh_sec
5132  0597 a40f          	and	a,#15
5133  0599 b70b          	ld	_seconds,a
5134                     ; 40 	minutes = fresh_min & 0x0f;
5136  059b b611          	ld	a,_fresh_min
5137  059d a40f          	and	a,#15
5138  059f b70c          	ld	_minutes,a
5139                     ; 41 	hours = fresh_hours & 0x0f;
5141  05a1 b613          	ld	a,_fresh_hours
5142  05a3 a40f          	and	a,#15
5143  05a5 b70d          	ld	_hours,a
5144                     ; 42 }
5147  05a7 81            	ret
5215                     ; 21 int main( void )
5215                     ; 22 {
5216                     	switch	.text
5217  05a8               _main:
5221                     ; 24 		CLK_CKDIVR=0;                //	no dividers
5223  05a8 725f50c6      	clr	_CLK_CKDIVR
5224                     ; 26 		for (i = 0; i < 0xFFFF; i++);
5226  05ac 5f            	clrw	x
5227  05ad bf0b          	ldw	_i,x
5228  05af               L3503:
5232  05af be0b          	ldw	x,_i
5233  05b1 1c0001        	addw	x,#1
5234  05b4 bf0b          	ldw	_i,x
5237  05b6 be0b          	ldw	x,_i
5238  05b8 a3ffff        	cpw	x,#65535
5239  05bb 25f2          	jrult	L3503
5240                     ; 27 		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //clocking for TIM1, UART1, SPI i I2C
5242  05bd 35ff50c7      	mov	_CLK_PCKENR1,#255
5243                     ; 30     PA_DDR=(1<<3) | (1<<2); //0b000001000; //output for register's latch, input for RTC 1 Hz pulse
5245  05c1 350c5002      	mov	_PA_DDR,#12
5246                     ; 31     PA_CR1= 0xff;        //	pull-up on inputs, push-pull on outputs
5248  05c5 35ff5003      	mov	_PA_CR1,#255
5249                     ; 32     PA_ODR |= (1<<3);
5251  05c9 72165000      	bset	_PA_ODR,#3
5252                     ; 33 		PA_CR2 |=(1<<3);        //	interrupt on PA1 for 1hz
5254  05cd 72165004      	bset	_PA_CR2,#3
5255                     ; 35     PC_DDR=0x60; //0b01100000; // buttons pins as input
5257  05d1 3560500c      	mov	_PC_DDR,#96
5258                     ; 36     PC_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5260  05d5 35ff500d      	mov	_PC_CR1,#255
5261                     ; 37     PC_CR2 |= (1<<4) | (1<<3);        //	interrapts for buttons
5263  05d9 c6500e        	ld	a,_PC_CR2
5264  05dc aa18          	or	a,#24
5265  05de c7500e        	ld	_PC_CR2,a
5266                     ; 39 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM
5268  05e1 35a85011      	mov	_PD_DDR,#168
5269                     ; 40     PD_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5271  05e5 35ff5012      	mov	_PD_CR1,#255
5272                     ; 41     PD_ODR = (1 << 3);
5274  05e9 3508500f      	mov	_PD_ODR,#8
5275                     ; 45     spi_setup();
5277  05ed cd0515        	call	_spi_setup
5279                     ; 48 		uart_setup();
5281  05f0 cd0000        	call	_uart_setup
5283                     ; 49 		uart_send('h');
5285  05f3 a668          	ld	a,#104
5286  05f5 cd0019        	call	_uart_send
5288                     ; 52     timer1_setup(65500,0xffff);//	freq in hz and top value
5290  05f8 aeffff        	ldw	x,#65535
5291  05fb 89            	pushw	x
5292  05fc aeffdc        	ldw	x,#65500
5293  05ff cd02e4        	call	_timer1_setup
5295  0602 85            	popw	x
5296                     ; 53 		timer2_setup();
5298  0603 cd034f        	call	_timer2_setup
5300                     ; 54 		timer1_start();
5302  0606 cd0374        	call	_timer1_start
5304                     ; 55 		timer2_start(TIM2_TOP);
5306  0609 ae3e80        	ldw	x,#16000
5307  060c cd0379        	call	_timer2_start
5309                     ; 59 		i2c_master_init(16000000, 100000);
5311  060f ae86a0        	ldw	x,#34464
5312  0612 89            	pushw	x
5313  0613 ae0001        	ldw	x,#1
5314  0616 89            	pushw	x
5315  0617 ae2400        	ldw	x,#9216
5316  061a 89            	pushw	x
5317  061b ae00f4        	ldw	x,#244
5318  061e 89            	pushw	x
5319  061f cd00bc        	call	_i2c_master_init
5321  0622 5b08          	addw	sp,#8
5322                     ; 63 		timers_int_off();
5324  0624 cd048d        	call	_timers_int_off
5326                     ; 64 		i2c_rd_reg(ds_address, 7, &temp, 1);
5328  0627 4b01          	push	#1
5329  0629 ae0002        	ldw	x,#_temp
5330  062c 89            	pushw	x
5331  062d aed007        	ldw	x,#53255
5332  0630 cd01a1        	call	_i2c_rd_reg
5334  0633 5b03          	addw	sp,#3
5335                     ; 65 	if (temp != 0b10010000)	// if OUT and SWQ == 0
5337  0635 b602          	ld	a,_temp
5338  0637 a190          	cp	a,#144
5339  0639 270e          	jreq	L1603
5340                     ; 67 			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//	setup RTC for 1Hz output
5342  063b 4b01          	push	#1
5343  063d ae000e        	ldw	x,#_ds_cr
5344  0640 89            	pushw	x
5345  0641 aed007        	ldw	x,#53255
5346  0644 cd013e        	call	_i2c_wr_reg
5348  0647 5b03          	addw	sp,#3
5349  0649               L1603:
5350                     ; 70 		i2c_rd_reg(ds_address, 0, &temp, 1);
5352  0649 4b01          	push	#1
5353  064b ae0002        	ldw	x,#_temp
5354  064e 89            	pushw	x
5355  064f aed000        	ldw	x,#53248
5356  0652 cd01a1        	call	_i2c_rd_reg
5358  0655 5b03          	addw	sp,#3
5359                     ; 73 	if((temp & 0x80) == 0x80)
5361  0657 b602          	ld	a,_temp
5362  0659 a480          	and	a,#128
5363  065b a180          	cp	a,#128
5364  065d 2610          	jrne	L3603
5365                     ; 75 		temp = 0;
5367  065f 3f02          	clr	_temp
5368                     ; 76 		i2c_wr_reg(ds_address, 0, &temp, 1);
5370  0661 4b01          	push	#1
5371  0663 ae0002        	ldw	x,#_temp
5372  0666 89            	pushw	x
5373  0667 aed000        	ldw	x,#53248
5374  066a cd013e        	call	_i2c_wr_reg
5376  066d 5b03          	addw	sp,#3
5377  066f               L3603:
5378                     ; 78 		timers_int_on();
5380  066f cd0496        	call	_timers_int_on
5382                     ; 80 		_asm ("RIM");  //on interupts
5385  0672 9a            RIM
5387  0673               L5603:
5389  0673 20fe          	jra	L5603
5402                     	xdef	_main
5403                     	xdef	_Keys_switched
5404                     	xdef	_I2C_Event
5405                     	xdef	_SPI_Transmitted
5406                     	xdef	_UART_Resieved
5407                     	xdef	_spi_setup
5408                     	xdef	_timer2_compare
5409                     	xdef	_Timer1_overflow
5410                     	xdef	_Timer2_Overflow
5411                     	xdef	_timer2_start
5412                     	xdef	_timer1_start
5413                     	xdef	_timer2_setup
5414                     	xdef	_timer1_setup
5415                     	xdef	_kostil_k155
5416                     	xdef	_time_refresh
5417                     	xdef	_timers_int_on
5418                     	xdef	_timers_int_off
5419                     	xdef	_spi_send
5420                     	xdef	_i2c_rd_reg
5421                     	xdef	_i2c_wr_reg
5422                     	xdef	_i2c_master_init
5423                     	xdef	_Key_interrupt
5424                     	xdef	_uart_routine
5425                     	xdef	_uart_send
5426                     	xdef	_uart_setup
5427                     	xdef	_time_write
5428                     	switch	.ubsct
5429  0000               _i2c_flags:
5430  0000 00            	ds.b	1
5431                     	xdef	_i2c_flags
5432  0001               _flags:
5433  0001 00            	ds.b	1
5434                     	xdef	_flags
5435                     	xdef	_ds_cr
5436                     	xdef	_schetchik2
5437                     	xdef	_i
5438                     	xdef	_schetchik
5439                     	xdef	_temp3
5440                     	xdef	_temp2
5441  0002               _temp:
5442  0002 00            	ds.b	1
5443                     	xdef	_temp
5444  0003               _pins:
5445  0003 00            	ds.b	1
5446                     	xdef	_pins
5447  0004               _fresh_data_pointer:
5448  0004 0000          	ds.b	2
5449                     	xdef	_fresh_data_pointer
5450  0006               _data_pointer:
5451  0006 0000          	ds.b	2
5452                     	xdef	_data_pointer
5453                     	xdef	_time_pointer
5454  0008               _hours_tens:
5455  0008 00            	ds.b	1
5456                     	xdef	_hours_tens
5457  0009               _minutes_tens:
5458  0009 00            	ds.b	1
5459                     	xdef	_minutes_tens
5460  000a               _seconds_tens:
5461  000a 00            	ds.b	1
5462                     	xdef	_seconds_tens
5463  000b               _seconds:
5464  000b 00            	ds.b	1
5465                     	xdef	_seconds
5466  000c               _minutes:
5467  000c 00            	ds.b	1
5468                     	xdef	_minutes
5469  000d               _hours:
5470  000d 00            	ds.b	1
5471                     	xdef	_hours
5472  000e               _timeset:
5473  000e 00            	ds.b	1
5474                     	xdef	_timeset
5475  000f               _fresh_sec:
5476  000f 00            	ds.b	1
5477                     	xdef	_fresh_sec
5478  0010               _fresh_sec_dec:
5479  0010 00            	ds.b	1
5480                     	xdef	_fresh_sec_dec
5481  0011               _fresh_min:
5482  0011 00            	ds.b	1
5483                     	xdef	_fresh_min
5484  0012               _fresh_min_dec:
5485  0012 00            	ds.b	1
5486                     	xdef	_fresh_min_dec
5487  0013               _fresh_hours:
5488  0013 00            	ds.b	1
5489                     	xdef	_fresh_hours
5490  0014               _fresh_hours_dec:
5491  0014 00            	ds.b	1
5492                     	xdef	_fresh_hours_dec
5493                     	xdef	_dots_on
5494                     	xdef	_dots_upd
5495  0015               _lamp_number_data:
5496  0015 00            	ds.b	1
5497                     	xdef	_lamp_number_data
5498  0016               _k155_data:
5499  0016 00            	ds.b	1
5500                     	xdef	_k155_data
5501                     	xdef	_dots
5502                     	xdef	_lamp_number
5503                     	xref.b	c_lreg
5504                     	xref.b	c_x
5524                     	xref	c_lrsh
5525                     	xref	c_ldiv
5526                     	xref	c_uitolx
5527                     	xref	c_ludv
5528                     	xref	c_rtol
5529                     	xref	c_ltor
5530                     	end
