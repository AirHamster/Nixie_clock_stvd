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
2767                     ; 18  void uart_routine(uint8_t data)
2767                     ; 19  {
2768                     	switch	.text
2769  002a               _uart_routine:
2771  002a 88            	push	a
2772       00000000      OFST:	set	0
2775                     ; 21 	 temp2 = data - 0x30;
2777  002b a030          	sub	a,#48
2778  002d b704          	ld	_temp2,a
2779                     ; 22 	 if (timeset != 0 && timeset <= 5)
2781  002f 3d0e          	tnz	_timeset
2782  0031 2719          	jreq	L5671
2784  0033 b60e          	ld	a,_timeset
2785  0035 a106          	cp	a,#6
2786  0037 2413          	jruge	L5671
2787                     ; 24 		* fresh_data_pointer-- = data-0x30;
2789  0039 7b01          	ld	a,(OFST+1,sp)
2790  003b a030          	sub	a,#48
2791  003d be04          	ldw	x,_fresh_data_pointer
2792  003f 1d0001        	subw	x,#1
2793  0042 bf04          	ldw	_fresh_data_pointer,x
2794  0044 1c0001        	addw	x,#1
2795  0047 f7            	ld	(x),a
2796                     ; 25 		 timeset++;
2798  0048 3c0e          	inc	_timeset
2799                     ; 26 		 return ;
2802  004a 84            	pop	a
2803  004b 81            	ret
2804  004c               L5671:
2805                     ; 28 	 if (timeset == 6)
2807  004c b60e          	ld	a,_timeset
2808  004e a106          	cp	a,#6
2809  0050 2616          	jrne	L7671
2810                     ; 30 		 *fresh_data_pointer = data-0x30;
2812  0052 7b01          	ld	a,(OFST+1,sp)
2813  0054 a030          	sub	a,#48
2814  0056 92c704        	ld	[_fresh_data_pointer.w],a
2815                     ; 31 		 timeset = 0;
2817  0059 3f0e          	clr	_timeset
2818                     ; 32 		 time_write();
2820  005b cd0413        	call	_time_write
2822                     ; 33 		 uart_send('O');
2824  005e a64f          	ld	a,#79
2825  0060 adb7          	call	_uart_send
2827                     ; 34 		 uart_send('K');
2829  0062 a64b          	ld	a,#75
2830  0064 adb3          	call	_uart_send
2832                     ; 35 		 return;
2835  0066 84            	pop	a
2836  0067 81            	ret
2837  0068               L7671:
2838                     ; 38 	 if (data == 's')
2840  0068 7b01          	ld	a,(OFST+1,sp)
2841  006a a173          	cp	a,#115
2842  006c 260b          	jrne	L1771
2843                     ; 40 			timeset = 1;
2845  006e 3501000e      	mov	_timeset,#1
2846                     ; 41 			fresh_data_pointer = &fresh_hours_dec;
2848  0072 ae0014        	ldw	x,#_fresh_hours_dec
2849  0075 bf04          	ldw	_fresh_data_pointer,x
2850                     ; 42 			return;
2853  0077 84            	pop	a
2854  0078 81            	ret
2855  0079               L1771:
2856                     ; 46 		if (data == 't')
2858  0079 7b01          	ld	a,(OFST+1,sp)
2859  007b a174          	cp	a,#116
2860  007d 2635          	jrne	L3771
2861                     ; 48 			uart_send(hours_tens+0x30);
2863  007f b608          	ld	a,_hours_tens
2864  0081 ab30          	add	a,#48
2865  0083 ad94          	call	_uart_send
2867                     ; 49 			uart_send(hours+0x30);
2869  0085 b60d          	ld	a,_hours
2870  0087 ab30          	add	a,#48
2871  0089 ad8e          	call	_uart_send
2873                     ; 50 			uart_send(':');	
2875  008b a63a          	ld	a,#58
2876  008d ad8a          	call	_uart_send
2878                     ; 51 			uart_send(minutes_tens+0x30);
2880  008f b609          	ld	a,_minutes_tens
2881  0091 ab30          	add	a,#48
2882  0093 ad84          	call	_uart_send
2884                     ; 52 			uart_send(minutes+0x30);
2886  0095 b60c          	ld	a,_minutes
2887  0097 ab30          	add	a,#48
2888  0099 cd0019        	call	_uart_send
2890                     ; 53 			uart_send(':'); 
2892  009c a63a          	ld	a,#58
2893  009e cd0019        	call	_uart_send
2895                     ; 54 			uart_send(seconds_tens+0x30);
2897  00a1 b60a          	ld	a,_seconds_tens
2898  00a3 ab30          	add	a,#48
2899  00a5 cd0019        	call	_uart_send
2901                     ; 55 			uart_send(seconds+0x30);
2903  00a8 b60b          	ld	a,_seconds
2904  00aa ab30          	add	a,#48
2905  00ac cd0019        	call	_uart_send
2907                     ; 56 			uart_send(0x0A);
2909  00af a60a          	ld	a,#10
2910  00b1 cd0019        	call	_uart_send
2912  00b4               L3771:
2913                     ; 58 	}
2916  00b4 84            	pop	a
2917  00b5 81            	ret
2959                     ; 1  void Key_interrupt (void)
2959                     ; 2 {
2960                     	switch	.text
2961  00b6               _Key_interrupt:
2965                     ; 4   pins = PC_IDR;
2967  00b6 55500b0003    	mov	_pins,_PC_IDR
2968                     ; 5 }
2971  00bb 81            	ret
3050                     ; 7 void i2c_master_init(unsigned long f_master_hz, unsigned long f_i2c_hz){
3051                     	switch	.text
3052  00bc               _i2c_master_init:
3054  00bc 5208          	subw	sp,#8
3055       00000008      OFST:	set	8
3058                     ; 9 	I2C_CR1 &= ~I2C_CR1_PE;
3060  00be 72115210      	bres	_I2C_CR1,#0
3061                     ; 10 	I2C_CR2 |= I2C_CR2_SWRST;
3063  00c2 721e5211      	bset	_I2C_CR2,#7
3064                     ; 11   PB_DDR = (0<<4);//PB_DDR_DDR4);
3066  00c6 725f5007      	clr	_PB_DDR
3067                     ; 12 	PB_DDR = (0<<5);//PB_DDR_DDR5);
3069  00ca 725f5007      	clr	_PB_DDR
3070                     ; 13 	PB_ODR = (1<<5);//PB_ODR_ODR5);  //SDA
3072  00ce 35205005      	mov	_PB_ODR,#32
3073                     ; 14   PB_ODR = (1<<4);//PB_ODR_ODR4);  //SCL
3075  00d2 35105005      	mov	_PB_ODR,#16
3076                     ; 16   PB_CR1 = (0<<4);//PB_CR1_C14);
3078  00d6 725f5008      	clr	_PB_CR1
3079                     ; 17   PB_CR1 = (0<<5);//PB_CR1_C15);
3081  00da 725f5008      	clr	_PB_CR1
3082                     ; 19   PB_CR2 = (0<<4);//PB_CR1_C24);
3084  00de 725f5009      	clr	_PB_CR2
3085                     ; 20   PB_CR2 = (0<<5);//PB_CR1_C25);
3087  00e2 725f5009      	clr	_PB_CR2
3088                     ; 21   I2C_CR2 &= ~I2C_CR2_SWRST;
3090  00e6 721f5211      	bres	_I2C_CR2,#7
3091                     ; 23   I2C_FREQR = 16;
3093  00ea 35105212      	mov	_I2C_FREQR,#16
3094                     ; 28   I2C_CCRH |=~I2C_CCRH_FS;
3096  00ee c6521c        	ld	a,_I2C_CCRH
3097  00f1 aa7f          	or	a,#127
3098  00f3 c7521c        	ld	_I2C_CCRH,a
3099                     ; 30   ccr = f_master_hz/(2*f_i2c_hz);
3101  00f6 96            	ldw	x,sp
3102  00f7 1c000f        	addw	x,#OFST+7
3103  00fa cd0000        	call	c_ltor
3105  00fd 3803          	sll	c_lreg+3
3106  00ff 3902          	rlc	c_lreg+2
3107  0101 3901          	rlc	c_lreg+1
3108  0103 3900          	rlc	c_lreg
3109  0105 96            	ldw	x,sp
3110  0106 1c0001        	addw	x,#OFST-7
3111  0109 cd0000        	call	c_rtol
3113  010c 96            	ldw	x,sp
3114  010d 1c000b        	addw	x,#OFST+3
3115  0110 cd0000        	call	c_ltor
3117  0113 96            	ldw	x,sp
3118  0114 1c0001        	addw	x,#OFST-7
3119  0117 cd0000        	call	c_ludv
3121  011a 96            	ldw	x,sp
3122  011b 1c0005        	addw	x,#OFST-3
3123  011e cd0000        	call	c_rtol
3125                     ; 34   I2C_TRISER = 12+1;
3127  0121 350d521d      	mov	_I2C_TRISER,#13
3128                     ; 35   I2C_CCRL = ccr & 0xFF;
3130  0125 7b08          	ld	a,(OFST+0,sp)
3131  0127 a4ff          	and	a,#255
3132  0129 c7521b        	ld	_I2C_CCRL,a
3133                     ; 36   I2C_CCRH = ((ccr >> 8) & 0x0F);
3135  012c 7b07          	ld	a,(OFST-1,sp)
3136  012e a40f          	and	a,#15
3137  0130 c7521c        	ld	_I2C_CCRH,a
3138                     ; 39   I2C_CR1 |=I2C_CR1_PE;
3140  0133 72105210      	bset	_I2C_CR1,#0
3141                     ; 42   I2C_CR2 |=I2C_CR2_ACK;
3143  0137 72145211      	bset	_I2C_CR2,#2
3144                     ; 43 }
3147  013b 5b08          	addw	sp,#8
3148  013d 81            	ret
3242                     ; 49 t_i2c_status i2c_wr_reg(unsigned char address, unsigned char reg_addr,
3242                     ; 50                               char * data, unsigned char length)
3242                     ; 51 {                                  
3243                     	switch	.text
3244  013e               _i2c_wr_reg:
3246  013e 89            	pushw	x
3247       00000000      OFST:	set	0
3250  013f               L5112:
3251                     ; 55   while((I2C_SR3 & I2C_SR3_BUSY) !=0);   
3253  013f c65219        	ld	a,_I2C_SR3
3254  0142 a502          	bcp	a,#2
3255  0144 26f9          	jrne	L5112
3256                     ; 57   I2C_CR2 |= I2C_CR2_START;
3258  0146 72105211      	bset	_I2C_CR2,#0
3260  014a               L3212:
3261                     ; 60   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3263  014a c65217        	ld	a,_I2C_SR1
3264  014d a501          	bcp	a,#1
3265  014f 27f9          	jreq	L3212
3266                     ; 63   I2C_DR = address & 0xFE;
3268  0151 7b01          	ld	a,(OFST+1,sp)
3269  0153 a4fe          	and	a,#254
3270  0155 c75216        	ld	_I2C_DR,a
3272  0158               L3312:
3273                     ; 66 	while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3275  0158 c65217        	ld	a,_I2C_SR1
3276  015b a502          	bcp	a,#2
3277  015d 27f9          	jreq	L3312
3278                     ; 68   I2C_SR3;
3280  015f c65219        	ld	a,_I2C_SR3
3282  0162               L1412:
3283                     ; 73   while((I2C_SR1 & I2C_SR1_TXE) ==0);
3285  0162 c65217        	ld	a,_I2C_SR1
3286  0165 a580          	bcp	a,#128
3287  0167 27f9          	jreq	L1412
3288                     ; 75   I2C_DR = reg_addr;
3290  0169 7b02          	ld	a,(OFST+2,sp)
3291  016b c75216        	ld	_I2C_DR,a
3293  016e 2015          	jra	L1512
3294  0170               L7512:
3295                     ; 81     while((I2C_SR1 & I2C_SR1_TXE) == 0);
3297  0170 c65217        	ld	a,_I2C_SR1
3298  0173 a580          	bcp	a,#128
3299  0175 27f9          	jreq	L7512
3300                     ; 83     I2C_DR = *data++;
3302  0177 1e05          	ldw	x,(OFST+5,sp)
3303  0179 1c0001        	addw	x,#1
3304  017c 1f05          	ldw	(OFST+5,sp),x
3305  017e 1d0001        	subw	x,#1
3306  0181 f6            	ld	a,(x)
3307  0182 c75216        	ld	_I2C_DR,a
3308  0185               L1512:
3309                     ; 78   while(length--){
3311  0185 7b07          	ld	a,(OFST+7,sp)
3312  0187 0a07          	dec	(OFST+7,sp)
3313  0189 4d            	tnz	a
3314  018a 26e4          	jrne	L7512
3316  018c               L5612:
3317                     ; 88   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3319  018c c65217        	ld	a,_I2C_SR1
3320  018f a584          	bcp	a,#132
3321  0191 27f9          	jreq	L5612
3322                     ; 90   I2C_CR2 |= I2C_CR2_STOP;
3324  0193 72125211      	bset	_I2C_CR2,#1
3326  0197               L3712:
3327                     ; 93   while((I2C_CR2 & I2C_CR2_STOP) == 0); 
3329  0197 c65211        	ld	a,_I2C_CR2
3330  019a a502          	bcp	a,#2
3331  019c 27f9          	jreq	L3712
3332                     ; 94   return I2C_SUCCESS;
3334  019e 4f            	clr	a
3337  019f 85            	popw	x
3338  01a0 81            	ret
3408                     ; 101 t_i2c_status i2c_rd_reg(unsigned char address, unsigned char reg_addr,
3408                     ; 102                               char * data, unsigned char length)
3408                     ; 103 {
3409                     	switch	.text
3410  01a1               _i2c_rd_reg:
3412  01a1 89            	pushw	x
3413       00000000      OFST:	set	0
3416  01a2               L3322:
3417                     ; 109   while((I2C_SR3 & I2C_SR3_BUSY) != 0);   
3419  01a2 c65219        	ld	a,_I2C_SR3
3420  01a5 a502          	bcp	a,#2
3421  01a7 26f9          	jrne	L3322
3422                     ; 111   I2C_CR2 |= I2C_CR2_ACK;
3424  01a9 72145211      	bset	_I2C_CR2,#2
3425                     ; 114   I2C_CR2 |= I2C_CR2_START;
3427  01ad 72105211      	bset	_I2C_CR2,#0
3429  01b1               L1422:
3430                     ; 117   while((I2C_SR1 & I2C_SR1_SB) == 0);  
3432  01b1 c65217        	ld	a,_I2C_SR1
3433  01b4 a501          	bcp	a,#1
3434  01b6 27f9          	jreq	L1422
3435                     ; 119   I2C_DR = address & 0xFE;
3437  01b8 7b01          	ld	a,(OFST+1,sp)
3438  01ba a4fe          	and	a,#254
3439  01bc c75216        	ld	_I2C_DR,a
3441  01bf               L1522:
3442                     ; 122   while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3444  01bf c65217        	ld	a,_I2C_SR1
3445  01c2 a502          	bcp	a,#2
3446  01c4 27f9          	jreq	L1522
3447                     ; 124   temp = I2C_SR3;
3449  01c6 5552190002    	mov	_temp,_I2C_SR3
3451  01cb               L1622:
3452                     ; 128   while((I2C_SR1 & I2C_SR1) == 0); 
3454  01cb c65217        	ld	a,_I2C_SR1
3455  01ce 5f            	clrw	x
3456  01cf 97            	ld	xl,a
3457  01d0 a30000        	cpw	x,#0
3458  01d3 27f6          	jreq	L1622
3459                     ; 130   I2C_DR = reg_addr;
3461  01d5 7b02          	ld	a,(OFST+2,sp)
3462  01d7 c75216        	ld	_I2C_DR,a
3464  01da               L1722:
3465                     ; 133   while((I2C_SR1 & (I2C_SR1_TXE | I2C_SR1_BTF)) == 0); 
3467  01da c65217        	ld	a,_I2C_SR1
3468  01dd a584          	bcp	a,#132
3469  01df 27f9          	jreq	L1722
3470                     ; 135   I2C_CR2 |= I2C_CR2_START;
3472  01e1 72105211      	bset	_I2C_CR2,#0
3474  01e5               L7722:
3475                     ; 138   while((I2C_SR1 & I2C_SR1_SB) == 0); 
3477  01e5 c65217        	ld	a,_I2C_SR1
3478  01e8 a501          	bcp	a,#1
3479  01ea 27f9          	jreq	L7722
3480                     ; 141   I2C_DR = address | 0x01;
3482  01ec 7b01          	ld	a,(OFST+1,sp)
3483  01ee aa01          	or	a,#1
3484  01f0 c75216        	ld	_I2C_DR,a
3485                     ; 145   if(length == 1){
3487  01f3 7b07          	ld	a,(OFST+7,sp)
3488  01f5 a101          	cp	a,#1
3489  01f7 2627          	jrne	L3032
3490                     ; 147     I2C_CR2 &= ~I2C_CR2_ACK;
3492  01f9 72155211      	bres	_I2C_CR2,#2
3494  01fd               L7032:
3495                     ; 150     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3497  01fd c65217        	ld	a,_I2C_SR1
3498  0200 a502          	bcp	a,#2
3499  0202 27f9          	jreq	L7032
3500                     ; 152     _asm ("SIM");  //on interupts
3503  0204 9b            SIM
3505                     ; 154     temp = I2C_SR3;
3507  0205 5552190002    	mov	_temp,_I2C_SR3
3508                     ; 157     I2C_CR2 |= I2C_CR2_STOP;
3510  020a 72125211      	bset	_I2C_CR2,#1
3511                     ; 159     _asm ("RIM");  //on interupts;
3514  020e 9a            RIM
3517  020f               L5132:
3518                     ; 163     while((I2C_SR1 & I2C_SR1_RXNE) == 0); 
3520  020f c65217        	ld	a,_I2C_SR1
3521  0212 a540          	bcp	a,#64
3522  0214 27f9          	jreq	L5132
3523                     ; 165     *data = I2C_DR;
3525  0216 1e05          	ldw	x,(OFST+5,sp)
3526  0218 c65216        	ld	a,_I2C_DR
3527  021b f7            	ld	(x),a
3529  021c acd202d2      	jpf	L1232
3530  0220               L3032:
3531                     ; 168   else if(length == 2){
3533  0220 7b07          	ld	a,(OFST+7,sp)
3534  0222 a102          	cp	a,#2
3535  0224 2639          	jrne	L3232
3536                     ; 170     I2C_CR2 |= I2C_CR2_POS;
3538  0226 72165211      	bset	_I2C_CR2,#3
3540  022a               L7232:
3541                     ; 173     while((I2C_SR1 & I2C_SR1_ADDR) == 0);
3543  022a c65217        	ld	a,_I2C_SR1
3544  022d a502          	bcp	a,#2
3545  022f 27f9          	jreq	L7232
3546                     ; 175     _asm ("SIM");  //on interupts;
3549  0231 9b            SIM
3551                     ; 177     temp = I2C_SR3;
3553  0232 5552190002    	mov	_temp,_I2C_SR3
3554                     ; 179     I2C_CR2 &= ~I2C_CR2_ACK;
3556  0237 72155211      	bres	_I2C_CR2,#2
3557                     ; 181     _asm ("RIM");  //on interupts;
3560  023b 9a            RIM
3563  023c               L5332:
3564                     ; 185     while((I2C_SR1 & I2C_SR1_BTF) == 0); 
3566  023c c65217        	ld	a,_I2C_SR1
3567  023f a504          	bcp	a,#4
3568  0241 27f9          	jreq	L5332
3569                     ; 187     _asm ("SIM");  //on interupts;
3572  0243 9b            SIM
3574                     ; 189     I2C_CR2 |= I2C_CR2_STOP;
3576  0244 72125211      	bset	_I2C_CR2,#1
3577                     ; 191     *data++ = I2C_DR;
3579  0248 1e05          	ldw	x,(OFST+5,sp)
3580  024a 1c0001        	addw	x,#1
3581  024d 1f05          	ldw	(OFST+5,sp),x
3582  024f 1d0001        	subw	x,#1
3583  0252 c65216        	ld	a,_I2C_DR
3584  0255 f7            	ld	(x),a
3585                     ; 193     _asm ("RIM");  //on interupts;
3588  0256 9a            RIM
3590                     ; 194     *data = I2C_DR;
3592  0257 1e05          	ldw	x,(OFST+5,sp)
3593  0259 c65216        	ld	a,_I2C_DR
3594  025c f7            	ld	(x),a
3596  025d 2073          	jra	L1232
3597  025f               L3232:
3598                     ; 197   else if(length > 2){
3600  025f 7b07          	ld	a,(OFST+7,sp)
3601  0261 a103          	cp	a,#3
3602  0263 256d          	jrult	L1232
3604  0265               L7432:
3605                     ; 200     while((I2C_SR1 & I2C_SR1_ADDR) == 0); 
3607  0265 c65217        	ld	a,_I2C_SR1
3608  0268 a502          	bcp	a,#2
3609  026a 27f9          	jreq	L7432
3610                     ; 202     _asm ("SIM");  //on interupts;
3613  026c 9b            SIM
3615                     ; 205     I2C_SR3;
3617  026d c65219        	ld	a,_I2C_SR3
3618                     ; 208     _asm ("RIM");  //on interupts;
3621  0270 9a            RIM
3624  0271 2015          	jra	L5532
3625  0273               L3632:
3626                     ; 213       while((I2C_SR1 & I2C_SR1_BTF) == 0);
3628  0273 c65217        	ld	a,_I2C_SR1
3629  0276 a504          	bcp	a,#4
3630  0278 27f9          	jreq	L3632
3631                     ; 215       *data++ = I2C_DR;
3633  027a 1e05          	ldw	x,(OFST+5,sp)
3634  027c 1c0001        	addw	x,#1
3635  027f 1f05          	ldw	(OFST+5,sp),x
3636  0281 1d0001        	subw	x,#1
3637  0284 c65216        	ld	a,_I2C_DR
3638  0287 f7            	ld	(x),a
3639  0288               L5532:
3640                     ; 210     while(length-- > 3){
3642  0288 7b07          	ld	a,(OFST+7,sp)
3643  028a 0a07          	dec	(OFST+7,sp)
3644  028c a104          	cp	a,#4
3645  028e 24e3          	jruge	L3632
3647  0290               L1732:
3648                     ; 224     while((I2C_SR1 & I2C_SR1_BTF) == 0);
3650  0290 c65217        	ld	a,_I2C_SR1
3651  0293 a504          	bcp	a,#4
3652  0295 27f9          	jreq	L1732
3653                     ; 226     I2C_CR2 &= ~I2C_CR2_ACK;
3655  0297 72155211      	bres	_I2C_CR2,#2
3656                     ; 228     _asm ("SIM");  //on interupts;
3659  029b 9b            SIM
3661                     ; 231     *data++ = I2C_DR;
3663  029c 1e05          	ldw	x,(OFST+5,sp)
3664  029e 1c0001        	addw	x,#1
3665  02a1 1f05          	ldw	(OFST+5,sp),x
3666  02a3 1d0001        	subw	x,#1
3667  02a6 c65216        	ld	a,_I2C_DR
3668  02a9 f7            	ld	(x),a
3669                     ; 233     I2C_CR2 |= I2C_CR2_STOP;
3671  02aa 72125211      	bset	_I2C_CR2,#1
3672                     ; 235     *data++ = I2C_DR;
3674  02ae 1e05          	ldw	x,(OFST+5,sp)
3675  02b0 1c0001        	addw	x,#1
3676  02b3 1f05          	ldw	(OFST+5,sp),x
3677  02b5 1d0001        	subw	x,#1
3678  02b8 c65216        	ld	a,_I2C_DR
3679  02bb f7            	ld	(x),a
3680                     ; 237     _asm ("RIM");  //on interupts;
3683  02bc 9a            RIM
3686  02bd               L7732:
3687                     ; 240     while((I2C_SR1 & I2C_SR1_RXNE) == 0);
3689  02bd c65217        	ld	a,_I2C_SR1
3690  02c0 a540          	bcp	a,#64
3691  02c2 27f9          	jreq	L7732
3692                     ; 242     *data++ = I2C_DR;
3694  02c4 1e05          	ldw	x,(OFST+5,sp)
3695  02c6 1c0001        	addw	x,#1
3696  02c9 1f05          	ldw	(OFST+5,sp),x
3697  02cb 1d0001        	subw	x,#1
3698  02ce c65216        	ld	a,_I2C_DR
3699  02d1 f7            	ld	(x),a
3700  02d2               L1232:
3701                     ; 245 	 I2C_CR2 |= I2C_CR2_STOP;
3703  02d2 72125211      	bset	_I2C_CR2,#1
3705  02d6               L5042:
3706                     ; 248   while((I2C_CR2 & I2C_CR2_STOP) == 0);
3708  02d6 c65211        	ld	a,_I2C_CR2
3709  02d9 a502          	bcp	a,#2
3710  02db 27f9          	jreq	L5042
3711                     ; 250   I2C_CR2 &= ~I2C_CR2_POS;
3713  02dd 72175211      	bres	_I2C_CR2,#3
3714                     ; 252   return I2C_SUCCESS;
3716  02e1 4f            	clr	a
3719  02e2 85            	popw	x
3720  02e3 81            	ret
3761                     ; 10 void timer1_start(void)
3761                     ; 11  {
3762                     	switch	.text
3763  02e4               _timer1_start:
3767                     ; 12    TIM1_CR1 |= TIM1_CR1_CEN; //Запускаем таймер
3769  02e4 72105250      	bset	_TIM1_CR1,#0
3770                     ; 13  }
3773  02e8 81            	ret
3810                     ; 15 void timer2_start(uint16_t top_val)
3810                     ; 16 {
3811                     	switch	.text
3812  02e9               _timer2_start:
3816                     ; 17   TIM2_ARRH =top_val >>8;
3818  02e9 9e            	ld	a,xh
3819  02ea c7530f        	ld	_TIM2_ARRH,a
3820                     ; 18   TIM2_ARRL =top_val & 0xFF;
3822  02ed 9f            	ld	a,xl
3823  02ee a4ff          	and	a,#255
3824  02f0 c75310        	ld	_TIM2_ARRL,a
3825                     ; 19   TIM2_CR1 |= TIM2_CR1_CEN;
3827  02f3 72105300      	bset	_TIM2_CR1,#0
3828                     ; 20 }
3831  02f7 81            	ret
3869                     ; 22 void Timer2_Overflow (void)
3869                     ; 23 {
3870                     	switch	.text
3871  02f8               _Timer2_Overflow:
3875                     ; 24 	TIM2_SR1 = 0;
3877  02f8 725f5304      	clr	_TIM2_SR1
3878                     ; 25 	switch (lamp_number)
3880  02fc b600          	ld	a,_lamp_number
3882                     ; 38 	break;
3883  02fe 4d            	tnz	a
3884  02ff 270b          	jreq	L5442
3885  0301 4a            	dec	a
3886  0302 270d          	jreq	L7442
3887  0304 4a            	dec	a
3888  0305 270f          	jreq	L1542
3889  0307 4a            	dec	a
3890  0308 2711          	jreq	L3542
3891  030a 2012          	jra	L7642
3892  030c               L5442:
3893                     ; 27 	case 0:
3893                     ; 28 	k155_data = hours_tens; 
3895  030c 450816        	mov	_k155_data,_hours_tens
3896                     ; 29 	break;
3898  030f 200d          	jra	L7642
3899  0311               L7442:
3900                     ; 30 	case 1:
3900                     ; 31 	k155_data = hours;
3902  0311 450d16        	mov	_k155_data,_hours
3903                     ; 32 	break;
3905  0314 2008          	jra	L7642
3906  0316               L1542:
3907                     ; 33 	case 2:
3907                     ; 34 	k155_data = minutes_tens;
3909  0316 450916        	mov	_k155_data,_minutes_tens
3910                     ; 35 	break;
3912  0319 2003          	jra	L7642
3913  031b               L3542:
3914                     ; 36 	case 3:
3914                     ; 37 	k155_data = minutes;
3916  031b 450c16        	mov	_k155_data,_minutes
3917                     ; 38 	break;
3919  031e               L7642:
3920                     ; 41 	if (lamp_number < 3)
3922  031e b600          	ld	a,_lamp_number
3923  0320 a103          	cp	a,#3
3924  0322 2415          	jruge	L1742
3925                     ; 43 			lamp_number_data = (1<<(lamp_number++));
3927  0324 b600          	ld	a,_lamp_number
3928  0326 97            	ld	xl,a
3929  0327 3c00          	inc	_lamp_number
3930  0329 9f            	ld	a,xl
3931  032a 5f            	clrw	x
3932  032b 97            	ld	xl,a
3933  032c a601          	ld	a,#1
3934  032e 5d            	tnzw	x
3935  032f 2704          	jreq	L03
3936  0331               L23:
3937  0331 48            	sll	a
3938  0332 5a            	decw	x
3939  0333 26fc          	jrne	L23
3940  0335               L03:
3941  0335 b715          	ld	_lamp_number_data,a
3943  0337 2017          	jra	L3742
3944  0339               L1742:
3945                     ; 45 		else if (lamp_number >= 3)
3947  0339 b600          	ld	a,_lamp_number
3948  033b a103          	cp	a,#3
3949  033d 2511          	jrult	L3742
3950                     ; 47 			lamp_number_data = (1<<(lamp_number));
3952  033f b600          	ld	a,_lamp_number
3953  0341 5f            	clrw	x
3954  0342 97            	ld	xl,a
3955  0343 a601          	ld	a,#1
3956  0345 5d            	tnzw	x
3957  0346 2704          	jreq	L43
3958  0348               L63:
3959  0348 48            	sll	a
3960  0349 5a            	decw	x
3961  034a 26fc          	jrne	L63
3962  034c               L43:
3963  034c b715          	ld	_lamp_number_data,a
3964                     ; 48 			lamp_number = 0;
3966  034e 3f00          	clr	_lamp_number
3967  0350               L3742:
3968                     ; 54 	timers_int_off();
3970  0350 cd0401        	call	_timers_int_off
3972                     ; 55 	PA_ODR &= (0<<3);
3974  0353 725f5000      	clr	_PA_ODR
3975                     ; 59 	spi_send(kostil_k155(k155_data));
3977  0357 b616          	ld	a,_k155_data
3978  0359 cd0463        	call	_kostil_k155
3980  035c cd048a        	call	_spi_send
3982                     ; 60 	spi_send(lamp_number_data | dots);
3984  035f b615          	ld	a,_lamp_number_data
3985  0361 ba01          	or	a,_dots
3986  0363 cd048a        	call	_spi_send
3989  0366               L1052:
3990                     ; 64 	while((SPI_SR & SPI_SR_BSY) != 0)
3992  0366 c65203        	ld	a,_SPI_SR
3993  0369 a580          	bcp	a,#128
3994  036b 26f9          	jrne	L1052
3995                     ; 67 	PA_ODR |= (1<<3);
3997  036d 72165000      	bset	_PA_ODR,#3
3998                     ; 68 	timers_int_on();
4000  0371 cd040a        	call	_timers_int_on
4002                     ; 69 	return;
4005  0374 81            	ret
4031                     ; 72 void Timer1_Compare_1 (void)
4031                     ; 73 {
4032                     	switch	.text
4033  0375               _Timer1_Compare_1:
4037                     ; 74 	TIM1_SR1 = 0;
4039  0375 725f5255      	clr	_TIM1_SR1
4040                     ; 75 	dots = ~dots;
4042  0379 3301          	cpl	_dots
4043                     ; 76 	dots &= 0b00010000;
4045  037b b601          	ld	a,_dots
4046  037d a410          	and	a,#16
4047  037f b701          	ld	_dots,a
4048                     ; 77 	time_refresh();
4050  0381 cd04ba        	call	_time_refresh
4052                     ; 78 }
4055  0384 81            	ret
4105                     ; 81 void timer1_setup(uint16_t tim_freq, uint16_t top)
4105                     ; 82  {
4106                     	switch	.text
4107  0385               _timer1_setup:
4109  0385 89            	pushw	x
4110  0386 5204          	subw	sp,#4
4111       00000004      OFST:	set	4
4114                     ; 83   TIM1_PSCRH = CLOCK_FREQ/tim_freq >> 8;//(prescaler) >> 8;								// TODO: изучить генерируемый код!!!!
4116  0388 cd0000        	call	c_uitolx
4118  038b 96            	ldw	x,sp
4119  038c 1c0001        	addw	x,#OFST-3
4120  038f cd0000        	call	c_rtol
4122  0392 ae2400        	ldw	x,#9216
4123  0395 bf02          	ldw	c_lreg+2,x
4124  0397 ae00f4        	ldw	x,#244
4125  039a bf00          	ldw	c_lreg,x
4126  039c 96            	ldw	x,sp
4127  039d 1c0001        	addw	x,#OFST-3
4128  03a0 cd0000        	call	c_ldiv
4130  03a3 a608          	ld	a,#8
4131  03a5 cd0000        	call	c_lrsh
4133  03a8 b603          	ld	a,c_lreg+3
4134  03aa c75260        	ld	_TIM1_PSCRH,a
4135                     ; 84   TIM1_PSCRL = CLOCK_FREQ/tim_freq & 0xFF;//(prescaler)& 0xFF; // 16 divider
4137  03ad 1e05          	ldw	x,(OFST+1,sp)
4138  03af cd0000        	call	c_uitolx
4140  03b2 96            	ldw	x,sp
4141  03b3 1c0001        	addw	x,#OFST-3
4142  03b6 cd0000        	call	c_rtol
4144  03b9 ae2400        	ldw	x,#9216
4145  03bc bf02          	ldw	c_lreg+2,x
4146  03be ae00f4        	ldw	x,#244
4147  03c1 bf00          	ldw	c_lreg,x
4148  03c3 96            	ldw	x,sp
4149  03c4 1c0001        	addw	x,#OFST-3
4150  03c7 cd0000        	call	c_ldiv
4152  03ca 3f02          	clr	c_lreg+2
4153  03cc 3f01          	clr	c_lreg+1
4154  03ce 3f00          	clr	c_lreg
4155  03d0 b603          	ld	a,c_lreg+3
4156  03d2 c75261        	ld	_TIM1_PSCRL,a
4157                     ; 85   TIM1_ARRH = (top) >> 8; //	overflow frequency = 16М / 8 / 1000 = 2000 Гц
4159  03d5 7b09          	ld	a,(OFST+5,sp)
4160  03d7 c75262        	ld	_TIM1_ARRH,a
4161                     ; 86   TIM1_ARRL = (top)& 0xFF;
4163  03da 7b0a          	ld	a,(OFST+6,sp)
4164  03dc a4ff          	and	a,#255
4165  03de c75263        	ld	_TIM1_ARRL,a
4166                     ; 88   TIM1_CR1 |= TIM1_CR1_URS; //only overflow int
4168  03e1 72145250      	bset	_TIM1_CR1,#2
4169                     ; 89   TIM1_EGR |= TIM1_EGR_UG;  //call Update Event
4171  03e5 72105257      	bset	_TIM1_EGR,#0
4172                     ; 90   TIM1_IER |= TIM1_IER_UIE; //int enable
4174  03e9 72105254      	bset	_TIM1_IER,#0
4175                     ; 91  }
4178  03ed 5b06          	addw	sp,#6
4179  03ef 81            	ret
4206                     ; 94 void timer2_setup(void)
4206                     ; 95  {
4207                     	switch	.text
4208  03f0               _timer2_setup:
4212                     ; 97     TIM2_IER |= TIM2_IER_UIE;	//overflow int   
4214  03f0 72105303      	bset	_TIM2_IER,#0
4215                     ; 98     TIM2_PSCR = 1;
4217  03f4 3501530e      	mov	_TIM2_PSCR,#1
4218                     ; 99     TIM2_ARRH = 0;
4220  03f8 725f530f      	clr	_TIM2_ARRH
4221                     ; 100     TIM2_ARRL = 0;
4223  03fc 725f5310      	clr	_TIM2_ARRL
4224                     ; 101  }
4227  0400 81            	ret
4252                     ; 104 void timers_int_off(void)
4252                     ; 105 {
4253                     	switch	.text
4254  0401               _timers_int_off:
4258                     ; 106 	TIM1_IER &= ~TIM1_IER_UIE;
4260  0401 72115254      	bres	_TIM1_IER,#0
4261                     ; 107 	TIM2_IER &= ~TIM2_IER_UIE;
4263  0405 72115303      	bres	_TIM2_IER,#0
4264                     ; 108 }
4267  0409 81            	ret
4292                     ; 110 void timers_int_on(void)
4292                     ; 111 {
4293                     	switch	.text
4294  040a               _timers_int_on:
4298                     ; 112 	TIM1_IER |= TIM1_IER_UIE;
4300  040a 72105254      	bset	_TIM1_IER,#0
4301                     ; 113 	TIM2_IER |= TIM2_IER_UIE;
4303  040e 72105303      	bset	_TIM2_IER,#0
4304                     ; 114 }
4307  0412 81            	ret
4356                     ; 1 void time_write(void)
4356                     ; 2 {
4357                     	switch	.text
4358  0413               _time_write:
4362                     ; 5 	fresh_hours = fresh_hours + (fresh_hours_dec<<4);
4364  0413 b614          	ld	a,_fresh_hours_dec
4365  0415 97            	ld	xl,a
4366  0416 a610          	ld	a,#16
4367  0418 42            	mul	x,a
4368  0419 9f            	ld	a,xl
4369  041a bb13          	add	a,_fresh_hours
4370  041c b713          	ld	_fresh_hours,a
4371                     ; 6 	fresh_min = fresh_min + (fresh_min_dec<<4);
4373  041e b612          	ld	a,_fresh_min_dec
4374  0420 97            	ld	xl,a
4375  0421 a610          	ld	a,#16
4376  0423 42            	mul	x,a
4377  0424 9f            	ld	a,xl
4378  0425 bb11          	add	a,_fresh_min
4379  0427 b711          	ld	_fresh_min,a
4380                     ; 7 	fresh_sec = fresh_sec + (fresh_sec_dec<<4);
4382  0429 b610          	ld	a,_fresh_sec_dec
4383  042b 97            	ld	xl,a
4384  042c a610          	ld	a,#16
4385  042e 42            	mul	x,a
4386  042f 9f            	ld	a,xl
4387  0430 bb0f          	add	a,_fresh_sec
4388  0432 b70f          	ld	_fresh_sec,a
4389                     ; 8 	timers_int_off();
4391  0434 adcb          	call	_timers_int_off
4393                     ; 9 	i2c_wr_reg(ds_address, 2, &fresh_hours, 1);
4395  0436 4b01          	push	#1
4396  0438 ae0013        	ldw	x,#_fresh_hours
4397  043b 89            	pushw	x
4398  043c aed002        	ldw	x,#53250
4399  043f cd013e        	call	_i2c_wr_reg
4401  0442 5b03          	addw	sp,#3
4402                     ; 10 	i2c_wr_reg(ds_address, 1, &fresh_min, 1);
4404  0444 4b01          	push	#1
4405  0446 ae0011        	ldw	x,#_fresh_min
4406  0449 89            	pushw	x
4407  044a aed001        	ldw	x,#53249
4408  044d cd013e        	call	_i2c_wr_reg
4410  0450 5b03          	addw	sp,#3
4411                     ; 11 	i2c_wr_reg(ds_address, 0, &fresh_sec, 1);
4413  0452 4b01          	push	#1
4414  0454 ae000f        	ldw	x,#_fresh_sec
4415  0457 89            	pushw	x
4416  0458 aed000        	ldw	x,#53248
4417  045b cd013e        	call	_i2c_wr_reg
4419  045e 5b03          	addw	sp,#3
4420                     ; 12 	timers_int_on();
4422  0460 ada8          	call	_timers_int_on
4424                     ; 13 }
4427  0462 81            	ret
4479                     ; 15 uint8_t kostil_k155 (uint8_t byte)
4479                     ; 16 {
4480                     	switch	.text
4481  0463               _kostil_k155:
4483  0463 88            	push	a
4484  0464 89            	pushw	x
4485       00000002      OFST:	set	2
4488                     ; 17 	uint8_t tmp = (byte<<1) & 0b00001100;
4490  0465 48            	sll	a
4491  0466 a40c          	and	a,#12
4492  0468 6b01          	ld	(OFST-1,sp),a
4493                     ; 18 	uint8_t tmp2 = (byte>>2) & 0b00000010;
4495  046a 7b03          	ld	a,(OFST+1,sp)
4496  046c 44            	srl	a
4497  046d 44            	srl	a
4498  046e a402          	and	a,#2
4499  0470 6b02          	ld	(OFST+0,sp),a
4500                     ; 19 	byte &= 1;
4502  0472 7b03          	ld	a,(OFST+1,sp)
4503  0474 a401          	and	a,#1
4504  0476 6b03          	ld	(OFST+1,sp),a
4505                     ; 20 	byte |= tmp | tmp2;
4507  0478 7b01          	ld	a,(OFST-1,sp)
4508  047a 1a02          	or	a,(OFST+0,sp)
4509  047c 1a03          	or	a,(OFST+1,sp)
4510  047e 6b03          	ld	(OFST+1,sp),a
4511                     ; 21 	return byte;
4513  0480 7b03          	ld	a,(OFST+1,sp)
4516  0482 5b03          	addw	sp,#3
4517  0484 81            	ret
4558                     ; 1 void spi_setup(void)
4558                     ; 2  {
4559                     	switch	.text
4560  0485               _spi_setup:
4564                     ; 3     SPI_CR1= 0b01110100;//0x7C;       //this
4566  0485 35745200      	mov	_SPI_CR1,#116
4567                     ; 5  }
4570  0489 81            	ret
4606                     ; 8 void spi_send(uint8_t msg)
4606                     ; 9 {
4607                     	switch	.text
4608  048a               _spi_send:
4610  048a 88            	push	a
4611       00000000      OFST:	set	0
4614  048b               L1762:
4615                     ; 11 	while((SPI_SR & SPI_SR_BSY) != 0)
4617  048b c65203        	ld	a,_SPI_SR
4618  048e a580          	bcp	a,#128
4619  0490 26f9          	jrne	L1762
4620                     ; 14 	SPI_DR = msg;
4622  0492 7b01          	ld	a,(OFST+1,sp)
4623  0494 c75204        	ld	_SPI_DR,a
4624                     ; 15 }
4627  0497 84            	pop	a
4628  0498 81            	ret
4670                     ; 4 void UART_Resieved (void)
4670                     ; 5 {
4671                     	switch	.text
4672  0499               _UART_Resieved:
4676                     ; 6 	uart_routine(UART1_DR);
4678  0499 c65231        	ld	a,_UART1_DR
4679  049c cd002a        	call	_uart_routine
4681                     ; 7 }
4684  049f 81            	ret
4709                     ; 9 void SPI_Transmitted(void)
4709                     ; 10 {
4710                     	switch	.text
4711  04a0               _SPI_Transmitted:
4715                     ; 11 	spi_send(temp3);
4717  04a0 b605          	ld	a,_temp3
4718  04a2 ade6          	call	_spi_send
4720                     ; 12 }
4723  04a4 81            	ret
4746                     ; 14 void I2C_Event(void)
4746                     ; 15 {
4747                     	switch	.text
4748  04a5               _I2C_Event:
4752                     ; 17 }
4755  04a5 81            	ret
4781                     ; 19 void Keys_switched(void)
4781                     ; 20 {
4782                     	switch	.text
4783  04a6               _Keys_switched:
4787                     ; 21 	EXTI_CR1 = ~(EXTI_CR1) & 0b00110000;
4789  04a6 c650a0        	ld	a,_EXTI_CR1
4790  04a9 43            	cpl	a
4791  04aa a430          	and	a,#48
4792  04ac c750a0        	ld	_EXTI_CR1,a
4793                     ; 22 	PC_CR2 = 0;
4795  04af 725f500e      	clr	_PC_CR2
4796                     ; 23 	timer2_start(0xff);	
4798  04b3 ae00ff        	ldw	x,#255
4799  04b6 cd02e9        	call	_timer2_start
4801                     ; 24 }
4804  04b9 81            	ret
4839                     ; 26 void time_refresh (void)
4839                     ; 27 {
4840                     	switch	.text
4841  04ba               _time_refresh:
4845                     ; 29 	timers_int_off();
4847  04ba cd0401        	call	_timers_int_off
4849                     ; 30 	i2c_rd_reg(0xD0, 0, &fresh_sec, 1); 	
4851  04bd 4b01          	push	#1
4852  04bf ae000f        	ldw	x,#_fresh_sec
4853  04c2 89            	pushw	x
4854  04c3 aed000        	ldw	x,#53248
4855  04c6 cd01a1        	call	_i2c_rd_reg
4857  04c9 5b03          	addw	sp,#3
4858                     ; 31 	i2c_rd_reg(0xD0, 1, &fresh_min, 1);
4860  04cb 4b01          	push	#1
4861  04cd ae0011        	ldw	x,#_fresh_min
4862  04d0 89            	pushw	x
4863  04d1 aed001        	ldw	x,#53249
4864  04d4 cd01a1        	call	_i2c_rd_reg
4866  04d7 5b03          	addw	sp,#3
4867                     ; 32 	i2c_rd_reg(0xD0, 2, &fresh_hours, 1);
4869  04d9 4b01          	push	#1
4870  04db ae0013        	ldw	x,#_fresh_hours
4871  04de 89            	pushw	x
4872  04df aed002        	ldw	x,#53250
4873  04e2 cd01a1        	call	_i2c_rd_reg
4875  04e5 5b03          	addw	sp,#3
4876                     ; 33 	timers_int_on();
4878  04e7 cd040a        	call	_timers_int_on
4880                     ; 35 	seconds_tens = (fresh_sec & 0xf0)>>4;
4882  04ea b60f          	ld	a,_fresh_sec
4883  04ec a4f0          	and	a,#240
4884  04ee 4e            	swap	a
4885  04ef a40f          	and	a,#15
4886  04f1 b70a          	ld	_seconds_tens,a
4887                     ; 36 	minutes_tens = (fresh_min & 0xf0)>>4;
4889  04f3 b611          	ld	a,_fresh_min
4890  04f5 a4f0          	and	a,#240
4891  04f7 4e            	swap	a
4892  04f8 a40f          	and	a,#15
4893  04fa b709          	ld	_minutes_tens,a
4894                     ; 37 	hours_tens = (fresh_hours & 0xf0)>>4;
4896  04fc b613          	ld	a,_fresh_hours
4897  04fe a4f0          	and	a,#240
4898  0500 4e            	swap	a
4899  0501 a40f          	and	a,#15
4900  0503 b708          	ld	_hours_tens,a
4901                     ; 39 	seconds = fresh_sec & 0x0f;
4903  0505 b60f          	ld	a,_fresh_sec
4904  0507 a40f          	and	a,#15
4905  0509 b70b          	ld	_seconds,a
4906                     ; 40 	minutes = fresh_min & 0x0f;
4908  050b b611          	ld	a,_fresh_min
4909  050d a40f          	and	a,#15
4910  050f b70c          	ld	_minutes,a
4911                     ; 41 	hours = fresh_hours & 0x0f;
4913  0511 b613          	ld	a,_fresh_hours
4914  0513 a40f          	and	a,#15
4915  0515 b70d          	ld	_hours,a
4916                     ; 42 }
4919  0517 81            	ret
4986                     ; 21 int main( void )
4986                     ; 22 {
4987                     	switch	.text
4988  0518               _main:
4992                     ; 24 		CLK_CKDIVR=0;                //	no dividers
4994  0518 725f50c6      	clr	_CLK_CKDIVR
4995                     ; 25 		CLK_PCKENR1=0xff;//0x8B;     //0b10001011;        //clocking for TIM1, UART1, SPI i I2C
4997  051c 35ff50c7      	mov	_CLK_PCKENR1,#255
4998                     ; 28     PA_DDR=(1<<3) | (1<<2); //0b000001000; //output for register's latch, input for RTC 1 Hz pulse
5000  0520 350c5002      	mov	_PA_DDR,#12
5001                     ; 29     PA_CR1= 0xff;        //	pull-up on inputs, push-pull on outputs
5003  0524 35ff5003      	mov	_PA_CR1,#255
5004                     ; 30     PA_ODR |= (1<<3);
5006  0528 72165000      	bset	_PA_ODR,#3
5007                     ; 31 		PA_CR2 |=(1<<3);        //	interrupt on PA1 for 1hz
5009  052c 72165004      	bset	_PA_CR2,#3
5010                     ; 33     PC_DDR=0x60; //0b01100000; // buttons pins as input
5012  0530 3560500c      	mov	_PC_DDR,#96
5013                     ; 34     PC_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5015  0534 35ff500d      	mov	_PC_CR1,#255
5016                     ; 35     PC_CR2 |= (1<<4) | (1<<3);        //	interrapts for buttons
5018  0538 c6500e        	ld	a,_PC_CR2
5019  053b aa18          	or	a,#24
5020  053d c7500e        	ld	_PC_CR2,a
5021                     ; 37 		PD_DDR= (1<<7) | (1<<5) | (1<<3);//0x20;        //0b00100000; //UART, SWIM
5023  0540 35a85011      	mov	_PD_DDR,#168
5024                     ; 38     PD_CR1=0xff;        //	pull-up on inputs, push-pull on outputs
5026  0544 35ff5012      	mov	_PD_CR1,#255
5027                     ; 39     PD_ODR = (1 << 3);
5029  0548 3508500f      	mov	_PD_ODR,#8
5030                     ; 43     spi_setup();
5032  054c cd0485        	call	_spi_setup
5034                     ; 46 		uart_setup();
5036  054f cd0000        	call	_uart_setup
5038                     ; 47 		uart_send('h');
5040  0552 a668          	ld	a,#104
5041  0554 cd0019        	call	_uart_send
5043                     ; 50     timer1_setup( 65500,0xffff);//	freq in hz and top value
5045  0557 aeffff        	ldw	x,#65535
5046  055a 89            	pushw	x
5047  055b aeffdc        	ldw	x,#65500
5048  055e cd0385        	call	_timer1_setup
5050  0561 85            	popw	x
5051                     ; 51 		timer2_setup();
5053  0562 cd03f0        	call	_timer2_setup
5055                     ; 52 		timer1_start();
5057  0565 cd02e4        	call	_timer1_start
5059                     ; 53 		timer2_start(TIM2_TOP);
5061  0568 ae7d00        	ldw	x,#32000
5062  056b cd02e9        	call	_timer2_start
5064                     ; 57 		i2c_master_init(16000000, 50000);
5066  056e aec350        	ldw	x,#50000
5067  0571 89            	pushw	x
5068  0572 ae0000        	ldw	x,#0
5069  0575 89            	pushw	x
5070  0576 ae2400        	ldw	x,#9216
5071  0579 89            	pushw	x
5072  057a ae00f4        	ldw	x,#244
5073  057d 89            	pushw	x
5074  057e cd00bc        	call	_i2c_master_init
5076  0581 5b08          	addw	sp,#8
5077                     ; 60 		timers_int_off();
5079  0583 cd0401        	call	_timers_int_off
5081                     ; 62 		i2c_rd_reg(ds_address, 7, &temp, 1);
5083  0586 4b01          	push	#1
5084  0588 ae0002        	ldw	x,#_temp
5085  058b 89            	pushw	x
5086  058c aed007        	ldw	x,#53255
5087  058f cd01a1        	call	_i2c_rd_reg
5089  0592 5b03          	addw	sp,#3
5090                     ; 63 	if (temp != 0b10010000)	// if OUT and SWQ == 0
5092  0594 b602          	ld	a,_temp
5093  0596 a190          	cp	a,#144
5094  0598 270e          	jreq	L1772
5095                     ; 65 			i2c_wr_reg(ds_address, 7,&ds_cr, 1);	//	setup RTC for 1Hz output
5097  059a 4b01          	push	#1
5098  059c ae0006        	ldw	x,#_ds_cr
5099  059f 89            	pushw	x
5100  05a0 aed007        	ldw	x,#53255
5101  05a3 cd013e        	call	_i2c_wr_reg
5103  05a6 5b03          	addw	sp,#3
5104  05a8               L1772:
5105                     ; 68 		i2c_rd_reg(ds_address, 0, &temp, 1);
5107  05a8 4b01          	push	#1
5108  05aa ae0002        	ldw	x,#_temp
5109  05ad 89            	pushw	x
5110  05ae aed000        	ldw	x,#53248
5111  05b1 cd01a1        	call	_i2c_rd_reg
5113  05b4 5b03          	addw	sp,#3
5114                     ; 71 	if((temp & 0x80) == 0x80)
5116  05b6 b602          	ld	a,_temp
5117  05b8 a480          	and	a,#128
5118  05ba a180          	cp	a,#128
5119  05bc 2610          	jrne	L3772
5120                     ; 73 		temp = 0;
5122  05be 3f02          	clr	_temp
5123                     ; 74 		i2c_wr_reg(ds_address, 0, &temp, 1);
5125  05c0 4b01          	push	#1
5126  05c2 ae0002        	ldw	x,#_temp
5127  05c5 89            	pushw	x
5128  05c6 aed000        	ldw	x,#53248
5129  05c9 cd013e        	call	_i2c_wr_reg
5131  05cc 5b03          	addw	sp,#3
5132  05ce               L3772:
5133                     ; 76 		timers_int_on();
5135  05ce cd040a        	call	_timers_int_on
5137                     ; 78 		_asm ("RIM");  //on interupts
5140  05d1 9a            RIM
5142  05d2               L5772:
5144  05d2 20fe          	jra	L5772
5157                     	xdef	_main
5158                     	xdef	_Keys_switched
5159                     	xdef	_I2C_Event
5160                     	xdef	_SPI_Transmitted
5161                     	xdef	_UART_Resieved
5162                     	xdef	_spi_setup
5163                     	xdef	_timer2_setup
5164                     	xdef	_timer1_setup
5165                     	xdef	_Timer1_Compare_1
5166                     	xdef	_Timer2_Overflow
5167                     	xdef	_timer2_start
5168                     	xdef	_timer1_start
5169                     	xdef	_kostil_k155
5170                     	xdef	_time_refresh
5171                     	xdef	_timers_int_on
5172                     	xdef	_timers_int_off
5173                     	xdef	_spi_send
5174                     	xdef	_i2c_rd_reg
5175                     	xdef	_i2c_wr_reg
5176                     	xdef	_i2c_master_init
5177                     	xdef	_Key_interrupt
5178                     	xdef	_uart_routine
5179                     	xdef	_uart_send
5180                     	xdef	_uart_setup
5181                     	xdef	_time_write
5182                     	switch	.ubsct
5183  0000               _i2c_flags:
5184  0000 00            	ds.b	1
5185                     	xdef	_i2c_flags
5186  0001               _flags:
5187  0001 00            	ds.b	1
5188                     	xdef	_flags
5189                     	xdef	_ds_cr
5190                     	xdef	_temp3
5191                     	xdef	_temp2
5192  0002               _temp:
5193  0002 00            	ds.b	1
5194                     	xdef	_temp
5195  0003               _pins:
5196  0003 00            	ds.b	1
5197                     	xdef	_pins
5198  0004               _fresh_data_pointer:
5199  0004 0000          	ds.b	2
5200                     	xdef	_fresh_data_pointer
5201  0006               _data_pointer:
5202  0006 0000          	ds.b	2
5203                     	xdef	_data_pointer
5204                     	xdef	_time_pointer
5205  0008               _hours_tens:
5206  0008 00            	ds.b	1
5207                     	xdef	_hours_tens
5208  0009               _minutes_tens:
5209  0009 00            	ds.b	1
5210                     	xdef	_minutes_tens
5211  000a               _seconds_tens:
5212  000a 00            	ds.b	1
5213                     	xdef	_seconds_tens
5214  000b               _seconds:
5215  000b 00            	ds.b	1
5216                     	xdef	_seconds
5217  000c               _minutes:
5218  000c 00            	ds.b	1
5219                     	xdef	_minutes
5220  000d               _hours:
5221  000d 00            	ds.b	1
5222                     	xdef	_hours
5223  000e               _timeset:
5224  000e 00            	ds.b	1
5225                     	xdef	_timeset
5226  000f               _fresh_sec:
5227  000f 00            	ds.b	1
5228                     	xdef	_fresh_sec
5229  0010               _fresh_sec_dec:
5230  0010 00            	ds.b	1
5231                     	xdef	_fresh_sec_dec
5232  0011               _fresh_min:
5233  0011 00            	ds.b	1
5234                     	xdef	_fresh_min
5235  0012               _fresh_min_dec:
5236  0012 00            	ds.b	1
5237                     	xdef	_fresh_min_dec
5238  0013               _fresh_hours:
5239  0013 00            	ds.b	1
5240                     	xdef	_fresh_hours
5241  0014               _fresh_hours_dec:
5242  0014 00            	ds.b	1
5243                     	xdef	_fresh_hours_dec
5244  0015               _lamp_number_data:
5245  0015 00            	ds.b	1
5246                     	xdef	_lamp_number_data
5247  0016               _k155_data:
5248  0016 00            	ds.b	1
5249                     	xdef	_k155_data
5250                     	xdef	_dots
5251                     	xdef	_lamp_number
5252                     	xref.b	c_lreg
5253                     	xref.b	c_x
5273                     	xref	c_lrsh
5274                     	xref	c_ldiv
5275                     	xref	c_uitolx
5276                     	xref	c_ludv
5277                     	xref	c_rtol
5278                     	xref	c_ltor
5279                     	end
