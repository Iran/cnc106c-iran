@HOOK 0x004A61F7	_StripClass_Activate_hires
@HOOK 0x004A620B	_StripClass_Activate_hires2
@HOOK 0x004A6227	_StripClass_Activate_hires3
@HOOK 0x004A4E19	_StripClass_fn_init_hires
@HOOK 0x004A5FFF	_StripClass_Init_IO_hires
@HOOK 0x004A6041	_StripClass_Init_IO_hires2
@HOOK 0x004A6279	_StripClass_Deactivate_hires
@HOOK 0x004A6295	_StripClass_Deactivate_hires2
@HOOK 0x004A672E	_StripClass_Draw_It_hires
@HOOK 0x004A6BA4	_StripClass_Draw_It_hires2
@HOOK 0x004A4FD3	_SidebarClass_One_TIme_Icon_Area_Size_hires
@HOOK 0x004A6407	_StripClass_AI_hires
@HOOK 0x004A644A	_StripClass_AI_hires2
@HOOK 0x004A6046	_StripClass_Init_IO_Up_Down_Buttons_hires
;@HOOK 0x004A633C	_StripClass_Scroll_hires
@HOOK 0x004A6734	_StripClass_Draw_It_hires3
@HOOK 0x004A55CB	_SidebarClass_Add_hires
@HOOK 0x0049A3E2	_Load_Game_hires
@HOOK 0x004A579D	_StripClass_Draw_It_hires4
@HOOK 0x0048FAF8	_PowerClass_Draw_It_hires
@HOOK 0x0048FBA0	_PowerClass_Draw_It_hires2
@HOOK 0x004A6D70	_StripClass_Recalc_hires

CameoItems dd 0 ; Cameo icons to draw the per strip
CurrentStripIndex dd 0 ; variable used for strip.shp drawing
CurrentStripFrame dd 0 ; variable used for strip.shp frame
CurrentStripDrawPosition dd 0 ; variable for strip.shp drawing height position
CurrentPowerBarDrawPosition dd 0 ; variable used for pwrbar.shp no power bar drawing height position
CurrentPowerBarDrawPosition2 dd 0 ; variable used for pwrbar.shp with power bar drawing height position

; These are per strip, there's a left and right strip in the sidebar
; 208 / 52 = 4 items
; 30 cameo icons times 48 is 1440 pixels plus 181 (start of icon drawing plus 27 (buttons)
; gives about 1650 vertical height to support

%define CAMEO_ITEMS 30
%define CAMEOS_SIZE	1560 ; memory size of all cameos in byte

%define StripBarAreaVerticalSize 0x005054F4
%define MouseClass_Map			0x0053DDC0

; Height of up and down buttons is 27 pixels
; Drawing of icons starts at height 181, every extra icon is 48 extra pixels
;[23:58:21] <iran> so
;[23:58:42] <iran> IngameHeight-181-27 / 48 for total amount of possible icons
%define IngameHeight 0x00541C08

ExtendedSelectButtons TIMES 824 dd 0

_PowerClass_Draw_It_hires2: ; Draw the whole powerbar graphics with power bar till bottom of screen
	mov 	ecx, [eax+64h]
;	mov		ecx, 0xB4
;	add		ecx, 64h
	mov		[CurrentPowerBarDrawPosition2], ecx
	
.Loop:
	push    0
	mov     edx, [0x50552C]
	mov     eax, [esi+338h]
	push    0
	sub     eax, edx
	push    10h
	mov     ebx, [esi+334h]
	mov     ecx, DWORD [CurrentPowerBarDrawPosition2]
;	sub		ecx, 20
	push    6
	lea     edx, [edi+3]
	mov     eax, [0x00556C78] ; ds:PowerBarShape
	call    0x0042D7DC; CC_Draw_Shape(void *,int,int,int,WindowNumberType,void *,void *,DirType,long)
	
	mov		DWORD ecx, [CurrentPowerBarDrawPosition2]
	add		DWORD [CurrentPowerBarDrawPosition2], 100	
	cmp		ecx, DWORD [IngameHeight]
	jl		.Loop
	
	mov		DWORD [CurrentPowerBarDrawPosition2], 0
	jmp		0x0048FBCC

_StripClass_Recalc_hires: ; Fix graphical glitching when selling conyard and other situations
	mov		esi, MouseClass_Map
	lea     eax, [esi+3A0h]
	call	0x004A6350 ; StripClass::Flag_To_Redraw

	mov		esi, MouseClass_Map
	lea     eax, [esi+4EAh]
	call	0x004A6350 ; StripClass::Flag_To_Redraw

	pop		ebp
	pop		edi
	pop     esi
	pop     edx
	pop     ecx
	pop     ebx
	retn

_PowerClass_Draw_It_hires: ; Draw the whole powerbar graphics without power bar till bottom of screen
	mov 	ecx, [esi+338h]
	add		ecx, 64h
	mov		[CurrentPowerBarDrawPosition], ecx
	
.Loop:
	push    0
	push    0
	mov     edx, 1
	push    10h
	mov     eax, [0x00556C78] ; ds:PowerBarShape
	push    6
	mov     ebx, [esi+334h]
	mov		ecx, DWORD [CurrentPowerBarDrawPosition]
	call    0x0042D7DC ; CC_Draw_Shape(void *,int,int,int,WindowNumberType,void *,void *,DirType,long)

	mov		DWORD ecx, [CurrentPowerBarDrawPosition]
	add		DWORD [CurrentPowerBarDrawPosition], 64h	
	cmp		ecx, DWORD [IngameHeight]
	jle		.Loop
	
	mov		DWORD [CurrentPowerBarDrawPosition], 0
	jmp		0x0048FB1E
	
_StripClass_Draw_It_hires4:
	mov		DWORD [CurrentStripDrawPosition], 114h
.Loop:
	push    0
	push    0
	push    10h
	mov		DWORD ecx, [CurrentStripDrawPosition]
	mov     eax, [0x005587E8] ; ds:void *SidebarClass::SidebarShape2
	push    0
	mov     ebx, [edi+374h]
	xor     edx, edx
	call    0x0042D7DC ; CC_Draw_Shape(void *,int,int,int,WindowNumberType,void *,void *,DirType,long)
	
	add		DWORD [CurrentStripDrawPosition], 48
	mov		DWORD ecx, [CurrentStripDrawPosition]
	cmp		ecx, DWORD [IngameHeight]
	jle		.Loop
	
	mov		DWORD [CurrentStripDrawPosition], 0
	jmp		0x004A57BC

_Load_Game_hires: ; Fix up button vertical position and visible icon area size when loading save games
	add     esp, 24Ch
	push 	eax
	
	mov		eax, [CameoItems]
	mov		edx, 48
	imul	eax, edx
	mov 	DWORD [StripBarAreaVerticalSize], eax
	
	mov DWORD ebx, [CameoItems]
	imul	ebx, 48
	add		ebx, 181
	add		ebx, 1
	mov	DWORD [0x00558560], ebx ; Up and down buttons vertical psotion
	mov	DWORD [0x00558598], ebx
	mov	DWORD [0x005585D0], ebx
	mov	DWORD [0x00558608], ebx
	
	;Scroll up cameo list to top for left sidebar if it would be glitched
	mov		eax, MouseClass_Map
	lea     eax, [eax+3A0h]
	
	mov     edx, [eax+2Ch] ; Current cameo item in sidebar
	mov     ebx, [eax+38h] ; Max cameo item in sidebar
	add     edx, [CameoItems]
	cmp     edx, ebx
	jle     .No_Cameo_list_Left_Strip_Reset
	
	mov		DWORD [eax+2Ch], 0 ; Reset it
	
.No_Cameo_list_Left_Strip_Reset:

	;Scroll up cameo list to top for right sidebar if it would be glitched
	mov		eax, MouseClass_Map
	lea     eax, [eax+4EAh]
	
	mov     edx, [eax+2Ch] ; Current cameo item in sidebar
	mov     ebx, [eax+38h] ; Max cameo item in sidebar
	add     edx, [CameoItems]
	cmp     edx, ebx
	jle     .No_Cameo_list_Right_Strip_Reset	
	
	mov		DWORD [eax+2Ch], 0 ; Reset it
	
.No_Cameo_list_Right_Strip_Reset
	
	pop		eax
	jmp		0x0049A3E8

_SidebarClass_Add_hires: ; Fix graphical glitching when new icons are added to sidebar
	mov     edx, esi
	call    0x004A62A4 ; SidebarClass::StripClass::Add(RTTIType,int)
	push	eax

	mov		esi, MouseClass_Map
	lea     eax, [esi+3A0h]
	call	0x004A6350 ; StripClass::Flag_To_Redraw

	mov		esi, MouseClass_Map
	lea     eax, [esi+4EAh]
	call	0x004A6350 ; StripClass::Flag_To_Redraw

	pop		eax
	jmp		0x004A55D2

_StripClass_Draw_It_hires3: ; Draw strip.shp background over each cameo

	mov 	DWORD [CurrentStripIndex], 0
	mov		DWORD [CurrentStripFrame], 0

.Loop:
	mov		eax, [CurrentStripIndex]
	mov		ecx, 4
	cdq                ; sign-extend EAX into EDX
	idiv	ecx
	cmp		DWORD [esi+20h], 1
	jnz		.No_Add_4
	
	add		edx, 4
	
.No_Add_4:
	mov		DWORD [CurrentStripFrame],	edx

	push    0
	push    0
	mov     eax, [0x005587D0] ; ds:void *SidebarClass::StripClass::StripShapes
	mov     ecx, [esi+1Ch]
	mov		ebx, [CurrentStripIndex]
	imul	ebx, 48
	add		ecx, ebx
	push    10h
	mov     ebx, [esi+18h]
	mov    DWORD edx, [CurrentStripFrame]
	push    0
	dec     ecx
	add     ebx, 3
	call    0x0042D7DC ; CC_Draw_Shape(void *,int,int,int,WindowNumberType,void *,void *,DirType,long)
	
	inc		DWORD [CurrentStripIndex]
	
	mov		DWORD eax, [CurrentStripIndex]
	mov		DWORD ecx, [CameoItems]
	cmp		eax, ecx
	jl		.Loop
		
	mov		DWORD [CurrentStripIndex], 0
	mov		DWORD [CurrentStripFrame], 0
	
	jmp		0x004A6753

_StripClass_Scroll_hires: ; Add the same check RA1 has, this check
; prevents scrolling backwards if current cameo item + CameoIcons > max items
; to prevent graphical glitching
	test    edx, edx
	jz      .Scroll_Back_Check
	dec     DWORD [eax+30h]
	jmp		0x004A6343

.Scroll_Back_Check:
;	mov     ebx, [eax+38h] ; Max cameo item in sidebar
;	cmp		ebx, DWORD [CameoItems]
;	jl		0x004A6345
	mov     edx, [eax+2Ch] ; Current cameo item in sidebar
	mov     ebx, [eax+38h] ; Max cameo item in sidebar
	add     edx, [CameoItems]
	cmp     edx, ebx
	jl      0x004A6345
	xor     eax, eax
	retn
	
_StripClass_Init_IO_Up_Down_Buttons_hires: ; Fix up up and down buttons vertical height
	mov DWORD ebx, [CameoItems]
	imul	ebx, 48
;	add		ebx, 27
	add		ebx, 181

	mov	DWORD [0x00558560], ebx ; Up and down buttons height
	mov	DWORD [0x00558598], ebx
	mov	DWORD [0x005585D0], ebx
	mov	DWORD [0x00558608], ebx

	pop     ebp
	pop     edi
	pop     esi
	pop     ecx
	pop     ebx
	retn
    
_StripClass_AI_hires2:
    mov     eax, [ebp+2Ch]
    add     DWORD   eax, [CameoItems]
    jmp     0x004A6450

_StripClass_AI_hires: ; Not sure what this does and if this is needed, RA1 extended sidebar also has this

;	mov     edx, [eax+2Ch] ; Current cameo item in sidebar
;	mov     ebx, [eax+38h] ; Max cameo item in sidebar

	cmp 	edi, [CameoItems]
	jg		0x004A6415
	jmp		0x004A640C

_StripClass_Activate_hires:
	imul    eax, [ecx+20h], CAMEOS_SIZE
	add		eax, ExtendedSelectButtons
	jmp		0x004A6203 
	
_StripClass_Activate_hires2:
	imul    edx, [ecx+20h], CAMEOS_SIZE
	add		edx, ExtendedSelectButtons
	jmp		0x004A6218
	
_StripClass_Activate_hires3:
	mov		edx, [CameoItems]
	imul	edx, edx, 52
	cmp     ebx, edx
	jmp		0x004A622D
	
_StripClass_fn_init_hires: ; Initialize extended invisible select buttons
	mov     edx, CAMEO_ITEMS*2 ; amount of total items to init
	mov		eax, ExtendedSelectButtons
;	mov		DWORD [0x0050AC28], ebp
	jmp		0x004A4E1E

	;[23:58:21] <iran> so
;[23:58:42] <iran> IngameHeight-181-27 / 48

_StripClass_Init_IO_hires:
	imul    eax, [ecx+20h], CAMEOS_SIZE
	add		eax, ExtendedSelectButtons
	jmp 	0x004A600B
	
_StripClass_Init_IO_hires2:
	cmp     esi, [CameoItems] ; items check
	jl     	0x004A5FFF
	jmp		0x004A6046
	 
_StripClass_Deactivate_hires:
	imul    edx, [ecx+20h], CAMEOS_SIZE
	add		edx, ExtendedSelectButtons
	jmp		0x004A6286
	
_StripClass_Deactivate_hires2:
	cmp     ebx, CAMEOS_SIZE
	jmp		0x004A629B
	
_StripClass_Draw_It_hires:
	cmp     DWORD [esi+38h], CAMEOS_SIZE
	jge     0x004A6753
	jmp		0x004A6734

_StripClass_Draw_It_hires2:
;	add     eax, CAMEO_ITEMS*2; items to draw	
	mov		DWORD edi, [CameoItems]
	imul	edi, 2
	add     eax, edi ; items to draw
	cmp     eax, ecx
	jmp		0x004A6BA9
	
_SidebarClass_One_TIme_Icon_Area_Size_hires: ; Calculate CameoItems and set StripBarAreaVerticalSize
	push	ecx
	push	edx
	push	ebx
	push	eax
	
	mov		eax, [IngameHeight]
	sub		eax, 181
	sub		eax, 27
	cdq                ; sign-extend EAX into EDX
	mov		ebx, 48
	idiv	ebx
	
	; If CameoItems would be higher than the max cameo items hardcoded to support
	; set CameoItems to CAMEO_ITEMS instead of the value we calculated
	cmp		eax, CAMEO_ITEMS
	jl		.Dont_Set_Max_Cameos
	
	mov		eax, CAMEO_ITEMS
	
.Dont_Set_Max_Cameos:	
	
	mov		DWORD [CameoItems], eax

	mov		eax, [CameoItems]
	mov		edx, 48
	imul	eax, edx
	mov 	DWORD [StripBarAreaVerticalSize], eax
	
	pop		eax
	pop		ebx
	pop		edx
	pop		ecx
	jmp		0x004A4FD8
