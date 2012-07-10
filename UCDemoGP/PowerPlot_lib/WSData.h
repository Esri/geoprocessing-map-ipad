///
///  WSData.h
///  PowerPlot
///
///  Store and manage a set of data to be plotted. This class acts as
///  a controller for WSDatum.
///
///  The data is stored as an NSMutableArray of NSDatum. The array
///  contains a entry for every separate datum point. A couple of
///  factory methods allows the construction both from Cocoa-style
///  NSArray of NSNumber and from C-style float[] arrays.
///
///  Starting with PowerPlot v1.3 this class supports KVO notifications
///  for the 'values' property which are triggered if any element is
///  changed using any of the 'set...' methods in the WSDatum class or a
///  method in this WSData class that modifies the data. Note that the
///  changes to the content are *not* reported when notifications are
///  posted!
///
///  @note The convention that data coordinates are prepended with a
///        capital "D" does not apply here since everything WSData
///        handles is done in data coordinates, anyway!
///
///
///  Created by Wolfram Schroers on 24.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import <math.h>
#import "NARange.h"
#import "WSObject.h"


@class WSDatum;

@interface WSData : WSObject <NSCopying, NSCoding, NSFastEnumeration> {

@protected
    NSString *_nameTag;
    NSMutableArray* _values;
}

@property (retain) NSString *nameTag;      ///< An (optional) name of the data set.
@property (retain) NSMutableArray *values; ///< Array of NSDatum containing numerical data.


/** @brief Get an NSArray of zeros with specified length.
 
    This is an auxilliary method which makes life easier when using
    the initializers that ask for lots of data.
 */
+ (NSArray *)arrayOfZerosWithLen:(NSUInteger)len;

/** @brief Return an NSArray of NSNumber (float) from a C array of float.
 
    This is an auxilliary method which makes life easier when the data
    model is available as C-style data.
 */
+ (NSArray *)arrayWithFloat:(float[])floats
                        len:(NSUInteger)len;

/** @brief Return an NSArray of NSString from a C array of NSString.
 
    This is an auxilliary method which should make life easier when
    the data model is available as C-style data.
 */
+ (NSArray *)arrayWithString:(NSString *[])strings
                         len:(NSUInteger)len;

/** Return an autoreleased empty data set (factory method). */
+ (id)data;

/** Return an autoreleased data set of Y-values (factory method). */
+ (id)dataWithValues:(NSArray *)vals;

/** Return an autoreleased data set of annotated Y-values (factory method). */
+ (id)dataWithValues:(NSArray *)vals
         annotations:(NSArray *)annos;

/** Return an autoreleased data set of X,Y-pairs (factory method). */
+ (id)dataWithValues:(NSArray *)vals
             valuesX:(NSArray *)valsX;

/** Return an autoreleased data set of annotated X,Y-pairs (factory method). */
+ (id)dataWithValues:(NSArray *)vals
             valuesX:(NSArray *)valsX
         annotations:(NSArray *)annos;

/** @brief Return an autoreleased data set of X,Y-pairs with uncertainties (factory method).
 
    @note See the method
          "initWithValues:withValuesX:withErrorMinY:with ..."  for the
          conventions used for the uncertainties.
 */
+ (id)dataWithValues:(NSArray *)vals
             valuesX:(NSArray *)valsX
           errorMinY:(NSArray *)errMinY
           errorMaxY:(NSArray *)errMaxY
           errorMinX:(NSArray *)errMinX
           errorMaxX:(NSArray *)errMaxX;

/** @brief Sort the WSDatum objects in this class.

    Return an autoreleased instance of WSData with the current data
    sorted by X-values (factory method). The content of the current
    instance is not affected.

    @return The new WSData set.
 */
- (WSData *)sortedDataUsingValueX;

/** @brief Return the WSDatum objects in this class with an index.

    Return an autoreleased instance of WSData based on the current
    data in this instance. The new X-values set to integer numbers,
    i.e., indexed (factory method). The old content of X-values is not
    preserved in the new data set. The content of the current instance
    is not affected.

    @return The new WSData set.
 */
- (WSData *)indexedData;

/** Initialize an empty data set. */
- (id)init;

/** @brief Initialize the data set with Y-values.
 
    After initialization, the data will only consist of Y-values, the
    other fields are empty.
 */
- (id)initWithValues:(NSArray *)vals;

/** @brief Initialize the data set with annotated Y-values.
 
    The data will consist of Y-values and NSString values in the
    annotation field. The sizes of both arrays must match.
 */
- (id)initWithValues:(NSArray *)vals
         annotations:(NSArray *)annos;

/** @brief Initialize the data set with X,Y-pairs.
 
    The data will consist of pairs of X,Y-values. The sizes of both
    arrays must match.
 */
- (id)initWithValues:(NSArray *)vals
             valuesX:(NSArray *)valsX;

/** @brief Initialize the data set with annotated X,Y-pairs.
 
    The data will consist of pairs of X,Y-values and appropriate
    labels.  The sizes of all three arrays must match.
 */
- (id)initWithValues:(NSArray *)vals
             valuesX:(NSArray *)valsX
         annotations:(NSArray *)annos;

/** @brief Initialize the data set with X,Y-pairs with uncertainties.
 
    The data will consist of pairs of X,Y-values and (optional) their
    uncertainties. The sizes of "vals" and "valsX" must match. The
    arrays "withErrorMin[X|Y]" can either be empty or must match the
    X,Y-pairs. The array "withErrorMax[X|Y]" can either be empty or
    must match the X,Y-pairs. If the "*Min*" arrays are supplied, but
    the "*Max*" arrays are empty, the latter will be assumed to be
    identical to the former.  If neither errors are supplied (i.e.,
    the NSArray are empty), the data is assumed to have no uncertainty
    in X, Y or both.
 
    @note All uncertainties need to be positive!
 */
- (id)initWithValues:(NSArray *)vals
             valuesX:(NSArray *)valsX
           errorMinY:(NSArray *)errMinY
           errorMaxY:(NSArray *)errMaxY
           errorMinX:(NSArray *)errMinX
           errorMaxX:(NSArray *)errMaxX;

/** @brief Sort the current data by X-values.

    Unlike the "sortedDataUsingValueX" method this method acts on the
    current data content of the instance, i.e., the property is
    changed.
 */
- (void)sortDataUsingValueX;

/** Add an individual data point.

    @param aDatum New datum which is appended.
 */
- (void)addDatum:(WSDatum *)aDatum;

/** Insert an individual data point.

    @param aDatum The new datum.
    @param index Location where the new datum is inserted.
 */
- (void)insertDatum:(WSDatum *)aDatum
            atIndex:(NSUInteger)index;

/** Replace a data point at a given index.

    @param index Location where the new datum is placed.
    @param aDatum The new datum.
 */
- (void)replaceDatumAtIndex:(NSUInteger)index
                  withDatum:(WSDatum *)aDatum;

/** Remove all data points. */
- (void)removeAllData;

/** Remove an individual data point.

    @param index Location where the datum will be removed.
 */
- (void)removeDatumAtIndex:(NSUInteger)index;

/** @brief Return an array of values extracted from data set.
 
    @param extractor The extraction selector returning a value from WSDatum.
    @return An array with the results.
 */
- (NSArray *)valuesWithSelector:(SEL)extractor;

/** Return an array of X-values extracted from data set. */
- (NSArray *)valuesFromDataX;

/** Return an array of Y-values extracted from data set. */
- (NSArray *)valuesFromDataY;

/** Return an array of annotations (type NSString) from data set. */
- (NSArray *)annotationsFromData;

/** Return an array of the customData slot from data set. */
- (NSArray *)customFromData;

/** Return the minimum data value. */
- (NAFloat)minimumValue;
- (NAFloat)minimumValueY;

/** Return the maximum data value. */
- (NAFloat)maximumValue;
- (NAFloat)maximumValueY;

/** Return the minimum X value. */
- (NAFloat)minimumValueX;

/** Return the maximum X value. */
- (NAFloat)maximumValueX;

/** Return the sum of all data values */
- (NAFloat)integrateValue;

/** Return the number of data points in the set. */
- (NSUInteger)count;

/** Return the index of a specific datum. */
- (NSUInteger)indexOfDatum:(WSDatum *)datum;

/** Return a specific datum at index. */
- (WSDatum *)datumAtIndex:(NSUInteger)index;

/** Return the X-value of a datum at index. */
- (NAFloat)valueXAtIndex:(NSUInteger)index;

/** Return the Y-value of a datum at index. */
- (NAFloat)valueAtIndex:(NSUInteger)index;

/** Return the left-most data point (with smallest X-value). */
- (WSDatum *)leftMostDatum;

/** Return the right-most data point (with largest X-value). */
- (WSDatum *)rightMostDatum;

/** Return a string with a description of the set. */
- (NSString *)description;

@end
