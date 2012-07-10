/**
 *  @file
 *  NASymbol.h
 *  NuAS Amethyst Graphics System
 *
 *  This header defines basic functions of the NuAS Amethyst Graphics
 *  library. It defines functions and data types for plotting
 *  2D-symbols on screen.
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#ifndef __NASYMBOL_H__
#define __NASYMBOL_H__

#include <CoreGraphics/CoreGraphics.h>
#include "NABase.h"


/** Styles a symbol can be drawn. */
typedef enum _NASymbolStyle {
    kSymbolNone,
    kSymbolDisk,
    kSymbolSquare, 
    kSymbolEmptySquare,
    kSymbolDiamond,
    kSymbolTriangleUp,
    kSymbolTriangleDown,
    kSymbolTriangleLeft,
    kSymbolTriangleRight,
    kSymbolPlus,
    kSymbolX,
    kSymbolStar
} NASymbolStyle;


void NAContextAddSymbol(const CGContextRef, 
                        const NASymbolStyle,
                        const CGPoint,
                        const NAFloat);


#endif /* __NASYMBOL_H__ */

