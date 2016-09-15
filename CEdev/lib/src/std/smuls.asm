; (c) Copyright 2001-2008 Zilog, Inc.
;-------------------------------------------------------------------------
; Short Multiply Signed
; Input:
;	Operand1: 
;		  bc : 16 bits
; 
;	Operand2: 
;		  hl :	 16 bits
;
; Output:
;	Result:   hl : 16 bits
;
; Registers Used:
;	
;-------------------------------------------------------------------------
	.assume adl=1
	.def	__smuls
	.ref	__imuls
	
__smuls        equ 000224h	
