   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2213                     ; 24 @far @interrupt void NonHandledInterrupt (void)
2213                     ; 25 {
2214                     	switch	.text
2215  0000               f_NonHandledInterrupt:
2219                     ; 29 	return;
2222  0000 80            	iret
2246                     ; 32 @far @interrupt void Keys_switched_interrupt(void)
2246                     ; 33 {
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
2263                     ; 34 	Keys_switched();
2265  0013 cd0000        	call	_Keys_switched
2267                     ; 36 	return;
2270  0016 85            	popw	x
2271  0017 bf00          	ldw	c_y,x
2272  0019 320002        	pop	c_y+2
2273  001c 85            	popw	x
2274  001d bf00          	ldw	c_x,x
2275  001f 320002        	pop	c_x+2
2276  0022 80            	iret
2300                     ; 39 @far @interrupt void UART_Resieved_Handler (void)
2300                     ; 40 {	
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
2317                     ; 42 		UART_Resieved();
2319  0035 cd0000        	call	_UART_Resieved
2321                     ; 44 	return;
2324  0038 85            	popw	x
2325  0039 bf00          	ldw	c_y,x
2326  003b 320002        	pop	c_y+2
2327  003e 85            	popw	x
2328  003f bf00          	ldw	c_x,x
2329  0041 320002        	pop	c_x+2
2330  0044 80            	iret
2354                     ; 47 @far @interrupt void SPI_Transmitted_Handler (void)
2354                     ; 48 {	
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
2371                     ; 49 	SPI_Transmitted();
2373  0057 cd0000        	call	_SPI_Transmitted
2375                     ; 50 	return;
2378  005a 85            	popw	x
2379  005b bf00          	ldw	c_y,x
2380  005d 320002        	pop	c_y+2
2381  0060 85            	popw	x
2382  0061 bf00          	ldw	c_x,x
2383  0063 320002        	pop	c_x+2
2384  0066 80            	iret
2406                     ; 52 @far @interrupt void I2C_Handler(void)
2406                     ; 53 {
2407                     	switch	.text
2408  0067               f_I2C_Handler:
2412                     ; 54 	return;
2415  0067 80            	iret
2439                     ; 57 @far @interrupt void Timer1_overflow_handler(void)
2439                     ; 58 {
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
2456                     ; 59 	Timer1_Compare_1();
2458  007a cd0000        	call	_Timer1_Compare_1
2460                     ; 60 }
2463  007d 85            	popw	x
2464  007e bf00          	ldw	c_y,x
2465  0080 320002        	pop	c_y+2
2466  0083 85            	popw	x
2467  0084 bf00          	ldw	c_x,x
2468  0086 320002        	pop	c_x+2
2469  0089 80            	iret
2493                     ; 63 @far @interrupt void Timer2_overflow_handler(void)
2493                     ; 64 {
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
2510                     ; 65 	Timer2_Overflow();
2512  009c cd0000        	call	_Timer2_Overflow
2514                     ; 66 }
2517  009f 85            	popw	x
2518  00a0 bf00          	ldw	c_y,x
2519  00a2 320002        	pop	c_y+2
2520  00a5 85            	popw	x
2521  00a6 bf00          	ldw	c_x,x
2522  00a8 320002        	pop	c_x+2
2523  00ab 80            	iret
2546                     ; 68 @far @interrupt void ds_pulse_interrupt(void)
2546                     ; 69 {
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
2563                     ; 70 	time_refresh();
2565  00be cd0000        	call	_time_refresh
2567                     ; 71 }
2570  00c1 85            	popw	x
2571  00c2 bf00          	ldw	c_y,x
2572  00c4 320002        	pop	c_y+2
2573  00c7 85            	popw	x
2574  00c8 bf00          	ldw	c_x,x
2575  00ca 320002        	pop	c_x+2
2576  00cd 80            	iret
2578                     .const:	section	.text
2579  0000               __vectab:
2580  0000 82            	dc.b	130
2582  0001 00            	dc.b	page(__stext)
2583  0002 0000          	dc.w	__stext
2584  0004 82            	dc.b	130
2586  0005 00            	dc.b	page(f_NonHandledInterrupt)
2587  0006 0000          	dc.w	f_NonHandledInterrupt
2588  0008 82            	dc.b	130
2590  0009 00            	dc.b	page(f_NonHandledInterrupt)
2591  000a 0000          	dc.w	f_NonHandledInterrupt
2592  000c 82            	dc.b	130
2594  000d 00            	dc.b	page(f_NonHandledInterrupt)
2595  000e 0000          	dc.w	f_NonHandledInterrupt
2596  0010 82            	dc.b	130
2598  0011 00            	dc.b	page(f_NonHandledInterrupt)
2599  0012 0000          	dc.w	f_NonHandledInterrupt
2600  0014 82            	dc.b	130
2602  0015 ac            	dc.b	page(f_ds_pulse_interrupt)
2603  0016 00ac          	dc.w	f_ds_pulse_interrupt
2604  0018 82            	dc.b	130
2606  0019 00            	dc.b	page(f_NonHandledInterrupt)
2607  001a 0000          	dc.w	f_NonHandledInterrupt
2608  001c 82            	dc.b	130
2610  001d 01            	dc.b	page(f_Keys_switched_interrupt)
2611  001e 0001          	dc.w	f_Keys_switched_interrupt
2612  0020 82            	dc.b	130
2614  0021 00            	dc.b	page(f_NonHandledInterrupt)
2615  0022 0000          	dc.w	f_NonHandledInterrupt
2616  0024 82            	dc.b	130
2618  0025 00            	dc.b	page(f_NonHandledInterrupt)
2619  0026 0000          	dc.w	f_NonHandledInterrupt
2620  0028 82            	dc.b	130
2622  0029 00            	dc.b	page(f_NonHandledInterrupt)
2623  002a 0000          	dc.w	f_NonHandledInterrupt
2624  002c 82            	dc.b	130
2626  002d 00            	dc.b	page(f_NonHandledInterrupt)
2627  002e 0000          	dc.w	f_NonHandledInterrupt
2628  0030 82            	dc.b	130
2630  0031 45            	dc.b	page(f_SPI_Transmitted_Handler)
2631  0032 0045          	dc.w	f_SPI_Transmitted_Handler
2632  0034 82            	dc.b	130
2634  0035 68            	dc.b	page(f_Timer1_overflow_handler)
2635  0036 0068          	dc.w	f_Timer1_overflow_handler
2636  0038 82            	dc.b	130
2638  0039 00            	dc.b	page(f_NonHandledInterrupt)
2639  003a 0000          	dc.w	f_NonHandledInterrupt
2640  003c 82            	dc.b	130
2642  003d 8a            	dc.b	page(f_Timer2_overflow_handler)
2643  003e 008a          	dc.w	f_Timer2_overflow_handler
2644  0040 82            	dc.b	130
2646  0041 00            	dc.b	page(f_NonHandledInterrupt)
2647  0042 0000          	dc.w	f_NonHandledInterrupt
2648  0044 82            	dc.b	130
2650  0045 00            	dc.b	page(f_NonHandledInterrupt)
2651  0046 0000          	dc.w	f_NonHandledInterrupt
2652  0048 82            	dc.b	130
2654  0049 00            	dc.b	page(f_NonHandledInterrupt)
2655  004a 0000          	dc.w	f_NonHandledInterrupt
2656  004c 82            	dc.b	130
2658  004d 00            	dc.b	page(f_NonHandledInterrupt)
2659  004e 0000          	dc.w	f_NonHandledInterrupt
2660  0050 82            	dc.b	130
2662  0051 23            	dc.b	page(f_UART_Resieved_Handler)
2663  0052 0023          	dc.w	f_UART_Resieved_Handler
2664  0054 82            	dc.b	130
2666  0055 67            	dc.b	page(f_I2C_Handler)
2667  0056 0067          	dc.w	f_I2C_Handler
2668  0058 82            	dc.b	130
2670  0059 00            	dc.b	page(f_NonHandledInterrupt)
2671  005a 0000          	dc.w	f_NonHandledInterrupt
2672  005c 82            	dc.b	130
2674  005d 00            	dc.b	page(f_NonHandledInterrupt)
2675  005e 0000          	dc.w	f_NonHandledInterrupt
2676  0060 82            	dc.b	130
2678  0061 00            	dc.b	page(f_NonHandledInterrupt)
2679  0062 0000          	dc.w	f_NonHandledInterrupt
2680  0064 82            	dc.b	130
2682  0065 00            	dc.b	page(f_NonHandledInterrupt)
2683  0066 0000          	dc.w	f_NonHandledInterrupt
2684  0068 82            	dc.b	130
2686  0069 00            	dc.b	page(f_NonHandledInterrupt)
2687  006a 0000          	dc.w	f_NonHandledInterrupt
2688  006c 82            	dc.b	130
2690  006d 00            	dc.b	page(f_NonHandledInterrupt)
2691  006e 0000          	dc.w	f_NonHandledInterrupt
2692  0070 82            	dc.b	130
2694  0071 00            	dc.b	page(f_NonHandledInterrupt)
2695  0072 0000          	dc.w	f_NonHandledInterrupt
2696  0074 82            	dc.b	130
2698  0075 00            	dc.b	page(f_NonHandledInterrupt)
2699  0076 0000          	dc.w	f_NonHandledInterrupt
2700  0078 82            	dc.b	130
2702  0079 00            	dc.b	page(f_NonHandledInterrupt)
2703  007a 0000          	dc.w	f_NonHandledInterrupt
2704  007c 82            	dc.b	130
2706  007d 00            	dc.b	page(f_NonHandledInterrupt)
2707  007e 0000          	dc.w	f_NonHandledInterrupt
2758                     	xdef	__vectab
2759                     	xref	__stext
2760                     	xdef	f_ds_pulse_interrupt
2761                     	xdef	f_Timer2_overflow_handler
2762                     	xdef	f_Timer1_overflow_handler
2763                     	xdef	f_I2C_Handler
2764                     	xdef	f_SPI_Transmitted_Handler
2765                     	xdef	f_UART_Resieved_Handler
2766                     	xdef	f_Keys_switched_interrupt
2767                     	xdef	f_NonHandledInterrupt
2768                     	xref	_time_refresh
2769                     	xref	_Timer2_Overflow
2770                     	xref	_Timer1_Compare_1
2771                     	xref	_Keys_switched
2772                     	xref	_UART_Resieved
2773                     	xref	_SPI_Transmitted
2774                     	xref.b	c_x
2775                     	xref.b	c_y
2794                     	end
