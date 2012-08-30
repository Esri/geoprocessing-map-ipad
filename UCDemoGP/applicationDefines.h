//
//  applicationDefines.h

/*
 
 UC Geoprocessing Demo -- Esri 2012 User Conference
 Copyright © 2012 Esri
 
 All rights reserved under the copyright laws of the United States
 and applicable international laws, treaties, and conventions.
 
 You may freely redistribute and use this sample code, with or
 without modification, provided you include the original copyright
 notice and use restrictions.
 
 See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
 
 */


// Map Services used
#define kBaseMapTiled @"http://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Reference_Overlay/MapServer"
#define kBaseMapDynamicMapService @"http://esrilabs3.esri.com/arcgis/rest/services/SpatialAnalysis/lead/MapServer"
//http://esrilabs3.esri.com/arcgis/rest/services/SpatialAnalysis/InterpolateLead/MapServer
#define kSoilSampleFeatureService @"http://esrilabs3.esri.com/arcgis/rest/services/SpatialAnalysis/Soilpoints/FeatureServer/0"
#define kGPUrlForMapService @"http://esrilabs3.esri.com/arcgis/rest/services/SpatialAnalysis/InterpolateLead/GPServer/InterpolateLead"
#define kGPUrlForMapServiceResults @"/results/Lead_Concentrations"
#define kGPUrlForMapServiceJobs @"/jobs/"
#define kRiversService @"http://esrilabs3.esri.com/arcgis/rest/services/SpatialAnalysis/Rivers/MapServer"

#define kWaterShedGP @"http://esrilabs3.esri.com/arcgis/rest/services/SpatialAnalysis/Watershed/GPServer/Watershed"
#define kSoilStatsGP @"http://esrilabs3.esri.com/arcgis/rest/services/SpatialAnalysis/SoilStats/GPServer/SoilStats"

#define kDynamicMapAlpha 0.7

#define kXmin -10744392.2272696
#define kYmin 3513521.303541
#define kXmax -10580470.919649
#define kYmax 3631972.982113

