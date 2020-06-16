* C- Compilation to TM Code
* Standard prelude:
  0:     LD  6,0(0) 	load maxaddress from location 0
  1:    LDA  4,0(6) 	copy gp to sp &allocating global variables(if any)
  2:     ST  0,0(0) 	clear location 0
* End of standard prelude.
* Jump to main()
* Begin output()
  9:     LD  1,1(4) 	load param into ax
 10:    OUT  1,0,0 	output using ax
 11:    LDA  4,1(4) 	pop prepare
 12:     LD  7,-1(4) 	pop return addr
* End output()
* -> function:
 13:    LDA  4,-1(4) 	push prepare
 14:     ST  5,0(4) 	push old bp
 15:    LDA  5,0(4) 	let bp == sp
 16:    LDA  4,0(4) 	allocate for local variables
* -> compound
* -> call
* -> Const
 17:    LDC  1,1(0) 	load const
* <- Const
 18:    LDA  4,-1(4) 	push prepare
 19:     ST  1,0(4) 	push parameters
 20:    LDA  1,3(7) 	store returned PC
 21:    LDA  4,-1(4) 	push prepare
 22:     ST  1,0(4) 	push returned PC
 23:    LDC  7,9(0) 	jump to function
 24:    LDA  4,1(4) 	release parameters
* <- call
* -> return
* -> Const
 25:    LDC  1,0(0) 	load const
* <- Const
 26:    LDA  4,0(5) 	let sp == bp
 27:    LDA  4,2(4) 	pop prepare
 28:     LD  5,-2(4) 	pop old bp
 29:     LD  7,-1(4) 	pop return addr
* <- return
* <- compound
* <- function
  3:    LDA  1,3(7) 	store returned PC
  4:    LDA  4,-1(4) 	push prepare
  5:     ST  1,0(4) 	push returned PC
  6:    LDC  7,13(0) 	jump to function
  7:    LDA  4,0(4) 	release local var
* End of execution.
  8:   HALT  0,0,0 	
