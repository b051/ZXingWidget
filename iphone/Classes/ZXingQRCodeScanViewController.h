//
//  ZXingQRCodeScanViewController.h
//
//  Created by Rex Sheng on 6/18/12.
//  Copyright (c) 2012 lognllc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"

@class CLLocation;
@class OverlayView;

@interface ZXingQRCodeScanViewController : ZXingWidgetController

@property (nonatomic, retain) OverlayView *overlayView;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic) BOOL scanWithLocation;

- (void)finishScan:(NSString *)scanResult;
- (void)scanDidCancel;

@end
