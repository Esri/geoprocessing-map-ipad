///
///  @file
///  WSData.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 24.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSData.h"
#import "WSDatum.h"


/// Manual KVO notifications for the 'values' property.
#define KVO_VALUES @"values"
#define KVO_DATUM @"datum"

/// Methods for data bindings support.
@interface WSData ()

/** Add a single instance of WSDatum to KVO. */
- (void)observeDatum:(WSDatum *)datum;

/** Remove a single instance of WSDatum from KVO. */
- (void)removeObserveDatum:(WSDatum *)datum;

/** Register all instances of WSDatum in the values array to KVO. */
- (void)observeAllValues;

/** Deregister all instances of WSDatum in the values array from KVO. */
- (void)removeObserveAllValues;
   
@end


@implementation WSData

@synthesize nameTag = _nameTag;


+ (NSArray *)arrayOfZerosWithLen:(NSUInteger)len {
    NSNumber *zero = [NSNumber numberWithFloat:0.0];
    NSMutableArray *tmpArr = [NSMutableArray
                              arrayWithCapacity:len];
    NSUInteger i;
    
    for (i=0; i<len; i++) {
        [tmpArr addObject:zero];
    }
    return [NSArray arrayWithArray:tmpArr];
}

+ (NSArray *)arrayWithFloat:(float[])floats
                        len:(NSUInteger)len {
    NSMutableArray *tmpArr = [NSMutableArray
                              arrayWithCapacity:len];
    NSUInteger i;
    
    for (i=0; i<len; i++) {
        [tmpArr addObject:[NSNumber numberWithFloat:floats[i]]];
    }
    return [NSArray arrayWithArray:tmpArr];
}

+ (NSArray *)arrayWithString:(NSString *[])strings
                         len:(NSUInteger)len {
    NSMutableArray *tmpArr = [NSMutableArray
                              arrayWithCapacity:len];
    NSUInteger i;
    
    for (i=0; i<len; i++) {
        [tmpArr addObject:strings[i]];
    }
    return [NSArray arrayWithArray:tmpArr];
}

+ (id)data {
    return [[self alloc] init] ;
}

+ (id)dataWithValues:(NSArray *)vals {
    return [[self alloc] initWithValues:vals]
            ;
}

+ (id)dataWithValues:(NSArray *)vals
         annotations:(NSArray *)annos {
    return [[self alloc] initWithValues:vals
                             annotations:annos]
            ;
}

+ (id)dataWithValues:(NSArray *)vals
             valuesX:(NSArray *)valsX {
    return [[self alloc] initWithValues:vals
                                 valuesX:valsX]
            ;
}

+ (id)dataWithValues:(NSArray *)vals
             valuesX:(NSArray *)valsX
         annotations:(NSArray *)annos {
    return [[self alloc] initWithValues:vals
                                 valuesX:valsX
                             annotations:annos]
            ;
}

+ (id)dataWithValues:(NSArray *)vals
             valuesX:(NSArray *)valsX
           errorMinY:(NSArray *)errMinY
           errorMaxY:(NSArray *)errMaxY
           errorMinX:(NSArray *)errMinX
           errorMaxX:(NSArray *)errMaxX {
    return [[self alloc] initWithValues:vals
                                 valuesX:valsX
                               errorMinY:errMinY
                               errorMaxY:errMaxY
                               errorMinX:errMinX
                               errorMaxX:errMaxX]
            ;
}

- (WSData *)sortedDataUsingValueX {
    WSData *sorted = [[WSData alloc] init];
    [sorted setNameTag:[self nameTag]];
    [sorted setValues:[[NSMutableArray alloc] initWithArray:[self values]
                                                    copyItems:NO]
                       ];
    [sorted sortDataUsingValueX];
    return sorted;
}

- (WSData *)indexedData {
    NSUInteger i;
    WSData *indexed = [[WSData alloc] init];
    
    [indexed setNameTag:[self nameTag]];
    [indexed setValues:[[NSMutableArray alloc] initWithArray:[self values]
                                                    copyItems:NO]
                        ];
    for (i=0; i<[indexed count]; i++) {
        [[indexed datumAtIndex:i] setValueX:(NAFloat)i];
    }
    return indexed ;
}

- (id)init {
    return [self initWithValues:[NSArray array]];
}

- (id)initWithValues:(NSArray *)vals {
    return [self initWithValues:vals
                        valuesX:[WSData arrayOfZerosWithLen:[vals count]]];
}

- (id)initWithValues:(NSArray *)vals
         annotations:(NSArray *)annos {
    NSUInteger i;
    
    if ([vals count] != [annos count]) {
        NSException *countExcpt = [NSException
                                   exceptionWithName:[NSString
                                                      stringWithFormat:@"USER ERROR <%@>",
                                                      [self class]]
                                   reason:@"vals-annos conflict"
                                   userInfo:[NSDictionary
                                             dictionaryWithObjectsAndKeys:[NSNumber 
                                                                           numberWithInt:[vals count]],
                                             @"vals_count",
                                             [NSNumber numberWithInt:[vals count]],
                                             @"annos_count",
                                             [NSNumber numberWithInt:[annos count]],
                                             nil]];
        @throw countExcpt;        
    }
    self = [super init];
    if (self) {
        [self setNameTag:@""];
        [self setValues:[NSMutableArray arrayWithCapacity:[vals count]]];
        
        for (i=0; i<[vals count]; i++) {
            WSDatum *tmp = [WSDatum datumWithValue:[[vals objectAtIndex:i]
                                                    floatValue]
                                    annotation:[annos objectAtIndex:i]];
            [[self values] addObject:tmp];
            [self observeDatum:tmp];
        }
    }
    return self;
}

- (id)initWithValues:(NSArray *)vals
             valuesX:(NSArray *)valsX {
    NSArray *empty = [NSArray array];
    
    return [self initWithValues:vals
                        valuesX:valsX
                      errorMinY:empty
                      errorMaxY:empty
                      errorMinX:empty
                      errorMaxX:empty];
}

- (id)initWithValues:(NSArray *)vals
             valuesX:(NSArray *)valsX
         annotations:(NSArray *)annos {
    NSUInteger i;
    
    if (([vals count] != [valsX count]) ||
        ([vals count] != [annos count])) {
        NSException *countExcpt = [NSException
                                   exceptionWithName:[NSString
                                                      stringWithFormat:@"USER ERROR <%@>",
                                                      [self class]]
                                   reason:@"vals-valsX-annos conflict"
                                   userInfo:[NSDictionary
                                             dictionaryWithObjectsAndKeys:[NSNumber 
                                                                           numberWithInt:[vals count]],
                                             @"vals_count",
                                             [NSNumber numberWithInt:[vals count]],
                                             @"valsX_count",
                                             [NSNumber numberWithInt:[valsX count]],
                                             @"annos_count",
                                             [NSNumber numberWithInt:[annos count]],
                                             nil]];
        @throw countExcpt;        
    }
    self = [self initWithValues:vals
                        valuesX:valsX];
    if (self) {
        
        for (i=0; i<[annos count]; i++) {
            WSDatum *tmp = [[self values] objectAtIndex:i];
            [tmp setAnnotation:[annos objectAtIndex:i]];
        }
    }
    return self;    
}

- (id)initWithValues:(NSArray *)vals
             valuesX:(NSArray *)valsX
           errorMinY:(NSArray *)errMinY
           errorMaxY:(NSArray *)errMaxY
           errorMinX:(NSArray *)errMinX
           errorMaxX:(NSArray *)errMaxX {
    NSUInteger i;
    NSUInteger len;

    // This methods needs both Y and X values; there have to be equal numbers!
    len = [vals count];
    if ([valsX count] != len) {
        NSException *countExcpt = [NSException
                                   exceptionWithName:[NSString
                                                      stringWithFormat:@"USER ERROR <%@>",
                                                      [self class]]
                                   reason:@"vals-valsX conflict"
                                   userInfo:[NSDictionary
                                             dictionaryWithObjectsAndKeys:[NSNumber
                                                                           numberWithInt:len],
                                             @"vals_count",
                                             [NSNumber numberWithInt:[valsX count]],
                                             @"valsX_count",
                                             nil]];
        @throw countExcpt;
    }
    
    // Furthermore, if uncertainties are provided, the numbers have to match, too.
    if ([errMinY count] > 0) {
        if ([errMinY count] != len) {
            NSException *countExcpt = [NSException
                                       exceptionWithName:[NSString
                                                          stringWithFormat:@"USER ERROR <%@>",
                                                          [self class]]
                                       reason:@"errMinY-valsX conflict"
                                       userInfo:[NSDictionary
                                                 dictionaryWithObjectsAndKeys:[NSNumber 
                                                                               numberWithInt:len],
                                                 @"vals_count",
                                                 [NSNumber numberWithInt:[errMinY count]],
                                                 @"errMinY_count",
                                                 nil]];
            @throw countExcpt;
        }
    }
    if ([errMinX count] > 0) {
        if ([errMinX count] != len) {
            NSException *countExcpt = [NSException
                                       exceptionWithName:[NSString
                                                          stringWithFormat:@"USER ERROR <%@>",
                                                          [self class]]
                                       reason:@"errMinX-valsX conflict"
                                       userInfo:[NSDictionary
                                                 dictionaryWithObjectsAndKeys:[NSNumber 
                                                                               numberWithInt:len],
                                                 @"vals_count",
                                                 [NSNumber numberWithInt:[errMinY count]],
                                                 @"errMinX_count",
                                                 nil]];
            @throw countExcpt;            
        }
    }
    if ([errMaxY count] > 0) {
        if ([errMinY count] != len) {
            NSException *countExcpt = [NSException
                                        exceptionWithName:[NSString
                                                           stringWithFormat:@"USER ERROR <%@>",
                                                           [self class]]
                                        reason:@"errMinY-valsX conflict"
                                        userInfo:[NSDictionary
                                                    dictionaryWithObjectsAndKeys:[NSNumber 
                                                                                numberWithInt:len],
                                                    @"vals_count",
                                                    [NSNumber numberWithInt:[errMinY count]],
                                                    @"errMinY_count",
                                                    nil]];
            @throw countExcpt;
        }
        if ([errMaxY count] != len) {
            NSException *countExcpt = [NSException
                                       exceptionWithName:[NSString
                                                          stringWithFormat:@"USER ERROR <%@>",
                                                          [self class]]
                                       reason:@"errMaxY-valsX conflict"
                                       userInfo:[NSDictionary
                                                 dictionaryWithObjectsAndKeys:[NSNumber 
                                                                               numberWithInt:len],
                                                 @"vals_count",
                                                 [NSNumber numberWithInt:[errMaxY count]],
                                                 @"errMaxY_count",
                                                 nil]];
            @throw countExcpt;
        }
    }
    if ([errMaxX count] > 0) {
        if ([errMinX count] != len) {
            NSException *countExcpt = [NSException
                                       exceptionWithName:[NSString
                                                          stringWithFormat:@"USER ERROR <%@>",
                                                          [self class]]
                                       reason:@"errMinX-valsX conflict"
                                       userInfo:[NSDictionary
                                                 dictionaryWithObjectsAndKeys:[NSNumber 
                                                                               numberWithInt:len],
                                                 @"vals_count",
                                                 [NSNumber numberWithInt:[errMinX count]],
                                                 @"errMinX_count",
                                                 nil]];
            @throw countExcpt;
        }
        if ([errMaxX count] != len) {
            NSException *countExcpt = [NSException
                                       exceptionWithName:[NSString
                                                          stringWithFormat:@"USER ERROR <%@>",
                                                          [self class]]
                                       reason:@"errMaxX-valsX conflict"
                                       userInfo:[NSDictionary
                                                 dictionaryWithObjectsAndKeys:[NSNumber 
                                                                               numberWithInt:len],
                                                 @"vals_count",
                                                 [NSNumber numberWithInt:[errMaxX count]],
                                                 @"errMaxX_count",
                                                 nil]];
            @throw countExcpt;
        }
    }

    // It is evident that all uncertainties need to be positive numbers.
    for (i=0; i<[vals count]; i++) {
        if ([errMinY count] > 0 )
            NSParameterAssert([[errMinY objectAtIndex:i] floatValue] >= 0.0);
        if ([errMaxY count] > 0 )
            NSParameterAssert([[errMaxY objectAtIndex:i] floatValue] >= 0.0);
        if ([errMinX count] > 0 )
            NSParameterAssert([[errMinX objectAtIndex:i] floatValue] >= 0.0);
        if ([errMaxX count] > 0 )
            NSParameterAssert([[errMaxX objectAtIndex:i] floatValue] >= 0.0);
    }

    self = [super init];
    if (self) {
        [self setNameTag:@""];
        [self setValues:[NSMutableArray arrayWithCapacity:[vals count]]];
        
        // Fill in all values provided into the internal data structure.
        for (i=0; i<[vals count]; i++) {
            WSDatum *tmp = [WSDatum datumWithValue:[[vals objectAtIndex:i]
                                                    floatValue]
                                        valueX:[[valsX objectAtIndex:i]
                                                    floatValue]];
            if ([errMinY count] > 0) {
                [tmp setErrorMinY:[[errMinY objectAtIndex:i] floatValue]];
                if ([errMaxY count] > 0) {
                    [tmp setErrorMaxY:[[errMaxY objectAtIndex:i] floatValue]];
                } else {
                    [tmp setErrorMaxY:[[errMinY objectAtIndex:i] floatValue]];
                }
            }
            if ([errMinX count] > 0) {
                [tmp setErrorMinX:[[errMinX objectAtIndex:i] floatValue]];
                if ([errMaxX count] > 0) {
                    [tmp setErrorMaxX:[[errMaxX objectAtIndex:i] floatValue]];
                } else {
                    [tmp setErrorMaxX:[[errMinX objectAtIndex:i] floatValue]];
                }
            }
            [[self values] addObject:tmp];
            [self observeDatum:tmp];
        }
    }
    return self;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[self nameTag] forKey:@"name"];
    [encoder encodeObject:[self values] forKey:@"values"];
}

- initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        [self setNameTag:[decoder decodeObjectForKey:@"name"]];
        _values = [[decoder decodeObjectForKey:@"values"] mutableCopy];
        for (WSDatum *datum in _values) {
            [self observeDatum:datum];
        }
    }
    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WSData *copy = [[[self class] allocWithZone:zone] init];
    [copy setNameTag:[self nameTag]];
    [copy setValues:[[NSMutableArray alloc] initWithArray:[self values]
                                                 copyItems:YES]
                     ];
    return copy;
}


#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id *)stackbuf
                                    count:(NSUInteger)len {
    
    return [self values];
//    return [[self values] countByEnumeratingWithState:state 
//                                              objects:(__weak)stackbuf
//                                                count:len];
}


#pragma mark - KVO

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
    BOOL automatic = NO;
    
    if ([theKey isEqualToString:KVO_VALUES]) {
        automatic = NO;
    } else {
        automatic=[super automaticallyNotifiesObserversForKey:theKey];
    }
    return automatic;
}

- (void)observeDatum:(WSDatum *)datum {
    [datum addObserver:self
            forKeyPath:KVO_DATUM
               options:0
               context:NULL];
}

- (void)removeObserveDatum:(WSDatum *)datum {
    [datum removeObserver:self
               forKeyPath:KVO_DATUM];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (([keyPath isEqualToString:KVO_DATUM]) &&
        ([object isKindOfClass:[WSDatum class]])) {
        [self willChangeValueForKey:KVO_VALUES];
        [self didChangeValueForKey:KVO_VALUES];
    }
}

- (void)observeAllValues {
    for (WSDatum *datum in [self values]) {
        [self observeDatum:datum];
    }
}

- (void)removeObserveAllValues {
    for (WSDatum *datum in [self values]) {
        [self removeObserveDatum:datum];
    }
}

- (void)setValues:(NSMutableArray *)values {
    @synchronized(self) {
        [self willChangeValueForKey:KVO_VALUES];
        [self removeObserveAllValues];
        
        _values = values;
        [self observeAllValues];
        [self didChangeValueForKey:KVO_VALUES];
    }
}

- (NSMutableArray *)values {
        return _values;
}


#pragma mark -

- (void)sortDataUsingValueX {
    [self willChangeValueForKey:KVO_VALUES];
    [self setValues:[NSMutableArray
                     arrayWithArray:[[self values]
                                     sortedArrayUsingSelector:@selector(valueXCompare:)]]];
    [self didChangeValueForKey:KVO_VALUES];
}

- (void)addDatum:(WSDatum *)aDatum {
    [self willChangeValueForKey:KVO_VALUES];
    [self observeDatum:aDatum];
    [[self values] addObject:aDatum];
    [self didChangeValueForKey:KVO_VALUES];
}

- (void)insertDatum:(WSDatum *)aDatum
            atIndex:(NSUInteger)index {
    [self willChangeValueForKey:KVO_VALUES];
    [self observeDatum:aDatum];
    [[self values] insertObject:aDatum
                        atIndex:index];
    [self didChangeValueForKey:KVO_VALUES];
}

- (void)replaceDatumAtIndex:(NSUInteger)index
                  withDatum:(WSDatum *)aDatum {
    [self willChangeValueForKey:KVO_VALUES];
    [self removeObserveDatum:[[self values] objectAtIndex:index]];
    [self observeDatum:aDatum];
    [[self values] replaceObjectAtIndex:index
                             withObject:aDatum];
    [self didChangeValueForKey:KVO_VALUES];
}

- (void)removeAllData {
    [self willChangeValueForKey:KVO_VALUES];
    for (WSDatum *datum in [self values]) {
        [self removeObserveDatum:datum];
    }
    [[self values] removeAllObjects];
    [self didChangeValueForKey:KVO_VALUES];
}

- (void)removeDatumAtIndex:(NSUInteger)index {
    [self willChangeValueForKey:KVO_VALUES];
    [self removeObserveDatum:[[self values] objectAtIndex:index]];
    [[self values] removeObjectAtIndex:index];
    [self didChangeValueForKey:KVO_VALUES];
}

- (NSArray *)valuesWithSelector:(SEL)extractor {
    return [self valueForKeyPath:[NSString stringWithFormat:@"values.%@",
                                  NSStringFromSelector(extractor)]];
}

- (NSArray *)valuesFromDataX {
    return [self valuesWithSelector:@selector(valueX)];
}

- (NSArray *)valuesFromDataY {
    return [self valuesWithSelector:@selector(valueY)];
}

- (NSArray *)annotationsFromData {
    return [self valuesWithSelector:@selector(annotation)];
}

- (NSArray *)customFromData {
    return [self valuesWithSelector:@selector(customDatum)];
}

- (NAFloat)minimumValue {
    NAFloat retVal = NAN;
    
    if ([self count] > 0) {
        retVal = [[self datumAtIndex:0] value];
        for (WSDatum *item in [self values]) {
            retVal = fmin(retVal, [item value]);
        }
    }
    return retVal;
}

- (NAFloat)minimumValueY {
    return [self minimumValue];
}

- (NAFloat)maximumValue {
    NAFloat retVal = NAN;
    
    if ([self count] > 0) {
        retVal = [[self datumAtIndex:0] value];
        for (WSDatum *item in [self values]) {
            retVal = fmax(retVal, [item value]);
        }
    }
    return retVal;
}

- (NAFloat)maximumValueY {
    return [self maximumValue];
}

- (NAFloat)minimumValueX {
    NAFloat retVal = NAN;
    
    if ([self count] > 0) {
        retVal = [[[self values] objectAtIndex:0]
                    valueX];
        for (WSDatum *item in [self values]) {
            retVal = fmin(retVal, [item valueX]);
        }
    }
    return retVal;
}

- (NAFloat)maximumValueX {
    NAFloat retVal = NAN;
    
    if ([self count] > 0) {
        retVal = [[[self values] objectAtIndex:0]
                   valueX];
        for (WSDatum *item in [self values]) {
            retVal = fmax(retVal, [item valueX]);
        }
    }
    return retVal;
}

- (NAFloat)integrateValue {
    NAFloat retVal = 0.0;
    
    for (WSDatum *item in [self values]) {
        retVal += [item value];
    }
    return retVal;
}

- (NSUInteger)count {
    return [[self values] count];
}

- (NSUInteger)indexOfDatum:(WSDatum *)datum {
    return [[self values] indexOfObject:datum];
}

- (WSDatum *)datumAtIndex:(NSUInteger)index {
    return [[self values] objectAtIndex:index];
}

- (NAFloat)valueXAtIndex:(NSUInteger)index {
    return [[self datumAtIndex:index] valueX];
}

- (NAFloat)valueAtIndex:(NSUInteger)index {
    return [[self datumAtIndex:index] value];
}

- (WSDatum *)leftMostDatum {
    WSDatum *retVal = nil;
    NAFloat minValX = NAN;
    
    // Don't do anything when the data set is empty.
    if ([[self values] count] > 0) {
        retVal = [self datumAtIndex:0];
        minValX = [retVal valueX];
        for (WSDatum *item in [self values]) {
            NAFloat currentValX = [item valueX];
            if (currentValX < minValX) {
                minValX = currentValX;
                retVal = item;
            }
        }
    }
    return retVal;
}

- (WSDatum *)rightMostDatum {
    WSDatum *retVal = nil;
    NAFloat maxValX = NAN;
    
    // Don't do anything when the data set is empty.
    if ([[self values] count] > 0) {
        retVal = [self datumAtIndex:0];
        maxValX = [retVal valueX];
        for (WSDatum *item in [self values]) {
            NAFloat currentValX = [item valueX];
            if (currentValX > maxValX) {
                maxValX = currentValX;
                retVal = item;
            }
        }
    }
    return retVal;
}


#pragma mark -

- (NSString *)description {
    const NSUInteger descLen = 5;
    NSUInteger num = [self count];
    NSMutableString *prtCont = [NSMutableString stringWithString:@"["];
    
    NSUInteger i;
    // Iterate over all data points.
    for (i=0; i<num; i++) {
        // Print the contents of the first "descLen" points.
        if (i < descLen) {
            NSDictionary *tmpDict = (NSDictionary *)[[[self values]
                                                      objectAtIndex:i] datum];
            NSString *anno = [tmpDict valueForKey:@"annotation"];
            NSNumber *valX = [tmpDict valueForKey:@"valueX"];
            NSNumber *erriY = [tmpDict valueForKey:@"errorMinY"];
            NSNumber *erraY = [tmpDict valueForKey:@"errorMaxY"];
            NSNumber *erriX = [tmpDict valueForKey:@"errorMinX"];
            NSNumber *erraX = [tmpDict valueForKey:@"errorMaxX"];
            // If there is an X-value, print it. If it has an
            // uncertainty, append "+"; for uncertainties in both
            // directions, prepend "+-".
            if (valX) {
                [prtCont appendFormat:@"(%f", [valX floatValue]];
                if (erraX) {
                    [prtCont appendString:@"+"];
                    if ([erriX floatValue] != [erraX floatValue]) {
                        [prtCont appendString:@"-"];
                    }
                }
                [prtCont appendString:@","];
            }
            // There always is a Y-value (at least it *should*). For
            // the uncertainty, proceed as before.
            [prtCont appendFormat:@"%f", [[tmpDict valueForKey:@"value"]
                                          floatValue]];
            if (erraY) {
                [prtCont appendString:@"+"];
                if ([erriY floatValue] != [erraY floatValue]) {
                    [prtCont appendString:@"-"];
                }
            }
            if (valX) {
                [prtCont appendString:@")"];
            }
            // Add an annotation if present.
            if (anno) {
                [prtCont appendFormat:@"{%@}", anno];
            }
            [prtCont appendString:@","];
        }
    }
    if (num > descLen) {
        [prtCont appendString:@"...,nil]"];
    } else
        [prtCont appendString:@"nil]"];

    return [NSString stringWithFormat:@"%@ of length %i, content: %@.",
            [self class], [self count], prtCont];
}



@end
