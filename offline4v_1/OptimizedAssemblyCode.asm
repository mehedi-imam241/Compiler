.MODEL SMALL
.STACK 100H
.DATA
    ADDRESS DW ?
    a1DOT1 DW ?
    k1DOT1 DW ?
    T1 DW ?
    T2 DW ?
    T3 DW ?
    T4 DW ?
    T5 DW ?
    a1DOT2 DW ?
    b1DOT2 DW ?
    x1DOT2 DW ?
    i1DOT2 DW ?
    T6 DW ?
    T7 DW ?
    T8 DW ?
    T9 DW ?
    T10 DW ?
    T11 DW ?
    T12 DW ?
    T13 DW ?
    T14 DW ?
    a1DOT3 DW ?
    b1DOT3 DW ?
    i1DOT3 DW ?
    T15 DW ?
    T16 DW ?
    T17 DW ?
    T18 DW ?
    T19 DW ?
    T20 DW ?
.CODE
PRINTLN PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV BX, 10
    MOV CX, 0
    MOV DX, 0
    CMP AX, 0
    JE PRINT_ZERO
    JNL START_STACK
    PUSH AX
    MOV AH, 2
    MOV DL, 2DH
    INT 21H
    POP AX
    NEG AX
    MOV DX, 0
    START_STACK:
        CMP AX,0
        JE START_PRINTING
        DIV BX
        PUSH DX
        INC CX
        MOV DX, 0
        JMP START_STACK
    START_PRINTING:
        MOV AH, 2
        CMP CX, 0
        JE DONE_PRINTING
        POP DX
        ADD DX, 30H
        INT 21H
        DEC CX
        JMP START_PRINTING
    PRINT_ZERO:
        MOV AH, 2
        MOV DX, 30H
        INT 21H
    DONE_PRINTING:
        MOV DL, 0AH
        INT 21H
        MOV DL, 0DH
        INT 21H
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINTLN ENDP
f PROC
    POP ADDRESS
    POP a1DOT1
    MOV AX, 5
    MOV k1DOT1, AX
L3:
    MOV AX, k1DOT1
    MOV DX, 0
    CMP AX, DX
    JG L1
    MOV AX, 0
    JMP L2
L1:
    MOV AX, 1
L2:
	; Redundant MOV optimized
    MOV T1, AX
    CMP AX, 0
    JE L4
    MOV AX, a1DOT1
    MOV T2, AX
    INC a1DOT1
    MOV AX, k1DOT1
    MOV T3, AX
    DEC k1DOT1
    JMP L3
L4:
    MOV AX, 3
    MOV DX, a1DOT1
    IMUL DX
	; Redundant MOV optimized
    MOV T4, AX
    MOV DX, 7
    SUB AX, DX
    MOV T5, AX
    PUSH T5
    PUSH ADDRESS
    RET
f ENDP
g PROC
    POP ADDRESS
    POP b1DOT2
    POP a1DOT2
    PUSH ADDRESS
    PUSH a1DOT2
    CALL f
    POP T6
    POP ADDRESS
    MOV AX, a1DOT2
    MOV DX, T6
    ADD AX, DX
    MOV T7, AX
    MOV AX, b1DOT2
    MOV DX, T7
    ADD AX, DX
	; Redundant MOV optimized
    MOV T8, AX
    MOV x1DOT2, AX
    MOV AX, 0
    MOV i1DOT2, AX
L11:
    MOV AX, i1DOT2
    MOV DX, 7
    CMP AX, DX
    JL L5
    MOV AX, 0
    JMP L6
L5:
    MOV AX, 1
L6:
	; Redundant MOV optimized
    MOV T9, AX
    CMP AX, 0
    JE L12
    MOV DX, 0
    MOV AX, i1DOT2
    CWD
    MOV CX, 3
    IDIV CX
    MOV T11, DX
    MOV AX, T11
    MOV DX, 0
    CMP AX, DX
    JE L7
    MOV AX, 0
    JMP L8
L7:
    MOV AX, 1
L8:
	; Redundant MOV optimized
    MOV T12, AX
    CMP AX, 0
    JE L9
    MOV AX, 5
    MOV DX, x1DOT2
    ADD AX, DX
	; Redundant MOV optimized
    MOV T13, AX
    MOV x1DOT2, AX
    JMP L10
L9:
    MOV AX, x1DOT2
    MOV DX, 1
    SUB AX, DX
	; Redundant MOV optimized
    MOV T14, AX
    MOV x1DOT2, AX
L10:
    MOV AX, i1DOT2
    MOV T10, AX
    INC i1DOT2
    JMP L11
L12:
    PUSH x1DOT2
    PUSH ADDRESS
    RET
g ENDP
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV AX, 1
    MOV a1DOT3, AX
    MOV AX, 2
    MOV b1DOT3, AX
    PUSH ADDRESS
    PUSH a1DOT3
    PUSH b1DOT3
    CALL g
    POP T15
    POP ADDRESS
    MOV AX, T15
	; Redundant MOV optimized
    MOV a1DOT3, AX
    CALL PRINTLN
    MOV AX, 0
    MOV i1DOT3, AX
L19:
    MOV AX, i1DOT3
    MOV DX, 4
    CMP AX, DX
    JL L13
    MOV AX, 0
    JMP L14
L13:
    MOV AX, 1
L14:
	; Redundant MOV optimized
    MOV T16, AX
    CMP AX, 0
    JE L20
    MOV AX, 3
    MOV a1DOT3, AX
L17:
    MOV AX, a1DOT3
    MOV DX, 0
    CMP AX, DX
    JG L15
    MOV AX, 0
    JMP L16
L15:
    MOV AX, 1
L16:
	; Redundant MOV optimized
    MOV T18, AX
    CMP AX, 0
    JE L18
    MOV AX, b1DOT3
    MOV T19, AX
    INC b1DOT3
    MOV AX, a1DOT3
    MOV T20, AX
    DEC a1DOT3
    JMP L17
L18:
    MOV AX, i1DOT3
    MOV T17, AX
    INC i1DOT3
    JMP L19
L20:
    MOV AX, a1DOT3
    CALL PRINTLN
    MOV AX, b1DOT3
    CALL PRINTLN
    MOV AX, i1DOT3
    CALL PRINTLN
    MOV AH, 4CH
    INT 21H
MAIN ENDP
    END MAIN