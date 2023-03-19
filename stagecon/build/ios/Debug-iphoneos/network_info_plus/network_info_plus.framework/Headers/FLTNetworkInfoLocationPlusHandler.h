// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FLTNetworkInfoLocationPlusDelegate;

typedef void (^FLTNetworkInfoLocationPlusCompletion)(CLAuthorizationStatus);

@interface FLTNetworkInfoLocationPlusHandler : NSObject

+ (CLAuthorizationStatus)locationAuthorizationStatus;

- (void)requestLocationAuthorization:(BOOL)always
                          completion:
                              (_Nonnull FLTNetworkInfoLocationPlusCompletion)
                                  completionHnadler;

@end

NS_ASSUME_NONNULL_END
