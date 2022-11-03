# BEDCC Binary EDitor for ComputerCraft
Just download the **bed.lua** file and add it to your path on CC computer.
(some vim-like keybindings for navigation are present)
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
 - h ─ choose previous bit (left).
 - j ─ choose next byte/line (down).
 - k ─ choose previous byte/line (up).
 - l ─ choose next bit (right).
 - f ─ flip current bit.
 - i ─ increment selected byte.
 - u ─ decrement selected byte.
 - delete ─ deletes selected byte
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