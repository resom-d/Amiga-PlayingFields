
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
   4:	263c 0000 2c71 	move.l #11377,d3
   a:	0483 0000 2c71 	subi.l #11377,d3
  10:	e483           	asr.l #2,d3
	for (i = 0; i < count; i++)
  12:	6712           	beq.s 26 <_start+0x26>
  14:	45f9 0000 2c71 	lea 2c71 <__fini_array_end>,a2
  1a:	7400           	moveq #0,d2
		__preinit_array_start[i]();
  1c:	205a           	movea.l (a2)+,a0
  1e:	4e90           	jsr (a0)
	for (i = 0; i < count; i++)
  20:	5282           	addq.l #1,d2
  22:	b483           	cmp.l d3,d2
  24:	66f6           	bne.s 1c <_start+0x1c>

	count = __init_array_end - __init_array_start;
  26:	263c 0000 2c71 	move.l #11377,d3
  2c:	0483 0000 2c71 	subi.l #11377,d3
  32:	e483           	asr.l #2,d3
	for (i = 0; i < count; i++)
  34:	6712           	beq.s 48 <_start+0x48>
  36:	45f9 0000 2c71 	lea 2c71 <__fini_array_end>,a2
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
  4e:	243c 0000 2c71 	move.l #11377,d2
  54:	0482 0000 2c71 	subi.l #11377,d2
  5a:	e482           	asr.l #2,d2
	for (i = count; i > 0; i--)
  5c:	6710           	beq.s 6e <_start+0x6e>
  5e:	45f9 0000 2c71 	lea 2c71 <__fini_array_end>,a2
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
  74:	4fef fff4      	lea -12(sp),sp
  78:	48e7 313e      	movem.l d2-d3/d7/a2-a6,-(sp)
	copPtr = copWaitXY(copPtr, 0xfe, 0xff);
}

int InitDemo()
{
	SysBase = *((struct ExecBase **)4UL);
  7c:	2c78 0004      	movea.l 4 <_start+0x4>,a6
  80:	23ce 0001 94fa 	move.l a6,194fa <SysBase>
	custom = (struct Custom *)0xdff000;
  86:	23fc 00df f000 	move.l #14675968,1953c <custom>
  8c:	0001 953c 

	// We will use the graphics library only to locate and restore the system copper list once we are through.
	GfxBase = (struct GfxBase *)OpenLibrary((CONST_STRPTR) "graphics.library", 0);
  90:	43f9 0000 0c28 	lea c28 <PutChar+0x4>,a1
  96:	7000           	moveq #0,d0
  98:	4eae fdd8      	jsr -552(a6)
  9c:	23c0 0001 94f6 	move.l d0,194f6 <GfxBase>
	if (!GfxBase)
  a2:	6700 06a2      	beq.w 746 <main+0x6d2>
		Exit(0);

	// used for printing
	DOSBase = (struct DosLibrary *)OpenLibrary((CONST_STRPTR) "dos.library", 0);
  a6:	2c79 0001 94fa 	movea.l 194fa <SysBase>,a6
  ac:	43f9 0000 0c39 	lea c39 <PutChar+0x15>,a1
  b2:	7000           	moveq #0,d0
  b4:	4eae fdd8      	jsr -552(a6)
  b8:	23c0 0001 94fe 	move.l d0,194fe <DOSBase>
	if (!DOSBase)
  be:	6700 06ae      	beq.w 76e <main+0x6fa>
		Exit(0);

#ifdef __cplusplus
	KPrintF("Hello debugger from Amiga: %ld!\n", staticClass.i);
#else
	KPrintF("Hello debugger from Amiga!\n");
  c2:	4879 0000 0c45 	pea c45 <PutChar+0x21>
  c8:	4eb9 0000 0884 	jsr 884 <KPrintF>
#endif
	Write(Output(), (APTR) "Hello console!\n", 15);
  ce:	2c79 0001 94fe 	movea.l 194fe <DOSBase>,a6
  d4:	4eae ffc4      	jsr -60(a6)
  d8:	2c79 0001 94fe 	movea.l 194fe <DOSBase>,a6
  de:	2200           	move.l d0,d1
  e0:	243c 0000 0c61 	move.l #3169,d2
  e6:	760f           	moveq #15,d3
  e8:	4eae ffd0      	jsr -48(a6)
    } //blitter busy wait
}

void TakeSystem(void)
{
    ActiView = GfxBase->ActiView; //store current view
  ec:	2c79 0001 94f6 	movea.l 194f6 <GfxBase>,a6
  f2:	23ee 0022 0001 	move.l 34(a6),194e4 <ActiView>
  f8:	94e4 
    OwnBlitter();
  fa:	4eae fe38      	jsr -456(a6)
    WaitBlit();
  fe:	2c79 0001 94f6 	movea.l 194f6 <GfxBase>,a6
 104:	4eae ff1c      	jsr -228(a6)
    Disable();
 108:	2c79 0001 94fa 	movea.l 194fa <SysBase>,a6
 10e:	4eae ff88      	jsr -120(a6)

    //Save current interrupts and DMA settings so we can restore them upon exit.
    SystemADKCON = custom->adkconr;
 112:	2679 0001 953c 	movea.l 1953c <custom>,a3
 118:	302b 0010      	move.w 16(a3),d0
 11c:	33c0 0001 94e8 	move.w d0,194e8 <SystemADKCON>
    SystemInts = custom->intenar;
 122:	302b 001c      	move.w 28(a3),d0
 126:	33c0 0001 94ec 	move.w d0,194ec <SystemInts>
    SystemDMA = custom->dmaconr;
 12c:	302b 0002      	move.w 2(a3),d0
 130:	33c0 0001 94ea 	move.w d0,194ea <SystemDMA>
    custom->intena = 0x7fff; //disable all interrupts
 136:	377c 7fff 009a 	move.w #32767,154(a3)
    custom->intreq = 0x7fff; //Clear any interrupts that were pending
 13c:	377c 7fff 009c 	move.w #32767,156(a3)

    WaitVbl();
 142:	45f9 0000 083e 	lea 83e <WaitVbl>,a2
 148:	4e92           	jsr (a2)
    WaitVbl();
 14a:	4e92           	jsr (a2)
    custom->dmacon = 0x7fff; //Clear all DMA channels
 14c:	377c 7fff 0096 	move.w #32767,150(a3)
 152:	588f           	addq.l #4,sp

    //set all colors black
    for (int a = 0; a < 32; a++)
 154:	7200           	moveq #0,d1
        custom->color[a] = 0;
 156:	2001           	move.l d1,d0
 158:	0680 0000 00c0 	addi.l #192,d0
 15e:	d080           	add.l d0,d0
 160:	37bc 0000 0800 	move.w #0,(0,a3,d0.l)
    for (int a = 0; a < 32; a++)
 166:	5281           	addq.l #1,d1
 168:	7020           	moveq #32,d0
 16a:	b081           	cmp.l d1,d0
 16c:	66e8           	bne.s 156 <main+0xe2>

    LoadView(0);
 16e:	2c79 0001 94f6 	movea.l 194f6 <GfxBase>,a6
 174:	93c9           	suba.l a1,a1
 176:	4eae ff22      	jsr -222(a6)
    WaitTOF();
 17a:	2c79 0001 94f6 	movea.l 194f6 <GfxBase>,a6
 180:	4eae fef2      	jsr -270(a6)
    WaitTOF();
 184:	2c79 0001 94f6 	movea.l 194f6 <GfxBase>,a6
 18a:	4eae fef2      	jsr -270(a6)

    WaitVbl();
 18e:	4e92           	jsr (a2)
    WaitVbl();
 190:	4e92           	jsr (a2)
    UWORD getvbr[] = {0x4e7a, 0x0801, 0x4e73}; // MOVEC.L VBR,D0 RTE
 192:	3f7c 4e7a 0026 	move.w #20090,38(sp)
 198:	3f7c 0801 0028 	move.w #2049,40(sp)
 19e:	3f7c 4e73 002a 	move.w #20083,42(sp)
    if (SysBase->AttnFlags & AFF_68010)
 1a4:	2c79 0001 94fa 	movea.l 194fa <SysBase>,a6
 1aa:	082e 0000 0129 	btst #0,297(a6)
 1b0:	6700 065c      	beq.w 80e <main+0x79a>
        vbr = (APTR)Supervisor((ULONG(*)())getvbr);
 1b4:	7e26           	moveq #38,d7
 1b6:	de8f           	add.l sp,d7
 1b8:	cf8d           	exg d7,a5
 1ba:	4eae ffe2      	jsr -30(a6)
 1be:	cf8d           	exg d7,a5

    VBR = GetVBR();
 1c0:	23c0 0001 94ee 	move.l d0,194ee <VBR>
    return *(volatile APTR *)(((UBYTE *)VBR) + 0x6c);
 1c6:	2079 0001 94ee 	movea.l 194ee <VBR>,a0
 1cc:	2028 006c      	move.l 108(a0),d0
    SystemIrq = GetInterruptHandler(); //store interrupt register
 1d0:	23c0 0001 94f2 	move.l d0,194f2 <SystemIrq>

	TakeSystem();
	// TODO: precalc stuff here
	copper1 = AllocMem(1024, MEMF_CHIP);
 1d6:	2c79 0001 94fa 	movea.l 194fa <SysBase>,a6
 1dc:	203c 0000 0400 	move.l #1024,d0
 1e2:	7202           	moveq #2,d1
 1e4:	4eae ff3a      	jsr -198(a6)
 1e8:	2840           	movea.l d0,a4
 1ea:	23c0 0001 94e0 	move.l d0,194e0 <copper1>
}

void ImageToImgContainer(struct Image *img, ImageContainer *imgC)
{
	imgC->Bitmap.BytesPerRow = img->Width / 8;
	imgC->Bitmap.Depth = img->Depth;
 1f0:	13fc 0003 0001 	move.b #3,194ad <bmpLogo+0x5>
 1f6:	94ad 
	imgC->Bitmap.BytesPerRow = img->Width / 8;
 1f8:	23fc 0028 0100 	move.l #2621696,194a8 <bmpLogo>
 1fe:	0001 94a8 
	imgC->Bitmap.Rows = img->Height;
	imgC->ImageData = img->ImageData;
 202:	23fc 0000 a4a8 	move.l #42152,194d0 <bmpLogo+0x28>
 208:	0001 94d0 
	imgC->LeftEdge = img->LeftEdge;
 20c:	42b9 0001 94d4 	clr.l 194d4 <bmpLogo+0x2c>
 212:	23fc 0140 0100 	move.l #20971776,194d8 <bmpLogo+0x30>
 218:	0001 94d8 
	imgC->Bitmap.Depth = img->Depth;
 21c:	13fc 0003 0001 	move.b #3,19509 <bmpCookie+0x5>
 222:	9509 
	imgC->Bitmap.BytesPerRow = img->Width / 8;
 224:	23fc 0028 0100 	move.l #2621696,19504 <bmpCookie>
 22a:	0001 9504 
	imgC->ImageData = img->ImageData;
 22e:	23fc 0000 2ca8 	move.l #11432,1952c <bmpCookie+0x28>
 234:	0001 952c 
	imgC->LeftEdge = img->LeftEdge;
 238:	42b9 0001 9530 	clr.l 19530 <bmpCookie+0x2c>
 23e:	23fc 0140 0100 	move.l #20971776,19534 <bmpCookie+0x30>
 244:	0001 9534 
	for (int p = 0; p < img->Bitmap.Depth; p++)
 248:	4bf9 0000 2c74 	lea 2c74 <bmpDisplay>,a5
 24e:	7400           	moveq #0,d2
 250:	1439 0000 2c79 	move.b 2c79 <bmpDisplay+0x5>,d2
 256:	4a82           	tst.l d2
 258:	6700 009e      	beq.w 2f8 <main+0x284>
		img->Bitmap.Planes[p] = (UBYTE *)img->ImageData + (p * (img->Bitmap.BytesPerRow * img->Height));
 25c:	2679 0000 2c9c 	movea.l 2c9c <bmpDisplay+0x28>,a3
 262:	7000           	moveq #0,d0
 264:	3015           	move.w (a5),d0
 266:	3079 0000 2ca6 	movea.w 2ca6 <bmpDisplay+0x32>,a0
 26c:	2f08           	move.l a0,-(sp)
 26e:	2f00           	move.l d0,-(sp)
 270:	4eb9 0000 0b1c 	jsr b1c <__mulsi3>
 276:	508f           	addq.l #8,sp
 278:	23cb 0000 2c7c 	move.l a3,2c7c <bmpDisplay+0x8>
	for (int p = 0; p < img->Bitmap.Depth; p++)
 27e:	7201           	moveq #1,d1
 280:	b282           	cmp.l d2,d1
 282:	6774           	beq.s 2f8 <main+0x284>
		img->Bitmap.Planes[p] = (UBYTE *)img->ImageData + (p * (img->Bitmap.BytesPerRow * img->Height));
 284:	41f3 0800      	lea (0,a3,d0.l),a0
 288:	23c8 0000 2c80 	move.l a0,2c80 <bmpDisplay+0xc>
	for (int p = 0; p < img->Bitmap.Depth; p++)
 28e:	7202           	moveq #2,d1
 290:	b282           	cmp.l d2,d1
 292:	6764           	beq.s 2f8 <main+0x284>
		img->Bitmap.Planes[p] = (UBYTE *)img->ImageData + (p * (img->Bitmap.BytesPerRow * img->Height));
 294:	2200           	move.l d0,d1
 296:	d280           	add.l d0,d1
 298:	41f3 1800      	lea (0,a3,d1.l),a0
 29c:	23c8 0000 2c84 	move.l a0,2c84 <bmpDisplay+0x10>
	for (int p = 0; p < img->Bitmap.Depth; p++)
 2a2:	7603           	moveq #3,d3
 2a4:	b682           	cmp.l d2,d3
 2a6:	6750           	beq.s 2f8 <main+0x284>
		img->Bitmap.Planes[p] = (UBYTE *)img->ImageData + (p * (img->Bitmap.BytesPerRow * img->Height));
 2a8:	d280           	add.l d0,d1
 2aa:	41f3 1800      	lea (0,a3,d1.l),a0
 2ae:	23c8 0000 2c88 	move.l a0,2c88 <bmpDisplay+0x14>
	for (int p = 0; p < img->Bitmap.Depth; p++)
 2b4:	7604           	moveq #4,d3
 2b6:	b682           	cmp.l d2,d3
 2b8:	673e           	beq.s 2f8 <main+0x284>
		img->Bitmap.Planes[p] = (UBYTE *)img->ImageData + (p * (img->Bitmap.BytesPerRow * img->Height));
 2ba:	d280           	add.l d0,d1
 2bc:	41f3 1800      	lea (0,a3,d1.l),a0
 2c0:	23c8 0000 2c8c 	move.l a0,2c8c <bmpDisplay+0x18>
	for (int p = 0; p < img->Bitmap.Depth; p++)
 2c6:	7605           	moveq #5,d3
 2c8:	b682           	cmp.l d2,d3
 2ca:	672c           	beq.s 2f8 <main+0x284>
		img->Bitmap.Planes[p] = (UBYTE *)img->ImageData + (p * (img->Bitmap.BytesPerRow * img->Height));
 2cc:	d280           	add.l d0,d1
 2ce:	41f3 1800      	lea (0,a3,d1.l),a0
 2d2:	23c8 0000 2c90 	move.l a0,2c90 <bmpDisplay+0x1c>
	for (int p = 0; p < img->Bitmap.Depth; p++)
 2d8:	7606           	moveq #6,d3
 2da:	b682           	cmp.l d2,d3
 2dc:	671a           	beq.s 2f8 <main+0x284>
		img->Bitmap.Planes[p] = (UBYTE *)img->ImageData + (p * (img->Bitmap.BytesPerRow * img->Height));
 2de:	d280           	add.l d0,d1
 2e0:	41f3 1800      	lea (0,a3,d1.l),a0
 2e4:	23c8 0000 2c94 	move.l a0,2c94 <bmpDisplay+0x20>
	for (int p = 0; p < img->Bitmap.Depth; p++)
 2ea:	5f82           	subq.l #7,d2
 2ec:	670a           	beq.s 2f8 <main+0x284>
		img->Bitmap.Planes[p] = (UBYTE *)img->ImageData + (p * (img->Bitmap.BytesPerRow * img->Height));
 2ee:	d081           	add.l d1,d0
 2f0:	d08b           	add.l a3,d0
 2f2:	23c0 0000 2c98 	move.l d0,2c98 <bmpDisplay+0x24>
 2f8:	23fc 0000 a4a8 	move.l #42152,194b0 <bmpLogo+0x8>
 2fe:	0001 94b0 
 302:	23fc 0000 cca8 	move.l #52392,194b4 <bmpLogo+0xc>
 308:	0001 94b4 
 30c:	23fc 0000 f4a8 	move.l #62632,194b8 <bmpLogo+0x10>
 312:	0001 94b8 
 316:	23fc 0000 2ca8 	move.l #11432,1950c <bmpCookie+0x8>
 31c:	0001 950c 
 320:	23fc 0000 54a8 	move.l #21672,19510 <bmpCookie+0xc>
 326:	0001 9510 
 32a:	23fc 0000 7ca8 	move.l #31912,19514 <bmpCookie+0x10>
 330:	0001 9514 
    *copListEnd++ = offsetof(struct Custom, ddfstrt);
 334:	38bc 0092      	move.w #146,(a4)
    *copListEnd++ = fw;
 338:	397c 0038 0002 	move.w #56,2(a4)
    *copListEnd++ = offsetof(struct Custom, ddfstop);
 33e:	397c 0094 0004 	move.w #148,4(a4)
    *copListEnd++ = fw + (((width >> 4) - 1) << 3);
 344:	397c 00d0 0006 	move.w #208,6(a4)
    *copListEnd++ = offsetof(struct Custom, diwstrt);
 34a:	397c 008e 0008 	move.w #142,8(a4)
    *copListEnd++ = x + (y << 8);
 350:	397c 2c81 000a 	move.w #11393,10(a4)
    *copListEnd++ = offsetof(struct Custom, diwstop);
 356:	397c 0090 000c 	move.w #144,12(a4)
    *copListEnd++ = (xstop - 256) + ((ystop - 256) << 8);
 35c:	397c 2cc1 000e 	move.w #11457,14(a4)
	*copPtr++ = BPLCON0;
 362:	397c 0100 0010 	move.w #256,16(a4)
	*copPtr++ = (1 << 10) /*dual pf*/ | (1 << 9) /*color*/ | ((ScreenBpls * 2) << 12) /*num bitplanes*/;
 368:	397c 6600 0012 	move.w #26112,18(a4)
	*copPtr++ = BPLCON1; //scrolling
 36e:	397c 0102 0014 	move.w #258,20(a4)
	*copPtr++ = 0;
 374:	426c 0016      	clr.w 22(a4)
	*copPtr++ = BPLCON2; //playfied priority
 378:	397c 0104 0018 	move.w #260,24(a4)
	*copPtr++ = 1 << 6;	 //0x24;			//Sprites have priority over playfields
 37e:	397c 0040 001a 	move.w #64,26(a4)
	*copPtr++ = BPL1MOD; //odd planes   1,3,5
 384:	397c 0108 001c 	move.w #264,28(a4)
	*copPtr++ = 0;
 38a:	426c 001e      	clr.w 30(a4)
	*copPtr++ = BPL2MOD; //even  planes 2,4
 38e:	397c 010a 0020 	move.w #266,32(a4)
	*copPtr++ = 0;
 394:	426c 0022      	clr.w 34(a4)
        ULONG addr = (ULONG)planes[i];
 398:	203c 0000 a4a8 	move.l #42152,d0
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]);
 39e:	397c 00e4 0024 	move.w #228,36(a4)
        *copListEnd++ = (UWORD)(addr >> 16);
 3a4:	2200           	move.l d0,d1
 3a6:	4241           	clr.w d1
 3a8:	4841           	swap d1
 3aa:	3941 0026      	move.w d1,38(a4)
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]) + 2;
 3ae:	397c 00e6 0028 	move.w #230,40(a4)
        *copListEnd++ = (UWORD)addr;
 3b4:	3940 002a      	move.w d0,42(a4)
        ULONG addr = (ULONG)planes[i];
 3b8:	203c 0000 cca8 	move.l #52392,d0
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]);
 3be:	397c 00ec 002c 	move.w #236,44(a4)
        *copListEnd++ = (UWORD)(addr >> 16);
 3c4:	2200           	move.l d0,d1
 3c6:	4241           	clr.w d1
 3c8:	4841           	swap d1
 3ca:	3941 002e      	move.w d1,46(a4)
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]) + 2;
 3ce:	397c 00ee 0030 	move.w #238,48(a4)
        *copListEnd++ = (UWORD)addr;
 3d4:	3940 0032      	move.w d0,50(a4)
        ULONG addr = (ULONG)planes[i];
 3d8:	203c 0000 f4a8 	move.l #62632,d0
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]);
 3de:	397c 00f4 0034 	move.w #244,52(a4)
        *copListEnd++ = (UWORD)(addr >> 16);
 3e4:	2200           	move.l d0,d1
 3e6:	4241           	clr.w d1
 3e8:	4841           	swap d1
 3ea:	3941 0036      	move.w d1,54(a4)
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]) + 2;
 3ee:	397c 00f6 0038 	move.w #246,56(a4)
        *copListEnd++ = (UWORD)addr;
 3f4:	3940 003a      	move.w d0,58(a4)
        ULONG addr = (ULONG)planes[i];
 3f8:	2039 0000 2c7c 	move.l 2c7c <bmpDisplay+0x8>,d0
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]);
 3fe:	397c 00e0 003c 	move.w #224,60(a4)
        *copListEnd++ = (UWORD)(addr >> 16);
 404:	2200           	move.l d0,d1
 406:	4241           	clr.w d1
 408:	4841           	swap d1
 40a:	3941 003e      	move.w d1,62(a4)
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]) + 2;
 40e:	397c 00e2 0040 	move.w #226,64(a4)
        *copListEnd++ = (UWORD)addr;
 414:	3940 0042      	move.w d0,66(a4)
        ULONG addr = (ULONG)planes[i];
 418:	2039 0000 2c80 	move.l 2c80 <bmpDisplay+0xc>,d0
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]);
 41e:	397c 00e8 0044 	move.w #232,68(a4)
        *copListEnd++ = (UWORD)(addr >> 16);
 424:	2200           	move.l d0,d1
 426:	4241           	clr.w d1
 428:	4841           	swap d1
 42a:	3941 0046      	move.w d1,70(a4)
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]) + 2;
 42e:	397c 00ea 0048 	move.w #234,72(a4)
        *copListEnd++ = (UWORD)addr;
 434:	3940 004a      	move.w d0,74(a4)
        ULONG addr = (ULONG)planes[i];
 438:	2039 0000 2c84 	move.l 2c84 <bmpDisplay+0x10>,d0
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]);
 43e:	397c 00f0 004c 	move.w #240,76(a4)
        *copListEnd++ = (UWORD)(addr >> 16);
 444:	2200           	move.l d0,d1
 446:	4241           	clr.w d1
 448:	4841           	swap d1
 44a:	3941 004e      	move.w d1,78(a4)
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]) + 2;
 44e:	397c 00f2 0050 	move.w #242,80(a4)
        *copListEnd++ = (UWORD)addr;
 454:	3940 0052      	move.w d0,82(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 458:	397c 0180 0054 	move.w #384,84(a4)
    *copListCurrent++ = color;
 45e:	426c 0056      	clr.w 86(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 462:	397c 0182 0058 	move.w #386,88(a4)
    *copListCurrent++ = color;
 468:	397c 0fff 005a 	move.w #4095,90(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 46e:	397c 0184 005c 	move.w #388,92(a4)
    *copListCurrent++ = color;
 474:	397c 0a20 005e 	move.w #2592,94(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 47a:	397c 0186 0060 	move.w #390,96(a4)
    *copListCurrent++ = color;
 480:	397c 0b40 0062 	move.w #2880,98(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 486:	397c 0188 0064 	move.w #392,100(a4)
    *copListCurrent++ = color;
 48c:	397c 0c70 0066 	move.w #3184,102(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 492:	397c 018a 0068 	move.w #394,104(a4)
    *copListCurrent++ = color;
 498:	397c 0d90 006a 	move.w #3472,106(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 49e:	397c 018c 006c 	move.w #396,108(a4)
    *copListCurrent++ = color;
 4a4:	397c 0eb0 006e 	move.w #3760,110(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 4aa:	397c 018e 0070 	move.w #398,112(a4)
    *copListCurrent++ = color;
 4b0:	397c 0080 0072 	move.w #128,114(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 4b6:	397c 0190 0074 	move.w #400,116(a4)
    *copListCurrent++ = color;
 4bc:	426c 0076      	clr.w 118(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 4c0:	397c 0192 0078 	move.w #402,120(a4)
    *copListCurrent++ = color;
 4c6:	397c 0556 007a 	move.w #1366,122(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 4cc:	397c 0194 007c 	move.w #404,124(a4)
    *copListCurrent++ = color;
 4d2:	397c 0c95 007e 	move.w #3221,126(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 4d8:	397c 0196 0080 	move.w #406,128(a4)
    *copListCurrent++ = color;
 4de:	397c 0ea6 0082 	move.w #3750,130(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 4e4:	397c 0198 0084 	move.w #408,132(a4)
    *copListCurrent++ = color;
 4ea:	397c 0432 0086 	move.w #1074,134(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 4f0:	397c 019a 0088 	move.w #410,136(a4)
    *copListCurrent++ = color;
 4f6:	397c 0531 008a 	move.w #1329,138(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 4fc:	397c 019c 008c 	move.w #412,140(a4)
    *copListCurrent++ = color;
 502:	397c 0212 008e 	move.w #530,142(a4)
    *copListCurrent++ = offsetof(struct Custom, color[index]);
 508:	397c 019e 0090 	move.w #414,144(a4)
    *copListCurrent++ = color;
 50e:	397c 0881 0092 	move.w #2177,146(a4)
    *copListEnd++ = (i << 8) | (x << 1) | 1; //bit 1 means wait. waits for vertical position x<<8, first raster stop position outside the left
 514:	397c fffd 0094 	move.w #-3,148(a4)
    *copListEnd++ = 0xfffe;
 51a:	397c fffe 0096 	move.w #-2,150(a4)
 520:	41ec 0098      	lea 152(a4),a0
 524:	23c8 0001 94dc 	move.l a0,194dc <copPtr>
	WaitVbl();
 52a:	4e92           	jsr (a2)
	custom->cop1lc = (ULONG)copper1;
 52c:	2679 0001 953c 	movea.l 1953c <custom>,a3
 532:	274c 0080      	move.l a4,128(a3)
	custom->dmacon = DMAF_BLITTER; //disable blitter dma for copjmp bug
 536:	377c 0040 0096 	move.w #64,150(a3)
	custom->copjmp1 = 0x7fff;	   //start coppper
 53c:	377c 7fff 0088 	move.w #32767,136(a3)
	custom->dmacon = DMAF_SETCLR | DMAF_MASTER | DMAF_RASTER | DMAF_COPPER | DMAF_BLITTER;
 542:	377c 83c0 0096 	move.w #-31808,150(a3)
    *(volatile APTR *)(((UBYTE *)VBR) + 0x6c) = interrupt;
 548:	2079 0001 94ee 	movea.l 194ee <VBR>,a0
 54e:	217c 0000 0814 	move.l #2068,108(a0)
 554:	006c 
	custom->intena = (1 << INTB_SETCLR) | (1 << INTB_INTEN) | (1 << INTB_VERTB);
 556:	377c c020 009a 	move.w #-16352,154(a3)
	custom->intreq = 1 << INTB_VERTB; //reset vbl req
 55c:	377c 0020 009c 	move.w #32,156(a3)
	WaitVbl();
 562:	4e92           	jsr (a2)
	SimpleBlit(bmpCookie, bmpDisplay, ps, pd, 32, 32);
 564:	3015           	move.w (a5),d0
 566:	3239 0000 2ca6 	move.w 2ca6 <bmpDisplay+0x32>,d1
	UBYTE *dest = (UBYTE*)imgD.ImageData +(startD.Y * imgD.Bitmap.BytesPerRow) + (startD.X / 8);
 56c:	3400           	move.w d0,d2
 56e:	c4fc 0070      	mulu.w #112,d2
 572:	2042           	movea.l d2,a0
 574:	41e8 0012      	lea 18(a0),a0
 578:	d1f9 0000 2c9c 	adda.l 2c9c <bmpDisplay+0x28>,a0
	custom->bltcon0 = 0x09f0;
 57e:	377c 09f0 0040 	move.w #2544,64(a3)
	custom->bltcon1 = 0x0000;
 584:	377c 0000 0042 	move.w #0,66(a3)
	custom->bltafwm = 0xffff;
 58a:	377c ffff 0044 	move.w #-1,68(a3)
	custom->bltalwm = 0xffff;
 590:	377c ffff 0046 	move.w #-1,70(a3)
		custom->bltamod = imgA.Bitmap.BytesPerRow - (width / 8);
 596:	377c 0024 0064 	move.w #36,100(a3)
		custom->bltdmod = imgD.Bitmap.BytesPerRow - (width / 8);
 59c:	5940           	subq.w #4,d0
 59e:	3740 0066      	move.w d0,102(a3)
		dest += imgD.Width/8*imgD.Height;
 5a2:	3439 0000 2ca4 	move.w 2ca4 <bmpDisplay+0x30>,d2
 5a8:	6b00 018c      	bmi.w 736 <main+0x6c2>
 5ac:	e642           	asr.w #3,d2
 5ae:	c5c1           	muls.w d1,d2
	UBYTE *src = (UBYTE*)imgA.ImageData + (startA.Y * imgA.Bitmap.BytesPerRow) + (startA.X / 8);
 5b0:	223c 0000 2ca8 	move.l #11432,d1
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
 5b6:	302b 0002      	move.w 2(a3),d0
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
 5ba:	302b 0002      	move.w 2(a3),d0
 5be:	0800 000e      	btst #14,d0
 5c2:	66f6           	bne.s 5ba <main+0x546>
		custom->bltapt = src;
 5c4:	2741 0050      	move.l d1,80(a3)
		custom->bltdpt = dest;
 5c8:	2748 0054      	move.l a0,84(a3)
		custom->bltsize = ((height) << 6) + (width / 16);
 5cc:	377c 0802 0058 	move.w #2050,88(a3)
		src += imgA.Width/8*imgA.Height;
 5d2:	0681 0000 2800 	addi.l #10240,d1
		dest += imgD.Width/8*imgD.Height;
 5d8:	d1c2           	adda.l d2,a0
	for (int b = 0; b < imgA.Bitmap.Depth; b++)
 5da:	0c81 0000 a4a8 	cmpi.l #42152,d1
 5e0:	66d4           	bne.s 5b6 <main+0x542>
inline short MouseLeft() { return !((*(volatile UBYTE *)0xbfe001) & 64); }
 5e2:	1039 00bf e001 	move.b bfe001 <_end+0xbe4ac1>,d0
	while (!MouseLeft())
 5e8:	0800 0006      	btst #6,d0
 5ec:	676e           	beq.s 65c <main+0x5e8>
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
 5ee:	2039 00df f004 	move.l dff004 <_end+0xde5ac4>,d0
 5f4:	2f40 0026      	move.l d0,38(sp)
        vpos &= 0x1ff00;
 5f8:	202f 0026      	move.l 38(sp),d0
 5fc:	0280 0001 ff00 	andi.l #130816,d0
 602:	2f40 0026      	move.l d0,38(sp)
        if (vpos != (311 << 8))
 606:	202f 0026      	move.l 38(sp),d0
 60a:	0c80 0001 3700 	cmpi.l #79616,d0
 610:	67dc           	beq.s 5ee <main+0x57a>
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
 612:	2039 00df f004 	move.l dff004 <_end+0xde5ac4>,d0
 618:	2f40 0022      	move.l d0,34(sp)
        vpos &= 0x1ff00;
 61c:	202f 0022      	move.l 34(sp),d0
 620:	0280 0001 ff00 	andi.l #130816,d0
 626:	2f40 0022      	move.l d0,34(sp)
        if (vpos == (311 << 8))
 62a:	202f 0022      	move.l 34(sp),d0
 62e:	0c80 0001 3700 	cmpi.l #79616,d0
 634:	67ac           	beq.s 5e2 <main+0x56e>
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
 636:	2039 00df f004 	move.l dff004 <_end+0xde5ac4>,d0
 63c:	2f40 0022      	move.l d0,34(sp)
        vpos &= 0x1ff00;
 640:	202f 0022      	move.l 34(sp),d0
 644:	0280 0001 ff00 	andi.l #130816,d0
 64a:	2f40 0022      	move.l d0,34(sp)
        if (vpos == (311 << 8))
 64e:	202f 0022      	move.l 34(sp),d0
 652:	0c80 0001 3700 	cmpi.l #79616,d0
 658:	66b8           	bne.s 612 <main+0x59e>
 65a:	6086           	bra.s 5e2 <main+0x56e>
}

void FreeSystem(void)
{
    WaitVbl();
 65c:	4e92           	jsr (a2)
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
 65e:	302b 0002      	move.w 2(a3),d0
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
 662:	302b 0002      	move.w 2(a3),d0
 666:	0800 000e      	btst #14,d0
 66a:	66f6           	bne.s 662 <main+0x5ee>
    WaitBlt();
    custom->intena = 0x7fff; //disable all interrupts
 66c:	377c 7fff 009a 	move.w #32767,154(a3)
    custom->intreq = 0x7fff; //Clear any interrupts that were pending
 672:	377c 7fff 009c 	move.w #32767,156(a3)
    custom->dmacon = 0x7fff; //Clear all DMA channels
 678:	377c 7fff 0096 	move.w #32767,150(a3)
    *(volatile APTR *)(((UBYTE *)VBR) + 0x6c) = interrupt;
 67e:	2079 0001 94ee 	movea.l 194ee <VBR>,a0
 684:	2179 0001 94f2 	move.l 194f2 <SystemIrq>,108(a0)
 68a:	006c 

    //restore interrupts
    SetInterruptHandler(SystemIrq);

    /*Restore system copper list(s). */
    custom->cop1lc = (ULONG)GfxBase->copinit;
 68c:	2c79 0001 94f6 	movea.l 194f6 <GfxBase>,a6
 692:	276e 0026 0080 	move.l 38(a6),128(a3)
    custom->cop2lc = (ULONG)GfxBase->LOFlist;
 698:	276e 0032 0084 	move.l 50(a6),132(a3)
    custom->copjmp1 = 0x7fff; //start coppper
 69e:	377c 7fff 0088 	move.w #32767,136(a3)

    /*Restore all interrupts and DMA settings. */
    custom->intena = SystemInts | 0x8000;
 6a4:	3039 0001 94ec 	move.w 194ec <SystemInts>,d0
 6aa:	0040 8000      	ori.w #-32768,d0
 6ae:	3740 009a      	move.w d0,154(a3)
    custom->dmacon = SystemDMA | 0x8000;
 6b2:	3039 0001 94ea 	move.w 194ea <SystemDMA>,d0
 6b8:	0040 8000      	ori.w #-32768,d0
 6bc:	3740 0096      	move.w d0,150(a3)
    custom->adkcon = SystemADKCON | 0x8000;
 6c0:	3039 0001 94e8 	move.w 194e8 <SystemADKCON>,d0
 6c6:	0040 8000      	ori.w #-32768,d0
 6ca:	3740 009e      	move.w d0,158(a3)

    LoadView(ActiView);
 6ce:	2279 0001 94e4 	movea.l 194e4 <ActiView>,a1
 6d4:	4eae ff22      	jsr -222(a6)
    WaitTOF();
 6d8:	2c79 0001 94f6 	movea.l 194f6 <GfxBase>,a6
 6de:	4eae fef2      	jsr -270(a6)
    WaitTOF();
 6e2:	2c79 0001 94f6 	movea.l 194f6 <GfxBase>,a6
 6e8:	4eae fef2      	jsr -270(a6)
    WaitBlit();
 6ec:	2c79 0001 94f6 	movea.l 194f6 <GfxBase>,a6
 6f2:	4eae ff1c      	jsr -228(a6)
    DisownBlitter();
 6f6:	2c79 0001 94f6 	movea.l 194f6 <GfxBase>,a6
 6fc:	4eae fe32      	jsr -462(a6)
    Enable();
 700:	2c79 0001 94fa 	movea.l 194fa <SysBase>,a6
 706:	4eae ff82      	jsr -126(a6)
	CloseLibrary((struct Library *)DOSBase);
 70a:	2c79 0001 94fa 	movea.l 194fa <SysBase>,a6
 710:	2279 0001 94fe 	movea.l 194fe <DOSBase>,a1
 716:	4eae fe62      	jsr -414(a6)
	CloseLibrary((struct Library *)GfxBase);
 71a:	2c79 0001 94fa 	movea.l 194fa <SysBase>,a6
 720:	2279 0001 94f6 	movea.l 194f6 <GfxBase>,a1
 726:	4eae fe62      	jsr -414(a6)
}
 72a:	7000           	moveq #0,d0
 72c:	4cdf 7c8c      	movem.l (sp)+,d2-d3/d7/a2-a6
 730:	4fef 000c      	lea 12(sp),sp
 734:	4e75           	rts
		dest += imgD.Width/8*imgD.Height;
 736:	5e42           	addq.w #7,d2
 738:	e642           	asr.w #3,d2
 73a:	c5c1           	muls.w d1,d2
	UBYTE *src = (UBYTE*)imgA.ImageData + (startA.Y * imgA.Bitmap.BytesPerRow) + (startA.X / 8);
 73c:	223c 0000 2ca8 	move.l #11432,d1
 742:	6000 fe72      	bra.w 5b6 <main+0x542>
		Exit(0);
 746:	2c79 0001 94fe 	movea.l 194fe <DOSBase>,a6
 74c:	7200           	moveq #0,d1
 74e:	4eae ff70      	jsr -144(a6)
	DOSBase = (struct DosLibrary *)OpenLibrary((CONST_STRPTR) "dos.library", 0);
 752:	2c79 0001 94fa 	movea.l 194fa <SysBase>,a6
 758:	43f9 0000 0c39 	lea c39 <PutChar+0x15>,a1
 75e:	7000           	moveq #0,d0
 760:	4eae fdd8      	jsr -552(a6)
 764:	23c0 0001 94fe 	move.l d0,194fe <DOSBase>
	if (!DOSBase)
 76a:	6600 f956      	bne.w c2 <main+0x4e>
		Exit(0);
 76e:	9dce           	suba.l a6,a6
 770:	7200           	moveq #0,d1
 772:	4eae ff70      	jsr -144(a6)
	KPrintF("Hello debugger from Amiga!\n");
 776:	4879 0000 0c45 	pea c45 <PutChar+0x21>
 77c:	4eb9 0000 0884 	jsr 884 <KPrintF>
	Write(Output(), (APTR) "Hello console!\n", 15);
 782:	2c79 0001 94fe 	movea.l 194fe <DOSBase>,a6
 788:	4eae ffc4      	jsr -60(a6)
 78c:	2c79 0001 94fe 	movea.l 194fe <DOSBase>,a6
 792:	2200           	move.l d0,d1
 794:	243c 0000 0c61 	move.l #3169,d2
 79a:	760f           	moveq #15,d3
 79c:	4eae ffd0      	jsr -48(a6)
    ActiView = GfxBase->ActiView; //store current view
 7a0:	2c79 0001 94f6 	movea.l 194f6 <GfxBase>,a6
 7a6:	23ee 0022 0001 	move.l 34(a6),194e4 <ActiView>
 7ac:	94e4 
    OwnBlitter();
 7ae:	4eae fe38      	jsr -456(a6)
    WaitBlit();
 7b2:	2c79 0001 94f6 	movea.l 194f6 <GfxBase>,a6
 7b8:	4eae ff1c      	jsr -228(a6)
    Disable();
 7bc:	2c79 0001 94fa 	movea.l 194fa <SysBase>,a6
 7c2:	4eae ff88      	jsr -120(a6)
    SystemADKCON = custom->adkconr;
 7c6:	2679 0001 953c 	movea.l 1953c <custom>,a3
 7cc:	302b 0010      	move.w 16(a3),d0
 7d0:	33c0 0001 94e8 	move.w d0,194e8 <SystemADKCON>
    SystemInts = custom->intenar;
 7d6:	302b 001c      	move.w 28(a3),d0
 7da:	33c0 0001 94ec 	move.w d0,194ec <SystemInts>
    SystemDMA = custom->dmaconr;
 7e0:	302b 0002      	move.w 2(a3),d0
 7e4:	33c0 0001 94ea 	move.w d0,194ea <SystemDMA>
    custom->intena = 0x7fff; //disable all interrupts
 7ea:	377c 7fff 009a 	move.w #32767,154(a3)
    custom->intreq = 0x7fff; //Clear any interrupts that were pending
 7f0:	377c 7fff 009c 	move.w #32767,156(a3)
    WaitVbl();
 7f6:	45f9 0000 083e 	lea 83e <WaitVbl>,a2
 7fc:	4e92           	jsr (a2)
    WaitVbl();
 7fe:	4e92           	jsr (a2)
    custom->dmacon = 0x7fff; //Clear all DMA channels
 800:	377c 7fff 0096 	move.w #32767,150(a3)
 806:	588f           	addq.l #4,sp
    for (int a = 0; a < 32; a++)
 808:	7200           	moveq #0,d1
 80a:	6000 f94a      	bra.w 156 <main+0xe2>
    APTR vbr = 0;
 80e:	7000           	moveq #0,d0
 810:	6000 f9ae      	bra.w 1c0 <main+0x14c>

00000814 <interruptHandler>:
{
 814:	2f08           	move.l a0,-(sp)
 816:	2f00           	move.l d0,-(sp)
    custom->intreq = (1 << INTB_VERTB);
 818:	2079 0001 953c 	movea.l 1953c <custom>,a0
 81e:	317c 0020 009c 	move.w #32,156(a0)
    custom->intreq = (1 << INTB_VERTB); //reset vbl req. twice for a4000 bug.
 824:	317c 0020 009c 	move.w #32,156(a0)
    frameCounter++;
 82a:	2039 0001 9538 	move.l 19538 <frameCounter>,d0
 830:	5280           	addq.l #1,d0
 832:	23c0 0001 9538 	move.l d0,19538 <frameCounter>
}
 838:	201f           	move.l (sp)+,d0
 83a:	205f           	movea.l (sp)+,a0
 83c:	4e73           	rte

0000083e <WaitVbl>:
{
 83e:	518f           	subq.l #8,sp
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
 840:	2039 00df f004 	move.l dff004 <_end+0xde5ac4>,d0
 846:	2e80           	move.l d0,(sp)
        vpos &= 0x1ff00;
 848:	2017           	move.l (sp),d0
 84a:	0280 0001 ff00 	andi.l #130816,d0
 850:	2e80           	move.l d0,(sp)
        if (vpos != (311 << 8))
 852:	2017           	move.l (sp),d0
 854:	0c80 0001 3700 	cmpi.l #79616,d0
 85a:	67e4           	beq.s 840 <WaitVbl+0x2>
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
 85c:	2039 00df f004 	move.l dff004 <_end+0xde5ac4>,d0
 862:	2f40 0004      	move.l d0,4(sp)
        vpos &= 0x1ff00;
 866:	202f 0004      	move.l 4(sp),d0
 86a:	0280 0001 ff00 	andi.l #130816,d0
 870:	2f40 0004      	move.l d0,4(sp)
        if (vpos == (311 << 8))
 874:	202f 0004      	move.l 4(sp),d0
 878:	0c80 0001 3700 	cmpi.l #79616,d0
 87e:	66dc           	bne.s 85c <WaitVbl+0x1e>
}
 880:	508f           	addq.l #8,sp
 882:	4e75           	rts

00000884 <KPrintF>:
{
 884:	4fef ff80      	lea -128(sp),sp
 888:	48e7 0032      	movem.l a2-a3/a6,-(sp)
    if(*((UWORD *)UaeDbgLog) == 0x4eb9 || *((UWORD *)UaeDbgLog) == 0xa00e) {
 88c:	3039 00f0 ff60 	move.w f0ff60 <_end+0xef6a20>,d0
 892:	0c40 4eb9      	cmpi.w #20153,d0
 896:	672a           	beq.s 8c2 <KPrintF+0x3e>
 898:	0c40 a00e      	cmpi.w #-24562,d0
 89c:	6724           	beq.s 8c2 <KPrintF+0x3e>
		RawDoFmt((CONST_STRPTR)fmt, vl, KPutCharX, 0);
 89e:	2c79 0001 94fa 	movea.l 194fa <SysBase>,a6
 8a4:	206f 0090      	movea.l 144(sp),a0
 8a8:	43ef 0094      	lea 148(sp),a1
 8ac:	45f9 0000 0c16 	lea c16 <KPutCharX>,a2
 8b2:	97cb           	suba.l a3,a3
 8b4:	4eae fdf6      	jsr -522(a6)
}
 8b8:	4cdf 4c00      	movem.l (sp)+,a2-a3/a6
 8bc:	4fef 0080      	lea 128(sp),sp
 8c0:	4e75           	rts
		RawDoFmt((CONST_STRPTR)fmt, vl, PutChar, temp);
 8c2:	2c79 0001 94fa 	movea.l 194fa <SysBase>,a6
 8c8:	206f 0090      	movea.l 144(sp),a0
 8cc:	43ef 0094      	lea 148(sp),a1
 8d0:	45f9 0000 0c24 	lea c24 <PutChar>,a2
 8d6:	47ef 000c      	lea 12(sp),a3
 8da:	4eae fdf6      	jsr -522(a6)
		UaeDbgLog(86, temp);
 8de:	2f0b           	move.l a3,-(sp)
 8e0:	4878 0056      	pea 56 <_start+0x56>
 8e4:	4eb9 00f0 ff60 	jsr f0ff60 <_end+0xef6a20>
 8ea:	508f           	addq.l #8,sp
}
 8ec:	4cdf 4c00      	movem.l (sp)+,a2-a3/a6
 8f0:	4fef 0080      	lea 128(sp),sp
 8f4:	4e75           	rts

000008f6 <strlen>:
{
 8f6:	206f 0004      	movea.l 4(sp),a0
	unsigned long t=0;
 8fa:	7000           	moveq #0,d0
	while(*s++)
 8fc:	4a10           	tst.b (a0)
 8fe:	6708           	beq.s 908 <strlen+0x12>
		t++;
 900:	5280           	addq.l #1,d0
	while(*s++)
 902:	4a30 0800      	tst.b (0,a0,d0.l)
 906:	66f8           	bne.s 900 <strlen+0xa>
}
 908:	4e75           	rts

0000090a <memset>:
{
 90a:	48e7 3f30      	movem.l d2-d7/a2-a3,-(sp)
 90e:	202f 0024      	move.l 36(sp),d0
 912:	282f 0028      	move.l 40(sp),d4
 916:	226f 002c      	movea.l 44(sp),a1
	while(len-- > 0)
 91a:	2a09           	move.l a1,d5
 91c:	5385           	subq.l #1,d5
 91e:	b2fc 0000      	cmpa.w #0,a1
 922:	6700 00ae      	beq.w 9d2 <memset+0xc8>
		*ptr++ = val;
 926:	1e04           	move.b d4,d7
 928:	2200           	move.l d0,d1
 92a:	4481           	neg.l d1
 92c:	7403           	moveq #3,d2
 92e:	c282           	and.l d2,d1
 930:	7c05           	moveq #5,d6
 932:	2440           	movea.l d0,a2
 934:	bc85           	cmp.l d5,d6
 936:	646a           	bcc.s 9a2 <memset+0x98>
 938:	4a81           	tst.l d1
 93a:	6724           	beq.s 960 <memset+0x56>
 93c:	14c4           	move.b d4,(a2)+
	while(len-- > 0)
 93e:	5385           	subq.l #1,d5
 940:	7401           	moveq #1,d2
 942:	b481           	cmp.l d1,d2
 944:	671a           	beq.s 960 <memset+0x56>
		*ptr++ = val;
 946:	2440           	movea.l d0,a2
 948:	548a           	addq.l #2,a2
 94a:	2040           	movea.l d0,a0
 94c:	1144 0001      	move.b d4,1(a0)
	while(len-- > 0)
 950:	5385           	subq.l #1,d5
 952:	7403           	moveq #3,d2
 954:	b481           	cmp.l d1,d2
 956:	6608           	bne.s 960 <memset+0x56>
		*ptr++ = val;
 958:	528a           	addq.l #1,a2
 95a:	1144 0002      	move.b d4,2(a0)
	while(len-- > 0)
 95e:	5385           	subq.l #1,d5
 960:	2609           	move.l a1,d3
 962:	9681           	sub.l d1,d3
 964:	7c00           	moveq #0,d6
 966:	1c04           	move.b d4,d6
 968:	2406           	move.l d6,d2
 96a:	4842           	swap d2
 96c:	4242           	clr.w d2
 96e:	2042           	movea.l d2,a0
 970:	2404           	move.l d4,d2
 972:	e14a           	lsl.w #8,d2
 974:	4842           	swap d2
 976:	4242           	clr.w d2
 978:	e18e           	lsl.l #8,d6
 97a:	2646           	movea.l d6,a3
 97c:	2c08           	move.l a0,d6
 97e:	8486           	or.l d6,d2
 980:	2c0b           	move.l a3,d6
 982:	8486           	or.l d6,d2
 984:	1407           	move.b d7,d2
 986:	2040           	movea.l d0,a0
 988:	d1c1           	adda.l d1,a0
 98a:	72fc           	moveq #-4,d1
 98c:	c283           	and.l d3,d1
 98e:	d288           	add.l a0,d1
		*ptr++ = val;
 990:	20c2           	move.l d2,(a0)+
	while(len-- > 0)
 992:	b1c1           	cmpa.l d1,a0
 994:	66fa           	bne.s 990 <memset+0x86>
 996:	72fc           	moveq #-4,d1
 998:	c283           	and.l d3,d1
 99a:	d5c1           	adda.l d1,a2
 99c:	9a81           	sub.l d1,d5
 99e:	b283           	cmp.l d3,d1
 9a0:	6730           	beq.s 9d2 <memset+0xc8>
		*ptr++ = val;
 9a2:	1484           	move.b d4,(a2)
	while(len-- > 0)
 9a4:	4a85           	tst.l d5
 9a6:	672a           	beq.s 9d2 <memset+0xc8>
		*ptr++ = val;
 9a8:	1544 0001      	move.b d4,1(a2)
	while(len-- > 0)
 9ac:	7201           	moveq #1,d1
 9ae:	b285           	cmp.l d5,d1
 9b0:	6720           	beq.s 9d2 <memset+0xc8>
		*ptr++ = val;
 9b2:	1544 0002      	move.b d4,2(a2)
	while(len-- > 0)
 9b6:	7402           	moveq #2,d2
 9b8:	b485           	cmp.l d5,d2
 9ba:	6716           	beq.s 9d2 <memset+0xc8>
		*ptr++ = val;
 9bc:	1544 0003      	move.b d4,3(a2)
	while(len-- > 0)
 9c0:	7c03           	moveq #3,d6
 9c2:	bc85           	cmp.l d5,d6
 9c4:	670c           	beq.s 9d2 <memset+0xc8>
		*ptr++ = val;
 9c6:	1544 0004      	move.b d4,4(a2)
	while(len-- > 0)
 9ca:	5985           	subq.l #4,d5
 9cc:	6704           	beq.s 9d2 <memset+0xc8>
		*ptr++ = val;
 9ce:	1544 0005      	move.b d4,5(a2)
}
 9d2:	4cdf 0cfc      	movem.l (sp)+,d2-d7/a2-a3
 9d6:	4e75           	rts

000009d8 <memcpy>:
{
 9d8:	48e7 3e00      	movem.l d2-d6,-(sp)
 9dc:	202f 0018      	move.l 24(sp),d0
 9e0:	222f 001c      	move.l 28(sp),d1
 9e4:	262f 0020      	move.l 32(sp),d3
	while(len--)
 9e8:	2803           	move.l d3,d4
 9ea:	5384           	subq.l #1,d4
 9ec:	4a83           	tst.l d3
 9ee:	675e           	beq.s a4e <memcpy+0x76>
 9f0:	2041           	movea.l d1,a0
 9f2:	5288           	addq.l #1,a0
 9f4:	2400           	move.l d0,d2
 9f6:	9488           	sub.l a0,d2
 9f8:	7a02           	moveq #2,d5
 9fa:	ba82           	cmp.l d2,d5
 9fc:	55c2           	sc.s d2
 9fe:	4402           	neg.b d2
 a00:	7c08           	moveq #8,d6
 a02:	bc84           	cmp.l d4,d6
 a04:	55c5           	sc.s d5
 a06:	4405           	neg.b d5
 a08:	c405           	and.b d5,d2
 a0a:	6748           	beq.s a54 <memcpy+0x7c>
 a0c:	2400           	move.l d0,d2
 a0e:	8481           	or.l d1,d2
 a10:	7a03           	moveq #3,d5
 a12:	c485           	and.l d5,d2
 a14:	663e           	bne.s a54 <memcpy+0x7c>
 a16:	2041           	movea.l d1,a0
 a18:	2240           	movea.l d0,a1
 a1a:	74fc           	moveq #-4,d2
 a1c:	c483           	and.l d3,d2
 a1e:	d481           	add.l d1,d2
		*d++ = *s++;
 a20:	22d8           	move.l (a0)+,(a1)+
	while(len--)
 a22:	b488           	cmp.l a0,d2
 a24:	66fa           	bne.s a20 <memcpy+0x48>
 a26:	74fc           	moveq #-4,d2
 a28:	c483           	and.l d3,d2
 a2a:	2040           	movea.l d0,a0
 a2c:	d1c2           	adda.l d2,a0
 a2e:	d282           	add.l d2,d1
 a30:	9882           	sub.l d2,d4
 a32:	b483           	cmp.l d3,d2
 a34:	6718           	beq.s a4e <memcpy+0x76>
		*d++ = *s++;
 a36:	2241           	movea.l d1,a1
 a38:	1091           	move.b (a1),(a0)
	while(len--)
 a3a:	4a84           	tst.l d4
 a3c:	6710           	beq.s a4e <memcpy+0x76>
		*d++ = *s++;
 a3e:	1169 0001 0001 	move.b 1(a1),1(a0)
	while(len--)
 a44:	5384           	subq.l #1,d4
 a46:	6706           	beq.s a4e <memcpy+0x76>
		*d++ = *s++;
 a48:	1169 0002 0002 	move.b 2(a1),2(a0)
}
 a4e:	4cdf 007c      	movem.l (sp)+,d2-d6
 a52:	4e75           	rts
 a54:	2240           	movea.l d0,a1
 a56:	d283           	add.l d3,d1
		*d++ = *s++;
 a58:	12e8 ffff      	move.b -1(a0),(a1)+
	while(len--)
 a5c:	b288           	cmp.l a0,d1
 a5e:	67ee           	beq.s a4e <memcpy+0x76>
 a60:	5288           	addq.l #1,a0
 a62:	60f4           	bra.s a58 <memcpy+0x80>

00000a64 <memmove>:
{
 a64:	48e7 3c20      	movem.l d2-d5/a2,-(sp)
 a68:	202f 0018      	move.l 24(sp),d0
 a6c:	222f 001c      	move.l 28(sp),d1
 a70:	242f 0020      	move.l 32(sp),d2
		while (len--)
 a74:	2242           	movea.l d2,a1
 a76:	5389           	subq.l #1,a1
	if (d < s) {
 a78:	b280           	cmp.l d0,d1
 a7a:	636c           	bls.s ae8 <memmove+0x84>
		while (len--)
 a7c:	4a82           	tst.l d2
 a7e:	6762           	beq.s ae2 <memmove+0x7e>
 a80:	2441           	movea.l d1,a2
 a82:	528a           	addq.l #1,a2
 a84:	2600           	move.l d0,d3
 a86:	968a           	sub.l a2,d3
 a88:	7802           	moveq #2,d4
 a8a:	b883           	cmp.l d3,d4
 a8c:	55c3           	sc.s d3
 a8e:	4403           	neg.b d3
 a90:	7a08           	moveq #8,d5
 a92:	ba89           	cmp.l a1,d5
 a94:	55c4           	sc.s d4
 a96:	4404           	neg.b d4
 a98:	c604           	and.b d4,d3
 a9a:	6770           	beq.s b0c <memmove+0xa8>
 a9c:	2600           	move.l d0,d3
 a9e:	8681           	or.l d1,d3
 aa0:	7803           	moveq #3,d4
 aa2:	c684           	and.l d4,d3
 aa4:	6666           	bne.s b0c <memmove+0xa8>
 aa6:	2041           	movea.l d1,a0
 aa8:	2440           	movea.l d0,a2
 aaa:	76fc           	moveq #-4,d3
 aac:	c682           	and.l d2,d3
 aae:	d681           	add.l d1,d3
			*d++ = *s++;
 ab0:	24d8           	move.l (a0)+,(a2)+
		while (len--)
 ab2:	b688           	cmp.l a0,d3
 ab4:	66fa           	bne.s ab0 <memmove+0x4c>
 ab6:	76fc           	moveq #-4,d3
 ab8:	c682           	and.l d2,d3
 aba:	2440           	movea.l d0,a2
 abc:	d5c3           	adda.l d3,a2
 abe:	2041           	movea.l d1,a0
 ac0:	d1c3           	adda.l d3,a0
 ac2:	93c3           	suba.l d3,a1
 ac4:	b682           	cmp.l d2,d3
 ac6:	671a           	beq.s ae2 <memmove+0x7e>
			*d++ = *s++;
 ac8:	1490           	move.b (a0),(a2)
		while (len--)
 aca:	b2fc 0000      	cmpa.w #0,a1
 ace:	6712           	beq.s ae2 <memmove+0x7e>
			*d++ = *s++;
 ad0:	1568 0001 0001 	move.b 1(a0),1(a2)
		while (len--)
 ad6:	7a01           	moveq #1,d5
 ad8:	ba89           	cmp.l a1,d5
 ada:	6706           	beq.s ae2 <memmove+0x7e>
			*d++ = *s++;
 adc:	1568 0002 0002 	move.b 2(a0),2(a2)
}
 ae2:	4cdf 043c      	movem.l (sp)+,d2-d5/a2
 ae6:	4e75           	rts
		const char *lasts = s + (len - 1);
 ae8:	41f1 1800      	lea (0,a1,d1.l),a0
		char *lastd = d + (len - 1);
 aec:	d3c0           	adda.l d0,a1
		while (len--)
 aee:	4a82           	tst.l d2
 af0:	67f0           	beq.s ae2 <memmove+0x7e>
 af2:	2208           	move.l a0,d1
 af4:	9282           	sub.l d2,d1
			*lastd-- = *lasts--;
 af6:	1290           	move.b (a0),(a1)
		while (len--)
 af8:	5388           	subq.l #1,a0
 afa:	5389           	subq.l #1,a1
 afc:	b288           	cmp.l a0,d1
 afe:	67e2           	beq.s ae2 <memmove+0x7e>
			*lastd-- = *lasts--;
 b00:	1290           	move.b (a0),(a1)
		while (len--)
 b02:	5388           	subq.l #1,a0
 b04:	5389           	subq.l #1,a1
 b06:	b288           	cmp.l a0,d1
 b08:	66ec           	bne.s af6 <memmove+0x92>
 b0a:	60d6           	bra.s ae2 <memmove+0x7e>
 b0c:	2240           	movea.l d0,a1
 b0e:	d282           	add.l d2,d1
			*d++ = *s++;
 b10:	12ea ffff      	move.b -1(a2),(a1)+
		while (len--)
 b14:	b28a           	cmp.l a2,d1
 b16:	67ca           	beq.s ae2 <memmove+0x7e>
 b18:	528a           	addq.l #1,a2
 b1a:	60f4           	bra.s b10 <memmove+0xac>

00000b1c <__mulsi3>:
	.text
	FUNC(__mulsi3)
	.globl	SYM (__mulsi3)
SYM (__mulsi3):
	.cfi_startproc
	movew	sp@(4), d0	/* x0 -> d0 */
 b1c:	302f 0004      	move.w 4(sp),d0
	muluw	sp@(10), d0	/* x0*y1 */
 b20:	c0ef 000a      	mulu.w 10(sp),d0
	movew	sp@(6), d1	/* x1 -> d1 */
 b24:	322f 0006      	move.w 6(sp),d1
	muluw	sp@(8), d1	/* x1*y0 */
 b28:	c2ef 0008      	mulu.w 8(sp),d1
	addw	d1, d0
 b2c:	d041           	add.w d1,d0
	swap	d0
 b2e:	4840           	swap d0
	clrw	d0
 b30:	4240           	clr.w d0
	movew	sp@(6), d1	/* x1 -> d1 */
 b32:	322f 0006      	move.w 6(sp),d1
	muluw	sp@(10), d1	/* x1*y1 */
 b36:	c2ef 000a      	mulu.w 10(sp),d1
	addl	d1, d0
 b3a:	d081           	add.l d1,d0
	rts
 b3c:	4e75           	rts

00000b3e <__udivsi3>:
	.text
	FUNC(__udivsi3)
	.globl	SYM (__udivsi3)
SYM (__udivsi3):
	.cfi_startproc
	movel	d2, sp@-
 b3e:	2f02           	move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	sp@(12), d1	/* d1 = divisor */
 b40:	222f 000c      	move.l 12(sp),d1
	movel	sp@(8), d0	/* d0 = dividend */
 b44:	202f 0008      	move.l 8(sp),d0

	cmpl	IMM (0x10000), d1 /* divisor >= 2 ^ 16 ?   */
 b48:	0c81 0001 0000 	cmpi.l #65536,d1
	jcc	3f		/* then try next algorithm */
 b4e:	6416           	bcc.s b66 <__udivsi3+0x28>
	movel	d0, d2
 b50:	2400           	move.l d0,d2
	clrw	d2
 b52:	4242           	clr.w d2
	swap	d2
 b54:	4842           	swap d2
	divu	d1, d2          /* high quotient in lower word */
 b56:	84c1           	divu.w d1,d2
	movew	d2, d0		/* save high quotient */
 b58:	3002           	move.w d2,d0
	swap	d0
 b5a:	4840           	swap d0
	movew	sp@(10), d2	/* get low dividend + high rest */
 b5c:	342f 000a      	move.w 10(sp),d2
	divu	d1, d2		/* low quotient */
 b60:	84c1           	divu.w d1,d2
	movew	d2, d0
 b62:	3002           	move.w d2,d0
	jra	6f
 b64:	6030           	bra.s b96 <__udivsi3+0x58>

3:	movel	d1, d2		/* use d2 as divisor backup */
 b66:	2401           	move.l d1,d2
4:	lsrl	IMM (1), d1	/* shift divisor */
 b68:	e289           	lsr.l #1,d1
	lsrl	IMM (1), d0	/* shift dividend */
 b6a:	e288           	lsr.l #1,d0
	cmpl	IMM (0x10000), d1 /* still divisor >= 2 ^ 16 ?  */
 b6c:	0c81 0001 0000 	cmpi.l #65536,d1
	jcc	4b
 b72:	64f4           	bcc.s b68 <__udivsi3+0x2a>
	divu	d1, d0		/* now we have 16-bit divisor */
 b74:	80c1           	divu.w d1,d0
	andl	IMM (0xffff), d0 /* mask out divisor, ignore remainder */
 b76:	0280 0000 ffff 	andi.l #65535,d0

/* Multiply the 16-bit tentative quotient with the 32-bit divisor.  Because of
   the operand ranges, this might give a 33-bit product.  If this product is
   greater than the dividend, the tentative quotient was too large. */
	movel	d2, d1
 b7c:	2202           	move.l d2,d1
	mulu	d0, d1		/* low part, 32 bits */
 b7e:	c2c0           	mulu.w d0,d1
	swap	d2
 b80:	4842           	swap d2
	mulu	d0, d2		/* high part, at most 17 bits */
 b82:	c4c0           	mulu.w d0,d2
	swap	d2		/* align high part with low part */
 b84:	4842           	swap d2
	tstw	d2		/* high part 17 bits? */
 b86:	4a42           	tst.w d2
	jne	5f		/* if 17 bits, quotient was too large */
 b88:	660a           	bne.s b94 <__udivsi3+0x56>
	addl	d2, d1		/* add parts */
 b8a:	d282           	add.l d2,d1
	jcs	5f		/* if sum is 33 bits, quotient was too large */
 b8c:	6506           	bcs.s b94 <__udivsi3+0x56>
	cmpl	sp@(8), d1	/* compare the sum with the dividend */
 b8e:	b2af 0008      	cmp.l 8(sp),d1
	jls	6f		/* if sum > dividend, quotient was too large */
 b92:	6302           	bls.s b96 <__udivsi3+0x58>
5:	subql	IMM (1), d0	/* adjust quotient */
 b94:	5380           	subq.l #1,d0

6:	movel	sp@+, d2
 b96:	241f           	move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
 b98:	4e75           	rts

00000b9a <__divsi3>:
	.text
	FUNC(__divsi3)
	.globl	SYM (__divsi3)
SYM (__divsi3):
	.cfi_startproc
	movel	d2, sp@-
 b9a:	2f02           	move.l d2,-(sp)
	.cfi_adjust_cfa_offset 4

	moveq	IMM (1), d2	/* sign of result stored in d2 (=1 or =-1) */
 b9c:	7401           	moveq #1,d2
	movel	sp@(12), d1	/* d1 = divisor */
 b9e:	222f 000c      	move.l 12(sp),d1
	jpl	1f
 ba2:	6a04           	bpl.s ba8 <__divsi3+0xe>
	negl	d1
 ba4:	4481           	neg.l d1
	negb	d2		/* change sign because divisor <0  */
 ba6:	4402           	neg.b d2
1:	movel	sp@(8), d0	/* d0 = dividend */
 ba8:	202f 0008      	move.l 8(sp),d0
	jpl	2f
 bac:	6a04           	bpl.s bb2 <__divsi3+0x18>
	negl	d0
 bae:	4480           	neg.l d0
	negb	d2
 bb0:	4402           	neg.b d2

2:	movel	d1, sp@-
 bb2:	2f01           	move.l d1,-(sp)
	movel	d0, sp@-
 bb4:	2f00           	move.l d0,-(sp)
	PICCALL	SYM (__udivsi3)	/* divide abs(dividend) by abs(divisor) */
 bb6:	6186           	bsr.s b3e <__udivsi3>
	addql	IMM (8), sp
 bb8:	508f           	addq.l #8,sp

	tstb	d2
 bba:	4a02           	tst.b d2
	jpl	3f
 bbc:	6a02           	bpl.s bc0 <__divsi3+0x26>
	negl	d0
 bbe:	4480           	neg.l d0

3:	movel	sp@+, d2
 bc0:	241f           	move.l (sp)+,d2
	.cfi_adjust_cfa_offset -4
	rts
 bc2:	4e75           	rts

00000bc4 <__modsi3>:
	.text
	FUNC(__modsi3)
	.globl	SYM (__modsi3)
SYM (__modsi3):
	.cfi_startproc
	movel	sp@(8), d1	/* d1 = divisor */
 bc4:	222f 0008      	move.l 8(sp),d1
	movel	sp@(4), d0	/* d0 = dividend */
 bc8:	202f 0004      	move.l 4(sp),d0
	movel	d1, sp@-
 bcc:	2f01           	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
 bce:	2f00           	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	PICCALL	SYM (__divsi3)
 bd0:	61c8           	bsr.s b9a <__divsi3>
	addql	IMM (8), sp
 bd2:	508f           	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(8), d1	/* d1 = divisor */
 bd4:	222f 0008      	move.l 8(sp),d1
	movel	d1, sp@-
 bd8:	2f01           	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
 bda:	2f00           	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	PICCALL	SYM (__mulsi3)	/* d0 = (a/b)*b */
 bdc:	6100 ff3e      	bsr.w b1c <__mulsi3>
	addql	IMM (8), sp
 be0:	508f           	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(4), d1	/* d1 = dividend */
 be2:	222f 0004      	move.l 4(sp),d1
	subl	d0, d1		/* d1 = a - (a/b)*b */
 be6:	9280           	sub.l d0,d1
	movel	d1, d0
 be8:	2001           	move.l d1,d0
	rts
 bea:	4e75           	rts

00000bec <__umodsi3>:
	.text
	FUNC(__umodsi3)
	.globl	SYM (__umodsi3)
SYM (__umodsi3):
	.cfi_startproc
	movel	sp@(8), d1	/* d1 = divisor */
 bec:	222f 0008      	move.l 8(sp),d1
	movel	sp@(4), d0	/* d0 = dividend */
 bf0:	202f 0004      	move.l 4(sp),d0
	movel	d1, sp@-
 bf4:	2f01           	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
 bf6:	2f00           	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	PICCALL	SYM (__udivsi3)
 bf8:	6100 ff44      	bsr.w b3e <__udivsi3>
	addql	IMM (8), sp
 bfc:	508f           	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(8), d1	/* d1 = divisor */
 bfe:	222f 0008      	move.l 8(sp),d1
	movel	d1, sp@-
 c02:	2f01           	move.l d1,-(sp)
	.cfi_adjust_cfa_offset 4
	movel	d0, sp@-
 c04:	2f00           	move.l d0,-(sp)
	.cfi_adjust_cfa_offset 4
	PICCALL	SYM (__mulsi3)	/* d0 = (a/b)*b */
 c06:	6100 ff14      	bsr.w b1c <__mulsi3>
	addql	IMM (8), sp
 c0a:	508f           	addq.l #8,sp
	.cfi_adjust_cfa_offset -8
	movel	sp@(4), d1	/* d1 = dividend */
 c0c:	222f 0004      	move.l 4(sp),d1
	subl	d0, d1		/* d1 = a - (a/b)*b */
 c10:	9280           	sub.l d0,d1
	movel	d1, d0
 c12:	2001           	move.l d1,d0
	rts
 c14:	4e75           	rts

00000c16 <KPutCharX>:
	FUNC(KPutCharX)
	.globl	SYM (KPutCharX)

SYM(KPutCharX):
	.cfi_startproc
    move.l  a6, -(sp)
 c16:	2f0e           	move.l a6,-(sp)
	.cfi_adjust_cfa_offset 4
    move.l  4.w, a6
 c18:	2c78 0004      	movea.l 4 <_start+0x4>,a6
    jsr     -0x204(a6)
 c1c:	4eae fdfc      	jsr -516(a6)
    movea.l (sp)+, a6
 c20:	2c5f           	movea.l (sp)+,a6
	.cfi_adjust_cfa_offset -4
    rts
 c22:	4e75           	rts

00000c24 <PutChar>:
	FUNC(PutChar)
	.globl	SYM (PutChar)

SYM(PutChar):
	.cfi_startproc
	move.b d0, (a3)+
 c24:	16c0           	move.b d0,(a3)+
	rts
 c26:	4e75           	rts
