#ifndef HANK_HEAD
#define HANK_HEAD 1

#include "../support/gcc8_c_support.h"
#include "custom_defines.h"
#include "DemoTypes.h"
#include "vector.h"
#include <clib/alib_stdio_protos.h>
#include <proto/exec.h>
#include <exec/execbase.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <graphics/gfxbase.h>
#include <graphics/view.h>
#include <graphics/gfxmacros.h>
#include <hardware/custom.h>
#include <hardware/dmabits.h>
#include <hardware/intbits.h>
#include <intuition/intuition.h>

#define Abs(a) (a < 0 ? a * -1 : a)

#define PI (3141)
struct ExecBase *SysBase;
volatile struct Custom *custom;
struct DosLibrary *DOSBase;
struct GfxBase *GfxBase;

volatile int frameCounter;
//backup
static UWORD SystemInts;
static UWORD SystemDMA;
static UWORD SystemADKCON;
volatile static APTR VBR = 0;
static APTR SystemIrq;
struct View *ActiView;

#define ScreenW (320)
#define ScreenH (256)
#define ScreenBpls (3)
#define ScreenBpl (ScreenW / 8)
#define ScreenBplt (ScreenBpl * ScreenBpls)
#define ScreenBps (ScreenBpl * ScreenH)
#define ScreenStl (ScreenBplt * ScreenH)

USHORT *copPtr, *copper1;
extern struct Image imgLogo;
extern UWORD imgLogoPaletteRGB4[8];
extern struct Image imgCookie;
extern UWORD imgCookiePaletteRGB4[8];

struct RastPort *RPortA;

ImageContainer bmpLogo;
ImageContainer bmpCookie;

UWORD bmpDisplayData[ScreenStl/2] __attribute__((section("BMP_DISP.MEMF_CHIP")));
ImageContainer bmpDisplay = {
    {
        320/8,
        256,
        0,
        3,
        NULL
    },
    bmpDisplayData, /* ImageData */
    0, 0,
    320,256};

UWORD bmpCookieMaskData[ScreenStl/2]__attribute__((section("BMP_COOKIEMASK.MEMF_CHIP")));;
ImageContainer bmpCookieMask = {
    {
        320/8,
        256,
        0,
        3,
        NULL
    },
    bmpDisplayData, /* ImageData */
    0, 0,
    320,256};

// proto
inline short MouseLeft() { return !((*(volatile UBYTE *)0xbfe001) & 64); }
inline short MouseRight() { return !((*(volatile UWORD *)0xdff016) & (1 << 10)); }

// DEMO - INCBIN
Point2D PolyBox[4];

Point2D SinusData[320];
USHORT colors[] = {
    0x0000, 0x0556, 0x0C95, 0x0EA6, 0x0432, 0x0531, 0x0212, 0x0881};

// put copperlist into chip mem so we can use it without copying
const UWORD copper2[] __attribute__((section("COP1.MEMF_CHIP"))) = {
    0xe001, 0xff00, offsetof(struct Custom, color[29]), 0x0eee, // line 0xe0
    0xe101, 0xff00, offsetof(struct Custom, color[29]), 0x0ddd, // line 0xe1
    0xe201, 0xff00, offsetof(struct Custom, color[29]), 0x0ccc, // line 0xe2
    0xe301, 0xff00, offsetof(struct Custom, color[29]), 0x0bbb, // line 0xe3
    0xe401, 0xff00, offsetof(struct Custom, color[29]), 0x0aaa, // line 0xe4
    0xe501, 0xff00, offsetof(struct Custom, color[29]), 0x0999, // line 0xe5
    0xe601, 0xff00, offsetof(struct Custom, color[29]), 0x0888, // line 0xe6
    0xe701, 0xff00, offsetof(struct Custom, color[29]), 0x0777, // line 0xe7
    0xe801, 0xff00, offsetof(struct Custom, color[29]), 0x0666, // line 0xe8
    0xe901, 0xff00, offsetof(struct Custom, color[29]), 0x0555, // line 0xe9
    0xea01, 0xff00, offsetof(struct Custom, color[29]), 0x0444, // line 0xea
    0xeb01, 0xff00, offsetof(struct Custom, color[29]), 0x0333, // line 0xeb
    0xec01, 0xff00, offsetof(struct Custom, color[29]), 0x0222, // line 0xec
    0xed01, 0xff00, offsetof(struct Custom, color[29]), 0x0111, // line 0xed
    0xee01, 0xff00, offsetof(struct Custom, color[29]), 0x0000, // line 0xee
    0xffff, 0xfffe                                              // end copper list
};

static APTR GetVBR(void)
{
    APTR vbr = 0;
    UWORD getvbr[] = {0x4e7a, 0x0801, 0x4e73}; // MOVEC.L VBR,D0 RTE

    if (SysBase->AttnFlags & AFF_68010)
        vbr = (APTR)Supervisor((ULONG(*)())getvbr);

    return vbr;
}

inline USHORT *copSetPlanes(UBYTE bplPtrStart, USHORT *copListEnd, UBYTE **planes, int numPlanes)
{
    for (USHORT i = 0; i < numPlanes; i++)
    {
        ULONG addr = (ULONG)planes[i];
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]);
        *copListEnd++ = (UWORD)(addr >> 16);
        *copListEnd++ = offsetof(struct Custom, bplpt[i + bplPtrStart]) + 2;
        *copListEnd++ = (UWORD)addr;
    }
    return copListEnd;
}

inline USHORT *copSetOddEvenPlanes(UBYTE bplPtrStart, USHORT *copListEnd, UBYTE **planes, int numPlanes, BOOL odd)
{
    BYTE plane = odd ? 1 : 0;
    for (USHORT i = 0; i < numPlanes; i++)
    {
        ULONG addr = (ULONG)planes[i];
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]);
        *copListEnd++ = (UWORD)(addr >> 16);
        *copListEnd++ = offsetof(struct Custom, bplpt[plane + bplPtrStart]) + 2;
        *copListEnd++ = (UWORD)addr;
        plane += 2;
    }
    return copListEnd;
}

inline USHORT *copWaitXY(USHORT *copListEnd, USHORT x, USHORT i)
{
    *copListEnd++ = (i << 8) | (x << 1) | 1; //bit 1 means wait. waits for vertical position x<<8, first raster stop position outside the left
    *copListEnd++ = 0xfffe;
    return copListEnd;
}

inline USHORT *copWaitY(USHORT *copListEnd, USHORT i)
{
    *copListEnd++ = (i << 8) | 4 | 1; //bit 1 means wait. waits for vertical position x<<8, first raster stop position outside the left
    *copListEnd++ = 0xfffe;
    return copListEnd;
}

inline USHORT *copSetColor(USHORT *copListCurrent, USHORT index, USHORT color)
{
    *copListCurrent++ = offsetof(struct Custom, color[index]);
    *copListCurrent++ = color;
    return copListCurrent;
}

static __attribute__((interrupt)) void interruptHandler(void)
{
    custom->intreq = (1 << INTB_VERTB);
    custom->intreq = (1 << INTB_VERTB); //reset vbl req. twice for a4000 bug.
    // DEMO - increment frameCounter
    frameCounter++;
}

#ifdef __cplusplus
class TestClass
{
public:
    TestClass(int y)
    {
        static int x = 7;
        i = y + x;
    }

    int i;
};

TestClass staticClass(4);
#endif

// set up a 320x256 lowres display
inline USHORT *screenScanDefault(USHORT *copListEnd)
{
    const USHORT x = 129;
    const USHORT width = 320;
    const USHORT height = 256;
    const USHORT y = 44;
    const USHORT RES = 8; //8=lowres,4=hires
    USHORT xstop = x + width;
    USHORT ystop = y + height;
    USHORT fw = (x >> 1) - RES;

    *copListEnd++ = offsetof(struct Custom, ddfstrt);
    *copListEnd++ = fw;
    *copListEnd++ = offsetof(struct Custom, ddfstop);
    *copListEnd++ = fw + (((width >> 4) - 1) << 3);
    *copListEnd++ = offsetof(struct Custom, diwstrt);
    *copListEnd++ = x + (y << 8);
    *copListEnd++ = offsetof(struct Custom, diwstop);
    *copListEnd++ = (xstop - 256) + ((ystop - 256) << 8);
    return copListEnd;
}

void SetInterruptHandler(APTR interrupt)
{
    *(volatile APTR *)(((UBYTE *)VBR) + 0x6c) = interrupt;
}

APTR GetInterruptHandler(void)
{
    return *(volatile APTR *)(((UBYTE *)VBR) + 0x6c);
}

//vblank begins at vpos 312 hpos 1 and ends at vpos 25 hpos 1
//vsync begins at line 2 hpos 132 and ends at vpos 5 hpos 18
void WaitVbl(void)
{
    while (1)
    {
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
        vpos &= 0x1ff00;
        if (vpos != (311 << 8))
            break;
    }
    while (1)
    {
        volatile ULONG vpos = *(volatile ULONG *)0xDFF004;
        vpos &= 0x1ff00;
        if (vpos == (311 << 8))
            break;
    }
}

inline void WaitBlt()
{
    UWORD tst = *(volatile UWORD *)&custom->dmaconr; //for compatiblity a1000
    (void)tst;
    while (*(volatile UWORD *)&custom->dmaconr & (1 << 14))
    {
    } //blitter busy wait
}

void TakeSystem(void)
{
    ActiView = GfxBase->ActiView; //store current view
    OwnBlitter();
    WaitBlit();
    Disable();

    //Save current interrupts and DMA settings so we can restore them upon exit.
    SystemADKCON = custom->adkconr;
    SystemInts = custom->intenar;
    SystemDMA = custom->dmaconr;
    custom->intena = 0x7fff; //disable all interrupts
    custom->intreq = 0x7fff; //Clear any interrupts that were pending

    WaitVbl();
    WaitVbl();
    custom->dmacon = 0x7fff; //Clear all DMA channels

    //set all colors black
    for (int a = 0; a < 32; a++)
        custom->color[a] = 0;

    LoadView(0);
    WaitTOF();
    WaitTOF();

    WaitVbl();
    WaitVbl();

    VBR = GetVBR();
    SystemIrq = GetInterruptHandler(); //store interrupt register
}

void FreeSystem(void)
{
    WaitVbl();
    WaitBlt();
    custom->intena = 0x7fff; //disable all interrupts
    custom->intreq = 0x7fff; //Clear any interrupts that were pending
    custom->dmacon = 0x7fff; //Clear all DMA channels

    //restore interrupts
    SetInterruptHandler(SystemIrq);

    /*Restore system copper list(s). */
    custom->cop1lc = (ULONG)GfxBase->copinit;
    custom->cop2lc = (ULONG)GfxBase->LOFlist;
    custom->copjmp1 = 0x7fff; //start coppper

    /*Restore all interrupts and DMA settings. */
    custom->intena = SystemInts | 0x8000;
    custom->dmacon = SystemDMA | 0x8000;
    custom->adkcon = SystemADKCON | 0x8000;

    LoadView(ActiView);
    WaitTOF();
    WaitTOF();
    WaitBlit();
    DisownBlitter();
    Enable();
}

int InitDemo(void);

void SetCopper(void);

void InitImagePlanes(ImageContainer *img);

void SinusDraw(Point2D *targetList, USHORT sinstart, USHORT x, USHORT y, int amp, int width);

void SetPixel(ImageContainer bitmap, USHORT x, USHORT y, UBYTE col);

void LineDraw(ImageContainer bitmap, int x0, int y0, int x1, int y1, UBYTE col);

void PolygonDraw(ImageContainer bitmap, Point2D *pointlist, USHORT length, BYTE col, BOOL closed);

void Points2DRotate(Point2D *pointsA, Point2D *pointsB, USHORT length, Point2D origin, int alpha);

void EllipseDraw(ImageContainer bitmap, BYTE col, int xm, int ym, int a, int b);

void CopyBitmap(ImageContainer bmpS, ImageContainer bmpD);

void ClearBitmap(ImageContainer bmpD);

void MakePolys();

void SimpleBlit(ImageContainer imgS, ImageContainer imgD, Point2D startS, Point2D startD, USHORT height, USHORT width);

void GetCookieMask(UBYTE planes, UBYTE **bmp, UBYTE *destMask, USHORT height, USHORT width);

void ImageToImgContainer(struct Image *img, ImageContainer *imgC);

#endif // HANK_HEAD
