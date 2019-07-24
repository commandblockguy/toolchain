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
	export srl_SetRate
	export srl_Available
	export srl_Read
	export srl_Write
	export srl_Read_Blocking
	export srl_Write_Blocking
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
; memory structures
;-------------------------------------------------------------------------------
macro struct? name*, parameters&
 macro end?.struct?!
     iterate base, ., .base
      if defined base
       assert base+sizeof base=$
      end if
     end iterate
   end namespace
  end struc
  iterate <base,prefix>, 0,, ix-name,x, iy-name,y
   virtual at base
	prefix#name	name
   end virtual
  end iterate
  purge end?.struct?
 end macro
 struc name parameters
  namespace .
end macro

struct srl_Device
	local size
	label .: size
	dev				rl 1	; USB device
	in				rl 1	; USB bulk in endpoint
	out				rl 1	; USB bulk out endpoint
	type			rb 1	; Device type
	readBuf			rl 1	; Pointer to the read buffer
	readBufSize		rl 1	; Size of the read buffer
	readBufStart	rl 1	; First byte with data in the read buffer
	readBufEnd		rl 1	; Last byte with data in the read buffer
	readBufBreak	rl 1	; Last byte before the buffer "loops"
	writeBuf		rl 1	; Pointer to the write buffer
	writeBufSize	rl 1	; Size of the write buffer
	writeBufStart	rl 1	; First byte with data in the write buffer
	writeBufEnd		rl 1	; Last byte with data in the write buffer
	size := $-.
end struct

; enum srl_DeviceType
virtual at 0
	?SRL_UNKNOWN	equ	0	/**< Incompatible or non-serial device */
	?SRL_HOST		equ 1	/**< Calc is acting as a device */
	?SRL_CDC		equ 2	/**< CDC device */
	?SRL_FTDI		equ 3	/**< FTDI device */
end virtual

;-------------------------------------------------------------------------------
;usb_error_t srl_Init(srl_device_t *srl, usb_device_t dev, void *buf, size_t size);
srl_Init:
	ld	iy,0
	add	iy,sp
;set srl->dev

;determine endpoints
;determine device type
;set read buffer pointer, start, and end
;divide size by 2
;set buffer sizes
;set write buffer pointer, start, and end
;set read buffer break to 0
;start async read
	xor	a,a
	ret
	ret

;-------------------------------------------------------------------------------
;usb_error_t srl_SetRate(srl_device_t *srl, uint24_t rate);
srl_SetRate:
	ld	iy,0
	add	iy,sp
;check device type
;if a CDC device:
; change the rate of the default line coding
; send control request
; return error, if any
;if a FTDI device:
; convert the rate to whatever completely arbitrary format FTDI uses
; send control request
; return error, if any
	ret

;-------------------------------------------------------------------------------
;size_t srl_Available(srl_device_t *srl);
srl_Available:
	ld	iy,0
	add	iy,sp
;if readBufBreak == 0:
; readBufEnd - readBufStart
;else:
; (readBufBreak - readBufStart) + (readBufEnd - readBuf)
	ret

;-------------------------------------------------------------------------------
;size_t srl_Read(srl_device_t *srl, void *buffer, size_t length);
srl_Read:
	ld	iy,0
	add	iy,sp
	ret

;-------------------------------------------------------------------------------
;size_t srl_Write(srl_device_t *srl, const void *buffer, size_t length);
srl_Write:
	ld	iy,0
	add	iy,sp
;copy data into buffer
;if writeBufStart == writeBufEnd:
; schedule transfer
;update writeBufEnd
	ret

;-------------------------------------------------------------------------------
;size_t srl_Read_Blocking(srl_device_t *srl, void *buffer, size_t length, uint24_t timeout);
srl_Read_Blocking:
	ld	iy,0
	add	iy,sp
;while total < length:
; check timeout
; usb_WaitForEvents ; would HandleEvents be better here?
; srl_Read(srl, buffer + total, total - length)
; total += len
	ret

;-------------------------------------------------------------------------------
;size_t srl_Write_Blocking(srl_device_t *srl, const void *buffer, size_t length, uint24_t timeout);
srl_Write_Blocking:
	ld	iy,0
	add	iy,sp
;while total < length:
; check timeout
; usb_Write(srl, buffer + total, total - length)
; usb_WaitForEvents ; would HandleEvents be better here?
; total += len
	ret

;-------------------------------------------------------------------------------
;usb_error_t (usb_endpoint_t endpoint, usb_transfer_status_t status, size_t transferred, srl_device_t *data);
srl_Read_Callback:
	ld	iy,0
	add	iy,sp
;update buffer info
;if ftdi:
; transferred -= 2
; copy data over 2 bytes
;readBufEnd += transferred
;if readBufEnd + 64 > readBuf + readBufSize:
; readBufBreak = readBufEnd
; readBufEnd = readBuf
;if readBufBreak:
; if readBufEnd + 64 <= readBufStart:
;  reschedule transfer at readBufEnd
;else:
; reschedule transfer at readBufEnd
	ret

;-------------------------------------------------------------------------------
;usb_error_t (usb_endpoint_t endpoint, usb_transfer_status_t status, size_t transferred, srl_device_t *data);
srl_Write_Callback:
	ld	iy,0
	add	iy,sp
;update buffer info
;writeBufStart += transferred
;if writeBufStart == writeBuf + writeBufSize:
; writeBufStart = writeBuf
;if writeBufStart == writeBufEnd:
; return
;if writeBufEnd < writeBufStart:
; reschedule transfer at writeBufStart with size writeBuf+writeBufSize-writeBufSize
;else:
; reschedule transfer at writeBufStart with size writeBufEnd - writeBufStart
	ret
