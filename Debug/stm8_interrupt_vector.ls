   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2213                     ; 25 @far @interrupt void NonHandledInterrupt (void)
2213                     ; 26 {
2214                     	switch	.text
2215  0000               f_NonHandledInterrupt:
2219                     ; 30 	return;
2222  0000 80            	iret
2246                     ; 33 @far @interrupt void Keys_switched_interrupt(void)
2246                     ; 34 {
2247                     	switch	.text
2248  0001               f_Keys_switched_interrupt:
2250  0001 8a            	push	cc
2251  0002 84            	pop	a
2252  0003 a4bf          	and	a,#191
2253  0005 88            	push	a
2254  0006 86            	pop	cc
2255  0007 3b0002        	push	c_x+2
2256  000a be00          	ldw	x,c_x
2257  000c 89            	pushw	x
2258  000d 3b0002        	push	c_y+2
2259  0010 be00          	ldw	x,c_y
2260  0012 89            	pushw	x
2263                     ; 35 	Keys_switched();
2265  0013 cd0000        	call	_Keys_switched
2267                     ; 37 	return;
2270  0016 85            	popw	x
2271  0017 bf00          	ldw	c_y,x
2272  0019 320002        	pop	c_y+2
2273  001c 85            	popw	x
2274  001d bf00          	ldw	c_x,x
2275  001f 320002        	pop	c_x+2
2276  0022 80            	iret
2300                     ; 40 @far @interrupt void UART_Resieved_Handler (void)
2300                     ; 41 {	
2301                     	switch	.text
2302  0023               f_UART_Resieved_Handler:
2304  0023 8a            	push	cc
2305  0024 84            	pop	a
2306  0025 a4bf          	and	a,#191
2307  0027 88            	push	a
2308  0028 86            	pop	cc
2309  0029 3b0002        	push	c_x+2
2310  002c be00          	ldw	x,c_x
2311  002e 89            	pushw	x
2312  002f 3b0002        	push	c_y+2
2313  0032 be00          	ldw	x,c_y
2314  0034 89            	pushw	x
2317                     ; 43 		UART_Resieved();
2319  0035 cd0000        	call	_UART_Resieved
2321                     ; 45 	return;
2324  0038 85            	popw	x
2325  0039 bf00          	ldw	c_y,x
2326  003b 320002        	pop	c_y+2
2327  003e 85            	popw	x
2328  003f bf00          	ldw	c_x,x
2329  0041 320002        	pop	c_x+2
2330  0044 80            	iret
2354                     ; 48 @far @interrupt void SPI_Transmitted_Handler (void)
2354                     ; 49 {	
2355                     	switch	.text
2356  0045               f_SPI_Transmitted_Handler:
2358  0045 8a            	push	cc
2359  0046 84            	pop	a
2360  0047 a4bf          	and	a,#191
2361  0049 88            	push	a
2362  004a 86            	pop	cc
2363  004b 3b0002        	push	c_x+2
2364  004e be00          	ldw	x,c_x
2365  0050 89            	pushw	x
2366  0051 3b0002        	push	c_y+2
2367  0054 be00          	ldw	x,c_y
2368  0056 89            	pushw	x
2371                     ; 50 	SPI_Transmitted();
2373  0057 cd0000        	call	_SPI_Transmitted
2375                     ; 51 	return;
2378  005a 85            	popw	x
2379  005b bf00          	ldw	c_y,x
2380  005d 320002        	pop	c_y+2
2381  0060 85            	popw	x
2382  0061 bf00          	ldw	c_x,x
2383  0063 320002        	pop	c_x+2
2384  0066 80            	iret
2406                     ; 53 @far @interrupt void I2C_Handler(void)
2406                     ; 54 {
2407                     	switch	.text
2408  0067               f_I2C_Handler:
2412                     ; 55 	return;
2415  0067 80            	iret
2439                     ; 58 @far @interrupt void Timer1_overflow_handler(void)
2439                     ; 59 {
2440                     	switch	.text
2441  0068               f_Timer1_overflow_handler:
2443  0068 8a            	push	cc
2444  0069 84            	pop	a
2445  006a a4bf          	and	a,#191
2446  006c 88            	push	a
2447  006d 86            	pop	cc
2448  006e 3b0002        	push	c_x+2
2449  0071 be00          	ldw	x,c_x
2450  0073 89            	pushw	x
2451  0074 3b0002        	push	c_y+2
2452  0077 be00          	ldw	x,c_y
2453  0079 89            	pushw	x
2456                     ; 60 	Timer1_overflow();
2458  007a cd0000        	call	_Timer1_overflow
2460                     ; 61 }
2463  007d 85            	popw	x
2464  007e bf00          	ldw	c_y,x
2465  0080 320002        	pop	c_y+2
2466  0083 85            	popw	x
2467  0084 bf00          	ldw	c_x,x
2468  0086 320002        	pop	c_x+2
2469  0089 80            	iret
2493                     ; 64 @far @interrupt void Timer2_overflow_handler(void)
2493                     ; 65 {
2494                     	switch	.text
2495  008a               f_Timer2_overflow_handler:
2497  008a 8a            	push	cc
2498  008b 84            	pop	a
2499  008c a4bf          	and	a,#191
2500  008e 88            	push	a
2501  008f 86            	pop	cc
2502  0090 3b0002        	push	c_x+2
2503  0093 be00          	ldw	x,c_x
2504  0095 89            	pushw	x
2505  0096 3b0002        	push	c_y+2
2506  0099 be00          	ldw	x,c_y
2507  009b 89            	pushw	x
2510                     ; 66 	Timer2_Overflow();
2512  009c cd0000        	call	_Timer2_Overflow
2514                     ; 67 }
2517  009f 85            	popw	x
2518  00a0 bf00          	ldw	c_y,x
2519  00a2 320002        	pop	c_y+2
2520  00a5 85            	popw	x
2521  00a6 bf00          	ldw	c_x,x
2522  00a8 320002        	pop	c_x+2
2523  00ab 80            	iret
2546                     ; 69 @far @interrupt void ds_pulse_interrupt(void)
2546                     ; 70 {
2547                     	switch	.text
2548  00ac               f_ds_pulse_interrupt:
2550  00ac 8a            	push	cc
2551  00ad 84            	pop	a
2552  00ae a4bf          	and	a,#191
2553  00b0 88            	push	a
2554  00b1 86            	pop	cc
2555  00b2 3b0002        	push	c_x+2
2556  00b5 be00          	ldw	x,c_x
2557  00b7 89            	pushw	x
2558  00b8 3b0002        	push	c_y+2
2559  00bb be00          	ldw	x,c_y
2560  00bd 89            	pushw	x
2563                     ; 71 	time_refresh();
2565  00be cd0000        	call	_time_refresh
2567                     ; 72 }
2570  00c1 85            	popw	x
2571  00c2 bf00          	ldw	c_y,x
2572  00c4 320002        	pop	c_y+2
2573  00c7 85            	popw	x
2574  00c8 bf00          	ldw	c_x,x
2575  00ca 320002        	pop	c_x+2
2576  00cd 80            	iret
2600                     ; 73 @far @interrupt void timer2_compare_handler (void)
2600                     ; 74 {
2601                     	switch	.text
2602  00ce               f_timer2_compare_handler:
2604  00ce 8a            	push	cc
2605  00cf 84            	pop	a
2606  00d0 a4bf          	and	a,#191
2607  00d2 88            	push	a
2608  00d3 86            	pop	cc
2609  00d4 3b0002        	push	c_x+2
2610  00d7 be00          	ldw	x,c_x
2611  00d9 89            	pushw	x
2612  00da 3b0002        	push	c_y+2
2613  00dd be00          	ldw	x,c_y
2614  00df 89            	pushw	x
2617                     ; 75 	timer2_compare();
2619  00e0 cd0000        	call	_timer2_compare
2621                     ; 76 }
2624  00e3 85            	popw	x
2625  00e4 bf00          	ldw	c_y,x
2626  00e6 320002        	pop	c_y+2
2627  00e9 85            	popw	x
2628  00ea bf00          	ldw	c_x,x
2629  00ec 320002        	pop	c_x+2
2630  00ef 80            	iret
2654                     ; 77 @far @interrupt void timer1_compare_handler(void)
2654                     ; 78 {
2655                     	switch	.text
2656  00f0               f_timer1_compare_handler:
2658  00f0 8a            	push	cc
2659  00f1 84            	pop	a
2660  00f2 a4bf          	and	a,#191
2661  00f4 88            	push	a
2662  00f5 86            	pop	cc
2663  00f6 3b0002        	push	c_x+2
2664  00f9 be00          	ldw	x,c_x
2665  00fb 89            	pushw	x
2666  00fc 3b0002        	push	c_y+2
2667  00ff be00          	ldw	x,c_y
2668  0101 89            	pushw	x
2671                     ; 79 	timer1_compare();
2673  0102 cd0000        	call	_timer1_compare
2675                     ; 80 }
2678  0105 85            	popw	x
2679  0106 bf00          	ldw	c_y,x
2680  0108 320002        	pop	c_y+2
2681  010b 85            	popw	x
2682  010c bf00          	ldw	c_x,x
2683  010e 320002        	pop	c_x+2
2684  0111 80            	iret
2686                     .const:	section	.text
2687  0000               __vectab:
2688  0000 82            	dc.b	130
2690  0001 00            	dc.b	page(__stext)
2691  0002 0000          	dc.w	__stext
2692  0004 82            	dc.b	130
2694  0005 00            	dc.b	page(f_NonHandledInterrupt)
2695  0006 0000          	dc.w	f_NonHandledInterrupt
2696  0008 82            	dc.b	130
2698  0009 00            	dc.b	page(f_NonHandledInterrupt)
2699  000a 0000          	dc.w	f_NonHandledInterrupt
2700  000c 82            	dc.b	130
2702  000d 00            	dc.b	page(f_NonHandledInterrupt)
2703  000e 0000          	dc.w	f_NonHandledInterrupt
2704  0010 82            	dc.b	130
2706  0011 00            	dc.b	page(f_NonHandledInterrupt)
2707  0012 0000          	dc.w	f_NonHandledInterrupt
2708  0014 82            	dc.b	130
2710  0015 ac            	dc.b	page(f_ds_pulse_interrupt)
2711  0016 00ac          	dc.w	f_ds_pulse_interrupt
2712  0018 82            	dc.b	130
2714  0019 00            	dc.b	page(f_NonHandledInterrupt)
2715  001a 0000          	dc.w	f_NonHandledInterrupt
2716  001c 82            	dc.b	130
2718  001d 01            	dc.b	page(f_Keys_switched_interrupt)
2719  001e 0001          	dc.w	f_Keys_switched_interrupt
2720  0020 82            	dc.b	130
2722  0021 00            	dc.b	page(f_NonHandledInterrupt)
2723  0022 0000          	dc.w	f_NonHandledInterrupt
2724  0024 82            	dc.b	130
2726  0025 00            	dc.b	page(f_NonHandledInterrupt)
2727  0026 0000          	dc.w	f_NonHandledInterrupt
2728  0028 82            	dc.b	130
2730  0029 00            	dc.b	page(f_NonHandledInterrupt)
2731  002a 0000          	dc.w	f_NonHandledInterrupt
2732  002c 82            	dc.b	130
2734  002d 00            	dc.b	page(f_NonHandledInterrupt)
2735  002e 0000          	dc.w	f_NonHandledInterrupt
2736  0030 82            	dc.b	130
2738  0031 45            	dc.b	page(f_SPI_Transmitted_Handler)
2739  0032 0045          	dc.w	f_SPI_Transmitted_Handler
2740  0034 82            	dc.b	130
2742  0035 68            	dc.b	page(f_Timer1_overflow_handler)
2743  0036 0068          	dc.w	f_Timer1_overflow_handler
2744  0038 82            	dc.b	130
2746  0039 f0            	dc.b	page(f_timer1_compare_handler)
2747  003a 00f0          	dc.w	f_timer1_compare_handler
2748  003c 82            	dc.b	130
2750  003d 8a            	dc.b	page(f_Timer2_overflow_handler)
2751  003e 008a          	dc.w	f_Timer2_overflow_handler
2752  0040 82            	dc.b	130
2754  0041 ce            	dc.b	page(f_timer2_compare_handler)
2755  0042 00ce          	dc.w	f_timer2_compare_handler
2756  0044 82            	dc.b	130
2758  0045 00            	dc.b	page(f_NonHandledInterrupt)
2759  0046 0000          	dc.w	f_NonHandledInterrupt
2760  0048 82            	dc.b	130
2762  0049 00            	dc.b	page(f_NonHandledInterrupt)
2763  004a 0000          	dc.w	f_NonHandledInterrupt
2764  004c 82            	dc.b	130
2766  004d 00            	dc.b	page(f_NonHandledInterrupt)
2767  004e 0000          	dc.w	f_NonHandledInterrupt
2768  0050 82            	dc.b	130
2770  0051 23            	dc.b	page(f_UART_Resieved_Handler)
2771  0052 0023          	dc.w	f_UART_Resieved_Handler
2772  0054 82            	dc.b	130
2774  0055 67            	dc.b	page(f_I2C_Handler)
2775  0056 0067          	dc.w	f_I2C_Handler
2776  0058 82            	dc.b	130
2778  0059 00            	dc.b	page(f_NonHandledInterrupt)
2779  005a 0000          	dc.w	f_NonHandledInterrupt
2780  005c 82            	dc.b	130
2782  005d 00            	dc.b	page(f_NonHandledInterrupt)
2783  005e 0000          	dc.w	f_NonHandledInterrupt
2784  0060 82            	dc.b	130
2786  0061 00            	dc.b	page(f_NonHandledInterrupt)
2787  0062 0000          	dc.w	f_NonHandledInterrupt
2788  0064 82            	dc.b	130
2790  0065 00            	dc.b	page(f_NonHandledInterrupt)
2791  0066 0000          	dc.w	f_NonHandledInterrupt
2792  0068 82            	dc.b	130
2794  0069 00            	dc.b	page(f_NonHandledInterrupt)
2795  006a 0000          	dc.w	f_NonHandledInterrupt
2796  006c 82            	dc.b	130
2798  006d 00            	dc.b	page(f_NonHandledInterrupt)
2799  006e 0000          	dc.w	f_NonHandledInterrupt
2800  0070 82            	dc.b	130
2802  0071 00            	dc.b	page(f_NonHandledInterrupt)
2803  0072 0000          	dc.w	f_NonHandledInterrupt
2804  0074 82            	dc.b	130
2806  0075 00            	dc.b	page(f_NonHandledInterrupt)
2807  0076 0000          	dc.w	f_NonHandledInterrupt
2808  0078 82            	dc.b	130
2810  0079 00            	dc.b	page(f_NonHandledInterrupt)
2811  007a 0000          	dc.w	f_NonHandledInterrupt
2812  007c 82            	dc.b	130
2814  007d 00            	dc.b	page(f_NonHandledInterrupt)
2815  007e 0000          	dc.w	f_NonHandledInterrupt
2866                     	xdef	__vectab
2867                     	xref	__stext
2868                     	xdef	f_timer1_compare_handler
2869                     	xdef	f_timer2_compare_handler
2870                     	xdef	f_ds_pulse_interrupt
2871                     	xdef	f_Timer2_overflow_handler
2872                     	xdef	f_Timer1_overflow_handler
2873                     	xdef	f_I2C_Handler
2874                     	xdef	f_SPI_Transmitted_Handler
2875                     	xdef	f_UART_Resieved_Handler
2876                     	xdef	f_Keys_switched_interrupt
2877                     	xdef	f_NonHandledInterrupt
2878                     	xref	_timer2_compare
2879                     	xref	_time_refresh
2880                     	xref	_Timer2_Overflow
2881                     	xref	_timer1_compare
2882                     	xref	_Timer1_overflow
2883                     	xref	_Keys_switched
2884                     	xref	_UART_Resieved
2885                     	xref	_SPI_Transmitted
2886                     	xref.b	c_x
2887                     	xref.b	c_y
2906                     	end
