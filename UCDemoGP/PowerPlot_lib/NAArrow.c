/*
 *  NAArrow.c
 *  NuAS Amethyst Graphics System
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#include "NAArrow.h"
#include "NADashing.h"
#include "math.h"
#include "assert.h"


/** Definition of fixed arrow angle. */
const NAFloat kArrowAngle = M_PI/6.0;


/** @brief Draw a straight line with an arrow at the end.
 
    @param aContext Drawing context.
    @param arrowStyle Style of drawing the arrow.
    @param start Screen coordinates starting point.
    @param end Screen coordinates end point.
    @param headLen Length of the arrow head.
    @param lineWidth Width of the line and the arrow.
 */

void NAContextAddLineArrow(const CGContextRef aContext,
                           const NAArrowStyle arrowStyle,
                           const CGPoint start,
                           const CGPoint end,
                           const NAFloat headLen,
                           const NAFloat lineWidth) {

    assert(kArrowAngle < (M_PI/2.0));

    NAFloat arrLen = headLen / cos(kArrowAngle);
    NAFloat beta = atan2((end.y-start.y), (end.x-start.x));
    NAFloat delta = (M_PI/2.0 - beta - kArrowAngle);

        
    /* Save the current context. */
    CGContextSaveGState(aContext);
    
    /* Setup the line configuration. */
    CGContextSetLineWidth(aContext, lineWidth);
    CGContextSetLineJoin(aContext, kCGLineJoinMiter);
    CGContextSetLineCap(aContext, kCGLineCapSquare);
    NAContextSetLineDash(aContext, kDashingSolid);
    
    /* Draw the straight line, then append the head if necessary. */
    switch (arrowStyle) {
        case kArrowLineNone:
            break;
        case kArrowLinePlain:
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext, start.x, start.y);
            CGContextAddLineToPoint(aContext, end.x, end.y);
            CGContextDrawPath(aContext, kCGPathStroke);
            break;
        case kArrowLineArrow:
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext, start.x, start.y);
            NAFloat thickness = (lineWidth/sin(kArrowAngle) -
                                 lineWidth*sin(kArrowAngle));
            CGContextAddLineToPoint(aContext,
                                    end.x-thickness*cos(beta),
                                    end.y-thickness*sin(beta));
            CGContextMoveToPoint(aContext,
                                 end.x-arrLen*sin(delta),
                                 end.y-arrLen*cos(delta));
            CGContextAddLineToPoint(aContext, end.x, end.y);
            CGContextAddLineToPoint(aContext,
                                    end.x-arrLen*sin(delta+2.0*kArrowAngle),
                                    end.y-arrLen*cos(delta+2.0*kArrowAngle));      
            CGContextDrawPath(aContext, kCGPathStroke);
            break;
        case kArrowLineFilledHead:
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext, start.x, start.y);
            CGContextAddLineToPoint(aContext,
                                    end.x-headLen*cos(beta),
                                    end.y-headLen*sin(beta));
            CGContextDrawPath(aContext, kCGPathStroke);         
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext,
                                 end.x-arrLen*sin(delta),
                                 end.y-arrLen*cos(delta));
            CGContextAddLineToPoint(aContext, end.x, end.y);
            CGContextAddLineToPoint(aContext,
                                    end.x-arrLen*sin(delta+2.0*kArrowAngle),
                                    end.y-arrLen*cos(delta+2.0*kArrowAngle));        
            CGContextAddLineToPoint(aContext,
                                    end.x-arrLen*sin(delta),
                                    end.y-arrLen*cos(delta));
            CGContextDrawPath(aContext, kCGPathFill);
            break;
        default:
            break;
    }
    
    /* Save the context and return. */
    CGContextRestoreGState(aContext);
    return;
}

/** @brief Draw a straight line with an arrows at both ends.
 
    @param aContext Drawing context.
    @param arrowStyle Style of drawing the arrow.
    @param start Screen coordinates starting point.
    @param end Screen coordinates end point.
    @param headLen Length of the arrow head.
    @param lineWidth Width of the line and the arrow.
 */

void NAContextAddLineDoubleArrow(const CGContextRef aContext,
                                 const NAArrowStyle arrowStyle,
                                 const CGPoint start,
                                 const CGPoint end,
                                 const NAFloat headLen,
                                 const NAFloat lineWidth) {
    
    
    /* Check if we can use the plain arrow function for the job. */
    switch (arrowStyle) {
        case kArrowLineNone:
            return;
            break;
        case kArrowLinePlain:
            NAContextAddLineArrow(aContext, arrowStyle,
                                  start, end, headLen, lineWidth);
            return;
            break;
        default:
            break;
    }

    /* Otherwise, we have to work ourselves. */
    
    assert(kArrowAngle < (M_PI/2.0));
    
    NAFloat beta = atan2((end.y-start.y), (end.x-start.x));
    NAFloat arrLen = headLen / cos(kArrowAngle);
    NAFloat delta = (M_PI/2.0 - beta - kArrowAngle);
    NAFloat thickness = (lineWidth/sin(kArrowAngle) -
                         lineWidth*sin(kArrowAngle));
    CGPoint newStart, newEnd;

    
    /* Save the current context. */
    CGContextSaveGState(aContext);
    
    /* Setup the line configuration. */
    CGContextSetLineWidth(aContext, lineWidth);
    CGContextSetLineJoin(aContext, kCGLineJoinMiter);
    CGContextSetLineCap(aContext, kCGLineCapSquare);
    NAContextSetLineDash(aContext, kDashingSolid);
    
    /* Draw the line and the head. */
    switch (arrowStyle) {
        case kArrowLineArrow:
            CGContextBeginPath(aContext);
            CGPoint end2 = CGPointMake(end.x-0.5*thickness*cos(beta), 
                                       end.y-0.5*thickness*sin(beta));
            newEnd = CGPointMake(end2.x-thickness*cos(beta),
                                 end2.y-thickness*sin(beta));
            beta = atan2((start.y-end.y), (start.x-end.x));
            CGPoint start2 = CGPointMake(start.x-0.5*thickness*cos(beta), 
                                         start.y-0.5*thickness*sin(beta));
            newStart = CGPointMake(start2.x-thickness*cos(beta),
                                   start2.y-thickness*sin(beta));
            CGContextMoveToPoint(aContext, newStart.x, newStart.y);
            CGContextAddLineToPoint(aContext, newEnd.x, newEnd.y);
            CGContextMoveToPoint(aContext,
                                 end2.x-arrLen*sin(delta),
                                 end2.y-arrLen*cos(delta));
            CGContextAddLineToPoint(aContext, end2.x, end2.y);
            CGContextAddLineToPoint(aContext,
                                    end2.x-arrLen*sin(delta+2.0*kArrowAngle),
                                    end2.y-arrLen*cos(delta+2.0*kArrowAngle));   
            delta = (M_PI/2.0 - beta - kArrowAngle);
            CGContextMoveToPoint(aContext, 
                                 start2.x-arrLen*sin(delta), 
                                 start2.y-arrLen*cos(delta));
            CGContextAddLineToPoint(aContext, start2.x, start2.y);
            CGContextAddLineToPoint(aContext, 
                                    start2.x-arrLen*sin(delta+2.0*kArrowAngle), 
                                    start2.y-arrLen*cos(delta+2.0*kArrowAngle));
            CGContextDrawPath(aContext, kCGPathStroke);
            break;
        case kArrowLineFilledHead:
            CGContextBeginPath(aContext);
            newEnd = CGPointMake(end.x-headLen*cos(beta),
                                 end.y-headLen*sin(beta));
            beta = atan2((start.y-end.y), (start.x-end.x));
            newStart = CGPointMake(start.x-headLen*cos(beta),
                                   start.y-headLen*sin(beta));
            CGContextMoveToPoint(aContext, newStart.x, newStart.y);
            CGContextAddLineToPoint(aContext, newEnd.x, newEnd.y);
            CGContextDrawPath(aContext, kCGPathStroke);         
            CGContextBeginPath(aContext);
            CGContextMoveToPoint(aContext,
                                 end.x-arrLen*sin(delta),
                                 end.y-arrLen*cos(delta));
            CGContextAddLineToPoint(aContext, end.x, end.y);
            CGContextAddLineToPoint(aContext,
                                    end.x-arrLen*sin(delta+2.0*kArrowAngle),
                                    end.y-arrLen*cos(delta+2.0*kArrowAngle));        
            CGContextAddLineToPoint(aContext,
                                    end.x-arrLen*sin(delta),
                                    end.y-arrLen*cos(delta));
            delta = (M_PI/2.0 - beta - kArrowAngle);
            CGContextMoveToPoint(aContext,
                                 start.x-arrLen*sin(delta),
                                 start.y-arrLen*cos(delta));
            CGContextAddLineToPoint(aContext, start.x, start.y);
            CGContextAddLineToPoint(aContext,
                                    start.x-arrLen*sin(delta+2.0*kArrowAngle),
                                    start.y-arrLen*cos(delta+2.0*kArrowAngle));
            CGContextAddLineToPoint(aContext, 
                                    start.x-arrLen*sin(delta), 
                                    start.y-arrLen*cos(delta));
            CGContextDrawPath(aContext, kCGPathFill);
            break;
        default:
            break;
    }    
    
    /* Save the context and return. */
    CGContextRestoreGState(aContext);
    return;    
}

