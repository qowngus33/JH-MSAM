INCLUDE C:\Irvine32\Irvine32.inc

.data
prompt1 BYTE "Randomly generated 6 byte hexadecimal: ",0
prompt2 BYTE "Result of summing all the hexadecimal: ",0
prompt3 BYTE "Average value: ",0

array BYTE 120 DUP(?)
temp BYTE 9 DUP(0)
tempSum BYTE 9 DUP(0)
sum BYTE 10 DUP(0)
result BYTE 6 DUP(0)

.code
main PROC
	mov edx, OFFSET prompt1
	call WriteString
	call Crlf

; generating random hex and saving to the array

	mov esi, OFFSET array
	mov ecx, 20
	mov edx, 0

L1:	push ecx	
	mov ecx, 6
	mov eax, 256	; generate random number between 0-255
	mov ebx, TYPE BYTE
L2:	call RandomRange	; second loop
	mov BYTE PTR [esi], al
	inc esi
	mov eax, 256
	loop L2
	pop ecx
	loop L1

; printing out random numbers

	mov ecx, 20
	mov esi, OFFSET array 
L3: push ecx
	mov ecx, 6
	call Display_Num
	mov eax, ' '
	call WriteChar
	pop ecx
	add esi, 6
	loop L3

; Adding all the numbers in array

	mov esi, OFFSET temp
	mov edi, OFFSET tempSum
	mov ebx, OFFSET sum
	mov eax, OFFSET array
	mov ecx, 20

L4: call MOV_ARRAY_VALUE
	call EXTENDED_ADD
	call MOV_SUM_VALUE
	add eax, 6
	loop L4

; printing summation of numbers

	call Crlf
	mov edx, OFFSET prompt2
	call WriteString

	mov ecx, LENGTHOF sum
	mov esi, OFFSET sum
	call Display_Num
	call Crlf

; dividing sum with 20

	mov esi, OFFSET sum
	add esi, LENGTHOF sum
	mov ecx, LENGTHOF sum 
	add ecx, 1
	mov dl, [esi] ; bring one byte
	movzx edi, dl
	shr edi, 2 ; check only 5 bits
	shl dl, 4
	mov bh, 1 ; flag

L5:	push ecx
	mov ecx,3
	sub bh, 1
	cmp bh, 0
	jz L6
	mov ecx,8
L6:	shl dl, 1
	rcl edi, 1
	cmp edi,20
	JAE one
	jmp zero
one: sub edi,20
	stc
	call Shift_multiple
	jmp L7
zero:clc
	call Shift_multiple
L7: loop L6
	pop ecx
	sub esi, SIZE BYTE
	mov dl, [esi]
	loop L5

; printing out result
	
	mov edx, OFFSET prompt3
	call WriteString

	mov ecx, LENGTHOF result
	mov esi, OFFSET result
	call Display_Num
	call Crlf

	call WaitMsg
	Invoke ExitProcess, 0

main ENDP

;--------------------------------------------------------------
EXTENDED_ADD PROC
;
; Calculates sum of two extended integers stored
; as arrays of byte
; Receives: ESI and EDI point to the two integers,
;			EBX points to a variable that will hold the sum,
;			and ECX indicates the number of bytes to be added.
; Storage for the sum must be one byte longer than the
; input operands.
; Returns: nothing
;--------------------------------------------------------------
	pushad
	mov ecx, LENGTHOF tempSum
	clc
L0: mov al,[esi]
	adc al,[edi]
	pushfd
	mov [ebx],al
	add esi,1
	add edi,1
	add ebx,1
	popfd
	loop L0

	mov byte ptr [ebx],0
	adc byte ptr [ebx],0
	popad
	ret
EXTENDED_ADD ENDP

;--------------------------------------------------------------
MOV_ARRAY_VALUE PROC USES eax esi ecx edx
;
; Moves [eax] to [esi] (pointer to data segment value)
; Returns: nothing
;--------------------------------------------------------------
	mov ecx, 6 ; loop is repeated hexadecimal length time
L0: mov dl, [eax]
	mov [esi], dl
	inc eax
	inc esi
	loop L0
	ret
MOV_ARRAY_VALUE ENDP

;--------------------------------------------------------------
MOV_SUM_VALUE PROC USES edi ebx ecx eax
;
; Moves value of [ebx] to [edi]
; Receives ebx,edi (pointer to data segment value)
; Returns: nothing
;--------------------------------------------------------------
	mov ecx, lengthof temp
L0: mov al, [ebx]
	mov [edi], al
	inc edi
	inc ebx
	loop L0
	ret
MOV_SUM_VALUE ENDP

;--------------------------------------------------------------
Shift_multiple PROC USES esi ecx
;
; Shifts multiple bytes of 'result' array
; Uses carry flag value as a new binary to be added at the end.
; Returns: nothing
;--------------------------------------------------------------
	pushfd
	mov esi, 0
	mov ecx, LENGTHOF result
	popfd
L0: rcl result[esi], 1
	pushfd
	add esi, TYPE BYTE
	popfd
	loop L0
	ret
Shift_multiple ENDP

;--------------------------------------------------------------
Display_Num PROC
;
; Displays the value on the data segment in hexadecimal
; Receives: esi(Pointer to the value), ecx(Length of array)
; Returns: nothing
;--------------------------------------------------------------
	pushad
	add esi, ecx
	sub esi, TYPE BYTE
	mov ebx, TYPE BYTE
L0: mov al, [esi]
	call WriteHexB
	sub esi, TYPE BYTE
	loop L0
	popad
	ret
Display_Num ENDP

END main