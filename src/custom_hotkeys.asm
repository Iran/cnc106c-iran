@HOOK	0x004A58DB		_Keyboard_Sidebar_Scroll_Up
@HOOK	0x004A58B3		_Keyboard_Sidebar_Scroll_Down
@HOOK	0x0042B6C6		_Keyboard_Process_New_Keys
@HOOK	0x0042B665 		_Keyboard_Process_Unhardcode_Spacebar

; The keyboard values of these hexadecimal can be found at
; http://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
; A-Z is mapped as ASCII code minus 20 hex
; Call Convert_To_ASCII_Or_VK function to convert, not sure if end value is ACII or VK
%define	ScrollUpKey 			0x26
%define ScrollDownKey			0x27
%define B_KEY					0x42
%define C_KEY					0x43
%define V_KEY					0x56
%define M_KEY					0x4D
%define T_KEY					0x54
%define Y_KEY					0x59
%define U_KEY					0x55
%define W_KEY					0x57
%define Z_KEY					0x5A
%define Q_KEY					0x51
%define P_KEY					0x50
%define O_KEY					0x4F
%define L_KEY					0x4C
%define K_KEY					0x4B
%define D_KEY					0x44
%define R_KEY					0x52
%define S_KEY					0x53
%define X_KEY					0x58
%define N_KEY					0x4E
%define H_KEY					0x48
%define A_KEY					0x41
%define G_KEY					0x47
%define _0_KEY					0x30
%define _1_KEY					0x31
%define _2_KEY					0x32
%define _3_KEY					0x33
%define _4_KEY					0x34
%define _5_KEY					0x35
%define _6_KEY					0x36
%define _7_KEY					0x37
%define _8_KEY					0x38
%define _9_KEY					0x39
%define SPACEBAR_KEY			0x20

%define Convert_To_ASCII_Or_VK	0x004CD07C

%macro Ret_Macro_Keyboard_Process 0
	mov     esp, ebp
	pop     ebp
	pop     edi
	pop     esi
	pop     edx
	pop     ecx
	pop     ebx
	retn
%endmacro

_Keyboard_Sidebar_Scroll_Up:
	push	eax
	
	mov		eax, [edi]
	call	Convert_To_ASCII_Or_VK
	cmp     DWORD eax, D_KEY
	
	pop		eax
	jmp		0x004A58E1
	
_Keyboard_Sidebar_Scroll_Down:
	push	eax
	
	mov		eax, [edi]
	call	Convert_To_ASCII_Or_VK
	cmp     DWORD eax, SPACEBAR_KEY
	
	pop		eax
	jmp		0x004A58B9
	
_Keyboard_Process_New_Keys:
	call    0x005C5000
	
	cmp		edx, 2
	jnz		.Dont_Minus_20
	
	sub		eax, 20h
	
	; keys 0-10 (minus 20hex)
	cmp		eax, 0x10
	jl		.Dont_Add_20
	cmp		eax, 0x19
	jg		.Dont_Add_20
	
	add		eax, 20h

.Dont_Minus_20:	
.Dont_Add_20:
	
	
	CMP		eax, W_KEY
	je		.New_Bookmark_Key1
	
	CMP		eax, R_KEY
	je		.New_Bookmark_Key2
	
	CMP		eax, T_KEY
	je		.New_Bookmark_Key3
	
	CMP		eax, Z_KEY
	je		.New_Bookmark_Key4
	
	CMP		eax, X_KEY
	je		0x0042BA8A ; Scatter units
	
	CMP		eax, H_KEY
	je		0x0042B72D ; H key code, center view on conyard
	
	CMP		eax, S_KEY
	je		0x0042B9B5 ; Stop key
	
	CMP		eax, N_KEY
	je		.Next_Unit_Key ; next unit key
	
	CMP		eax, Z_KEY
	je		0x0042B86E ; Resign key
	
	CMP		eax, A_KEY
	je		0x0042B894 ; Alliance key
	
	CMP		eax, G_KEY
	je		0x0042BB49 ; Guard key
	
	CMP		eax, C_KEY
	je		.Repair_Mode_Toggle
	
	CMP		eax, V_KEY
	je		.Sell_Mode_Toggle
	
	CMP		eax, _0_KEY
	je		.New_Team0_Key
	
	CMP		eax, _1_KEY
	je		.New_Team1_Key
	
	CMP		eax, _2_KEY
	je		.New_Team2_Key
	
	CMP		eax, _3_KEY
	je		.New_Team3_Key
	
	CMP		eax, _3_KEY
	je		.New_Team3_Key
	
	CMP		eax, _4_KEY
	je		.New_Team4_Key
	
	CMP		eax, _5_KEY
	je		.New_Team5_Key

	CMP		eax, _6_KEY
	je		.New_Team6_Key
	
	CMP		eax, _7_KEY
	je		.New_Team7_Key
	
	CMP		eax, _8_KEY
	je		.New_Team8_Key
	
	CMP		eax, _9_KEY
	je		.New_Team9_Key
	
		
	Ret_Macro_Keyboard_Process ; We return here so the original hardcoded hotkeys don't get executed (except ESC key at beginning of function)
	
.New_Bookmark_Key1:
	xor		edx, edx
	cmp		ebx, 100h
	setge	dl
	mov		eax, 0
	call    0x0042E33C
	Ret_Macro_Keyboard_Process

.New_Bookmark_Key2:
	xor		edx, edx
	cmp		ebx, 100h
	setge	dl
	mov		ebx, C_KEY
	mov		eax, 1
	call    0x0042E33C
	Ret_Macro_Keyboard_Process

.New_Bookmark_Key3:
	xor		edx, edx
	cmp		ebx, 100h
	setge	dl
	mov		ebx, V_KEY
	mov		eax, 2
	call    0x0042E33C
	Ret_Macro_Keyboard_Process
	
.New_Bookmark_Key4:
	xor		edx, edx
	cmp		ebx, 100h
	setge	dl
	mov		ebx, M_KEY
	mov		eax, 3
	call    0x0042E33C
	Ret_Macro_Keyboard_Process
	
.Repair_Mode_Toggle:
	mov     edx, 0FFFFFFFFh
	mov     eax, 0x0053DDC0 ; MouseClass Map
	call    0x00436384 ; DisplayClass::Repair_Mode_Control(int)
	Ret_Macro_Keyboard_Process
	
.Sell_Mode_Toggle:
	mov     edx, 0FFFFFFFFh
	mov     eax, 0x0053DDC0 ; MouseClass Map
	call    0x004362E4 ; DisplayClass::Sell_Mode_Control(int)
	Ret_Macro_Keyboard_Process
	
.Next_Unit_Key	
	mov		edx, 0
	jmp		0x0042B7F2
	
.New_Team0_Key:
	mov		eax, 0
	call	0x0042DFCC ; Handle_Team(int, int)
	Ret_Macro_Keyboard_Process
	
.New_Team1_Key:
	mov		eax, 1
	call	0x0042DFCC ; Handle_Team(int, int)
	Ret_Macro_Keyboard_Process
	
.New_Team2_Key:
	mov		eax, 2
	call	0x0042DFCC ; Handle_Team(int, int)
	Ret_Macro_Keyboard_Process
	
.New_Team3_Key:
	mov		eax, 3
	call	0x0042DFCC ; Handle_Team(int, int)
	Ret_Macro_Keyboard_Process
	
.New_Team4_Key:
	mov		eax, 4
	call	0x0042DFCC ; Handle_Team(int, int)
	Ret_Macro_Keyboard_Process
	
.New_Team5_Key:
	mov		eax, 5
	call	0x0042DFCC ; Handle_Team(int, int)
	Ret_Macro_Keyboard_Process
	
.New_Team6_Key:
	mov		eax, 6
	call	0x0042DFCC ; Handle_Team(int, int)
	Ret_Macro_Keyboard_Process
	
.New_Team7_Key:
	mov		eax, 7
	call	0x0042DFCC ; Handle_Team(int, int)
	Ret_Macro_Keyboard_Process
	
.New_Team8_Key:
	mov		eax, 8
	call	0x0042DFCC ; Handle_Team(int, int)
	Ret_Macro_Keyboard_Process
	
.New_Team9_Key:
	mov		eax, 9
	call	0x0042DFCC ; Handle_Team(int, int)
	Ret_Macro_Keyboard_Process
	
_Keyboard_Process_Unhardcode_Spacebar:
	jmp		0x0042B66A