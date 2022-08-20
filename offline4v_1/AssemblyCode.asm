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

f PROC
    ;Save Address
    POP ADDRESS

    ;Get Function Parameters
    POP a1DOT1
    ;AX = 5
    MOV AX, 5
    ;k = AX
    MOV k1DOT1, AX

    ;while()
L3:
    ;k1DOT1>0
    MOV AX, k1DOT1
    MOV DX, 0
    CMP AX, DX
    JG L1
    MOV AX, 0
    JMP L2
L1:
    MOV AX, 1
L2:
    MOV T1, AX

    MOV AX, T1
    CMP AX, 0
    JE L4
    ;Variable INCOP
    MOV AX, a1DOT1
    MOV T2, AX
    INC a1DOT1

    ;Variable DECOP
    MOV AX, k1DOT1
    MOV T3, AX
    DEC k1DOT1

    JMP L3

L4:
    ;3*a1DOT1
    MOV AX, 3
    MOV DX, a1DOT1
    IMUL DX
    MOV T4, AX

    ;T4-7
    MOV AX, T4
    MOV DX, 7
    SUB AX, DX
    MOV T5, AX

    ;Push Return Value
    PUSH T5
    PUSH ADDRESS
    RET
f ENDP

g PROC
    ;Save Address
    POP ADDRESS

    ;Get Function Parameters
    POP b1DOT2
    POP a1DOT2
    ;f(a)
    PUSH ADDRESS
    PUSH a1DOT2
    CALL f

    ;Restore Address & Store The Return Value
    POP T6
    POP ADDRESS

    ;T6+a1DOT2
    MOV AX, a1DOT2
    MOV DX, T6
    ADD AX, DX
    MOV T7, AX

    ;T7+b1DOT2
    MOV AX, b1DOT2
    MOV DX, T7
    ADD AX, DX
    MOV T8, AX

    ;AX = T8
    MOV AX, T8
    ;x = AX
    MOV x1DOT2, AX

    ;for loop
    ;AX = 0
    MOV AX, 0
    ;i = AX
    MOV i1DOT2, AX

L11:
    ;i1DOT2<7
    MOV AX, i1DOT2
    MOV DX, 7
    CMP AX, DX
    JL L5
    MOV AX, 0
    JMP L6
L5:
    MOV AX, 1
L6:
    MOV T9, AX

    MOV AX, T9
    CMP AX, 0
    JE L12
    ;i1DOT2%3
    MOV DX, 0
    MOV AX, i1DOT2
    CWD
    MOV CX, 3
    IDIV CX
    MOV T11, DX

    ;T11==0
    MOV AX, T11
    MOV DX, 0
    CMP AX, DX
    JE L7
    MOV AX, 0
    JMP L8
L7:
    MOV AX, 1
L8:
    MOV T12, AX

    ;if(i%3==0)...else...
    MOV AX, T12
    CMP AX, 0
    JE L9
    ;x1DOT2+5
    MOV AX, 5
    MOV DX, x1DOT2
    ADD AX, DX
    MOV T13, AX

    ;AX = T13
    MOV AX, T13
    ;x = AX
    MOV x1DOT2, AX

    JMP L10

L9:
    ;x1DOT2-1
    MOV AX, x1DOT2
    MOV DX, 1
    SUB AX, DX
    MOV T14, AX

    ;AX = T14
    MOV AX, T14
    ;x = AX
    MOV x1DOT2, AX

L10:
    ;Variable INCOP
    MOV AX, i1DOT2
    MOV T10, AX
    INC i1DOT2

    JMP L11

L12:
    ;Push Return Value
    PUSH x1DOT2
    PUSH ADDRESS
    RET
g ENDP

MAIN PROC
    ;Initialize Data Segment
    MOV AX, @DATA
    MOV DS, AX

    ;AX = 1
    MOV AX, 1
    ;a = AX
    MOV a1DOT3, AX

    ;AX = 2
    MOV AX, 2
    ;b = AX
    MOV b1DOT3, AX

    ;g(a, b)
    PUSH ADDRESS
    PUSH a1DOT3
    PUSH b1DOT3
    CALL g

    ;Restore Address & Store The Return Value
    POP T15
    POP ADDRESS

    ;AX = T15
    MOV AX, T15
    ;a = AX
    MOV a1DOT3, AX

    ;println(a)
    MOV AX, a1DOT3
    CALL PRINTLN

    ;for loop
    ;AX = 0
    MOV AX, 0
    ;i = AX
    MOV i1DOT3, AX

L19:
    ;i1DOT3<4
    MOV AX, i1DOT3
    MOV DX, 4
    CMP AX, DX
    JL L13
    MOV AX, 0
    JMP L14
L13:
    MOV AX, 1
L14:
    MOV T16, AX

    MOV AX, T16
    CMP AX, 0
    JE L20
    ;AX = 3
    MOV AX, 3
    ;a = AX
    MOV a1DOT3, AX

    ;while()
L17:
    ;a1DOT3>0
    MOV AX, a1DOT3
    MOV DX, 0
    CMP AX, DX
    JG L15
    MOV AX, 0
    JMP L16
L15:
    MOV AX, 1
L16:
    MOV T18, AX

    MOV AX, T18
    CMP AX, 0
    JE L18
    ;Variable INCOP
    MOV AX, b1DOT3
    MOV T19, AX
    INC b1DOT3

    ;Variable DECOP
    MOV AX, a1DOT3
    MOV T20, AX
    DEC a1DOT3

    JMP L17

L18:
    ;Variable INCOP
    MOV AX, i1DOT3
    MOV T17, AX
    INC i1DOT3

    JMP L19

L20:
    ;println(a)
    MOV AX, a1DOT3
    CALL PRINTLN

    ;println(b)
    MOV AX, b1DOT3
    CALL PRINTLN

    ;println(i)
    MOV AX, i1DOT3
    CALL PRINTLN

    ;End of main
    MOV AH, 4CH
    INT 21H
MAIN ENDP
    END MAIN