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
 36:    LDA  2,-3(5) 	get local address
* <- Id
 37:    LDA  4,-1(4) 	push prepare
 38:     ST  2,0(4) 	protect bx
* -> array element
 39:     LD  2,2(5) 	get param array address
 40:    LDA  4,-1(4) 	push prepare
 41:     ST  2,0(4) 	protect array address
* -> Id
 42:    LDA  2,2(5) 	get param variable address
 43:     LD  1,0(2) 	get variable value
* <- Id
 44:    LDA  4,1(4) 	pop prepare
 45:     LD  2,-1(4) 	recover array address
 46:    SUB  2,2,1 	get address of array element
 47:     LD  1,0(2) 	get value of array element
* <- array element
 48:    LDA  4,1(4) 	pop prepare
 49:     LD  2,-1(4) 	recover bx
 50:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
 51:    LDA  2,-2(5) 	get local address
* <- Id
 52:    LDA  4,-1(4) 	push prepare
 53:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
 54:    LDA  2,2(5) 	get param variable address
 55:     LD  1,0(2) 	get variable value
* <- Id
 56:    LDA  4,-1(4) 	push prepare
 57:     ST  1,0(4) 	op: protect left
* -> Const
 58:    LDC  1,1(0) 	load const
* <- Const
 59:    LDA  4,1(4) 	pop prepare
 60:     LD  2,-1(4) 	op: recover left
 61:    ADD  1,2,1 	op +
* <- Op
 62:    LDA  4,1(4) 	pop prepare
 63:     LD  2,-1(4) 	recover bx
 64:     ST  1,0(2) 	assign: store
* <- assign
* -> while
* jump here after body
* -> Op
* -> Id
 65:    LDA  2,-2(5) 	get local address
 66:     LD  1,0(2) 	get variable value
* <- Id
 67:    LDA  4,-1(4) 	push prepare
 68:     ST  1,0(4) 	op: protect left
* -> Id
 69:    LDA  2,3(5) 	get param variable address
 70:     LD  1,0(2) 	get variable value
* <- Id
 71:    LDA  4,1(4) 	pop prepare
 72:     LD  2,-1(4) 	op: recover left
 73:    SUB  1,2,1 	op <
 74:    JLT  1,2(7) 	br if true
 75:    LDC  1,0(0) 	false case
 76:    LDA  7,1(7) 	unconditional jmp
 77:    LDC  1,1(0) 	true case
* <- Op
* jump to end if test fails
* -> compound
* -> if
* -> Op
* -> array element
 79:     LD  2,2(5) 	get param array address
 80:    LDA  4,-1(4) 	push prepare
 81:     ST  2,0(4) 	protect array address
* -> Id
 82:    LDA  2,-2(5) 	get local address
 83:     LD  1,0(2) 	get variable value
* <- Id
 84:    LDA  4,1(4) 	pop prepare
 85:     LD  2,-1(4) 	recover array address
 86:    SUB  2,2,1 	get address of array element
 87:     LD  1,0(2) 	get value of array element
* <- array element
 88:    LDA  4,-1(4) 	push prepare
 89:     ST  1,0(4) 	op: protect left
* -> Id
 90:    LDA  2,-3(5) 	get local address
 91:     LD  1,0(2) 	get variable value
* <- Id
 92:    LDA  4,1(4) 	pop prepare
 93:     LD  2,-1(4) 	op: recover left
 94:    SUB  1,2,1 	op <
 95:    JLT  1,2(7) 	br if true
 96:    LDC  1,0(0) 	false case
 97:    LDA  7,1(7) 	unconditional jmp
 98:    LDC  1,1(0) 	true case
* <- Op
* if: jump to else belongs here
* -> compound
* -> assign
* -> Id
100:    LDA  2,-3(5) 	get local address
* <- Id
101:    LDA  4,-1(4) 	push prepare
102:     ST  2,0(4) 	protect bx
* -> array element
103:     LD  2,2(5) 	get param array address
104:    LDA  4,-1(4) 	push prepare
105:     ST  2,0(4) 	protect array address
* -> Id
106:    LDA  2,-2(5) 	get local address
107:     LD  1,0(2) 	get variable value
* <- Id
108:    LDA  4,1(4) 	pop prepare
109:     LD  2,-1(4) 	recover array address
110:    SUB  2,2,1 	get address of array element
111:     LD  1,0(2) 	get value of array element
* <- array element
112:    LDA  4,1(4) 	pop prepare
113:     LD  2,-1(4) 	recover bx
114:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
115:    LDA  2,-4(5) 	get local address
* <- Id
116:    LDA  4,-1(4) 	push prepare
117:     ST  2,0(4) 	protect bx
* -> Id
118:    LDA  2,-2(5) 	get local address
119:     LD  1,0(2) 	get variable value
* <- Id
120:    LDA  4,1(4) 	pop prepare
121:     LD  2,-1(4) 	recover bx
122:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
* if: jump to end belongs here
 99:    JEQ  1,24(7) 	if: jmp to else
123:    LDA  7,0(7) 	jmp to end
* <- if
* -> assign
* -> Id
124:    LDA  2,-2(5) 	get local address
* <- Id
125:    LDA  4,-1(4) 	push prepare
126:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
127:    LDA  2,-2(5) 	get local address
128:     LD  1,0(2) 	get variable value
* <- Id
129:    LDA  4,-1(4) 	push prepare
130:     ST  1,0(4) 	op: protect left
* -> Const
131:    LDC  1,1(0) 	load const
* <- Const
132:    LDA  4,1(4) 	pop prepare
133:     LD  2,-1(4) 	op: recover left
134:    ADD  1,2,1 	op +
* <- Op
135:    LDA  4,1(4) 	pop prepare
136:     LD  2,-1(4) 	recover bx
137:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
138:    LDA  7,65(0) 	jump to test
 78:    JEQ  1,139(0) 	jump to end
* <- while
* -> return
* -> Id
139:    LDA  2,-4(5) 	get local address
140:     LD  1,0(2) 	get variable value
* <- Id
141:    LDA  4,0(5) 	let sp == bp
142:    LDA  4,2(4) 	pop prepare
143:     LD  5,-2(4) 	pop old bp
144:     LD  7,-1(4) 	pop return addr
* <- return
* <- compound
* <- function
* -> function:
145:    LDA  4,-1(4) 	push prepare
146:     ST  5,0(4) 	push old bp
147:    LDA  5,0(4) 	let bp == sp
148:    LDA  4,-2(4) 	allocate for local variables
* -> compound
* -> assign
* -> Id
149:    LDA  2,-2(5) 	get local address
* <- Id
150:    LDA  4,-1(4) 	push prepare
151:     ST  2,0(4) 	protect bx
* -> Id
152:    LDA  2,6(5) 	get param variable address
153:     LD  1,0(2) 	get variable value
* <- Id
154:    LDA  4,1(4) 	pop prepare
155:     LD  2,-1(4) 	recover bx
156:     ST  1,0(2) 	assign: store
* <- assign
* -> while
* jump here after body
* -> Op
* -> Id
157:    LDA  2,-2(5) 	get local address
158:     LD  1,0(2) 	get variable value
* <- Id
159:    LDA  4,-1(4) 	push prepare
160:     ST  1,0(4) 	op: protect left
* -> Op
* -> Id
161:    LDA  2,7(5) 	get param variable address
162:     LD  1,0(2) 	get variable value
* <- Id
163:    LDA  4,-1(4) 	push prepare
164:     ST  1,0(4) 	op: protect left
* -> Const
165:    LDC  1,1(0) 	load const
* <- Const
166:    LDA  4,1(4) 	pop prepare
167:     LD  2,-1(4) 	op: recover left
168:    SUB  1,2,1 	op -
* <- Op
169:    LDA  4,1(4) 	pop prepare
170:     LD  2,-1(4) 	op: recover left
171:    SUB  1,2,1 	op <
172:    JLT  1,2(7) 	br if true
173:    LDC  1,0(0) 	false case
174:    LDA  7,1(7) 	unconditional jmp
175:    LDC  1,1(0) 	true case
* <- Op
* jump to end if test fails
* -> compound
* -> assign
* -> Id
177:    LDA  2,-3(5) 	get local address
* <- Id
178:    LDA  4,-1(4) 	push prepare
179:     ST  2,0(4) 	protect bx
* -> call
* -> Id
180:    LDA  2,7(5) 	get param variable address
181:     LD  1,0(2) 	get variable value
* <- Id
182:    LDA  4,-1(4) 	push prepare
183:     ST  1,0(4) 	push parameters
* -> Id
184:    LDA  2,-2(5) 	get local address
185:     LD  1,0(2) 	get variable value
* <- Id
186:    LDA  4,-1(4) 	push prepare
187:     ST  1,0(4) 	push parameters
* -> Id
188:    LDA  2,2(5) 	get param variable address
189:     LD  1,0(2) 	get variable value
* <- Id
190:    LDA  4,-1(4) 	push prepare
191:     ST  1,0(4) 	push parameters
192:    LDA  1,3(7) 	store returned PC
193:    LDA  4,-1(4) 	push prepare
194:     ST  1,0(4) 	push returned PC
195:    LDC  7,24(0) 	jump to function
196:    LDA  4,3(4) 	release parameters
* <- call
197:    LDA  4,1(4) 	pop prepare
198:     LD  2,-1(4) 	recover bx
199:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
200:    LDA  2,-4(5) 	get local address
* <- Id
201:    LDA  4,-1(4) 	push prepare
202:     ST  2,0(4) 	protect bx
* -> array element
203:     LD  2,2(5) 	get param array address
204:    LDA  4,-1(4) 	push prepare
205:     ST  2,0(4) 	protect array address
* -> Id
206:    LDA  2,-3(5) 	get local address
207:     LD  1,0(2) 	get variable value
* <- Id
208:    LDA  4,1(4) 	pop prepare
209:     LD  2,-1(4) 	recover array address
210:    SUB  2,2,1 	get address of array element
211:     LD  1,0(2) 	get value of array element
* <- array element
212:    LDA  4,1(4) 	pop prepare
213:     LD  2,-1(4) 	recover bx
214:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> array element
215:     LD  2,2(5) 	get param array address
216:    LDA  4,-1(4) 	push prepare
217:     ST  2,0(4) 	protect array address
* -> Id
218:    LDA  2,-3(5) 	get local address
219:     LD  1,0(2) 	get variable value
* <- Id
220:    LDA  4,1(4) 	pop prepare
221:     LD  2,-1(4) 	recover array address
222:    SUB  2,2,1 	get address of array element
* <- array element
223:    LDA  4,-1(4) 	push prepare
224:     ST  2,0(4) 	protect bx
* -> array element
225:     LD  2,2(5) 	get param array address
226:    LDA  4,-1(4) 	push prepare
227:     ST  2,0(4) 	protect array address
* -> Id
228:    LDA  2,-2(5) 	get local address
229:     LD  1,0(2) 	get variable value
* <- Id
230:    LDA  4,1(4) 	pop prepare
231:     LD  2,-1(4) 	recover array address
232:    SUB  2,2,1 	get address of array element
233:     LD  1,0(2) 	get value of array element
* <- array element
234:    LDA  4,1(4) 	pop prepare
235:     LD  2,-1(4) 	recover bx
236:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> array element
237:     LD  2,2(5) 	get param array address
238:    LDA  4,-1(4) 	push prepare
239:     ST  2,0(4) 	protect array address
* -> Id
240:    LDA  2,-2(5) 	get local address
241:     LD  1,0(2) 	get variable value
* <- Id
242:    LDA  4,1(4) 	pop prepare
243:     LD  2,-1(4) 	recover array address
244:    SUB  2,2,1 	get address of array element
* <- array element
245:    LDA  4,-1(4) 	push prepare
246:     ST  2,0(4) 	protect bx
* -> Id
247:    LDA  2,-4(5) 	get local address
248:     LD  1,0(2) 	get variable value
* <- Id
249:    LDA  4,1(4) 	pop prepare
250:     LD  2,-1(4) 	recover bx
251:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
252:    LDA  2,-2(5) 	get local address
* <- Id
253:    LDA  4,-1(4) 	push prepare
254:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
255:    LDA  2,-2(5) 	get local address
256:     LD  1,0(2) 	get variable value
* <- Id
257:    LDA  4,-1(4) 	push prepare
258:     ST  1,0(4) 	op: protect left
* -> Const
259:    LDC  1,1(0) 	load const
* <- Const
260:    LDA  4,1(4) 	pop prepare
261:     LD  2,-1(4) 	op: recover left
262:    ADD  1,2,1 	op +
* <- Op
263:    LDA  4,1(4) 	pop prepare
264:     LD  2,-1(4) 	recover bx
265:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
266:    LDA  7,157(0) 	jump to test
176:    JEQ  1,267(0) 	jump to end
* <- while
* <- compound
267:    LDA  4,0(5) 	let sp == bp
268:    LDA  4,2(4) 	pop prepare
269:     LD  5,-2(4) 	pop old bp
270:     LD  7,-1(4) 	pop return addr
* <- function
* -> function:
271:    LDA  4,-1(4) 	push prepare
272:     ST  5,0(4) 	push old bp
273:    LDA  5,0(4) 	let bp == sp
274:    LDA  4,-1(4) 	allocate for local variables
* -> compound
* -> assign
* -> Id
275:    LDA  2,-1(5) 	get local address
* <- Id
276:    LDA  4,-1(4) 	push prepare
277:     ST  2,0(4) 	protect bx
* -> Const
278:    LDC  1,0(0) 	load const
* <- Const
279:    LDA  4,1(4) 	pop prepare
280:     LD  2,-1(4) 	recover bx
281:     ST  1,0(2) 	assign: store
* <- assign
* -> while
* jump here after body
* -> Op
* -> Id
282:    LDA  2,-1(5) 	get local address
283:     LD  1,0(2) 	get variable value
* <- Id
284:    LDA  4,-1(4) 	push prepare
285:     ST  1,0(4) 	op: protect left
* -> Const
286:    LDC  1,10(0) 	load const
* <- Const
287:    LDA  4,1(4) 	pop prepare
288:     LD  2,-1(4) 	op: recover left
289:    SUB  1,2,1 	op <
290:    JLT  1,2(7) 	br if true
291:    LDC  1,0(0) 	false case
292:    LDA  7,1(7) 	unconditional jmp
293:    LDC  1,1(0) 	true case
* <- Op
* jump to end if test fails
* -> compound
* -> assign
* -> array element
295:    LDA  2,0(6) 	get global array address
296:    LDA  4,-1(4) 	push prepare
297:     ST  2,0(4) 	protect array address
* -> Id
298:    LDA  2,-1(5) 	get local address
299:     LD  1,0(2) 	get variable value
* <- Id
300:    LDA  4,1(4) 	pop prepare
301:     LD  2,-1(4) 	recover array address
302:    SUB  2,2,1 	get address of array element
* <- array element
303:    LDA  4,-1(4) 	push prepare
304:     ST  2,0(4) 	protect bx
* -> call
305:    LDA  1,3(7) 	store returned PC
306:    LDA  4,-1(4) 	push prepare
307:     ST  1,0(4) 	push returned PC
308:    LDC  7,9(0) 	jump to function
309:    LDA  4,0(4) 	release parameters
* <- call
310:    LDA  4,1(4) 	pop prepare
311:     LD  2,-1(4) 	recover bx
312:     ST  1,0(2) 	assign: store
* <- assign
* -> assign
* -> Id
313:    LDA  2,-1(5) 	get local address
* <- Id
314:    LDA  4,-1(4) 	push prepare
315:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
316:    LDA  2,-1(5) 	get local address
317:     LD  1,0(2) 	get variable value
* <- Id
318:    LDA  4,-1(4) 	push prepare
319:     ST  1,0(4) 	op: protect left
* -> Const
320:    LDC  1,1(0) 	load const
* <- Const
321:    LDA  4,1(4) 	pop prepare
322:     LD  2,-1(4) 	op: recover left
323:    ADD  1,2,1 	op +
* <- Op
324:    LDA  4,1(4) 	pop prepare
325:     LD  2,-1(4) 	recover bx
326:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
327:    LDA  7,282(0) 	jump to test
294:    JEQ  1,328(0) 	jump to end
* <- while
* -> call
* -> Const
328:    LDC  1,10(0) 	load const
* <- Const
329:    LDA  4,-1(4) 	push prepare
330:     ST  1,0(4) 	push parameters
* -> Const
331:    LDC  1,0(0) 	load const
* <- Const
332:    LDA  4,-1(4) 	push prepare
333:     ST  1,0(4) 	push parameters
* -> Id
334:    LDA  2,-1(6) 	get global address
335:     LD  1,0(2) 	get variable value
* <- Id
336:    LDA  4,-1(4) 	push prepare
337:     ST  1,0(4) 	push parameters
338:    LDA  1,3(7) 	store returned PC
339:    LDA  4,-1(4) 	push prepare
340:     ST  1,0(4) 	push returned PC
341:    LDC  7,145(0) 	jump to function
342:    LDA  4,3(4) 	release parameters
* <- call
* -> assign
* -> Id
343:    LDA  2,-1(5) 	get local address
* <- Id
344:    LDA  4,-1(4) 	push prepare
345:     ST  2,0(4) 	protect bx
* -> Const
346:    LDC  1,0(0) 	load const
* <- Const
347:    LDA  4,1(4) 	pop prepare
348:     LD  2,-1(4) 	recover bx
349:     ST  1,0(2) 	assign: store
* <- assign
* -> while
* jump here after body
* -> Op
* -> Id
350:    LDA  2,-1(5) 	get local address
351:     LD  1,0(2) 	get variable value
* <- Id
352:    LDA  4,-1(4) 	push prepare
353:     ST  1,0(4) 	op: protect left
* -> Const
354:    LDC  1,10(0) 	load const
* <- Const
355:    LDA  4,1(4) 	pop prepare
356:     LD  2,-1(4) 	op: recover left
357:    SUB  1,2,1 	op <
358:    JLT  1,2(7) 	br if true
359:    LDC  1,0(0) 	false case
360:    LDA  7,1(7) 	unconditional jmp
361:    LDC  1,1(0) 	true case
* <- Op
* jump to end if test fails
* -> compound
* -> call
* -> array element
363:    LDA  2,0(6) 	get global array address
364:    LDA  4,-1(4) 	push prepare
365:     ST  2,0(4) 	protect array address
* -> Id
366:    LDA  2,-1(5) 	get local address
367:     LD  1,0(2) 	get variable value
* <- Id
368:    LDA  4,1(4) 	pop prepare
369:     LD  2,-1(4) 	recover array address
370:    SUB  2,2,1 	get address of array element
371:     LD  1,0(2) 	get value of array element
* <- array element
372:    LDA  4,-1(4) 	push prepare
373:     ST  1,0(4) 	push parameters
374:    LDA  1,3(7) 	store returned PC
375:    LDA  4,-1(4) 	push prepare
376:     ST  1,0(4) 	push returned PC
377:    LDC  7,12(0) 	jump to function
378:    LDA  4,1(4) 	release parameters
* <- call
* -> assign
* -> Id
379:    LDA  2,-1(5) 	get local address
* <- Id
380:    LDA  4,-1(4) 	push prepare
381:     ST  2,0(4) 	protect bx
* -> Op
* -> Id
382:    LDA  2,-1(5) 	get local address
383:     LD  1,0(2) 	get variable value
* <- Id
384:    LDA  4,-1(4) 	push prepare
385:     ST  1,0(4) 	op: protect left
* -> Const
386:    LDC  1,1(0) 	load const
* <- Const
387:    LDA  4,1(4) 	pop prepare
388:     LD  2,-1(4) 	op: recover left
389:    ADD  1,2,1 	op +
* <- Op
390:    LDA  4,1(4) 	pop prepare
391:     LD  2,-1(4) 	recover bx
392:     ST  1,0(2) 	assign: store
* <- assign
* <- compound
393:    LDA  7,350(0) 	jump to test
362:    JEQ  1,394(0) 	jump to end
* <- while
* <- compound
394:    LDA  4,0(5) 	let sp == bp
395:    LDA  4,2(4) 	pop prepare
396:     LD  5,-2(4) 	pop old bp
397:     LD  7,-1(4) 	pop return addr
* <- function
  3:    LDA  1,3(7) 	store returned PC
  4:    LDA  4,-1(4) 	push prepare
  5:     ST  1,0(4) 	push returned PC
  6:    LDC  7,271(0) 	jump to function
  7:    LDA  4,1(4) 	release local var
* End of execution.
  8:   HALT  0,0,0 	
