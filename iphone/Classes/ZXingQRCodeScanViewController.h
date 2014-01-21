//
//  ZXingQRCodeScanViewController.h
//
//  Created by Rex Sheng on 6/18/12.
//  Copyright (c) 2012 lognllc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import <CoreLocation/CoreLocation.h>

@class OverlayView;

@interface ZXingQRCodeScanViewController : ZXingWidgetController

@property (nonatomic, retain) OverlayView *overlayView;
@property (nonatomic) BOOL scanWithLocation;
@property (nonatomic) CLLocationAccuracy desiredAccuracy;

- (void)finishScan:(NSString *)scanResult withLocation:(CLLocation *)location;
- (void)scanDidCancel;

@end
