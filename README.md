# BEDCC Binary EDitor for ComputerCraft
BEDCC - Binary EDitor for ComputerCraft. BEDCC is an editor for editing files in binary format.
![](https://i.imgur.com/iPbUYXZ.png)

Just download the **bed.lua** file and add it to your path on CC computer.
(some vim-like keybindings for navigation are present)

pastebin link - https://pastebin.com/hTag3yBE

if you want to write binary or hexadecimal number after command then use '0b' or '0x' before the number respectfully.

Usage:

    bed [option] filepath
    
	    options:
			    -v, --version ─ get the version of the program
			    -h, --help ─ get this message
			    -ob, --output-binary ─ prints all binary data without opening the main program
			    -obd, --output-binary-detail ─ prints integer, symbol equivalents and line number.
			    
default keybindings:
 - q ─ quit.
 - w ─ write to the file.
 - h ─ choose bit to the left.
 - j ─ choose next byte/line (down).
 - k ─ choose previous byte/line (up).
 - l ─ choose bit to the right.
 - f ─ flip current bit.
 - i ─ increment selected byte.
 - u ─ decrement selected byte.
 - delete ─ deletes selected byte.
 - backspace ─ deletes previous byte.
 - c ─ creates byte above.
 - C ─ creates byte below.
 - : ─ start typing a command.

commands: (if x is not an integer it's going to round down)
- :q ─ quits the program.
- :w ─ write to the file.
- :wq ─ write to the file and quit the program.
- :f ─ flip current bit
- :a x ─ adds x to the byte.
- :s x ─ subtract x from the byte.
- :m x ─ multiply the byte by x.
- :d x ─ divide byte by x.
- :ba x ─ bitwise 'and' operator.
- :bo x ─ bitwise 'or' operator.
- :bx x ─ bitwise 'xor' operator.
- :brs x ─ shift byte to the right by x.
- :bls x ─ shift byte to the shift by x.
