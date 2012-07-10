///
///  @file
///  WSView.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 03/15/10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSView.h"


@implementation WSView

@synthesize aVersion = _aVersion;
@synthesize UIID = _UIID;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _aVersion = [[WSVersion alloc] init];
        _UIID = [[WSVersion UIIDForInstance:self] copy];
    }
    return self;
}


#pragma mark - WSVersionDelegate

- (NSString *)version {
    @synchronized(self) {
        if (_aVersion == nil) {
            _aVersion = [[WSVersion alloc] init];
        }
    }
    return [_aVersion version];
}

- (NSString *)licenseStyle {
    @synchronized(self) {
        if (_aVersion == nil) {
            _aVersion = [[WSVersion alloc] init];
        }
    }
    return [_aVersion licenseStyle];
}

- (NSString *)UIID {
    @synchronized(self) {
        if (_UIID == nil) {
            _UIID = [[WSVersion UIIDForInstance:self] copy];
        }
    }
    return _UIID;
}




@end
