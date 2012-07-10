/*
 *  NASymbol.c
 *  NuAS Amethyst Graphics System
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#include "NASymbol.h"
#include "NADashing.h"


/** @brief Draw a symbol on screen.
 
    @param aContext Drawing context.
    @param symbolStyle NASymbolStyle which declares the type of the symbol.
    @param aPoint Screen coordinates.
    @param symbolSize Screen size of symbol.
 */

void NAContextAddSymbol(const CGContextRef aContext,
                        const NASymbolStyle symbolStyle,
                        const CGPoint aPoint,
                        const NAFloat symbolSize) {
    
    NAFloat halfSize = symbolSize/2.0;
    
    
    /* Save the current context. */
    CGContextSaveGState(aContext);
    
    /* Setup the line configuration. */
    CGContextSetLineWidth(aContext, 0.0);
    NAContextSetLineDash(aContext, kDashingSolid);
    
    /* Plot the appropriate symbol in each case. */
    switch (symbolStyle) {
        case kSymbolDisk:
            CGContextFillEllipseInRect(aContext,
                                       CGRectMake(aPoint.x-halfSize,
                                                  aPoint.y-halfSize,
                                                  2.0*halfSize, 
                                                  2.0*halfSize));
            break;
        case kSymbolSquare:
            CGContextFillRect(aContext,
                              CGRectMake(aPoint.x-halfSize,
                                         aPoint.y-halfSize,
                                         2.0*halfSize, 
                                         2.0*halfSize));
            break;
        case kSymbolEmptySquare:
            CGContextSetLineWidth(aContext, halfSize/5.0);
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext, aPoint.x-halfSize, aPoint.y-halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x-halfSize, aPoint.y+halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y+halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y-halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x-halfSize, aPoint.y-halfSize);
            CGContextDrawPath(aContext, kCGPathStroke);                
            break;            
        case kSymbolDiamond:
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext, aPoint.x-halfSize, aPoint.y);
            CGContextAddLineToPoint(aContext, aPoint.x, aPoint.y-halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y);
            CGContextAddLineToPoint(aContext, aPoint.x, aPoint.y+halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x-halfSize, aPoint.y);
            CGContextFillPath(aContext);
            break;
        case kSymbolTriangleUp:
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext, aPoint.x, aPoint.y-halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x-halfSize, aPoint.y+halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y+halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x, aPoint.y-halfSize);
            CGContextFillPath(aContext);                
            break;
        case kSymbolTriangleDown:
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext, aPoint.x, aPoint.y+halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x-halfSize, aPoint.y-halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y-halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x, aPoint.y+halfSize);
            CGContextFillPath(aContext);                
            break;
        case kSymbolTriangleLeft:
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext, aPoint.x-halfSize, aPoint.y);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y-halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y+halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x-halfSize, aPoint.y);
            CGContextFillPath(aContext);                
            break;
        case kSymbolTriangleRight:
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext, aPoint.x+halfSize, aPoint.y);
            CGContextAddLineToPoint(aContext, aPoint.x-halfSize, aPoint.y-halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x-halfSize, aPoint.y+halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y);
            CGContextFillPath(aContext);                
            break;
        case kSymbolPlus:
            CGContextSetLineWidth(aContext, halfSize/5.0);
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext, aPoint.x-halfSize, aPoint.y);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y);
            CGContextMoveToPoint(aContext, aPoint.x, aPoint.y+halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x, aPoint.y-halfSize);
            CGContextDrawPath(aContext, kCGPathStroke);                
            break;
        case kSymbolX:
            CGContextSetLineWidth(aContext, halfSize/5.0);
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext, aPoint.x-halfSize, aPoint.y-halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y+halfSize);
            CGContextMoveToPoint(aContext, aPoint.x-halfSize, aPoint.y+halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y-halfSize);
            CGContextDrawPath(aContext, kCGPathStroke);                
            break;
        case kSymbolStar:
            CGContextSetLineWidth(aContext, halfSize/5.0);
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext, aPoint.x-halfSize, aPoint.y);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y);
            CGContextMoveToPoint(aContext, aPoint.x, aPoint.y+halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x, aPoint.y-halfSize);
            CGContextMoveToPoint(aContext, aPoint.x-halfSize, aPoint.y-halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y+halfSize);
            CGContextMoveToPoint(aContext, aPoint.x-halfSize, aPoint.y+halfSize);
            CGContextAddLineToPoint(aContext, aPoint.x+halfSize, aPoint.y-halfSize);
            CGContextDrawPath(aContext, kCGPathStroke);                
            break;
        default:
            break;
    }
    
    /* Restore the graphics context. */
    CGContextRestoreGState(aContext);
}

