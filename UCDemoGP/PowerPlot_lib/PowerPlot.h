///
///  PowerPlot.h
///  PowerPlot
///
///  @mainpage
///
///  @section overview Overview
///
///  This is the Open-Source PowerPlot static library for
///  iOS. PowerPlot is a library for visualizing data on mobile
///  devices. It significantly simplifies the development of software
///  that presents information to the user in a graphical manner. It
///  ships with a large collection of default graph types, plot and
///  color styles and is widely configurable to meet any
///  requirement. Still, it is easy to learn and use and well
///  documented. For commercial uses and App-Store deployment a
///  proprietary, alternative license is available.
///
///  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
///  APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE
///  COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS
///  IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
///  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
///  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE
///  RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH
///  YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
///  ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
///
///  IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN
///  WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO
///  MODIFIES AND/OR CONVEYS THE PROGRAM AS PERMITTED ABOVE, BE LIABLE
///  TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR
///  CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
///  THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA
///  BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
///  PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
///  PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF
///  THE POSSIBILITY OF SUCH DAMAGES.
///
///  @section version Version information
///
///  This GPL release has removed the deprecated APIs from earlier
///  versions. Commercial clients have received help in porting if
///  they have acquired a license prior to January 23rd, 2012.
///
///  @section support Support
///
///  Documentation, support and more licensing options and extensions
///  are provided by
///
///  Numerik & Analyse Schroers, Berlin, Germany.
///  http://powerplot.nua-schroers.de
///
///  in collaboration with
///
///  global prognostics GmbH, Berlin, Germany.
///  http://www.global-prognostics.com/home.php
///
///  Introductory articles into the structure of PowerPlot can be
///  found at
///
///  http://www.field-theory.org/articles/powerplot/library.html
///  http://www.field-theory.org/articles/powerplot/example.html
///
///  Detailed documentation generated from the source code files is
///  available at
///
///  http://powerplot.nua-schroers.de/documentation.html
///
///  @section license License
///
///  Copyright 2010 Numerik & Analyse Schroers. All rights
///  reserved. This copy of the resources is licensed under the GPLv3
///  http://field-theory.org/downloads/gpl-3.0.txt For additional
///  licensing options and support, please go to
///  http://powerplot.nua-schroers.de
///
///  @version This is PowerPlot library v1.4.1. GPLv3 release.
///
///
///  @author Lead developer and project leader is Dr. Wolfram Schroers
///  http://www.field-theory.org , additional development team funded
///  by global prognostics GmbH.
///
///

/// Version information flags.
#define __POWERPLOT__1_3_NON_DEPRECATED_INTERFACE
#define __POWERPLOT__1_4

/// Import of individual project files.
#import "NAAmethyst.h"
#import "NARange.h"
#import "WSAuxiliary.h"
#import "WSAxisLocation.h"
#import "WSAxisLocationDelegate.h"
#import "WSAxisProperties.h"
#import "WSBarPlotFactory.h"
#import "WSBarProperties.h"
#import "WSBinning.h"
#import "WSChart.h"
#import "WSChartAnimation.h"
#import "WSColor.h"
#import "WSColorScheme.h"
#import "WSConnection.h"
#import "WSConnectionDelegate.h"
#import "WSContour.h"
#import "WSControllerGestureDelegate.h"
#import "WSCoordinate.h"
#import "WSCoordinateDelegate.h"
#import "WSCoordinateDirection.h"
#import "WSCoordinateTransform.h"
#import "WSCustomProperties.h"
#import "WSData.h"
#import "WSDataDelegate.h"
#import "WSDataOperations.h"
#import "WSDataPointProperties.h"
#import "WSDatum.h"
#import "WSDatumCustomization.h"
#import "WSFont.h"
#import "WSGraph.h"
#import "WSGraphConnections.h"
#import "WSGraphPlotFactory.h"
#import "WSLinePlotFactory.h"
#import "WSNode.h"
#import "WSNodeProperties.h"
#import "WSObject.h"
#import "WSPlot.h"
#import "WSPlotAxis.h"
#import "WSPlotBar.h"
#import "WSPlotController.h"
#import "WSPlotData.h"
#import "WSPlotDisc.h"
#import "WSPlotFactoryDefaults.h"
#import "WSPlotGraph.h"
#import "WSPlotRegion.h"
#import "WSPlotTemplate.h"
#import "WSTicks.h"
#import "WSVersion.h"
#import "WSView.h"

