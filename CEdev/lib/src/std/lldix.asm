; (c) Copyright 2001-2008 Zilog, Inc.
;-------------------------------------------------------------------------
; long load e:hl,(ix+nnnnnn)
; Input:
;	Operand1: 
;                 BC : 24-bit offset from ix
;
; Output:
;       Result:   E:HL : 32 bit
;
; Registers Used:
;      
;-------------------------------------------------------------------------
	.assume adl=1
        .def    __lldix
	
__lldix        equ 0001C0h

