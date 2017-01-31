include 'macro.inc'

extrn write
macro write src, x, y, color
{
	push esi, eax, ebx, edx
	mov esi, src
	mov eax, x
	mov ebx, y
	mov edx, color
	call write
	popr esi, eax, ebx, edx
}

extrn print
macro print src, y, color
{
	push esi, ebx, edx
	mov esi, src
	mov ebx, y
	mov edx, color
	call print
	popr esi, ebx, edx
}

extrn itoa
extrn itoah
extrn fill_zeros

extrn hex_f
macro hex_f n, dst
{
	push eax, edi
	mov eax, n
	mov edi, dst
	call hex_f
	popr eax, edi
}