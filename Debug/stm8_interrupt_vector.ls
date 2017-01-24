   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
2213                     ; 28 @far @interrupt void NonHandledInterrupt (void)
2213                     ; 29 {
2214                     	switch	.text
2215  0000               f_NonHandledInterrupt:
2219                     ; 33 	return;
2222  0000 80            	iret
2246                     ; 36 @far @interrupt void Keys_switched_interrupt(void)
2246                     ; 37 {
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
2263                     ; 38 	Keys_switched();
2265  0013 cd0000        	call	_Keys_switched
2267                     ; 40 	return;
2270  0016 85            	popw	x
2271  0017 bf00          	ldw	c_y,x
2272  0019 320002        	pop	c_y+2
2273  001c 85            	popw	x
2274  001d bf00          	ldw	c_x,x
2275  001f 320002        	pop	c_x+2
2276  0022 80            	iret
2300                     ; 49 @far @interrupt void UART_Resieved_Handler (void)
2300                     ; 50 {	
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
2317                     ; 52 		UART_Resieved();
2319  0035 cd0000        	call	_UART_Resieved
2321                     ; 54 	return;
2324  0038 85            	popw	x
2325  0039 bf00          	ldw	c_y,x
2326  003b 320002        	pop	c_y+2
2327  003e 85            	popw	x
2328  003f bf00          	ldw	c_x,x
2329  0041 320002        	pop	c_x+2
2330  0044 80            	iret
2354                     ; 57 @far @interrupt void SPI_Transmitted_Handler (void)
2354                     ; 58 {	
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
2371                     ; 59 	SPI_Transmitted();
2373  0057 cd0000        	call	_SPI_Transmitted
2375                     ; 60 	return;
2378  005a 85            	popw	x
2379  005b bf00          	ldw	c_y,x
2380  005d 320002        	pop	c_y+2
2381  0060 85            	popw	x
2382  0061 bf00          	ldw	c_x,x
2383  0063 320002        	pop	c_x+2
2384  0066 80            	iret
2406                     ; 62 @far @interrupt void I2C_Handler(void)
2406                     ; 63 {
2407                     	switch	.text
2408  0067               f_I2C_Handler:
2412                     ; 65 	return;
2415  0067 80            	iret
2439                     ; 68 @far @interrupt void Timer1_overflow_handler(void)
2439                     ; 69 {
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
2456                     ; 70 	Timer1_Compare_1();
2458  007a cd0000        	call	_Timer1_Compare_1
2460                     ; 71 }
2463  007d 85            	popw	x
2464  007e bf00          	ldw	c_y,x
2465  0080 320002        	pop	c_y+2
2466  0083 85            	popw	x
2467  0084 bf00          	ldw	c_x,x
2468  0086 320002        	pop	c_x+2
2469  0089 80            	iret
2493                     ; 74 @far @interrupt void Timer2_overflow_handler(void)
2493                     ; 75 {
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
2510                     ; 76 	Timer2_Overflow();
2512  009c cd0000        	call	_Timer2_Overflow
2514                     ; 77 }
2517  009f 85            	popw	x
2518  00a0 bf00          	ldw	c_y,x
2519  00a2 320002        	pop	c_y+2
2520  00a5 85            	popw	x
2521  00a6 bf00          	ldw	c_x,x
2522  00a8 320002        	pop	c_x+2
2523  00ab 80            	iret
2525                     .const:	section	.text
2526  0000               __vectab:
2527  0000 82            	dc.b	130
2529  0001 00            	dc.b	page(__stext)
2530  0002 0000          	dc.w	__stext
2531  0004 82            	dc.b	130
2533  0005 00            	dc.b	page(f_NonHandledInterrupt)
2534  0006 0000          	dc.w	f_NonHandledInterrupt
2535  0008 82            	dc.b	130
2537  0009 00            	dc.b	page(f_NonHandledInterrupt)
2538  000a 0000          	dc.w	f_NonHandledInterrupt
2539  000c 82            	dc.b	130
2541  000d 00            	dc.b	page(f_NonHandledInterrupt)
2542  000e 0000          	dc.w	f_NonHandledInterrupt
2543  0010 82            	dc.b	130
2545  0011 00            	dc.b	page(f_NonHandledInterrupt)
2546  0012 0000          	dc.w	f_NonHandledInterrupt
2547  0014 82            	dc.b	130
2549  0015 00            	dc.b	page(f_NonHandledInterrupt)
2550  0016 0000          	dc.w	f_NonHandledInterrupt
2551  0018 82            	dc.b	130
2553  0019 00            	dc.b	page(f_NonHandledInterrupt)
2554  001a 0000          	dc.w	f_NonHandledInterrupt
2555  001c 82            	dc.b	130
2557  001d 01            	dc.b	page(f_Keys_switched_interrupt)
2558  001e 0001          	dc.w	f_Keys_switched_interrupt
2559  0020 82            	dc.b	130
2561  0021 00            	dc.b	page(f_NonHandledInterrupt)
2562  0022 0000          	dc.w	f_NonHandledInterrupt
2563  0024 82            	dc.b	130
2565  0025 00            	dc.b	page(f_NonHandledInterrupt)
2566  0026 0000          	dc.w	f_NonHandledInterrupt
2567  0028 82            	dc.b	130
2569  0029 00            	dc.b	page(f_NonHandledInterrupt)
2570  002a 0000          	dc.w	f_NonHandledInterrupt
2571  002c 82            	dc.b	130
2573  002d 00            	dc.b	page(f_NonHandledInterrupt)
2574  002e 0000          	dc.w	f_NonHandledInterrupt
2575  0030 82            	dc.b	130
2577  0031 45            	dc.b	page(f_SPI_Transmitted_Handler)
2578  0032 0045          	dc.w	f_SPI_Transmitted_Handler
2579  0034 82            	dc.b	130
2581  0035 68            	dc.b	page(f_Timer1_overflow_handler)
2582  0036 0068          	dc.w	f_Timer1_overflow_handler
2583  0038 82            	dc.b	130
2585  0039 00            	dc.b	page(f_NonHandledInterrupt)
2586  003a 0000          	dc.w	f_NonHandledInterrupt
2587  003c 82            	dc.b	130
2589  003d 8a            	dc.b	page(f_Timer2_overflow_handler)
2590  003e 008a          	dc.w	f_Timer2_overflow_handler
2591  0040 82            	dc.b	130
2593  0041 00            	dc.b	page(f_NonHandledInterrupt)
2594  0042 0000          	dc.w	f_NonHandledInterrupt
2595  0044 82            	dc.b	130
2597  0045 00            	dc.b	page(f_NonHandledInterrupt)
2598  0046 0000          	dc.w	f_NonHandledInterrupt
2599  0048 82            	dc.b	130
2601  0049 00            	dc.b	page(f_NonHandledInterrupt)
2602  004a 0000          	dc.w	f_NonHandledInterrupt
2603  004c 82            	dc.b	130
2605  004d 00            	dc.b	page(f_NonHandledInterrupt)
2606  004e 0000          	dc.w	f_NonHandledInterrupt
2607  0050 82            	dc.b	130
2609  0051 23            	dc.b	page(f_UART_Resieved_Handler)
2610  0052 0023          	dc.w	f_UART_Resieved_Handler
2611  0054 82            	dc.b	130
2613  0055 67            	dc.b	page(f_I2C_Handler)
2614  0056 0067          	dc.w	f_I2C_Handler
2615  0058 82            	dc.b	130
2617  0059 00            	dc.b	page(f_NonHandledInterrupt)
2618  005a 0000          	dc.w	f_NonHandledInterrupt
2619  005c 82            	dc.b	130
2621  005d 00            	dc.b	page(f_NonHandledInterrupt)
2622  005e 0000          	dc.w	f_NonHandledInterrupt
2623  0060 82            	dc.b	130
2625  0061 00            	dc.b	page(f_NonHandledInterrupt)
2626  0062 0000          	dc.w	f_NonHandledInterrupt
2627  0064 82            	dc.b	130
2629  0065 00            	dc.b	page(f_NonHandledInterrupt)
2630  0066 0000          	dc.w	f_NonHandledInterrupt
2631  0068 82            	dc.b	130
2633  0069 00            	dc.b	page(f_NonHandledInterrupt)
2634  006a 0000          	dc.w	f_NonHandledInterrupt
2635  006c 82            	dc.b	130
2637  006d 00            	dc.b	page(f_NonHandledInterrupt)
2638  006e 0000          	dc.w	f_NonHandledInterrupt
2639  0070 82            	dc.b	130
2641  0071 00            	dc.b	page(f_NonHandledInterrupt)
2642  0072 0000          	dc.w	f_NonHandledInterrupt
2643  0074 82            	dc.b	130
2645  0075 00            	dc.b	page(f_NonHandledInterrupt)
2646  0076 0000          	dc.w	f_NonHandledInterrupt
2647  0078 82            	dc.b	130
2649  0079 00            	dc.b	page(f_NonHandledInterrupt)
2650  007a 0000          	dc.w	f_NonHandledInterrupt
2651  007c 82            	dc.b	130
2653  007d 00            	dc.b	page(f_NonHandledInterrupt)
2654  007e 0000          	dc.w	f_NonHandledInterrupt
2705                     	xdef	__vectab
2706                     	xref	__stext
2707                     	xdef	f_Timer2_overflow_handler
2708                     	xdef	f_Timer1_overflow_handler
2709                     	xdef	f_I2C_Handler
2710                     	xdef	f_SPI_Transmitted_Handler
2711                     	xdef	f_UART_Resieved_Handler
2712                     	xdef	f_Keys_switched_interrupt
2713                     	xdef	f_NonHandledInterrupt
2714                     	xref	_Timer2_Overflow
2715                     	xref	_Timer1_Compare_1
2716                     	xref	_Keys_switched
2717                     	xref	_UART_Resieved
2718                     	xref	_SPI_Transmitted
2719                     	xref.b	c_x
2720                     	xref.b	c_y
2739                     	end
