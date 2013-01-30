@HOOK 0x00410FA8	_Mouse_Wheel_Sidebar_Scrolling

Scrolling db 0

%define HouseClass_PlayerPtr 	0x0053E6FC
%define MouseClass_Map			0x0053DDC0

_Mouse_Wheel_Sidebar_Scrolling:
;	cmp		BYTE [mousewheelscrolling], 1
;	jnz		.out
	mov     esi, [esp+0Ch]
	cmp     esi, 20Ah               ;WM_MOUSEHWHEEL
	jnz 	.out
 
	mov     ecx, HouseClass_PlayerPtr
	test    ecx, ecx
	jz		.out
 
	mov 	cl, byte [Scrolling]
	test    cl, cl
	jnz 	.out
 
	mov 	byte [Scrolling], 1
	mov     edx, [esp+10h]
	shr     edx, 10h
	test    dx, dx
	jl		.scroll
 
	mov     ebx, 0FFFFFFFFh
	mov     edx, 1
	mov		esi, MouseClass_Map
	lea     eax, [esi+3A0h]
	call    0x004A633C      ;//StripClass::Scroll

	mov     ebx, 0FFFFFFFFh
	mov     edx, 1
	mov		esi, MouseClass_Map
	lea     eax, [esi+4EAh]
	call    0x004A633C      ;//StripClass::Scroll
	
	jmp		.done
 
;-----------------------------------------------
.scroll:
	mov     ebx, 0FFFFFFFFh
	xor		edx, edx
	mov		esi, MouseClass_Map
	lea     eax, [esi+4EAh]
	call    0x004A633C      ;//StripClass::Scroll
	
	mov     ebx, 0FFFFFFFFh
	xor		edx, edx
	mov		esi, MouseClass_Map
	lea     eax, [esi+3A0h]
	call    0x004A633C      ;//StripClass::Scroll
 
.done:
	mov   	byte [Scrolling], 0

.out:
	cmp     eax, 112h
	jb      0x00411001
	jmp		0x00410FAF