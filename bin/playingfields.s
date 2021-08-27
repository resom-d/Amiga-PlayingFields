
bin/playingfields.elf:     file format elf32-m68k


Disassembly of section .text:

00000000 <_start>:
extern void (*__init_array_start[])() __attribute__((weak));
extern void (*__init_array_end[])() __attribute__((weak));
extern void (*__fini_array_start[])() __attribute__((weak));
extern void (*__fini_array_end[])() __attribute__((weak));

__attribute__((used)) __attribute__((section(".text.unlikely"))) void _start() {
   0:	48e7 3020      	movem.l d2-d3/a2,-(sp)
	// initialize globals, ctors etc.
	unsigned long count;
	unsigned long i;

	count = __preinit_array_end - __preinit_array_start;
   4:	263c 0000 2000 	move.l #8192,d3
   a:	0483 0000 2000 	subi.l #8192,d3
  10:	e483           	asr.l #2,d3
	for (i = 0; i < count; i++)
  12:	6712           	beq.s 26 <_start+0x26>
  14:	45f9 0000 2000 	lea 2000 <bmpDisplay>,a2
  1a:	7400           	moveq #0,d2
		__preinit_array_start[i]();
  1c:	205a           	movea.l (a2)+,a0
  1e:	4e90           	jsr (a0)
	for (i = 0; i < count; i++)
  20:	5282           	addq.l #1,d2
  22:	b483           	cmp.l d3,d2
  24:	66f6           	bne.s 1c <_start+0x1c>

	count = __init_array_end - __init_array_start;
  26:	263c 0000 2000 	move.l #8192,d3
  2c:	0483 0000 2000 	subi.l #8192,d3
  32:	e483           	asr.l #2,d3
	for (i = 0; i < count; i++)
  34:	6712           	beq.s 48 <_start+0x48>
  36:	45f9 0000 2000 	lea 2000 <bmpDisplay>,a2
  3c:	7400           	moveq #0,d2
		__init_array_start[i]();
  3e:	205a           	movea.l (a2)+,a0
  40:	4e90           	jsr (a0)
	for (i = 0; i < count; i++)
  42:	5282           	addq.l #1,d2
  44:	b483           	cmp.l d3,d2
  46:	66f6           	bne.s 3e <_start+0x3e>

	main();
  48:	4eb9 0000 0074 	jsr 74 <main>

	// call dtors
	count = __fini_array_end - __fini_array_start;
  4e:	243c 0000 2000 	move.l #8192,d2
  54:	0482 0000 2000 	subi.l #8192,d2
  5a:	e482           	asr.l #2,d2
	for (i = count; i > 0; i--)
  5c:	6710           	beq.s 6e <_start+0x6e>
  5e:	45f9 0000 2000 	lea 2000 <bmpDisplay>,a2
		__fini_array_start[i - 1]();
  64:	5382           	subq.l #1,d2
  66:	2062           	movea.l -(a2),a0
  68:	4e90           	jsr (a0)
	for (i = count; i > 0; i--)
  6a:	4a82           	tst.l d2
  6c:	66f6           	bne.s 64 <_start+0x64>
}
  6e:	4cdf 040c      	movem.l (sp)+,d2-d3/a2
  72:	4e75           	rts

00000074 <main>:
#include "includes/head.h"

int main()
{
  74:	4fef ffbc      	lea -68(sp),sp
  78:	48e7 3f3e      	movem.l d2-d7/a2-a6,-(sp)
	copPtr = copWaitXY(copPtr, 0xfe, 0xff);
}

int InitDemo()
{
	SysBase = *((struct ExecBase **)4UL);
  7c:	2c78 0004      	movea.l 4 <_start+0x4>,a6
  80:	23ce 0001 107e 	move.l a6,1107e <SysBase>
	custom = (struct Custom *)0xdff000;
  86:	23fc 00df f000 	move.l #14675968,1108a <custom>
  8c:	0001 108a 

	// We will use the graphics library only to locate and restore the system copper list once we are through.
	GfxBase = (struct GfxBase *)OpenLibrary((CONST_STRPTR) "graphics.library", 0);
  90:	43f9 0000 0ff0 	lea ff0 <PutChar+0x4c>,a1
  96:	7000           	moveq #0,d0
  98:	4eae fdd8      	jsr -552(a6)
  9c:	23c0 0001 107a 	move.l d0,1107a <GfxBase>
	if (!GfxBase)
  a2:	6700 0a06      	beq.w aaa <main+0xa36>
		Exit(0);

	// used for printing
	DOSBase = (struct DosLibrary *)OpenLibrary((CONST_STRPTR) "dos.library", 0);
  a6:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
  ac:	43f9 0000 1001 	lea 1001 <PutChar+0x5d>,a1
  b2:	7000           	moveq #0,d0
  b4:	4eae fdd8      	jsr -552(a6)
  b8:	23c0 0001 1082 	move.l d0,11082 <DOSBase>
	if (!DOSBase)
  be:	6700 0936      	beq.w 9f6 <main+0x982>
		Exit(0);

#ifdef __cplusplus
	KPrintF("Hello debugger from Amiga: %ld!\n", staticClass.i);
#else
	KPrintF("Hello debugger from Amiga!\n");
  c2:	4879 0000 100d 	pea 100d <PutChar+0x69>
  c8:	4eb9 0000 0b4c 	jsr b4c <KPrintF>
#endif
	Write(Output(), (APTR) "Hello console!\n", 15);
  ce:	2c79 0001 1082 	movea.l 11082 <DOSBase>,a6
  d4:	4eae ffc4      	jsr -60(a6)
  d8:	2c79 0001 1082 	movea.l 11082 <DOSBase>,a6
  de:	2200           	move.l d0,d1
  e0:	243c 0000 1029 	move.l #4137,d2
  e6:	760f           	moveq #15,d3
  e8:	4eae ffd0      	jsr -48(a6)

	warpmode(1);
  ec:	4878 0001      	pea 1 <_start+0x1>
  f0:	45f9 0000 0bbe 	lea bbe <warpmode>,a2
  f6:	4e92           	jsr (a2)
	warpmode(0);
  f8:	42a7           	clr.l -(sp)
  fa:	4e92           	jsr (a2)
    } //blitter busy wait
}

void TakeSystem(void)
{
    ActiView = GfxBase->ActiView; //store current view
  fc:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
 102:	23ee 0022 0001 	move.l 34(a6),11068 <ActiView>
 108:	1068 
    OwnBlitter();
 10a:	4eae fe38      	jsr -456(a6)
    WaitBlit();
 10e:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
 114:	4eae ff1c      	jsr -228(a6)
    Disable();
 118:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
 11e:	4eae ff88      	jsr -120(a6)

    //Save current interrupts and DMA settings so we can restore them upon exit.
    SystemADKCON = custom->adkconr;
 122:	2479 0001 108a 	movea.l 1108a <custom>,a2
 128:	302a 0010      	move.w 16(a2),d0
 12c:	33c0 0001 106c 	move.w d0,1106c <SystemADKCON>
    SystemInts = custom->intenar;
 132:	302a 001c      	move.w 28(a2),d0
 136:	33c0 0001 1070 	move.w d0,11070 <SystemInts>
    SystemDMA = custom->dmaconr;
 13c:	302a 0002      	move.w 2(a2),d0
 140:	33c0 0001 106e 	move.w d0,1106e <SystemDMA>
    custom->intena = 0x7fff; //disable all interrupts
 146:	357c 7fff 009a 	move.w #32767,154(a2)
    custom->intreq = 0x7fff; //Clear any interrupts that were pending
 14c:	357c 7fff 009c 	move.w #32767,156(a2)

    WaitVbl();
 152:	4eb9 0000 0b06 	jsr b06 <WaitVbl>
    WaitVbl();
 158:	4eb9 0000 0b06 	jsr b06 <WaitVbl>
    custom->dmacon = 0x7fff; //Clear all DMA channels
 15e:	357c 7fff 0096 	move.w #32767,150(a2)
 164:	4fef 000c      	lea 12(sp),sp

    //set all colors black
    for (int a = 0; a < 32; a++)
 168:	7200           	moveq #0,d1
        custom->color[a] = 0;
 16a:	2001           	move.l d1,d0
 16c:	0680 0000 00c0 	addi.l #192,d0
 172:	d080           	add.l d0,d0
 174:	35bc 0000 0800 	move.w #0,(0,a2,d0.l)
    for (int a = 0; a < 32; a++)
 17a:	5281           	addq.l #1,d1
 17c:	7020           	moveq #32,d0
 17e:	b081           	cmp.l d1,d0
 180:	66e8           	bne.s 16a <main+0xf6>

    LoadView(0);
 182:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
 188:	93c9           	suba.l a1,a1
 18a:	4eae ff22      	jsr -222(a6)
    WaitTOF();
 18e:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
 194:	4eae fef2      	jsr -270(a6)
    WaitTOF();
 198:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
 19e:	4eae fef2      	jsr -270(a6)

    WaitVbl();
 1a2:	4eb9 0000 0b06 	jsr b06 <WaitVbl>
    WaitVbl();
 1a8:	4eb9 0000 0b06 	jsr b06 <WaitVbl>
    UWORD getvbr[] = {0x4e7a, 0x0801, 0x4e73}; // MOVEC.L VBR,D0 RTE
 1ae:	3f7c 4e7a 006a 	move.w #20090,106(sp)
 1b4:	3f7c 0801 006c 	move.w #2049,108(sp)
 1ba:	3f7c 4e73 006e 	move.w #20083,110(sp)
    if (SysBase->AttnFlags & AFF_68010)
 1c0:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
 1c6:	082e 0000 0129 	btst #0,297(a6)
 1cc:	6700 0908      	beq.w ad6 <main+0xa62>
        vbr = (APTR)Supervisor((ULONG(*)())getvbr);
 1d0:	7e6a           	moveq #106,d7
 1d2:	de8f           	add.l sp,d7
 1d4:	cf8d           	exg d7,a5
 1d6:	4eae ffe2      	jsr -30(a6)
 1da:	cf8d           	exg d7,a5

    VBR = GetVBR();
 1dc:	23c0 0001 1072 	move.l d0,11072 <VBR>
    return *(volatile APTR *)(((UBYTE *)VBR) + 0x6c);
 1e2:	2079 0001 1072 	movea.l 11072 <VBR>,a0
 1e8:	2028 006c      	move.l 108(a0),d0
    SystemIrq = GetInterruptHandler(); //store interrupt register
 1ec:	23c0 0001 1076 	move.l d0,11076 <SystemIrq>

	TakeSystem();
	// TODO: precalc stuff here
	copper1 = AllocMem(1024, MEMF_CHIP);
 1f2:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
 1f8:	203c 0000 0400 	move.l #1024,d0
 1fe:	7202           	moveq #2,d1
 200:	4eae ff3a      	jsr -198(a6)
 204:	2440           	movea.l d0,a2
 206:	23c0 0001 1064 	move.l d0,11064 <copper1>
	copPtr = copper1;
 20c:	23c0 0001 1060 	move.l d0,11060 <copPtr>
	return RETURN_OK;
}

void InitImagePlanes(ImageContainer *img)
{
	for (int p = 0; p < img->Depth; p++)
 212:	3279 0000 2008 	movea.w 2008 <bmpDisplay+0x8>,a1
 218:	b2fc 0000      	cmpa.w #0,a1
 21c:	6f00 0098      	ble.w 2b6 <main+0x242>
	{
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 220:	2079 0000 200c 	movea.l 200c <bmpDisplay+0xc>,a0
 226:	4241           	clr.w d1
 228:	1239 0000 200a 	move.b 200a <bmpDisplay+0xa>,d1
 22e:	c3f9 0000 2006 	muls.w 2006 <bmpDisplay+0x6>,d1
 234:	23c8 0000 2010 	move.l a0,2010 <bmpDisplay+0x10>
	for (int p = 0; p < img->Depth; p++)
 23a:	7401           	moveq #1,d2
 23c:	b489           	cmp.l a1,d2
 23e:	6776           	beq.s 2b6 <main+0x242>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 240:	47f0 1800      	lea (0,a0,d1.l),a3
 244:	23cb 0000 2014 	move.l a3,2014 <bmpDisplay+0x14>
	for (int p = 0; p < img->Depth; p++)
 24a:	7002           	moveq #2,d0
 24c:	b089           	cmp.l a1,d0
 24e:	6766           	beq.s 2b6 <main+0x242>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 250:	2001           	move.l d1,d0
 252:	d081           	add.l d1,d0
 254:	47f0 0800      	lea (0,a0,d0.l),a3
 258:	23cb 0000 2018 	move.l a3,2018 <bmpDisplay+0x18>
	for (int p = 0; p < img->Depth; p++)
 25e:	7403           	moveq #3,d2
 260:	b489           	cmp.l a1,d2
 262:	6752           	beq.s 2b6 <main+0x242>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 264:	d081           	add.l d1,d0
 266:	47f0 0800      	lea (0,a0,d0.l),a3
 26a:	23cb 0000 201c 	move.l a3,201c <bmpDisplay+0x1c>
	for (int p = 0; p < img->Depth; p++)
 270:	7404           	moveq #4,d2
 272:	b489           	cmp.l a1,d2
 274:	6740           	beq.s 2b6 <main+0x242>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 276:	d081           	add.l d1,d0
 278:	47f0 0800      	lea (0,a0,d0.l),a3
 27c:	23cb 0000 2020 	move.l a3,2020 <bmpDisplay+0x20>
	for (int p = 0; p < img->Depth; p++)
 282:	7405           	moveq #5,d2
 284:	b489           	cmp.l a1,d2
 286:	672e           	beq.s 2b6 <main+0x242>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 288:	d081           	add.l d1,d0
 28a:	47f0 0800      	lea (0,a0,d0.l),a3
 28e:	23cb 0000 2024 	move.l a3,2024 <bmpDisplay+0x24>
	for (int p = 0; p < img->Depth; p++)
 294:	7406           	moveq #6,d2
 296:	b489           	cmp.l a1,d2
 298:	671c           	beq.s 2b6 <main+0x242>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 29a:	d081           	add.l d1,d0
 29c:	47f0 0800      	lea (0,a0,d0.l),a3
 2a0:	23cb 0000 2028 	move.l a3,2028 <bmpDisplay+0x28>
	for (int p = 0; p < img->Depth; p++)
 2a6:	7407           	moveq #7,d2
 2a8:	b489           	cmp.l a1,d2
 2aa:	670a           	beq.s 2b6 <main+0x242>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 2ac:	d081           	add.l d1,d0
 2ae:	d088           	add.l a0,d0
 2b0:	23c0 0000 202c 	move.l d0,202c <bmpDisplay+0x2c>
	for (int p = 0; p < img->Depth; p++)
 2b6:	3439 0000 2038 	move.w 2038 <bmpDraw+0x8>,d2
 2bc:	3c02           	move.w d2,d6
 2be:	48c6           	ext.l d6
 2c0:	4a42           	tst.w d2
 2c2:	6f00 0098      	ble.w 35c <main+0x2e8>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 2c6:	2079 0000 203c 	movea.l 203c <bmpDraw+0xc>,a0
 2cc:	4241           	clr.w d1
 2ce:	1239 0000 203a 	move.b 203a <bmpDraw+0xa>,d1
 2d4:	c3f9 0000 2036 	muls.w 2036 <bmpDraw+0x6>,d1
 2da:	23c8 0000 2040 	move.l a0,2040 <bmpDraw+0x10>
	for (int p = 0; p < img->Depth; p++)
 2e0:	7001           	moveq #1,d0
 2e2:	b086           	cmp.l d6,d0
 2e4:	6776           	beq.s 35c <main+0x2e8>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 2e6:	43f0 1800      	lea (0,a0,d1.l),a1
 2ea:	23c9 0000 2044 	move.l a1,2044 <bmpDraw+0x14>
	for (int p = 0; p < img->Depth; p++)
 2f0:	7002           	moveq #2,d0
 2f2:	b086           	cmp.l d6,d0
 2f4:	6766           	beq.s 35c <main+0x2e8>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 2f6:	2001           	move.l d1,d0
 2f8:	d081           	add.l d1,d0
 2fa:	43f0 0800      	lea (0,a0,d0.l),a1
 2fe:	23c9 0000 2048 	move.l a1,2048 <bmpDraw+0x18>
	for (int p = 0; p < img->Depth; p++)
 304:	7603           	moveq #3,d3
 306:	b686           	cmp.l d6,d3
 308:	6752           	beq.s 35c <main+0x2e8>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 30a:	d081           	add.l d1,d0
 30c:	43f0 0800      	lea (0,a0,d0.l),a1
 310:	23c9 0000 204c 	move.l a1,204c <bmpDraw+0x1c>
	for (int p = 0; p < img->Depth; p++)
 316:	7604           	moveq #4,d3
 318:	b686           	cmp.l d6,d3
 31a:	6740           	beq.s 35c <main+0x2e8>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 31c:	d081           	add.l d1,d0
 31e:	43f0 0800      	lea (0,a0,d0.l),a1
 322:	23c9 0000 2050 	move.l a1,2050 <bmpDraw+0x20>
	for (int p = 0; p < img->Depth; p++)
 328:	7605           	moveq #5,d3
 32a:	b686           	cmp.l d6,d3
 32c:	672e           	beq.s 35c <main+0x2e8>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 32e:	d081           	add.l d1,d0
 330:	43f0 0800      	lea (0,a0,d0.l),a1
 334:	23c9 0000 2054 	move.l a1,2054 <bmpDraw+0x24>
	for (int p = 0; p < img->Depth; p++)
 33a:	7606           	moveq #6,d3
 33c:	b686           	cmp.l d6,d3
 33e:	671c           	beq.s 35c <main+0x2e8>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 340:	d081           	add.l d1,d0
 342:	43f0 0800      	lea (0,a0,d0.l),a1
 346:	23c9 0000 2058 	move.l a1,2058 <bmpDraw+0x28>
	for (int p = 0; p < img->Depth; p++)
 34c:	7607           	moveq #7,d3
 34e:	b686           	cmp.l d6,d3
 350:	670a           	beq.s 35c <main+0x2e8>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
 352:	d081           	add.l d1,d0
 354:	d088           	add.l a0,d0
 356:	23c0 0000 205c 	move.l d0,205c <bmpDraw+0x2c>
	WaitVbl();
 35c:	4eb9 0000 0b06 	jsr b06 <WaitVbl>
    *copListEnd++ = offsetof(struct Custom, ddfstrt);
 362:	34bc 0092      	move.w #146,(a2)
    *copListEnd++ = fw;
 366:	357c 0038 0002 	move.w #56,2(a2)
    *copListEnd++ = offsetof(struct Custom, ddfstop);
 36c:	357c 0094 0004 	move.w #148,4(a2)
    *copListEnd++ = fw + (((width >> 4) - 1) << 3);
 372:	357c 00d0 0006 	move.w #208,6(a2)
    *copListEnd++ = offsetof(struct Custom, diwstrt);
 378:	357c 008e 0008 	move.w #142,8(a2)
    *copListEnd++ = x + (y << 8);
 37e:	357c 2c81 000a 	move.w #11393,10(a2)
    *copListEnd++ = offsetof(struct Custom, diwstop);
 384:	357c 0090 000c 	move.w #144,12(a2)
    *copListEnd++ = (xstop - 256) + ((ystop - 256) << 8);
 38a:	357c 2cc1 000e 	move.w #11457,14(a2)
	*copPtr++ = BPLCON0;
 390:	357c 0100 0010 	move.w #256,16(a2)
	*copPtr++ = (0 << 10) /*dual pf*/ | (1 << 9) /*color*/ | ((ScreenBpls) << 12) /*num bitplanes*/;
 396:	357c 3200 0012 	move.w #12800,18(a2)
	*copPtr++ = BPLCON1; //scrolling
 39c:	357c 0102 0014 	move.w #258,20(a2)
	*copPtr++ = 0;
 3a2:	426a 0016      	clr.w 22(a2)
	*copPtr++ = BPLCON2; //playfied priority
 3a6:	357c 0104 0018 	move.w #260,24(a2)
	*copPtr++ = 1 << 6;	 //0x24;			//Sprites have priority over playfields
 3ac:	357c 0040 001a 	move.w #64,26(a2)
	*copPtr++ = BPL1MOD; //odd planes   1,3,5
 3b2:	357c 0108 001c 	move.w #264,28(a2)
	*copPtr++ = 0;
 3b8:	426a 001e      	clr.w 30(a2)
	*copPtr++ = BPL2MOD; //even  planes 2,4
 3bc:	357c 010a 0020 	move.w #266,32(a2)
	*copPtr++ = 0;
 3c2:	426a 0022      	clr.w 34(a2)
        ULONG addr = (ULONG)planes[i];
 3c6:	2039 0000 2010 	move.l 2010 <bmpDisplay+0x10>,d0
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]);
 3cc:	357c 00e0 0024 	move.w #224,36(a2)
        *copListEnd++ = (UWORD)(addr >> 16);
 3d2:	2200           	move.l d0,d1
 3d4:	4241           	clr.w d1
 3d6:	4841           	swap d1
 3d8:	3541 0026      	move.w d1,38(a2)
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]) + 2;
 3dc:	357c 00e2 0028 	move.w #226,40(a2)
        *copListEnd++ = (UWORD)addr;
 3e2:	3540 002a      	move.w d0,42(a2)
        ULONG addr = (ULONG)planes[i];
 3e6:	2039 0000 2014 	move.l 2014 <bmpDisplay+0x14>,d0
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]);
 3ec:	357c 00e4 002c 	move.w #228,44(a2)
        *copListEnd++ = (UWORD)(addr >> 16);
 3f2:	2200           	move.l d0,d1
 3f4:	4241           	clr.w d1
 3f6:	4841           	swap d1
 3f8:	3541 002e      	move.w d1,46(a2)
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]) + 2;
 3fc:	357c 00e6 0030 	move.w #230,48(a2)
        *copListEnd++ = (UWORD)addr;
 402:	3540 0032      	move.w d0,50(a2)
        ULONG addr = (ULONG)planes[i];
 406:	2039 0000 2018 	move.l 2018 <bmpDisplay+0x18>,d0
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]);
 40c:	357c 00e8 0034 	move.w #232,52(a2)
        *copListEnd++ = (UWORD)(addr >> 16);
 412:	2200           	move.l d0,d1
 414:	4241           	clr.w d1
 416:	4841           	swap d1
 418:	3541 0036      	move.w d1,54(a2)
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]) + 2;
 41c:	357c 00ea 0038 	move.w #234,56(a2)
        *copListEnd++ = (UWORD)addr;
 422:	3540 003a      	move.w d0,58(a2)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 426:	357c 0180 003c 	move.w #384,60(a2)
    *copListCurrent++ = color;
 42c:	426a 003e      	clr.w 62(a2)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 430:	357c 0182 0040 	move.w #386,64(a2)
    *copListCurrent++ = color;
 436:	357c 0556 0042 	move.w #1366,66(a2)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 43c:	357c 0184 0044 	move.w #388,68(a2)
    *copListCurrent++ = color;
 442:	357c 0c95 0046 	move.w #3221,70(a2)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 448:	357c 0186 0048 	move.w #390,72(a2)
    *copListCurrent++ = color;
 44e:	357c 0ea6 004a 	move.w #3750,74(a2)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 454:	357c 0188 004c 	move.w #392,76(a2)
    *copListCurrent++ = color;
 45a:	357c 0432 004e 	move.w #1074,78(a2)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 460:	357c 018a 0050 	move.w #394,80(a2)
    *copListCurrent++ = color;
 466:	357c 0531 0052 	move.w #1329,82(a2)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 46c:	357c 018c 0054 	move.w #396,84(a2)
    *copListCurrent++ = color;
 472:	357c 0212 0056 	move.w #530,86(a2)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 478:	357c 018e 0058 	move.w #398,88(a2)
    *copListCurrent++ = color;
 47e:	357c 0881 005a 	move.w #2177,90(a2)
    *copListEnd++ = (i << 8) | 4 | 1; //bit 1 means wait. waits for vertical position x<<8, first raster stop position outside the left
 484:	357c d605 005c 	move.w #-10747,92(a2)
    *copListEnd++ = 0xfffe;
 48a:	357c fffe 005e 	move.w #-2,94(a2)
	*copPtr++ = BPL1MOD; //odd planes   1,3,5
 490:	357c 0108 0060 	move.w #264,96(a2)
	*copPtr++ = -2 * ScreenBpl;
 496:	357c ffb0 0062 	move.w #-80,98(a2)
	*copPtr++ = BPL2MOD; //even  planes 2,4
 49c:	357c 010a 0064 	move.w #266,100(a2)
	*copPtr++ = -2 * ScreenBpl;
 4a2:	357c ffb0 0066 	move.w #-80,102(a2)
    *copListEnd++ = (i << 8) | (x << 1) | 1; //bit 1 means wait. waits for vertical position x<<8, first raster stop position outside the left
 4a8:	357c fffd 0068 	move.w #-3,104(a2)
    *copListEnd++ = 0xfffe;
 4ae:	357c fffe 006a 	move.w #-2,106(a2)
 4b4:	41ea 006c      	lea 108(a2),a0
 4b8:	23c8 0001 1060 	move.l a0,11060 <copPtr>
	custom->cop1lc = (ULONG)copper1;
 4be:	2a79 0001 108a 	movea.l 1108a <custom>,a5
 4c4:	2b4a 0080      	move.l a2,128(a5)
	custom->dmacon = DMAF_BLITTER; //disable blitter dma for copjmp bug
 4c8:	3b7c 0040 0096 	move.w #64,150(a5)
	custom->copjmp1 = 0x7fff;	   //start coppper
 4ce:	3b7c 7fff 0088 	move.w #32767,136(a5)
	custom->dmacon = DMAF_SETCLR | DMAF_MASTER | DMAF_RASTER | DMAF_COPPER | DMAF_BLITTER;
 4d4:	3b7c 83c0 0096 	move.w #-31808,150(a5)
    *(volatile APTR *)(((UBYTE *)VBR) + 0x6c) = interrupt;
 4da:	2079 0001 1072 	movea.l 11072 <VBR>,a0
 4e0:	217c 0000 0adc 	move.l #2780,108(a0)
 4e6:	006c 
	custom->intena = (1 << INTB_SETCLR) | (1 << INTB_INTEN) | (1 << INTB_VERTB);
 4e8:	3b7c c020 009a 	move.w #-16352,154(a5)
	custom->intreq = 1 << INTB_VERTB; //reset vbl req
 4ee:	3b7c 0020 009c 	move.w #32,156(a5)
inline short MouseLeft() { return !((*(volatile UBYTE *)0xbfe001) & 64); }
 4f4:	1039 00bf e001 	move.b bfe001 <_end+0xbecf71>,d0
	while (!MouseLeft())
 4fa:	0800 0006      	btst #6,d0
 4fe:	6700 0418      	beq.w 918 <main+0x8a4>
 502:	2f79 0000 203c 	move.l 203c <bmpDraw+0xc>,88(sp)
 508:	0058 
 50a:	1039 0000 203a 	move.b 203a <bmpDraw+0xa>,d0
 510:	2079 0000 2044 	movea.l 2044 <bmpDraw+0x14>,a0
 516:	2279 0000 2050 	movea.l 2050 <bmpDraw+0x20>,a1
 51c:	2f79 0000 205c 	move.l 205c <bmpDraw+0x2c>,70(sp)
 522:	0046 

void SetPixel(ImageContainer bitmap, USHORT x, USHORT y, UBYTE col)
{
	USHORT xb = (x) / 8;
	UBYTE xo = 0x80 >> (x % 8);
	USHORT yb = y * bitmap.BytesPerRow;
 524:	4244           	clr.w d4
 526:	1800           	move.b d0,d4
 528:	3f44 004e      	move.w d4,78(sp)
 52c:	2f79 0000 2058 	move.l 2058 <bmpDraw+0x28>,62(sp)
 532:	003e 
 534:	2479 0000 204c 	movea.l 204c <bmpDraw+0x1c>,a2
 53a:	2679 0000 2040 	movea.l 2040 <bmpDraw+0x10>,a3
 540:	2879 0000 2054 	movea.l 2054 <bmpDraw+0x24>,a4
 546:	2c79 0000 2048 	movea.l 2048 <bmpDraw+0x18>,a6
	custom->bltdpt = bmpD.ImageData;
	custom->bltafwm = 0xffff;
	custom->bltalwm = 0xffff;
	custom->bltamod = 0;
	custom->bltdmod = 0;
	custom->bltsize = ((bmpS.Height * bmpS.Depth) << 6) + (bmpS.BytesPerRow / 2);
 54c:	3202           	move.w d2,d1
 54e:	c3f9 0000 2036 	muls.w 2036 <bmpDraw+0x6>,d1
 554:	ed49           	lsl.w #6,d1
 556:	e208           	lsr.b #1,d0
 558:	0240 00ff      	andi.w #255,d0
 55c:	d240           	add.w d0,d1
 55e:	3f41 005c      	move.w d1,92(sp)
	int x = 20;
 562:	7014           	moveq #20,d0
 564:	2f40 0054      	move.l d0,84(sp)
	UBYTE xo = 0x80 >> (x % 8);
 568:	2f4c 0062      	move.l a4,98(sp)
 56c:	2849           	movea.l a1,a4
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
 56e:	2039 00df f004 	move.l dff004 <_end+0xdedf74>,d0
 574:	2f40 006a      	move.l d0,106(sp)
        vpos &= 0x1ff00;
 578:	202f 006a      	move.l 106(sp),d0
 57c:	0280 0001 ff00 	andi.l #130816,d0
 582:	2f40 006a      	move.l d0,106(sp)
        if (vpos != (311 << 8))
 586:	202f 006a      	move.l 106(sp),d0
 58a:	0c80 0001 3700 	cmpi.l #79616,d0
 590:	67dc           	beq.s 56e <main+0x4fa>
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
 592:	2039 00df f004 	move.l dff004 <_end+0xdedf74>,d0
 598:	2f40 0066      	move.l d0,102(sp)
        vpos &= 0x1ff00;
 59c:	202f 0066      	move.l 102(sp),d0
 5a0:	0280 0001 ff00 	andi.l #130816,d0
 5a6:	2f40 0066      	move.l d0,102(sp)
        if (vpos == (311 << 8))
 5aa:	202f 0066      	move.l 102(sp),d0
 5ae:	0c80 0001 3700 	cmpi.l #79616,d0
 5b4:	66dc           	bne.s 592 <main+0x51e>
		CopyBitmap(bmpDraw, bmpDisplay);
 5b6:	2239 0000 200c 	move.l 200c <bmpDisplay+0xc>,d1
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
 5bc:	302d 0002      	move.w 2(a5),d0
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
 5c0:	302d 0002      	move.w 2(a5),d0
 5c4:	0800 000e      	btst #14,d0
 5c8:	66f6           	bne.s 5c0 <main+0x54c>
	custom->bltcon0 = 0x09f0;
 5ca:	3b7c 09f0 0040 	move.w #2544,64(a5)
	custom->bltcon1 = 0x0000;
 5d0:	3b7c 0000 0042 	move.w #0,66(a5)
	custom->bltapt = bmpS.ImageData;
 5d6:	2b6f 0058 0050 	move.l 88(sp),80(a5)
	custom->bltdpt = bmpD.ImageData;
 5dc:	2b41 0054      	move.l d1,84(a5)
	custom->bltafwm = 0xffff;
 5e0:	3b7c ffff 0044 	move.w #-1,68(a5)
	custom->bltalwm = 0xffff;
 5e6:	3b7c ffff 0046 	move.w #-1,70(a5)
	custom->bltamod = 0;
 5ec:	3b7c 0000 0064 	move.w #0,100(a5)
	custom->bltdmod = 0;
 5f2:	3b7c 0000 0066 	move.w #0,102(a5)
	custom->bltsize = ((bmpS.Height * bmpS.Depth) << 6) + (bmpS.BytesPerRow / 2);
 5f8:	3b6f 005c 0058 	move.w 92(sp),88(a5)
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
 5fe:	302d 0002      	move.w 2(a5),d0
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
 602:	302d 0002      	move.w 2(a5),d0
 606:	0800 000e      	btst #14,d0
 60a:	66f6           	bne.s 602 <main+0x58e>

void ClearBitmap(ImageContainer bmpD)
{
	WaitBlt();

	custom->bltcon0 = 0x0900;
 60c:	3b7c 0900 0040 	move.w #2304,64(a5)
	custom->bltcon1 = 0x0000;
 612:	3b7c 0000 0042 	move.w #0,66(a5)
	custom->bltapt = bmpD.ImageData;
 618:	2b6f 0058 0050 	move.l 88(sp),80(a5)
	custom->bltdpt = bmpD.ImageData;
 61e:	2b6f 0058 0054 	move.l 88(sp),84(a5)
	custom->bltafwm = 0xffff;
 624:	3b7c ffff 0044 	move.w #-1,68(a5)
	custom->bltalwm = 0xffff;
 62a:	3b7c ffff 0046 	move.w #-1,70(a5)
	custom->bltamod = 0;
 630:	3b7c 0000 0064 	move.w #0,100(a5)
	custom->bltdmod = 0;
 636:	3b7c 0000 0066 	move.w #0,102(a5)
	custom->bltsize = ((bmpD.Height * bmpD.Depth) << 6) + (bmpD.BytesPerRow / 2);
 63c:	3b6f 005c 0058 	move.w 92(sp),88(a5)
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
 642:	302d 0002      	move.w 2(a5),d0
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
 646:	302d 0002      	move.w 2(a5),d0
 64a:	0800 000e      	btst #14,d0
 64e:	66f6           	bne.s 646 <main+0x5d2>
		SetPixel(bitmap, xm + dx, ym + dy, col);
 650:	3f6f 0056 0044 	move.w 86(sp),68(sp)
	long err = b2 - (2 * b - 1) * a2, e2; /* Fehler im 1. Schritt */
 656:	2f7c ffff c4a0 	move.l #-15200,58(sp)
 65c:	003a 
	int dx = 0, dy = b; /* im I. Quadranten von links oben nach rechts unten */
 65e:	7214           	moveq #20,d1
 660:	2f41 0036      	move.l d1,54(sp)
 664:	7a00           	moveq #0,d5
 666:	342f 0044      	move.w 68(sp),d2
 66a:	0642 0014      	addi.w #20,d2
 66e:	3f42 0052      	move.w d2,82(sp)
 672:	7628           	moveq #40,d3
 674:	2f43 004a      	move.l d3,74(sp)
 678:	2f4d 005e      	move.l a5,94(sp)
 67c:	2a6f 0062      	movea.l 98(sp),a5
		SetPixel(bitmap, xm + dx, ym + dy, col);
 680:	3f6f 0038 0042 	move.w 56(sp),66(sp)
 686:	3f45 0034      	move.w d5,52(sp)
 68a:	302f 0044      	move.w 68(sp),d0
 68e:	d045           	add.w d5,d0
	USHORT xb = (x) / 8;
 690:	3800           	move.w d0,d4
 692:	e64c           	lsr.w #3,d4
	UBYTE xo = 0x80 >> (x % 8);
 694:	7207           	moveq #7,d1
 696:	c081           	and.l d1,d0
 698:	7e7f           	moveq #127,d7
 69a:	4607           	not.b d7
 69c:	e0a7           	asr.l d0,d7
	USHORT yb = y * bitmap.BytesPerRow;
 69e:	302f 0052      	move.w 82(sp),d0
 6a2:	c1ef 004e      	muls.w 78(sp),d0
	for (int pl = 0; pl < bitmap.Depth; pl++)
 6a6:	4a86           	tst.l d6
 6a8:	6f00 01c4      	ble.w 86e <main+0x7fa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 6ac:	0280 0000 ffff 	andi.l #65535,d0
 6b2:	0284 0000 ffff 	andi.l #65535,d4
 6b8:	2f44 002c      	move.l d4,44(sp)
 6bc:	2204           	move.l d4,d1
 6be:	d280           	add.l d0,d1
 6c0:	1407           	move.b d7,d2
 6c2:	4602           	not.b d2
 6c4:	c533 1800      	and.b d2,(0,a3,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 6c8:	7601           	moveq #1,d3
 6ca:	b686           	cmp.l d6,d3
 6cc:	6750           	beq.s 71e <main+0x6aa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 6ce:	1602           	move.b d2,d3
 6d0:	c630 1800      	and.b (0,a0,d1.l),d3
			bitmap.Planes[pl][yb + xb] |= xo;
 6d4:	8607           	or.b d7,d3
 6d6:	1183 1800      	move.b d3,(0,a0,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 6da:	7602           	moveq #2,d3
 6dc:	b686           	cmp.l d6,d3
 6de:	673e           	beq.s 71e <main+0x6aa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 6e0:	c536 1800      	and.b d2,(0,a6,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 6e4:	7803           	moveq #3,d4
 6e6:	b886           	cmp.l d6,d4
 6e8:	6734           	beq.s 71e <main+0x6aa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 6ea:	c532 1800      	and.b d2,(0,a2,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 6ee:	7604           	moveq #4,d3
 6f0:	b686           	cmp.l d6,d3
 6f2:	672a           	beq.s 71e <main+0x6aa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 6f4:	c534 1800      	and.b d2,(0,a4,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 6f8:	7805           	moveq #5,d4
 6fa:	b886           	cmp.l d6,d4
 6fc:	6720           	beq.s 71e <main+0x6aa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 6fe:	c535 1800      	and.b d2,(0,a5,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 702:	7606           	moveq #6,d3
 704:	b686           	cmp.l d6,d3
 706:	6716           	beq.s 71e <main+0x6aa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 708:	226f 003e      	movea.l 62(sp),a1
 70c:	c531 1800      	and.b d2,(0,a1,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 710:	7607           	moveq #7,d3
 712:	b686           	cmp.l d6,d3
 714:	6708           	beq.s 71e <main+0x6aa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 716:	226f 0046      	movea.l 70(sp),a1
 71a:	c531 1800      	and.b d2,(0,a1,d1.l)
		SetPixel(bitmap, xm - dx, ym + dy, col);
 71e:	362f 0044      	move.w 68(sp),d3
 722:	966f 0034      	sub.w 52(sp),d3
	USHORT xb = (x) / 8;
 726:	3203           	move.w d3,d1
 728:	e649           	lsr.w #3,d1
	UBYTE xo = 0x80 >> (x % 8);
 72a:	7807           	moveq #7,d4
 72c:	c684           	and.l d4,d3
 72e:	787f           	moveq #127,d4
 730:	4604           	not.b d4
 732:	e6a4           	asr.l d3,d4
 734:	2f44 0030      	move.l d4,48(sp)
		bitmap.Planes[pl][yb + xb] &= ~xo;
 738:	0281 0000 ffff 	andi.l #65535,d1
 73e:	d081           	add.l d1,d0
 740:	1604           	move.b d4,d3
 742:	4603           	not.b d3
 744:	c733 0800      	and.b d3,(0,a3,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 748:	7801           	moveq #1,d4
 74a:	b886           	cmp.l d6,d4
 74c:	6752           	beq.s 7a0 <main+0x72c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 74e:	1803           	move.b d3,d4
 750:	c830 0800      	and.b (0,a0,d0.l),d4
			bitmap.Planes[pl][yb + xb] |= xo;
 754:	882f 0033      	or.b 51(sp),d4
 758:	1184 0800      	move.b d4,(0,a0,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 75c:	7802           	moveq #2,d4
 75e:	b886           	cmp.l d6,d4
 760:	673e           	beq.s 7a0 <main+0x72c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 762:	c736 0800      	and.b d3,(0,a6,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 766:	7803           	moveq #3,d4
 768:	b886           	cmp.l d6,d4
 76a:	6734           	beq.s 7a0 <main+0x72c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 76c:	c732 0800      	and.b d3,(0,a2,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 770:	7804           	moveq #4,d4
 772:	b886           	cmp.l d6,d4
 774:	672a           	beq.s 7a0 <main+0x72c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 776:	c734 0800      	and.b d3,(0,a4,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 77a:	7805           	moveq #5,d4
 77c:	b886           	cmp.l d6,d4
 77e:	6720           	beq.s 7a0 <main+0x72c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 780:	c735 0800      	and.b d3,(0,a5,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 784:	7806           	moveq #6,d4
 786:	b886           	cmp.l d6,d4
 788:	6716           	beq.s 7a0 <main+0x72c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 78a:	226f 003e      	movea.l 62(sp),a1
 78e:	c731 0800      	and.b d3,(0,a1,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 792:	7807           	moveq #7,d4
 794:	b886           	cmp.l d6,d4
 796:	6708           	beq.s 7a0 <main+0x72c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 798:	226f 0046      	movea.l 70(sp),a1
 79c:	c731 0800      	and.b d3,(0,a1,d0.l)
		SetPixel(bitmap, xm - dx, ym - dy, col);
 7a0:	302f 0044      	move.w 68(sp),d0
 7a4:	906f 0042      	sub.w 66(sp),d0
	USHORT yb = y * bitmap.BytesPerRow;
 7a8:	c1ef 004e      	muls.w 78(sp),d0
		bitmap.Planes[pl][yb + xb] &= ~xo;
 7ac:	0280 0000 ffff 	andi.l #65535,d0
 7b2:	d280           	add.l d0,d1
 7b4:	c733 1800      	and.b d3,(0,a3,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 7b8:	7801           	moveq #1,d4
 7ba:	b886           	cmp.l d6,d4
 7bc:	6752           	beq.s 810 <main+0x79c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 7be:	1803           	move.b d3,d4
 7c0:	c830 1800      	and.b (0,a0,d1.l),d4
			bitmap.Planes[pl][yb + xb] |= xo;
 7c4:	882f 0033      	or.b 51(sp),d4
 7c8:	1184 1800      	move.b d4,(0,a0,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 7cc:	7802           	moveq #2,d4
 7ce:	b886           	cmp.l d6,d4
 7d0:	673e           	beq.s 810 <main+0x79c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 7d2:	c736 1800      	and.b d3,(0,a6,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 7d6:	7803           	moveq #3,d4
 7d8:	b886           	cmp.l d6,d4
 7da:	6734           	beq.s 810 <main+0x79c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 7dc:	c732 1800      	and.b d3,(0,a2,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 7e0:	7804           	moveq #4,d4
 7e2:	b886           	cmp.l d6,d4
 7e4:	672a           	beq.s 810 <main+0x79c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 7e6:	c734 1800      	and.b d3,(0,a4,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 7ea:	7805           	moveq #5,d4
 7ec:	b886           	cmp.l d6,d4
 7ee:	6720           	beq.s 810 <main+0x79c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 7f0:	c735 1800      	and.b d3,(0,a5,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 7f4:	7806           	moveq #6,d4
 7f6:	b886           	cmp.l d6,d4
 7f8:	6716           	beq.s 810 <main+0x79c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 7fa:	226f 003e      	movea.l 62(sp),a1
 7fe:	c731 1800      	and.b d3,(0,a1,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 802:	7807           	moveq #7,d4
 804:	b886           	cmp.l d6,d4
 806:	6708           	beq.s 810 <main+0x79c>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 808:	226f 0046      	movea.l 70(sp),a1
 80c:	c731 1800      	and.b d3,(0,a1,d1.l)
 810:	d0af 002c      	add.l 44(sp),d0
 814:	c533 0800      	and.b d2,(0,a3,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 818:	7801           	moveq #1,d4
 81a:	b886           	cmp.l d6,d4
 81c:	6750           	beq.s 86e <main+0x7fa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 81e:	1202           	move.b d2,d1
 820:	c230 0800      	and.b (0,a0,d0.l),d1
			bitmap.Planes[pl][yb + xb] |= xo;
 824:	8207           	or.b d7,d1
 826:	1181 0800      	move.b d1,(0,a0,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 82a:	7202           	moveq #2,d1
 82c:	b286           	cmp.l d6,d1
 82e:	673e           	beq.s 86e <main+0x7fa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 830:	c536 0800      	and.b d2,(0,a6,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 834:	7603           	moveq #3,d3
 836:	b686           	cmp.l d6,d3
 838:	6734           	beq.s 86e <main+0x7fa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 83a:	c532 0800      	and.b d2,(0,a2,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 83e:	7804           	moveq #4,d4
 840:	b886           	cmp.l d6,d4
 842:	672a           	beq.s 86e <main+0x7fa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 844:	c534 0800      	and.b d2,(0,a4,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 848:	7205           	moveq #5,d1
 84a:	b286           	cmp.l d6,d1
 84c:	6720           	beq.s 86e <main+0x7fa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 84e:	c535 0800      	and.b d2,(0,a5,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 852:	7606           	moveq #6,d3
 854:	b686           	cmp.l d6,d3
 856:	6716           	beq.s 86e <main+0x7fa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 858:	226f 003e      	movea.l 62(sp),a1
 85c:	c531 0800      	and.b d2,(0,a1,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
 860:	7207           	moveq #7,d1
 862:	b286           	cmp.l d6,d1
 864:	6708           	beq.s 86e <main+0x7fa>
		bitmap.Planes[pl][yb + xb] &= ~xo;
 866:	226f 0046      	movea.l 70(sp),a1
 86a:	c531 0800      	and.b d2,(0,a1,d0.l)
		e2 = 2 * err;
 86e:	242f 003a      	move.l 58(sp),d2
 872:	d482           	add.l d2,d2
		if (e2 < (2 * dx + 1) * b2)
 874:	2205           	move.l d5,d1
 876:	d285           	add.l d5,d1
 878:	2241           	movea.l d1,a1
 87a:	5289           	addq.l #1,a1
 87c:	2009           	move.l a1,d0
 87e:	d089           	add.l a1,d0
 880:	d089           	add.l a1,d0
 882:	e788           	lsl.l #3,d0
 884:	d089           	add.l a1,d0
 886:	e988           	lsl.l #4,d0
 888:	b082           	cmp.l d2,d0
 88a:	6f14           	ble.s 8a0 <main+0x82c>
			dx++;
 88c:	5285           	addq.l #1,d5
			err += (2 * dx + 1) * b2;
 88e:	5681           	addq.l #3,d1
 890:	2001           	move.l d1,d0
 892:	d081           	add.l d1,d0
 894:	d081           	add.l d1,d0
 896:	e788           	lsl.l #3,d0
 898:	d280           	add.l d0,d1
 89a:	e989           	lsl.l #4,d1
 89c:	d3af 003a      	add.l d1,58(sp)
		if (e2 > -(2 * dy - 1) * a2)
 8a0:	7201           	moveq #1,d1
 8a2:	92af 004a      	sub.l 74(sp),d1
 8a6:	2001           	move.l d1,d0
 8a8:	d081           	add.l d1,d0
 8aa:	d081           	add.l d1,d0
 8ac:	e788           	lsl.l #3,d0
 8ae:	d081           	add.l d1,d0
 8b0:	e988           	lsl.l #4,d0
 8b2:	b082           	cmp.l d2,d0
 8b4:	6c3a           	bge.s 8f0 <main+0x87c>
			dy--;
 8b6:	53af 0036      	subq.l #1,54(sp)
			err -= (2 * dy - 1) * a2;
 8ba:	222f 004a      	move.l 74(sp),d1
 8be:	5781           	subq.l #3,d1
 8c0:	2001           	move.l d1,d0
 8c2:	d081           	add.l d1,d0
 8c4:	d081           	add.l d1,d0
 8c6:	e788           	lsl.l #3,d0
 8c8:	d081           	add.l d1,d0
 8ca:	e988           	lsl.l #4,d0
 8cc:	91af 003a      	sub.l d0,58(sp)
	} while (dy >= 0);
 8d0:	4aaf 0036      	tst.l 54(sp)
 8d4:	6d22           	blt.s 8f8 <main+0x884>
 8d6:	302f 0044      	move.w 68(sp),d0
 8da:	d06f 0038      	add.w 56(sp),d0
 8de:	3f40 0052      	move.w d0,82(sp)
 8e2:	222f 0036      	move.l 54(sp),d1
 8e6:	d281           	add.l d1,d1
 8e8:	2f41 004a      	move.l d1,74(sp)
 8ec:	6000 fd92      	bra.w 680 <main+0x60c>
 8f0:	4aaf 0036      	tst.l 54(sp)
 8f4:	6c00 fd8a      	bge.w 680 <main+0x60c>
		if(x< 150)x++;
 8f8:	2a6f 005e      	movea.l 94(sp),a5
 8fc:	0caf 0000 0095 	cmpi.l #149,84(sp)
 902:	0054 
 904:	6e04           	bgt.s 90a <main+0x896>
 906:	52af 0054      	addq.l #1,84(sp)
inline short MouseLeft() { return !((*(volatile UBYTE *)0xbfe001) & 64); }
 90a:	1039 00bf e001 	move.b bfe001 <_end+0xbecf71>,d0
	while (!MouseLeft())
 910:	0800 0006      	btst #6,d0
 914:	6600 fc58      	bne.w 56e <main+0x4fa>
}

void FreeSystem(void)
{
    WaitVbl();
 918:	4eb9 0000 0b06 	jsr b06 <WaitVbl>
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
 91e:	302d 0002      	move.w 2(a5),d0
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
 922:	302d 0002      	move.w 2(a5),d0
 926:	0800 000e      	btst #14,d0
 92a:	66f6           	bne.s 922 <main+0x8ae>
    WaitBlt();
    custom->intena = 0x7fff; //disable all interrupts
 92c:	3b7c 7fff 009a 	move.w #32767,154(a5)
    custom->intreq = 0x7fff; //Clear any interrupts that were pending
 932:	3b7c 7fff 009c 	move.w #32767,156(a5)
    custom->dmacon = 0x7fff; //Clear all DMA channels
 938:	3b7c 7fff 0096 	move.w #32767,150(a5)
    *(volatile APTR *)(((UBYTE *)VBR) + 0x6c) = interrupt;
 93e:	2079 0001 1072 	movea.l 11072 <VBR>,a0
 944:	2179 0001 1076 	move.l 11076 <SystemIrq>,108(a0)
 94a:	006c 

    //restore interrupts
    SetInterruptHandler(SystemIrq);

    /*Restore system copper list(s). */
    custom->cop1lc = (ULONG)GfxBase->copinit;
 94c:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
 952:	2b6e 0026 0080 	move.l 38(a6),128(a5)
    custom->cop2lc = (ULONG)GfxBase->LOFlist;
 958:	2b6e 0032 0084 	move.l 50(a6),132(a5)
    custom->copjmp1 = 0x7fff; //start coppper
 95e:	3b7c 7fff 0088 	move.w #32767,136(a5)

    /*Restore all interrupts and DMA settings. */
    custom->intena = SystemInts | 0x8000;
 964:	3039 0001 1070 	move.w 11070 <SystemInts>,d0
 96a:	0040 8000      	ori.w #-32768,d0
 96e:	3b40 009a      	move.w d0,154(a5)
    custom->dmacon = SystemDMA | 0x8000;
 972:	3039 0001 106e 	move.w 1106e <SystemDMA>,d0
 978:	0040 8000      	ori.w #-32768,d0
 97c:	3b40 0096      	move.w d0,150(a5)
    custom->adkcon = SystemADKCON | 0x8000;
 980:	3039 0001 106c 	move.w 1106c <SystemADKCON>,d0
 986:	0040 8000      	ori.w #-32768,d0
 98a:	3b40 009e      	move.w d0,158(a5)

    LoadView(ActiView);
 98e:	2279 0001 1068 	movea.l 11068 <ActiView>,a1
 994:	4eae ff22      	jsr -222(a6)
    WaitTOF();
 998:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
 99e:	4eae fef2      	jsr -270(a6)
    WaitTOF();
 9a2:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
 9a8:	4eae fef2      	jsr -270(a6)
    WaitBlit();
 9ac:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
 9b2:	4eae ff1c      	jsr -228(a6)
    DisownBlitter();
 9b6:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
 9bc:	4eae fe32      	jsr -462(a6)
    Enable();
 9c0:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
 9c6:	4eae ff82      	jsr -126(a6)
	CloseLibrary((struct Library *)DOSBase);
 9ca:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
 9d0:	2279 0001 1082 	movea.l 11082 <DOSBase>,a1
 9d6:	4eae fe62      	jsr -414(a6)
	CloseLibrary((struct Library *)GfxBase);
 9da:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
 9e0:	2279 0001 107a 	movea.l 1107a <GfxBase>,a1
 9e6:	4eae fe62      	jsr -414(a6)
}
 9ea:	7000           	moveq #0,d0
 9ec:	4cdf 7cfc      	movem.l (sp)+,d2-d7/a2-a6
 9f0:	4fef 0044      	lea 68(sp),sp
 9f4:	4e75           	rts
		Exit(0);
 9f6:	9dce           	suba.l a6,a6
 9f8:	7200           	moveq #0,d1
 9fa:	4eae ff70      	jsr -144(a6)
	KPrintF("Hello debugger from Amiga!\n");
 9fe:	4879 0000 100d 	pea 100d <PutChar+0x69>
 a04:	4eb9 0000 0b4c 	jsr b4c <KPrintF>
	Write(Output(), (APTR) "Hello console!\n", 15);
 a0a:	2c79 0001 1082 	movea.l 11082 <DOSBase>,a6
 a10:	4eae ffc4      	jsr -60(a6)
 a14:	2c79 0001 1082 	movea.l 11082 <DOSBase>,a6
 a1a:	2200           	move.l d0,d1
 a1c:	243c 0000 1029 	move.l #4137,d2
 a22:	760f           	moveq #15,d3
 a24:	4eae ffd0      	jsr -48(a6)
	warpmode(1);
 a28:	4878 0001      	pea 1 <_start+0x1>
 a2c:	45f9 0000 0bbe 	lea bbe <warpmode>,a2
 a32:	4e92           	jsr (a2)
	warpmode(0);
 a34:	42a7           	clr.l -(sp)
 a36:	4e92           	jsr (a2)
    ActiView = GfxBase->ActiView; //store current view
 a38:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
 a3e:	23ee 0022 0001 	move.l 34(a6),11068 <ActiView>
 a44:	1068 
    OwnBlitter();
 a46:	4eae fe38      	jsr -456(a6)
    WaitBlit();
 a4a:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
 a50:	4eae ff1c      	jsr -228(a6)
    Disable();
 a54:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
 a5a:	4eae ff88      	jsr -120(a6)
    SystemADKCON = custom->adkconr;
 a5e:	2479 0001 108a 	movea.l 1108a <custom>,a2
 a64:	302a 0010      	move.w 16(a2),d0
 a68:	33c0 0001 106c 	move.w d0,1106c <SystemADKCON>
    SystemInts = custom->intenar;
 a6e:	302a 001c      	move.w 28(a2),d0
 a72:	33c0 0001 1070 	move.w d0,11070 <SystemInts>
    SystemDMA = custom->dmaconr;
 a78:	302a 0002      	move.w 2(a2),d0
 a7c:	33c0 0001 106e 	move.w d0,1106e <SystemDMA>
    custom->intena = 0x7fff; //disable all interrupts
 a82:	357c 7fff 009a 	move.w #32767,154(a2)
    custom->intreq = 0x7fff; //Clear any interrupts that were pending
 a88:	357c 7fff 009c 	move.w #32767,156(a2)
    WaitVbl();
 a8e:	4eb9 0000 0b06 	jsr b06 <WaitVbl>
    WaitVbl();
 a94:	4eb9 0000 0b06 	jsr b06 <WaitVbl>
    custom->dmacon = 0x7fff; //Clear all DMA channels
 a9a:	357c 7fff 0096 	move.w #32767,150(a2)
 aa0:	4fef 000c      	lea 12(sp),sp
    for (int a = 0; a < 32; a++)
 aa4:	7200           	moveq #0,d1
 aa6:	6000 f6c2      	bra.w 16a <main+0xf6>
		Exit(0);
 aaa:	2c79 0001 1082 	movea.l 11082 <DOSBase>,a6
 ab0:	7200           	moveq #0,d1
 ab2:	4eae ff70      	jsr -144(a6)
	DOSBase = (struct DosLibrary *)OpenLibrary((CONST_STRPTR) "dos.library", 0);
 ab6:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
 abc:	43f9 0000 1001 	lea 1001 <PutChar+0x5d>,a1
 ac2:	7000           	moveq #0,d0
 ac4:	4eae fdd8      	jsr -552(a6)
 ac8:	23c0 0001 1082 	move.l d0,11082 <DOSBase>
	if (!DOSBase)
 ace:	6600 f5f2      	bne.w c2 <main+0x4e>
 ad2:	6000 ff22      	bra.w 9f6 <main+0x982>
    APTR vbr = 0;
 ad6:	7000           	moveq #0,d0
 ad8:	6000 f702      	bra.w 1dc <main+0x168>

00000adc <interruptHandler>:
{
 adc:	2f08           	move.l a0,-(sp)
 ade:	2f00           	move.l d0,-(sp)
    custom->intreq = (1 << INTB_VERTB);
 ae0:	2079 0001 108a 	movea.l 1108a <custom>,a0
 ae6:	317c 0020 009c 	move.w #32,156(a0)
    custom->intreq = (1 << INTB_VERTB); //reset vbl req. twice for a4000 bug.
 aec:	317c 0020 009c 	move.w #32,156(a0)
    frameCounter++;
 af2:	2039 0001 1086 	move.l 11086 <frameCounter>,d0
 af8:	5280           	addq.l #1,d0
 afa:	23c0 0001 1086 	move.l d0,11086 <frameCounter>
}
 b00:	201f           	move.l (sp)+,d0
 b02:	205f           	movea.l (sp)+,a0
 b04:	4e73           	rte

00000b06 <WaitVbl>:
{
 b06:	518f           	subq.l #8,sp
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
 b08:	2039 00df f004 	move.l dff004 <_end+0xdedf74>,d0
 b0e:	2e80           	move.l d0,(sp)
        vpos &= 0x1ff00;
 b10:	2017           	move.l (sp),d0
 b12:	0280 0001 ff00 	andi.l #130816,d0
 b18:	2e80           	move.l d0,(sp)
        if (vpos != (311 << 8))
 b1a:	2017           	move.l (sp),d0
 b1c:	0c80 0001 3700 	cmpi.l #79616,d0
 b22:	67e4           	beq.s b08 <WaitVbl+0x2>
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
 b24:	2039 00df f004 	move.l dff004 <_end+0xdedf74>,d0
 b2a:	2f40 0004      	move.l d0,4(sp)
        vpos &= 0x1ff00;
 b2e:	202f 0004      	move.l 4(sp),d0
 b32:	0280 0001 ff00 	andi.l #130816,d0
 b38:	2f40 0004      	move.l d0,4(sp)
        if (vpos == (311 << 8))
 b3c:	202f 0004      	move.l 4(sp),d0
 b40:	0c80 0001 3700 	cmpi.l #79616,d0
 b46:	66dc           	bne.s b24 <WaitVbl+0x1e>
}
 b48:	508f           	addq.l #8,sp
 b4a:	4e75           	rts

00000b4c <KPrintF>:
{
 b4c:	4fef ff80      	lea -128(sp),sp
 b50:	48e7 0032      	movem.l a2-a3/a6,-(sp)
    if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
 b54:	3039 00f0 ff60 	move.w f0ff60 <_end+0xefeed0>,d0
 b5a:	0c40 4eb9      	cmpi.w #20153,d0
 b5e:	672a           	beq.s b8a <KPrintF+0x3e>
 b60:	0c40 a00e      	cmpi.w #-24562,d0
 b64:	6724           	beq.s b8a <KPrintF+0x3e>
		RawDoFmt((CONST_STRPTR)fmt, vl, KPutCharX, 0);
 b66:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
 b6c:	206f 0090      	movea.l 144(sp),a0
 b70:	43ef 0094      	lea 148(sp),a1
 b74:	45f9 0000 0f96 	lea f96 <KPutCharX>,a2
 b7a:	97cb           	suba.l a3,a3
 b7c:	4eae fdf6      	jsr -522(a6)
}
 b80:	4cdf 4c00      	movem.l (sp)+,a2-a3/a6
 b84:	4fef 0080      	lea 128(sp),sp
 b88:	4e75           	rts
		RawDoFmt((CONST_STRPTR)fmt, vl, PutChar, temp);
 b8a:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
 b90:	206f 0090      	movea.l 144(sp),a0
 b94:	43ef 0094      	lea 148(sp),a1
 b98:	45f9 0000 0fa4 	lea fa4 <PutChar>,a2
 b9e:	47ef 000c      	lea 12(sp),a3
 ba2:	4eae fdf6      	jsr -522(a6)
		UaeDbgLog(86, temp);
 ba6:	2f0b           	move.l a3,-(sp)
 ba8:	4878 0056      	pea 56 <_start+0x56>
 bac:	4eb9 00f0 ff60 	jsr f0ff60 <_end+0xefeed0>
 bb2:	508f           	addq.l #8,sp
}
 bb4:	4cdf 4c00      	movem.l (sp)+,a2-a3/a6
 bb8:	4fef 0080      	lea 128(sp),sp
 bbc:	4e75           	rts

00000bbe <warpmode>:

void warpmode(int on) // bool
{
 bbe:	598f           	subq.l #4,sp
 bc0:	2f02           	move.l d2,-(sp)
	long(*UaeConf)(long mode, int index, const char* param, int param_len, char* outbuf, int outbuf_len);
	UaeConf = (long(*)(long, int, const char*, int, char*, int))0xf0ff60;
    if(*((UWORD *)UaeConf) == 0x4eb9 || *((UWORD *)UaeConf) == 0xa00e) {
 bc2:	3039 00f0 ff60 	move.w f0ff60 <_end+0xefeed0>,d0
 bc8:	0c40 4eb9      	cmpi.w #20153,d0
 bcc:	670c           	beq.s bda <warpmode+0x1c>
 bce:	0c40 a00e      	cmpi.w #-24562,d0
 bd2:	6706           	beq.s bda <warpmode+0x1c>
		char outbuf;
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
	}
}
 bd4:	241f           	move.l (sp)+,d2
 bd6:	588f           	addq.l #4,sp
 bd8:	4e75           	rts
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
 bda:	4aaf 000c      	tst.l 12(sp)
 bde:	674c           	beq.s c2c <warpmode+0x6e>
 be0:	4878 0001      	pea 1 <_start+0x1>
 be4:	740b           	moveq #11,d2
 be6:	d48f           	add.l sp,d2
 be8:	2f02           	move.l d2,-(sp)
 bea:	42a7           	clr.l -(sp)
 bec:	4879 0000 0fe6 	pea fe6 <PutChar+0x42>
 bf2:	4878 ffff      	pea ffffffff <_end+0xfffeef6f>
 bf6:	4878 0052      	pea 52 <_start+0x52>
 bfa:	4eb9 00f0 ff60 	jsr f0ff60 <_end+0xefeed0>
 c00:	4fef 0018      	lea 24(sp),sp
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
 c04:	203c 0000 0fc1 	move.l #4033,d0
 c0a:	4878 0001      	pea 1 <_start+0x1>
 c0e:	2f02           	move.l d2,-(sp)
 c10:	42a7           	clr.l -(sp)
 c12:	2f00           	move.l d0,-(sp)
 c14:	4878 ffff      	pea ffffffff <_end+0xfffeef6f>
 c18:	4878 0052      	pea 52 <_start+0x52>
 c1c:	4eb9 00f0 ff60 	jsr f0ff60 <_end+0xefeed0>
 c22:	4fef 0018      	lea 24(sp),sp
}
 c26:	241f           	move.l (sp)+,d2
 c28:	588f           	addq.l #4,sp
 c2a:	4e75           	rts
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
 c2c:	4878 0001      	pea 1 <_start+0x1>
 c30:	740b           	moveq #11,d2
 c32:	d48f           	add.l sp,d2
 c34:	2f02           	move.l d2,-(sp)
 c36:	42a7           	clr.l -(sp)
 c38:	4879 0000 0fdb 	pea fdb <PutChar+0x37>
 c3e:	4878 ffff      	pea ffffffff <_end+0xfffeef6f>
 c42:	4878 0052      	pea 52 <_start+0x52>
 c46:	4eb9 00f0 ff60 	jsr f0ff60 <_end+0xefeed0>
 c4c:	4fef 0018      	lea 24(sp),sp
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
 c50:	203c 0000 0fa8 	move.l #4008,d0
 c56:	4878 0001      	pea 1 <_start+0x1>
 c5a:	2f02           	move.l d2,-(sp)
 c5c:	42a7           	clr.l -(sp)
 c5e:	2f00           	move.l d0,-(sp)
 c60:	4878 ffff      	pea ffffffff <_end+0xfffeef6f>
 c64:	4878 0052      	pea 52 <_start+0x52>
 c68:	4eb9 00f0 ff60 	jsr f0ff60 <_end+0xefeed0>
 c6e:	4fef 0018      	lea 24(sp),sp
 c72:	60b2           	bra.s c26 <warpmode+0x68>

00000c74 <strlen>:
{
 c74:	206f 0004      	movea.l 4(sp),a0
	unsigned long t=0;
 c78:	7000           	moveq #0,d0
	while(*s++)
 c7a:	4a10           	tst.b (a0)
 c7c:	6708           	beq.s c86 <strlen+0x12>
		t++;
 c7e:	5280           	addq.l #1,d0
	while(*s++)
 c80:	4a30 0800      	tst.b (0,a0,d0.l)
 c84:	66f8           	bne.s c7e <strlen+0xa>
}
 c86:	4e75           	rts

00000c88 <memset>:
{
 c88:	48e7 3f30      	movem.l d2-d7/a2-a3,-(sp)
 c8c:	202f 0024      	move.l 36(sp),d0
 c90:	282f 0028      	move.l 40(sp),d4
 c94:	226f 002c      	movea.l 44(sp),a1
	while(len-- > 0)
 c98:	2a09           	move.l a1,d5
 c9a:	5385           	subq.l #1,d5
 c9c:	b2fc 0000      	cmpa.w #0,a1
 ca0:	6700 00ae      	beq.w d50 <memset+0xc8>
		*ptr++ = val;
 ca4:	1e04           	move.b d4,d7
 ca6:	2200           	move.l d0,d1
 ca8:	4481           	neg.l d1
 caa:	7403           	moveq #3,d2
 cac:	c282           	and.l d2,d1
 cae:	7c05           	moveq #5,d6
 cb0:	2440           	movea.l d0,a2
 cb2:	bc85           	cmp.l d5,d6
 cb4:	646a           	bcc.s d20 <memset+0x98>
 cb6:	4a81           	tst.l d1
 cb8:	6724           	beq.s cde <memset+0x56>
 cba:	14c4           	move.b d4,(a2)+
	while(len-- > 0)
 cbc:	5385           	subq.l #1,d5
 cbe:	7401           	moveq #1,d2
 cc0:	b481           	cmp.l d1,d2
 cc2:	671a           	beq.s cde <memset+0x56>
		*ptr++ = val;
 cc4:	2440           	movea.l d0,a2
 cc6:	548a           	addq.l #2,a2
 cc8:	2040           	movea.l d0,a0
 cca:	1144 0001      	move.b d4,1(a0)
	while(len-- > 0)
 cce:	5385           	subq.l #1,d5
 cd0:	7403           	moveq #3,d2
 cd2:	b481           	cmp.l d1,d2
 cd4:	6608           	bne.s cde <memset+0x56>
		*ptr++ = val;
 cd6:	528a           	addq.l #1,a2
 cd8:	1144 0002      	move.b d4,2(a0)
	while(len-- > 0)
 cdc:	5385           	subq.l #1,d5
 cde:	2609           	move.l a1,d3
 ce0:	9681           	sub.l d1,d3
 ce2:	7c00           	moveq #0,d6
 ce4:	1c04           	move.b d4,d6
 ce6:	2406           	move.l d6,d2
 ce8:	4842           	swap d2
 cea:	4242           	clr.w d2
 cec:	2042           	movea.l d2,a0
 cee:	2404           	move.l d4,d2
 cf0:	e14a           	lsl.w #8,d2
 cf2:	4842           	swap d2
 cf4:	4242           	clr.w d2
 cf6:	e18e           	lsl.l #8,d6
 cf8:	2646           	movea.l d6,a3
 cfa:	2c08           	move.l a0,d6
 cfc:	8486           	or.l d6,d2
 cfe:	2c0b           	move.l a3,d6
 d00:	8486           	or.l d6,d2
 d02:	1407           	move.b d7,d2
 d04:	2040           	movea.l d0,a0
 d06:	d1c1           	adda.l d1,a0
 d08:	72fc           	moveq #-4,d1
 d0a:	c283           	and.l d3,d1
 d0c:	d288           	add.l a0,d1
		*ptr++ = val;
 d0e:	20c2           	move.l d2,(a0)+
	while(len-- > 0)
 d10:	b1c1           	cmpa.l d1,a0
 d12:	66fa           	bne.s d0e <memset+0x86>
 d14:	72fc           	moveq #-4,d1
 d16:	c283           	and.l d3,d1
 d18:	d5c1           	adda.l d1,a2
 d1a:	9a81           	sub.l d1,d5
 d1c:	b283           	cmp.l d3,d1
 d1e:	6730           	beq.s d50 <memset+0xc8>
		*ptr++ = val;
 d20:	1484           	move.b d4,(a2)
	while(len-- > 0)
 d22:	4a85           	tst.l d5
 d24:	672a           	beq.s d50 <memset+0xc8>
		*ptr++ = val;
 d26:	1544 0001      	move.b d4,1(a2)
	while(len-- > 0)
 d2a:	7201           	moveq #1,d1
 d2c:	b285           	cmp.l d5,d1
 d2e:	6720           	beq.s d50 <memset+0xc8>
		*ptr++ = val;
 d30:	1544 0002      	move.b d4,2(a2)
	while(len-- > 0)
 d34:	7402           	moveq #2,d2
 d36:	b485           	cmp.l d5,d2
 d38:	6716           	beq.s d50 <memset+0xc8>
		*ptr++ = val;
 d3a:	1544 0003      	move.b d4,3(a2)
	while(len-- > 0)
 d3e:	7c03           	moveq #3,d6
 d40:	bc85           	cmp.l d5,d6
 d42:	670c           	beq.s d50 <memset+0xc8>
		*ptr++ = val;
 d44:	1544 0004      	move.b d4,4(a2)
	while(len-- > 0)
 d48:	5985           	subq.l #4,d5
 d4a:	6704           	beq.s d50 <memset+0xc8>
		*ptr++ = val;
 d4c:	1544 0005      	move.b d4,5(a2)
}
 d50:	4cdf 0cfc      	movem.l (sp)+,d2-d7/a2-a3
 d54:	4e75           	rts

00000d56 <memcpy>:
{
 d56:	48e7 3e00      	movem.l d2-d6,-(sp)
 d5a:	202f 0018      	move.l 24(sp),d0
 d5e:	222f 001c      	move.l 28(sp),d1
 d62:	262f 0020      	move.l 32(sp),d3
	while(len--)
 d66:	2803           	move.l d3,d4
 d68:	5384           	subq.l #1,d4
 d6a:	4a83           	tst.l d3
 d6c:	675e           	beq.s dcc <memcpy+0x76>
 d6e:	2041           	movea.l d1,a0
 d70:	5288           	addq.l #1,a0
 d72:	2400           	move.l d0,d2
 d74:	9488           	sub.l a0,d2
 d76:	7a02           	moveq #2,d5
 d78:	ba82           	cmp.l d2,d5
 d7a:	55c2           	sc.s d2
 d7c:	4402           	neg.b d2
 d7e:	7c08           	moveq #8,d6
 d80:	bc84           	cmp.l d4,d6
 d82:	55c5           	sc.s d5
 d84:	4405           	neg.b d5
 d86:	c405           	and.b d5,d2
 d88:	6748           	beq.s dd2 <memcpy+0x7c>
 d8a:	2400           	move.l d0,d2
 d8c:	8481           	or.l d1,d2
 d8e:	7a03           	moveq #3,d5
 d90:	c485           	and.l d5,d2
 d92:	663e           	bne.s dd2 <memcpy+0x7c>
 d94:	2041           	movea.l d1,a0
 d96:	2240           	movea.l d0,a1
 d98:	74fc           	moveq #-4,d2
 d9a:	c483           	and.l d3,d2
 d9c:	d481           	add.l d1,d2
		*d++ = *s++;
 d9e:	22d8           	move.l (a0)+,(a1)+
	while(len--)
 da0:	b488           	cmp.l a0,d2
 da2:	66fa           	bne.s d9e <memcpy+0x48>
 da4:	74fc           	moveq #-4,d2
 da6:	c483           	and.l d3,d2
 da8:	2040           	movea.l d0,a0
 daa:	d1c2           	adda.l d2,a0
 dac:	d282           	add.l d2,d1
 dae:	9882           	sub.l d2,d4
 db0:	b483           	cmp.l d3,d2
 db2:	6718           	beq.s dcc <memcpy+0x76>
		*d++ = *s++;
 db4:	2241           	movea.l d1,a1
 db6:	1091           	move.b (a1),(a0)
	while(len--)
 db8:	4a84           	tst.l d4
 dba:	6710           	beq.s dcc <memcpy+0x76>
		*d++ = *s++;
 dbc:	1169 0001 0001 	move.b 1(a1),1(a0)
	while(len--)
 dc2:	5384           	subq.l #1,d4
 dc4:	6706           	beq.s dcc <memcpy+0x76>
		*d++ = *s++;
 dc6:	1169 0002 0002 	move.b 2(a1),2(a0)
}
 dcc:	4cdf 007c      	movem.l (sp)+,d2-d6
 dd0:	4e75           	rts
 dd2:	2240           	movea.l d0,a1
 dd4:	d283           	add.l d3,d1
		*d++ = *s++;
 dd6:	12e8 ffff      	move.b -1(a0),(a1)+
	while(len--)
 dda:	b288           	cmp.l a0,d1
 ddc:	67ee           	beq.s dcc <memcpy+0x76>
 dde:	5288           	addq.l #1,a0
 de0:	60f4           	bra.s dd6 <memcpy+0x80>

00000de2 <memmove>:
{
 de2:	48e7 3c20      	movem.l d2-d5/a2,-(sp)
 de6:	202f 0018      	move.l 24(sp),d0
 dea:	222f 001c      	move.l 28(sp),d1
 dee:	242f 0020      	move.l 32(sp),d2
		while (len--)
 df2:	2242           	movea.l d2,a1
 df4:	5389           	subq.l #1,a1
	if (d < s) {
 df6:	b280           	cmp.l d0,d1
 df8:	636c           	bls.s e66 <memmove+0x84>
		while (len--)
 dfa:	4a82           	tst.l d2
 dfc:	6762           	beq.s e60 <memmove+0x7e>
 dfe:	2441           	movea.l d1,a2
 e00:	528a           	addq.l #1,a2
 e02:	2600           	move.l d0,d3
 e04:	968a           	sub.l a2,d3
 e06:	7802           	moveq #2,d4
 e08:	b883           	cmp.l d3,d4
 e0a:	55c3           	sc.s d3
 e0c:	4403           	neg.b d3
 e0e:	7a08           	moveq #8,d5
 e10:	ba89           	cmp.l a1,d5
 e12:	55c4           	sc.s d4
 e14:	4404           	neg.b d4
 e16:	c604           	and.b d4,d3
 e18:	6770           	beq.s e8a <memmove+0xa8>
 e1a:	2600           	move.l d0,d3
 e1c:	8681           	or.l d1,d3
 e1e:	7803           	moveq #3,d4
 e20:	c684           	and.l d4,d3
 e22:	6666           	bne.s e8a <memmove+0xa8>
 e24:	2041           	movea.l d1,a0
 e26:	2440           	movea.l d0,a2
 e28:	76fc           	moveq #-4,d3
 e2a:	c682           	and.l d2,d3
 e2c:	d681           	add.l d1,d3
			*d++ = *s++;
 e2e:	24d8           	move.l (a0)+,(a2)+
		while (len--)
 e30:	b688           	cmp.l a0,d3
 e32:	66fa           	bne.s e2e <memmove+0x4c>
 e34:	76fc           	moveq #-4,d3
 e36:	c682           	and.l d2,d3
 e38:	2440           	movea.l d0,a2
 e3a:	d5c3           	adda.l d3,a2
 e3c:	2041           	movea.l d1,a0
 e3e:	d1c3           	adda.l d3,a0
 e40:	93c3           	suba.l d3,a1
 e42:	b682           	cmp.l d2,d3
 e44:	671a           	beq.s e60 <memmove+0x7e>
			*d++ = *s++;
 e46:	1490           	move.b (a0),(a2)
		while (len--)
 e48:	b2fc 0000      	cmpa.w #0,a1
 e4c:	6712           	beq.s e60 <memmove+0x7e>
			*d++ = *s++;
 e4e:	1568 0001 0001 	move.b 1(a0),1(a2)
		while (len--)
 e54:	7a01           	moveq #1,d5
 e56:	ba89           	cmp.l a1,d5
 e58:	6706           	beq.s e60 <memmove+0x7e>
			*d++ = *s++;
 e5a:	1568 0002 0002 	move.b 2(a0),2(a2)
}
 e60:	4cdf 043c      	movem.l (sp)+,d2-d5/a2
 e64:	4e75           	rts
		const char *lasts = s + (len - 1);
 e66:	41f1 1800      	lea (0,a1,d1.l),a0
		char *lastd = d + (len - 1);
 e6a:	d3c0           	adda.l d0,a1
		while (len--)
 e6c:	4a82           	tst.l d2
 e6e:	67f0           	beq.s e60 <memmove+0x7e>
 e70:	2208           	move.l a0,d1
 e72:	9282           	sub.l d2,d1
			*lastd-- = *lasts--;
 e74:	1290           	move.b (a0),(a1)
		while (len--)
 e76:	5388           	subq.l #1,a0
 e78:	5389           	subq.l #1,a1
 e7a:	b288           	cmp.l a0,d1
 e7c:	67e2           	beq.s e60 <memmove+0x7e>
			*lastd-- = *lasts--;
 e7e:	1290           	move.b (a0),(a1)
		while (len--)
 e80:	5388           	subq.l #1,a0
 e82:	5389           	subq.l #1,a1
 e84:	b288           	cmp.l a0,d1
 e86:	66ec           	bne.s e74 <memmove+0x92>
 e88:	60d6           	bra.s e60 <memmove+0x7e>
 e8a:	2240           	movea.l d0,a1
 e8c:	d282           	add.l d2,d1
			*d++ = *s++;
 e8e:	12ea ffff      	move.b -1(a2),(a1)+
		while (len--)
 e92:	b28a           	cmp.l a2,d1
 e94:	67ca           	beq.s e60 <memmove+0x7e>
 e96:	528a           	addq.l #1,a2
 e98:	60f4           	bra.s e8e <memmove+0xac>
 e9a:	4e71           	nop

00000e9c <__mulsi3>:
	.text
	FUNC(__mulsi3)
	.globl	SYM (__mulsi3)
SYM (__mulsi3):
	.cfi_startproc
	movew	sp@(4), d0	/* x0 -> d0 */
 e9c:	302f 0004      	move.w 4(sp),d0
	muluw	sp@(10), d0	/* x0*y1 */
 ea0:	c0ef 000a      	mulu.w 10(sp),d0
	movew	sp@(6), d1	/* x1 -> d1 */
 ea4:	322f 0006      	move.w 6(sp),d1
	muluw	sp@(8), d1	/* x1*y0 */
 ea8:	c2ef 0008      	mulu.w 8(sp),d1
	addw	d1, d0
 eac:	d041           	add.w d1,d0
	swap	d0
 eae:	4840           	swap d0
	clrw	d0
 eb0:	4240           	clr.w d0
	movew	sp@(6), d1	/* x1 -> d1 */
 eb2:	322f 0006      	move.w 6(sp),d1
	muluw	sp@(10), d1	/* x1*y1 */
 eb6:	c2ef 000a      	mulu.w 10(sp),d1
	addl	d1, d0
 eba:	d081           	add.l d1,d0
	rts
 ebc:	4e75           	rts

00000ebe <__udivsi3>:
	.text
	FUNC(__udivsi3)
	.globl	SYM (__udivsi3)
SYM (__udivsi3):
	.cfi_startproc
	movel	d2, sp@-
 ebe:	2f02           	move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	sp@(12), d1	/* d1 = divisor */
 ec0:	222f 000c      	move.l 12(sp),d1
	movel	sp@(8), d0	/* d0 = dividend */
 ec4:	202f 0008      	move.l 8(sp),d0

	cmpl	IMM (0x10000), d1 /* divisor >= 2 ^ 16 ?   */
 ec8:	0c81 0001 0000 	cmpi.l #65536,d1
	jcc	3f		/* then try next algorithm */
 ece:	6416           	bcc.s ee6 <__udivsi3+0x28>
	movel	d0, d2
 ed0:	2400           	move.l d0,d2
	clrw	d2
 ed2:	4242           	clr.w d2
	swap	d2
 ed4:	4842           	swap d2
	divu	d1, d2          /* high quotient in lower word */
 ed6:	84c1           	divu.w d1,d2
	movew	d2, d0		/* save high quotient */
 ed8:	3002           	move.w d2,d0
	swap	d0
 eda:	4840           	swap d0
	movew	sp@(10), d2	/* get low dividend + high rest */
 edc:	342f 000a      	move.w 10(sp),d2
	divu	d1, d2		/* low quotient */
 ee0:	84c1           	divu.w d1,d2
	movew	d2, d0
 ee2:	3002           	move.w d2,d0
	jra	6f
 ee4:	6030           	bra.s f16 <__udivsi3+0x58>

3:	movel	d1, d2		/* use d2 as divisor backup */
 ee6:	2401           	move.l d1,d2
4:	lsrl	IMM (1), d1	/* shift divisor */
 ee8:	e289           	lsr.l #1,d1
	lsrl	IMM (1), d0	/* shift dividend */
 eea:	e288           	lsr.l #1,d0
	cmpl	IMM (0x10000), d1 /* still divisor >= 2 ^ 16 ?  */
 eec:	0c81 0001 0000 	cmpi.l #65536,d1
	jcc	4b
 ef2:	64f4           	bcc.s ee8 <__udivsi3+0x2a>
	divu	d1, d0		/* now we have 16-bit divisor */
 ef4:	80c1           	divu.w d1,d0
	andl	IMM (0xffff), d0 /* mask out divisor, ignore remainder */
 ef6:	0280 0000 ffff 	andi.l #65535,d0

/* Multiply the 16-bit tentative quotient with the 32-bit divisor.  Because of
   the operand ranges, this might give a 33-bit product.  If this product is
   greater than the dividend, the tentative quotient was too large. */
	movel	d2, d1
 efc:	2202           	move.l d2,d1
	mulu	d0, d1		/* low part, 32 bits */
 efe:	c2c0           	mulu.w d0,d1
	swap	d2
 f00:	4842           	swap d2
	mulu	d0, d2		/* high part, at most 17 bits */
 f02:	c4c0           	mulu.w d0,d2
	swap	d2		/* align high part with low part */
 f04:	4842           	swap d2
	tstw	d2		/* high part 17 bits? */
 f06:	4a42           	tst.w d2
	jne	5f		/* if 17 bits, quotient was too large */
 f08:	660a           	bne.s f14 <__udivsi3+0x56>
	addl	d2, d1		/* add parts */
 f0a:	d282           	add.l d2,d1
	jcs	5f		/* if sum is 33 bits, quotient was too large */
 f0c:	6506           	bcs.s f14 <__udivsi3+0x56>
	cmpl	sp@(8), d1	/* compare the sum with the dividend */
 f0e:	b2af 0008      	cmp.l 8(sp),d1
	jls	6f		/* if sum > dividend, quotient was too large */
 f12:	6302           	bls.s f16 <__udivsi3+0x58>
5:	subql	IMM (1), d0	/* adjust quotient */
 f14:	5380           	subq.l #1,d0

6:	movel	sp@+, d2
 f16:	241f           	move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
 f18:	4e75           	rts

00000f1a <__divsi3>:
	.text
	FUNC(__divsi3)
	.globl	SYM (__divsi3)
SYM (__divsi3):
	.cfi_startproc
	movel	d2, sp@-
 f1a:	2f02           	move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4

	moveq	IMM (1), d2	/* sign of result stored in d2 (=1 or =-1) */
 f1c:	7401           	moveq #1,d2
	movel	sp@(12), d1	/* d1 = divisor */
 f1e:	222f 000c      	move.l 12(sp),d1
	jpl	1f
 f22:	6a04           	bpl.s f28 <__divsi3+0xe>
	negl	d1
 f24:	4481           	neg.l d1
	negb	d2		/* change sign because divisor <0  */
 f26:	4402           	neg.b d2
1:	movel	sp@(8), d0	/* d0 = dividend */
 f28:	202f 0008      	move.l 8(sp),d0
	jpl	2f
 f2c:	6a04           	bpl.s f32 <__divsi3+0x18>
	negl	d0
 f2e:	4480           	neg.l d0
	negb	d2
 f30:	4402           	neg.b d2

2:	movel	d1, sp@-
 f32:	2f01           	move.l d1,-(sp)
	movel	d0, sp@-
 f34:	2f00           	move.l d0,-(sp)
	PICCALL	SYM (__udivsi3)	/* divide abs(dividend) by abs(divisor) */
 f36:	6186           	bsr.s ebe <__udivsi3>
	addql	IMM (8), sp
 f38:	508f           	addq.l #8,sp

	tstb	d2
 f3a:	4a02           	tst.b d2
	jpl	3f
 f3c:	6a02           	bpl.s f40 <__divsi3+0x26>
	negl	d0
 f3e:	4480           	neg.l d0

3:	movel	sp@+, d2
 f40:	241f           	move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
 f42:	4e75           	rts

00000f44 <__modsi3>:
	.text
	FUNC(__modsi3)
	.globl	SYM (__modsi3)
SYM (__modsi3):
	.cfi_startproc
	movel	sp@(8), d1	/* d1 = divisor */
 f44:	222f 0008      	move.l 8(sp),d1
	movel	sp@(4), d0	/* d0 = dividend */
 f48:	202f 0004      	move.l 4(sp),d0
	movel	d1, sp@-
 f4c:	2f01           	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
 f4e:	2f00           	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	PICCALL	SYM (__divsi3)
 f50:	61c8           	bsr.s f1a <__divsi3>
	addql	IMM (8), sp
 f52:	508f           	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(8), d1	/* d1 = divisor */
 f54:	222f 0008      	move.l 8(sp),d1
	movel	d1, sp@-
 f58:	2f01           	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
 f5a:	2f00           	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	PICCALL	SYM (__mulsi3)	/* d0 = (a/b)*b */
 f5c:	6100 ff3e      	bsr.w e9c <__mulsi3>
	addql	IMM (8), sp
 f60:	508f           	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(4), d1	/* d1 = dividend */
 f62:	222f 0004      	move.l 4(sp),d1
	subl	d0, d1		/* d1 = a - (a/b)*b */
 f66:	9280           	sub.l d0,d1
	movel	d1, d0
 f68:	2001           	move.l d1,d0
	rts
 f6a:	4e75           	rts

00000f6c <__umodsi3>:
	.text
	FUNC(__umodsi3)
	.globl	SYM (__umodsi3)
SYM (__umodsi3):
	.cfi_startproc
	movel	sp@(8), d1	/* d1 = divisor */
 f6c:	222f 0008      	move.l 8(sp),d1
	movel	sp@(4), d0	/* d0 = dividend */
 f70:	202f 0004      	move.l 4(sp),d0
	movel	d1, sp@-
 f74:	2f01           	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
 f76:	2f00           	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	PICCALL	SYM (__udivsi3)
 f78:	6100 ff44      	bsr.w ebe <__udivsi3>
	addql	IMM (8), sp
 f7c:	508f           	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(8), d1	/* d1 = divisor */
 f7e:	222f 0008      	move.l 8(sp),d1
	movel	d1, sp@-
 f82:	2f01           	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
 f84:	2f00           	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	PICCALL	SYM (__mulsi3)	/* d0 = (a/b)*b */
 f86:	6100 ff14      	bsr.w e9c <__mulsi3>
	addql	IMM (8), sp
 f8a:	508f           	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(4), d1	/* d1 = dividend */
 f8c:	222f 0004      	move.l 4(sp),d1
	subl	d0, d1		/* d1 = a - (a/b)*b */
 f90:	9280           	sub.l d0,d1
	movel	d1, d0
 f92:	2001           	move.l d1,d0
	rts
 f94:	4e75           	rts

00000f96 <KPutCharX>:
	FUNC(KPutCharX)
	.globl	SYM (KPutCharX)

SYM(KPutCharX):
	.cfi_startproc
    move.l  a6, -(sp)
 f96:	2f0e           	move.l a6,-(sp)
	.cfi_adjust_cfa_offset 4
    move.l  4.w, a6
 f98:	2c78 0004      	movea.l 4 <_start+0x4>,a6
    jsr     -0x204(a6)
 f9c:	4eae fdfc      	jsr -516(a6)
    movea.l (sp)+, a6
 fa0:	2c5f           	movea.l (sp)+,a6
	.cfi_adjust_cfa_offset -4
    rts
 fa2:	4e75           	rts

00000fa4 <PutChar>:
	FUNC(PutChar)
	.globl	SYM (PutChar)

SYM(PutChar):
	.cfi_startproc
	move.b d0, (a3)+
 fa4:	16c0           	move.b d0,(a3)+
	rts
 fa6:	4e75           	rts
