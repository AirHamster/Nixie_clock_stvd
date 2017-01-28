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
2192  0004 0000          	dc.w	0
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
2875  005b cd0531        	call	_time_write
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
3943                     ; 23 void timer2_setup(void)
3943                     ; 24  {
3944                     	switch	.text
3945  034f               _timer2_setup:
3949                     ; 30     TIM2_IER |= TIM2_IER_UIE;;	//overflow int and compare 1   
3951  034f 72105303      	bset	_TIM2_IER,#0
3952                     ; 31     TIM2_PSCR = 0;
3955  0353 725f530e      	clr	_TIM2_PSCR
3956                     ; 32     TIM2_ARRH = 0;
3958  0357 725f530f      	clr	_TIM2_ARRH
3959                     ; 33     TIM2_ARRL = 0;
3961  035b 725f5310      	clr	_TIM2_ARRL
3962                     ; 36  }
3965  035f 81            	ret
3989                     ; 38  void timer1_start(void)
3989                     ; 39  {
3990                     	switch	.text
3991  0360               _timer1_start:
3995                     ; 40    TIM1_CR1 |= TIM1_CR1_CEN; //Запускаем таймер
3997  0360 72105250      	bset	_TIM1_CR1,#0
3998                     ; 41  }
4001  0364 81            	ret
4038                     ; 43 void timer2_start(uint16_t top_val)
4038                     ; 44 {
4039                     	switch	.text
4040  0365               _timer2_start:
4044                     ; 45   TIM2_ARRH =top_val >>8;
4046  0365 9e            	ld	a,xh
4047  0366 c7530f        	ld	_TIM2_ARRH,a
4048                     ; 46   TIM2_ARRL =top_val & 0xFF;
4050  0369 9f            	ld	a,xl
4051  036a a4ff          	and	a,#255
4052  036c c75310        	ld	_TIM2_ARRL,a
4053                     ; 47   TIM2_CR1 |= TIM2_CR1_CEN;
4055  036f 72105300      	bset	_TIM2_CR1,#0
4056                     ; 48 }
4059  0373 81            	ret
4099                     ; 50 void Timer2_Overflow (void)
4099                     ; 51 {
4100                     	switch	.text
4101  0374               _Timer2_Overflow:
4105                     ; 52 	TIM2_SR1 &= ~TIM2_SR1_UIF;
4107  0374 72115304      	bres	_TIM2_SR1,#0
4108                     ; 82 	if (schetchik == 1)
4110  0378 b60a          	ld	a,_schetchik
4111  037a a101          	cp	a,#1
4112  037c 2703          	jreq	L44
4113  037e cc040d        	jp	L3452
4114  0381               L44:
4115                     ; 84 	switch (lamp_number)
4117  0381 b600          	ld	a,_lamp_number
4119                     ; 97 	break;
4120  0383 4d            	tnz	a
4121  0384 270b          	jreq	L3252
4122  0386 4a            	dec	a
4123  0387 270d          	jreq	L5252
4124  0389 4a            	dec	a
4125  038a 270f          	jreq	L7252
4126  038c 4a            	dec	a
4127  038d 2711          	jreq	L1352
4128  038f 2012          	jra	L7452
4129  0391               L3252:
4130                     ; 86 	case 0:
4130                     ; 87 	k155_data = hours_tens; 
4132  0391 450816        	mov	_k155_data,_hours_tens
4133                     ; 88 	break;
4135  0394 200d          	jra	L7452
4136  0396               L5252:
4137                     ; 89 	case 1:
4137                     ; 90 	k155_data = hours;
4139  0396 450d16        	mov	_k155_data,_hours
4140                     ; 91 	break;
4142  0399 2008          	jra	L7452
4143  039b               L7252:
4144                     ; 92 	case 2:
4144                     ; 93 	k155_data = minutes_tens;
4146  039b 450916        	mov	_k155_data,_minutes_tens
4147                     ; 94 	break;
4149  039e 2003          	jra	L7452
4150  03a0               L1352:
4151                     ; 95 	case 3:
4151                     ; 96 	k155_data = minutes;
4153  03a0 450c16        	mov	_k155_data,_minutes
4154                     ; 97 	break;
4156  03a3               L7452:
4157                     ; 100 	if (lamp_number < 3)
4159  03a3 b600          	ld	a,_lamp_number
4160  03a5 a103          	cp	a,#3
4161  03a7 2415          	jruge	L1552
4162                     ; 102 			lamp_number_data = (1<<(lamp_number++));
4164  03a9 b600          	ld	a,_lamp_number
4165  03ab 97            	ld	xl,a
4166  03ac 3c00          	inc	_lamp_number
4167  03ae 9f            	ld	a,xl
4168  03af 5f            	clrw	x
4169  03b0 97            	ld	xl,a
4170  03b1 a601          	ld	a,#1
4171  03b3 5d            	tnzw	x
4172  03b4 2704          	jreq	L43
4173  03b6               L63:
4174  03b6 48            	sll	a
4175  03b7 5a            	decw	x
4176  03b8 26fc          	jrne	L63
4177  03ba               L43:
4178  03ba b715          	ld	_lamp_number_data,a
4180  03bc 2017          	jra	L3552
4181  03be               L1552:
4182                     ; 104 		else if (lamp_number >= 3)
4184  03be b600          	ld	a,_lamp_number
4185  03c0 a103          	cp	a,#3
4186  03c2 2511          	jrult	L3552
4187                     ; 106 			lamp_number_data = (1<<(lamp_number));
4189  03c4 b600          	ld	a,_lamp_number
4190  03c6 5f            	clrw	x
4191  03c7 97            	ld	xl,a
4192  03c8 a601          	ld	a,#1
4193  03ca 5d            	tnzw	x
4194  03cb 2704          	jreq	L04
4195  03cd               L24:
4196  03cd 48            	sll	a
4197  03ce 5a            	decw	x
4198  03cf 26fc          	jrne	L24
4199  03d1               L04:
4200  03d1 b715          	ld	_lamp_number_data,a
4201                     ; 107 			lamp_number = 0;
4203  03d3 3f00          	clr	_lamp_number
4204  03d5               L3552:
4205                     ; 110 			timers_int_off();
4207  03d5 cd051f        	call	_timers_int_off
4209                     ; 111 	PA_ODR &= (0<<3);
4211  03d8 725f5000      	clr	_PA_ODR
4212                     ; 114 	spi_send(kostil_k155(k155_data));
4214  03dc b616          	ld	a,_k155_data
4215  03de cd0581        	call	_kostil_k155
4217  03e1 cd05a8        	call	_spi_send
4219                     ; 115 	if (schetchik2++ <= 4)
4221  03e4 b60d          	ld	a,_schetchik2
4222  03e6 3c0d          	inc	_schetchik2
4223  03e8 a105          	cp	a,#5
4224  03ea 2407          	jruge	L7552
4225                     ; 117 	spi_send(lamp_number_data);
4227  03ec b615          	ld	a,_lamp_number_data
4228  03ee cd05a8        	call	_spi_send
4231  03f1 2009          	jra	L5652
4232  03f3               L7552:
4233                     ; 121 		spi_send(lamp_number_data | dots);
4235  03f3 b615          	ld	a,_lamp_number_data
4236  03f5 ba01          	or	a,_dots
4237  03f7 cd05a8        	call	_spi_send
4239                     ; 122 		schetchik2 = 0;
4241  03fa 3f0d          	clr	_schetchik2
4242  03fc               L5652:
4243                     ; 125 	while((SPI_SR & SPI_SR_BSY) != 0);
4245  03fc c65203        	ld	a,_SPI_SR
4246  03ff a580          	bcp	a,#128
4247  0401 26f9          	jrne	L5652
4248                     ; 126 	PA_ODR |= (1<<3);
4250  0403 72165000      	bset	_PA_ODR,#3
4251                     ; 127 	timers_int_on();
4253  0407 cd0528        	call	_timers_int_on
4255                     ; 129 	schetchik = 0;
4257  040a 3f0a          	clr	_schetchik
4259  040c               L1752:
4260                     ; 147 	return;
4263  040c 81            	ret
4264  040d               L3452:
4265                     ; 133 		schetchik = 1;
4267  040d 3501000a      	mov	_schetchik,#1
4268                     ; 134 	timers_int_off();
4270  0411 cd051f        	call	_timers_int_off
4272                     ; 135 	PA_ODR &= (0<<3);
4274  0414 725f5000      	clr	_PA_ODR
4275                     ; 139 	spi_send(kostil_k155(k155_data));
4277  0418 b616          	ld	a,_k155_data
4278  041a cd0581        	call	_kostil_k155
4280  041d cd05a8        	call	_spi_send
4282                     ; 141 	spi_send(0);
4284  0420 4f            	clr	a
4285  0421 cd05a8        	call	_spi_send
4288  0424               L5752:
4289                     ; 143 	while((SPI_SR & SPI_SR_BSY) != 0);
4291  0424 c65203        	ld	a,_SPI_SR
4292  0427 a580          	bcp	a,#128
4293  0429 26f9          	jrne	L5752
4294                     ; 144 	PA_ODR |= (1<<3);
4296  042b 72165000      	bset	_PA_ODR,#3
4297                     ; 145 	timers_int_on();
4299  042f cd0528        	call	_timers_int_on
4301  0432 20d8          	jra	L1752
4328                     ; 150 void Timer1_overflow (void){
4329                     	switch	.text
4330  0434               _Timer1_overflow:
4334                     ; 151 	TIM1_SR1 = 0;
4336  0434 725f5255      	clr	_TIM1_SR1
4337                     ; 152 	if (dots_on == 0){
4339  0438 be04          	ldw	x,_dots_on
4340  043a 260b          	jrne	L1162
4341                     ; 153 		dots_on = 1;
4343  043c ae0001        	ldw	x,#1
4344  043f bf04          	ldw	_dots_on,x
4345                     ; 154 		dots = 0b00010000;
4347  0441 35100001      	mov	_dots,#16
4349  0445 2005          	jra	L3162
4350  0447               L1162:
4351                     ; 157 		dots_on = 0;
4353  0447 5f            	clrw	x
4354  0448 bf04          	ldw	_dots_on,x
4355                     ; 158 		dots = 0;
4357  044a 3f01          	clr	_dots
4358  044c               L3162:
4359                     ; 162 	time_refresh();
4361  044c cd05d8        	call	_time_refresh
4363                     ; 163 }
4366  044f 81            	ret
4408                     ; 165 void timer2_compare(void)
4408                     ; 166 {
4409                     	switch	.text
4410  0450               _timer2_compare:
4414                     ; 167 	TIM2_SR1 &= ~TIM2_SR1_CC1IF;
4416  0450 72135304      	bres	_TIM2_SR1,#1
4417                     ; 169 		switch (lamp_number)
4419  0454 b600          	ld	a,_lamp_number
4421                     ; 182 	break;
4422  0456 4d            	tnz	a
4423  0457 270b          	jreq	L5162
4424  0459 4a            	dec	a
4425  045a 270d          	jreq	L7162
4426  045c 4a            	dec	a
4427  045d 270f          	jreq	L1262
4428  045f 4a            	dec	a
4429  0460 2711          	jreq	L3262
4430  0462 2012          	jra	L7362
4431  0464               L5162:
4432                     ; 171 	case 0:
4432                     ; 172 	k155_data = hours_tens; 
4434  0464 450816        	mov	_k155_data,_hours_tens
4435                     ; 173 	break;
4437  0467 200d          	jra	L7362
4438  0469               L7162:
4439                     ; 174 	case 1:
4439                     ; 175 	k155_data = hours;
4441  0469 450d16        	mov	_k155_data,_hours
4442                     ; 176 	break;
4444  046c 2008          	jra	L7362
4445  046e               L1262:
4446                     ; 177 	case 2:
4446                     ; 178 	k155_data = minutes_tens;
4448  046e 450916        	mov	_k155_data,_minutes_tens
4449                     ; 179 	break;
4451  0471 2003          	jra	L7362
4452  0473               L3262:
4453                     ; 180 	case 3:
4453                     ; 181 	k155_data = minutes;
4455  0473 450c16        	mov	_k155_data,_minutes
4456                     ; 182 	break;
4458  0476               L7362:
4459                     ; 185 	if (lamp_number < 3)
4461  0476 b600          	ld	a,_lamp_number
4462  0478 a103          	cp	a,#3
4463  047a 2415          	jruge	L1462
4464                     ; 187 			lamp_number_data = (1<<(lamp_number++));
4466  047c b600          	ld	a,_lamp_number
4467  047e 97            	ld	xl,a
4468  047f 3c00          	inc	_lamp_number
4469  0481 9f            	ld	a,xl
4470  0482 5f            	clrw	x
4471  0483 97            	ld	xl,a
4472  0484 a601          	ld	a,#1
4473  0486 5d            	tnzw	x
4474  0487 2704          	jreq	L25
4475  0489               L45:
4476  0489 48            	sll	a
4477  048a 5a            	decw	x
4478  048b 26fc          	jrne	L45
4479  048d               L25:
4480  048d b715          	ld	_lamp_number_data,a
4482  048f 2017          	jra	L3462
4483  0491               L1462:
4484                     ; 189 		else if (lamp_number >= 3)
4486  0491 b600          	ld	a,_lamp_number
4487  0493 a103          	cp	a,#3
4488  0495 2511          	jrult	L3462
4489                     ; 191 			lamp_number_data = (1<<(lamp_number));
4491  0497 b600          	ld	a,_lamp_number
4492  0499 5f            	clrw	x
4493  049a 97            	ld	xl,a
4494  049b a601          	ld	a,#1
4495  049d 5d            	tnzw	x
4496  049e 2704          	jreq	L65
4497  04a0               L06:
4498  04a0 48            	sll	a
4499  04a1 5a            	decw	x
4500  04a2 26fc          	jrne	L06
4501  04a4               L65:
4502  04a4 b715          	ld	_lamp_number_data,a
4503                     ; 192 			lamp_number = 0;
4505  04a6 3f00          	clr	_lamp_number
4506  04a8               L3462:
4507                     ; 195 	if (dots_on == 1){
4509  04a8 be04          	ldw	x,_dots_on
4510  04aa a30001        	cpw	x,#1
4511  04ad 2637          	jrne	L7462
4512                     ; 196 		if (dots_upd < 15000){
4514  04af be02          	ldw	x,_dots_upd
4515  04b1 a33a98        	cpw	x,#15000
4516  04b4 2468          	jruge	L3562
4517                     ; 197 			dots_upd +=15;
4519  04b6 be02          	ldw	x,_dots_upd
4520  04b8 1c000f        	addw	x,#15
4521  04bb bf02          	ldw	_dots_upd,x
4522                     ; 198 			TIM2_CCR1H = dots_upd >> 8;
4524  04bd 5500025311    	mov	_TIM2_CCR1H,_dots_upd
4525                     ; 199 			TIM2_CCR1L = dots_upd & 0xFF;
4527  04c2 b603          	ld	a,_dots_upd+1
4528  04c4 a4ff          	and	a,#255
4529  04c6 c75312        	ld	_TIM2_CCR1L,a
4530                     ; 201 			timers_int_off();
4532  04c9 ad54          	call	_timers_int_off
4534                     ; 202 			PA_ODR &= (0<<3);
4536  04cb 725f5000      	clr	_PA_ODR
4537                     ; 203 			spi_send(kostil_k155(k155_data));
4539  04cf b616          	ld	a,_k155_data
4540  04d1 cd0581        	call	_kostil_k155
4542  04d4 cd05a8        	call	_spi_send
4544                     ; 204 			spi_send(lamp_number_data | dots);
4546  04d7 b615          	ld	a,_lamp_number_data
4547  04d9 ba01          	or	a,_dots
4548  04db cd05a8        	call	_spi_send
4550                     ; 205 			PA_ODR |= (1<<3);
4552  04de 72165000      	bset	_PA_ODR,#3
4553                     ; 206 			timers_int_on();
4555  04e2 ad44          	call	_timers_int_on
4557  04e4 2038          	jra	L3562
4558  04e6               L7462:
4559                     ; 210 			if (dots_upd > 0)
4561  04e6 be02          	ldw	x,_dots_upd
4562  04e8 2734          	jreq	L3562
4563                     ; 212 				dots_upd -= 15;
4565  04ea be02          	ldw	x,_dots_upd
4566  04ec 1d000f        	subw	x,#15
4567  04ef bf02          	ldw	_dots_upd,x
4568                     ; 213 				TIM2_CCR1H = dots_upd >> 8;
4570  04f1 5500025311    	mov	_TIM2_CCR1H,_dots_upd
4571                     ; 214 				TIM2_CCR1L = dots_upd & 0xFF;
4573  04f6 b603          	ld	a,_dots_upd+1
4574  04f8 a4ff          	and	a,#255
4575  04fa c75312        	ld	_TIM2_CCR1L,a
4576                     ; 216 				timers_int_off();
4578  04fd ad20          	call	_timers_int_off
4580                     ; 217 				PA_ODR &= (0<<3);
4582  04ff 725f5000      	clr	_PA_ODR
4583                     ; 218 				spi_send(kostil_k155(k155_data));
4585  0503 b616          	ld	a,_k155_data
4586  0505 ad7a          	call	_kostil_k155
4588  0507 cd05a8        	call	_spi_send
4590                     ; 219 				spi_send(lamp_number_data | dots);
4592  050a b615          	ld	a,_lamp_number_data
4593  050c ba01          	or	a,_dots
4594  050e cd05a8        	call	_spi_send
4597  0511               L1662:
4598                     ; 220 				while((SPI_SR & SPI_SR_BSY) != 0);
4600  0511 c65203        	ld	a,_SPI_SR
4601  0514 a580          	bcp	a,#128
4602  0516 26f9          	jrne	L1662
4603                     ; 221 				PA_ODR |= (1<<3);
4605  0518 72165000      	bset	_PA_ODR,#3
4606                     ; 222 				timers_int_on();
4608  051c ad0a          	call	_timers_int_on
4610  051e               L3562:
4611                     ; 226 	return;
4614  051e 81            	ret
4639                     ; 230 void timers_int_off(void)
4639                     ; 231 {
4640                     	switch	.text
4641  051f               _timers_int_off:
4645                     ; 232 	TIM1_IER &= ~TIM1_IER_UIE;
4647  051f 72115254      	bres	_TIM1_IER,#0
4648                     ; 234 	TIM2_IER = 0;
4650  0523 725f5303      	clr	_TIM2_IER
4651                     ; 235 }
4654  0527 81            	ret
4679                     ; 238 void timers_int_on(void)
4679                     ; 239 {
4680                     	switch	.text
4681  0528               _timers_int_on:
4685                     ; 240 	TIM1_IER |= TIM1_IER_UIE;
4687  0528 72105254      	bset	_TIM1_IER,#0
4688                     ; 241 	TIM2_IER |= TIM2_IER_UIE; //TIM2_IER_CC1IE;	//overflow int and compare 1
4690  052c 72105303      	bset	_TIM2_IER,#0
4691                     ; 242 }
4694  0530 81            	ret
4743                     ; 1 void time_write(void)
4743                     ; 2 {
4744                     	switch	.text
4745  0531               _time_write:
4749                     ; 5 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
4751  0531 b614          	ld	a,_fresh_hours_dec
4752  0533 97            	ld	xl,a
4753  0534 a610          	ld	a,#16
4754  0536 42            	mul	x,a
4755  0537 9f            	ld	a,xl
4756  0538 bb13          	add	a,_fresh_hours
4757  053a b713          	ld	_fresh_hours,a
4758                     ; 6 	fresh_min = fresh_min + (fresh_min_dec<<4);
4760  053c b612          	ld	a,_fresh_min_dec
4761  053e 97            	ld	xl,a
4762  053f a610          	ld	a,#16
4763  0541 42            	mul	x,a
4764  0542 9f            	ld	a,xl
4765  0543 bb11          	add	a,_fresh_min
4766  0545 b711          	ld	_fresh_min,a
4767                     ; 7 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
4769  0547 b610          	ld	a,_fresh_sec_dec
4770  0549 97            	ld	xl,a
4771  054a a610          	ld	a,#16
4772  054c 42            	mul	x,a
4773  054d 9f            	ld	a,xl
4774  054e bb0f          	add	a,_fresh_sec
4775  0550 b70f          	ld	_fresh_sec,a
4776                     ; 8 	timers_int_off();
4778  0552 adcb          	call	_timers_int_off
4780                     ; 9 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
4782  0554 4b01          	push	#1
4783  0556 ae0013        	ldw	x,#_fresh_hours
4784  0559 89            	pushw	x
4785  055a aed002        	ldw	x,#53250
4786  055d cd013e        	call	_i2c_wr_reg
4788  0560 5b03          	addw	sp,#3
4789                     ; 10 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
4791  0562 4b01          	push	#1
4792  0564 ae0011        	ldw	x,#_fresh_min
4793  0567 89            	pushw	x
4794  0568 aed001        	ldw	x,#53249
4795  056b cd013e        	call	_i2c_wr_reg
4797  056e 5b03          	addw	sp,#3
4798                     ; 11 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
4800  0570 4b01          	push	#1
4801  0572 ae000f        	ldw	x,#_fresh_sec
4802  0575 89            	pushw	x
4803  0576 aed000        	ldw	x,#53248
4804  0579 cd013e        	call	_i2c_wr_reg
4806  057c 5b03          	addw	sp,#3
4807                     ; 12 	timers_int_on();
4809  057e ada8          	call	_timers_int_on
4811                     ; 13 }
4814  0580 81            	ret
4866                     ; 15 uint8_t kostil_k155 (uint8_t byte)
4866                     ; 16 {
4867                     	switch	.text
4868  0581               _kostil_k155:
4870  0581 88            	push	a
4871  0582 89            	pushw	x
4872       00000002      OFST:	set	2
4875                     ; 17 	uint8_t tmp = (byte<<1) & 0b00001100;
4877  0583 48            	sll	a
4878  0584 a40c          	and	a,#12
4879  0586 6b01          	ld	(OFST-1,sp),a
4880                     ; 18 	uint8_t tmp2 = (byte>>2) & 0b00000010;
4882  0588 7b03          	ld	a,(OFST+1,sp)
4883  058a 44            	srl	a
4884  058b 44            	srl	a
4885  058c a402          	and	a,#2
4886  058e 6b02          	ld	(OFST+0,sp),a
4887                     ; 19 	byte &= 1;
4889  0590 7b03          	ld	a,(OFST+1,sp)
4890  0592 a401          	and	a,#1
4891  0594 6b03          	ld	(OFST+1,sp),a
4892                     ; 20 	byte |= tmp | tmp2;
4894  0596 7b01          	ld	a,(OFST-1,sp)
4895  0598 1a02          	or	a,(OFST+0,sp)
4896  059a 1a03          	or	a,(OFST+1,sp)
4897  059c 6b03          	ld	(OFST+1,sp),a
4898                     ; 21 	return byte;
4900  059e 7b03          	ld	a,(OFST+1,sp)
4903  05a0 5b03          	addw	sp,#3
4904  05a2 81            	ret
4945                     ; 1 void spi_setup(void)
4945                     ; 2  {
4946                     	switch	.text
4947  05a3               _spi_setup:
4951                     ; 3     SPI_CR1= 0b01110100;//0x7C;       //this
4953  05a3 35745200      	mov	_SPI_CR1,#116
4954                     ; 5  }
4957  05a7 81            	ret
4993                     ; 8 void spi_send(uint8_t msg)
4993                     ; 9 {
4994                     	switch	.text
4995  05a8               _spi_send:
4997  05a8 88            	push	a
4998       00000000      OFST:	set	0
5001  05a9               L7003:
5002                     ; 11 	while((SPI_SR & SPI_SR_BSY) != 0)
5004  05a9 c65203        	ld	a,_SPI_SR
5005  05ac a580          	bcp	a,#128
5006  05ae 26f9          	jrne	L7003
5007                     ; 14 	SPI_DR = msg;
5009  05b0 7b01          	ld	a,(OFST+1,sp)
5010  05b2 c75204        	ld	_SPI_DR,a
5011                     ; 15 }
5014  05b5 84            	pop	a
5015  05b6 81            	ret
5057                     ; 4 void UART_Resieved (void)
5057                     ; 5 {
5058                     	switch	.text
5059  05b7               _UART_Resieved:
5063                     ; 6 	uart_routine(UART1_DR);
5065  05b7 c65231        	ld	a,_UART1_DR
5066  05ba cd002a        	call	_uart_routine
5068                     ; 7 }
5071  05bd 81            	ret
5096                     ; 9 void SPI_Transmitted(void)
5096                     ; 10 {
5097                     	switch	.text
5098  05be               _SPI_Transmitted:
5102                     ; 11 	spi_send(temp3);
5104  05be b609          	ld	a,_temp3
5105  05c0 ade6          	call	_spi_send
5107                     ; 12 }
5110  05c2 81            	ret
5133                     ; 14 void I2C_Event(void)
5133                     ; 15 {
5134                     	switch	.text
5135  05c3               _I2C_Event:
5139                     ; 17 }
5142  05c3 81            	ret
5168                     ; 19 void Keys_switched(void)
5168                     ; 20 {
5169                     	switch	.text
5170  05c4               _Keys_switched:
5174                     ; 21 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
5176  05c4 c650a0        	ld	a,_EXTI_CR1
5177  05c7 43            	cpl	a
5178  05c8 a430          	and	a,#48
5179  05ca c750a0        	ld	_EXTI_CR1,a
5180                     ; 22 	PC_CR2 = 0;
5182  05cd 725f500e      	clr	_PC_CR2
5183                     ; 23 	timer2_start(0xff);	
5185  05d1 ae00ff        	ldw	x,#255
5186  05d4 cd0365        	call	_timer2_start
5188                     ; 24 }
5191  05d7 81            	ret
5226                     ; 26 void time_refresh (void)
5226                     ; 27 {
5227                     	switch	.text
5228  05d8               _time_refresh:
5232                     ; 29 	timers_int_off();
5234  05d8 cd051f        	call	_timers_int_off
5236                     ; 30 	i2c_rd_reg(0xD0, 0, &fresh_sec, 1); 	
5238  05db 4b01          	push	#1
5239  05dd ae000f        	ldw	x,#_fresh_sec
5240  05e0 89            	pushw	x
5241  05e1 aed000        	ldw	x,#53248
5242  05e4 cd01a1        	call	_i2c_rd_reg
5244  05e7 5b03          	addw	sp,#3
5245                     ; 31 	i2c_rd_reg(0xD0, 1, &fresh_min, 1);
5247  05e9 4b01          	push	#1
5248  05eb ae0011        	ldw	x,#_fresh_min
5249  05ee 89            	pushw	x
5250  05ef aed001        	ldw	x,#53249
5251  05f2 cd01a1        	call	_i2c_rd_reg
5253  05f5 5b03          	addw	sp,#3
5254                     ; 32 	i2c_rd_reg(0xD0, 2, &fresh_hours, 1);
5256  05f7 4b01          	push	#1
5257  05f9 ae0013        	ldw	x,#_fresh_hours
5258  05fc 89            	pushw	x
5259  05fd aed002        	ldw	x,#53250
5260  0600 cd01a1        	call	_i2c_rd_reg
5262  0603 5b03          	addw	sp,#3
5263                     ; 33 	timers_int_on();
5265  0605 cd0528        	call	_timers_int_on
5267                     ; 35 	seconds_tens = (fresh_sec & 0xf0)>>4;
5269  0608 b60f          	ld	a,_fresh_sec
5270  060a a4f0          	and	a,#240
5271  060c 4e            	swap	a
5272  060d a40f          	and	a,#15
5273  060f b70a          	ld	_seconds_tens,a
5274                     ; 36 	minutes_tens = (fresh_min & 0xf0)>>4;
5276  0611 b611          	ld	a,_fresh_min
5277  0613 a4f0          	and	a,#240
5278  0615 4e            	swap	a
5279  0616 a40f          	and	a,#15
5280  0618 b709          	ld	_minutes_tens,a
5281                     ; 37 	hours_tens = (fresh_hours & 0xf0)>>4;
5283  061a b613          	ld	a,_fresh_hours
5284  061c a4f0          	and	a,#240
5285  061e 4e            	swap	a
5286  061f a40f          	and	a,#15
5287  0621 b708          	ld	_hours_tens,a
5288                     ; 39 	seconds = fresh_sec & 0x0f;
5290  0623 b60f          	ld	a,_fresh_sec
5291  0625 a40f          	and	a,#15
5292  0627 b70b          	ld	_seconds,a
5293                     ; 40 	minutes = fresh_min & 0x0f;
5295  0629 b611          	ld	a,_fresh_min
5296  062b a40f          	and	a,#15
5297  062d b70c          	ld	_minutes,a
5298                     ; 41 	hours = fresh_hours & 0x0f;
5300  062f b613          	ld	a,_fresh_hours
5301  0631 a40f          	and	a,#15
5302  0633 b70d          	ld	_hours,a
5303                     ; 42 }
5306  0635 81            	ret
5374                     ; 21 int main( void )
5374                     ; 22 {
5375                     	switch	.text
5376  0636               _main:
5380                     ; 24 		CLK_CKDIVR=0;                //	no dividers
5382  0636 725f50c6      	clr	_CLK_CKDIVR
5383                     ; 26 		for (i = 0; i < 0xFFFF; i++);
5385  063a 5f            	clrw	x
5386  063b bf0b          	ldw	_i,x
5387  063d               L7013:
5391  063d be0b          	ldw	x,_i
5392  063f 1c0001        	addw	x,#1
5393  0642 bf0b          	ldw	_i,x
5396  0644 be0b          	ldw	x,_i
5397  0646 a3ffff        	cpw	x,#65535
5398  0649 25f2          	jrult	L7013
5399                     ; 27 		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //clocking for TIM1, UART1, SPI i I2C
5401  064b 35ff50c7      	mov	_CLK_PCKENR1,#255
5402                     ; 30     PA_DDR=(1<<3) | (1<<2); //0b000001000; //output for register's latch, input for RTC 1 Hz pulse
5404  064f 350c5002      	mov	_PA_DDR,#12
5405                     ; 31     PA_CR1= 0xff;        //	pull-up on inputs, push-pull on outputs
5407  0653 35ff5003      	mov	_PA_CR1,#255
5408                     ; 32     PA_ODR |= (1<<3);
5410  0657 72165000      	bset	_PA_ODR,#3
5411                     ; 33 		PA_CR2 |=(1<<3);        //	interrupt on PA1 for 1hz
5413  065b 72165004      	bset	_PA_CR2,#3
5414                     ; 35     PC_DDR=0x60; //0b01100000; // buttons pins as input
5416  065f 3560500c      	mov	_PC_DDR,#96
5417                     ; 36     PC_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5419  0663 35ff500d      	mov	_PC_CR1,#255
5420                     ; 37     PC_CR2 |= (1<<4) | (1<<3);        //	interrapts for buttons
5422  0667 c6500e        	ld	a,_PC_CR2
5423  066a aa18          	or	a,#24
5424  066c c7500e        	ld	_PC_CR2,a
5425                     ; 39 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM
5427  066f 35a85011      	mov	_PD_DDR,#168
5428                     ; 40     PD_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5430  0673 35ff5012      	mov	_PD_CR1,#255
5431                     ; 41     PD_ODR = (1 << 3);
5433  0677 3508500f      	mov	_PD_ODR,#8
5434                     ; 45     spi_setup();
5436  067b cd05a3        	call	_spi_setup
5438                     ; 48 		uart_setup();
5440  067e cd0000        	call	_uart_setup
5442                     ; 49 		uart_send('h');
5444  0681 a668          	ld	a,#104
5445  0683 cd0019        	call	_uart_send
5447                     ; 52     timer1_setup( 65500,0xffff);//	freq in hz and top value
5449  0686 aeffff        	ldw	x,#65535
5450  0689 89            	pushw	x
5451  068a aeffdc        	ldw	x,#65500
5452  068d cd02e4        	call	_timer1_setup
5454  0690 85            	popw	x
5455                     ; 53 		timer2_setup();
5457  0691 cd034f        	call	_timer2_setup
5459                     ; 54 		timer1_start();
5461  0694 cd0360        	call	_timer1_start
5463                     ; 55 		timer2_start(TIM2_TOP);
5465  0697 ae3e80        	ldw	x,#16000
5466  069a cd0365        	call	_timer2_start
5468                     ; 59 		i2c_master_init(16000000, 50000);
5470  069d aec350        	ldw	x,#50000
5471  06a0 89            	pushw	x
5472  06a1 ae0000        	ldw	x,#0
5473  06a4 89            	pushw	x
5474  06a5 ae2400        	ldw	x,#9216
5475  06a8 89            	pushw	x
5476  06a9 ae00f4        	ldw	x,#244
5477  06ac 89            	pushw	x
5478  06ad cd00bc        	call	_i2c_master_init
5480  06b0 5b08          	addw	sp,#8
5481                     ; 62 		timers_int_off();
5483  06b2 cd051f        	call	_timers_int_off
5485                     ; 64 		i2c_rd_reg(ds_address, 7, &temp, 1);
5487  06b5 4b01          	push	#1
5488  06b7 ae0002        	ldw	x,#_temp
5489  06ba 89            	pushw	x
5490  06bb aed007        	ldw	x,#53255
5491  06be cd01a1        	call	_i2c_rd_reg
5493  06c1 5b03          	addw	sp,#3
5494                     ; 65 	if (temp != 0b10010000)	// if OUT and SWQ == 0
5496  06c3 b602          	ld	a,_temp
5497  06c5 a190          	cp	a,#144
5498  06c7 270e          	jreq	L5113
5499                     ; 67 			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//	setup RTC for 1Hz output
5501  06c9 4b01          	push	#1
5502  06cb ae000e        	ldw	x,#_ds_cr
5503  06ce 89            	pushw	x
5504  06cf aed007        	ldw	x,#53255
5505  06d2 cd013e        	call	_i2c_wr_reg
5507  06d5 5b03          	addw	sp,#3
5508  06d7               L5113:
5509                     ; 70 		i2c_rd_reg(ds_address, 0, &temp, 1);
5511  06d7 4b01          	push	#1
5512  06d9 ae0002        	ldw	x,#_temp
5513  06dc 89            	pushw	x
5514  06dd aed000        	ldw	x,#53248
5515  06e0 cd01a1        	call	_i2c_rd_reg
5517  06e3 5b03          	addw	sp,#3
5518                     ; 73 	if((temp & 0x80) == 0x80)
5520  06e5 b602          	ld	a,_temp
5521  06e7 a480          	and	a,#128
5522  06e9 a180          	cp	a,#128
5523  06eb 2610          	jrne	L7113
5524                     ; 75 		temp = 0;
5526  06ed 3f02          	clr	_temp
5527                     ; 76 		i2c_wr_reg(ds_address, 0, &temp, 1);
5529  06ef 4b01          	push	#1
5530  06f1 ae0002        	ldw	x,#_temp
5531  06f4 89            	pushw	x
5532  06f5 aed000        	ldw	x,#53248
5533  06f8 cd013e        	call	_i2c_wr_reg
5535  06fb 5b03          	addw	sp,#3
5536  06fd               L7113:
5537                     ; 78 		timers_int_on();
5539  06fd cd0528        	call	_timers_int_on
5541                     ; 80 		_asm ("RIM");  //on interupts
5544  0700 9a            RIM
5546  0701               L1213:
5548  0701 20fe          	jra	L1213
5561                     	xdef	_main
5562                     	xdef	_Keys_switched
5563                     	xdef	_I2C_Event
5564                     	xdef	_SPI_Transmitted
5565                     	xdef	_UART_Resieved
5566                     	xdef	_spi_setup
5567                     	xdef	_timer2_compare
5568                     	xdef	_Timer1_overflow
5569                     	xdef	_Timer2_Overflow
5570                     	xdef	_timer2_start
5571                     	xdef	_timer1_start
5572                     	xdef	_timer2_setup
5573                     	xdef	_timer1_setup
5574                     	xdef	_kostil_k155
5575                     	xdef	_time_refresh
5576                     	xdef	_timers_int_on
5577                     	xdef	_timers_int_off
5578                     	xdef	_spi_send
5579                     	xdef	_i2c_rd_reg
5580                     	xdef	_i2c_wr_reg
5581                     	xdef	_i2c_master_init
5582                     	xdef	_Key_interrupt
5583                     	xdef	_uart_routine
5584                     	xdef	_uart_send
5585                     	xdef	_uart_setup
5586                     	xdef	_time_write
5587                     	switch	.ubsct
5588  0000               _i2c_flags:
5589  0000 00            	ds.b	1
5590                     	xdef	_i2c_flags
5591  0001               _flags:
5592  0001 00            	ds.b	1
5593                     	xdef	_flags
5594                     	xdef	_ds_cr
5595                     	xdef	_schetchik2
5596                     	xdef	_i
5597                     	xdef	_schetchik
5598                     	xdef	_temp3
5599                     	xdef	_temp2
5600  0002               _temp:
5601  0002 00            	ds.b	1
5602                     	xdef	_temp
5603  0003               _pins:
5604  0003 00            	ds.b	1
5605                     	xdef	_pins
5606  0004               _fresh_data_pointer:
5607  0004 0000          	ds.b	2
5608                     	xdef	_fresh_data_pointer
5609  0006               _data_pointer:
5610  0006 0000          	ds.b	2
5611                     	xdef	_data_pointer
5612                     	xdef	_time_pointer
5613  0008               _hours_tens:
5614  0008 00            	ds.b	1
5615                     	xdef	_hours_tens
5616  0009               _minutes_tens:
5617  0009 00            	ds.b	1
5618                     	xdef	_minutes_tens
5619  000a               _seconds_tens:
5620  000a 00            	ds.b	1
5621                     	xdef	_seconds_tens
5622  000b               _seconds:
5623  000b 00            	ds.b	1
5624                     	xdef	_seconds
5625  000c               _minutes:
5626  000c 00            	ds.b	1
5627                     	xdef	_minutes
5628  000d               _hours:
5629  000d 00            	ds.b	1
5630                     	xdef	_hours
5631  000e               _timeset:
5632  000e 00            	ds.b	1
5633                     	xdef	_timeset
5634  000f               _fresh_sec:
5635  000f 00            	ds.b	1
5636                     	xdef	_fresh_sec
5637  0010               _fresh_sec_dec:
5638  0010 00            	ds.b	1
5639                     	xdef	_fresh_sec_dec
5640  0011               _fresh_min:
5641  0011 00            	ds.b	1
5642                     	xdef	_fresh_min
5643  0012               _fresh_min_dec:
5644  0012 00            	ds.b	1
5645                     	xdef	_fresh_min_dec
5646  0013               _fresh_hours:
5647  0013 00            	ds.b	1
5648                     	xdef	_fresh_hours
5649  0014               _fresh_hours_dec:
5650  0014 00            	ds.b	1
5651                     	xdef	_fresh_hours_dec
5652                     	xdef	_dots_on
5653                     	xdef	_dots_upd
5654  0015               _lamp_number_data:
5655  0015 00            	ds.b	1
5656                     	xdef	_lamp_number_data
5657  0016               _k155_data:
5658  0016 00            	ds.b	1
5659                     	xdef	_k155_data
5660                     	xdef	_dots
5661                     	xdef	_lamp_number
5662                     	xref.b	c_lreg
5663                     	xref.b	c_x
5683                     	xref	c_lrsh
5684                     	xref	c_ldiv
5685                     	xref	c_uitolx
5686                     	xref	c_ludv
5687                     	xref	c_rtol
5688                     	xref	c_ltor
5689                     	end
