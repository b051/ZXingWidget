//
//  ZXingWidgetQRCodeScannerController.h
//
//  Created by Rex Sheng on 6/18/12.
//  Copyright (c) 2012 lognllc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"

@class CLLocation;
@class OverlayView;

@interface ZXingWidgetQRCodeScannerController : ZXingWidgetController

@property (nonatomic, strong) OverlayView *overlayView;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic) BOOL scanWithLocation;

@end