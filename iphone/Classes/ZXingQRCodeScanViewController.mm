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
@property (nonatomic, retain) NSString *lastScanResult;
@property (nonatomic, retain) CLLocationManager *locationManager;
@end

@implementation ZXingQRCodeScanViewController

@synthesize location=_location, scanWithLocation=_scanWithLocation;
@synthesize lastScanResult, locationManager;

- (id)init
{
	if (self = [super init]) {
		self.wantsFullScreenLayout = YES;
		self.soundToPlay = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"caf"] isDirectory:NO];
		self.delegate = self;
		_scanWithLocation = YES;
		lastScanResult = nil;
		self.readers = [NSSet setWithObject:[[QRCodeReader alloc] init]];
	}
	return self;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	locationManager.delegate = nil;
	locationManager = nil;
}

- (void)finishScan:(NSString *)scanResult
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

- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)scanResult
{
	[self.overlayView removeFromSuperview];
	objc_msgSend(self, @selector(stopCapture));
	if (!_location && _scanWithLocation) {
		if ([CLLocationManager locationServicesEnabled]) {
			if (!locationManager) {
				locationManager = [[CLLocationManager alloc] init];
				locationManager.delegate = self;
				locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
				locationManager.distanceFilter = 500;
			}
			self.lastScanResult = scanResult;
			return [locationManager startUpdatingLocation];
		}
	}
	[self finishScan:scanResult];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSDate* eventDate = newLocation.timestamp;
	NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
	if (abs(howRecent) < 15.0) {
		self.location = newLocation;
		NSLog(@"self = %@", self);
		NSLog(@"lastScanResult = %@", lastScanResult);
		[self finishScan:lastScanResult];
		[locationManager stopUpdatingLocation];
		locationManager.delegate = nil;
		locationManager = nil;
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	[self finishScan:lastScanResult];
}

@end
