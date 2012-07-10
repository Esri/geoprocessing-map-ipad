///
///  WSPlotController.h
///  PowerPlot
///
///  This class is a controller class that manages both a data model
///  object and a view object in PowerPlot. The data object contains
///  information in data coordinates (which is whatever the user
///  decides to use) and the view object is a subplot (data curve,
///  bar/pie charts, coordinate axis and related properties etc.) of
///  the chart.
///
///  Each controller handles one PowerPlot view object (which is
///  typically a subclass of WSPlot), the two coordinate axis (class
///  WSCoordinate), two axis locations (used by some, but not all
///  plots) and optionally an instance of WSData. In the latter case
///  it must implement the WSDataDelegate formal protocol that defines
///  methods for accessing the data.
///
///  This controller also implements the WSCoordinateDelegate formal
///  protocol that provides methods for conversion of screen/bounds
///  and data coordinates.
///
///  The instances of coordX and coordY handled by this controller may
///  be shared with other controllers. This can be used to give the
///  chart a unified coordinate and axis system if needed. Similarly,
///  axisLocationX and axisLocationY can be shared among several plot
///  controllers, but it remains the user's responsibility to make
///  sure that no inconsistencies arise, particularly with the
///  delegate of these classes!
///
///  It is, of course, possible to also use other view objects (like
///  UILabel instances etc.) in this controller. That is a mechanism
///  to add more customization to a plot.
///
///  Since PowerPlot v1.4 this class also supports a set of default
///  gesture recognizers. They allow zooming by pinching, scrolling by
///  panning and single taps. In order for zooming and scrolling to
///  work, the zoomRange[X|Y]D and scrollRange[X|Y]D properties must
///  be set up appropriately.  For configuring a response to tap
///  gestures, set the delegate property of this class.
///
///  @note An instance of WSPlotController is <strong>not</strong> a
///        user interface view controller, but rather an abstraction
///        to combine data model objects and view objects. Although
///        its view is accessed only indirectly via [instVar view],
///        from the users' point of view it is a view which is
///        internally split up according to the MVC paradigm.  This is
///        the reason why WSPlotController inherits directly from
///        WSObject rather from a UIController or a UIView.
///
///
///  Created by Wolfram Schroers on 06.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSObject.h"
#import "WSAxisLocationDelegate.h"
#import "WSCoordinateDelegate.h"
#import "WSDataDelegate.h"
#import "WSControllerGestureDelegate.h"


/** Set the type of hit testing to be performed. */
typedef enum _WSTapHitTesting {
    kHitTestNone      = 0,      ///< Do not perform any hit testing.
    kHitTestX         = 1 << 0, ///< Consider X-distance only.
    kHitTestY         = 1 << 1, ///< Consider Y-distance only.
    kHitTestWithRange = 1 << 2  ///< Consider 2D (X&Y) distance.
} WSTapHitTesting;

/** Set the type of response once a tap occurred. */
typedef enum _WSTapHitResponse {
    kHitResponseNone,           ///< Do not call the delegate.
    kHitResponseDatum,          ///< Identify the datum index (based on hitTestMethod), call the delegate.
    kHitResponseLocationBounds, ///< Call the delegate with the bounds coordinates.
    kHitResponseLocationData    ///< Call the delegate with the data coordinates.
} WSTapHitResponse;

@class WSAxisLocation;
@class WSPlot;
@class WSCoordinate;
@class WSData;
@class WSDatum;
@class WSCustomProperties;

#ifdef __IPHONE_4_0

/** A block with 'alerting' functionality. */
typedef BOOL (^alertBlock_t)(WSDatum *);

#endif ///__IPHONE_4_0

@interface WSPlotController : WSObject
    <UIGestureRecognizerDelegate,
     WSAxisLocationDelegate,
     WSCoordinateDelegate,
     WSDataDelegate>

@property (retain, nonatomic) WSPlot *view;                                       ///< View handled by this controller.
@property (retain, nonatomic) WSAxisLocation *axisLocationX;                      ///< Handles X-axis positioning.
@property (retain, nonatomic) WSAxisLocation *axisLocationY;                      ///< Handles Y-axis positioning.
@property (retain, nonatomic) WSCoordinate *coordX;                               ///< Abscissa axis.
@property (retain, nonatomic) WSCoordinate *coordY;                               ///< Ordinate axis.
@property (nonatomic, getter = isScrollEnabled) BOOL scrollEnabled;               ///< Scrolling enabled flag.
@property (nonatomic, getter = isZoomEnabled) BOOL zoomEnabled;                   ///< Zooming enabled flag.
@property (nonatomic, getter = isTapEnabled) BOOL tapEnabled;                     ///< Single-tap enabled flag.
@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;     ///< Scrolling gesture recognizer.
@property (nonatomic, readonly) UIPinchGestureRecognizer *pinchGestureRecognizer; ///< Scrolling gesture recognizer.
@property (nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;     ///< Scrolling gesture recognizer.
@property (nonatomic) NARange scrollRangeXD;                                      ///< Allowed X-range for scrolling.
@property (nonatomic) NARange scrollRangeYD;                                      ///< Allowed Y-range for scrolling.
@property (nonatomic) NARange zoomRangeXD;                                        ///< Allowed X-range for zooming.
@property (nonatomic) NARange zoomRangeYD;                                        ///< Allowed Y-range for zooming.
@property (nonatomic) WSTapHitTesting hitTestMethod;                              ///< Determine how taps are tested.
@property (nonatomic) WSTapHitResponse hitResponseMethod;                         ///< How to respond to a single tap.
@property (assign, nonatomic) id <WSControllerGestureDelegate> delegate;          ///< Delegate for gestures.

/** @brief Configure zooming factors for pinch gestures.
 
    This method sets the rangePinchXD, rangePinchYD, scrollRangeXD and
    scrollRangeYD properties based on the current coordinates. It is
    an alternative to computing and setting these ranges manually.
 
    @note For non-linear coordinate transformations this method may
          yield unexpected results.
 
    @param maxZoomXD Zoom factor max. X-axis >= 1.0.
    @param maxZoomYD Zoom factor max. Y-axis >= 1.0.
    @param minZoomXD Zoom factor min. X-axis <= 1.0.
    @param minZoomYD Zoom factor min. Y-axis <= 1.0.
 */
- (void)setMaximumZoomScaleXD:(NAFloat)maxZoomXD
           maximumZoomScaleYD:(NAFloat)maxZoomYD
           minimumZoomScaleXD:(NAFloat)minZoomXD
           minimumZoomScaleYD:(NAFloat)minZoomYD;

/** @brief Activate data bindings for this specific plot.
 
    When the data set associated with a particular instance of a
    subclass of WSPlot is changed and this flag is turned on, then the
    graph will automatically be redrawn.
 
    The default value is NO, i.e., the graph is not updated.
 */
@property (nonatomic, getter = isBindingsEnabled) BOOL bindingsEnabled;

#ifdef __IPHONE_4_0

/** @brief Activate alerting for this specific plot.
 
    Alerting is a feature that will highlight individual data points
    that meet certain criteria. Alerting only works with subclasses of
    WSPlot that support customizable data, like WSPlotBar or
    WSPlotGraph etc.  The style property in the view must be set to
    kCustomStyleIndividual.
 
    In order to configure automatic alerting, the bindings property
    has to be set to TRUE. For manual alerting call
    updatedAlertedData. In either case, the standardProperties and
    alertedProperties must be set to the correct values.
 
    The standardProperties and the alertedProperties properties are
    the values of the customDatum of a WSDatum that is not alerted and
    alerted, respectively.
 */
@property (copy, nonatomic) alertBlock_t alertBlock;                ///< Criteria for highlighting.
@property (copy, nonatomic) WSCustomProperties *standardProperties; ///< Non-highlighted datum style.
@property (copy, nonatomic) WSCustomProperties *alertedProperties;  ///< Highlighted datum style.

/** Perform an update of the dataD data set based on the alerting configuration. */
- (void)updateAlertedData;

#endif ///__IPHONE_4_0

@end
