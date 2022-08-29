.MODEL SMALL

.STACK 100H

.DATA
    ADDRESS DW ?
    i01DOT1 DW ?

.CODE
PRINTLN PROC
    ;Store Register States
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ;Divisor
    MOV BX, 10
    ;Counter
    MOV CX, 0
    ;For remainder
    MOV DX, 0

    ;Check for 0 or negative
    CMP AX, 0
    ;Print Zero
    JE PRINT_ZERO
    ;Positive Number
    JNL START_STACK
    ;Negative Number, Print the sign and Negate the number
    PUSH AX
    MOV AH, 2
    MOV DL, 2DH
    INT 21H
    POP AX
    NEG AX
    MOV DX, 0
    START_STACK:
        ;If AX=0, Start Printing
        CMP AX,0
        JE START_PRINTING
        ;AX = AX / 10
        DIV BX
        ;Remainder is Stored in DX
        PUSH DX
        INC CX
        MOV DX, 0
        JMP START_STACK
    START_PRINTING:
        MOV AH, 2
        ;Counter becoming 0 implies that the number has been printed
        CMP CX, 0
        JE DONE_PRINTING
        POP DX
        ;To get the ASCII Equivalent
        ADD DX, 30H
        INT 21H
        DEC CX
        JMP START_PRINTING
    PRINT_ZERO:
        MOV AH, 2
        MOV DX, 30H
        INT 21H
    DONE_PRINTING:
        ;Print a New Line
        MOV DL, 0AH
        INT 21H
        MOV DL, 0DH
        INT 21H
    ;Restore Register States and Return
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINTLN ENDP

MAIN PROC
    ;Initialize Data Segment
    MOV AX, @DATA
    MOV DS, AX

    ;AX = 0
    MOV AX, 0
    ;i0 = AX
    MOV i01DOT1, AX

    ;println(i0)
    MOV AX, i01DOT1
    CALL PRINTLN

    ;End of main
    MOV AH, 4CH
    INT 21H
MAIN ENDP
    END MAIN