* miniC- Compilation to MC Code
* Standard prelude:
  0:     LD  6,0(0) 	load maxaddress from location 0
  1:     ST  0,0(0) 	clear location 0
  2:    LDA  4,0(6) 	copy gp to sp & allocating global variables(if any)
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
 19:    LDA  4,-3(4) 	allocate for local variables
* -> compound
* -> assign
* -> Id
 20:    LDA  2,-4(5) 	get local address
* <- Id
 21:    LDA  4,-1(4) 	push prepare
 22:     ST  2,0(4) 	protect bx
* -> Id
 23:    LDA  2,2(5) 	get param variable address
 24:     LD  1,0(2) 	get variable value
* <- Id
 25:    LDA  4,1(4) 	pop prepare
 26:     LD  2,-1(4) 	recover bx
 27:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
 28:    LDA  2,-3(5) 	get local address
* <- Id
 29:    LDA  4,-1(4) 	push prepare
 30:     ST  2,0(4) 	protect bx
* -> array element
 31:     LD  2,2(5) 	get param array address
 32:    LDA  4,-1(4) 	push prepare
 33:     ST  2,0(4) 	protect array address
* -> Id
 34:    LDA  2,2(5) 	get param variable address
 35:     LD  1,0(2) 	get variable value
* <- Id
 36:    LDA  4,1(4) 	pop prepare
 37:     LD  2,-1(4) 	recover array address
 38:    SUB  2,2,1 	get address of array element
 39:     LD  1,0(2) 	get value of array element
* <- array element
 40:    LDA  4,1(4) 	pop prepare
 41:     LD  2,-1(4) 	recover bx
 42:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
 43:    LDA  2,-2(5) 	get local address
* <- Id
 44:    LDA  4,-1(4) 	push prepare
 45:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
 46:    LDA  2,2(5) 	get param variable address
 47:     LD  1,0(2) 	get variable value
* <- Id
 48:    LDA  4,-1(4) 	push prepare
 49:     ST  1,0(4) 	op: protect left
* -> Const
 50:    LDC  1,1(0) 	load const
* <- Const
 51:    LDA  4,1(4) 	pop prepare
 52:     LD  2,-1(4) 	op: recover left
 53:    ADD  1,2,1 	op +
* <- Op
 54:    LDA  4,1(4) 	pop prepare
 55:     LD  2,-1(4) 	recover bx
 56:     ST  1,0(2) 	assign: store
* <- assign
* -> while
* jump here after body
* -> Op
* -> Id
 57:    LDA  2,-2(5) 	get local address
 58:     LD  1,0(2) 	get variable value
* <- Id
 59:    LDA  4,-1(4) 	push prepare
 60:     ST  1,0(4) 	op: protect left
* -> Id
 61:    LDA  2,3(5) 	get param variable address
 62:     LD  1,0(2) 	get variable value
* <- Id
 63:    LDA  4,1(4) 	pop prepare
 64:     LD  2,-1(4) 	op: recover left
 65:    SUB  1,2,1 	op <
 66:    JLT  1,2(7) 	br if true
 67:    LDC  1,0(0) 	false case
 68:    LDA  7,1(7) 	unconditional jmp
 69:    LDC  1,1(0) 	true case
* <- Op
* jump to end if test fails
* -> compound
* -> if
* -> Op
* -> array element
 71:     LD  2,2(5) 	get param array address
 72:    LDA  4,-1(4) 	push prepare
 73:     ST  2,0(4) 	protect array address
* -> Id
 74:    LDA  2,-2(5) 	get local address
 75:     LD  1,0(2) 	get variable value
* <- Id
 76:    LDA  4,1(4) 	pop prepare
 77:     LD  2,-1(4) 	recover array address
 78:    SUB  2,2,1 	get address of array element
 79:     LD  1,0(2) 	get value of array element
* <- array element
 80:    LDA  4,-1(4) 	push prepare
 81:     ST  1,0(4) 	op: protect left
* -> Id
 82:    LDA  2,-3(5) 	get local address
 83:     LD  1,0(2) 	get variable value
* <- Id
 84:    LDA  4,1(4) 	pop prepare
 85:     LD  2,-1(4) 	op: recover left
 86:    SUB  1,2,1 	op <
 87:    JLT  1,2(7) 	br if true
 88:    LDC  1,0(0) 	false case
 89:    LDA  7,1(7) 	unconditional jmp
 90:    LDC  1,1(0) 	true case
* <- Op
* if: jump to else belongs here
* -> compound
* -> assign
* -> Id
 92:    LDA  2,-3(5) 	get local address
* <- Id
 93:    LDA  4,-1(4) 	push prepare
 94:     ST  2,0(4) 	protect bx
* -> array element
 95:     LD  2,2(5) 	get param array address
 96:    LDA  4,-1(4) 	push prepare
 97:     ST  2,0(4) 	protect array address
* -> Id
 98:    LDA  2,-2(5) 	get local address
 99:     LD  1,0(2) 	get variable value
* <- Id
100:    LDA  4,1(4) 	pop prepare
101:     LD  2,-1(4) 	recover array address
102:    SUB  2,2,1 	get address of array element
103:     LD  1,0(2) 	get value of array element
* <- array element
104:    LDA  4,1(4) 	pop prepare
105:     LD  2,-1(4) 	recover bx
106:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
107:    LDA  2,-4(5) 	get local address
* <- Id
108:    LDA  4,-1(4) 	push prepare
109:     ST  2,0(4) 	protect bx
* -> Id
110:    LDA  2,-2(5) 	get local address
111:     LD  1,0(2) 	get variable value
* <- Id
112:    LDA  4,1(4) 	pop prepare
113:     LD  2,-1(4) 	recover bx
114:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
* if: jump to end belongs here
 91:    JEQ  1,116(0) 	if: jmp to else
115:    LDA  7,116(0) 	jmp to end
* <- if
* -> assign
* -> Id
116:    LDA  2,-2(5) 	get local address
* <- Id
117:    LDA  4,-1(4) 	push prepare
118:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
119:    LDA  2,-2(5) 	get local address
120:     LD  1,0(2) 	get variable value
* <- Id
121:    LDA  4,-1(4) 	push prepare
122:     ST  1,0(4) 	op: protect left
* -> Const
123:    LDC  1,1(0) 	load const
* <- Const
124:    LDA  4,1(4) 	pop prepare
125:     LD  2,-1(4) 	op: recover left
126:    ADD  1,2,1 	op +
* <- Op
127:    LDA  4,1(4) 	pop prepare
128:     LD  2,-1(4) 	recover bx
129:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
130:    LDA  7,57(0) 	jump to test
 70:    JEQ  1,131(0) 	jump to end
* <- while
* -> return
* -> Id
131:    LDA  2,-4(5) 	get local address
132:     LD  1,0(2) 	get variable value
* <- Id
133:    LDA  4,0(5) 	let sp == bp
134:    LDA  4,2(4) 	pop prepare
135:     LD  5,-2(4) 	pop old bp
136:     LD  7,-1(4) 	pop return addr
* <- return
* <- compound
* <- function
* -> function:
137:    LDA  4,-1(4) 	push prepare
138:     ST  5,0(4) 	push old bp
139:    LDA  5,0(4) 	let bp == sp
140:    LDA  4,-2(4) 	allocate for local variables
* -> compound
* -> assign
* -> Id
141:    LDA  2,-2(5) 	get local address
* <- Id
142:    LDA  4,-1(4) 	push prepare
143:     ST  2,0(4) 	protect bx
* -> Id
144:    LDA  2,6(5) 	get param variable address
145:     LD  1,0(2) 	get variable value
* <- Id
146:    LDA  4,1(4) 	pop prepare
147:     LD  2,-1(4) 	recover bx
148:     ST  1,0(2) 	assign: store
* <- assign
* -> while
* jump here after body
* -> Op
* -> Id
149:    LDA  2,-2(5) 	get local address
150:     LD  1,0(2) 	get variable value
* <- Id
151:    LDA  4,-1(4) 	push prepare
152:     ST  1,0(4) 	op: protect left
* -> Op
* -> Id
153:    LDA  2,7(5) 	get param variable address
154:     LD  1,0(2) 	get variable value
* <- Id
155:    LDA  4,-1(4) 	push prepare
156:     ST  1,0(4) 	op: protect left
* -> Const
157:    LDC  1,1(0) 	load const
* <- Const
158:    LDA  4,1(4) 	pop prepare
159:     LD  2,-1(4) 	op: recover left
160:    SUB  1,2,1 	op -
* <- Op
161:    LDA  4,1(4) 	pop prepare
162:     LD  2,-1(4) 	op: recover left
163:    SUB  1,2,1 	op <
164:    JLT  1,2(7) 	br if true
165:    LDC  1,0(0) 	false case
166:    LDA  7,1(7) 	unconditional jmp
167:    LDC  1,1(0) 	true case
* <- Op
* jump to end if test fails
* -> compound
* -> assign
* -> Id
169:    LDA  2,-3(5) 	get local address
* <- Id
170:    LDA  4,-1(4) 	push prepare
171:     ST  2,0(4) 	protect bx
* -> call
* -> Id
172:    LDA  2,7(5) 	get param variable address
173:     LD  1,0(2) 	get variable value
* <- Id
174:    LDA  4,-1(4) 	push prepare
175:     ST  1,0(4) 	push parameters
* -> Id
176:    LDA  2,-2(5) 	get local address
177:     LD  1,0(2) 	get variable value
* <- Id
178:    LDA  4,-1(4) 	push prepare
179:     ST  1,0(4) 	push parameters
* -> Id
180:     LD  2,2(5) 	get param array address
181:    LDA  1,0(2) 	get array variable value
* <- Id
182:    LDA  4,-1(4) 	push prepare
183:     ST  1,0(4) 	push parameters
184:    LDA  1,3(7) 	store returned PC
185:    LDA  4,-1(4) 	push prepare
186:     ST  1,0(4) 	push returned PC
187:    LDC  7,16(0) 	jump to function
188:    LDA  4,3(4) 	release parameters
* <- call
189:    LDA  4,1(4) 	pop prepare
190:     LD  2,-1(4) 	recover bx
191:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
192:    LDA  2,-4(5) 	get local address
* <- Id
193:    LDA  4,-1(4) 	push prepare
194:     ST  2,0(4) 	protect bx
* -> array element
195:     LD  2,2(5) 	get param array address
196:    LDA  4,-1(4) 	push prepare
197:     ST  2,0(4) 	protect array address
* -> Id
198:    LDA  2,-3(5) 	get local address
199:     LD  1,0(2) 	get variable value
* <- Id
200:    LDA  4,1(4) 	pop prepare
201:     LD  2,-1(4) 	recover array address
202:    SUB  2,2,1 	get address of array element
203:     LD  1,0(2) 	get value of array element
* <- array element
204:    LDA  4,1(4) 	pop prepare
205:     LD  2,-1(4) 	recover bx
206:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> array element
207:     LD  2,2(5) 	get param array address
208:    LDA  4,-1(4) 	push prepare
209:     ST  2,0(4) 	protect array address
* -> Id
210:    LDA  2,-3(5) 	get local address
211:     LD  1,0(2) 	get variable value
* <- Id
212:    LDA  4,1(4) 	pop prepare
213:     LD  2,-1(4) 	recover array address
214:    SUB  2,2,1 	get address of array element
* <- array element
215:    LDA  4,-1(4) 	push prepare
216:     ST  2,0(4) 	protect bx
* -> array element
217:     LD  2,2(5) 	get param array address
218:    LDA  4,-1(4) 	push prepare
219:     ST  2,0(4) 	protect array address
* -> Id
220:    LDA  2,-2(5) 	get local address
221:     LD  1,0(2) 	get variable value
* <- Id
222:    LDA  4,1(4) 	pop prepare
223:     LD  2,-1(4) 	recover array address
224:    SUB  2,2,1 	get address of array element
225:     LD  1,0(2) 	get value of array element
* <- array element
226:    LDA  4,1(4) 	pop prepare
227:     LD  2,-1(4) 	recover bx
228:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> array element
229:     LD  2,2(5) 	get param array address
230:    LDA  4,-1(4) 	push prepare
231:     ST  2,0(4) 	protect array address
* -> Id
232:    LDA  2,-2(5) 	get local address
233:     LD  1,0(2) 	get variable value
* <- Id
234:    LDA  4,1(4) 	pop prepare
235:     LD  2,-1(4) 	recover array address
236:    SUB  2,2,1 	get address of array element
* <- array element
237:    LDA  4,-1(4) 	push prepare
238:     ST  2,0(4) 	protect bx
* -> Id
239:    LDA  2,-4(5) 	get local address
240:     LD  1,0(2) 	get variable value
* <- Id
241:    LDA  4,1(4) 	pop prepare
242:     LD  2,-1(4) 	recover bx
243:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
244:    LDA  2,-2(5) 	get local address
* <- Id
245:    LDA  4,-1(4) 	push prepare
246:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
247:    LDA  2,-2(5) 	get local address
248:     LD  1,0(2) 	get variable value
* <- Id
249:    LDA  4,-1(4) 	push prepare
250:     ST  1,0(4) 	op: protect left
* -> Const
251:    LDC  1,1(0) 	load const
* <- Const
252:    LDA  4,1(4) 	pop prepare
253:     LD  2,-1(4) 	op: recover left
254:    ADD  1,2,1 	op +
* <- Op
255:    LDA  4,1(4) 	pop prepare
256:     LD  2,-1(4) 	recover bx
257:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
258:    LDA  7,149(0) 	jump to test
168:    JEQ  1,259(0) 	jump to end
* <- while
* <- compound
259:    LDA  4,0(5) 	let sp == bp
260:    LDA  4,2(4) 	pop prepare
261:     LD  5,-2(4) 	pop old bp
262:     LD  7,-1(4) 	pop return addr
* <- function
* -> function:
263:    LDA  4,-1(4) 	push prepare
264:     ST  5,0(4) 	push old bp
265:    LDA  5,0(4) 	let bp == sp
266:    LDA  4,-11(4) 	allocate for local variables
* -> compound
* -> assign
* -> Id
267:    LDA  2,-1(5) 	get local address
* <- Id
268:    LDA  4,-1(4) 	push prepare
269:     ST  2,0(4) 	protect bx
* -> Const
270:    LDC  1,0(0) 	load const
* <- Const
271:    LDA  4,1(4) 	pop prepare
272:     LD  2,-1(4) 	recover bx
273:     ST  1,0(2) 	assign: store
* <- assign
* -> while
* jump here after body
* -> Op
* -> Id
274:    LDA  2,-1(5) 	get local address
275:     LD  1,0(2) 	get variable value
* <- Id
276:    LDA  4,-1(4) 	push prepare
277:     ST  1,0(4) 	op: protect left
* -> Const
278:    LDC  1,10(0) 	load const
* <- Const
279:    LDA  4,1(4) 	pop prepare
280:     LD  2,-1(4) 	op: recover left
281:    SUB  1,2,1 	op <
282:    JLT  1,2(7) 	br if true
283:    LDC  1,0(0) 	false case
284:    LDA  7,1(7) 	unconditional jmp
285:    LDC  1,1(0) 	true case
* <- Op
* jump to end if test fails
* -> compound
* -> assign
* -> array element
287:    LDA  2,0(5) 	get local array address
288:    LDA  4,-1(4) 	push prepare
289:     ST  2,0(4) 	protect array address
* -> Id
290:    LDA  2,-1(5) 	get local address
291:     LD  1,0(2) 	get variable value
* <- Id
292:    LDA  4,1(4) 	pop prepare
293:     LD  2,-1(4) 	recover array address
294:    SUB  2,2,1 	get address of array element
* <- array element
295:    LDA  4,-1(4) 	push prepare
296:     ST  2,0(4) 	protect bx
* -> call
297:    LDA  1,3(7) 	store returned PC
298:    LDA  4,-1(4) 	push prepare
299:     ST  1,0(4) 	push returned PC
300:    LDC  7,9(0) 	jump to function
301:    LDA  4,0(4) 	release parameters
* <- call
302:    LDA  4,1(4) 	pop prepare
303:     LD  2,-1(4) 	recover bx
304:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
305:    LDA  2,-1(5) 	get local address
* <- Id
306:    LDA  4,-1(4) 	push prepare
307:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
308:    LDA  2,-1(5) 	get local address
309:     LD  1,0(2) 	get variable value
* <- Id
310:    LDA  4,-1(4) 	push prepare
311:     ST  1,0(4) 	op: protect left
* -> Const
312:    LDC  1,1(0) 	load const
* <- Const
313:    LDA  4,1(4) 	pop prepare
314:     LD  2,-1(4) 	op: recover left
315:    ADD  1,2,1 	op +
* <- Op
316:    LDA  4,1(4) 	pop prepare
317:     LD  2,-1(4) 	recover bx
318:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
319:    LDA  7,274(0) 	jump to test
286:    JEQ  1,320(0) 	jump to end
* <- while
* -> call
* -> Const
320:    LDC  1,10(0) 	load const
* <- Const
321:    LDA  4,-1(4) 	push prepare
322:     ST  1,0(4) 	push parameters
* -> Const
323:    LDC  1,0(0) 	load const
* <- Const
324:    LDA  4,-1(4) 	push prepare
325:     ST  1,0(4) 	push parameters
* -> Id
326:    LDA  2,0(5) 	get local array address
327:    LDA  1,0(2) 	get array variable value
* <- Id
328:    LDA  4,-1(4) 	push prepare
329:     ST  1,0(4) 	push parameters
330:    LDA  1,3(7) 	store returned PC
331:    LDA  4,-1(4) 	push prepare
332:     ST  1,0(4) 	push returned PC
333:    LDC  7,137(0) 	jump to function
334:    LDA  4,3(4) 	release parameters
* <- call
* -> assign
* -> Id
335:    LDA  2,-1(5) 	get local address
* <- Id
336:    LDA  4,-1(4) 	push prepare
337:     ST  2,0(4) 	protect bx
* -> Const
338:    LDC  1,0(0) 	load const
* <- Const
339:    LDA  4,1(4) 	pop prepare
340:     LD  2,-1(4) 	recover bx
341:     ST  1,0(2) 	assign: store
* <- assign
* -> while
* jump here after body
* -> Op
* -> Id
342:    LDA  2,-1(5) 	get local address
343:     LD  1,0(2) 	get variable value
* <- Id
344:    LDA  4,-1(4) 	push prepare
345:     ST  1,0(4) 	op: protect left
* -> Const
346:    LDC  1,10(0) 	load const
* <- Const
347:    LDA  4,1(4) 	pop prepare
348:     LD  2,-1(4) 	op: recover left
349:    SUB  1,2,1 	op <
350:    JLT  1,2(7) 	br if true
351:    LDC  1,0(0) 	false case
352:    LDA  7,1(7) 	unconditional jmp
353:    LDC  1,1(0) 	true case
* <- Op
* jump to end if test fails
* -> compound
* -> call
* -> array element
355:    LDA  2,0(5) 	get local array address
356:    LDA  4,-1(4) 	push prepare
357:     ST  2,0(4) 	protect array address
* -> Id
358:    LDA  2,-1(5) 	get local address
359:     LD  1,0(2) 	get variable value
* <- Id
360:    LDA  4,1(4) 	pop prepare
361:     LD  2,-1(4) 	recover array address
362:    SUB  2,2,1 	get address of array element
363:     LD  1,0(2) 	get value of array element
* <- array element
364:    LDA  4,-1(4) 	push prepare
365:     ST  1,0(4) 	push parameters
366:    LDA  1,3(7) 	store returned PC
367:    LDA  4,-1(4) 	push prepare
368:     ST  1,0(4) 	push returned PC
369:    LDC  7,12(0) 	jump to function
370:    LDA  4,1(4) 	release parameters
* <- call
* -> assign
* -> Id
371:    LDA  2,-1(5) 	get local address
* <- Id
372:    LDA  4,-1(4) 	push prepare
373:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
374:    LDA  2,-1(5) 	get local address
375:     LD  1,0(2) 	get variable value
* <- Id
376:    LDA  4,-1(4) 	push prepare
377:     ST  1,0(4) 	op: protect left
* -> Const
378:    LDC  1,1(0) 	load const
* <- Const
379:    LDA  4,1(4) 	pop prepare
380:     LD  2,-1(4) 	op: recover left
381:    ADD  1,2,1 	op +
* <- Op
382:    LDA  4,1(4) 	pop prepare
383:     LD  2,-1(4) 	recover bx
384:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
385:    LDA  7,342(0) 	jump to test
354:    JEQ  1,386(0) 	jump to end
* <- while
* <- compound
386:    LDA  4,0(5) 	let sp == bp
387:    LDA  4,2(4) 	pop prepare
388:     LD  5,-2(4) 	pop old bp
389:     LD  7,-1(4) 	pop return addr
* <- function
  3:    LDA  1,3(7) 	store returned PC
  4:    LDA  4,-1(4) 	push prepare
  5:     ST  1,0(4) 	push returned PC
  6:    LDC  7,263(0) 	jump to function
  7:    LDA  4,11(4) 	release local var
* End of execution.
  8:   HALT  0,0,0 	
