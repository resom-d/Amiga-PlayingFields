
a.mingw.elf:     file format elf32-m68k


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
      74:	4fef ff94      	lea -108(sp),sp
      78:	48e7 3f3e      	movem.l d2-d7/a2-a6,-(sp)
	copPtr = copWaitXY(copPtr, 0xfe, 0xff);
}

int InitDemo()
{
	SysBase = *((struct ExecBase **)4UL);
      7c:	2c78 0004      	movea.l 4 <_start+0x4>,a6
      80:	23ce 0001 107e 	move.l a6,1107e <SysBase>
	custom = (struct Custom *)0xdff000;
      86:	23fc 00df f000 	move.l #14675968,110aa <custom>
      8c:	0001 10aa 

	// We will use the graphics library only to locate and restore the system copper list once we are through.
	GfxBase = (struct GfxBase *)OpenLibrary((CONST_STRPTR) "graphics.library", 0);
      90:	43f9 0000 1484 	lea 1484 <PutChar+0x4c>,a1
      96:	7000           	moveq #0,d0
      98:	4eae fdd8      	jsr -552(a6)
      9c:	23c0 0001 107a 	move.l d0,1107a <GfxBase>
	if (!GfxBase)
      a2:	6700 0b7c      	beq.w c20 <main+0xbac>
		Exit(0);

	// used for printing
	DOSBase = (struct DosLibrary *)OpenLibrary((CONST_STRPTR) "dos.library", 0);
      a6:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
      ac:	43f9 0000 1495 	lea 1495 <PutChar+0x5d>,a1
      b2:	7000           	moveq #0,d0
      b4:	4eae fdd8      	jsr -552(a6)
      b8:	23c0 0001 1082 	move.l d0,11082 <DOSBase>
	if (!DOSBase)
      be:	6700 0aac      	beq.w b6c <main+0xaf8>
		Exit(0);

#ifdef __cplusplus
	KPrintF("Hello debugger from Amiga: %ld!\n", staticClass.i);
#else
	KPrintF("Hello debugger from Amiga!\n");
      c2:	4879 0000 14a1 	pea 14a1 <PutChar+0x69>
      c8:	4eb9 0000 0fe0 	jsr fe0 <KPrintF>
#endif
	Write(Output(), (APTR) "Hello console!\n", 15);
      ce:	2c79 0001 1082 	movea.l 11082 <DOSBase>,a6
      d4:	4eae ffc4      	jsr -60(a6)
      d8:	2c79 0001 1082 	movea.l 11082 <DOSBase>,a6
      de:	2200           	move.l d0,d1
      e0:	243c 0000 14bd 	move.l #5309,d2
      e6:	760f           	moveq #15,d3
      e8:	4eae ffd0      	jsr -48(a6)

	warpmode(1);
      ec:	4878 0001      	pea 1 <_start+0x1>
      f0:	45f9 0000 1052 	lea 1052 <warpmode>,a2
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
     122:	2479 0001 10aa 	movea.l 110aa <custom>,a2
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
     152:	4eb9 0000 0c7e 	jsr c7e <WaitVbl>
    WaitVbl();
     158:	4eb9 0000 0c7e 	jsr c7e <WaitVbl>
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
     1a2:	4eb9 0000 0c7e 	jsr c7e <WaitVbl>
    WaitVbl();
     1a8:	4eb9 0000 0c7e 	jsr c7e <WaitVbl>
    UWORD getvbr[] = {0x4e7a, 0x0801, 0x4e73}; // MOVEC.L VBR,D0 RTE
     1ae:	3f7c 4e7a 0068 	move.w #20090,104(sp)
     1b4:	3f7c 0801 006a 	move.w #2049,106(sp)
     1ba:	3f7c 4e73 006c 	move.w #20083,108(sp)
    if (SysBase->AttnFlags & AFF_68010)
     1c0:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
     1c6:	082e 0000 0129 	btst #0,297(a6)
     1cc:	6700 0a7e      	beq.w c4c <main+0xbd8>
        vbr = (APTR)Supervisor((ULONG(*)())getvbr);
     1d0:	7e68           	moveq #104,d7
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
     204:	2640           	movea.l d0,a3
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
     240:	45f0 1800      	lea (0,a0,d1.l),a2
     244:	23ca 0000 2014 	move.l a2,2014 <bmpDisplay+0x14>
	for (int p = 0; p < img->Depth; p++)
     24a:	7002           	moveq #2,d0
     24c:	b089           	cmp.l a1,d0
     24e:	6766           	beq.s 2b6 <main+0x242>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     250:	2001           	move.l d1,d0
     252:	d081           	add.l d1,d0
     254:	45f0 0800      	lea (0,a0,d0.l),a2
     258:	23ca 0000 2018 	move.l a2,2018 <bmpDisplay+0x18>
	for (int p = 0; p < img->Depth; p++)
     25e:	7403           	moveq #3,d2
     260:	b489           	cmp.l a1,d2
     262:	6752           	beq.s 2b6 <main+0x242>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     264:	d081           	add.l d1,d0
     266:	45f0 0800      	lea (0,a0,d0.l),a2
     26a:	23ca 0000 201c 	move.l a2,201c <bmpDisplay+0x1c>
	for (int p = 0; p < img->Depth; p++)
     270:	7404           	moveq #4,d2
     272:	b489           	cmp.l a1,d2
     274:	6740           	beq.s 2b6 <main+0x242>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     276:	d081           	add.l d1,d0
     278:	45f0 0800      	lea (0,a0,d0.l),a2
     27c:	23ca 0000 2020 	move.l a2,2020 <bmpDisplay+0x20>
	for (int p = 0; p < img->Depth; p++)
     282:	7405           	moveq #5,d2
     284:	b489           	cmp.l a1,d2
     286:	672e           	beq.s 2b6 <main+0x242>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     288:	d081           	add.l d1,d0
     28a:	45f0 0800      	lea (0,a0,d0.l),a2
     28e:	23ca 0000 2024 	move.l a2,2024 <bmpDisplay+0x24>
	for (int p = 0; p < img->Depth; p++)
     294:	7406           	moveq #6,d2
     296:	b489           	cmp.l a1,d2
     298:	671c           	beq.s 2b6 <main+0x242>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     29a:	d081           	add.l d1,d0
     29c:	45f0 0800      	lea (0,a0,d0.l),a2
     2a0:	23ca 0000 2028 	move.l a2,2028 <bmpDisplay+0x28>
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
     2bc:	3442           	movea.w d2,a2
     2be:	4a42           	tst.w d2
     2c0:	6f00 0098      	ble.w 35a <main+0x2e6>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     2c4:	2079 0000 203c 	movea.l 203c <bmpDraw+0xc>,a0
     2ca:	4241           	clr.w d1
     2cc:	1239 0000 203a 	move.b 203a <bmpDraw+0xa>,d1
     2d2:	c3f9 0000 2036 	muls.w 2036 <bmpDraw+0x6>,d1
     2d8:	23c8 0000 2040 	move.l a0,2040 <bmpDraw+0x10>
	for (int p = 0; p < img->Depth; p++)
     2de:	7601           	moveq #1,d3
     2e0:	b68a           	cmp.l a2,d3
     2e2:	6776           	beq.s 35a <main+0x2e6>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     2e4:	43f0 1800      	lea (0,a0,d1.l),a1
     2e8:	23c9 0000 2044 	move.l a1,2044 <bmpDraw+0x14>
	for (int p = 0; p < img->Depth; p++)
     2ee:	7002           	moveq #2,d0
     2f0:	b08a           	cmp.l a2,d0
     2f2:	6766           	beq.s 35a <main+0x2e6>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     2f4:	2001           	move.l d1,d0
     2f6:	d081           	add.l d1,d0
     2f8:	43f0 0800      	lea (0,a0,d0.l),a1
     2fc:	23c9 0000 2048 	move.l a1,2048 <bmpDraw+0x18>
	for (int p = 0; p < img->Depth; p++)
     302:	7603           	moveq #3,d3
     304:	b68a           	cmp.l a2,d3
     306:	6752           	beq.s 35a <main+0x2e6>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     308:	d081           	add.l d1,d0
     30a:	43f0 0800      	lea (0,a0,d0.l),a1
     30e:	23c9 0000 204c 	move.l a1,204c <bmpDraw+0x1c>
	for (int p = 0; p < img->Depth; p++)
     314:	7604           	moveq #4,d3
     316:	b68a           	cmp.l a2,d3
     318:	6740           	beq.s 35a <main+0x2e6>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     31a:	d081           	add.l d1,d0
     31c:	43f0 0800      	lea (0,a0,d0.l),a1
     320:	23c9 0000 2050 	move.l a1,2050 <bmpDraw+0x20>
	for (int p = 0; p < img->Depth; p++)
     326:	7605           	moveq #5,d3
     328:	b68a           	cmp.l a2,d3
     32a:	672e           	beq.s 35a <main+0x2e6>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     32c:	d081           	add.l d1,d0
     32e:	43f0 0800      	lea (0,a0,d0.l),a1
     332:	23c9 0000 2054 	move.l a1,2054 <bmpDraw+0x24>
	for (int p = 0; p < img->Depth; p++)
     338:	7606           	moveq #6,d3
     33a:	b68a           	cmp.l a2,d3
     33c:	671c           	beq.s 35a <main+0x2e6>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     33e:	d081           	add.l d1,d0
     340:	43f0 0800      	lea (0,a0,d0.l),a1
     344:	23c9 0000 2058 	move.l a1,2058 <bmpDraw+0x28>
	for (int p = 0; p < img->Depth; p++)
     34a:	7607           	moveq #7,d3
     34c:	b68a           	cmp.l a2,d3
     34e:	670a           	beq.s 35a <main+0x2e6>
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
     350:	d081           	add.l d1,d0
     352:	d088           	add.l a0,d0
     354:	23c0 0000 205c 	move.l d0,205c <bmpDraw+0x2c>
	WaitVbl();
     35a:	4eb9 0000 0c7e 	jsr c7e <WaitVbl>
    *copListEnd++ = offsetof(struct Custom, ddfstrt);
     360:	36bc 0092      	move.w #146,(a3)
    *copListEnd++ = fw;
     364:	377c 0038 0002 	move.w #56,2(a3)
    *copListEnd++ = offsetof(struct Custom, ddfstop);
     36a:	377c 0094 0004 	move.w #148,4(a3)
    *copListEnd++ = fw + (((width >> 4) - 1) << 3);
     370:	377c 00d0 0006 	move.w #208,6(a3)
    *copListEnd++ = offsetof(struct Custom, diwstrt);
     376:	377c 008e 0008 	move.w #142,8(a3)
    *copListEnd++ = x + (y << 8);
     37c:	377c 2c81 000a 	move.w #11393,10(a3)
    *copListEnd++ = offsetof(struct Custom, diwstop);
     382:	377c 0090 000c 	move.w #144,12(a3)
    *copListEnd++ = (xstop - 256) + ((ystop - 256) << 8);
     388:	377c 2cc1 000e 	move.w #11457,14(a3)
	*copPtr++ = BPLCON0;
     38e:	377c 0100 0010 	move.w #256,16(a3)
	*copPtr++ = (0 << 10) /*dual pf*/ | (1 << 9) /*color*/ | ((ScreenBpls) << 12) /*num bitplanes*/;
     394:	377c 3200 0012 	move.w #12800,18(a3)
	*copPtr++ = BPLCON1; //scrolling
     39a:	377c 0102 0014 	move.w #258,20(a3)
	*copPtr++ = 0;
     3a0:	426b 0016      	clr.w 22(a3)
	*copPtr++ = BPLCON2; //playfied priority
     3a4:	377c 0104 0018 	move.w #260,24(a3)
	*copPtr++ = 1 << 6;	 //0x24;			//Sprites have priority over playfields
     3aa:	377c 0040 001a 	move.w #64,26(a3)
	*copPtr++ = BPL1MOD; //odd planes   1,3,5
     3b0:	377c 0108 001c 	move.w #264,28(a3)
	*copPtr++ = 0;
     3b6:	426b 001e      	clr.w 30(a3)
	*copPtr++ = BPL2MOD; //even  planes 2,4
     3ba:	377c 010a 0020 	move.w #266,32(a3)
	*copPtr++ = 0;
     3c0:	426b 0022      	clr.w 34(a3)
        ULONG addr = (ULONG)planes[i];
     3c4:	2039 0000 2010 	move.l 2010 <bmpDisplay+0x10>,d0
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]);
     3ca:	377c 00e0 0024 	move.w #224,36(a3)
        *copListEnd++ = (UWORD)(addr >> 16);
     3d0:	2200           	move.l d0,d1
     3d2:	4241           	clr.w d1
     3d4:	4841           	swap d1
     3d6:	3741 0026      	move.w d1,38(a3)
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]) + 2;
     3da:	377c 00e2 0028 	move.w #226,40(a3)
        *copListEnd++ = (UWORD)addr;
     3e0:	3740 002a      	move.w d0,42(a3)
        ULONG addr = (ULONG)planes[i];
     3e4:	2039 0000 2014 	move.l 2014 <bmpDisplay+0x14>,d0
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]);
     3ea:	377c 00e4 002c 	move.w #228,44(a3)
        *copListEnd++ = (UWORD)(addr >> 16);
     3f0:	2200           	move.l d0,d1
     3f2:	4241           	clr.w d1
     3f4:	4841           	swap d1
     3f6:	3741 002e      	move.w d1,46(a3)
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]) + 2;
     3fa:	377c 00e6 0030 	move.w #230,48(a3)
        *copListEnd++ = (UWORD)addr;
     400:	3740 0032      	move.w d0,50(a3)
        ULONG addr = (ULONG)planes[i];
     404:	2039 0000 2018 	move.l 2018 <bmpDisplay+0x18>,d0
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]);
     40a:	377c 00e8 0034 	move.w #232,52(a3)
        *copListEnd++ = (UWORD)(addr >> 16);
     410:	2200           	move.l d0,d1
     412:	4241           	clr.w d1
     414:	4841           	swap d1
     416:	3741 0036      	move.w d1,54(a3)
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]) + 2;
     41a:	377c 00ea 0038 	move.w #234,56(a3)
        *copListEnd++ = (UWORD)addr;
     420:	3740 003a      	move.w d0,58(a3)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
     424:	377c 0180 003c 	move.w #384,60(a3)
    *copListCurrent++ = color;
     42a:	426b 003e      	clr.w 62(a3)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
     42e:	377c 0182 0040 	move.w #386,64(a3)
    *copListCurrent++ = color;
     434:	377c 0556 0042 	move.w #1366,66(a3)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
     43a:	377c 0184 0044 	move.w #388,68(a3)
    *copListCurrent++ = color;
     440:	377c 0c95 0046 	move.w #3221,70(a3)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
     446:	377c 0186 0048 	move.w #390,72(a3)
    *copListCurrent++ = color;
     44c:	377c 0ea6 004a 	move.w #3750,74(a3)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
     452:	377c 0188 004c 	move.w #392,76(a3)
    *copListCurrent++ = color;
     458:	377c 0432 004e 	move.w #1074,78(a3)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
     45e:	377c 018a 0050 	move.w #394,80(a3)
    *copListCurrent++ = color;
     464:	377c 0531 0052 	move.w #1329,82(a3)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
     46a:	377c 018c 0054 	move.w #396,84(a3)
    *copListCurrent++ = color;
     470:	377c 0212 0056 	move.w #530,86(a3)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
     476:	377c 018e 0058 	move.w #398,88(a3)
    *copListCurrent++ = color;
     47c:	377c 0881 005a 	move.w #2177,90(a3)
    *copListEnd++ = (i << 8) | 4 | 1; //bit 1 means wait. waits for vertical position x<<8, first raster stop position outside the left
     482:	377c d605 005c 	move.w #-10747,92(a3)
    *copListEnd++ = 0xfffe;
     488:	377c fffe 005e 	move.w #-2,94(a3)
	*copPtr++ = BPL1MOD; //odd planes   1,3,5
     48e:	377c 0108 0060 	move.w #264,96(a3)
	*copPtr++ = -2 * ScreenBpl;
     494:	377c ffb0 0062 	move.w #-80,98(a3)
	*copPtr++ = BPL2MOD; //even  planes 2,4
     49a:	377c 010a 0064 	move.w #266,100(a3)
	*copPtr++ = -2 * ScreenBpl;
     4a0:	377c ffb0 0066 	move.w #-80,102(a3)
    *copListEnd++ = (i << 8) | (x << 1) | 1; //bit 1 means wait. waits for vertical position x<<8, first raster stop position outside the left
     4a6:	377c fffd 0068 	move.w #-3,104(a3)
    *copListEnd++ = 0xfffe;
     4ac:	377c fffe 006a 	move.w #-2,106(a3)
     4b2:	41eb 006c      	lea 108(a3),a0
     4b6:	23c8 0001 1060 	move.l a0,11060 <copPtr>
	custom->cop1lc = (ULONG)copper1;
     4bc:	2a79 0001 10aa 	movea.l 110aa <custom>,a5
     4c2:	2b4b 0080      	move.l a3,128(a5)
	custom->dmacon = DMAF_BLITTER; //disable blitter dma for copjmp bug
     4c6:	3b7c 0040 0096 	move.w #64,150(a5)
	custom->copjmp1 = 0x7fff;	   //start coppper
     4cc:	3b7c 7fff 0088 	move.w #32767,136(a5)
	custom->dmacon = DMAF_SETCLR | DMAF_MASTER | DMAF_RASTER | DMAF_COPPER | DMAF_BLITTER;
     4d2:	3b7c 83c0 0096 	move.w #-31808,150(a5)
    *(volatile APTR *)(((UBYTE *)VBR) + 0x6c) = interrupt;
     4d8:	2079 0001 1072 	movea.l 11072 <VBR>,a0
     4de:	217c 0000 0c54 	move.l #3156,108(a0)
     4e4:	006c 
	custom->intena = (1 << INTB_SETCLR) | (1 << INTB_INTEN) | (1 << INTB_VERTB);
     4e6:	3b7c c020 009a 	move.w #-16352,154(a5)
	custom->intreq = 1 << INTB_VERTB; //reset vbl req
     4ec:	3b7c 0020 009c 	move.w #32,156(a5)
	}
}

void MakePolys()
{
	PolyBox[0].X = 10;
     4f2:	700a           	moveq #10,d0
     4f4:	23c0 0001 1086 	move.l d0,11086 <PolyBox>
	PolyBox[0].Y = 10;
     4fa:	23c0 0001 108a 	move.l d0,1108a <PolyBox+0x4>
	PolyBox[1].X = 50;
     500:	7232           	moveq #50,d1
     502:	23c1 0001 108e 	move.l d1,1108e <PolyBox+0x8>
	PolyBox[1].Y = 10;
     508:	23c0 0001 1092 	move.l d0,11092 <PolyBox+0xc>
	PolyBox[2].X = 50;
     50e:	23c1 0001 1096 	move.l d1,11096 <PolyBox+0x10>
	PolyBox[2].Y = 50;
     514:	23c1 0001 109a 	move.l d1,1109a <PolyBox+0x14>
	PolyBox[3].X = 10;
     51a:	23c0 0001 109e 	move.l d0,1109e <PolyBox+0x18>
	PolyBox[3].Y = 50;
     520:	23c1 0001 10a2 	move.l d1,110a2 <PolyBox+0x1c>
inline short MouseLeft() { return !((*(volatile UBYTE *)0xbfe001) & 64); }
     526:	1039 00bf e001 	move.b bfe001 <_end+0xbecf51>,d0
	while (!MouseLeft())
     52c:	0800 0006      	btst #6,d0
     530:	6700 055c      	beq.w a8e <main+0xa1a>
     534:	2f79 0000 203c 	move.l 203c <bmpDraw+0xc>,82(sp)
     53a:	0052 
     53c:	1039 0000 203a 	move.b 203a <bmpDraw+0xa>,d0
     542:	2f79 0000 205c 	move.l 205c <bmpDraw+0x2c>,68(sp)
     548:	0044 
     54a:	2279 0000 2040 	movea.l 2040 <bmpDraw+0x10>,a1
     550:	2f79 0000 204c 	move.l 204c <bmpDraw+0x1c>,92(sp)
     556:	005c 
     558:	2f79 0000 2058 	move.l 2058 <bmpDraw+0x28>,64(sp)
     55e:	0040 
	custom->bltdpt = bmpD.ImageData;
	custom->bltafwm = 0xffff;
	custom->bltalwm = 0xffff;
	custom->bltamod = 0;
	custom->bltdmod = 0;
	custom->bltsize = ((bmpS.Height * bmpS.Depth) << 6) + (bmpS.BytesPerRow / 2);
     560:	3202           	move.w d2,d1
     562:	c3f9 0000 2036 	muls.w 2036 <bmpDraw+0x6>,d1
     568:	ed49           	lsl.w #6,d1
     56a:	1400           	move.b d0,d2
     56c:	e20a           	lsr.b #1,d2
     56e:	0242 00ff      	andi.w #255,d2
     572:	d242           	add.w d2,d1
     574:	3f41 0056      	move.w d1,86(sp)
	USHORT yb = y * bitmap.BytesPerRow;
     578:	0240 00ff      	andi.w #255,d0
     57c:	3f40 004c      	move.w d0,76(sp)
     580:	2f79 0000 2054 	move.l 2054 <bmpDraw+0x24>,60(sp)
     586:	003c 
     588:	2879 0000 2048 	movea.l 2048 <bmpDraw+0x18>,a4
     58e:	2f79 0000 2050 	move.l 2050 <bmpDraw+0x20>,52(sp)
     594:	0034 
     596:	2c79 0000 2044 	movea.l 2044 <bmpDraw+0x14>,a6
	UBYTE xo = 0x80 >> (x % 8);
     59c:	2649           	movea.l a1,a3
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
     59e:	2039 00df f004 	move.l dff004 <_end+0xdedf54>,d0
     5a4:	2f40 0064      	move.l d0,100(sp)
        vpos &= 0x1ff00;
     5a8:	202f 0064      	move.l 100(sp),d0
     5ac:	0280 0001 ff00 	andi.l #130816,d0
     5b2:	2f40 0064      	move.l d0,100(sp)
        if (vpos != (311 << 8))
     5b6:	202f 0064      	move.l 100(sp),d0
     5ba:	0c80 0001 3700 	cmpi.l #79616,d0
     5c0:	67dc           	beq.s 59e <main+0x52a>
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
     5c2:	2039 00df f004 	move.l dff004 <_end+0xdedf54>,d0
     5c8:	2f40 0060      	move.l d0,96(sp)
        vpos &= 0x1ff00;
     5cc:	202f 0060      	move.l 96(sp),d0
     5d0:	0280 0001 ff00 	andi.l #130816,d0
     5d6:	2f40 0060      	move.l d0,96(sp)
        if (vpos == (311 << 8))
     5da:	202f 0060      	move.l 96(sp),d0
     5de:	0c80 0001 3700 	cmpi.l #79616,d0
     5e4:	66dc           	bne.s 5c2 <main+0x54e>
		CopyBitmap(bmpDraw, bmpDisplay);
     5e6:	2239 0000 200c 	move.l 200c <bmpDisplay+0xc>,d1
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
     5ec:	302d 0002      	move.w 2(a5),d0
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
     5f0:	302d 0002      	move.w 2(a5),d0
     5f4:	0800 000e      	btst #14,d0
     5f8:	66f6           	bne.s 5f0 <main+0x57c>
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
     5fa:	302d 0002      	move.w 2(a5),d0
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
     5fe:	302d 0002      	move.w 2(a5),d0
     602:	0800 000e      	btst #14,d0
     606:	66f6           	bne.s 5fe <main+0x58a>
	custom->bltcon0 = 0x09f0;
     608:	3b7c 09f0 0040 	move.w #2544,64(a5)
	custom->bltcon1 = 0x0000;
     60e:	3b7c 0000 0042 	move.w #0,66(a5)
	custom->bltapt = bmpS.ImageData;
     614:	2b6f 0052 0050 	move.l 82(sp),80(a5)
	custom->bltdpt = bmpD.ImageData;
     61a:	2b41 0054      	move.l d1,84(a5)
	custom->bltafwm = 0xffff;
     61e:	3b7c ffff 0044 	move.w #-1,68(a5)
	custom->bltalwm = 0xffff;
     624:	3b7c ffff 0046 	move.w #-1,70(a5)
	custom->bltamod = 0;
     62a:	3b7c 0000 0064 	move.w #0,100(a5)
	custom->bltdmod = 0;
     630:	3b7c 0000 0066 	move.w #0,102(a5)
	custom->bltsize = ((bmpS.Height * bmpS.Depth) << 6) + (bmpS.BytesPerRow / 2);
     636:	3b6f 0056 0058 	move.w 86(sp),88(a5)
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
     63c:	302d 0002      	move.w 2(a5),d0
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
     640:	302d 0002      	move.w 2(a5),d0
     644:	0800 000e      	btst #14,d0
     648:	66f6           	bne.s 640 <main+0x5cc>
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
     64a:	302d 0002      	move.w 2(a5),d0
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
     64e:	302d 0002      	move.w 2(a5),d0
     652:	0800 000e      	btst #14,d0
     656:	66f6           	bne.s 64e <main+0x5da>
void ClearBitmap(ImageContainer bmpD)
{
	WaitBlt();
	WaitBlt();

	custom->bltcon0 = 0x0900;
     658:	3b7c 0900 0040 	move.w #2304,64(a5)
	custom->bltcon1 = 0x0000;
     65e:	3b7c 0000 0042 	move.w #0,66(a5)
	custom->bltapt = bmpD.ImageData;
     664:	2b6f 0052 0050 	move.l 82(sp),80(a5)
	custom->bltdpt = bmpD.ImageData;
     66a:	2b6f 0052 0054 	move.l 82(sp),84(a5)
	custom->bltafwm = 0xffff;
     670:	3b7c ffff 0044 	move.w #-1,68(a5)
	custom->bltalwm = 0xffff;
     676:	3b7c ffff 0046 	move.w #-1,70(a5)
	custom->bltamod = 0;
     67c:	3b7c 0000 0064 	move.w #0,100(a5)
	custom->bltdmod = 0;
     682:	3b7c 0000 0066 	move.w #0,102(a5)
	custom->bltsize = ((bmpD.Height * bmpD.Depth) << 6) + (bmpD.BytesPerRow / 2);
     688:	3b6f 0056 0058 	move.w 86(sp),88(a5)
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
     68e:	302d 0002      	move.w 2(a5),d0
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
     692:	302d 0002      	move.w 2(a5),d0
     696:	0800 000e      	btst #14,d0
     69a:	66f6           	bne.s 692 <main+0x61e>
		PolygonDraw(bmpDraw, PolyBox, 4, 7, TRUE);
     69c:	41f9 0000 2030 	lea 2030 <bmpDraw>,a0
     6a2:	2f50 0068      	move.l (a0),104(sp)
     6a6:	43f9 0000 2034 	lea 2034 <bmpDraw+0x4>,a1
     6ac:	2f51 006c      	move.l (a1),108(sp)
     6b0:	41f9 0000 2038 	lea 2038 <bmpDraw+0x8>,a0
     6b6:	2f50 0070      	move.l (a0),112(sp)
     6ba:	43f9 0000 203c 	lea 203c <bmpDraw+0xc>,a1
     6c0:	2f51 0074      	move.l (a1),116(sp)
     6c4:	41f9 0000 2040 	lea 2040 <bmpDraw+0x10>,a0
     6ca:	2f50 0078      	move.l (a0),120(sp)
     6ce:	43f9 0000 2044 	lea 2044 <bmpDraw+0x14>,a1
     6d4:	2f51 007c      	move.l (a1),124(sp)
     6d8:	41f9 0000 2048 	lea 2048 <bmpDraw+0x18>,a0
     6de:	2f50 0080      	move.l (a0),128(sp)
     6e2:	43f9 0000 204c 	lea 204c <bmpDraw+0x1c>,a1
     6e8:	2f51 0084      	move.l (a1),132(sp)
     6ec:	41f9 0000 2050 	lea 2050 <bmpDraw+0x20>,a0
     6f2:	2f50 0088      	move.l (a0),136(sp)
     6f6:	43f9 0000 2054 	lea 2054 <bmpDraw+0x24>,a1
     6fc:	2f51 008c      	move.l (a1),140(sp)
     700:	41f9 0000 2058 	lea 2058 <bmpDraw+0x28>,a0
     706:	2f50 0090      	move.l (a0),144(sp)
     70a:	43f9 0000 205c 	lea 205c <bmpDraw+0x2c>,a1
     710:	2f51 0094      	move.l (a1),148(sp)
     714:	43f9 0001 1086 	lea 11086 <PolyBox>,a1
     71a:	240a           	move.l a2,d2
     71c:	2449           	movea.l a1,a2
		LineDraw(bitmap, pointlist[i].X, pointlist[i].Y, pointlist[i + 1].X, pointlist[i + 1].Y, col);
     71e:	4878 0007      	pea 7 <_start+0x7>
     722:	2f2a 000c      	move.l 12(a2),-(sp)
     726:	2f2a 0008      	move.l 8(a2),-(sp)
     72a:	2f2a 0004      	move.l 4(a2),-(sp)
     72e:	2f12           	move.l (a2),-(sp)
     730:	2f2f 00a8      	move.l 168(sp),-(sp)
     734:	41ef 00ac      	lea 172(sp),a0
     738:	2f20           	move.l -(a0),-(sp)
     73a:	2f20           	move.l -(a0),-(sp)
     73c:	2f20           	move.l -(a0),-(sp)
     73e:	2f20           	move.l -(a0),-(sp)
     740:	2f20           	move.l -(a0),-(sp)
     742:	2f20           	move.l -(a0),-(sp)
     744:	2f20           	move.l -(a0),-(sp)
     746:	2f20           	move.l -(a0),-(sp)
     748:	2f20           	move.l -(a0),-(sp)
     74a:	2f20           	move.l -(a0),-(sp)
     74c:	2f28 fffc      	move.l -4(a0),-(sp)
     750:	4eb9 0000 0cc4 	jsr cc4 <LineDraw>
	for (int i = 0; i < length - 1; i++)
     756:	508a           	addq.l #8,a2
     758:	4fef 0044      	lea 68(sp),sp
     75c:	b5fc 0001 109e 	cmpa.l #69790,a2
     762:	66ba           	bne.s 71e <main+0x6aa>
		LineDraw(bitmap, pointlist[length - 1].X, pointlist[length - 1].Y, pointlist[0].X, pointlist[0].Y, col);
     764:	2442           	movea.l d2,a2
     766:	4878 0007      	pea 7 <_start+0x7>
     76a:	2f39 0001 108a 	move.l 1108a <PolyBox+0x4>,-(sp)
     770:	41f9 0001 1086 	lea 11086 <PolyBox>,a0
     776:	2f10           	move.l (a0),-(sp)
     778:	2f39 0001 10a2 	move.l 110a2 <PolyBox+0x1c>,-(sp)
     77e:	2f39 0001 109e 	move.l 1109e <PolyBox+0x18>,-(sp)
     784:	2f2f 00a8      	move.l 168(sp),-(sp)
     788:	41ef 00ac      	lea 172(sp),a0
     78c:	2f20           	move.l -(a0),-(sp)
     78e:	2f20           	move.l -(a0),-(sp)
     790:	2f20           	move.l -(a0),-(sp)
     792:	2f20           	move.l -(a0),-(sp)
     794:	2f20           	move.l -(a0),-(sp)
     796:	2f20           	move.l -(a0),-(sp)
     798:	2f20           	move.l -(a0),-(sp)
     79a:	2f20           	move.l -(a0),-(sp)
     79c:	2f20           	move.l -(a0),-(sp)
     79e:	2f20           	move.l -(a0),-(sp)
     7a0:	2f28 fffc      	move.l -4(a0),-(sp)
     7a4:	4eb9 0000 0cc4 	jsr cc4 <LineDraw>
		PolygonDraw(bmpDraw, PolyBox, 4, 7, TRUE);
     7aa:	4fef 0044      	lea 68(sp),sp
	long err = b2 - (2 * b - 1) * a2, e2; /* Fehler im 1. Schritt */
     7ae:	2f7c fffc 42f8 	move.l #-245000,56(sp)
     7b4:	0038 
	int dx = 0, dy = b; /* im I. Quadranten von links oben nach rechts unten */
     7b6:	7e32           	moveq #50,d7
     7b8:	91c8           	suba.l a0,a0
     7ba:	3f7c 0082 0050 	move.w #130,80(sp)
     7c0:	7064           	moveq #100,d0
     7c2:	2f40 0048      	move.l d0,72(sp)
     7c6:	2f4d 0058      	move.l a5,88(sp)
     7ca:	2a6f 005c      	movea.l 92(sp),a5
		SetPixel(bitmap, xm + dx, ym + dy, col);
     7ce:	3f47 0032      	move.w d7,50(sp)
     7d2:	3c08           	move.w a0,d6
     7d4:	3008           	move.w a0,d0
     7d6:	0640 0050      	addi.w #80,d0
	USHORT xb = (x) / 8;
     7da:	3800           	move.w d0,d4
     7dc:	e64c           	lsr.w #3,d4
	UBYTE xo = 0x80 >> (x % 8);
     7de:	7207           	moveq #7,d1
     7e0:	c081           	and.l d1,d0
     7e2:	7a7f           	moveq #127,d5
     7e4:	4605           	not.b d5
     7e6:	e0a5           	asr.l d0,d5
	USHORT yb = y * bitmap.BytesPerRow;
     7e8:	302f 0050      	move.w 80(sp),d0
     7ec:	c1ef 004c      	muls.w 76(sp),d0
	for (int pl = 0; pl < bitmap.Depth; pl++)
     7f0:	b4fc 0000      	cmpa.w #0,a2
     7f4:	6f00 01d6      	ble.w 9cc <main+0x958>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     7f8:	0280 0000 ffff 	andi.l #65535,d0
     7fe:	0284 0000 ffff 	andi.l #65535,d4
     804:	2f44 002e      	move.l d4,46(sp)
     808:	2204           	move.l d4,d1
     80a:	d280           	add.l d0,d1
     80c:	1405           	move.b d5,d2
     80e:	4602           	not.b d2
     810:	c533 1800      	and.b d2,(0,a3,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     814:	7601           	moveq #1,d3
     816:	b68a           	cmp.l a2,d3
     818:	6758           	beq.s 872 <main+0x7fe>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     81a:	1602           	move.b d2,d3
     81c:	c636 1800      	and.b (0,a6,d1.l),d3
			bitmap.Planes[pl][yb + xb] |= xo;
     820:	8605           	or.b d5,d3
     822:	1d83 1800      	move.b d3,(0,a6,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     826:	7602           	moveq #2,d3
     828:	b68a           	cmp.l a2,d3
     82a:	6746           	beq.s 872 <main+0x7fe>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     82c:	c534 1800      	and.b d2,(0,a4,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     830:	7803           	moveq #3,d4
     832:	b88a           	cmp.l a2,d4
     834:	673c           	beq.s 872 <main+0x7fe>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     836:	c535 1800      	and.b d2,(0,a5,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     83a:	7604           	moveq #4,d3
     83c:	b68a           	cmp.l a2,d3
     83e:	6732           	beq.s 872 <main+0x7fe>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     840:	226f 0034      	movea.l 52(sp),a1
     844:	c531 1800      	and.b d2,(0,a1,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     848:	7605           	moveq #5,d3
     84a:	b68a           	cmp.l a2,d3
     84c:	6724           	beq.s 872 <main+0x7fe>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     84e:	226f 003c      	movea.l 60(sp),a1
     852:	c531 1800      	and.b d2,(0,a1,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     856:	7606           	moveq #6,d3
     858:	b68a           	cmp.l a2,d3
     85a:	6716           	beq.s 872 <main+0x7fe>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     85c:	226f 0040      	movea.l 64(sp),a1
     860:	c531 1800      	and.b d2,(0,a1,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     864:	7607           	moveq #7,d3
     866:	b68a           	cmp.l a2,d3
     868:	6708           	beq.s 872 <main+0x7fe>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     86a:	226f 0044      	movea.l 68(sp),a1
     86e:	c531 1800      	and.b d2,(0,a1,d1.l)
		SetPixel(bitmap, xm - dx, ym + dy, col);
     872:	7650           	moveq #80,d3
     874:	9646           	sub.w d6,d3
	USHORT xb = (x) / 8;
     876:	3203           	move.w d3,d1
     878:	e649           	lsr.w #3,d1
	UBYTE xo = 0x80 >> (x % 8);
     87a:	7807           	moveq #7,d4
     87c:	c684           	and.l d4,d3
     87e:	7c7f           	moveq #127,d6
     880:	4606           	not.b d6
     882:	e6a6           	asr.l d3,d6
		bitmap.Planes[pl][yb + xb] &= ~xo;
     884:	0281 0000 ffff 	andi.l #65535,d1
     88a:	d081           	add.l d1,d0
     88c:	1606           	move.b d6,d3
     88e:	4603           	not.b d3
     890:	c733 0800      	and.b d3,(0,a3,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     894:	7801           	moveq #1,d4
     896:	b88a           	cmp.l a2,d4
     898:	6758           	beq.s 8f2 <main+0x87e>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     89a:	1803           	move.b d3,d4
     89c:	c836 0800      	and.b (0,a6,d0.l),d4
			bitmap.Planes[pl][yb + xb] |= xo;
     8a0:	8806           	or.b d6,d4
     8a2:	1d84 0800      	move.b d4,(0,a6,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     8a6:	7802           	moveq #2,d4
     8a8:	b88a           	cmp.l a2,d4
     8aa:	6746           	beq.s 8f2 <main+0x87e>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     8ac:	c734 0800      	and.b d3,(0,a4,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     8b0:	7803           	moveq #3,d4
     8b2:	b88a           	cmp.l a2,d4
     8b4:	673c           	beq.s 8f2 <main+0x87e>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     8b6:	c735 0800      	and.b d3,(0,a5,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     8ba:	7804           	moveq #4,d4
     8bc:	b88a           	cmp.l a2,d4
     8be:	6732           	beq.s 8f2 <main+0x87e>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     8c0:	226f 0034      	movea.l 52(sp),a1
     8c4:	c731 0800      	and.b d3,(0,a1,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     8c8:	7805           	moveq #5,d4
     8ca:	b88a           	cmp.l a2,d4
     8cc:	6724           	beq.s 8f2 <main+0x87e>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     8ce:	226f 003c      	movea.l 60(sp),a1
     8d2:	c731 0800      	and.b d3,(0,a1,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     8d6:	7806           	moveq #6,d4
     8d8:	b88a           	cmp.l a2,d4
     8da:	6716           	beq.s 8f2 <main+0x87e>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     8dc:	226f 0040      	movea.l 64(sp),a1
     8e0:	c731 0800      	and.b d3,(0,a1,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     8e4:	7807           	moveq #7,d4
     8e6:	b88a           	cmp.l a2,d4
     8e8:	6708           	beq.s 8f2 <main+0x87e>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     8ea:	226f 0044      	movea.l 68(sp),a1
     8ee:	c731 0800      	and.b d3,(0,a1,d0.l)
		SetPixel(bitmap, xm - dx, ym - dy, col);
     8f2:	7050           	moveq #80,d0
     8f4:	906f 0032      	sub.w 50(sp),d0
	USHORT yb = y * bitmap.BytesPerRow;
     8f8:	c1ef 004c      	muls.w 76(sp),d0
		bitmap.Planes[pl][yb + xb] &= ~xo;
     8fc:	0280 0000 ffff 	andi.l #65535,d0
     902:	d280           	add.l d0,d1
     904:	c733 1800      	and.b d3,(0,a3,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     908:	7801           	moveq #1,d4
     90a:	b88a           	cmp.l a2,d4
     90c:	6758           	beq.s 966 <main+0x8f2>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     90e:	1803           	move.b d3,d4
     910:	c836 1800      	and.b (0,a6,d1.l),d4
			bitmap.Planes[pl][yb + xb] |= xo;
     914:	8806           	or.b d6,d4
     916:	1d84 1800      	move.b d4,(0,a6,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     91a:	7802           	moveq #2,d4
     91c:	b88a           	cmp.l a2,d4
     91e:	6746           	beq.s 966 <main+0x8f2>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     920:	c734 1800      	and.b d3,(0,a4,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     924:	7803           	moveq #3,d4
     926:	b88a           	cmp.l a2,d4
     928:	673c           	beq.s 966 <main+0x8f2>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     92a:	c735 1800      	and.b d3,(0,a5,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     92e:	7804           	moveq #4,d4
     930:	b88a           	cmp.l a2,d4
     932:	6732           	beq.s 966 <main+0x8f2>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     934:	226f 0034      	movea.l 52(sp),a1
     938:	c731 1800      	and.b d3,(0,a1,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     93c:	7805           	moveq #5,d4
     93e:	b88a           	cmp.l a2,d4
     940:	6724           	beq.s 966 <main+0x8f2>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     942:	226f 003c      	movea.l 60(sp),a1
     946:	c731 1800      	and.b d3,(0,a1,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     94a:	7806           	moveq #6,d4
     94c:	b88a           	cmp.l a2,d4
     94e:	6716           	beq.s 966 <main+0x8f2>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     950:	226f 0040      	movea.l 64(sp),a1
     954:	c731 1800      	and.b d3,(0,a1,d1.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     958:	7807           	moveq #7,d4
     95a:	b88a           	cmp.l a2,d4
     95c:	6708           	beq.s 966 <main+0x8f2>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     95e:	226f 0044      	movea.l 68(sp),a1
     962:	c731 1800      	and.b d3,(0,a1,d1.l)
     966:	d0af 002e      	add.l 46(sp),d0
     96a:	c533 0800      	and.b d2,(0,a3,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     96e:	7801           	moveq #1,d4
     970:	b88a           	cmp.l a2,d4
     972:	6758           	beq.s 9cc <main+0x958>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     974:	1202           	move.b d2,d1
     976:	c236 0800      	and.b (0,a6,d0.l),d1
			bitmap.Planes[pl][yb + xb] |= xo;
     97a:	8205           	or.b d5,d1
     97c:	1d81 0800      	move.b d1,(0,a6,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     980:	7202           	moveq #2,d1
     982:	b28a           	cmp.l a2,d1
     984:	6746           	beq.s 9cc <main+0x958>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     986:	c534 0800      	and.b d2,(0,a4,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     98a:	7603           	moveq #3,d3
     98c:	b68a           	cmp.l a2,d3
     98e:	673c           	beq.s 9cc <main+0x958>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     990:	c535 0800      	and.b d2,(0,a5,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     994:	7804           	moveq #4,d4
     996:	b88a           	cmp.l a2,d4
     998:	6732           	beq.s 9cc <main+0x958>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     99a:	226f 0034      	movea.l 52(sp),a1
     99e:	c531 0800      	and.b d2,(0,a1,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     9a2:	7205           	moveq #5,d1
     9a4:	b28a           	cmp.l a2,d1
     9a6:	6724           	beq.s 9cc <main+0x958>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     9a8:	226f 003c      	movea.l 60(sp),a1
     9ac:	c531 0800      	and.b d2,(0,a1,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     9b0:	7206           	moveq #6,d1
     9b2:	b28a           	cmp.l a2,d1
     9b4:	6716           	beq.s 9cc <main+0x958>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     9b6:	226f 0040      	movea.l 64(sp),a1
     9ba:	c531 0800      	and.b d2,(0,a1,d0.l)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     9be:	7207           	moveq #7,d1
     9c0:	b28a           	cmp.l a2,d1
     9c2:	6708           	beq.s 9cc <main+0x958>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     9c4:	226f 0044      	movea.l 68(sp),a1
     9c8:	c531 0800      	and.b d2,(0,a1,d0.l)
		e2 = 2 * err;
     9cc:	226f 0038      	movea.l 56(sp),a1
     9d0:	d3c9           	adda.l a1,a1
		if (e2 < (2 * dx + 1) * b2)
     9d2:	2208           	move.l a0,d1
     9d4:	d288           	add.l a0,d1
     9d6:	2401           	move.l d1,d2
     9d8:	5282           	addq.l #1,d2
     9da:	2002           	move.l d2,d0
     9dc:	eb88           	lsl.l #5,d0
     9de:	9082           	sub.l d2,d0
     9e0:	d080           	add.l d0,d0
     9e2:	d080           	add.l d0,d0
     9e4:	d082           	add.l d2,d0
     9e6:	2400           	move.l d0,d2
     9e8:	d480           	add.l d0,d2
     9ea:	d482           	add.l d2,d2
     9ec:	d480           	add.l d0,d2
     9ee:	d482           	add.l d2,d2
     9f0:	d482           	add.l d2,d2
     9f2:	b489           	cmp.l a1,d2
     9f4:	6f20           	ble.s a16 <main+0x9a2>
			dx++;
     9f6:	5288           	addq.l #1,a0
			err += (2 * dx + 1) * b2;
     9f8:	5681           	addq.l #3,d1
     9fa:	2001           	move.l d1,d0
     9fc:	eb88           	lsl.l #5,d0
     9fe:	9081           	sub.l d1,d0
     a00:	d080           	add.l d0,d0
     a02:	d080           	add.l d0,d0
     a04:	d280           	add.l d0,d1
     a06:	2001           	move.l d1,d0
     a08:	d081           	add.l d1,d0
     a0a:	d080           	add.l d0,d0
     a0c:	d081           	add.l d1,d0
     a0e:	d080           	add.l d0,d0
     a10:	d080           	add.l d0,d0
     a12:	d1af 0038      	add.l d0,56(sp)
		if (e2 > -(2 * dy - 1) * a2)
     a16:	7201           	moveq #1,d1
     a18:	92af 0048      	sub.l 72(sp),d1
     a1c:	2001           	move.l d1,d0
     a1e:	eb88           	lsl.l #5,d0
     a20:	9081           	sub.l d1,d0
     a22:	d080           	add.l d0,d0
     a24:	d080           	add.l d0,d0
     a26:	d081           	add.l d1,d0
     a28:	2200           	move.l d0,d1
     a2a:	d280           	add.l d0,d1
     a2c:	d281           	add.l d1,d1
     a2e:	d280           	add.l d0,d1
     a30:	d281           	add.l d1,d1
     a32:	d281           	add.l d1,d1
     a34:	b289           	cmp.l a1,d1
     a36:	6c3e           	bge.s a76 <main+0xa02>
			dy--;
     a38:	5387           	subq.l #1,d7
			err -= (2 * dy - 1) * a2;
     a3a:	222f 0048      	move.l 72(sp),d1
     a3e:	5781           	subq.l #3,d1
     a40:	2001           	move.l d1,d0
     a42:	eb88           	lsl.l #5,d0
     a44:	9081           	sub.l d1,d0
     a46:	d080           	add.l d0,d0
     a48:	d080           	add.l d0,d0
     a4a:	d081           	add.l d1,d0
     a4c:	2200           	move.l d0,d1
     a4e:	d280           	add.l d0,d1
     a50:	d281           	add.l d1,d1
     a52:	d280           	add.l d0,d1
     a54:	d281           	add.l d1,d1
     a56:	d281           	add.l d1,d1
     a58:	93af 0038      	sub.l d1,56(sp)
	} while (dy >= 0);
     a5c:	4a87           	tst.l d7
     a5e:	6d1c           	blt.s a7c <main+0xa08>
     a60:	3007           	move.w d7,d0
     a62:	0640 0050      	addi.w #80,d0
     a66:	3f40 0050      	move.w d0,80(sp)
     a6a:	2207           	move.l d7,d1
     a6c:	d287           	add.l d7,d1
     a6e:	2f41 0048      	move.l d1,72(sp)
     a72:	6000 fd5a      	bra.w 7ce <main+0x75a>
     a76:	4a87           	tst.l d7
     a78:	6c00 fd54      	bge.w 7ce <main+0x75a>
inline short MouseLeft() { return !((*(volatile UBYTE *)0xbfe001) & 64); }
     a7c:	2a6f 0058      	movea.l 88(sp),a5
     a80:	1039 00bf e001 	move.b bfe001 <_end+0xbecf51>,d0
	while (!MouseLeft())
     a86:	0800 0006      	btst #6,d0
     a8a:	6600 fb12      	bne.w 59e <main+0x52a>
}

void FreeSystem(void)
{
    WaitVbl();
     a8e:	4eb9 0000 0c7e 	jsr c7e <WaitVbl>
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
     a94:	302d 0002      	move.w 2(a5),d0
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
     a98:	302d 0002      	move.w 2(a5),d0
     a9c:	0800 000e      	btst #14,d0
     aa0:	66f6           	bne.s a98 <main+0xa24>
    WaitBlt();
    custom->intena = 0x7fff; //disable all interrupts
     aa2:	3b7c 7fff 009a 	move.w #32767,154(a5)
    custom->intreq = 0x7fff; //Clear any interrupts that were pending
     aa8:	3b7c 7fff 009c 	move.w #32767,156(a5)
    custom->dmacon = 0x7fff; //Clear all DMA channels
     aae:	3b7c 7fff 0096 	move.w #32767,150(a5)
    *(volatile APTR *)(((UBYTE *)VBR) + 0x6c) = interrupt;
     ab4:	2079 0001 1072 	movea.l 11072 <VBR>,a0
     aba:	2179 0001 1076 	move.l 11076 <SystemIrq>,108(a0)
     ac0:	006c 

    //restore interrupts
    SetInterruptHandler(SystemIrq);

    /*Restore system copper list(s). */
    custom->cop1lc = (ULONG)GfxBase->copinit;
     ac2:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
     ac8:	2b6e 0026 0080 	move.l 38(a6),128(a5)
    custom->cop2lc = (ULONG)GfxBase->LOFlist;
     ace:	2b6e 0032 0084 	move.l 50(a6),132(a5)
    custom->copjmp1 = 0x7fff; //start coppper
     ad4:	3b7c 7fff 0088 	move.w #32767,136(a5)

    /*Restore all interrupts and DMA settings. */
    custom->intena = SystemInts | 0x8000;
     ada:	3039 0001 1070 	move.w 11070 <SystemInts>,d0
     ae0:	0040 8000      	ori.w #-32768,d0
     ae4:	3b40 009a      	move.w d0,154(a5)
    custom->dmacon = SystemDMA | 0x8000;
     ae8:	3039 0001 106e 	move.w 1106e <SystemDMA>,d0
     aee:	0040 8000      	ori.w #-32768,d0
     af2:	3b40 0096      	move.w d0,150(a5)
    custom->adkcon = SystemADKCON | 0x8000;
     af6:	3039 0001 106c 	move.w 1106c <SystemADKCON>,d0
     afc:	0040 8000      	ori.w #-32768,d0
     b00:	3b40 009e      	move.w d0,158(a5)

    LoadView(ActiView);
     b04:	2279 0001 1068 	movea.l 11068 <ActiView>,a1
     b0a:	4eae ff22      	jsr -222(a6)
    WaitTOF();
     b0e:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
     b14:	4eae fef2      	jsr -270(a6)
    WaitTOF();
     b18:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
     b1e:	4eae fef2      	jsr -270(a6)
    WaitBlit();
     b22:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
     b28:	4eae ff1c      	jsr -228(a6)
    DisownBlitter();
     b2c:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
     b32:	4eae fe32      	jsr -462(a6)
    Enable();
     b36:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
     b3c:	4eae ff82      	jsr -126(a6)
	CloseLibrary((struct Library *)DOSBase);
     b40:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
     b46:	2279 0001 1082 	movea.l 11082 <DOSBase>,a1
     b4c:	4eae fe62      	jsr -414(a6)
	CloseLibrary((struct Library *)GfxBase);
     b50:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
     b56:	2279 0001 107a 	movea.l 1107a <GfxBase>,a1
     b5c:	4eae fe62      	jsr -414(a6)
}
     b60:	7000           	moveq #0,d0
     b62:	4cdf 7cfc      	movem.l (sp)+,d2-d7/a2-a6
     b66:	4fef 006c      	lea 108(sp),sp
     b6a:	4e75           	rts
		Exit(0);
     b6c:	9dce           	suba.l a6,a6
     b6e:	7200           	moveq #0,d1
     b70:	4eae ff70      	jsr -144(a6)
	KPrintF("Hello debugger from Amiga!\n");
     b74:	4879 0000 14a1 	pea 14a1 <PutChar+0x69>
     b7a:	4eb9 0000 0fe0 	jsr fe0 <KPrintF>
	Write(Output(), (APTR) "Hello console!\n", 15);
     b80:	2c79 0001 1082 	movea.l 11082 <DOSBase>,a6
     b86:	4eae ffc4      	jsr -60(a6)
     b8a:	2c79 0001 1082 	movea.l 11082 <DOSBase>,a6
     b90:	2200           	move.l d0,d1
     b92:	243c 0000 14bd 	move.l #5309,d2
     b98:	760f           	moveq #15,d3
     b9a:	4eae ffd0      	jsr -48(a6)
	warpmode(1);
     b9e:	4878 0001      	pea 1 <_start+0x1>
     ba2:	45f9 0000 1052 	lea 1052 <warpmode>,a2
     ba8:	4e92           	jsr (a2)
	warpmode(0);
     baa:	42a7           	clr.l -(sp)
     bac:	4e92           	jsr (a2)
    ActiView = GfxBase->ActiView; //store current view
     bae:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
     bb4:	23ee 0022 0001 	move.l 34(a6),11068 <ActiView>
     bba:	1068 
    OwnBlitter();
     bbc:	4eae fe38      	jsr -456(a6)
    WaitBlit();
     bc0:	2c79 0001 107a 	movea.l 1107a <GfxBase>,a6
     bc6:	4eae ff1c      	jsr -228(a6)
    Disable();
     bca:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
     bd0:	4eae ff88      	jsr -120(a6)
    SystemADKCON = custom->adkconr;
     bd4:	2479 0001 10aa 	movea.l 110aa <custom>,a2
     bda:	302a 0010      	move.w 16(a2),d0
     bde:	33c0 0001 106c 	move.w d0,1106c <SystemADKCON>
    SystemInts = custom->intenar;
     be4:	302a 001c      	move.w 28(a2),d0
     be8:	33c0 0001 1070 	move.w d0,11070 <SystemInts>
    SystemDMA = custom->dmaconr;
     bee:	302a 0002      	move.w 2(a2),d0
     bf2:	33c0 0001 106e 	move.w d0,1106e <SystemDMA>
    custom->intena = 0x7fff; //disable all interrupts
     bf8:	357c 7fff 009a 	move.w #32767,154(a2)
    custom->intreq = 0x7fff; //Clear any interrupts that were pending
     bfe:	357c 7fff 009c 	move.w #32767,156(a2)
    WaitVbl();
     c04:	4eb9 0000 0c7e 	jsr c7e <WaitVbl>
    WaitVbl();
     c0a:	4eb9 0000 0c7e 	jsr c7e <WaitVbl>
    custom->dmacon = 0x7fff; //Clear all DMA channels
     c10:	357c 7fff 0096 	move.w #32767,150(a2)
     c16:	4fef 000c      	lea 12(sp),sp
    for (int a = 0; a < 32; a++)
     c1a:	7200           	moveq #0,d1
     c1c:	6000 f54c      	bra.w 16a <main+0xf6>
		Exit(0);
     c20:	2c79 0001 1082 	movea.l 11082 <DOSBase>,a6
     c26:	7200           	moveq #0,d1
     c28:	4eae ff70      	jsr -144(a6)
	DOSBase = (struct DosLibrary *)OpenLibrary((CONST_STRPTR) "dos.library", 0);
     c2c:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
     c32:	43f9 0000 1495 	lea 1495 <PutChar+0x5d>,a1
     c38:	7000           	moveq #0,d0
     c3a:	4eae fdd8      	jsr -552(a6)
     c3e:	23c0 0001 1082 	move.l d0,11082 <DOSBase>
	if (!DOSBase)
     c44:	6600 f47c      	bne.w c2 <main+0x4e>
     c48:	6000 ff22      	bra.w b6c <main+0xaf8>
    APTR vbr = 0;
     c4c:	7000           	moveq #0,d0
     c4e:	6000 f58c      	bra.w 1dc <main+0x168>
     c52:	4e71           	nop

00000c54 <interruptHandler>:
{
     c54:	2f08           	move.l a0,-(sp)
     c56:	2f00           	move.l d0,-(sp)
    custom->intreq = (1 << INTB_VERTB);
     c58:	2079 0001 10aa 	movea.l 110aa <custom>,a0
     c5e:	317c 0020 009c 	move.w #32,156(a0)
    custom->intreq = (1 << INTB_VERTB); //reset vbl req. twice for a4000 bug.
     c64:	317c 0020 009c 	move.w #32,156(a0)
    frameCounter++;
     c6a:	2039 0001 10a6 	move.l 110a6 <frameCounter>,d0
     c70:	5280           	addq.l #1,d0
     c72:	23c0 0001 10a6 	move.l d0,110a6 <frameCounter>
}
     c78:	201f           	move.l (sp)+,d0
     c7a:	205f           	movea.l (sp)+,a0
     c7c:	4e73           	rte

00000c7e <WaitVbl>:
{
     c7e:	518f           	subq.l #8,sp
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
     c80:	2039 00df f004 	move.l dff004 <_end+0xdedf54>,d0
     c86:	2e80           	move.l d0,(sp)
        vpos &= 0x1ff00;
     c88:	2017           	move.l (sp),d0
     c8a:	0280 0001 ff00 	andi.l #130816,d0
     c90:	2e80           	move.l d0,(sp)
        if (vpos != (311 << 8))
     c92:	2017           	move.l (sp),d0
     c94:	0c80 0001 3700 	cmpi.l #79616,d0
     c9a:	67e4           	beq.s c80 <WaitVbl+0x2>
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
     c9c:	2039 00df f004 	move.l dff004 <_end+0xdedf54>,d0
     ca2:	2f40 0004      	move.l d0,4(sp)
        vpos &= 0x1ff00;
     ca6:	202f 0004      	move.l 4(sp),d0
     caa:	0280 0001 ff00 	andi.l #130816,d0
     cb0:	2f40 0004      	move.l d0,4(sp)
        if (vpos == (311 << 8))
     cb4:	202f 0004      	move.l 4(sp),d0
     cb8:	0c80 0001 3700 	cmpi.l #79616,d0
     cbe:	66dc           	bne.s c9c <WaitVbl+0x1e>
}
     cc0:	508f           	addq.l #8,sp
     cc2:	4e75           	rts

00000cc4 <LineDraw>:
{
     cc4:	4fef ffa4      	lea -92(sp),sp
     cc8:	48e7 3f3e      	movem.l d2-d7/a2-a6,-(sp)
     ccc:	262f 00bc      	move.l 188(sp),d3
     cd0:	282f 00c0      	move.l 192(sp),d4
     cd4:	222f 00cc      	move.l 204(sp),d1
     cd8:	3a6f 0094      	movea.w 148(sp),a5
     cdc:	1f6f 0096 0030 	move.b 150(sp),48(sp)
	int dx = Abs(x1 - x0), sx = x0 < x1 ? 1 : -1;
     ce2:	2a2f 00c4      	move.l 196(sp),d5
     ce6:	9a83           	sub.l d3,d5
     ce8:	6b00 02ec      	bmi.w fd6 <LineDraw+0x312>
     cec:	b6af 00c4      	cmp.l 196(sp),d3
     cf0:	6d00 02c8      	blt.w fba <LineDraw+0x2f6>
     cf4:	70ff           	moveq #-1,d0
     cf6:	2f40 0048      	move.l d0,72(sp)
	int dy = -Abs(y1 - y0), sy = y0 < y1 ? 1 : -1;
     cfa:	202f 00c8      	move.l 200(sp),d0
     cfe:	9084           	sub.l d4,d0
     d00:	6b00 02c8      	bmi.w fca <LineDraw+0x306>
     d04:	2e04           	move.l d4,d7
     d06:	9eaf 00c8      	sub.l 200(sp),d7
     d0a:	b8af 00c8      	cmp.l 200(sp),d4
     d0e:	6d00 021e      	blt.w f2e <LineDraw+0x26a>
     d12:	70ff           	moveq #-1,d0
     d14:	2f40 004c      	move.l d0,76(sp)
	int err = dx + dy, e2; /* error value e_xy */
     d18:	2245           	movea.l d5,a1
     d1a:	d3c7           	adda.l d7,a1
	for (int pl = 0; pl < bitmap.Depth; pl++)
     d1c:	304d           	movea.w a5,a0
		SetPixel(bitmap, x0, y0, col);
     d1e:	7000           	moveq #0,d0
     d20:	1001           	move.b d1,d0
	USHORT yb = y * bitmap.BytesPerRow;
     d22:	4242           	clr.w d2
     d24:	142f 0030      	move.b 48(sp),d2
     d28:	3f42 0042      	move.w d2,66(sp)
     d2c:	0201 0001      	andi.b #1,d1
     d30:	1f41 0031      	move.b d1,49(sp)
		if ((col >> pl) & (UBYTE)1)
     d34:	2200           	move.l d0,d1
     d36:	e281           	asr.l #1,d1
     d38:	7401           	moveq #1,d2
     d3a:	c481           	and.l d1,d2
     d3c:	2f42 0032      	move.l d2,50(sp)
     d40:	2200           	move.l d0,d1
     d42:	e481           	asr.l #2,d1
     d44:	7401           	moveq #1,d2
     d46:	c481           	and.l d1,d2
     d48:	2f42 0036      	move.l d2,54(sp)
     d4c:	2200           	move.l d0,d1
     d4e:	e681           	asr.l #3,d1
     d50:	7401           	moveq #1,d2
     d52:	c481           	and.l d1,d2
     d54:	2f42 003a      	move.l d2,58(sp)
     d58:	2200           	move.l d0,d1
     d5a:	e881           	asr.l #4,d1
     d5c:	7401           	moveq #1,d2
     d5e:	c481           	and.l d1,d2
     d60:	2f42 003e      	move.l d2,62(sp)
     d64:	2200           	move.l d0,d1
     d66:	ea81           	asr.l #5,d1
     d68:	7401           	moveq #1,d2
     d6a:	c481           	and.l d1,d2
     d6c:	2f42 0044      	move.l d2,68(sp)
     d70:	2200           	move.l d0,d1
     d72:	ec81           	asr.l #6,d1
     d74:	7401           	moveq #1,d2
     d76:	c481           	and.l d1,d2
     d78:	2f42 0050      	move.l d2,80(sp)
     d7c:	ee80           	asr.l #7,d0
     d7e:	2f40 0054      	move.l d0,84(sp)
     d82:	3003           	move.w d3,d0
     d84:	e648           	lsr.w #3,d0
     d86:	3840           	movea.w d0,a4
     d88:	3c03           	move.w d3,d6
     d8a:	0246 0007      	andi.w #7,d6
     d8e:	322f 0042      	move.w 66(sp),d1
     d92:	c3c4           	muls.w d4,d1
     d94:	3641           	movea.w d1,a3
	UBYTE xo = 0x80 >> (x % 8);
     d96:	2f45 002c      	move.l d5,44(sp)
		SetPixel(bitmap, x0, y0, col);
     d9a:	3f4d 0094      	move.w a5,148(sp)
     d9e:	1f6f 0030 0096 	move.b 48(sp),150(sp)
     da4:	2f6f 008c 0058 	move.l 140(sp),88(sp)
     daa:	2f6f 0090 005c 	move.l 144(sp),92(sp)
     db0:	2f6f 0094 0060 	move.l 148(sp),96(sp)
     db6:	2f6f 0098 0064 	move.l 152(sp),100(sp)
     dbc:	2f6f 009c 0068 	move.l 156(sp),104(sp)
     dc2:	2f6f 00a0 006c 	move.l 160(sp),108(sp)
     dc8:	2f6f 00a4 0070 	move.l 164(sp),112(sp)
     dce:	2f6f 00a8 0074 	move.l 168(sp),116(sp)
     dd4:	2f6f 00ac 0078 	move.l 172(sp),120(sp)
     dda:	2f6f 00b0 007c 	move.l 176(sp),124(sp)
     de0:	2f6f 00b4 0080 	move.l 180(sp),128(sp)
     de6:	2f6f 00b8 0084 	move.l 184(sp),132(sp)
	UBYTE xo = 0x80 >> (x % 8);
     dec:	7000           	moveq #0,d0
     dee:	3006           	move.w d6,d0
     df0:	727f           	moveq #127,d1
     df2:	4601           	not.b d1
     df4:	e0a1           	asr.l d0,d1
	for (int pl = 0; pl < bitmap.Depth; pl++)
     df6:	b0fc 0000      	cmpa.w #0,a0
     dfa:	6f00 00dc      	ble.w ed8 <LineDraw+0x214>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     dfe:	7000           	moveq #0,d0
     e00:	300b           	move.w a3,d0
     e02:	7400           	moveq #0,d2
     e04:	340c           	move.w a4,d2
     e06:	d082           	add.l d2,d0
     e08:	1401           	move.b d1,d2
     e0a:	4602           	not.b d2
     e0c:	246f 0068      	movea.l 104(sp),a2
     e10:	d5c0           	adda.l d0,a2
     e12:	1a02           	move.b d2,d5
     e14:	ca12           	and.b (a2),d5
		if ((col >> pl) & (UBYTE)1)
     e16:	4a2f 0031      	tst.b 49(sp)
     e1a:	6702           	beq.s e1e <LineDraw+0x15a>
			bitmap.Planes[pl][yb + xb] |= xo;
     e1c:	8a01           	or.b d1,d5
     e1e:	1485           	move.b d5,(a2)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     e20:	7a01           	moveq #1,d5
     e22:	ba88           	cmp.l a0,d5
     e24:	6700 00b2      	beq.w ed8 <LineDraw+0x214>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     e28:	246f 006c      	movea.l 108(sp),a2
     e2c:	d5c0           	adda.l d0,a2
     e2e:	1a02           	move.b d2,d5
     e30:	ca12           	and.b (a2),d5
		if ((col >> pl) & (UBYTE)1)
     e32:	4aaf 0032      	tst.l 50(sp)
     e36:	6702           	beq.s e3a <LineDraw+0x176>
			bitmap.Planes[pl][yb + xb] |= xo;
     e38:	8a01           	or.b d1,d5
     e3a:	1485           	move.b d5,(a2)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     e3c:	7a02           	moveq #2,d5
     e3e:	ba88           	cmp.l a0,d5
     e40:	6700 0096      	beq.w ed8 <LineDraw+0x214>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     e44:	246f 0070      	movea.l 112(sp),a2
     e48:	d5c0           	adda.l d0,a2
     e4a:	1a02           	move.b d2,d5
     e4c:	ca12           	and.b (a2),d5
		if ((col >> pl) & (UBYTE)1)
     e4e:	4aaf 0036      	tst.l 54(sp)
     e52:	6702           	beq.s e56 <LineDraw+0x192>
			bitmap.Planes[pl][yb + xb] |= xo;
     e54:	8a01           	or.b d1,d5
     e56:	1485           	move.b d5,(a2)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     e58:	7a03           	moveq #3,d5
     e5a:	ba88           	cmp.l a0,d5
     e5c:	677a           	beq.s ed8 <LineDraw+0x214>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     e5e:	246f 0074      	movea.l 116(sp),a2
     e62:	d5c0           	adda.l d0,a2
     e64:	1a02           	move.b d2,d5
     e66:	ca12           	and.b (a2),d5
		if ((col >> pl) & (UBYTE)1)
     e68:	4aaf 003a      	tst.l 58(sp)
     e6c:	6702           	beq.s e70 <LineDraw+0x1ac>
			bitmap.Planes[pl][yb + xb] |= xo;
     e6e:	8a01           	or.b d1,d5
     e70:	1485           	move.b d5,(a2)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     e72:	7a04           	moveq #4,d5
     e74:	ba88           	cmp.l a0,d5
     e76:	6760           	beq.s ed8 <LineDraw+0x214>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     e78:	246f 0078      	movea.l 120(sp),a2
     e7c:	d5c0           	adda.l d0,a2
     e7e:	1a02           	move.b d2,d5
     e80:	ca12           	and.b (a2),d5
		if ((col >> pl) & (UBYTE)1)
     e82:	4aaf 003e      	tst.l 62(sp)
     e86:	6702           	beq.s e8a <LineDraw+0x1c6>
			bitmap.Planes[pl][yb + xb] |= xo;
     e88:	8a01           	or.b d1,d5
     e8a:	1485           	move.b d5,(a2)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     e8c:	7a05           	moveq #5,d5
     e8e:	ba88           	cmp.l a0,d5
     e90:	6746           	beq.s ed8 <LineDraw+0x214>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     e92:	246f 007c      	movea.l 124(sp),a2
     e96:	d5c0           	adda.l d0,a2
     e98:	1a02           	move.b d2,d5
     e9a:	ca12           	and.b (a2),d5
		if ((col >> pl) & (UBYTE)1)
     e9c:	4aaf 0044      	tst.l 68(sp)
     ea0:	6702           	beq.s ea4 <LineDraw+0x1e0>
			bitmap.Planes[pl][yb + xb] |= xo;
     ea2:	8a01           	or.b d1,d5
     ea4:	1485           	move.b d5,(a2)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     ea6:	7a06           	moveq #6,d5
     ea8:	ba88           	cmp.l a0,d5
     eaa:	672c           	beq.s ed8 <LineDraw+0x214>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     eac:	246f 0080      	movea.l 128(sp),a2
     eb0:	d5c0           	adda.l d0,a2
     eb2:	1a02           	move.b d2,d5
     eb4:	ca12           	and.b (a2),d5
		if ((col >> pl) & (UBYTE)1)
     eb6:	4aaf 0050      	tst.l 80(sp)
     eba:	6702           	beq.s ebe <LineDraw+0x1fa>
			bitmap.Planes[pl][yb + xb] |= xo;
     ebc:	8a01           	or.b d1,d5
     ebe:	1485           	move.b d5,(a2)
	for (int pl = 0; pl < bitmap.Depth; pl++)
     ec0:	7a07           	moveq #7,d5
     ec2:	ba88           	cmp.l a0,d5
     ec4:	6712           	beq.s ed8 <LineDraw+0x214>
		bitmap.Planes[pl][yb + xb] &= ~xo;
     ec6:	246f 0084      	movea.l 132(sp),a2
     eca:	d5c0           	adda.l d0,a2
     ecc:	c412           	and.b (a2),d2
		if ((col >> pl) & (UBYTE)1)
     ece:	4aaf 0054      	tst.l 84(sp)
     ed2:	6750           	beq.s f24 <LineDraw+0x260>
			bitmap.Planes[pl][yb + xb] |= xo;
     ed4:	8401           	or.b d1,d2
     ed6:	1482           	move.b d2,(a2)
		if (x0 == x1 && y0 == y1)
     ed8:	b6af 00c4      	cmp.l 196(sp),d3
     edc:	6736           	beq.s f14 <LineDraw+0x250>
		e2 = 2 * err;
     ede:	2009           	move.l a1,d0
     ee0:	d089           	add.l a1,d0
		if (e2 > dy)
     ee2:	b087           	cmp.l d7,d0
     ee4:	6f12           	ble.s ef8 <LineDraw+0x234>
			err += dy;
     ee6:	d3c7           	adda.l d7,a1
			x0 += sx;
     ee8:	d6af 0048      	add.l 72(sp),d3
     eec:	3203           	move.w d3,d1
     eee:	e649           	lsr.w #3,d1
     ef0:	3841           	movea.w d1,a4
     ef2:	3c03           	move.w d3,d6
     ef4:	0246 0007      	andi.w #7,d6
		if (e2 < dx)
     ef8:	b0af 002c      	cmp.l 44(sp),d0
     efc:	6c00 fe9c      	bge.w d9a <LineDraw+0xd6>
			err += dx;
     f00:	d3ef 002c      	adda.l 44(sp),a1
			y0 += sy;
     f04:	d8af 004c      	add.l 76(sp),d4
     f08:	342f 0042      	move.w 66(sp),d2
     f0c:	c5c4           	muls.w d4,d2
     f0e:	3642           	movea.w d2,a3
     f10:	6000 fe88      	bra.w d9a <LineDraw+0xd6>
		if (x0 == x1 && y0 == y1)
     f14:	b8af 00c8      	cmp.l 200(sp),d4
     f18:	66c4           	bne.s ede <LineDraw+0x21a>
}
     f1a:	4cdf 7cfc      	movem.l (sp)+,d2-d7/a2-a6
     f1e:	4fef 005c      	lea 92(sp),sp
     f22:	4e75           	rts
		bitmap.Planes[pl][yb + xb] &= ~xo;
     f24:	1482           	move.b d2,(a2)
		if (x0 == x1 && y0 == y1)
     f26:	b6af 00c4      	cmp.l 196(sp),d3
     f2a:	66b2           	bne.s ede <LineDraw+0x21a>
     f2c:	60e6           	bra.s f14 <LineDraw+0x250>
	int dy = -Abs(y1 - y0), sy = y0 < y1 ? 1 : -1;
     f2e:	7401           	moveq #1,d2
     f30:	2f42 004c      	move.l d2,76(sp)
	int err = dx + dy, e2; /* error value e_xy */
     f34:	2245           	movea.l d5,a1
     f36:	d3c7           	adda.l d7,a1
	for (int pl = 0; pl < bitmap.Depth; pl++)
     f38:	304d           	movea.w a5,a0
		SetPixel(bitmap, x0, y0, col);
     f3a:	7000           	moveq #0,d0
     f3c:	1001           	move.b d1,d0
	USHORT yb = y * bitmap.BytesPerRow;
     f3e:	4242           	clr.w d2
     f40:	142f 0030      	move.b 48(sp),d2
     f44:	3f42 0042      	move.w d2,66(sp)
     f48:	0201 0001      	andi.b #1,d1
     f4c:	1f41 0031      	move.b d1,49(sp)
		if ((col >> pl) & (UBYTE)1)
     f50:	2200           	move.l d0,d1
     f52:	e281           	asr.l #1,d1
     f54:	7401           	moveq #1,d2
     f56:	c481           	and.l d1,d2
     f58:	2f42 0032      	move.l d2,50(sp)
     f5c:	2200           	move.l d0,d1
     f5e:	e481           	asr.l #2,d1
     f60:	7401           	moveq #1,d2
     f62:	c481           	and.l d1,d2
     f64:	2f42 0036      	move.l d2,54(sp)
     f68:	2200           	move.l d0,d1
     f6a:	e681           	asr.l #3,d1
     f6c:	7401           	moveq #1,d2
     f6e:	c481           	and.l d1,d2
     f70:	2f42 003a      	move.l d2,58(sp)
     f74:	2200           	move.l d0,d1
     f76:	e881           	asr.l #4,d1
     f78:	7401           	moveq #1,d2
     f7a:	c481           	and.l d1,d2
     f7c:	2f42 003e      	move.l d2,62(sp)
     f80:	2200           	move.l d0,d1
     f82:	ea81           	asr.l #5,d1
     f84:	7401           	moveq #1,d2
     f86:	c481           	and.l d1,d2
     f88:	2f42 0044      	move.l d2,68(sp)
     f8c:	2200           	move.l d0,d1
     f8e:	ec81           	asr.l #6,d1
     f90:	7401           	moveq #1,d2
     f92:	c481           	and.l d1,d2
     f94:	2f42 0050      	move.l d2,80(sp)
     f98:	ee80           	asr.l #7,d0
     f9a:	2f40 0054      	move.l d0,84(sp)
     f9e:	3003           	move.w d3,d0
     fa0:	e648           	lsr.w #3,d0
     fa2:	3840           	movea.w d0,a4
     fa4:	3c03           	move.w d3,d6
     fa6:	0246 0007      	andi.w #7,d6
     faa:	322f 0042      	move.w 66(sp),d1
     fae:	c3c4           	muls.w d4,d1
     fb0:	3641           	movea.w d1,a3
	UBYTE xo = 0x80 >> (x % 8);
     fb2:	2f45 002c      	move.l d5,44(sp)
     fb6:	6000 fde2      	bra.w d9a <LineDraw+0xd6>
	int dx = Abs(x1 - x0), sx = x0 < x1 ? 1 : -1;
     fba:	7401           	moveq #1,d2
     fbc:	2f42 0048      	move.l d2,72(sp)
	int dy = -Abs(y1 - y0), sy = y0 < y1 ? 1 : -1;
     fc0:	202f 00c8      	move.l 200(sp),d0
     fc4:	9084           	sub.l d4,d0
     fc6:	6a00 fd3c      	bpl.w d04 <LineDraw+0x40>
     fca:	2e2f 00c8      	move.l 200(sp),d7
     fce:	de84           	add.l d4,d7
     fd0:	4487           	neg.l d7
     fd2:	6000 fd36      	bra.w d0a <LineDraw+0x46>
	int dx = Abs(x1 - x0), sx = x0 < x1 ? 1 : -1;
     fd6:	2a2f 00c4      	move.l 196(sp),d5
     fda:	da83           	add.l d3,d5
     fdc:	6000 fd0e      	bra.w cec <LineDraw+0x28>

00000fe0 <KPrintF>:
{
     fe0:	4fef ff80      	lea -128(sp),sp
     fe4:	48e7 0032      	movem.l a2-a3/a6,-(sp)
    if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
     fe8:	3039 00f0 ff60 	move.w f0ff60 <_end+0xefeeb0>,d0
     fee:	0c40 4eb9      	cmpi.w #20153,d0
     ff2:	672a           	beq.s 101e <KPrintF+0x3e>
     ff4:	0c40 a00e      	cmpi.w #-24562,d0
     ff8:	6724           	beq.s 101e <KPrintF+0x3e>
		RawDoFmt((CONST_STRPTR)fmt, vl, KPutCharX, 0);
     ffa:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
    1000:	206f 0090      	movea.l 144(sp),a0
    1004:	43ef 0094      	lea 148(sp),a1
    1008:	45f9 0000 142a 	lea 142a <KPutCharX>,a2
    100e:	97cb           	suba.l a3,a3
    1010:	4eae fdf6      	jsr -522(a6)
}
    1014:	4cdf 4c00      	movem.l (sp)+,a2-a3/a6
    1018:	4fef 0080      	lea 128(sp),sp
    101c:	4e75           	rts
		RawDoFmt((CONST_STRPTR)fmt, vl, PutChar, temp);
    101e:	2c79 0001 107e 	movea.l 1107e <SysBase>,a6
    1024:	206f 0090      	movea.l 144(sp),a0
    1028:	43ef 0094      	lea 148(sp),a1
    102c:	45f9 0000 1438 	lea 1438 <PutChar>,a2
    1032:	47ef 000c      	lea 12(sp),a3
    1036:	4eae fdf6      	jsr -522(a6)
		UaeDbgLog(86, temp);
    103a:	2f0b           	move.l a3,-(sp)
    103c:	4878 0056      	pea 56 <_start+0x56>
    1040:	4eb9 00f0 ff60 	jsr f0ff60 <_end+0xefeeb0>
    1046:	508f           	addq.l #8,sp
}
    1048:	4cdf 4c00      	movem.l (sp)+,a2-a3/a6
    104c:	4fef 0080      	lea 128(sp),sp
    1050:	4e75           	rts

00001052 <warpmode>:

void warpmode(int on) // bool
{
    1052:	598f           	subq.l #4,sp
    1054:	2f02           	move.l d2,-(sp)
	long(*UaeConf)(long mode, int index, const char* param, int param_len, char* outbuf, int outbuf_len);
	UaeConf = (long(*)(long, int, const char*, int, char*, int))0xf0ff60;
    if(*((UWORD *)UaeConf) == 0x4eb9 || *((UWORD *)UaeConf) == 0xa00e) {
    1056:	3039 00f0 ff60 	move.w f0ff60 <_end+0xefeeb0>,d0
    105c:	0c40 4eb9      	cmpi.w #20153,d0
    1060:	670c           	beq.s 106e <warpmode+0x1c>
    1062:	0c40 a00e      	cmpi.w #-24562,d0
    1066:	6706           	beq.s 106e <warpmode+0x1c>
		char outbuf;
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
	}
}
    1068:	241f           	move.l (sp)+,d2
    106a:	588f           	addq.l #4,sp
    106c:	4e75           	rts
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
    106e:	4aaf 000c      	tst.l 12(sp)
    1072:	674c           	beq.s 10c0 <warpmode+0x6e>
    1074:	4878 0001      	pea 1 <_start+0x1>
    1078:	740b           	moveq #11,d2
    107a:	d48f           	add.l sp,d2
    107c:	2f02           	move.l d2,-(sp)
    107e:	42a7           	clr.l -(sp)
    1080:	4879 0000 147a 	pea 147a <PutChar+0x42>
    1086:	4878 ffff      	pea ffffffff <_end+0xfffeef4f>
    108a:	4878 0052      	pea 52 <_start+0x52>
    108e:	4eb9 00f0 ff60 	jsr f0ff60 <_end+0xefeeb0>
    1094:	4fef 0018      	lea 24(sp),sp
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
    1098:	203c 0000 1455 	move.l #5205,d0
    109e:	4878 0001      	pea 1 <_start+0x1>
    10a2:	2f02           	move.l d2,-(sp)
    10a4:	42a7           	clr.l -(sp)
    10a6:	2f00           	move.l d0,-(sp)
    10a8:	4878 ffff      	pea ffffffff <_end+0xfffeef4f>
    10ac:	4878 0052      	pea 52 <_start+0x52>
    10b0:	4eb9 00f0 ff60 	jsr f0ff60 <_end+0xefeeb0>
    10b6:	4fef 0018      	lea 24(sp),sp
}
    10ba:	241f           	move.l (sp)+,d2
    10bc:	588f           	addq.l #4,sp
    10be:	4e75           	rts
		UaeConf(82, -1, on ? "warp true" : "warp false", 0, &outbuf, 1);
    10c0:	4878 0001      	pea 1 <_start+0x1>
    10c4:	740b           	moveq #11,d2
    10c6:	d48f           	add.l sp,d2
    10c8:	2f02           	move.l d2,-(sp)
    10ca:	42a7           	clr.l -(sp)
    10cc:	4879 0000 146f 	pea 146f <PutChar+0x37>
    10d2:	4878 ffff      	pea ffffffff <_end+0xfffeef4f>
    10d6:	4878 0052      	pea 52 <_start+0x52>
    10da:	4eb9 00f0 ff60 	jsr f0ff60 <_end+0xefeeb0>
    10e0:	4fef 0018      	lea 24(sp),sp
		UaeConf(82, -1, on ? "blitter_cycle_exact false" : "blitter_cycle_exact true", 0, &outbuf, 1);
    10e4:	203c 0000 143c 	move.l #5180,d0
    10ea:	4878 0001      	pea 1 <_start+0x1>
    10ee:	2f02           	move.l d2,-(sp)
    10f0:	42a7           	clr.l -(sp)
    10f2:	2f00           	move.l d0,-(sp)
    10f4:	4878 ffff      	pea ffffffff <_end+0xfffeef4f>
    10f8:	4878 0052      	pea 52 <_start+0x52>
    10fc:	4eb9 00f0 ff60 	jsr f0ff60 <_end+0xefeeb0>
    1102:	4fef 0018      	lea 24(sp),sp
    1106:	60b2           	bra.s 10ba <warpmode+0x68>

00001108 <strlen>:
{
    1108:	206f 0004      	movea.l 4(sp),a0
	unsigned long t=0;
    110c:	7000           	moveq #0,d0
	while(*s++)
    110e:	4a10           	tst.b (a0)
    1110:	6708           	beq.s 111a <strlen+0x12>
		t++;
    1112:	5280           	addq.l #1,d0
	while(*s++)
    1114:	4a30 0800      	tst.b (0,a0,d0.l)
    1118:	66f8           	bne.s 1112 <strlen+0xa>
}
    111a:	4e75           	rts

0000111c <memset>:
{
    111c:	48e7 3f30      	movem.l d2-d7/a2-a3,-(sp)
    1120:	202f 0024      	move.l 36(sp),d0
    1124:	282f 0028      	move.l 40(sp),d4
    1128:	226f 002c      	movea.l 44(sp),a1
	while(len-- > 0)
    112c:	2a09           	move.l a1,d5
    112e:	5385           	subq.l #1,d5
    1130:	b2fc 0000      	cmpa.w #0,a1
    1134:	6700 00ae      	beq.w 11e4 <memset+0xc8>
		*ptr++ = val;
    1138:	1e04           	move.b d4,d7
    113a:	2200           	move.l d0,d1
    113c:	4481           	neg.l d1
    113e:	7403           	moveq #3,d2
    1140:	c282           	and.l d2,d1
    1142:	7c05           	moveq #5,d6
    1144:	2440           	movea.l d0,a2
    1146:	bc85           	cmp.l d5,d6
    1148:	646a           	bcc.s 11b4 <memset+0x98>
    114a:	4a81           	tst.l d1
    114c:	6724           	beq.s 1172 <memset+0x56>
    114e:	14c4           	move.b d4,(a2)+
	while(len-- > 0)
    1150:	5385           	subq.l #1,d5
    1152:	7401           	moveq #1,d2
    1154:	b481           	cmp.l d1,d2
    1156:	671a           	beq.s 1172 <memset+0x56>
		*ptr++ = val;
    1158:	2440           	movea.l d0,a2
    115a:	548a           	addq.l #2,a2
    115c:	2040           	movea.l d0,a0
    115e:	1144 0001      	move.b d4,1(a0)
	while(len-- > 0)
    1162:	5385           	subq.l #1,d5
    1164:	7403           	moveq #3,d2
    1166:	b481           	cmp.l d1,d2
    1168:	6608           	bne.s 1172 <memset+0x56>
		*ptr++ = val;
    116a:	528a           	addq.l #1,a2
    116c:	1144 0002      	move.b d4,2(a0)
	while(len-- > 0)
    1170:	5385           	subq.l #1,d5
    1172:	2609           	move.l a1,d3
    1174:	9681           	sub.l d1,d3
    1176:	7c00           	moveq #0,d6
    1178:	1c04           	move.b d4,d6
    117a:	2406           	move.l d6,d2
    117c:	4842           	swap d2
    117e:	4242           	clr.w d2
    1180:	2042           	movea.l d2,a0
    1182:	2404           	move.l d4,d2
    1184:	e14a           	lsl.w #8,d2
    1186:	4842           	swap d2
    1188:	4242           	clr.w d2
    118a:	e18e           	lsl.l #8,d6
    118c:	2646           	movea.l d6,a3
    118e:	2c08           	move.l a0,d6
    1190:	8486           	or.l d6,d2
    1192:	2c0b           	move.l a3,d6
    1194:	8486           	or.l d6,d2
    1196:	1407           	move.b d7,d2
    1198:	2040           	movea.l d0,a0
    119a:	d1c1           	adda.l d1,a0
    119c:	72fc           	moveq #-4,d1
    119e:	c283           	and.l d3,d1
    11a0:	d288           	add.l a0,d1
		*ptr++ = val;
    11a2:	20c2           	move.l d2,(a0)+
	while(len-- > 0)
    11a4:	b1c1           	cmpa.l d1,a0
    11a6:	66fa           	bne.s 11a2 <memset+0x86>
    11a8:	72fc           	moveq #-4,d1
    11aa:	c283           	and.l d3,d1
    11ac:	d5c1           	adda.l d1,a2
    11ae:	9a81           	sub.l d1,d5
    11b0:	b283           	cmp.l d3,d1
    11b2:	6730           	beq.s 11e4 <memset+0xc8>
		*ptr++ = val;
    11b4:	1484           	move.b d4,(a2)
	while(len-- > 0)
    11b6:	4a85           	tst.l d5
    11b8:	672a           	beq.s 11e4 <memset+0xc8>
		*ptr++ = val;
    11ba:	1544 0001      	move.b d4,1(a2)
	while(len-- > 0)
    11be:	7201           	moveq #1,d1
    11c0:	b285           	cmp.l d5,d1
    11c2:	6720           	beq.s 11e4 <memset+0xc8>
		*ptr++ = val;
    11c4:	1544 0002      	move.b d4,2(a2)
	while(len-- > 0)
    11c8:	7402           	moveq #2,d2
    11ca:	b485           	cmp.l d5,d2
    11cc:	6716           	beq.s 11e4 <memset+0xc8>
		*ptr++ = val;
    11ce:	1544 0003      	move.b d4,3(a2)
	while(len-- > 0)
    11d2:	7c03           	moveq #3,d6
    11d4:	bc85           	cmp.l d5,d6
    11d6:	670c           	beq.s 11e4 <memset+0xc8>
		*ptr++ = val;
    11d8:	1544 0004      	move.b d4,4(a2)
	while(len-- > 0)
    11dc:	5985           	subq.l #4,d5
    11de:	6704           	beq.s 11e4 <memset+0xc8>
		*ptr++ = val;
    11e0:	1544 0005      	move.b d4,5(a2)
}
    11e4:	4cdf 0cfc      	movem.l (sp)+,d2-d7/a2-a3
    11e8:	4e75           	rts

000011ea <memcpy>:
{
    11ea:	48e7 3e00      	movem.l d2-d6,-(sp)
    11ee:	202f 0018      	move.l 24(sp),d0
    11f2:	222f 001c      	move.l 28(sp),d1
    11f6:	262f 0020      	move.l 32(sp),d3
	while(len--)
    11fa:	2803           	move.l d3,d4
    11fc:	5384           	subq.l #1,d4
    11fe:	4a83           	tst.l d3
    1200:	675e           	beq.s 1260 <memcpy+0x76>
    1202:	2041           	movea.l d1,a0
    1204:	5288           	addq.l #1,a0
    1206:	2400           	move.l d0,d2
    1208:	9488           	sub.l a0,d2
    120a:	7a02           	moveq #2,d5
    120c:	ba82           	cmp.l d2,d5
    120e:	55c2           	sc.s d2
    1210:	4402           	neg.b d2
    1212:	7c08           	moveq #8,d6
    1214:	bc84           	cmp.l d4,d6
    1216:	55c5           	sc.s d5
    1218:	4405           	neg.b d5
    121a:	c405           	and.b d5,d2
    121c:	6748           	beq.s 1266 <memcpy+0x7c>
    121e:	2400           	move.l d0,d2
    1220:	8481           	or.l d1,d2
    1222:	7a03           	moveq #3,d5
    1224:	c485           	and.l d5,d2
    1226:	663e           	bne.s 1266 <memcpy+0x7c>
    1228:	2041           	movea.l d1,a0
    122a:	2240           	movea.l d0,a1
    122c:	74fc           	moveq #-4,d2
    122e:	c483           	and.l d3,d2
    1230:	d481           	add.l d1,d2
		*d++ = *s++;
    1232:	22d8           	move.l (a0)+,(a1)+
	while(len--)
    1234:	b488           	cmp.l a0,d2
    1236:	66fa           	bne.s 1232 <memcpy+0x48>
    1238:	74fc           	moveq #-4,d2
    123a:	c483           	and.l d3,d2
    123c:	2040           	movea.l d0,a0
    123e:	d1c2           	adda.l d2,a0
    1240:	d282           	add.l d2,d1
    1242:	9882           	sub.l d2,d4
    1244:	b483           	cmp.l d3,d2
    1246:	6718           	beq.s 1260 <memcpy+0x76>
		*d++ = *s++;
    1248:	2241           	movea.l d1,a1
    124a:	1091           	move.b (a1),(a0)
	while(len--)
    124c:	4a84           	tst.l d4
    124e:	6710           	beq.s 1260 <memcpy+0x76>
		*d++ = *s++;
    1250:	1169 0001 0001 	move.b 1(a1),1(a0)
	while(len--)
    1256:	5384           	subq.l #1,d4
    1258:	6706           	beq.s 1260 <memcpy+0x76>
		*d++ = *s++;
    125a:	1169 0002 0002 	move.b 2(a1),2(a0)
}
    1260:	4cdf 007c      	movem.l (sp)+,d2-d6
    1264:	4e75           	rts
    1266:	2240           	movea.l d0,a1
    1268:	d283           	add.l d3,d1
		*d++ = *s++;
    126a:	12e8 ffff      	move.b -1(a0),(a1)+
	while(len--)
    126e:	b288           	cmp.l a0,d1
    1270:	67ee           	beq.s 1260 <memcpy+0x76>
    1272:	5288           	addq.l #1,a0
    1274:	60f4           	bra.s 126a <memcpy+0x80>

00001276 <memmove>:
{
    1276:	48e7 3c20      	movem.l d2-d5/a2,-(sp)
    127a:	202f 0018      	move.l 24(sp),d0
    127e:	222f 001c      	move.l 28(sp),d1
    1282:	242f 0020      	move.l 32(sp),d2
		while (len--)
    1286:	2242           	movea.l d2,a1
    1288:	5389           	subq.l #1,a1
	if (d < s) {
    128a:	b280           	cmp.l d0,d1
    128c:	636c           	bls.s 12fa <memmove+0x84>
		while (len--)
    128e:	4a82           	tst.l d2
    1290:	6762           	beq.s 12f4 <memmove+0x7e>
    1292:	2441           	movea.l d1,a2
    1294:	528a           	addq.l #1,a2
    1296:	2600           	move.l d0,d3
    1298:	968a           	sub.l a2,d3
    129a:	7802           	moveq #2,d4
    129c:	b883           	cmp.l d3,d4
    129e:	55c3           	sc.s d3
    12a0:	4403           	neg.b d3
    12a2:	7a08           	moveq #8,d5
    12a4:	ba89           	cmp.l a1,d5
    12a6:	55c4           	sc.s d4
    12a8:	4404           	neg.b d4
    12aa:	c604           	and.b d4,d3
    12ac:	6770           	beq.s 131e <memmove+0xa8>
    12ae:	2600           	move.l d0,d3
    12b0:	8681           	or.l d1,d3
    12b2:	7803           	moveq #3,d4
    12b4:	c684           	and.l d4,d3
    12b6:	6666           	bne.s 131e <memmove+0xa8>
    12b8:	2041           	movea.l d1,a0
    12ba:	2440           	movea.l d0,a2
    12bc:	76fc           	moveq #-4,d3
    12be:	c682           	and.l d2,d3
    12c0:	d681           	add.l d1,d3
			*d++ = *s++;
    12c2:	24d8           	move.l (a0)+,(a2)+
		while (len--)
    12c4:	b688           	cmp.l a0,d3
    12c6:	66fa           	bne.s 12c2 <memmove+0x4c>
    12c8:	76fc           	moveq #-4,d3
    12ca:	c682           	and.l d2,d3
    12cc:	2440           	movea.l d0,a2
    12ce:	d5c3           	adda.l d3,a2
    12d0:	2041           	movea.l d1,a0
    12d2:	d1c3           	adda.l d3,a0
    12d4:	93c3           	suba.l d3,a1
    12d6:	b682           	cmp.l d2,d3
    12d8:	671a           	beq.s 12f4 <memmove+0x7e>
			*d++ = *s++;
    12da:	1490           	move.b (a0),(a2)
		while (len--)
    12dc:	b2fc 0000      	cmpa.w #0,a1
    12e0:	6712           	beq.s 12f4 <memmove+0x7e>
			*d++ = *s++;
    12e2:	1568 0001 0001 	move.b 1(a0),1(a2)
		while (len--)
    12e8:	7a01           	moveq #1,d5
    12ea:	ba89           	cmp.l a1,d5
    12ec:	6706           	beq.s 12f4 <memmove+0x7e>
			*d++ = *s++;
    12ee:	1568 0002 0002 	move.b 2(a0),2(a2)
}
    12f4:	4cdf 043c      	movem.l (sp)+,d2-d5/a2
    12f8:	4e75           	rts
		const char *lasts = s + (len - 1);
    12fa:	41f1 1800      	lea (0,a1,d1.l),a0
		char *lastd = d + (len - 1);
    12fe:	d3c0           	adda.l d0,a1
		while (len--)
    1300:	4a82           	tst.l d2
    1302:	67f0           	beq.s 12f4 <memmove+0x7e>
    1304:	2208           	move.l a0,d1
    1306:	9282           	sub.l d2,d1
			*lastd-- = *lasts--;
    1308:	1290           	move.b (a0),(a1)
		while (len--)
    130a:	5388           	subq.l #1,a0
    130c:	5389           	subq.l #1,a1
    130e:	b288           	cmp.l a0,d1
    1310:	67e2           	beq.s 12f4 <memmove+0x7e>
			*lastd-- = *lasts--;
    1312:	1290           	move.b (a0),(a1)
		while (len--)
    1314:	5388           	subq.l #1,a0
    1316:	5389           	subq.l #1,a1
    1318:	b288           	cmp.l a0,d1
    131a:	66ec           	bne.s 1308 <memmove+0x92>
    131c:	60d6           	bra.s 12f4 <memmove+0x7e>
    131e:	2240           	movea.l d0,a1
    1320:	d282           	add.l d2,d1
			*d++ = *s++;
    1322:	12ea ffff      	move.b -1(a2),(a1)+
		while (len--)
    1326:	b28a           	cmp.l a2,d1
    1328:	67ca           	beq.s 12f4 <memmove+0x7e>
    132a:	528a           	addq.l #1,a2
    132c:	60f4           	bra.s 1322 <memmove+0xac>
    132e:	4e71           	nop

00001330 <__mulsi3>:
	.text
	FUNC(__mulsi3)
	.globl	SYM (__mulsi3)
SYM (__mulsi3):
	.cfi_startproc
	movew	sp@(4), d0	/* x0 -> d0 */
    1330:	302f 0004      	move.w 4(sp),d0
	muluw	sp@(10), d0	/* x0*y1 */
    1334:	c0ef 000a      	mulu.w 10(sp),d0
	movew	sp@(6), d1	/* x1 -> d1 */
    1338:	322f 0006      	move.w 6(sp),d1
	muluw	sp@(8), d1	/* x1*y0 */
    133c:	c2ef 0008      	mulu.w 8(sp),d1
	addw	d1, d0
    1340:	d041           	add.w d1,d0
	swap	d0
    1342:	4840           	swap d0
	clrw	d0
    1344:	4240           	clr.w d0
	movew	sp@(6), d1	/* x1 -> d1 */
    1346:	322f 0006      	move.w 6(sp),d1
	muluw	sp@(10), d1	/* x1*y1 */
    134a:	c2ef 000a      	mulu.w 10(sp),d1
	addl	d1, d0
    134e:	d081           	add.l d1,d0
	rts
    1350:	4e75           	rts

00001352 <__udivsi3>:
	.text
	FUNC(__udivsi3)
	.globl	SYM (__udivsi3)
SYM (__udivsi3):
	.cfi_startproc
	movel	d2, sp@-
    1352:	2f02           	move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	sp@(12), d1	/* d1 = divisor */
    1354:	222f 000c      	move.l 12(sp),d1
	movel	sp@(8), d0	/* d0 = dividend */
    1358:	202f 0008      	move.l 8(sp),d0

	cmpl	IMM (0x10000), d1 /* divisor >= 2 ^ 16 ?   */
    135c:	0c81 0001 0000 	cmpi.l #65536,d1
	jcc	3f		/* then try next algorithm */
    1362:	6416           	bcc.s 137a <__udivsi3+0x28>
	movel	d0, d2
    1364:	2400           	move.l d0,d2
	clrw	d2
    1366:	4242           	clr.w d2
	swap	d2
    1368:	4842           	swap d2
	divu	d1, d2          /* high quotient in lower word */
    136a:	84c1           	divu.w d1,d2
	movew	d2, d0		/* save high quotient */
    136c:	3002           	move.w d2,d0
	swap	d0
    136e:	4840           	swap d0
	movew	sp@(10), d2	/* get low dividend + high rest */
    1370:	342f 000a      	move.w 10(sp),d2
	divu	d1, d2		/* low quotient */
    1374:	84c1           	divu.w d1,d2
	movew	d2, d0
    1376:	3002           	move.w d2,d0
	jra	6f
    1378:	6030           	bra.s 13aa <__udivsi3+0x58>

3:	movel	d1, d2		/* use d2 as divisor backup */
    137a:	2401           	move.l d1,d2
4:	lsrl	IMM (1), d1	/* shift divisor */
    137c:	e289           	lsr.l #1,d1
	lsrl	IMM (1), d0	/* shift dividend */
    137e:	e288           	lsr.l #1,d0
	cmpl	IMM (0x10000), d1 /* still divisor >= 2 ^ 16 ?  */
    1380:	0c81 0001 0000 	cmpi.l #65536,d1
	jcc	4b
    1386:	64f4           	bcc.s 137c <__udivsi3+0x2a>
	divu	d1, d0		/* now we have 16-bit divisor */
    1388:	80c1           	divu.w d1,d0
	andl	IMM (0xffff), d0 /* mask out divisor, ignore remainder */
    138a:	0280 0000 ffff 	andi.l #65535,d0

/* Multiply the 16-bit tentative quotient with the 32-bit divisor.  Because of
   the operand ranges, this might give a 33-bit product.  If this product is
   greater than the dividend, the tentative quotient was too large. */
	movel	d2, d1
    1390:	2202           	move.l d2,d1
	mulu	d0, d1		/* low part, 32 bits */
    1392:	c2c0           	mulu.w d0,d1
	swap	d2
    1394:	4842           	swap d2
	mulu	d0, d2		/* high part, at most 17 bits */
    1396:	c4c0           	mulu.w d0,d2
	swap	d2		/* align high part with low part */
    1398:	4842           	swap d2
	tstw	d2		/* high part 17 bits? */
    139a:	4a42           	tst.w d2
	jne	5f		/* if 17 bits, quotient was too large */
    139c:	660a           	bne.s 13a8 <__udivsi3+0x56>
	addl	d2, d1		/* add parts */
    139e:	d282           	add.l d2,d1
	jcs	5f		/* if sum is 33 bits, quotient was too large */
    13a0:	6506           	bcs.s 13a8 <__udivsi3+0x56>
	cmpl	sp@(8), d1	/* compare the sum with the dividend */
    13a2:	b2af 0008      	cmp.l 8(sp),d1
	jls	6f		/* if sum > dividend, quotient was too large */
    13a6:	6302           	bls.s 13aa <__udivsi3+0x58>
5:	subql	IMM (1), d0	/* adjust quotient */
    13a8:	5380           	subq.l #1,d0

6:	movel	sp@+, d2
    13aa:	241f           	move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    13ac:	4e75           	rts

000013ae <__divsi3>:
	.text
	FUNC(__divsi3)
	.globl	SYM (__divsi3)
SYM (__divsi3):
	.cfi_startproc
	movel	d2, sp@-
    13ae:	2f02           	move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4

	moveq	IMM (1), d2	/* sign of result stored in d2 (=1 or =-1) */
    13b0:	7401           	moveq #1,d2
	movel	sp@(12), d1	/* d1 = divisor */
    13b2:	222f 000c      	move.l 12(sp),d1
	jpl	1f
    13b6:	6a04           	bpl.s 13bc <__divsi3+0xe>
	negl	d1
    13b8:	4481           	neg.l d1
	negb	d2		/* change sign because divisor <0  */
    13ba:	4402           	neg.b d2
1:	movel	sp@(8), d0	/* d0 = dividend */
    13bc:	202f 0008      	move.l 8(sp),d0
	jpl	2f
    13c0:	6a04           	bpl.s 13c6 <__divsi3+0x18>
	negl	d0
    13c2:	4480           	neg.l d0
	negb	d2
    13c4:	4402           	neg.b d2

2:	movel	d1, sp@-
    13c6:	2f01           	move.l d1,-(sp)
	movel	d0, sp@-
    13c8:	2f00           	move.l d0,-(sp)
	PICCALL	SYM (__udivsi3)	/* divide abs(dividend) by abs(divisor) */
    13ca:	6186           	bsr.s 1352 <__udivsi3>
	addql	IMM (8), sp
    13cc:	508f           	addq.l #8,sp

	tstb	d2
    13ce:	4a02           	tst.b d2
	jpl	3f
    13d0:	6a02           	bpl.s 13d4 <__divsi3+0x26>
	negl	d0
    13d2:	4480           	neg.l d0

3:	movel	sp@+, d2
    13d4:	241f           	move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
    13d6:	4e75           	rts

000013d8 <__modsi3>:
	.text
	FUNC(__modsi3)
	.globl	SYM (__modsi3)
SYM (__modsi3):
	.cfi_startproc
	movel	sp@(8), d1	/* d1 = divisor */
    13d8:	222f 0008      	move.l 8(sp),d1
	movel	sp@(4), d0	/* d0 = dividend */
    13dc:	202f 0004      	move.l 4(sp),d0
	movel	d1, sp@-
    13e0:	2f01           	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    13e2:	2f00           	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	PICCALL	SYM (__divsi3)
    13e4:	61c8           	bsr.s 13ae <__divsi3>
	addql	IMM (8), sp
    13e6:	508f           	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(8), d1	/* d1 = divisor */
    13e8:	222f 0008      	move.l 8(sp),d1
	movel	d1, sp@-
    13ec:	2f01           	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    13ee:	2f00           	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	PICCALL	SYM (__mulsi3)	/* d0 = (a/b)*b */
    13f0:	6100 ff3e      	bsr.w 1330 <__mulsi3>
	addql	IMM (8), sp
    13f4:	508f           	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(4), d1	/* d1 = dividend */
    13f6:	222f 0004      	move.l 4(sp),d1
	subl	d0, d1		/* d1 = a - (a/b)*b */
    13fa:	9280           	sub.l d0,d1
	movel	d1, d0
    13fc:	2001           	move.l d1,d0
	rts
    13fe:	4e75           	rts

00001400 <__umodsi3>:
	.text
	FUNC(__umodsi3)
	.globl	SYM (__umodsi3)
SYM (__umodsi3):
	.cfi_startproc
	movel	sp@(8), d1	/* d1 = divisor */
    1400:	222f 0008      	move.l 8(sp),d1
	movel	sp@(4), d0	/* d0 = dividend */
    1404:	202f 0004      	move.l 4(sp),d0
	movel	d1, sp@-
    1408:	2f01           	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    140a:	2f00           	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	PICCALL	SYM (__udivsi3)
    140c:	6100 ff44      	bsr.w 1352 <__udivsi3>
	addql	IMM (8), sp
    1410:	508f           	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(8), d1	/* d1 = divisor */
    1412:	222f 0008      	move.l 8(sp),d1
	movel	d1, sp@-
    1416:	2f01           	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
    1418:	2f00           	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	PICCALL	SYM (__mulsi3)	/* d0 = (a/b)*b */
    141a:	6100 ff14      	bsr.w 1330 <__mulsi3>
	addql	IMM (8), sp
    141e:	508f           	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(4), d1	/* d1 = dividend */
    1420:	222f 0004      	move.l 4(sp),d1
	subl	d0, d1		/* d1 = a - (a/b)*b */
    1424:	9280           	sub.l d0,d1
	movel	d1, d0
    1426:	2001           	move.l d1,d0
	rts
    1428:	4e75           	rts

0000142a <KPutCharX>:
	FUNC(KPutCharX)
	.globl	SYM (KPutCharX)

SYM(KPutCharX):
	.cfi_startproc
    move.l  a6, -(sp)
    142a:	2f0e           	move.l a6,-(sp)
	.cfi_adjust_cfa_offset 4
    move.l  4.w, a6
    142c:	2c78 0004      	movea.l 4 <_start+0x4>,a6
    jsr     -0x204(a6)
    1430:	4eae fdfc      	jsr -516(a6)
    movea.l (sp)+, a6
    1434:	2c5f           	movea.l (sp)+,a6
	.cfi_adjust_cfa_offset -4
    rts
    1436:	4e75           	rts

00001438 <PutChar>:
	FUNC(PutChar)
	.globl	SYM (PutChar)

SYM(PutChar):
	.cfi_startproc
	move.b d0, (a3)+
    1438:	16c0           	move.b d0,(a3)+
	rts
    143a:	4e75           	rts
