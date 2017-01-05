; Debugging

DEBUG = 1

macro mbp
{
	if DEBUG=1
		xchg bx, bx
	end if
}

; Stack ops

macro push [arg] { push arg }

macro popr [arg] { reverse pop arg }
; now we can:
; 1. push a, b, c
; 2 .pop a, b,c
; 3. PROFIT

macro pop [arg] { forward pop arg } 


; Procedures (inspired by http://asmworld.ru/uchebnyj-kurs/029-makrosy-proc-i-endp/)
; cdecl (!)
; no proc macro - can't use local labels there
; TODO: do a yet another proc macro?

macro ccall proc, [arg]
{
	common	argS = 0
			; pushad - let the callee do it outside
	reverse push arg
			argS = argS + 4
	common 	call proc
	common 	add esp, argS
			; popad
}