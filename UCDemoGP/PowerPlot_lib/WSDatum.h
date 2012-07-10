///
///  WSDatum.h
///  PowerPlot
///
///  This class describes a single datum point in a data set. The
///  point always has a value (Y-value) and may have an annotation, an
///  X-value and (asymmetric) errors in X and Y.
///
///  A point has a couple of further properties which are stored in a
///  dictionary.  If a property is available, the key exists and the
///  value will be an NSNumber whose floatValue corresponds to the
///  datum.
///
///  In the dictionary the following keys and value types are defined:
///    @"errorMinY"  -> NSNumber
///    @"errorMaxY"  -> NSNumber
///    @"errorMinX"  -> NSNumber
///    @"errorMaxX"  -> NSNumber
///    @"errorCorr"  -> NSNumber
///    @"alerted"    -> NSNumber (Boolean)
///
///  This class has two more slots whose use is optional. The first
///  one is called "customDatum" and can be any Cocoa object that
///  implements the NSCopying and NSCoding protocols. It is accessed
///  with standard getter and setter methods and is intended to be
///  used for storage of additional information not covered by the
///  default implementation. Typically, the customDatum slot is used
///  for "style" information that configure the view and possibly are
///  chosen by the program's user. These might include colors, fonts
///  and similar data. Subclasses of WSPlot that support these
///  customizations include WSPlotBar, WSPlotGraph etc. The objects
///  describing customizations typically are subclasses of
///  "WSCustomProperties" and their names end with "Properties".
///
///  The other is a delegate slot that can be used by categories or by
///  subclasses to provide an optional data source or a delegate.
///  While the customDatum property should implement both NSCoding and
///  NSCopying, the delegate property is never copied, but merely set
///  to the new destination in case of a copy operation and ignored
///  during serialization and deserialization.
///
///  Starting with PowerPlot v1.3 this class supports KVO notifications
///  for the 'datum' property if it is changed using any of the 'set...'
///  methods listed below.
///
///  @note The convention for uncertainties is that whenever
///        errorMin[X|Y] exists, so will errorMax[X|Y] and vice versa.
///
///
///  Created by Wolfram Schroers on 28.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "NARange.h"
#import "WSObject.h"


@interface WSDatum : WSObject <NSCopying, NSCoding> {

@public
    NSMutableDictionary *_datum;
}

@property (retain) NSMutableDictionary *datum;                     ///< The dictionary containing the properties.
@property (retain) id <NSCoding, NSCopying, NSObject> customDatum; ///< Customization information.
@property (assign) id <NSObject> delegate;                         ///< Custom delegate.

@property NAFloat valueY;               ///< The Y-value.
@property NAFloat value;                ///< The Y-value (alternate name for valueY).
@property NAFloat valueX;               ///< The X-value.
@property (copy) NSString *annotation;  ///< Annotation/string value of datum.
@property NAFloat errorMinX;            ///< Uncertainty in X - lower end.
@property NAFloat errorMaxX;            ///< Uncertainty in X - upper end.
@property NAFloat errorMinY;            ///< Uncertainty in Y - lower end.
@property NAFloat errorMaxY;            ///< Uncertainty in Y - upper end.
@property NAFloat errorCorr;            ///< Correlation of uncertainties in X- and Y-direction.
@property (readonly) BOOL hasErrorX;    ///< Does the data set have uncertainties in X-direction?
@property (readonly) BOOL hasErrorY;    ///< Does the data set have uncertainties in Y-direction?
@property (readonly) BOOL hasErrorCorr; ///< Does the data set have error correlations?
@property BOOL alerted;                 ///< 'alerted' flag on the current datum.


/** Return an autoreleased empty datum (factory method). */
+ (id)datum;

/** Return an autoreleased datum with a Y-value (factory method). */
+ (id)datumWithValue:(NAFloat)aValue;

/** Return an autoreleased datum with an annotated Y-value (factory method). */
+ (id)datumWithValue:(NAFloat)aValue
          annotation:(NSString *)anno;

/** Return an autoreleased datum of a X,Y-pairs (factory method). */
+ (id)datumWithValue:(NAFloat)aValue
              valueX:(NAFloat)aValueX;

/** Return an autoreleased datum of an annotated X,Y-pairs (factory method). */
+ (id)datumWithValue:(NAFloat)aValue
              valueX:(NAFloat)aValueX
          annotation:(NSString *)anno;

/** Initialize an empty datum. */
- (id)init;

/** @brief Initialize the datum with a Y-value.
 
    After initialization, the datum will only consist of a Y-value.
 */
- (id)initWithValue:(NAFloat)aValue;

/** Initialize the datum with an annotated Y-value. */
- (id)initWithValue:(NAFloat)aValue
         annotation:(NSString *)anno;

/** Initialize the datum with an X,Y-pair. */
- (id)initWithValue:(NAFloat)aValue
             valueX:(NAFloat)aValueX;

/** Initialize the datum with an annotated X,Y-pair. */
- (id)initWithValue:(NAFloat)aValue
             valueX:(NAFloat)aValueX
         annotation:(NSString *)anno;

/** @brief Alternate accessor for X-value.
 
    Internally, the X-value is stored as the time in seconds since 1970.
    The dateTime alternate accessors allow the passing of NSDate instances,
    instead.
 
    @return An autoreleased NSDate instance based on the valueX property.
 */
- (NSDate *)dateTime;

/** @brief Alternate setter for X-value.
 
    Sets the valueX property to the time in seconds since 1970.
 */
- (void)setDateTime:(NSDate *)dateTime;


/** @brief Compare the X-value of this datum with another X-value.

    This method is needed for all operations that require comparison,
    e.g. the sorting capabilities of WSData.

    @param aDatum WSDatum with which we compare the instance's properties.
    @return The result of the comparison of type NSComparisonResult.
 */
- (NSComparisonResult)valueXCompare:(id)aDatum;

/** Return a string with a description of this datum. */
- (NSString *)description;

@end
