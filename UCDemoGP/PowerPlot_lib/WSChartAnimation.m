///
///  @file
///  WSChartAnimation.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 11/7/11.
///  Copyright (c) 2011 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSChartAnimation.h"
#import "WSChartAnimationKeys.h"
#import "WSPlotController.h"
#import "WSData.h"
#import "WSDataOperations.h"
#import "WSDatum.h"
#import "WSCoordinate.h"


#ifdef __IPHONE_4_0

/// Helper method for animation.
@interface WSChart (WSChartAnimationHelper)

/** Return the ease in/out helper function, maps [0,1] -> [0,1].
 
    With PowerPlot v1.4 the default is now the "smoothstep" function
    (see, e.g. http://en.wikipedia.org/wiki/Smoothstep ).
    Alternatively, the previous function and the Ken Perlin "smootherstep"
    functions are available by defining SMOOTHSTEP_EXP or
    SMOOTHSTEP_PERLIN, respectively. */
+ (NAFloat)easeInOutHelper:(NAFloat)x;
// #define SMOOTHSTEP_EXP
// #define SMOOTHSTEP_PERLIN

@end


@implementation WSChart (WSChartAnimation)

- (void)dataAnimateWithDuration:(NSTimeInterval)duration
                          delay:(NSTimeInterval)delay
                        options:(WSChartAnimationOptions)options
                     animations:(void (^)(void))animations
                        context:(id)context
                         update:(void (^)(NAFloat, id))update
                     completion:(void (^)(BOOL))completion {
    
    // Verify that we have an animations block.
    NSAssert(animations != nil, @"Animations block must not be nil!");
    NSAssert(self.animationTimer == nil, @"Multiple animations initialized!");
    
    // Set up the information for the animation.
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:12];
    if (update != nil) {
        void (^updateHandlerCopy)(NAFloat, id) =  update;
        [userInfo setValue:context forKey:WSUI_CONTEXT_KEY];
        [userInfo setObject:updateHandlerCopy forKey:WSUI_CONTEXT_CUSTOM];
    }
    if (completion != nil) {
        void (^completionHandlerCopy)(BOOL) = completion;
        [userInfo setObject:completionHandlerCopy forKey:WSUI_COMPLETION];
    }
    [userInfo setValue:[NSNumber numberWithInt:options]
                forKey:WSUI_OPTIONS];
    [userInfo setObject:[NSNumber numberWithInt:0]
                 forKey:WSUI_ITERATION];
    [userInfo setObject:[NSNumber numberWithDouble:duration]
                 forKey:WSUI_DURATION];
    
    /// Store the old and the new animatable properties.
    NSMutableArray *oldData = [NSMutableArray arrayWithCapacity:[self count]];
    NSMutableArray *oldCoordX = [NSMutableArray arrayWithCapacity:[self count]];
    NSMutableArray *oldCoordY = [NSMutableArray arrayWithCapacity:[self count]];
    NSMutableArray *newData = [NSMutableArray arrayWithCapacity:[self count]];
    NSMutableArray *newCoordX = [NSMutableArray arrayWithCapacity:[self count]];
    NSMutableArray *newCoordY = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSUInteger i=0; i<[self count]; i++) {
        WSPlotController *currentCtrl = [self plotAtIndex:i];
        WSCoordinate *coordX = [currentCtrl coordX];
        WSCoordinate *coordY = [currentCtrl coordY];
        [oldData addObject:[[currentCtrl dataD] copy] ];
        [oldCoordX addObject:[NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:[coordX coordRangeD].rMin],
                              [NSNumber numberWithFloat:[coordX coordRangeD].rMax],
                              [NSNumber numberWithFloat:[coordX coordOrigin]],
                              nil]];
        [oldCoordY addObject:[NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:[coordY coordRangeD].rMin],
                              [NSNumber numberWithFloat:[coordY coordRangeD].rMax],
                              [NSNumber numberWithFloat:[coordY coordOrigin]],
                              nil]];
    }
    animations();
    for (NSUInteger i=0; i<[self count]; i++) {
        WSPlotController *currentCtrl = [self plotAtIndex:i];
        WSCoordinate *coordX = [currentCtrl coordX];
        WSCoordinate *coordY = [currentCtrl coordY];
        [newData addObject:[[currentCtrl dataD] copy] ];
        NSAssert([((NSArray *)[newData lastObject]) count] == [((NSArray *)[oldData objectAtIndex:i]) count],
                 @"Length of data object changed during animation!");
        [newCoordX addObject:[NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:[coordX coordRangeD].rMin],
                              [NSNumber numberWithFloat:[coordX coordRangeD].rMax],
                              [NSNumber numberWithFloat:[coordX coordOrigin]],
                              nil]];
        [newCoordY addObject:[NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:[coordY coordRangeD].rMin],
                              [NSNumber numberWithFloat:[coordY coordRangeD].rMax],
                              [NSNumber numberWithFloat:[coordY coordOrigin]],
                              nil]];
    }
    [userInfo setValue:oldData forKey:WSUI_OLDDATA];
    [userInfo setValue:oldCoordX forKey:WSUI_OLDCOORDINATEX];
    [userInfo setValue:oldCoordY forKey:WSUI_OLDCOORDINATEY];
    [userInfo setValue:newData forKey:WSUI_NEWDATA];
    [userInfo setValue:newCoordX forKey:WSUI_NEWCOORDINATEX];
    [userInfo setValue:newCoordY forKey:WSUI_NEWCOORDINATEY];
    
    // Restore the former settings.
    for (NSUInteger i=0; i<[self count]; i++) {
        WSPlotController *currentCtrl = [self plotAtIndex:i];
        [currentCtrl setDataD:[oldData objectAtIndex:i]];
        NSArray *oldCX = [oldCoordX objectAtIndex:i];
        NSArray *oldCY = [oldCoordY objectAtIndex:i];
        [[currentCtrl coordX] setCoordRangeD:NARangeMake([[oldCX objectAtIndex:0] floatValue],
                                                         [[oldCX objectAtIndex:1] floatValue])];
        [[currentCtrl coordX] setCoordOrigin:[[oldCX objectAtIndex:2] floatValue]];
        [[currentCtrl coordY] setCoordRangeD:NARangeMake([[oldCY objectAtIndex:0] floatValue],
                                                         [[oldCY objectAtIndex:1] floatValue])];
        [[currentCtrl coordY] setCoordOrigin:[[oldCY objectAtIndex:2] floatValue]];
    }
    
    // Set up the animation timer.
    [self setAnimationTimer:[NSTimer scheduledTimerWithTimeInterval:delay
                                                             target:self
                                                           selector:@selector(dataBeginAnimation:)
                                                           userInfo:userInfo
                                                            repeats:NO]];
}

- (void)dataAnimateWithDuration:(NSTimeInterval)duration
                          delay:(NSTimeInterval)delay
                        options:(WSChartAnimationOptions)options
                     animations:(void (^)(void))animations
                     completion:(void (^)(BOOL))completion {
    [self dataAnimateWithDuration:duration
                            delay:delay
                          options:options
                       animations:animations
                          context:nil
                           update:NULL
                       completion:completion];
}

- (void)dataAnimateWithDuration:(NSTimeInterval)duration
                     animations:(void (^)(void))animations
                     completion:(void (^)(BOOL))completion {
    [self dataAnimateWithDuration:duration
                            delay:0.
                          options:kWSChartAnimationOptionCurveEaseInOut
                       animations:animations
                       completion:completion];
}

- (void)dataAnimateWithDuration:(NSTimeInterval)duration
                     animations:(void (^)(void))animations {
    [self dataAnimateWithDuration:duration
                       animations:animations
                       completion:NULL];
}

- (void)dataBeginAnimation:(NSTimer *)aTimer {
    NSTimeInterval interval = 1./kWSChartAnimationFPS;
    [self setAnimationTimer:[NSTimer scheduledTimerWithTimeInterval:interval
                                                             target:self
                                                           selector:@selector(dataUpdateAnimation:)
                                                           userInfo:aTimer.userInfo
                                                            repeats:YES]];
}

- (void)dataUpdateAnimation:(NSTimer *)aTimer {
    BOOL final = NO;
    
    // Get options and parameters from dictionary userInfo.
    NSMutableDictionary *userInfo = (NSMutableDictionary *)aTimer.userInfo;
    NSInteger iteration = [(NSNumber *)[userInfo objectForKey:WSUI_ITERATION]
                           intValue];
    NAFloat duration = [(NSNumber *)[userInfo objectForKey:WSUI_DURATION]
                        floatValue];
    WSChartAnimationOptions options = [(NSNumber *)[userInfo objectForKey:WSUI_OPTIONS]
                                       intValue];
    NAFloat progress = [WSChart progressionAtIteration:(NAFloat)iteration
                                              duration:duration
                                               options:options];
    void (^updateHandlerCopy)(NAFloat, id);
    updateHandlerCopy = [userInfo objectForKey:WSUI_CONTEXT_CUSTOM];
    
    // Update iteration, check current progress, end animation if necessary.
    iteration++;
    [(NSMutableDictionary *)aTimer.userInfo setObject:[NSNumber numberWithInt:iteration]
                                               forKey:WSUI_ITERATION];
    if (iteration >= floor(duration*kWSChartAnimationFPS)) {
        final = YES;
        progress = 1.;
    }
    
    // Perform chart update.
    NSArray *oldSet = [userInfo objectForKey:WSUI_OLDDATA];
    NSArray *newSet = [userInfo objectForKey:WSUI_NEWDATA];
    for (NSUInteger i=0; i<[oldSet count]; i++) {
        WSData *cData = [WSData data:[NSArray arrayWithObjects:
                                      [oldSet objectAtIndex:i],
                                      [newSet objectAtIndex:i],   
                                      nil]
                                 map:^WSDatum *(const id args) {
                                     WSDatum *oldDatum = [args objectAtIndex:0];
                                     WSDatum *newDatum = [args objectAtIndex:1];
                                     WSDatum *currentDatum = [WSDatum datum];
                                     NAFloat valX = ([oldDatum valueX] + progress * ([newDatum valueX] - [oldDatum valueX]));
                                     NAFloat valY = ([oldDatum valueY] + progress * ([newDatum valueY] - [oldDatum valueY]));
                                     
                                     [currentDatum setValue:valY];
                                     [currentDatum setValueX:valX];
                                     if ([newDatum hasErrorX]) {
                                         NAFloat errorMinX = ([oldDatum errorMinX] + progress * ([newDatum errorMinX] - [oldDatum errorMinX]));
                                         NAFloat errorMaxX = ([oldDatum errorMaxX] + progress * ([newDatum errorMaxX] - [oldDatum errorMaxX]));
                                         [currentDatum setErrorMinX:errorMinX];
                                         [currentDatum setErrorMaxX:errorMaxX];
                                     }
                                     if ([newDatum hasErrorY]) {
                                         NAFloat errorMinY = ([oldDatum errorMinY] + progress * ([newDatum errorMinY] - [oldDatum errorMinY]));
                                         NAFloat errorMaxY = ([oldDatum errorMaxY] + progress * ([newDatum errorMaxY] - [oldDatum errorMaxY]));
                                         [currentDatum setErrorMinY:errorMinY];
                                         [currentDatum setErrorMaxY:errorMaxY];
                                     }
                                     if ([newDatum hasErrorX] && [newDatum hasErrorY]) {
                                         NAFloat errorCorr = ([oldDatum errorCorr] + progress * ([newDatum errorCorr] - [oldDatum errorCorr]));
                                         [currentDatum setErrorCorr:errorCorr];
                                     }
                                     
                                     if ([newDatum annotation]) {
                                         [currentDatum setAnnotation:[newDatum annotation]];
                                     }
                                     return currentDatum;
                                 }];
        
        NSArray *oldCoordX = [[userInfo objectForKey:WSUI_OLDCOORDINATEX] objectAtIndex:i];
        NSArray *newCoordX = [[userInfo objectForKey:WSUI_NEWCOORDINATEX] objectAtIndex:i];
        NSArray *oldCoordY = [[userInfo objectForKey:WSUI_OLDCOORDINATEY] objectAtIndex:i];
        NSArray *newCoordY = [[userInfo objectForKey:WSUI_NEWCOORDINATEY] objectAtIndex:i];
        
        NAFloat oldXrMin = [(NSNumber *)[oldCoordX objectAtIndex:0] floatValue];
        NAFloat oldXrMax = [(NSNumber *)[oldCoordX objectAtIndex:1] floatValue];
        NAFloat oldXOrig = [(NSNumber *)[oldCoordX objectAtIndex:2] floatValue];
        NAFloat newXrMin = [(NSNumber *)[newCoordX objectAtIndex:0] floatValue];
        NAFloat newXrMax = [(NSNumber *)[newCoordX objectAtIndex:1] floatValue];
        NAFloat newXOrig = [(NSNumber *)[newCoordX objectAtIndex:2] floatValue];
        
        NAFloat cCoordXrMin = oldXrMin + progress * (newXrMin - oldXrMin);
        NAFloat cCoordXrMax = oldXrMax + progress * (newXrMax - oldXrMax);
        NAFloat cCoordXOrig = oldXOrig + progress * (newXOrig - oldXOrig);
        
        NAFloat oldYrMin = [(NSNumber *)[oldCoordY objectAtIndex:0] floatValue];
        NAFloat oldYrMax = [(NSNumber *)[oldCoordY objectAtIndex:1] floatValue];
        NAFloat oldYOrig = [(NSNumber *)[oldCoordY objectAtIndex:2] floatValue];
        NAFloat newYrMin = [(NSNumber *)[newCoordY objectAtIndex:0] floatValue];
        NAFloat newYrMax = [(NSNumber *)[newCoordY objectAtIndex:1] floatValue];
        NAFloat newYOrig = [(NSNumber *)[newCoordY objectAtIndex:2] floatValue];
        
        NAFloat cCoordYrMin = oldYrMin + progress * (newYrMin - oldYrMin);
        NAFloat cCoordYrMax = oldYrMax + progress * (newYrMax - oldYrMax);
        NAFloat cCoordYOrig = oldYOrig + progress * (newYOrig - oldYOrig);
        
        WSPlotController *cCtrl = [self plotAtIndex:i];
        [cCtrl setDataD:cData];
        [[cCtrl coordX] setCoordRangeD:NARangeMake(cCoordXrMin, cCoordXrMax)];
        [[cCtrl coordX] setCoordOrigin:cCoordXOrig];
        [[cCtrl coordY] setCoordRangeD:NARangeMake(cCoordYrMin, cCoordYrMax)];
        [[cCtrl coordY] setCoordOrigin:cCoordYOrig];
    }
    
    // Call the custom update handler (if present).
    if (updateHandlerCopy != nil) {
        id context = [userInfo valueForKey:WSUI_CONTEXT_KEY];
        updateHandlerCopy(progress, context);
    }
    
    if (final) {
        [self setAnimationTimer:nil];
        [aTimer invalidate];

        // Call the completion handler and release memory.
        void (^completionHandlerCopy)(BOOL);
        completionHandlerCopy = [userInfo objectForKey:WSUI_COMPLETION];
        if (completionHandlerCopy != nil) {
            completionHandlerCopy(YES);
            //Block_release(completionHandlerCopy);
        }
        if (updateHandlerCopy != nil) {
            //Block_release(updateHandlerCopy);
        }
    }
    
    // We are done. Flag display update and exit.
    [self setNeedsDisplay];
}

+ (NAFloat)progressionAtIteration:(NAFloat)iteration
                         duration:(NSTimeInterval)duration
                          options:(WSChartAnimationOptions)options {
    NAFloat progress = iteration/(duration * kWSChartAnimationFPS);
    
    switch (options) {
        case kWSChartAnimationOptionCurveNone:
            return 1.;
            break;
            
        case kWSChartAnimationOptionCurveEaseInOut:
            return [WSChart easeInOutHelper:progress];
            break;
            
        case kWSChartAnimationOptionCurveEaseIn:
            return 2.*[WSChart easeInOutHelper:(0.5*progress)];
            break;
            
        case kWSChartAnimationOptionCurveEaseOut:
            return 2.*([WSChart easeInOutHelper:(0.5*progress+0.5)]-0.5);
            break;
            
        case kWSChartAnimationOptionCurveLinear:
            return progress;
            break;
            
        default:
            break;
    }
}

+ (NAFloat)easeInOutHelper:(NAFloat)x {
#ifdef SMOOTHSTEP_EXP
    // Return the original PowerPlot exponential smoothstep function.
    return 0.5f*(1.f + tanhf(kWSChartAnimationSmooth *
                             (-1.f/x + 1.f/(1.f-x))));
#else
#ifdef SMOOTHSTEP_PERLIN
    // Return Kai Perlin's "smootherstep" polynomial function.
    return x*x*x*(x*(x*6.0f - 15.0f) + 10.0f);
#else
    // Return the standard "smoothstep" polynomial function.
    return x*x*(3.0f - 2.0f*x);
#endif
#endif
}

@end

#endif ///__IPHONE_4_0
