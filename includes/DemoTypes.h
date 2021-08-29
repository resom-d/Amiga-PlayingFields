#include <proto/exec.h>
#include <exec/execbase.h>
#include <graphics/gfx.h>


struct _imageContainer
{
    struct BitMap Bitmap;
    UWORD *ImageData;    
    WORD LeftEdge; /* starting offset relative to some origin */
    WORD TopEdge;  /* starting offsets relative to some origin */
    WORD Width;    /* pixel size (though data is word-aligned) */
    WORD Height;   /* height in px*/
};
typedef struct _imageContainer ImageContainer;

