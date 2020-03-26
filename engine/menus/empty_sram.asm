EmptyAllSRAMBanks:
BANKNO  SET 0
REPT NUM_SRAM_BANKS
	ld a, BANKNO
	call .EmptyBank
BANKNO  SET BANKNO + 1
ENDR
	ret

.EmptyBank:
	call GetSRAMBank
	ld hl, SRAM_Begin
	ld bc, SRAM_End - SRAM_Begin
	xor a
	call ByteFill
	call CloseSRAM
	ret
