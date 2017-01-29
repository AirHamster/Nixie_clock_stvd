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
2875  005b cd0475        	call	_time_write
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
4102                     ; 48 void Timer2_Overflow (void)
4102                     ; 49 {
4103                     	switch	.text
4104  0388               _Timer2_Overflow:
4108                     ; 50 	TIM2_SR1 &= ~TIM2_SR1_UIF;
4110  0388 72115304      	bres	_TIM2_SR1,#0
4111                     ; 51 		lamp_number_data |= dots;
4113  038c b615          	ld	a,_lamp_number_data
4114  038e ba01          	or	a,_dots
4115  0390 b715          	ld	_lamp_number_data,a
4116                     ; 54 			spi_send();
4118  0392 cd04ec        	call	_spi_send
4120                     ; 58 }
4123  0395 81            	ret
4149                     ; 60 void Timer1_overflow (void){
4150                     	switch	.text
4151  0396               _Timer1_overflow:
4155                     ; 61 	TIM1_SR1 = 0;
4157  0396 725f5255      	clr	_TIM1_SR1
4158                     ; 62 	if (dots_on == 0){
4160  039a be04          	ldw	x,_dots_on
4161  039c 2607          	jrne	L3452
4162                     ; 63 		dots_on = 1;
4164  039e ae0001        	ldw	x,#1
4165  03a1 bf04          	ldw	_dots_on,x
4167  03a3 2003          	jra	L5452
4168  03a5               L3452:
4169                     ; 67 		dots_on = 0;
4171  03a5 5f            	clrw	x
4172  03a6 bf04          	ldw	_dots_on,x
4173  03a8               L5452:
4174                     ; 72 	time_refresh();
4176  03a8 cd0536        	call	_time_refresh
4178                     ; 73 }
4181  03ab 81            	ret
4220                     ; 75 void timer2_compare(void)
4220                     ; 76 {
4221                     	switch	.text
4222  03ac               _timer2_compare:
4226                     ; 77 	TIM2_SR1 &= ~TIM2_SR1_CC1IF;
4228  03ac 72135304      	bres	_TIM2_SR1,#1
4229                     ; 79 	if (schetchik == 1)
4231  03b0 b60a          	ld	a,_schetchik
4232  03b2 a101          	cp	a,#1
4233  03b4 2658          	jrne	L7652
4234                     ; 81 	switch (lamp_number)
4236  03b6 b600          	ld	a,_lamp_number
4238                     ; 94 	break;
4239  03b8 4d            	tnz	a
4240  03b9 270b          	jreq	L7452
4241  03bb 4a            	dec	a
4242  03bc 270d          	jreq	L1552
4243  03be 4a            	dec	a
4244  03bf 270f          	jreq	L3552
4245  03c1 4a            	dec	a
4246  03c2 2711          	jreq	L5552
4247  03c4 2012          	jra	L3752
4248  03c6               L7452:
4249                     ; 83 	case 0:
4249                     ; 84 	k155_data = hours_tens; 
4251  03c6 450816        	mov	_k155_data,_hours_tens
4252                     ; 85 	break;
4254  03c9 200d          	jra	L3752
4255  03cb               L1552:
4256                     ; 86 	case 1:
4256                     ; 87 	k155_data = hours;
4258  03cb 450d16        	mov	_k155_data,_hours
4259                     ; 88 	break;
4261  03ce 2008          	jra	L3752
4262  03d0               L3552:
4263                     ; 89 	case 2:
4263                     ; 90 	k155_data = minutes_tens;
4265  03d0 450916        	mov	_k155_data,_minutes_tens
4266                     ; 91 	break;
4268  03d3 2003          	jra	L3752
4269  03d5               L5552:
4270                     ; 92 	case 3:
4270                     ; 93 	k155_data = minutes;
4272  03d5 450c16        	mov	_k155_data,_minutes
4273                     ; 94 	break;
4275  03d8               L3752:
4276                     ; 97 	if (lamp_number < 3)
4278  03d8 b600          	ld	a,_lamp_number
4279  03da a103          	cp	a,#3
4280  03dc 2415          	jruge	L5752
4281                     ; 99 			lamp_number_data = (1<<(lamp_number++));
4283  03de b600          	ld	a,_lamp_number
4284  03e0 97            	ld	xl,a
4285  03e1 3c00          	inc	_lamp_number
4286  03e3 9f            	ld	a,xl
4287  03e4 5f            	clrw	x
4288  03e5 97            	ld	xl,a
4289  03e6 a601          	ld	a,#1
4290  03e8 5d            	tnzw	x
4291  03e9 2704          	jreq	L04
4292  03eb               L24:
4293  03eb 48            	sll	a
4294  03ec 5a            	decw	x
4295  03ed 26fc          	jrne	L24
4296  03ef               L04:
4297  03ef b715          	ld	_lamp_number_data,a
4299  03f1 2017          	jra	L7752
4300  03f3               L5752:
4301                     ; 101 		else if (lamp_number >= 3)
4303  03f3 b600          	ld	a,_lamp_number
4304  03f5 a103          	cp	a,#3
4305  03f7 2511          	jrult	L7752
4306                     ; 103 			lamp_number_data = (1<<(lamp_number));
4308  03f9 b600          	ld	a,_lamp_number
4309  03fb 5f            	clrw	x
4310  03fc 97            	ld	xl,a
4311  03fd a601          	ld	a,#1
4312  03ff 5d            	tnzw	x
4313  0400 2704          	jreq	L44
4314  0402               L64:
4315  0402 48            	sll	a
4316  0403 5a            	decw	x
4317  0404 26fc          	jrne	L64
4318  0406               L44:
4319  0406 b715          	ld	_lamp_number_data,a
4320                     ; 104 			lamp_number = 0;
4322  0408 3f00          	clr	_lamp_number
4323  040a               L7752:
4324                     ; 108 	schetchik = 0;
4326  040a 3f0a          	clr	_schetchik
4328  040c 2006          	jra	L3062
4329  040e               L7652:
4330                     ; 112 		lamp_number_data = 0;
4332  040e 3f15          	clr	_lamp_number_data
4333                     ; 113 		schetchik = 1;
4335  0410 3501000a      	mov	_schetchik,#1
4336  0414               L3062:
4337                     ; 117 	if (dots_on == 1){
4339  0414 be04          	ldw	x,_dots_on
4340  0416 a30001        	cpw	x,#1
4341  0419 261c          	jrne	L5062
4342                     ; 118 		if (dots_upd < 10000){
4344  041b be02          	ldw	x,_dots_upd
4345  041d a32710        	cpw	x,#10000
4346  0420 242c          	jruge	L1162
4347                     ; 119 			dots_upd +=10;
4349  0422 be02          	ldw	x,_dots_upd
4350  0424 1c000a        	addw	x,#10
4351  0427 bf02          	ldw	_dots_upd,x
4352                     ; 120 			TIM2_CCR1H = dots_upd >> 8;
4354  0429 5500025311    	mov	_TIM2_CCR1H,_dots_upd
4355                     ; 121 			TIM2_CCR1L = dots_upd & 0xFF;
4357  042e b603          	ld	a,_dots_upd+1
4358  0430 a4ff          	and	a,#255
4359  0432 c75312        	ld	_TIM2_CCR1L,a
4360  0435 2017          	jra	L1162
4361  0437               L5062:
4362                     ; 125 			if (dots_upd > 0){
4364  0437 be02          	ldw	x,_dots_upd
4365  0439 2713          	jreq	L1162
4366                     ; 126 				dots_upd -= 10;
4368  043b be02          	ldw	x,_dots_upd
4369  043d 1d000a        	subw	x,#10
4370  0440 bf02          	ldw	_dots_upd,x
4371                     ; 127 				TIM2_CCR1H = dots_upd >> 8;
4373  0442 5500025311    	mov	_TIM2_CCR1H,_dots_upd
4374                     ; 128 				TIM2_CCR1L = dots_upd & 0xFF;
4376  0447 b603          	ld	a,_dots_upd+1
4377  0449 a4ff          	and	a,#255
4378  044b c75312        	ld	_TIM2_CCR1L,a
4379  044e               L1162:
4380                     ; 134 		k155_data = kostil_k155(k155_data);
4382  044e b616          	ld	a,_k155_data
4383  0450 ad73          	call	_kostil_k155
4385  0452 b716          	ld	_k155_data,a
4386                     ; 135 		lamp_number_data &= ~dots;
4388  0454 b601          	ld	a,_dots
4389  0456 43            	cpl	a
4390  0457 b415          	and	a,_lamp_number_data
4391  0459 b715          	ld	_lamp_number_data,a
4392                     ; 136 		spi_send();
4394  045b cd04ec        	call	_spi_send
4396                     ; 142 	return;
4399  045e 81            	ret
4424                     ; 146 void timers_int_off(void)
4424                     ; 147 {
4425                     	switch	.text
4426  045f               _timers_int_off:
4430                     ; 148 	TIM1_IER &= ~TIM1_IER_UIE;
4432  045f 72115254      	bres	_TIM1_IER,#0
4433                     ; 150 	TIM2_IER = 0;
4435  0463 725f5303      	clr	_TIM2_IER
4436                     ; 151 }
4439  0467 81            	ret
4464                     ; 154 void timers_int_on(void)
4464                     ; 155 {
4465                     	switch	.text
4466  0468               _timers_int_on:
4470                     ; 156 	TIM1_IER |= TIM1_IER_UIE;
4472  0468 72105254      	bset	_TIM1_IER,#0
4473                     ; 157 	TIM2_IER |=	TIM2_IER_CC1IE |TIM2_IER_UIE;	//overflow int and compare 1
4475  046c c65303        	ld	a,_TIM2_IER
4476  046f aa03          	or	a,#3
4477  0471 c75303        	ld	_TIM2_IER,a
4478                     ; 158 }
4481  0474 81            	ret
4530                     ; 1 void time_write(void)
4530                     ; 2 {
4531                     	switch	.text
4532  0475               _time_write:
4536                     ; 5 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
4538  0475 b614          	ld	a,_fresh_hours_dec
4539  0477 97            	ld	xl,a
4540  0478 a610          	ld	a,#16
4541  047a 42            	mul	x,a
4542  047b 9f            	ld	a,xl
4543  047c bb13          	add	a,_fresh_hours
4544  047e b713          	ld	_fresh_hours,a
4545                     ; 6 	fresh_min = fresh_min + (fresh_min_dec<<4);
4547  0480 b612          	ld	a,_fresh_min_dec
4548  0482 97            	ld	xl,a
4549  0483 a610          	ld	a,#16
4550  0485 42            	mul	x,a
4551  0486 9f            	ld	a,xl
4552  0487 bb11          	add	a,_fresh_min
4553  0489 b711          	ld	_fresh_min,a
4554                     ; 7 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
4556  048b b610          	ld	a,_fresh_sec_dec
4557  048d 97            	ld	xl,a
4558  048e a610          	ld	a,#16
4559  0490 42            	mul	x,a
4560  0491 9f            	ld	a,xl
4561  0492 bb0f          	add	a,_fresh_sec
4562  0494 b70f          	ld	_fresh_sec,a
4563                     ; 8 	timers_int_off();
4565  0496 adc7          	call	_timers_int_off
4567                     ; 9 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
4569  0498 4b01          	push	#1
4570  049a ae0013        	ldw	x,#_fresh_hours
4571  049d 89            	pushw	x
4572  049e aed002        	ldw	x,#53250
4573  04a1 cd013e        	call	_i2c_wr_reg
4575  04a4 5b03          	addw	sp,#3
4576                     ; 10 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
4578  04a6 4b01          	push	#1
4579  04a8 ae0011        	ldw	x,#_fresh_min
4580  04ab 89            	pushw	x
4581  04ac aed001        	ldw	x,#53249
4582  04af cd013e        	call	_i2c_wr_reg
4584  04b2 5b03          	addw	sp,#3
4585                     ; 11 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
4587  04b4 4b01          	push	#1
4588  04b6 ae000f        	ldw	x,#_fresh_sec
4589  04b9 89            	pushw	x
4590  04ba aed000        	ldw	x,#53248
4591  04bd cd013e        	call	_i2c_wr_reg
4593  04c0 5b03          	addw	sp,#3
4594                     ; 12 	timers_int_on();
4596  04c2 ada4          	call	_timers_int_on
4598                     ; 13 }
4601  04c4 81            	ret
4653                     ; 15 uint8_t kostil_k155 (uint8_t byte)
4653                     ; 16 {
4654                     	switch	.text
4655  04c5               _kostil_k155:
4657  04c5 88            	push	a
4658  04c6 89            	pushw	x
4659       00000002      OFST:	set	2
4662                     ; 17 	uint8_t tmp = (byte<<1) & 0b00001100;
4664  04c7 48            	sll	a
4665  04c8 a40c          	and	a,#12
4666  04ca 6b01          	ld	(OFST-1,sp),a
4667                     ; 18 	uint8_t tmp2 = (byte>>2) & 0b00000010;
4669  04cc 7b03          	ld	a,(OFST+1,sp)
4670  04ce 44            	srl	a
4671  04cf 44            	srl	a
4672  04d0 a402          	and	a,#2
4673  04d2 6b02          	ld	(OFST+0,sp),a
4674                     ; 19 	byte &= 1;
4676  04d4 7b03          	ld	a,(OFST+1,sp)
4677  04d6 a401          	and	a,#1
4678  04d8 6b03          	ld	(OFST+1,sp),a
4679                     ; 20 	byte |= tmp | tmp2;
4681  04da 7b01          	ld	a,(OFST-1,sp)
4682  04dc 1a02          	or	a,(OFST+0,sp)
4683  04de 1a03          	or	a,(OFST+1,sp)
4684  04e0 6b03          	ld	(OFST+1,sp),a
4685                     ; 21 	return byte;
4687  04e2 7b03          	ld	a,(OFST+1,sp)
4690  04e4 5b03          	addw	sp,#3
4691  04e6 81            	ret
4732                     ; 1 void spi_setup(void)
4732                     ; 2  {
4733                     	switch	.text
4734  04e7               _spi_setup:
4738                     ; 3     SPI_CR1= 0b01000100;//0x7C;       //this
4740  04e7 35445200      	mov	_SPI_CR1,#68
4741                     ; 6  }
4744  04eb 81            	ret
4772                     ; 9 void spi_send (void)
4772                     ; 10 {
4773                     	switch	.text
4774  04ec               _spi_send:
4778                     ; 16 	SPI_SR = 0;
4780  04ec 725f5203      	clr	_SPI_SR
4781                     ; 18 	PA_ODR &= (0<<3);
4783  04f0 725f5000      	clr	_PA_ODR
4784                     ; 19 	SPI_DR = k155_data;
4786  04f4 5500165204    	mov	_SPI_DR,_k155_data
4787                     ; 20 	SPI_ICR |= SPI_ICR_TXEI;
4789  04f9 721e5202      	bset	_SPI_ICR,#7
4790                     ; 21 }
4793  04fd 81            	ret
4821                     ; 22 void spi_send2 (void)
4821                     ; 23 {
4822                     	switch	.text
4823  04fe               _spi_send2:
4827                     ; 24 	SPI_SR = 0;
4829  04fe 725f5203      	clr	_SPI_SR
4830                     ; 25 	SPI_ICR = 0;
4832  0502 725f5202      	clr	_SPI_ICR
4833                     ; 26 	SPI_DR = lamp_number_data;
4835  0506 5500155204    	mov	_SPI_DR,_lamp_number_data
4837  050b               L3472:
4838                     ; 27 	while((SPI_SR & SPI_SR_BSY) != 0);
4840  050b c65203        	ld	a,_SPI_SR
4841  050e a580          	bcp	a,#128
4842  0510 26f9          	jrne	L3472
4843                     ; 28 	PA_ODR |= (1<<3);
4845  0512 72165000      	bset	_PA_ODR,#3
4846                     ; 30 }
4849  0516 81            	ret
4891                     ; 4 void UART_Resieved (void)
4891                     ; 5 {
4892                     	switch	.text
4893  0517               _UART_Resieved:
4897                     ; 6 	uart_routine(UART1_DR);
4899  0517 c65231        	ld	a,_UART1_DR
4900  051a cd002a        	call	_uart_routine
4902                     ; 7 }
4905  051d 81            	ret
4929                     ; 9 void SPI_Transmitted(void)
4929                     ; 10 {
4930                     	switch	.text
4931  051e               _SPI_Transmitted:
4935                     ; 11 	spi_send2();
4937  051e adde          	call	_spi_send2
4939                     ; 12 }
4942  0520 81            	ret
4965                     ; 14 void I2C_Event(void)
4965                     ; 15 {
4966                     	switch	.text
4967  0521               _I2C_Event:
4971                     ; 17 }
4974  0521 81            	ret
5000                     ; 19 void Keys_switched(void)
5000                     ; 20 {
5001                     	switch	.text
5002  0522               _Keys_switched:
5006                     ; 21 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
5008  0522 c650a0        	ld	a,_EXTI_CR1
5009  0525 43            	cpl	a
5010  0526 a430          	and	a,#48
5011  0528 c750a0        	ld	_EXTI_CR1,a
5012                     ; 22 	PC_CR2 = 0;
5014  052b 725f500e      	clr	_PC_CR2
5015                     ; 23 	timer2_start(0xff);	
5017  052f ae00ff        	ldw	x,#255
5018  0532 cd0379        	call	_timer2_start
5020                     ; 24 }
5023  0535 81            	ret
5058                     ; 26 void time_refresh (void)
5058                     ; 27 {
5059                     	switch	.text
5060  0536               _time_refresh:
5064                     ; 29 	timers_int_off();
5066  0536 cd045f        	call	_timers_int_off
5068                     ; 30 	i2c_rd_reg(0xD0, 0, &fresh_sec, 1); 	
5070  0539 4b01          	push	#1
5071  053b ae000f        	ldw	x,#_fresh_sec
5072  053e 89            	pushw	x
5073  053f aed000        	ldw	x,#53248
5074  0542 cd01a1        	call	_i2c_rd_reg
5076  0545 5b03          	addw	sp,#3
5077                     ; 31 	i2c_rd_reg(0xD0, 1, &fresh_min, 1);
5079  0547 4b01          	push	#1
5080  0549 ae0011        	ldw	x,#_fresh_min
5081  054c 89            	pushw	x
5082  054d aed001        	ldw	x,#53249
5083  0550 cd01a1        	call	_i2c_rd_reg
5085  0553 5b03          	addw	sp,#3
5086                     ; 32 	i2c_rd_reg(0xD0, 2, &fresh_hours, 1);
5088  0555 4b01          	push	#1
5089  0557 ae0013        	ldw	x,#_fresh_hours
5090  055a 89            	pushw	x
5091  055b aed002        	ldw	x,#53250
5092  055e cd01a1        	call	_i2c_rd_reg
5094  0561 5b03          	addw	sp,#3
5095                     ; 33 	timers_int_on();
5097  0563 cd0468        	call	_timers_int_on
5099                     ; 35 	seconds_tens = (fresh_sec & 0xf0)>>4;
5101  0566 b60f          	ld	a,_fresh_sec
5102  0568 a4f0          	and	a,#240
5103  056a 4e            	swap	a
5104  056b a40f          	and	a,#15
5105  056d b70a          	ld	_seconds_tens,a
5106                     ; 36 	minutes_tens = (fresh_min & 0xf0)>>4;
5108  056f b611          	ld	a,_fresh_min
5109  0571 a4f0          	and	a,#240
5110  0573 4e            	swap	a
5111  0574 a40f          	and	a,#15
5112  0576 b709          	ld	_minutes_tens,a
5113                     ; 37 	hours_tens = (fresh_hours & 0xf0)>>4;
5115  0578 b613          	ld	a,_fresh_hours
5116  057a a4f0          	and	a,#240
5117  057c 4e            	swap	a
5118  057d a40f          	and	a,#15
5119  057f b708          	ld	_hours_tens,a
5120                     ; 39 	seconds = fresh_sec & 0x0f;
5122  0581 b60f          	ld	a,_fresh_sec
5123  0583 a40f          	and	a,#15
5124  0585 b70b          	ld	_seconds,a
5125                     ; 40 	minutes = fresh_min & 0x0f;
5127  0587 b611          	ld	a,_fresh_min
5128  0589 a40f          	and	a,#15
5129  058b b70c          	ld	_minutes,a
5130                     ; 41 	hours = fresh_hours & 0x0f;
5132  058d b613          	ld	a,_fresh_hours
5133  058f a40f          	and	a,#15
5134  0591 b70d          	ld	_hours,a
5135                     ; 42 }
5138  0593 81            	ret
5206                     ; 21 int main( void )
5206                     ; 22 {
5207                     	switch	.text
5208  0594               _main:
5212                     ; 24 		CLK_CKDIVR=0;                //	no dividers
5214  0594 725f50c6      	clr	_CLK_CKDIVR
5215                     ; 26 		for (i = 0; i < 0xFFFF; i++);
5217  0598 5f            	clrw	x
5218  0599 bf0b          	ldw	_i,x
5219  059b               L3403:
5223  059b be0b          	ldw	x,_i
5224  059d 1c0001        	addw	x,#1
5225  05a0 bf0b          	ldw	_i,x
5228  05a2 be0b          	ldw	x,_i
5229  05a4 a3ffff        	cpw	x,#65535
5230  05a7 25f2          	jrult	L3403
5231                     ; 27 		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //clocking for TIM1, UART1, SPI i I2C
5233  05a9 35ff50c7      	mov	_CLK_PCKENR1,#255
5234                     ; 30     PA_DDR=(1<<3) | (1<<2); //0b000001000; //output for register's latch, input for RTC 1 Hz pulse
5236  05ad 350c5002      	mov	_PA_DDR,#12
5237                     ; 31     PA_CR1= 0xff;        //	pull-up on inputs, push-pull on outputs
5239  05b1 35ff5003      	mov	_PA_CR1,#255
5240                     ; 32     PA_ODR |= (1<<3);
5242  05b5 72165000      	bset	_PA_ODR,#3
5243                     ; 33 		PA_CR2 |=(1<<3);        //	interrupt on PA1 for 1hz
5245  05b9 72165004      	bset	_PA_CR2,#3
5246                     ; 35     PC_DDR=0x60; //0b01100000; // buttons pins as input
5248  05bd 3560500c      	mov	_PC_DDR,#96
5249                     ; 36     PC_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5251  05c1 35ff500d      	mov	_PC_CR1,#255
5252                     ; 37     PC_CR2 |= (1<<4) | (1<<3);        //	interrapts for buttons
5254  05c5 c6500e        	ld	a,_PC_CR2
5255  05c8 aa18          	or	a,#24
5256  05ca c7500e        	ld	_PC_CR2,a
5257                     ; 39 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM
5259  05cd 35a85011      	mov	_PD_DDR,#168
5260                     ; 40     PD_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5262  05d1 35ff5012      	mov	_PD_CR1,#255
5263                     ; 41     PD_ODR = (1 << 3);
5265  05d5 3508500f      	mov	_PD_ODR,#8
5266                     ; 45     spi_setup();
5268  05d9 cd04e7        	call	_spi_setup
5270                     ; 48 		uart_setup();
5272  05dc cd0000        	call	_uart_setup
5274                     ; 49 		uart_send('h');
5276  05df a668          	ld	a,#104
5277  05e1 cd0019        	call	_uart_send
5279                     ; 52     timer1_setup(65500,0xffff);//	freq in hz and top value
5281  05e4 aeffff        	ldw	x,#65535
5282  05e7 89            	pushw	x
5283  05e8 aeffdc        	ldw	x,#65500
5284  05eb cd02e4        	call	_timer1_setup
5286  05ee 85            	popw	x
5287                     ; 53 		timer2_setup();
5289  05ef cd034f        	call	_timer2_setup
5291                     ; 58 		i2c_master_init(16000000, 100000);
5293  05f2 ae86a0        	ldw	x,#34464
5294  05f5 89            	pushw	x
5295  05f6 ae0001        	ldw	x,#1
5296  05f9 89            	pushw	x
5297  05fa ae2400        	ldw	x,#9216
5298  05fd 89            	pushw	x
5299  05fe ae00f4        	ldw	x,#244
5300  0601 89            	pushw	x
5301  0602 cd00bc        	call	_i2c_master_init
5303  0605 5b08          	addw	sp,#8
5304                     ; 62 		timers_int_off();
5306  0607 cd045f        	call	_timers_int_off
5308                     ; 63 		i2c_rd_reg(ds_address, 7, &temp, 1);
5310  060a 4b01          	push	#1
5311  060c ae0002        	ldw	x,#_temp
5312  060f 89            	pushw	x
5313  0610 aed007        	ldw	x,#53255
5314  0613 cd01a1        	call	_i2c_rd_reg
5316  0616 5b03          	addw	sp,#3
5317                     ; 64 	if (temp != 0b10010000)	// if OUT and SWQ == 0
5319  0618 b602          	ld	a,_temp
5320  061a a190          	cp	a,#144
5321  061c 270e          	jreq	L1503
5322                     ; 66 			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//	setup RTC for 1Hz output
5324  061e 4b01          	push	#1
5325  0620 ae000e        	ldw	x,#_ds_cr
5326  0623 89            	pushw	x
5327  0624 aed007        	ldw	x,#53255
5328  0627 cd013e        	call	_i2c_wr_reg
5330  062a 5b03          	addw	sp,#3
5331  062c               L1503:
5332                     ; 69 		i2c_rd_reg(ds_address, 0, &temp, 1);
5334  062c 4b01          	push	#1
5335  062e ae0002        	ldw	x,#_temp
5336  0631 89            	pushw	x
5337  0632 aed000        	ldw	x,#53248
5338  0635 cd01a1        	call	_i2c_rd_reg
5340  0638 5b03          	addw	sp,#3
5341                     ; 72 	if((temp & 0x80) == 0x80)
5343  063a b602          	ld	a,_temp
5344  063c a480          	and	a,#128
5345  063e a180          	cp	a,#128
5346  0640 2610          	jrne	L3503
5347                     ; 74 		temp = 0;
5349  0642 3f02          	clr	_temp
5350                     ; 75 		i2c_wr_reg(ds_address, 0, &temp, 1);
5352  0644 4b01          	push	#1
5353  0646 ae0002        	ldw	x,#_temp
5354  0649 89            	pushw	x
5355  064a aed000        	ldw	x,#53248
5356  064d cd013e        	call	_i2c_wr_reg
5358  0650 5b03          	addw	sp,#3
5359  0652               L3503:
5360                     ; 77 		timers_int_on();
5362  0652 cd0468        	call	_timers_int_on
5364                     ; 78 		timer1_start();
5366  0655 cd0374        	call	_timer1_start
5368                     ; 79 		timer2_start(TIM2_TOP);
5370  0658 ae3e80        	ldw	x,#16000
5371  065b cd0379        	call	_timer2_start
5373                     ; 80 		_asm ("RIM");  //on interupts
5376  065e 9a            RIM
5378  065f               L5503:
5380  065f 20fe          	jra	L5503
5393                     	xdef	_main
5394                     	xdef	_Keys_switched
5395                     	xdef	_I2C_Event
5396                     	xdef	_SPI_Transmitted
5397                     	xdef	_UART_Resieved
5398                     	xdef	_spi_send2
5399                     	xdef	_spi_setup
5400                     	xdef	_timer2_compare
5401                     	xdef	_Timer1_overflow
5402                     	xdef	_Timer2_Overflow
5403                     	xdef	_timer2_start
5404                     	xdef	_timer1_start
5405                     	xdef	_timer2_setup
5406                     	xdef	_timer1_setup
5407                     	xdef	_kostil_k155
5408                     	xdef	_time_refresh
5409                     	xdef	_timers_int_on
5410                     	xdef	_timers_int_off
5411                     	xdef	_spi_send
5412                     	xdef	_i2c_rd_reg
5413                     	xdef	_i2c_wr_reg
5414                     	xdef	_i2c_master_init
5415                     	xdef	_Key_interrupt
5416                     	xdef	_uart_routine
5417                     	xdef	_uart_send
5418                     	xdef	_uart_setup
5419                     	xdef	_time_write
5420                     	switch	.ubsct
5421  0000               _i2c_flags:
5422  0000 00            	ds.b	1
5423                     	xdef	_i2c_flags
5424  0001               _flags:
5425  0001 00            	ds.b	1
5426                     	xdef	_flags
5427                     	xdef	_ds_cr
5428                     	xdef	_schetchik2
5429                     	xdef	_i
5430                     	xdef	_schetchik
5431                     	xdef	_temp3
5432                     	xdef	_temp2
5433  0002               _temp:
5434  0002 00            	ds.b	1
5435                     	xdef	_temp
5436  0003               _pins:
5437  0003 00            	ds.b	1
5438                     	xdef	_pins
5439  0004               _fresh_data_pointer:
5440  0004 0000          	ds.b	2
5441                     	xdef	_fresh_data_pointer
5442  0006               _data_pointer:
5443  0006 0000          	ds.b	2
5444                     	xdef	_data_pointer
5445                     	xdef	_time_pointer
5446  0008               _hours_tens:
5447  0008 00            	ds.b	1
5448                     	xdef	_hours_tens
5449  0009               _minutes_tens:
5450  0009 00            	ds.b	1
5451                     	xdef	_minutes_tens
5452  000a               _seconds_tens:
5453  000a 00            	ds.b	1
5454                     	xdef	_seconds_tens
5455  000b               _seconds:
5456  000b 00            	ds.b	1
5457                     	xdef	_seconds
5458  000c               _minutes:
5459  000c 00            	ds.b	1
5460                     	xdef	_minutes
5461  000d               _hours:
5462  000d 00            	ds.b	1
5463                     	xdef	_hours
5464  000e               _timeset:
5465  000e 00            	ds.b	1
5466                     	xdef	_timeset
5467  000f               _fresh_sec:
5468  000f 00            	ds.b	1
5469                     	xdef	_fresh_sec
5470  0010               _fresh_sec_dec:
5471  0010 00            	ds.b	1
5472                     	xdef	_fresh_sec_dec
5473  0011               _fresh_min:
5474  0011 00            	ds.b	1
5475                     	xdef	_fresh_min
5476  0012               _fresh_min_dec:
5477  0012 00            	ds.b	1
5478                     	xdef	_fresh_min_dec
5479  0013               _fresh_hours:
5480  0013 00            	ds.b	1
5481                     	xdef	_fresh_hours
5482  0014               _fresh_hours_dec:
5483  0014 00            	ds.b	1
5484                     	xdef	_fresh_hours_dec
5485                     	xdef	_dots_on
5486                     	xdef	_dots_upd
5487  0015               _lamp_number_data:
5488  0015 00            	ds.b	1
5489                     	xdef	_lamp_number_data
5490  0016               _k155_data:
5491  0016 00            	ds.b	1
5492                     	xdef	_k155_data
5493                     	xdef	_dots
5494                     	xdef	_lamp_number
5495                     	xref.b	c_lreg
5496                     	xref.b	c_x
5516                     	xref	c_lrsh
5517                     	xref	c_ldiv
5518                     	xref	c_uitolx
5519                     	xref	c_ludv
5520                     	xref	c_rtol
5521                     	xref	c_ltor
5522                     	end
