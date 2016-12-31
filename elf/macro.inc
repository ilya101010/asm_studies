DEBUG = 1

macro push [arg] { push arg }

macro popr [arg] { reverse pop arg }
; now we can:
; 1. push a, b, c
; 2 .pop a, b,c
; 3. PROFIT

macro pop [arg] { forward pop arg } 

macro mbp
{
	if DEBUG=1
		xchg bx, bx
	end if
}

; Procedures (inspired by http://asmworld.ru/uchebnyj-kurs/029-makrosy-proc-i-endp/)
; cdecl (!)

macro ccall proc, [arg]
{
	common argsS = 0
	pushad
	reverse push arg
	common call proc
	forward pop arg
	popad
}