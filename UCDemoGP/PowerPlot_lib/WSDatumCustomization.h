///
///  WSDatumCustomization.h
///  PowerPlot
///
///  This protocol is implemented by those subclasses of WSPlot which
///  allow individual customizations of the representation of WSDatum
///  objects. These include WSPlotBar (which allows to choose
///  individual colors and outline properties of bars) and WSPlotData
///  (which allows individual symbols and colors).  Note that not all
///  plots support individual customization, because it doesn't make
///  sense in some cases.
///
///  Typically, the names of classes that describe customized datum
///  objects end with "Properties", e.g., WSBarProperties and
///  WSNodeProperties.
///
///
///  Created by Wolfram Schroers on 1/16/12.
///  Copyright (c) 2012 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>


@class WSCustomProperties;

/** Styles customizable data can be drawn. */
typedef enum _WSDatumCustomizationStyle {
    kCustomStyleNone = -1, ///< Do not show a plot.
    kCustomStyleUnified,   ///< Use a single default style.
    kCustomStyleIndividual ///< Use data-specific custom style (if provided).
} WSDatumCustomizationStyle;

@protocol WSDatumCustomization <NSObject>

@required

@property (nonatomic) WSDatumCustomizationStyle style; ///< Style for datum representation in this plot.

/** Copy current default style to all data objects. */
- (void)distributeDefaultPropertiesToAllCustomDatum;

@end
