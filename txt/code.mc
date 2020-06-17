* miniC- Compilation to MC Code
* Standard prelude:
  0:     LD  6,0(0) 	load maxaddress from location 0
  1:    LDA  4,0(6) 	copy gp to sp &allocating global variables(if any)
  2:     ST  0,0(0) 	clear location 0
* End of standard prelude.
* Jump to main()
* Begin input()
  9:     IN  1,0,0 	read input into ax
 10:    LDA  4,1(4) 	pop prepare
 11:     LD  7,-1(4) 	pop return addr
* End input()
* Begin output()
 12:     LD  1,1(4) 	load param into ax
 13:    OUT  1,0,0 	output using ax
 14:    LDA  4,1(4) 	pop prepare
 15:     LD  7,-1(4) 	pop return addr
* End output()
* -> function:
 16:    LDA  4,-1(4) 	push prepare
 17:     ST  5,0(4) 	push old bp
 18:    LDA  5,0(4) 	let bp == sp
 19:    LDA  4,0(4) 	allocate for local variables
* -> compound
* -> return
 20:    LDA  4,0(5) 	let sp == bp
 21:    LDA  4,2(4) 	pop prepare
 22:     LD  5,-2(4) 	pop old bp
 23:     LD  7,-1(4) 	pop return addr
* <- return
* <- compound
 24:    LDA  4,0(5) 	let sp == bp
 25:    LDA  4,2(4) 	pop prepare
 26:     LD  5,-2(4) 	pop old bp
 27:     LD  7,-1(4) 	pop return addr
* <- function
* -> function:
 28:    LDA  4,-1(4) 	push prepare
 29:     ST  5,0(4) 	push old bp
 30:    LDA  5,0(4) 	let bp == sp
 31:    LDA  4,0(4) 	allocate for local variables
* -> compound
* -> if
* -> Op
* -> Id
 32:    LDA  2,3(5) 	get param variable address
 33:     LD  1,0(2) 	get variable value
* <- Id
 34:    LDA  4,-1(4) 	push prepare
 35:     ST  1,0(4) 	op: protect left
* -> Const
 36:    LDC  1,0(0) 	load const
* <- Const
 37:    LDA  4,1(4) 	pop prepare
 38:     LD  2,-1(4) 	op: recover left
 39:    SUB  1,2,1 	op ==
 40:    JEQ  1,2(7) 	br if true
 41:    LDC  1,0(0) 	false case
 42:    LDA  7,1(7) 	unconditional jmp
 43:    LDC  1,1(0) 	true case
* <- Op
* if: jump to else belongs here
* -> return
* -> Id
 45:    LDA  2,2(5) 	get param variable address
 46:     LD  1,0(2) 	get variable value
* <- Id
 47:    LDA  4,0(5) 	let sp == bp
 48:    LDA  4,2(4) 	pop prepare
 49:     LD  5,-2(4) 	pop old bp
 50:     LD  7,-1(4) 	pop return addr
* <- return
* if: jump to end belongs here
 44:    JEQ  1,7(7) 	if: jmp to else
* -> return
* -> call
* -> Op
* -> Id
 52:    LDA  2,2(5) 	get param variable address
 53:     LD  1,0(2) 	get variable value
* <- Id
 54:    LDA  4,-1(4) 	push prepare
 55:     ST  1,0(4) 	op: protect left
* -> Op
* -> Op
* -> Id
 56:    LDA  2,2(5) 	get param variable address
 57:     LD  1,0(2) 	get variable value
* <- Id
 58:    LDA  4,-1(4) 	push prepare
 59:     ST  1,0(4) 	op: protect left
* -> Id
 60:    LDA  2,3(5) 	get param variable address
 61:     LD  1,0(2) 	get variable value
* <- Id
 62:    LDA  4,1(4) 	pop prepare
 63:     LD  2,-1(4) 	op: recover left
 64:    DIV  1,2,1 	op /
* <- Op
 65:    LDA  4,-1(4) 	push prepare
 66:     ST  1,0(4) 	op: protect left
* -> Id
 67:    LDA  2,3(5) 	get param variable address
 68:     LD  1,0(2) 	get variable value
* <- Id
 69:    LDA  4,1(4) 	pop prepare
 70:     LD  2,-1(4) 	op: recover left
 71:    MUL  1,2,1 	op *
* <- Op
 72:    LDA  4,1(4) 	pop prepare
 73:     LD  2,-1(4) 	op: recover left
 74:    SUB  1,2,1 	op -
* <- Op
 75:    LDA  4,-1(4) 	push prepare
 76:     ST  1,0(4) 	push parameters
* -> Id
 77:    LDA  2,3(5) 	get param variable address
 78:     LD  1,0(2) 	get variable value
* <- Id
 79:    LDA  4,-1(4) 	push prepare
 80:     ST  1,0(4) 	push parameters
 81:    LDA  1,3(7) 	store returned PC
 82:    LDA  4,-1(4) 	push prepare
 83:     ST  1,0(4) 	push returned PC
 84:    LDC  7,28(0) 	jump to function
 85:    LDA  4,2(4) 	release parameters
* <- call
 86:    LDA  4,0(5) 	let sp == bp
 87:    LDA  4,2(4) 	pop prepare
 88:     LD  5,-2(4) 	pop old bp
 89:     LD  7,-1(4) 	pop return addr
* <- return
 51:    LDA  7,38(7) 	jmp to end
* <- if
* <- compound
* <- function
* -> function:
 90:    LDA  4,-1(4) 	push prepare
 91:     ST  5,0(4) 	push old bp
 92:    LDA  5,0(4) 	let bp == sp
 93:    LDA  4,-2(4) 	allocate for local variables
* -> compound
* -> assign
* -> Id
 94:    LDA  2,-1(5) 	get local address
* <- Id
 95:    LDA  4,-1(4) 	push prepare
 96:     ST  2,0(4) 	protect bx
* -> call
 97:    LDA  1,3(7) 	store returned PC
 98:    LDA  4,-1(4) 	push prepare
 99:     ST  1,0(4) 	push returned PC
100:    LDC  7,9(0) 	jump to function
101:    LDA  4,0(4) 	release parameters
* <- call
102:    LDA  4,1(4) 	pop prepare
103:     LD  2,-1(4) 	recover bx
104:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
105:    LDA  2,-2(5) 	get local address
* <- Id
106:    LDA  4,-1(4) 	push prepare
107:     ST  2,0(4) 	protect bx
* -> call
108:    LDA  1,3(7) 	store returned PC
109:    LDA  4,-1(4) 	push prepare
110:     ST  1,0(4) 	push returned PC
111:    LDC  7,9(0) 	jump to function
112:    LDA  4,0(4) 	release parameters
* <- call
113:    LDA  4,1(4) 	pop prepare
114:     LD  2,-1(4) 	recover bx
115:     ST  1,0(2) 	assign: store
* <- assign
* -> call
* -> call
* -> Id
116:    LDA  2,-2(5) 	get local address
117:     LD  1,0(2) 	get variable value
* <- Id
118:    LDA  4,-1(4) 	push prepare
119:     ST  1,0(4) 	push parameters
* -> Id
120:    LDA  2,-1(5) 	get local address
121:     LD  1,0(2) 	get variable value
* <- Id
122:    LDA  4,-1(4) 	push prepare
123:     ST  1,0(4) 	push parameters
124:    LDA  1,3(7) 	store returned PC
125:    LDA  4,-1(4) 	push prepare
126:     ST  1,0(4) 	push returned PC
127:    LDC  7,28(0) 	jump to function
128:    LDA  4,2(4) 	release parameters
* <- call
129:    LDA  4,-1(4) 	push prepare
130:     ST  1,0(4) 	push parameters
131:    LDA  1,3(7) 	store returned PC
132:    LDA  4,-1(4) 	push prepare
133:     ST  1,0(4) 	push returned PC
134:    LDC  7,12(0) 	jump to function
135:    LDA  4,1(4) 	release parameters
* <- call
* <- compound
136:    LDA  4,0(5) 	let sp == bp
137:    LDA  4,2(4) 	pop prepare
138:     LD  5,-2(4) 	pop old bp
139:     LD  7,-1(4) 	pop return addr
* <- function
  3:    LDA  1,3(7) 	store returned PC
  4:    LDA  4,-1(4) 	push prepare
  5:     ST  1,0(4) 	push returned PC
  6:    LDC  7,90(0) 	jump to function
  7:    LDA  4,2(4) 	release local var
* End of execution.
  8:   HALT  0,0,0 	
