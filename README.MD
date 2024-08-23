
Jupiter Ace 1-bit music engines. ( proof-of-concept )
All credit to Shiru and Utz.

Original engines for ZX Spectrum by Shiru & Utz.
Utz modified engines to run on ZX81; and these have in turn been assembled to run on the Jupiter Ace as proof-of-concept.

Assembled to $4000 directly to a Binary file. Using emulator EightyOne, load .BIN file in as a memory block, back in the Forth prompt, type "16384 CALL" to make things go.
For real hardware, a tape header would need to be added, and a .WAV file created.

The Ace uses the same bit 4 on port $FE as the ZX SPectrum, however requires oscillating of the speaker via this means:

out ($fe),a                     ;11

	and $16 	;[7]
	jp nz,.HP	;[10]

	in a,($fe)	;[11]
	jp .LP		;[10]

.HP:	out ($fe),a	;[11]
	jp .LP		;[10]
.LP:
