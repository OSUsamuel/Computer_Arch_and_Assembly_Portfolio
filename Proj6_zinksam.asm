TITLE Program Template     (template.asm)

; Author: Samuel Zink
; Last Modified: 12/10/2023
; OSU email address: zinksam@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  6               Due Date:   12/10/2023
; Description: Takes input of 10 string converts them to numbers, adds them to an array, converts them back to strings 
;				then displays all the numbers, total, and average

INCLUDE Irvine32.inc

; ---------------------------------------------------------------------------------------------------------------------
; Name: mDisplayString

; Displays given string

; recieves: string
; ---------------------------------------------------------------------------------------------------------------------
mDisplayString   MACRO buffer
	PUSH		EDX
	mov			EDX,  buffer
	call		WriteString
	POP			EDX

ENDM



; ---------------------------------------------------------------------------------------------------------------------
; Name: mGetString

; Displays message for getting string, calls ReadString then stores the values, then stores the length in in given argument

; Recieves: DisplaysMessage, inputBuffer, address for bytes read
; ---------------------------------------------------------------------------------------------------------------------
mGetString MACRO buffer, value, bRead
	mDisplayString  buffer
	mov				EDX,  value
	mov				ECX, MAX_LENGTH

	call			ReadString
	mov				[bRead], EAX

	

	


		
ENDM




; (insert constant definitions here)
MAX_LENGTH  = 32
AMOUNT = 10


.data

program_title		BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 13, 10, 0
programmer			BYTE	"Written by: Samuel Zink",0
program_instruction BYTE	"Please provide 10 signed decimal integers.", 13, 10, 0
program_description BYTE	"Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value.", 13, 10, 0
goodbye				BYTE	"Thanks for giving me your numbers!", 0


string_prompt		BYTE	"Please enter a number and I will make it a digit: ",0
error_msg			BYTE    "The string you entered was incorrect, please try again.",0
too_long			BYTE	"The string you entered was too long.",0
total_display		BYTE    "The total is: ",0
average_display		BYTE	"The Average is: ",0
user_string			BYTE     MAX_LENGTH+1  DUP(?)
output_string		BYTE	 MAX_LENGTH+1  DUP(?)
rev_string			BYTE     MAX_LENGTH+1  DUP(?)
digit_string		SDWORD	 AMOUNT		   DUP(?)
total				SDWORD	 0
space				BYTE    " ",0
bytes_read			DWORD    ?
count				BYTE	 0


.code
main PROC

; Displays programming Description
mDisplayString	OFFSET program_title
mDisplayString  OFFSET programmer
call			Crlf
call			Crlf
mDisplayString	OFFSET program_instruction
mDisplayString	OFFSET program_description
call			Crlf



mov		ECX, AMOUNT


_get_data:

; Sets up loop and index
MOV		EBX, ECX
SUB		EBX, 1
IMUL	EBX, 4
PUSH	ECX

; Prompts the user for the data, then reads the value
LEA     EAX, digit_string[EBX]
PUSH	EBX
PUSH    EAX
PUSH    OFFSET string_prompt
PUSH    OFFSET user_string
PUSH	bytes_read
call	ReadVal


;  increments total and count then loops back to _get_data
POP		EBX
MOV		EAX, digit_string[EBX]
ADD		total, EAX
ADD	    count,1
POP		ECX
LOOP	_get_data


; sets up loop counter for displaying
MOV		ECX, AMOUNT 

_print_data:
; sets up indexing and pushes ECX
MOV		EBX, ECX
SUB		EBX, 1
PUSH	ECX
IMUL	EBX, 4


; Writes the values in given digit array
PUSH	OFFSET rev_string
PUSH	OFFSET space
PUSH	OFFSET output_string
MOV     EAX, digit_string[EBX] 
PUSH    EAX
call	WriteVal
POP		ECX

LOOP	_print_data

; Display the integers, their sum, and their truncated average.
call	Crlf

; Displays the total
mDisplayString OFFSET total_display
PUSH	OFFSET rev_string
PUSH	OFFSET space
PUSH	OFFSET output_string
MOV     EAX, total
PUSH    EAX
call	WriteVal

; displays the average
call	Crlf
mDisplayString OFFSET average_display
CDQ
mov		EAX, total
cmp		EAX, 0
JL		_negative ; handles case where the average is negativw
mov		EBX, AMOUNT
IDIV	EBX



; writes the average then jumps to the end
_write_average:
	PUSH	OFFSET rev_string
	PUSH	OFFSET space
	PUSH	OFFSET output_string
	PUSH    EAX
	call	WriteVal
	JMP		_fin

; case of negative average
_negative:	
	mov			EBX, -1
	IMUL		EBX
	mov			EBX, AMOUNT
	IDIV		EBX
	mov			EBX, -1
	IMUL		EBX
	JMP			_write_average

	; displays ending message
	_fin:
		call			Crlf
		mDisplayString OFFSET goodbye

	Invoke ExitProcess,0	; exit to operating system
main ENDP


; uses the mGetString macro to get user input in form of string digits, stores value in memory 
; preconditions: mGetString must be defined
; postconditions: None
; receives: output parameter to save data
; returns: integer
ReadVal PROC
	PUSH		EBP
	MOV			EBP, ESP
	
_start:

	mGetString [EBP + 16], [EBP + 12], [EBP + 8]
	mov			ECX, [EBP + 8] ; loads the string length into ECX
	
	

	; sets up the source and destination registers 
	CLD    ; Sets the direction flag
	mov		ESI,  EDX
	mov		EDI, [EBP + 20] 
	mov		EDX, 0


	_check_loop:

		LODSB

		;	checks case if a sign is given at the start, defaults to positive
		cmp		ECX, [EBP + 8]
		JE		_checksign
	

		;	checks if ASCII value is >= 48
		_number:
		cmp		AL, 48
		JGE		_other_check
		JMP		_error


	_other_check:
		
		; This part of the code determines the tens, hundreds place etc.
		PUSH	EAX
		PUSH	ECX
		SUB		ECX, 1
		SUB		AL, 48
		cmp		ECX, 0
		JE		_ones ; Ones is a special case
		mov		EBX, 10

		_place:
			MUL		EBX
			LOOP	_place
		_ones:
		ADD		[EDI], EAX
		POP		ECX
		POP		EAX
	
			
		;	Checks if value ASCII is <= 57
		cmp		AL, 57
		JLE		_done
		JMP		_error


		; displays error message when input is invalid
	_error:
		mDisplayString  OFFSET error_msg
		call			Crlf
		pop				ebx
		push			EAX
		mov				EAX, 0
		mov				[EDI], EAX
		POP				EAX
		JMP		_start
		

		; checks for sign, pushes -1, or 1 depending on given digit
	_checksign:
		cmp		AL, 43 ; positive
		JE		_makePositive

		CMP		AL, 45 ; negative
		JE		_makeNegative


		PUSH	1
		JMP		_number

	_makeNegative:

		PUSH	-1 
		JMP		_done


	_makePositive:
		PUSH		1
		JMP		    _done	

		

	_done: 
		LOOP	_check_loop
		

		;  moves digit to digit array

		MOV		EAX, [EDI]
		cmp		EAX, 2147483647
		JE		_error		
		POP		EBX
		IMUL	EBX
		MOV		[EDI], EAX


	
	POP			EBP

	ret 16
ReadVal ENDP


; Converts a numeric SDWORD value to a string of ASCII digits.
; preconditions: value must be already be defined
; postconditions: None
; receives: number to be converted
; returns: None
WriteVal  PROC

	PUSH		EBP
	MOV			EBP, ESP
	
	
	MOV			EAX,	[EBP + 8]  ; number to be written
	MOV			EDI,	[EBP + 12] 



	; checks if number is negative, pushes ASCII for +/- accordingly 
	cmp			EAX, 0
	JL			_is_negative
	PUSH		43
	JMP			_done

	_is_negative:
		PUSH	45
		MOV		EBX, -1
		IMUL	EBX



	_done:
	MOV			EDX, 0
	MOV			EBX, 10
	CLD
	MOV			ECX, 1

	; gets the tens, hundres, ect.
	_get_digits:
	cdq
    IDIV		EBX
	PUSH		EAX    ; saves the value 
	MOV			AL, DL 
	ADD			AL, 48
	STOSB		

	POP			EAX
		
	;  if no more digits, write string, else go to next place
	CMP			EAX, 0
	JE			_write_string
	ADD			ECX, 1
	JMP 		_get_digits


	_write_string:

	; reverses the string
	POP		EAX
	STOSB
	ADD		ECX, 1
	mov		ESI, [EBP + 12]
	add		ESI, ECX
	dec		ESI
	mov		EDI, [EBP + 20]


	_revLoop:
		STD			
		LODSB
		CLD			
		STOSB
	LOOP	_revLoop


	; sets the null terminator
	ADD			EDI, ECX
	mov			AL, 0
	STOSB




	;display sign

	mDisplayString	[EBP + 20] ;this displays the digit
	mDisplayString  [EBP + 16] ;this displays a space



	POP			EBP
	ret 16
WriteVal  ENDP

END main
