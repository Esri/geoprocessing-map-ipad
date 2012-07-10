///
///  WSCoordinateDirection.h
///  PowerPlot
///
///  This header defines an elementary data type that specifies the
///  direction (either X- or Y-) any coordinate-related datum can
///  have.
///
///
///  Created by Wolfram Schroers on 15.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


#ifndef __WSCOORDINATEDIRECTION_H__
#define __WSCOORDINATEDIRECTION_H__

/** The possible styles a direction can be scaled. */
typedef enum _WSCoordinateDirection {
    kCoordinateDirectionNone = 0, ///< No direction specified.
    kCoordinateDirectionX,        ///< X-direction.
    kCoordinateDirectionY         ///< Y-direction.
} WSCoordinateDirection;


#endif /* __WSCOORDINATEDIRECTION_H__ */

