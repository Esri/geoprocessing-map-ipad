///
///  WSVersion.h
///  PowerPlot
///
///  Generic versioning and identification mechanism whose
///  implementation and use is optional for derived objects.
///
///
///  Created by Wolfram Schroers on 03/15/10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "WSAuxiliary.h"


/** Name of this package. */
#define kPackageName @"PowerPlot"

/** Name of developer. */
#define kDeveloperName @"Dr. Wolfram Schroers, NuAS, Berlin, Germany"

/** License conditions of this version. */
#define kLicenseStyle @"GPLv3"

/** Current package version number. */
#define kPackageVersion 1.41

/** Version of the current class. */
#define kClassVersion 1.41

/** (Internal) revision info supplied by SVN/CVS. */
#ifdef DEBUG
/** Unique commit ID (force SVN to always update info in this file on
    each commit). This requires a custom script which wraps the
    commit-command. */
#define kCommitID @"@COMMIT_ID"

/** SVN-supplied magic strings. */
#define kSVNId @"$Id: WSVersion.h 986 2012-03-12 14:29:03Z wolfram $"
#define kSVNRevision @"$Revision: 986 $"
#define kSVNDate @"$Date: 2012-03-12 15:29:03 +0100 (Mon, 12 Mar 2012) $"
#define kSVNAuthor @"$Author: wolfram $"
#endif

@interface WSVersion : NSObject

@property (readonly) NSString *packageName;   ///< Name of package.
@property (readonly) NSString *developerName; ///< Name of developer/software house.
@property (readonly) NSString *licenseStyle;  ///< License condition of the current class.
@property (readonly) CGFloat packageVersion;  ///< Version tag for the entire package.
@property (readonly) CGFloat requiredVersion; ///< Required version number for current class.
@property (readonly) CGFloat classVersion;    ///< Actual version number of current class.
#ifdef DEBUG
@property (readonly, nonatomic) NSString *SVNId;
@property (readonly, nonatomic) NSString *SVNRevision;
@property (readonly, nonatomic) NSString *SVNDate;
@property (readonly, nonatomic) NSString *SVNAuthor;
#endif

/** @brief Return if this object satisfies version requirements.
 
    You should overwrite this method with your own implementation if
    you want the versioning mechanism to detect incompatibilities.

    @return YES in case of a version conflict, NO otherwise.
 */
- (BOOL)conflictingVersion;

/** Return version information and internal revision info (debug).

    With the debug flag activitated, the version information is
    significantly more verbose and contains the SVN magic
    keywords. These should not be used in release versions.

    @return  An NSString with version information.
 */
- (NSString *)version;

/** @brief Return a unique instance identifier (UIID) for an instance.
 
    The UIID is a unique string for the run of the program on a single
    machine.
 
    @note This method must only be called once for each instance!
 */
+ (NSString *)UIIDForInstance:(id)obj;

@end
