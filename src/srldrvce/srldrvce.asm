;-------------------------------------------------------------------------------
include '../include/library.inc'
include '../include/include_library.inc'
;-------------------------------------------------------------------------------

library 'SRLDRVCE', 0

;-------------------------------------------------------------------------------
; Dependencies
;-------------------------------------------------------------------------------
include_library '../usbdrvce/usbdrvce.asm'

;-------------------------------------------------------------------------------
; v0 functions (not final, subject to change!)
;-------------------------------------------------------------------------------
	export srl_Init
	export srl_GetType
	export srl_SetRate
	export srl_GetRate
	export srl_SetCoding
	export srl_GetCoding
	export srl_Available
	export srl_Read
	export srl_Write
	export srl_Read_Blocking
	export srl_Write_Blocking
;-------------------------------------------------------------------------------

srl_Init:
	ret

