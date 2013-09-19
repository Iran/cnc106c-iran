@HOOK	0x004A58DB		_Keyboard_Sidebar_Scroll_Up
@HOOK	0x004A58B3		_Keyboard_Sidebar_Scroll_Down
@HOOK	0x004A585D		_Keyboard_Sidebar_Toggle
@HOOK	0x0042B6C6		_Keyboard_Process_New_Keys
@HOOK	0x0042B665 		_Keyboard_Process_Unhardcode_Spacebar
@HOOK	0x0048EA6D 		_Load_Conquer_INI_Load_Custom_Hotkeys
@HOOK	0x004B1B01		_Unhardcode_ALT_Key
@HOOK	0x004B1B26		_Unhardcode_CTRL_Key
@HOOK	0x004B1B4B		_Unhardcode_Shift_Key

; args: <section>, <key>, <default>
%macro Conquer_INI_Get_Int 3
    MOV ebx, %3 ; default
    MOV edx, dword %2 ; key
    MOV eax, dword %1 ; section
	mov     ecx, esi
    CALL 0x00490180 ; INIClass__Get_Int
%endmacro

CellDistance dd 256

ShouldScrollDown dd 0
ShouldScrollUp dd 0
ShouldToggleSidebar dd 0

SidebarScrollUp dd 0
SidebarScrollDown dd 0
SidebarToggle dd 0 
Bookmark1 dd 0
Bookmark2 dd 0
Bookmark3 dd 0
Bookmark4 dd 0
ScatterUnits dd 0
CenterBase dd 0
StopAction dd 0
NextUnit dd 0
Resign dd 0
Alliance dd 0
Guard dd 0
RepairModeToggle dd 0
SellModeToggle dd 0
Team10 dd 0
Team1 dd 0
Team2 dd 0
Team3 dd 0
Team4 dd 0
Team5 dd 0
Team6 dd 0
Team7 dd 0
Team8 dd 0
Team9 dd 0
ForceMove1 dd 0
ForceMove2 dd 0
ForceAttack1 dd 0
ForceAttack2 dd 0
Select1 dd 0
Select2 dd 0
ScrollLeft dd 0
ScrollDown dd 0
ScrollUp dd 0
ScrollRight dd 0

; The keyboard values of these hexadecimal can be found at
; http://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
; A-Z is mapped as ASCII code minus 20 hex
; Call Convert_To_ASCII_Or_VK function to convert, not sure if end value is ACII or VK
%define TAB_KEY					0x8
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
%define F7_KEY					0x76
%define F8_KEY					0x77
%define F9_KEY					0x78
%define F10_KEY					0x79
%define F11_KEY					0x7A
%define F12_KEY					0x7B
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

; Use a global variable set in Keyboard_process to prevent issue with chatting
_Keyboard_Sidebar_Toggle:
	cmp		DWORD [ShouldToggleSidebar], 1
	mov		DWORD [ShouldToggleSidebar], 0
	jmp		0x004A5863

; Use a global variable set in Keyboard_process to prevent issue with chatting
_Keyboard_Sidebar_Scroll_Up:
	cmp		DWORD [ShouldScrollUp], 1
	mov		DWORD [ShouldScrollUp], 0
	jmp		0x004A58E1

; Use a global variable set in Keyboard_process to prevent issue with chatting
_Keyboard_Sidebar_Scroll_Down:
	cmp		DWORD [ShouldScrollDown], 1
	mov		DWORD [ShouldScrollDown], 0
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

	cmp		eax, 0x0
	je		.Ret_Custom

	CMP		eax, DWORD [SidebarToggle]
	je		.Scroll_Toggle_Sidebar
	
	CMP		eax, DWORD [SidebarScrollUp]
	je		.Scroll_Sidebar_Up
	
	CMP		eax, DWORD [SidebarScrollDown]
	je		.Scroll_Sidebar_Down
	
	CMP		eax, DWORD [Bookmark1]
	je		.New_Bookmark_Key1
	
	CMP		eax, DWORD [Bookmark2]
	je		.New_Bookmark_Key2
	
	CMP		eax, DWORD [Bookmark3]
	je		.New_Bookmark_Key3
	
	CMP		eax, DWORD [Bookmark4]
	je		.New_Bookmark_Key4
	
	CMP		eax, DWORD [ScatterUnits]
	je		0x0042BA8A ; Scatter units
	
	CMP		eax, DWORD [CenterBase]
	je		0x0042B72D ; H key code, center view on conyard
	
	CMP		eax, DWORD [StopAction]
	je		0x0042B9B5 ; Stop key
	
	CMP		eax, DWORD [NextUnit]
	je		.Next_Unit_Key ; next unit key
	
	CMP		eax, DWORD [Resign]
	je		0x0042B86E ; Resign key
	
	CMP		eax, DWORD [Alliance]
	je		0x0042B894 ; Alliance key
	
	CMP		eax, DWORD [Guard]
	je		0x0042BB49 ; Guard key
	
	CMP		eax, DWORD [RepairModeToggle]
	je		.Repair_Mode_Toggle
	
	CMP		eax, DWORD [SellModeToggle]
	je		.Sell_Mode_Toggle
	
	CMP		eax, DWORD [Team10]
	je		.New_Team0_Key
	
	CMP		eax, DWORD [Team1]
	je		.New_Team1_Key
	
	CMP		eax, DWORD [Team2]
	je		.New_Team2_Key
	
	CMP		eax, DWORD [Team3]
	je		.New_Team3_Key
	
	CMP		eax, DWORD [Team4]
	je		.New_Team4_Key
	
	CMP		eax, DWORD [Team5]
	je		.New_Team5_Key

	CMP		eax, DWORD [Team6]
	je		.New_Team6_Key
	
	CMP		eax, DWORD [Team7]
	je		.New_Team7_Key
	
	CMP		eax, DWORD [Team8]
	je		.New_Team8_Key
	
	CMP		eax, DWORD [Team9]
	je		.New_Team9_Key
	
	CMP		eax, DWORD [ScrollLeft]
	je		.Scroll_Left_Key
	
	CMP		eax, DWORD [ScrollRight]
	je		.Scroll_Right_Key
	
	CMP		eax, DWORD [ScrollUp]
	je		.Scroll_Up_Key
	
	CMP		eax, DWORD [ScrollDown]
	je		.Scroll_Down_Key
	
.Ret_Custom:
	; We return here so the original hardcoded hotkeys don't 
	; get executed (except ESC key at beginning of function)
	Ret_Macro_Keyboard_Process 
	
.Scroll_Left_Key:
	mov     ecx, 1
	mov		DWORD [CellDistance], 256
	lea     ebx, [CellDistance]
	mov     edx, 0C0h
	mov     eax, 0x0053DDC0 ; offset MouseClass Map
	call    0x00449C2C ; HelpClass::Scroll_Map(DirType,int &,int)
	Ret_Macro_Keyboard_Process
	
	
.Scroll_Right_Key:
	mov     ecx, 1
	mov		DWORD [CellDistance], 256	
	lea     ebx, [CellDistance]
	mov     edx, 040h
	mov     eax, 0x0053DDC0 ; offset MouseClass Map
	call    0x00449C2C ; HelpClass::Scroll_Map(DirType,int &,int)
	Ret_Macro_Keyboard_Process
	
.Scroll_Up_Key:
	mov     ecx, 1
	mov		DWORD [CellDistance], 256
	lea     ebx, [CellDistance]
	mov     edx, 0x00
	mov     eax, 0x0053DDC0 ; offset MouseClass Map
	call    0x00449C2C ; HelpClass::Scroll_Map(DirType,int &,int)
	Ret_Macro_Keyboard_Process
	
.Scroll_Down_Key:
	mov     ecx, 1
	mov		DWORD [CellDistance], 256
	lea     ebx, [CellDistance]
	mov     edx, 0x80
	mov     eax, 0x0053DDC0 ; offset MouseClass Map
	call    0x00449C2C ; HelpClass::Scroll_Map(DirType,int &,int)
	Ret_Macro_Keyboard_Process
	
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
	
.Scroll_Sidebar_Up:
	mov		DWORD [ShouldScrollUp], 1
	Ret_Macro_Keyboard_Process

.Scroll_Sidebar_Down:
	mov		DWORD [ShouldScrollDown], 1
	Ret_Macro_Keyboard_Process

.Scroll_Toggle_Sidebar:	
	mov		DWORD [ShouldToggleSidebar], 1
	Ret_Macro_Keyboard_Process
	
_Keyboard_Process_Unhardcode_Spacebar:
	jmp		0x0042B66A
	
str_winhotkeys db "WinHotkeys",0

str_KeyScatter db "KeyScatter",0
str_KeyStop db "KeyStop",0
str_KeyGuard db "KeyGuard",0
str_KeyNext db "KeyNext",0
str_KeyBase db "KeyBase",0
str_KeyResign db "KeyResign",0
str_KeyAlliance db "KeyAlliance",0
str_KeyBookmark1 db "KeyBookmark1",0
str_KeyBookmark2 db "KeyBookmark2",0
str_KeyBookmark3 db "KeyBookmark3",0
str_KeyBookmark4 db "KeyBookmark4",0
str_KeyRepairToggle db "KeyRepairToggle",0
str_KeySellToggle db "KeySellToggle",0
str_KeySidebarUp db "KeySidebarUp",0
str_KeySidebarDown db "KeySidebarDown",0
str_KeyTeam1 db "KeyTeam1",0
str_KeyTeam2 db "KeyTeam2",0
str_KeyTeam3 db "KeyTeam3",0
str_KeyTeam4 db "KeyTeam4",0
str_KeyTeam5 db "KeyTeam5",0
str_KeyTeam6 db "KeyTeam6",0
str_KeyTeam7 db "KeyTeam7",0
str_KeyTeam8 db "KeyTeam8",0
str_KeyTeam9 db "KeyTeam9",0
str_KeyTeam10 db "KeyTeam10",0
str_KeySidebarToggle db "KeySidebarToggle",0
str_KeyForceMove1 db "KeyForceMove1",0
str_KeyForceMove2 db "KeyForceMove2",0
str_KeyForceAttack1 db "KeyForceAttack1",0
str_KeyForceAttack2 db "KeyForceAttack2",0 
str_KeySelect1 db "KeySelect1",0
str_KeySelect2 db "KeySelect2",0
str_KeyScrollLeft db "KeyScrollLeft",0
str_KeyScrollRight db "KeyScrollRight",0
str_KeyScrollUp db "KeyScrollUp",0
str_KeyScrollDown db "KeyScrollDown",0
	
_Load_Conquer_INI_Load_Custom_Hotkeys:
	pushad
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeySidebarUp, 0x26
	mov		DWORD [SidebarScrollUp], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeySidebarDown, 0x27
	mov		DWORD [SidebarScrollDown], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeySidebarToggle, TAB_KEY
	mov		DWORD [SidebarToggle], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyScatter, X_KEY
	mov		DWORD [ScatterUnits], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyStop, S_KEY
	mov		DWORD [StopAction], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyGuard, G_KEY
	mov		DWORD [Guard], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyNext, N_KEY
	mov		DWORD [NextUnit], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyBase, H_KEY
	mov		DWORD [CenterBase], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyResign, R_KEY
	mov		DWORD [Resign], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyAlliance, A_KEY
	mov		DWORD [Alliance], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyBookmark1, F7_KEY
	mov		DWORD [Bookmark1], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyBookmark2, F8_KEY
	mov		DWORD [Bookmark2], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyBookmark3, F9_KEY
	mov		DWORD [Bookmark3], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyBookmark4, F10_KEY
	mov		DWORD [Bookmark4], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyRepairToggle, T_KEY
	mov		DWORD [RepairModeToggle], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeySellToggle, Y_KEY
	mov		DWORD [SellModeToggle], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyTeam10, _0_KEY
	mov		DWORD [Team10], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyTeam1, _1_KEY
	mov		DWORD [Team1], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyTeam2, _2_KEY
	mov		DWORD [Team2], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyTeam3, _3_KEY
	mov		DWORD [Team3], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyTeam4, _4_KEY
	mov		DWORD [Team4], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyTeam5, _5_KEY
	mov		DWORD [Team5], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyTeam6, _6_KEY
	mov		DWORD [Team6], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyTeam7, _7_KEY
	mov		DWORD [Team7], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyTeam8, _8_KEY
	mov		DWORD [Team8], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyTeam9, _9_KEY
	mov		DWORD [Team9], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeySelect1, 0x10
	add		eax, 0x1000
	mov		DWORD [Select1], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeySelect2, 0x10
	add		eax, 0x1000
	mov		DWORD [Select2], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyForceMove1, 0x12
	add		eax, 0x1000
	mov		DWORD [ForceMove1], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyForceMove2, 0x12
	add		eax, 0x1000
	mov		DWORD [ForceMove2], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyForceAttack1, 0x11
	add		eax, 0x1000
	mov		DWORD [ForceAttack1], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyForceAttack2, 0x11
	add		eax, 0x1000
	mov		DWORD [ForceAttack2], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyScrollLeft, 0x0
	mov		DWORD [ScrollLeft], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyScrollRight, 0x0
	mov		DWORD [ScrollRight], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyScrollUp, 0x0
	mov		DWORD [ScrollUp], eax
	
	Conquer_INI_Get_Int		str_winhotkeys, str_KeyScrollDown, 0x0
	mov		DWORD [ScrollDown], eax
	
	mov     edx, 0x004F6470 ; offset aGamespeed ; "GameSpeed"
	popad
	jmp		0x0048EA72
	
_Unhardcode_ALT_Key:
	mov     eax, DWORD [ForceMove1]
	call    0x004CD0C0 ; TabClass::Set_Active(int)
	test    eax, eax
	jnz		0x004B1B1D
	mov     eax, DWORD [ForceMove2]
	jmp		0x0004B1B14
	
_Unhardcode_CTRL_Key:
	mov     eax, DWORD [ForceAttack1]
	call    0x004CD0C0 ; TabClass::Set_Active(int)
	test    eax, eax
	jnz		0x004B1B42
	mov     eax, DWORD [ForceAttack2]
	jmp		0x004B1B39
	
_Unhardcode_Shift_Key:
	mov     eax, DWORD [Select1]
	call    0x004CD0C0 ; TabClass::Set_Active(int)
	test    eax, eax
	jnz     0x004B1B67
	mov     eax, DWORD [Select2]
	jmp		0x004B1B5E
	