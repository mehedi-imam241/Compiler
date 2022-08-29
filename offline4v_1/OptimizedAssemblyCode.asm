.MODEL SMALL
.STACK 100H
.DATA
    ADDRESS DW ?
    i01DOT1 DW ?
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
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV AX, 0
	; Redundant MOV optimized
    MOV i01DOT1, AX
    CALL PRINTLN
    MOV AH, 4CH
    INT 21H
MAIN ENDP
    END MAIN