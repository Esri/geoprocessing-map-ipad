///
///  @file
///  WSDataOperations.h
///  PowerPlot
///
///  A collection of operations on WSData objects.
///
///  @note: These operations require the use of Objective-C blocks and
///         are thus available only in Objective-C 2.0 and iOS 4.0 and
///         later. Do not use this category in earlier versions.
///
///
///  Created by Wolfram Schroers on 06.08.11.
///  Copyright 2011 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSData.h"


@class WSDatum;

#ifdef __IPHONE_4_0

/// Define the blocks used in the operations.
typedef WSDatum* (^mapBlock_t)(const id);
typedef NSComparisonResult (^sortBlock_t)(WSDatum *, WSDatum *);
typedef BOOL (^filterBlock_t)(WSDatum *);

#endif ///__IPHONE_4_0

@interface WSData (WSDataOperations)

#ifdef __IPHONE_4_0

/** @brief Map a function on a single data set (non-destructive).
 
    The input data object can either be a WSData object or an NSArray
    of WSData objects, each of which must have the same number of
    elements.  In the former case (if data is of class WSData),
    mapBlock is called with WSDatum objects. In the latter case (if
    data is of class NSArray), mapBlock is called with an NSArray of
    WSDatum objects, taken from the respective index of each WSData
    objects, i.e., the array is resorted for operation by mapBlock.
 
    @param data Input data object, not modified on return.
    @param mapBlock The function to be applied to each WSDatum object.
    @return An autoreleased WSData object with mapBlock mapped on data.
 */
+ (WSData *)data:(id)data
             map:(mapBlock_t)mapBlock;

/** @brief Map a function on the current data set (destructively).
 
    The function mapBlock is applied to each element of the current
    data set.  The function must take and return WSDatum objects.
 
    @param mapBlock The function to be applied to each WSDatum object.
 */
- (void)map:(mapBlock_t)mapBlock;


/** @brief Apply reduction operation 'average' on current data set.
 
    A reduction operation is applied to the current data set,
    returning a WSDatum object that contains the averaged X- and
    Y-values of the original set.
 
    @note Errors and correlations are ignored.
 
    @return A WSDatum object containing the averaging result.
 */
- (WSDatum *)reduceAverage;

/** @brief Apply reduction operation 'sum' on current data set.
 
    A reduction operation is applied to the current data set,
    returning a WSDatum object that contains the averaged X- and
    Y-values of the original set.
 
    @note Errors and correlations are ignored.
 
    @return A WSDatum object containing the sum result.
 */
- (WSDatum *)reduceSum;


/** Return a new WSData set, sorted with a custom comparator.
 
    @param comparator Block comparing two instances of WSDatum.
    @result An autoreleased new WSData set, sorted according to the comparator.
 */
- (WSData *)sortedDataUsingComparator:(sortBlock_t)comparator;


/** Return a new WSData set, filtered with a custom filter.
 
    @param filter Block returning a BOOL if this object should be used.
    @return An autoreleased new WSData set, filtered according to the block.
 */
- (WSData *)filteredDataUsingFilter:(filterBlock_t)filter;

#endif ///__IPHONE_4_0

/** Return an array of floats with the X-values extracted from data set.
 
    @note The recipient needs to free the array after use. The length
          of the array needs to be taken from the count method.
 */
- (NAFloat *)floatsFromDataX;

/** Return an array of floats with the Y-values extracted from data set.
 
    @note The recipient needs to free the array after use. The length
          of the array needs to be taken from the count method.
 */
- (NAFloat *)floatsFromDataY;

/** Return the index of the datum that is closest to the given point.
 
    @note If there are no data points in the set, -1 is returned.

    @param location Location of a point in the coordinate system of the data set.
    @return Index of the point closest to the given index. 
 */
- (NSInteger)datumClosestToLocation:(CGPoint)location;

/** Return the index of the datum closest to the given point within a distance.
 
    @note If there are no data points within the distance given, -1 is
    returned.
 
    @param location Location of a point in the coordinate system of the data set.
    @param distance Maximum distance for hit testing.
    @return Index of the point closest to the given index. 
 */
- (NSInteger)datumClosestToLocation:(CGPoint)location
                    maximumDistance:(NAFloat)distance;

/** Return the index of the datum whose X-value is closest to a given X-value.
 
    @note If there are no data points in the set, -1 is returned.
 
    @param valueX X-value in the coordinate system of the data set.
    @return Index of the point closest to the given index. 
 */
- (NSInteger)datumClosestToValueX:(NAFloat)valueX;

/** Index of datum whose X-value is closest to a given X-value within a distance.
 
    @note If there are no data points within the distance given, -1 is
    returned.
 
    @param valueX X-value in the coordinate system of the data set.
    @param distance Maximum distance for hit testing.
    @return Index of the point closest to the given index. 
 */
- (NSInteger)datumClosestToValueX:(NAFloat)valueX
                  maximumDistance:(NAFloat)distance;

/** Return the index of the datum whose Y-value is closest to a given Y-value.
 
    @note If there are no data points in the set, -1 is returned.
 
    @param valueY Y-value in the coordinate system of the data set.
    @return Index of the point closest to the given index. 
 */
- (NSInteger)datumClosestToValueY:(NAFloat)valueY;

/** Index of datum whose Y-value is closest to a given Y-value within a distance.
 
    @note If there are no data points within the distance given, -1 is
    returned.
 
    @param valueY Y-value in the coordinate system of the data set.
    @param distance Maximum distance for hit testing.
    @return Index of the point closest to the given index. 
 */
- (NSInteger)datumClosestToValueY:(NAFloat)valueY
                  maximumDistance:(NAFloat)distance;

@end
