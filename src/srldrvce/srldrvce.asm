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
macro compare_hl_zero?
	add	hl,de
	or	a,a
	sbc	hl,de
end macro

macro compare_hl_de?
	or	a,a
	sbc	hl,de
	add	hl,de
end macro

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

struct tmp_data
	local size
	label .: size
	length		rl 1
	descriptor	rb 18
	size := $-.
end struct

struct srl_Device
	local size
	label .: size
	dev		rl 1		; USB device
	?in		rl 1		; USB bulk in endpoint
	?out		rl 1		; USB bulk out endpoint
	type		rb 1		; Device type
	readBuf		rl 1		; Pointer to the read buffer
	readBufSize	rl 1		; Size of the read buffer
	readBufStart	rl 1		; First byte with data in the read buffer
	readBufEnd	rl 1		; Last byte with data in the read buffer
	readBufBreak	rl 1		; Last byte before the buffer "loops"
	readBufActive	rb 1		; Whether data is being read into the read buffer
	writeBuf	rl 1		; Pointer to the write buffer
	writeBufSize	rl 1		; Size of the write buffer
	writeBufStart	rl 1		; First byte with data in the write buffer
	writeBufEnd	rl 1		; Last byte with data in the write buffer
	size := $-.
end struct

; enum srl_DeviceType
virtual at 0
	SRL_UNKNOWN	rb 1		; Incompatible or non-serial device
	SRL_HOST	rb 1		; Calc is acting as a device
	SRL_CDC		rb 1		; CDC device
	SRL_FTDI	rb 1		; FTDI device
end virtual

struct setuppkt, requestType: ?, request: ?, value: ?, index: ?, length: ?
	label .: 8
	bmRequestType		db requestType
	bRequest		db request
	wValue			dw value
	wIndex			dw index
	wLength			dw length
end struct

struct descriptor
	label .: 2
	bLength			rb 1
	bDescriptorType		rb 1
end struct
struct deviceDescriptor
	label .: 18
	descriptor		descriptor
	bcdUSB			rw 1
	bDeviceClass		rb 1
	bDeviceSubClass		rb 1
	bDeviceProtocol		rb 1
	bMaxPacketSize0		rb 1
	idVendor		rw 1
	idProduct		rw 1
	bcdDevice		rw 1
	iManufacturer		rb 1
	iProduct		rb 1
	iSerialNumber		rb 1
	bNumConfigurations	rb 1
end struct
struct interfaceDescriptor
	label .: 9
	descriptor		descriptor
	bInterfaceNumber	rb 1
	bAlternateSetting	rb 1
	bNumEndpoints		rb 1
	bInterfaceClass		rb 1
	bInterfaceSubClass	rb 1
	bInterfaceProtocol	rb 1
	iInterface		rb 1
end struct
struct endpointDescriptor
	label .: 7
	descriptor		descriptor
	bEndpointAddress	rb 1
	bmAttributes		rb 1
	wMaxPacketSize		rw 1
	bInterval		rb 1
end struct

; enum usb_transfer_direction
virtual at 0
	?HOST_TO_DEVICE				rb 1 shl 7
	?DEVICE_TO_HOST				rb 1 shl 7
end virtual

virtual at 0
	USB_SUCCESS				rb 1
	USB_IGNORE				rb 1
	USB_ERROR_SYSTEM			rb 1
	USB_ERROR_INVALID_PARAM			rb 1
	USB_ERROR_SCHEDULE_FULL			rb 1
	USB_ERROR_NO_DEVICE			rb 1
	USB_ERROR_NO_MEMORY			rb 1
	USB_ERROR_NOT_SUPPORTED			rb 1
	USB_ERROR_TIMEOUT			rb 1
	USB_ERROR_FAILED			rb 1
end virtual

; enum usb_descriptor_type
virtual at 1
	?DEVICE_DESCRIPTOR			rb 1
	?CONFIGURATION_DESCRIPTOR		rb 1
	?STRING_DESCRIPTOR			rb 1
	?INTERFACE_DESCRIPTOR			rb 1
	?ENDPOINT_DESCRIPTOR			rb 1
end virtual

; enum usb_transfer_type
virtual at 0
	?CONTROL_TRANSFER			rb 1
	?ISOCHRONOUS_TRANSFER			rb 1
	?BULK_TRANSFER				rb 1
	?INTERRUPT_TRANSFER			rb 1
end virtual

;-------------------------------------------------------------------------------
;usb_error_t srl_Init(srl_device_t *srl, usb_device_t dev, void *buf, size_t size);
srl_Init:
	ld	iy,0
	add	iy,sp
	push	ix
	ld	ix,(iy + 3)
;todo: check if buffer is large enough
	ld	hl,(iy + 6)			; usb device
	compare_hl_zero
	jq	z,.err_nd
	ex	hl,de
	ld	hl,(iy + 3)
	ld	(hl),de
	push	iy				; get descriptor
	ld	bc,tmp.length			; storage for size of descriptor
	push	bc
	ld	bc,18				; size of device descriptor
	push	bc
	ld	bc,tmp.descriptor		; storage for descriptor
	push	bc
	ld	bc,0
	push	bc
	inc	bc				; USB_DEVICE_DESCRIPTOR = 1
	push	bc
	push	de
	call	usb_GetDescriptor
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	iy
	compare_hl_zero
	jq	nz,.exit			; return if error
	ld	de,18
	ld	hl,(tmp.length)
	compare_hl_de				; ensure enough bytes were fetched
	jq	nz,.err_nd
;look for CDC interfaces
;if found:
; set configuration
; set device type
;else:
; scan device list for matching FTDI device
; set configuration 0
; set device type
;find in/out endpoints
;convert endpoints to usb_endpoint_t

;some temp code to avoid the above
;assume ftdi device, config 0, endpoints in: $81 and out: $02
	push	iy
	ld	a,SRL_FTDI
	ld	(xsrl_Device.type),a
	ld	bc,0
	push	bc
	ld	bc,(xsrl_Device.dev)
	push	bc
	call	usb_GetConfigurationDescriptorTotalLength
	pop	bc
	pop	bc

	pop	iy
	push	iy
	ld	bc,tmp.length
	push	bc
	push	hl				; descriptor length
	ld	bc,(iy + 9)
	push	bc
	ld	bc,0
	push	bc
	ld	bc,CONFIGURATION_DESCRIPTOR
	push	bc
	ld	bc,(xsrl_Device.dev)
	push	bc
	call	usb_GetDescriptor
	pop	de
	pop	hl
	pop	hl
	pop	bc
	pop	hl
	pop	hl

	ld	hl,(hl)
	push	hl
	push	bc
	push	de
	call	usb_SetConfiguration
	pop	de
	pop	bc
	pop	bc

	ld	bc,$81				; get endpoint
	push	bc
	push	de
	call	usb_GetDeviceEndpoint
	pop	de
	pop	bc
	ld	(xsrl_Device.in),hl

	ld	bc,$02				; get endpoint
	push	bc
	ld	de,(xsrl_Device.dev)
	push	de
	call	usb_GetDeviceEndpoint
	pop	bc
	pop	bc
	ld	(xsrl_Device.out),hl
	pop	iy
;end temp code

	ld	hl,(iy + 9)			; set read buffer pointer, start, and end
	ld	(xsrl_Device.readBuf),hl
	ld	(xsrl_Device.readBufStart),hl
	ld	(xsrl_Device.readBufEnd),hl
	ld	de,(iy + 12)			; set buffer sizes to size/2
	ld	(xsrl_Device.readBufSize),de
	srl	(xsrl_Device.readBufSize)
	rr	(xsrl_Device.readBufSize+1)
	rr	(xsrl_Device.readBufSize+2)
	ld	de,(xsrl_Device.readBufSize)
	ld	(xsrl_Device.writeBufSize),de
	xor	a,a				; set write buffer pointer, start, and end
	adc	hl,de
	ld	(xsrl_Device.writeBuf),hl
	ld	(xsrl_Device.writeBufStart),hl
	ld	(xsrl_Device.writeBufEnd),hl
	ld	hl,0				; set read buffer break to 0
	ld	(xsrl_Device.readBufBreak),hl
;start async read
	ld	a,1				; mark read buffer as active
	ld	(xsrl_Device.readBufActive),a
	ld	hl,USB_SUCCESS
.exit:
	pop	ix
	ret
.err_nd:
	ld	hl,USB_ERROR_NO_DEVICE
	jq	.exit

;-------------------------------------------------------------------------------
;usb_error_t srl_SetRate(srl_device_t *srl, uint24_t rate);
srl_SetRate:
	ld	iy,0
	add	iy,sp
	push	ix
	ld	ix,(iy + 3)
	ld	a,SRL_UNKNOWN			; check device type
	cp	a,(xsrl_Device.type)
	jq	z,.exit
	inc	a
	cp	a,(xsrl_Device.type)
	jq	z,.exit
	inc	a
	cp	a,(xsrl_Device.type)
	jq	z,.cdc
	inc	a
	cp	a,(xsrl_Device.type)
	jq	z,.ftdi
	jq	.exit
.cdc:						; if a CDC device:
	ld	hl,(iy + 6)			; change the rate of the default line coding
	ld	(defaultlinecoding),hl
	ld	de,defaultlinecoding
	ld	hl,setup.setlinecoding
	jq	.sendctrl
.ftdi:						; if a FTDI device:
;todo: convert the rate to whatever completely arbitrary format FTDI uses
	ld	hl,setup.ftdisetrate
	jq	.sendctrl

.sendctrl:	;de: data, hl: request
	ld	bc,0				; don't need transfer length
	push	bc
	ld	bc,50				; number of retries
	push	bc
	push	de
	push	hl
	ld	bc,0				; get endpoint
	push	bc
	ld	hl,(iy + 3)			; get usb_device_t
	ld	bc,(hl)
	push	bc
	call	usb_GetDeviceEndpoint
	pop	bc
	pop	bc
	push	hl
	call	usb_ControlTransfer		; send control request
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	jq	.exit				; return error, if any
.exit:
	pop	ix
	ret

;-------------------------------------------------------------------------------
;size_t srl_Available(srl_device_t *srl);
srl_Available:
	ld	iy,0
	add	iy,sp
	push	ix
	ld	ix,(iy + 3)
;if readBufBreak == 0:
; readBufEnd - readBufStart
;else:
; (readBufBreak - readBufStart) + (readBufEnd - readBuf)
	pop	ix
	ret

;-------------------------------------------------------------------------------
;size_t srl_Read(srl_device_t *srl, void *buffer, size_t length);
srl_Read:
	ld	iy,0
	add	iy,sp
	push	ix
	ld	ix,(iy + 3)
;set remaining to length
;if readBufBreak:
; if readBufStart + remaining < readBufBreak:
;  copy remaining bytes to buffer
;  readBufStart += remaining
;  skip next block
; else:
;  copy readBufBreak - readBuf bytes to buffer
;  remaining -= readBufBreak - readBuf
;  set readBufBreak to 0
;  set readBufStart to readBuf
;readBufBreak guaranteed to be 0
;if readBufStart + remaining < readBufEnd:
; copy remaining bytes to buffer + length - remaining
; readBufStart += remaining
;else:
; copy readBufEnd - readBuf bytes to buffer + length - remaining
; remaining -= readBufEnd - readBuf
; set readBufStart to readBufEnd
;if read is inactive:
; attempt to schedule async transfer
.exit:
	pop	ix
	ret

;-------------------------------------------------------------------------------
;size_t srl_Write(srl_device_t *srl, const void *buffer, size_t length);
srl_Write:
	ld	iy,0
	add	iy,sp
	push	ix
	ld	ix,(iy + 3)
	ld	de,0				; transferred = 0
	xor	a,a
	ld	bc,(xsrl_Device.writeBufStart)	; writeBufStart == writeBufEnd
	ld	hl,(xsrl_Device.writeBufEnd)
	sbc	hl,bc
	push	af
	jq	c,.wrap				; if writeBufStart > writeBufEnd
	jq	.nowrap
.nowrap:
	xor	a,a
	ld	hl,(xsrl_Device.writeBufEnd)	; if writeBufEnd + length < writeBuf + writeBufSize
	ld	bc,(iy + 9)
	add	hl,bc
	ld	bc,(xsrl_Device.writeBuf)
	sbc	hl,bc
	ld	bc,(xsrl_Device.writeBufSize)
	sbc	hl,bc
	jq	c,.space

	ld	hl,(xsrl_Device.writeBuf)	; transferred = writeBuf + writeBufSize - writeBufEnd
	ld	bc,(xsrl_Device.writeBufSize)
	add	hl,bc
	ld	bc,(xsrl_Device.writeBufEnd)
	sbc	hl,bc
	push	hl
	push	hl
	pop	bc

	ld	hl,(iy + 6);  copy transferred bytes from buffer to writeBufEnd
	ld	de,(xsrl_Device.writeBufEnd)
	ldir
	ld	hl,(xsrl_Device.writeBuf)	; writeBufEnd = writeBuf
	ld	(xsrl_Device.writeBufEnd),hl
	pop	de				; transferred = writeBuf + writeBufSize - writeBufEnd
	jq	.wrap
.wrap:
	ld	hl,(xsrl_Device.writeBufEnd)	; if writeBufEnd + length - transferred < writeBufStart:
	ld	bc,(iy + 9)
	add	hl,bc
	sbc	hl,de
	ld	bc,(xsrl_Device.writeBufStart)
	sbc	hl,bc
	jq	c,.space

	scf					; copy writeBufStart - writeBufEnd - 1 bytes from buffer + transferred to writeBufEnd
	ld	hl,(xsrl_Device.writeBufStart)
	ld	bc,(xsrl_Device.writeBufEnd)
	sbc	hl,bc
	push	hl
	push	hl
	pop	bc
	push	de
	ld	hl,(iy + 6)
	add	hl,de
	ld	de,(xsrl_Device.writeBufEnd)
	ldir
	pop	de
	pop	hl				; transferred += writeBufStart - writeBufEnd - 1
	add	hl,de
	ex	de,hl

	ld	hl,(xsrl_Device.writeBufStart)
	dec	hl
	ld	(xsrl_Device.writeBufEnd),hl	; writeBufEnd = writeBufStart - 1
	jq	.exit
.space:
	xor	a,a
	ld	hl,(iy + 9)			; copy length - transferred bytes from buffer + transferred to writeBufEnd
	sbc	hl,de
	push	hl
	pop	bc				; length - transferred
	push	bc
	ld	hl,(iy + 6)
	add	hl,de
	ld	de,(xsrl_Device.writeBufEnd)
	ldir
	pop	bc
	ld	hl,(xsrl_Device.writeBufEnd)	; writeBufEnd += length - transferred
	add	hl,bc
	ld	(xsrl_Device.writeBufEnd),hl
	ld	de,(iy + 9)			; transferred = length
.exit:
	ex	hl,de
	pop	af
	push	hl
	call	z,srl_StartAsyncWrite		; attempt to schedule async transfer if buffer was empty
	pop	hl
	pop	ix
	ret

;-------------------------------------------------------------------------------
;size_t srl_Read_Blocking(srl_device_t *srl, void *buffer, size_t length, uint24_t timeout);
;todo: rewrite
srl_Read_Blocking:
	ld	iy,0
	add	iy,sp
	push	ix
	ld	ix,(iy + 3)
	ld	bc,0				; total
.loop:
;todo: check timeout
	xor	a,a
	push	iy
	push	bc
	ld	hl,(iy + 9)
	sbc	hl,bc
	push	hl
	ld	hl,(iy + 6)
	add	hl,bc
	push	hl
	push	ix
	call	srl_Read			; srl_Read(srl, buffer + total, length - total)
	pop	de
	pop	de
	pop	de
	pop	bc
	add	hl,bc				; total += len
	push	hl
	call	usb_HandleEvents
	pop	bc
	pop	iy
	xor	a,a
	ld	hl,(iy + 9)
	sbc	hl,bc
	jq	c,.loop
	pop	ix
	ret

;-------------------------------------------------------------------------------
;size_t srl_Write_Blocking(srl_device_t *srl, const void *buffer, size_t length, uint24_t timeout);
srl_Write_Blocking:
	ld	iy,0
	add	iy,sp
	push	ix
	ld	ix,(iy + 3)
	ld	bc,0				; total
.loop:
;todo: check timeout
	xor	a,a
	push	iy
	push	bc
	ld	hl,(iy + 9)
	sbc	hl,bc
	push	hl
	ld	hl,(iy + 6)
	add	hl,bc
	push	hl
	push	ix
	call	srl_Write			; srl_Write(srl, buffer + total, length - total)
	pop	de
	pop	de
	pop	de
	pop	bc
	add	hl,bc				; total += len
	push	hl
	call	usb_HandleEvents
	pop	bc
	pop	iy
	xor	a,a
	ld	hl,(iy + 9)
	sbc	hl,bc
	jq	c,.loop
	pop	ix
	ret

;-------------------------------------------------------------------------------
;usb_error_t (usb_endpoint_t endpoint, usb_transfer_status_t status, size_t transferred, srl_device_t *data);
srl_ReadCallback:
	ld	iy,0
	add	iy,sp
	push	ix
	ld	ix,(iy + 12)
;update buffer info
;if ftdi:
; transferred -= 2
; copy data over 2 bytes
;readBufEnd += transferred
	pop	ix
	ret

;-------------------------------------------------------------------------------
;usb_error_t (usb_endpoint_t endpoint, usb_transfer_status_t status, size_t transferred, srl_device_t *data);
srl_WriteCallback:
	ld	iy,0
	add	iy,sp
	push	ix
	ld	ix,(iy + 12)
	ld	bc,(iy + 9)			; writeBufStart += transferred
	ld	hl,(xsrl_Device.writeBufStart)
	add	hl,bc
	ld	(xsrl_Device.writeBufStart),hl
	xor	a,a				; if writeBufStart == writeBuf + writeBufSize:
	ld	bc,(xsrl_Device.writeBufSize)
	sbc	hl,bc
	ld	bc,(xsrl_Device.writeBuf)
	sbc	hl,bc
	jq	nz,.norestart
	ld	(xsrl_Device.writeBufStart),bc	; writeBufStart = writeBuf
.norestart:
	xor	a,a				; if writeBufStart == writeBufEnd:
	ld	bc,(xsrl_Device.writeBufStart)
	ld	hl,(xsrl_Device.writeBufEnd)
	sbc	hl,bc
	jq	z,.exit				; don't reschedule
	call	srl_StartAsyncWrite
.exit:
	pop	ix
	ret

;-------------------------------------------------------------------------------
; ix: srl_device_t
srl_StartAsyncRead:
;check if there is room in the buffer
;if readBufBreak:
; if readBufEnd + 64 > readBufStart
;  return
;else:
; if readBufEnd + 64 > readBuf + readBufSize
;  return
;schedule a transfer with 64 bytes
	ret

;-------------------------------------------------------------------------------
; ix: srl_device_t
srl_StartAsyncWrite:
	xor	a,a
	ld	hl,(xsrl_Device.writeBufEnd)
	ld	bc,(xsrl_Device.writeBufStart)
	sbc	hl,bc				; size = writeBufEnd - writeBufStart
	ret	z				; do nothing if buffer is empty
	jq	nc,.schedule
	jq	.wrap
.wrap:
	ld	hl,(xsrl_Device.writeBuf)	; size = writeBuf + writeBufSize - writeBufStart
	ld	bc,(xsrl_Device.writeBufSize)
	add	hl,bc
	ld	bc,(xsrl_Device.writeBufStart)
	sbc	hl,bc
	jq	.schedule
.schedule:
	push	ix				; schedule a transfer
	ld	bc,srl_WriteCallback
	push	bc
	push	hl
	ld	bc,(xsrl_Device.writeBufStart)
	push	bc
	ld	bc,(xsrl_Device.out)
	push	bc
	call	usb_ScheduleTransfer
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ret

;temp
openDebug:
	scf					; open debugger
	sbc	hl,hl
	ld	(hl),2
	ret

;-------------------------------------------------------------------------------
; library data
;-------------------------------------------------------------------------------

setup.setlinecoding	setuppkt	$21,$20,0,0,7
setup.ftdisetrate	setuppkt	$40,3,$1a,0,0

defaultlinecoding:
db	$80,$25,0,0,0,0,8

tmp tmp_data
