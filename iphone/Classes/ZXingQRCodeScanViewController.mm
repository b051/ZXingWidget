//
//  ZXingQRCodeScanViewController.m
//
//  Created by Rex Sheng on 6/18/12.
//  Copyright (c) 2012 lognllc.com. All rights reserved.
//

#import "ZXingQRCodeScanViewController.h"
#import <objc/message.h>
#import "QRCodeReader.h"
#import "OverlayView.h"
#import <CoreLocation/CoreLocation.h>

@interface ZXingQRCodeScanViewController () <CLLocationManagerDelegate, ZXingDelegate>
@property (nonatomic, copy) NSString *scanResultCache;
@property (nonatomic, retain) CLLocationManager *locationManager;
@end

@implementation ZXingQRCodeScanViewController

- (id)init
{
	if (self = [super init]) {
		self.wantsFullScreenLayout = YES;
		self.soundToPlay = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"caf"] isDirectory:NO];
		self.delegate = self;
		self.scanWithLocation = YES;
		self.readers = [NSSet setWithObject:[[QRCodeReader alloc] init]];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
	_locationManager.delegate = nil;
}

- (void)finishScan:(NSString *)scanResult withLocation:(CLLocation *)location
{
}

- (void)scanDidCancel
{
}

#pragma mark - ZXingDelegate
- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
	[self scanDidCancel];
}

- (CLLocationManager *)locationManager
{
	if (!_locationManager) {
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = self.desiredAccuracy ?: kCLLocationAccuracyKilometer;
	}
	return _locationManager;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
{
	_desiredAccuracy = desiredAccuracy;
	_locationManager.desiredAccuracy = desiredAccuracy;
}

- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)scan
{
	[self.overlayView removeFromSuperview];
	objc_msgSend(self, @selector(stopCapture));
	if (self.scanWithLocation) {
		if ([CLLocationManager locationServicesEnabled]) {
			self.scanResultCache = scan;
			NSLog(@"start updating location");
			self.locationManager.delegate = self;
			[self.locationManager startUpdatingLocation];
			return;
		}
	}
	[self finishScan:scan withLocation:nil];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	manager.delegate = nil;
	[manager stopUpdatingLocation];

	NSString *scan = self.scanResultCache;
	self.scanResultCache = nil;
	[self finishScan:scan withLocation:locations.lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	manager.delegate = nil;
	[manager stopUpdatingLocation];

	NSString *scan = self.scanResultCache;
	self.scanResultCache = nil;
	[self finishScan:scan withLocation:nil];
}

@end
