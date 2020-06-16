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
* -> array element
 16:    LDA  2,0(6) 	get global array address
 17:    LDA  4,-1(4) 	push prepare
 18:     ST  2,0(4) 	protect array address
* -> Const
 19:    LDC  1,10(0) 	load const
* <- Const
 20:    LDA  4,1(4) 	pop prepare
 21:     LD  2,-1(4) 	recover array address
 22:    SUB  2,2,1 	get address of array element
 23:     LD  1,0(2) 	get value of array element
* <- array element
* -> function:
 24:    LDA  4,-1(4) 	push prepare
 25:     ST  5,0(4) 	push old bp
 26:    LDA  5,0(4) 	let bp == sp
 27:    LDA  4,-3(4) 	allocate for local variables
* -> compound
* -> assign
* -> Id
 28:    LDA  2,-4(5) 	get local address
* <- Id
 29:    LDA  4,-1(4) 	push prepare
 30:     ST  2,0(4) 	protect bx
* -> Id
 31:    LDA  2,2(5) 	get param variable address
 32:     LD  1,0(2) 	get variable value
* <- Id
 33:    LDA  4,1(4) 	pop prepare
 34:     LD  2,-1(4) 	recover bx
 35:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
 36:    LDA  2,-1(6) 	get global address
* <- Id
 37:    LDA  4,-1(4) 	push prepare
 38:     ST  2,0(4) 	protect bx
 39:    LDA  4,1(4) 	pop prepare
 40:     LD  2,-1(4) 	recover bx
 41:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
 42:    LDA  2,-2(5) 	get local address
* <- Id
 43:    LDA  4,-1(4) 	push prepare
 44:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
 45:    LDA  2,2(5) 	get param variable address
 46:     LD  1,0(2) 	get variable value
* <- Id
 47:    LDA  4,-1(4) 	push prepare
 48:     ST  1,0(4) 	op: protect left
* -> Const
 49:    LDC  1,1(0) 	load const
* <- Const
 50:    LDA  4,1(4) 	pop prepare
 51:     LD  2,-1(4) 	op: recover left
 52:    ADD  1,2,1 	op +
* <- Op
 53:    LDA  4,1(4) 	pop prepare
 54:     LD  2,-1(4) 	recover bx
 55:     ST  1,0(2) 	assign: store
* <- assign
* -> while
* jump here after body
* -> compound
* -> if
* -> Op
 56:    LDA  4,-1(4) 	push prepare
 57:     ST  1,0(4) 	op: protect left
* -> Id
 58:    LDA  2,-1(6) 	get global address
 59:     LD  1,0(2) 	get variable value
* <- Id
 60:    LDA  4,1(4) 	pop prepare
 61:     LD  2,-1(4) 	op: recover left
 62:    SUB  1,2,1 	op <
 63:    JLT  1,2(7) 	br if true
 64:    LDC  1,0(0) 	false case
 65:    LDA  7,1(7) 	unconditional jmp
 66:    LDC  1,1(0) 	true case
* <- Op
* if: jump to else belongs here
* -> compound
* -> assign
* -> Id
 68:    LDA  2,-1(6) 	get global address
* <- Id
 69:    LDA  4,-1(4) 	push prepare
 70:     ST  2,0(4) 	protect bx
 71:    LDA  4,1(4) 	pop prepare
 72:     LD  2,-1(4) 	recover bx
 73:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
 74:    LDA  2,-4(5) 	get local address
* <- Id
 75:    LDA  4,-1(4) 	push prepare
 76:     ST  2,0(4) 	protect bx
* -> Id
 77:    LDA  2,-2(5) 	get local address
 78:     LD  1,0(2) 	get variable value
* <- Id
 79:    LDA  4,1(4) 	pop prepare
 80:     LD  2,-1(4) 	recover bx
 81:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
* if: jump to end belongs here
 67:    JEQ  1,15(7) 	if: jmp to else
 82:    LDA  7,0(7) 	jmp to end
* <- if
* -> assign
* -> Id
 83:    LDA  2,-2(5) 	get local address
* <- Id
 84:    LDA  4,-1(4) 	push prepare
 85:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
 86:    LDA  2,-2(5) 	get local address
 87:     LD  1,0(2) 	get variable value
* <- Id
 88:    LDA  4,-1(4) 	push prepare
 89:     ST  1,0(4) 	op: protect left
* -> Const
 90:    LDC  1,1(0) 	load const
* <- Const
 91:    LDA  4,1(4) 	pop prepare
 92:     LD  2,-1(4) 	op: recover left
 93:    ADD  1,2,1 	op +
* <- Op
 94:    LDA  4,1(4) 	pop prepare
 95:     LD  2,-1(4) 	recover bx
 96:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
* jump to end if test fails
* -> Op
* -> Id
 98:    LDA  2,-2(5) 	get local address
 99:     LD  1,0(2) 	get variable value
* <- Id
100:    LDA  4,-1(4) 	push prepare
101:     ST  1,0(4) 	op: protect left
* -> Id
102:    LDA  2,3(5) 	get param variable address
103:     LD  1,0(2) 	get variable value
* <- Id
104:    LDA  4,1(4) 	pop prepare
105:     LD  2,-1(4) 	op: recover left
106:    SUB  1,2,1 	op <
107:    JLT  1,2(7) 	br if true
108:    LDC  1,0(0) 	false case
109:    LDA  7,1(7) 	unconditional jmp
110:    LDC  1,1(0) 	true case
* <- Op
111:    LDA  7,56(0) 	jump to test
 97:    JEQ  1,112(0) 	jump to end
* <- while
* -> return
* -> Id
112:    LDA  2,-4(5) 	get local address
113:     LD  1,0(2) 	get variable value
* <- Id
114:    LDA  4,0(5) 	let sp == bp
115:    LDA  4,2(4) 	pop prepare
116:     LD  5,-2(4) 	pop old bp
117:     LD  7,-1(4) 	pop return addr
* <- return
* <- compound
* <- function
* -> function:
118:    LDA  4,-1(4) 	push prepare
119:     ST  5,0(4) 	push old bp
120:    LDA  5,0(4) 	let bp == sp
121:    LDA  4,-2(4) 	allocate for local variables
* -> compound
* -> assign
* -> Id
122:    LDA  2,-2(5) 	get local address
* <- Id
123:    LDA  4,-1(4) 	push prepare
124:     ST  2,0(4) 	protect bx
* -> Id
125:    LDA  2,6(5) 	get param variable address
126:     LD  1,0(2) 	get variable value
* <- Id
127:    LDA  4,1(4) 	pop prepare
128:     LD  2,-1(4) 	recover bx
129:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
130:    LDA  4,-1(4) 	push prepare
131:     ST  2,0(4) 	protect bx
* -> Const
132:    LDC  1,0(0) 	load const
* <- Const
133:    LDA  4,1(4) 	pop prepare
134:     LD  2,-1(4) 	recover bx
135:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
136:    LDA  4,-1(4) 	push prepare
137:     ST  2,0(4) 	protect bx
* -> Const
138:    LDC  1,0(0) 	load const
* <- Const
139:    LDA  4,1(4) 	pop prepare
140:     LD  2,-1(4) 	recover bx
141:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
142:    LDA  4,-1(4) 	push prepare
143:     ST  2,0(4) 	protect bx
* -> Const
144:    LDC  1,0(0) 	load const
* <- Const
145:    LDA  4,1(4) 	pop prepare
146:     LD  2,-1(4) 	recover bx
147:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
148:    LDA  4,-1(4) 	push prepare
149:     ST  2,0(4) 	protect bx
* -> Const
150:    LDC  1,0(0) 	load const
* <- Const
151:    LDA  4,1(4) 	pop prepare
152:     LD  2,-1(4) 	recover bx
153:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
154:    LDA  4,-1(4) 	push prepare
155:     ST  2,0(4) 	protect bx
* -> Const
156:    LDC  1,0(0) 	load const
* <- Const
157:    LDA  4,1(4) 	pop prepare
158:     LD  2,-1(4) 	recover bx
159:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
160:    LDA  4,-1(4) 	push prepare
161:     ST  2,0(4) 	protect bx
* -> Const
162:    LDC  1,0(0) 	load const
* <- Const
163:    LDA  4,1(4) 	pop prepare
164:     LD  2,-1(4) 	recover bx
165:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
166:    LDA  4,-1(4) 	push prepare
167:     ST  2,0(4) 	protect bx
* -> Const
168:    LDC  1,0(0) 	load const
* <- Const
169:    LDA  4,1(4) 	pop prepare
170:     LD  2,-1(4) 	recover bx
171:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
172:    LDA  4,-1(4) 	push prepare
173:     ST  2,0(4) 	protect bx
* -> Const
174:    LDC  1,0(0) 	load const
* <- Const
175:    LDA  4,1(4) 	pop prepare
176:     LD  2,-1(4) 	recover bx
177:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
178:    LDA  4,-1(4) 	push prepare
179:     ST  2,0(4) 	protect bx
* -> Const
180:    LDC  1,0(0) 	load const
* <- Const
181:    LDA  4,1(4) 	pop prepare
182:     LD  2,-1(4) 	recover bx
183:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
184:    LDA  4,-1(4) 	push prepare
185:     ST  2,0(4) 	protect bx
* -> Const
186:    LDC  1,0(0) 	load const
* <- Const
187:    LDA  4,1(4) 	pop prepare
188:     LD  2,-1(4) 	recover bx
189:     ST  1,0(2) 	assign: store
* <- assign
* -> while
* jump here after body
* -> compound
* -> assign
* -> Id
190:    LDA  2,-3(5) 	get local address
* <- Id
191:    LDA  4,-1(4) 	push prepare
192:     ST  2,0(4) 	protect bx
* -> call
* -> Id
193:    LDA  2,7(5) 	get param variable address
194:     LD  1,0(2) 	get variable value
* <- Id
195:    LDA  4,-1(4) 	push prepare
196:     ST  1,0(4) 	push parameters
* -> Id
197:    LDA  2,-2(5) 	get local address
198:     LD  1,0(2) 	get variable value
* <- Id
199:    LDA  4,-1(4) 	push prepare
200:     ST  1,0(4) 	push parameters
* -> Id
201:    LDA  2,2(5) 	get param variable address
202:     LD  1,0(2) 	get variable value
* <- Id
203:    LDA  4,-1(4) 	push prepare
204:     ST  1,0(4) 	push parameters
205:    LDA  1,3(7) 	store returned PC
206:    LDA  4,-1(4) 	push prepare
207:     ST  1,0(4) 	push returned PC
208:    LDC  7,24(0) 	jump to function
209:    LDA  4,3(4) 	release parameters
* <- call
210:    LDA  4,1(4) 	pop prepare
211:     LD  2,-1(4) 	recover bx
212:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
213:    LDA  2,-4(5) 	get local address
* <- Id
214:    LDA  4,-1(4) 	push prepare
215:     ST  2,0(4) 	protect bx
216:    LDA  4,1(4) 	pop prepare
217:     LD  2,-1(4) 	recover bx
218:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
219:    LDA  4,-1(4) 	push prepare
220:     ST  2,0(4) 	protect bx
221:    LDA  4,1(4) 	pop prepare
222:     LD  2,-1(4) 	recover bx
223:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
224:    LDA  4,-1(4) 	push prepare
225:     ST  2,0(4) 	protect bx
* -> Id
226:    LDA  2,-4(5) 	get local address
227:     LD  1,0(2) 	get variable value
* <- Id
228:    LDA  4,1(4) 	pop prepare
229:     LD  2,-1(4) 	recover bx
230:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
231:    LDA  2,-2(5) 	get local address
* <- Id
232:    LDA  4,-1(4) 	push prepare
233:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
234:    LDA  2,-2(5) 	get local address
235:     LD  1,0(2) 	get variable value
* <- Id
236:    LDA  4,-1(4) 	push prepare
237:     ST  1,0(4) 	op: protect left
* -> Const
238:    LDC  1,1(0) 	load const
* <- Const
239:    LDA  4,1(4) 	pop prepare
240:     LD  2,-1(4) 	op: recover left
241:    ADD  1,2,1 	op +
* <- Op
242:    LDA  4,1(4) 	pop prepare
243:     LD  2,-1(4) 	recover bx
244:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
* jump to end if test fails
* -> Op
* -> Id
246:    LDA  2,-2(5) 	get local address
247:     LD  1,0(2) 	get variable value
* <- Id
248:    LDA  4,-1(4) 	push prepare
249:     ST  1,0(4) 	op: protect left
* -> Op
* -> Id
250:    LDA  2,7(5) 	get param variable address
251:     LD  1,0(2) 	get variable value
* <- Id
252:    LDA  4,-1(4) 	push prepare
253:     ST  1,0(4) 	op: protect left
* -> Const
254:    LDC  1,1(0) 	load const
* <- Const
255:    LDA  4,1(4) 	pop prepare
256:     LD  2,-1(4) 	op: recover left
257:    SUB  1,2,1 	op -
* <- Op
258:    LDA  4,1(4) 	pop prepare
259:     LD  2,-1(4) 	op: recover left
260:    SUB  1,2,1 	op <
261:    JLT  1,2(7) 	br if true
262:    LDC  1,0(0) 	false case
263:    LDA  7,1(7) 	unconditional jmp
264:    LDC  1,1(0) 	true case
* <- Op
265:    LDA  7,190(0) 	jump to test
245:    JEQ  1,266(0) 	jump to end
* <- while
* <- compound
266:    LDA  4,0(5) 	let sp == bp
267:    LDA  4,2(4) 	pop prepare
268:     LD  5,-2(4) 	pop old bp
269:     LD  7,-1(4) 	pop return addr
* <- function
* -> function:
270:    LDA  4,-1(4) 	push prepare
271:     ST  5,0(4) 	push old bp
272:    LDA  5,0(4) 	let bp == sp
273:    LDA  4,-1(4) 	allocate for local variables
* -> compound
* -> assign
* -> Id
274:    LDA  2,-1(5) 	get local address
* <- Id
275:    LDA  4,-1(4) 	push prepare
276:     ST  2,0(4) 	protect bx
* -> Const
277:    LDC  1,0(0) 	load const
* <- Const
278:    LDA  4,1(4) 	pop prepare
279:     LD  2,-1(4) 	recover bx
280:     ST  1,0(2) 	assign: store
* <- assign
* -> while
* jump here after body
* -> compound
* -> assign
281:    LDA  4,-1(4) 	push prepare
282:     ST  2,0(4) 	protect bx
* -> call
283:    LDA  1,3(7) 	store returned PC
284:    LDA  4,-1(4) 	push prepare
285:     ST  1,0(4) 	push returned PC
286:    LDC  7,9(0) 	jump to function
287:    LDA  4,0(4) 	release parameters
* <- call
288:    LDA  4,1(4) 	pop prepare
289:     LD  2,-1(4) 	recover bx
290:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
291:    LDA  2,-1(5) 	get local address
* <- Id
292:    LDA  4,-1(4) 	push prepare
293:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
294:    LDA  2,-1(5) 	get local address
295:     LD  1,0(2) 	get variable value
* <- Id
296:    LDA  4,-1(4) 	push prepare
297:     ST  1,0(4) 	op: protect left
* -> Const
298:    LDC  1,1(0) 	load const
* <- Const
299:    LDA  4,1(4) 	pop prepare
300:     LD  2,-1(4) 	op: recover left
301:    ADD  1,2,1 	op +
* <- Op
302:    LDA  4,1(4) 	pop prepare
303:     LD  2,-1(4) 	recover bx
304:     ST  1,0(2) 	assign: store
* <- assign
* -> call
* -> Const
305:    LDC  1,10(0) 	load const
* <- Const
306:    LDA  4,-1(4) 	push prepare
307:     ST  1,0(4) 	push parameters
* -> Const
308:    LDC  1,0(0) 	load const
* <- Const
309:    LDA  4,-1(4) 	push prepare
310:     ST  1,0(4) 	push parameters
* -> Id
311:    LDA  2,-1(6) 	get global address
312:     LD  1,0(2) 	get variable value
* <- Id
313:    LDA  4,-1(4) 	push prepare
314:     ST  1,0(4) 	push parameters
315:    LDA  1,3(7) 	store returned PC
316:    LDA  4,-1(4) 	push prepare
317:     ST  1,0(4) 	push returned PC
318:    LDC  7,118(0) 	jump to function
319:    LDA  4,3(4) 	release parameters
* <- call
* -> assign
* -> Id
320:    LDA  2,-1(5) 	get local address
* <- Id
321:    LDA  4,-1(4) 	push prepare
322:     ST  2,0(4) 	protect bx
* -> Const
323:    LDC  1,0(0) 	load const
* <- Const
324:    LDA  4,1(4) 	pop prepare
325:     LD  2,-1(4) 	recover bx
326:     ST  1,0(2) 	assign: store
* <- assign
* -> while
* jump here after body
* -> compound
* -> call
327:    LDA  4,-1(4) 	push prepare
328:     ST  1,0(4) 	push parameters
329:    LDA  1,3(7) 	store returned PC
330:    LDA  4,-1(4) 	push prepare
331:     ST  1,0(4) 	push returned PC
332:    LDC  7,12(0) 	jump to function
333:    LDA  4,1(4) 	release parameters
* <- call
* -> assign
* -> Id
334:    LDA  2,-1(5) 	get local address
* <- Id
335:    LDA  4,-1(4) 	push prepare
336:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
337:    LDA  2,-1(5) 	get local address
338:     LD  1,0(2) 	get variable value
* <- Id
339:    LDA  4,-1(4) 	push prepare
340:     ST  1,0(4) 	op: protect left
* -> Const
341:    LDC  1,1(0) 	load const
* <- Const
342:    LDA  4,1(4) 	pop prepare
343:     LD  2,-1(4) 	op: recover left
344:    ADD  1,2,1 	op +
* <- Op
345:    LDA  4,1(4) 	pop prepare
346:     LD  2,-1(4) 	recover bx
347:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
* jump to end if test fails
* -> Op
* -> Id
349:    LDA  2,-1(5) 	get local address
350:     LD  1,0(2) 	get variable value
* <- Id
351:    LDA  4,-1(4) 	push prepare
352:     ST  1,0(4) 	op: protect left
* -> Const
353:    LDC  1,10(0) 	load const
* <- Const
354:    LDA  4,1(4) 	pop prepare
355:     LD  2,-1(4) 	op: recover left
356:    SUB  1,2,1 	op <
357:    JLT  1,2(7) 	br if true
358:    LDC  1,0(0) 	false case
359:    LDA  7,1(7) 	unconditional jmp
360:    LDC  1,1(0) 	true case
* <- Op
361:    LDA  7,327(0) 	jump to test
348:    JEQ  1,362(0) 	jump to end
* <- while
* <- compound
* jump to end if test fails
* -> Op
* -> Id
363:    LDA  2,-1(5) 	get local address
364:     LD  1,0(2) 	get variable value
* <- Id
365:    LDA  4,-1(4) 	push prepare
366:     ST  1,0(4) 	op: protect left
* -> Const
367:    LDC  1,10(0) 	load const
* <- Const
368:    LDA  4,1(4) 	pop prepare
369:     LD  2,-1(4) 	op: recover left
370:    SUB  1,2,1 	op <
371:    JLT  1,2(7) 	br if true
372:    LDC  1,0(0) 	false case
373:    LDA  7,1(7) 	unconditional jmp
374:    LDC  1,1(0) 	true case
* <- Op
375:    LDA  7,281(0) 	jump to test
362:    JEQ  1,376(0) 	jump to end
* <- while
* <- compound
376:    LDA  4,0(5) 	let sp == bp
377:    LDA  4,2(4) 	pop prepare
378:     LD  5,-2(4) 	pop old bp
379:     LD  7,-1(4) 	pop return addr
* <- function
  3:    LDA  1,3(7) 	store returned PC
  4:    LDA  4,-1(4) 	push prepare
  5:     ST  1,0(4) 	push returned PC
  6:    LDC  7,270(0) 	jump to function
  7:    LDA  4,1(4) 	release local var
* End of execution.
  8:   HALT  0,0,0 	
