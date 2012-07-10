///
///  @file
///  WSDatum.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 28.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSDatum.h"


/// Manual KVO notifications for the 'datum' property.
#define KVO_DATUM @"datum"

@implementation WSDatum {
    NAFloat _valueY;
    NAFloat _valueX;
    NSString *_annotation;
}

@synthesize datum = _datum;
@synthesize customDatum = _customDatum;
@synthesize delegate = _delegate;


+ (id)datum {
    return [[self alloc] init] ;
}

+ (id)datumWithValue:(NAFloat)aValue {
    return [[self alloc] initWithValue:aValue]
            ;
}

+ (id)datumWithValue:(NAFloat)aValue
          annotation:(NSString *)anno {
    return [[self alloc] initWithValue:aValue
                             annotation:anno]
            ;
}

+ (id)datumWithValue:(NAFloat)aValue
              valueX:(NAFloat)aValueX {
    return [[self alloc] initWithValue:aValue
                                 valueX:aValueX]
            ;
}

+ (id)datumWithValue:(NAFloat)aValue
              valueX:(NAFloat)aValueX
          annotation:(NSString *)anno {
    return [[self alloc] initWithValue:aValue
                                 valueX:aValueX
                             annotation:anno]
            ;
}

- (id)init {

    self = [super init];
    if (self) {
        _datum = [NSMutableDictionary dictionaryWithCapacity:0];
      
        _valueX = NAN;
        _valueY = NAN;
        _annotation = nil;
    }
    return self;
}

- (id)initWithValue:(NAFloat)aValue {

    self = [self init];
    if (self) {
        _valueY = aValue;
    }
    return self;
}

- (id)initWithValue:(NAFloat)aValue
         annotation:(NSString *)anno {

    self = [self initWithValue:aValue];
    if (self) {
        _annotation = [anno copy];
    }
    return self;
}

- (id)initWithValue:(NAFloat)aValue
             valueX:(NAFloat)aValueX {

    self = [self initWithValue:aValue];
    if (self) {
        _valueX = aValueX;
    }
    return self;
}

- (id)initWithValue:(NAFloat)aValue
             valueX:(NAFloat)aValueX
         annotation:(NSString *)anno {
    
    self = [self initWithValue:aValue
                        valueX:aValueX];
    if (self) {
        _annotation = [anno copy];
    }
    return self;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSMutableDictionary *datumDict = [_datum mutableCopy];
    [datumDict setObject:[NSNumber numberWithFloat:_valueY]
                  forKey:@"value"];
    if (!isnan(_valueX)) {
        [datumDict setObject:[NSNumber numberWithFloat:_valueX]
                      forKey:@"valueX"];
    }
    if (_annotation != nil) {
        [datumDict setObject:_annotation
                      forKey:@"annotation"];
    }
    [encoder encodeObject:datumDict forKey:@"datum"];
    [encoder encodeObject:[self customDatum] forKey:@"custom"];
   
}

- initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        NSDictionary *datumDict = [decoder decodeObjectForKey:@"datum"];
        _valueY = [[datumDict objectForKey:@"value"] floatValue];
        _datum = [datumDict mutableCopy];
        [_datum removeObjectForKey:@"value"];
        NSNumber *valueX = [_datum objectForKey:@"valueX"];
        if (valueX != nil) {
            _valueX = [valueX floatValue];
            [_datum removeObjectForKey:@"valueX"];
        } else {
            _valueX = NAN;
        }
        _annotation = [_datum objectForKey:@"annotation"];
        if (_annotation != nil) {
            [_datum removeObjectForKey:@"annotation"];
        }
        [self setCustomDatum:[decoder decodeObjectForKey:@"custom"]];
        [self setDelegate:nil];
    }
    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WSDatum *copy = [[[self class] allocWithZone:zone] init];
    [copy setValue:[self value]];
    [copy setValueX:[self valueX]];
    [copy setAnnotation:[self annotation]];
    id datumCopy = [[NSMutableDictionary alloc] initWithDictionary:[self datum]
                                                         copyItems:YES];
    [copy setDatum:datumCopy];
    id customCopy = [[self customDatum] copyWithZone:zone];
    [copy setCustomDatum:customCopy];

    [copy setDelegate:[self delegate]];
    return copy;
}


#pragma mark - KVO

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
    BOOL automatic = NO;
    
    if ([theKey isEqualToString:KVO_DATUM]) {
        automatic = NO;
    } else {
        automatic=[super automaticallyNotifiesObserversForKey:theKey];
    }
    return automatic;
}


#pragma mark -

- (NAFloat)valueY {
    return _valueY;
}

- (NAFloat)value {
    return [self valueY];
}

- (void)setValueY:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    _valueY = aValue;
    [self didChangeValueForKey:KVO_DATUM];
}

- (void)setValue:(NAFloat)aValue {
    [self setValueY:aValue];
}

- (NAFloat)valueX {
    return _valueX;
}

- (void)setValueX:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    _valueX = aValue;
    [self didChangeValueForKey:KVO_DATUM];
}

- (NSDate *)dateTime {
    return [NSDate dateWithTimeIntervalSince1970:[self valueX]];
}

- (void)setDateTime:(NSDate *)dateTime {
    [self setValueX:[dateTime timeIntervalSince1970]];
}

- (NSString *)annotation {
    return _annotation;
}

- (void)setAnnotation:(NSString *)anno {
    [self willChangeValueForKey:KVO_DATUM];
    _annotation = anno;
    [self didChangeValueForKey:KVO_DATUM];
}

- (NAFloat)errorMinX {
    return [[[self datum] objectForKey:@"errorMinX"]
            floatValue];
}

- (void)setErrorMinX:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    @synchronized(self) {
        [[self datum] setObject:[NSNumber numberWithFloat:aValue]
                         forKey:@"errorMinX"];
    }
    [self didChangeValueForKey:KVO_DATUM];
}

- (NAFloat)errorMaxX {
    return [[[self datum] objectForKey:@"errorMaxX"]
            floatValue];
}

- (void)setErrorMaxX:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    @synchronized(self) {
        [[self datum] setObject:[NSNumber numberWithFloat:aValue]
                         forKey:@"errorMaxX"];
    }
    [self didChangeValueForKey:KVO_DATUM];
}

- (NAFloat)errorMinY {
    return [[[self datum] objectForKey:@"errorMinY"]
            floatValue];
}

- (void)setErrorMinY:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    @synchronized(self) {
        [[self datum] setObject:[NSNumber numberWithFloat:aValue]
                         forKey:@"errorMinY"];
    }
    [self didChangeValueForKey:KVO_DATUM];
}
          
- (NAFloat)errorMaxY {
    return [[[self datum] objectForKey:@"errorMaxY"]
            floatValue];
}

- (void)setErrorMaxY:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    @synchronized(self) {
        [[self datum] setObject:[NSNumber numberWithFloat:aValue]
                         forKey:@"errorMaxY"];
    }
    [self didChangeValueForKey:KVO_DATUM];
}

- (BOOL)hasErrorX {
    if ([[self datum] objectForKey:@"errorMinX"]) {
        return YES;
    }
    return NO;
}

- (BOOL)hasErrorY {
    if ([[self datum] objectForKey:@"errorMinY"]) {
        return YES;
    }
    return NO;
}

- (NAFloat)errorCorr {
    return [[[self datum] objectForKey:@"errorCorr"]
            floatValue];
}

- (void)setErrorCorr:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    @synchronized(self) {
        [[self datum] setObject:[NSNumber numberWithFloat:aValue]
                         forKey:@"errorCorr"];
    }
    [self didChangeValueForKey:KVO_DATUM];
}

- (BOOL)hasErrorCorr {
    return (BOOL)[[self datum] objectForKey:@"errorCorr"];
}

- (BOOL)alerted {
    return [[[self datum] objectForKey:@"alerted"]
            boolValue];
}

- (void)setAlerted:(BOOL)alerted {
    [self willChangeValueForKey:KVO_DATUM];
    @synchronized(self) {
        [[self datum] setObject:[NSNumber numberWithBool:alerted]
                         forKey:@"alerted"];
    }
    [self didChangeValueForKey:KVO_DATUM];
}


#pragma mark -

- (NSComparisonResult)valueXCompare:(id)aDatum {
    if ([self valueX] < [aDatum valueX]) {
        return NSOrderedAscending;
    } else {
        if ([self valueX] > [aDatum valueX]) {
            return NSOrderedDescending;
        }
    }
    return NSOrderedSame;
}


#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"WSDatum: %@",
            [[self datum] description]];
}




@end
