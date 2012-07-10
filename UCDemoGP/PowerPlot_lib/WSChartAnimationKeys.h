/**
 *  @file
 *  WSChartAnimationKeys.h
 *  PowerPlot
 *
 *   This header file defines the keys for the WSChartAnimation support
 *   dictionary.
 *
 *   Created by Wolfram Schroers on 11/7/11.
 *   Copyright (c) 2011 Numerik & Analyse Schroers. All rights reserved.
 */

#ifndef __WSCHARTANIMATIONKEYS_H__
#define __WSCHARTANIMATIONKEYS_H__

#ifdef __IPHONE_4_0

/// Keys for userInfo dictionary of NSTimer.
#define WSUI_CONTEXT_KEY @"context"
#define WSUI_CONTEXT_CUSTOM @"customupdate"
#define WSUI_COMPLETION @"completion"
#define WSUI_ITERATION @"iteration"
#define WSUI_DURATION @"duration"
#define WSUI_OPTIONS @"options"
#define WSUI_OLDDATA @"olddata"
#define WSUI_NEWDATA @"newdata"
#define WSUI_OLDCOORDINATEX @"oldcoordX"
#define WSUI_OLDCOORDINATEY @"oldcoordY"
#define WSUI_NEWCOORDINATEX @"newcoordX"
#define WSUI_NEWCOORDINATEY @"newcoordY"


#endif /* __IPHONE_4_0 */

#endif /* __WSCHARTANIMATIONKEYS_H__ */
