///
///  WSBarProperties.h
///  PowerPlot
///
///  This class describes the customizable properties of a bar in a
///  WSPlotBar plot. Instances can be stored inside the customDatum
///  property a WSDatum object for use of individual bars or as a
///  generic object describing all bars in WSPlotBar.
///
///  @note The shadow property only applies to bars with a solid fill,
///        not bars with gradients.
///
///
///  Created by Wolfram Schroers on 16.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "NARange.h"
#import "WSObject.h"
#import "WSCustomProperties.h"


/** Configuration of default bar appearance (in bounds coordinates). */
#define kBarWidth 20.0
#define kOutlineStroke 2.0
#define kShadowScale 5.0

/** Styles the bar can be drawn. */
typedef enum _WSBarStyle {
    kBarNone = -1, ///< Turn the display off.
    kBarOutline,   ///< Online draw the outline.
    kBarFilled,    ///< Bar with outline and (separate) solid fill.
    kBarGradient   ///< Bar with outline, filled with gradient.
} WSBarStyle;

@interface WSBarProperties : WSCustomProperties {

@protected
    NAFloat _barWidth,
            _outlineStroke,
            _shadowScale;   
    WSBarStyle _style;      
    BOOL _shadowEnabled;        
    UIColor *_outlineColor,
            *_barColor,
            *_barColor2,
            *_shadowColor;  
}

@property (nonatomic) NAFloat barWidth;            ///< Width of bar in bounds coordinates.
@property (nonatomic) NAFloat outlineStroke;       ///< Width of outline stroke.
@property (nonatomic) NAFloat shadowScale;         ///< Offset and blur of shadow.
@property (nonatomic) WSBarStyle style;            ///< Style of the bar.
@property (nonatomic, getter = isShadowEnabled) BOOL shadowEnabled; ///< Does the bar have a shadow?
@property (copy, nonatomic) UIColor *outlineColor; ///< Color of bar outline.
@property (copy, nonatomic) UIColor *barColor;     ///< Color of bar filling.
@property (copy, nonatomic) UIColor *barColor2;    ///< Color of bar filling if there is a gradient.
@property (copy, nonatomic) UIColor *shadowColor;  ///< Color of bar shadow.

@end
