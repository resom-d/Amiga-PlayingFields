#include "includes/head.h"

int main()
{
	InitDemo();

	MakePolys();

	while (!MouseLeft())
	{
		WaitVbl();
		
		CopyBitmap(bmpDraw, bmpDisplay);
		ClearBitmap(bmpDraw);
		WaitBlt();
		
		PolygonDraw(bmpDraw, PolyBox, 4, 7, TRUE);
		EllipseDraw(bmpDraw, 2, 80, 80, 50, 50);
	}

	// END
	FreeSystem();
	CloseLibrary((struct Library *)DOSBase);
	CloseLibrary((struct Library *)GfxBase);
}

void SetCopper()
{
	copPtr = screenScanDefault(copPtr);
	//enable bitplanes
	*copPtr++ = BPLCON0;
	*copPtr++ = (0 << 10) /*dual pf*/ | (1 << 9) /*color*/ | ((ScreenBpls) << 12) /*num bitplanes*/;
	*copPtr++ = BPLCON1; //scrolling
	*copPtr++ = 0;
	*copPtr++ = BPLCON2; //playfied priority
	*copPtr++ = 1 << 6;	 //0x24;			//Sprites have priority over playfields

	//set bitplane modulo
	*copPtr++ = BPL1MOD; //odd planes   1,3,5
	*copPtr++ = 0;
	*copPtr++ = BPL2MOD; //even  planes 2,4
	*copPtr++ = 0;

	// set bitplane pointers
	copPtr = copSetPlanes(0, copPtr, bmpDisplay.Planes, ScreenBpls);

	// set colors
	for (int a = 0; a < 8; a++)
		copPtr = copSetColor(copPtr, a, bmpLogoPaletteRGB4[a]);

	copPtr = copWaitY(copPtr, 0x2c + 170);
	//set bitplane modulo
	*copPtr++ = BPL1MOD; //odd planes   1,3,5
	*copPtr++ = -2 * ScreenBpl;
	*copPtr++ = BPL2MOD; //even  planes 2,4
	*copPtr++ = -2 * ScreenBpl;

	copPtr = copWaitXY(copPtr, 0xfe, 0xff);
}

int InitDemo()
{
	SysBase = *((struct ExecBase **)4UL);
	custom = (struct Custom *)0xdff000;

	// We will use the graphics library only to locate and restore the system copper list once we are through.
	GfxBase = (struct GfxBase *)OpenLibrary((CONST_STRPTR) "graphics.library", 0);
	if (!GfxBase)
		Exit(0);

	// used for printing
	DOSBase = (struct DosLibrary *)OpenLibrary((CONST_STRPTR) "dos.library", 0);
	if (!DOSBase)
		Exit(0);

#ifdef __cplusplus
	KPrintF("Hello debugger from Amiga: %ld!\n", staticClass.i);
#else
	KPrintF("Hello debugger from Amiga!\n");
#endif
	Write(Output(), (APTR) "Hello console!\n", 15);

	warpmode(1);
	warpmode(0);

	TakeSystem();
	// TODO: precalc stuff here
	copper1 = AllocMem(1024, MEMF_CHIP);
	copPtr = copper1;

	InitImagePlanes(&bmpDisplay);
	InitImagePlanes(&bmpDraw);
	for (int p = 0; p < LogoImage.Depth; p++)
	{
		bmpLogoPlanes[p] = (UBYTE *)LogoImage.ImageData + (p * (LogoImage.Width / 8 * LogoImage.Height));
	}

	WaitVbl();

	SetCopper();

	custom->cop1lc = (ULONG)copper1;
	custom->dmacon = DMAF_BLITTER; //disable blitter dma for copjmp bug
	custom->copjmp1 = 0x7fff;	   //start coppper
	custom->dmacon = DMAF_SETCLR | DMAF_MASTER | DMAF_RASTER | DMAF_COPPER | DMAF_BLITTER;

	// DEMO
	SetInterruptHandler((APTR)interruptHandler);
	custom->intena = (1 << INTB_SETCLR) | (1 << INTB_INTEN) | (1 << INTB_VERTB);
	custom->intreq = 1 << INTB_VERTB; //reset vbl req

	return RETURN_OK;
}

void InitImagePlanes(ImageContainer *img)
{
	for (int p = 0; p < img->Depth; p++)
	{
		img->Planes[p] = (UBYTE *)img->ImageData + (p * (img->BytesPerRow * img->Height));
	}
}

void SetPixel(ImageContainer bitmap, USHORT x, USHORT y, UBYTE col)
{
	USHORT xb = (x) / 8;
	UBYTE xo = 0x80 >> (x % 8);
	USHORT yb = y * bitmap.BytesPerRow;
	for (int pl = 0; pl < bitmap.Depth; pl++)
	{
		bitmap.Planes[pl][yb + xb] &= ~xo;
		if ((col >> pl) & (UBYTE)1)
		{
			bitmap.Planes[pl][yb + xb] |= xo;
		}
	}
}

void LineDraw(ImageContainer bitmap, int x0, int y0, int x1, int y1, UBYTE col)
{
	int dx = Abs(x1 - x0), sx = x0 < x1 ? 1 : -1;
	int dy = -Abs(y1 - y0), sy = y0 < y1 ? 1 : -1;
	int err = dx + dy, e2; /* error value e_xy */

	while (1)
	{
		SetPixel(bitmap, x0, y0, col);
		if (x0 == x1 && y0 == y1)
			break;
		e2 = 2 * err;
		if (e2 > dy)
		{
			err += dy;
			x0 += sx;
		} /* e_xy+e_x > 0 */
		if (e2 < dx)
		{
			err += dx;
			y0 += sy;
		} /* e_xy+e_y < 0 */
	}
}

void SinusDraw(Point2D *targetlist, USHORT sinstart, USHORT x, USHORT y, int amp, int width)
{
	int idx = sinstart;
	int mod = width / (SINSIZE % width);

	for (int i = 0; i < width; i++)
	{
		idx += (SINSIZE / width);
		if (idx > 719)
			idx = 0;
		if (i % mod == 0)
			idx++;
		if (idx > 719)
			idx = 0;

		targetlist[i].X = x + i;
		targetlist[i].Y = y + (sin_05[idx] * amp / 1000);
	}
}

void PolygonDraw(ImageContainer bitmap, Point2D *pointlist, USHORT length, BYTE col, BOOL closed)
{
	for (int i = 0; i < length - 1; i++)
	{
		LineDraw(bitmap, pointlist[i].X, pointlist[i].Y, pointlist[i + 1].X, pointlist[i + 1].Y, col);
	}
	if (closed)
	{
		LineDraw(bitmap, pointlist[length - 1].X, pointlist[length - 1].Y, pointlist[0].X, pointlist[0].Y, col);
	}
}

void EllipseDraw(ImageContainer bitmap, BYTE col, int xm, int ym, int a, int b)
{
	int dx = 0, dy = b; /* im I. Quadranten von links oben nach rechts unten */
	long a2 = a * a, b2 = b * b;
	long err = b2 - (2 * b - 1) * a2, e2; /* Fehler im 1. Schritt */
	do
	{
		/* I. Quadrant */
		SetPixel(bitmap, xm + dx, ym + dy, col);
		/* II. Quadrant */
		SetPixel(bitmap, xm - dx, ym + dy, col);
		/* III. Quadrant */
		SetPixel(bitmap, xm - dx, ym - dy, col);
		/* IV. Quadrant */
		SetPixel(bitmap, xm + dx, ym - dy, col);

		e2 = 2 * err;
		if (e2 < (2 * dx + 1) * b2)
		{
			dx++;
			err += (2 * dx + 1) * b2;
		}
		if (e2 > -(2 * dy - 1) * a2)
		{
			dy--;
			err -= (2 * dy - 1) * a2;
		}
	} while (dy >= 0);

	while (dx++ < a)
	{	/* fehlerhafter Abbruch bei flachen Ellipsen (b=1) */
		//    setPixel(xm+dx, ym); /* -> Spitze der Ellipse vollenden */
		//    setPixel(xm-dx, ym);
	}
}

void MakePolys()
{
	PolyBox[0].X = 10;
	PolyBox[0].Y = 10;
	PolyBox[1].X = 50;
	PolyBox[1].Y = 10;
	PolyBox[2].X = 50;
	PolyBox[2].Y = 50;
	PolyBox[3].X = 10;
	PolyBox[3].Y = 50;
}

void Points2DRotate(Point2D *pointsA, Point2D *pointsB, USHORT length, Point2D origin, int alpha)
{
	for (int i = 0; i < length; i++)
	{
		pointsB[i] = Point2DRotate(pointsA[i], origin, alpha);
	}
}

void CopyBitmap(ImageContainer bmpS, ImageContainer bmpD)
{
	WaitBlt();
	WaitBlt();

	custom->bltcon0 = 0x09f0;
	custom->bltcon1 = 0x0000;
	custom->bltapt = bmpS.ImageData;
	custom->bltdpt = bmpD.ImageData;
	custom->bltafwm = 0xffff;
	custom->bltalwm = 0xffff;
	custom->bltamod = 0;
	custom->bltdmod = 0;
	custom->bltsize = ((bmpS.Height * bmpS.Depth) << 6) + (bmpS.BytesPerRow / 2);
}

void ClearBitmap(ImageContainer bmpD)
{
	WaitBlt();
	WaitBlt();

	custom->bltcon0 = 0x0900;
	custom->bltcon1 = 0x0000;
	custom->bltapt = bmpD.ImageData;
	custom->bltdpt = bmpD.ImageData;
	custom->bltafwm = 0xffff;
	custom->bltalwm = 0xffff;
	custom->bltamod = 0;
	custom->bltdmod = 0;
	custom->bltsize = ((bmpD.Height * bmpD.Depth) << 6) + (bmpD.BytesPerRow / 2);
}