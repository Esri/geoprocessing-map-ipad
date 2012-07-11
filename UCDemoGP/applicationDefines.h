//
//  applicationDefines.h
//  UCDemoGP
//
//  Created by Al Pascual on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// Map Services used
#define kBaseMapTiled @"http://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Reference_Overlay/MapServer"
#define kBaseMapDynamicMapService @"http://ne2k864:6080/arcgis/rest/services/lead/MapServer"
#define kSoilSampleFeatureService @"http://ne2k864:6080/arcgis/rest/services/SoilSamplePoints/FeatureServer/0"
#define kGPUrlForMapService @"http://ne2k864:6080/arcgis/rest/services/InterpolateLead/GPServer/InterpolateLead"
#define kGPUrlForMapServiceResults @"/results/Lead_Concentrations"
#define kGPUrlForMapServiceJobs @"/jobs/"

#define kWaterShedGP @"http://ne2k864:6080/arcgis/rest/services/Watershed/GPServer/Watershed"
#define kSoilStatsGP @"http://ne2k864:6080/arcgis/rest/services/SoilStats/GPServer/SoilStats"

#define kDynamicMapAlpha 0.7