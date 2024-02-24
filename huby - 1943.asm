
	ORG	$4000


; *****************************************************************************
; * Huby beeper music engine by Shiru (shiru@mail.ru) 04'11
; * updated 99b version 11'13
; * By Shiru
; *
; * Tempo mod by Chris Cowley
; *
; * Produced by Beepola v1.08.01
; ******************************************************************************

START:       

	di
  	LD	HL, MUSICDATA
     	CALL  	HUBY_PLAY

; Only loop back to start if a key is not pressed, otherwise RETurn
;                IN    A,($FE)
;                CPL
;                AND   $1F
;                JR    Z,START
                RET

OP_INCL:        EQU   $2C

HUBY_PLAY:      LD    C,(HL)              ; Read the tempo word
                INC   HL
                LD    B,(HL)
                INC   HL
                LD    E,(HL)              ; Offset to pattern data is 
                INC   HL                  ; kept in DE always. 
                LD    D,(HL)              ; And HL = current position in song layout.

READPOS:        INC   HL
                LD    A,(HL)              ; Read the pattern number for channel 1
                INC   HL
                OR    A
                RET   Z                   ; Zero signifies the end of the song

; This code is for handling Tempo changes in the middle of a song.
; As the song data specified in Beepola (see MUSICDATA below) doesn't
; have any tempo changes, this code has been commented out to save 9
; bytes. Uncomment it if you want to use this routine to play tunes
; that contain mid-song tempo changes...
                CP    $FF                 ; $FF signifies SET TEMPO
                JR    NZ,NOT_TEMPO
                LD    C,(HL)
                INC   HL
                LD    B,(HL)
                JR    READPOS

NOT_TEMPO:      PUSH  HL                  ; Store the layout pointer
                PUSH  DE                  ; Store the pattern offset pointer
                PUSH  BC                  ; Store current tempo
                LD    L,(HL)              ; Read the pattern number for channel 2
                LD    B,2                 ; DJNZ through following code twice (1x for each channel)
CALC_ADR:       LD    H,0                 ; Multiply pattern number by 8...
                ADD   HL,HL               ; x2
                ADD   HL,HL               ; x4
                ADD   HL,HL               ; x8
                ADD   HL,DE               ; Add the offset to the pattern data
                PUSH  HL                  ; Store the address of pattern data
                LD    L,A
                DJNZ  CALC_ADR            ; Do the same thing for channel 2
                EXX
                POP   HL
                POP   DE

                LD    B,8                 ; Fixed pattern length = 8 rows
READ_ROW:       LD    A,(DE)              ; Read note for channel 1
                INC   DE                  ; inc channel 1 row pointer
                EXX
                LD    H,A
                LD    D,A
                EXX
                LD    A,(HL)              ; Read note for channel 2
                INC   HL                  ; inc channel 2 row pointer
                EXX
                LD    L,A
                LD    E,A
                CP    OP_INCL             ; If channel 1 note == $2C then play drum
                JR    Z,SET_DRUMSLIDE
                XOR   A
SET_DRUMSLIDE:  LD    (SND_SLIDE),A
                POP   BC                  ; Retrieve tempo
                PUSH  BC
                DI

SOUND_LOOP:     XOR   A
                DEC   E
                JR    NZ,SND_LOOP1
                LD    E,L
                SUB   L
SND_SLIDE:      NOP                       ; This is set to INC L for the drum sound
SND_LOOP1:      DEC   D
                JR    NZ,SND_LOOP2
                LD    D,H
                SUB   H
SND_LOOP2:      SBC   A,A
;                AND   16
;                OR    BORDER_CLR          ; Remove this line to save 2 bytes if you are happy with a black border :)


	cp	$80
	sbc 	a, a 				;4
        out 	($fe), a                             ;11
	jp 	nz, .HP1	;[10]
	in 	a, ($fe)	;[11]
	jp 	.LP1 		;[10]
.HP1:	out 	($fe), a	;[11]
	jp 	.LP1 		;[10]
.LP1:



;                OUT   ($FE),A
;READKEYB:       IN    A,($FE)
;                CPL
;                AND   $1F
;                JR    NZ,SND_LOOP3

                DEC   BC
                LD    A,B
                OR    C
                JR    NZ,SOUND_LOOP       ; 113/123 Ts

SND_LOOP3:      LD    HL,$2758            ; Set HL' for returning to BASIC
                EXX   
                EI
                JR    NZ,PATTERN_END
                DJNZ  READ_ROW
PATTERN_END:    POP   BC
                POP   DE
                POP   HL
                JR    Z,READPOS           ; No key pressed, goto next pattern
                RET                       ; Otherwise return


; ************************************************************************
; * Song data...
; ************************************************************************
BORDER_CLR:          EQU $0




; *** DATA ***
MUSICDATA:
;                DEFW  $09A0               ; Initial tempo
                DEFW  $0730               ; Initial tempo
                DEFW  PATTDATA - 8        ; Ptr to start of pattern data - 8
                DB   $01
                DB   $02
                DB   $01
                DB   $03
                DB   $01
                DB   $04
                DB   $01
                DB   $05
                DB   $06
                DB   $07
                DB   $08
                DB   $09
                DB   $0A
                DB   $01
                DB   $0B
                DB   $01
                DB   $0C
                DB   $0D
                DB   $0E
                DB   $0F
                DB   $10
                DB   $11
                DB   $12
                DB   $13
                DB   $06
                DB   $07
                DB   $08
                DB   $09
                DB   $0A
                DB   $01
                DB   $0B
                DB   $01
                DB   $0C
                DB   $0D
                DB   $0E
                DB   $0F
                DB   $10
                DB   $11
                DB   $12
                DB   $13
                DB   $06
                DB   $14
                DB   $15
                DB   $01
                DB   $06
                DB   $01
                DB   $15
                DB   $01
                DB   $16
                DB   $17
                DB   $16
                DB   $18
                DB   $19
                DB   $1A
                DB   $19
                DB   $01
                DB   $1B
                DB   $1C
                DB   $1B
                DB   $1D
                DB   $16
                DB   $14
                DB   $16
                DB   $01
                DB   $1E
                DB   $1F
                DB   $1E
                DB   $20
                DB   $19
                DB   $1F
                DB   $19
                DB   $01
                DB   $21
                DB   $22
                DB   $21
                DB   $23
                DB   $24
                DB   $25
                DB   $26
                DB   $01
                DB   $16
                DB   $17
                DB   $16
                DB   $18
                DB   $19
                DB   $1A
                DB   $19
                DB   $01
                DB   $1B
                DB   $1C
                DB   $1B
                DB   $1D
                DB   $16
                DB   $14
                DB   $16
                DB   $01
                DB   $1E
                DB   $1F
                DB   $1E
                DB   $20
                DB   $19
                DB   $1F
                DB   $19
                DB   $01
                DB   $21
                DB   $22
                DB   $21
                DB   $27
                DB   $16
                DB   $25
                DB   $28
                DB   $01
                DB   $29
                DB   $01
                DB   $06
                DB   $01
                DB   $06
                DB   $07
                DB   $08
                DB   $09
                DB   $0A
                DB   $01
                DB   $0B
                DB   $01
                DB   $0C
                DB   $0D
                DB   $0E
                DB   $0F
                DB   $10
                DB   $11
                DB   $12
                DB   $13
                DB   $06
                DB   $07
                DB   $08
                DB   $2A
                DB   $0A
                DB   $01
                DB   $0B
                DB   $01
                DB   $0C
                DB   $07
                DB   $0C
                DB   $2B
                DB   $10
                DB   $2C
                DB   $2D
                DB   $2E
                DB   $06
                DB   $14
                DB   $15
                DB   $01
                DB   $06
                DB   $01
                DB   $15
                DB   $01
                DB   $16
                DB   $17
                DB   $16
                DB   $18
                DB   $19
                DB   $1A
                DB   $19
                DB   $01
                DB   $1B
                DB   $1C
                DB   $1B
                DB   $1D
                DB   $16
                DB   $14
                DB   $16
                DB   $01
                DB   $1E
                DB   $1F
                DB   $1E
                DB   $20
                DB   $19
                DB   $1F
                DB   $19
                DB   $01
                DB   $21
                DB   $22
                DB   $21
                DB   $23
                DB   $24
                DB   $25
                DB   $26
                DB   $01
                DB   $16
                DB   $17
                DB   $16
                DB   $18
                DB   $19
                DB   $1A
                DB   $19
                DB   $01
                DB   $1B
                DB   $1C
                DB   $1B
                DB   $1D
                DB   $16
                DB   $14
                DB   $16
                DB   $01
                DB   $1E
                DB   $1F
                DB   $1E
                DB   $20
                DB   $19
                DB   $1F
                DB   $19
                DB   $01
                DB   $21
                DB   $22
                DB   $21
                DB   $27
                DB   $16
                DB   $25
                DB   $28
                DB   $01
                DB   $29
                DB   $01
                DB   $06
                DB   $01
                DB   $00                 ; End of song

PATTDATA:
                DB   $00, $00, $00, $00, $00, $00, $00, $00
                DB   $66, $00, $00, $00, $60, $00, $00, $00
                DB   $5B, $00, $00, $00, $56, $00, $00, $00
                DB   $51, $00, $00, $00, $4C, $00, $00, $00
                DB   $48, $00, $00, $00, $44, $00, $00, $00
                DB   $80, $00, $80, $00, $80, $00, $80, $00
                DB   $20, $00, $00, $00, $20, $00, $00, $00
                DB   $2C, $00, $80, $00, $2C, $00, $80, $00
                DB   $00, $00, $24, $00, $20, $00, $24, $00
                DB   $90, $00, $90, $00, $90, $00, $90, $00
                DB   $2C, $00, $90, $00, $2C, $00, $90, $00
                DB   $A1, $00, $A1, $00, $A1, $00, $A1, $00
                DB   $28, $00, $00, $00, $28, $00, $00, $00
                DB   $2C, $00, $A1, $00, $2C, $00, $A1, $00
                DB   $00, $00, $28, $00, $30, $00, $36, $00
                DB   $97, $00, $97, $00, $97, $00, $97, $00
                DB   $39, $00, $00, $40, $00, $00, $39, $00
                DB   $2C, $00, $88, $00, $88, $00, $88, $00
                DB   $39, $00, $00, $44, $00, $00, $39, $00
                DB   $19, $00, $00, $00, $00, $00, $00, $00
                DB   $80, $00, $80, $00, $80, $00, $90, $88
                DB   $40, $00, $80, $00, $80, $00, $40, $80
                DB   $33, $00, $00, $00, $00, $00, $00, $00
                DB   $00, $00, $00, $00, $30, $00, $2D, $00
                DB   $44, $00, $88, $00, $88, $00, $44, $88
                DB   $2B, $00, $00, $00, $00, $00, $00, $00
                DB   $4C, $00, $97, $00, $97, $00, $4C, $97
                DB   $26, $00, $00, $00, $00, $00, $00, $00
                DB   $00, $00, $22, $00, $20, $00, $1C, $00
                DB   $39, $00, $72, $00, $72, $00, $39, $72
                DB   $18, $00, $00, $00, $00, $00, $00, $00
                DB   $00, $00, $13, $00, $00, $00, $15, $00
                DB   $56, $00, $AB, $00, $AB, $00, $56, $AB
                DB   $1C, $00, $00, $00, $00, $00, $00, $00
                DB   $00, $00, $18, $00, $00, $00, $19, $00
                DB   $80, $00, $80, $40, $88, $00, $80, $40
                DB   $20, $00, $00, $00, $00, $00, $00, $00
                DB   $97, $00, $80, $40, $AB, $00, $80, $40
                DB   $2B, $00, $00, $00, $1C, $00, $00, $00
                DB   $40, $00, $80, $00, $40, $00, $40, $80
                DB   $80, $FF, $80, $FF, $80, $FF, $80, $FF
                DB   $1B, $00, $1C, $00, $20, $00, $24, $00
                DB   $1B, $00, $1C, $00, $20, $00, $1B, $00
                DB   $18, $00, $00, $20, $00, $00, $18, $00
                DB   $88, $00, $88, $00, $88, $00, $88, $00
                DB   $15, $00, $00, $1C, $00, $00, $15, $00

end
