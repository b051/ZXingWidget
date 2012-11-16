//
//  ZXingWidgetQRCodeScannerController.m
//
//  Created by Rex Sheng on 6/18/12.
//  Copyright (c) 2012 lognllc.com. All rights reserved.
//

#import "ZXingWidgetQRCodeScannerController.h"
#import <objc/message.h>
#import "QRCodeReader.h"
#import "OverlayView.h"
#import <CoreLocation/CoreLocation.h>

@interface ZXingWidgetQRCodeScannerController () <CLLocationManagerDelegate, ZXingDelegate>
@end

@implementation ZXingWidgetQRCodeScannerController
{
	NSString *lastScanResult;
	CLLocationManager *locationManager;
	NSDictionary *locatedPet;
	__unsafe_unretained id<ZXingDelegate> myDelegate;
}

- (id)init
{
	if (self = [super init]) {
		self.wantsFullScreenLayout = YES;
		self.soundToPlay = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"caf"] isDirectory:NO];
		self.delegate = self;
		_scanWithLocation = YES;
		self.readers = [NSSet setWithObject:[[QRCodeReader alloc] init]];
	}
	return self;
}

- (void)setDelegate:(id<ZXingDelegate>)_delegate
{
	delegate = self;
	myDelegate = _delegate;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	locationManager.delegate = nil;
	locationManager = nil;
}

- (void)saveLocation:(CLLocation *)location
{
	_location = location;
	[myDelegate zxingController:self didScanResult:lastScanResult];
}

#pragma mark - ZXingDelegate
- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
	[myDelegate zxingControllerDidCancel:self];
}

-(void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)scanResult
{
	[self.overlayView removeFromSuperview];
	objc_msgSend(self, @selector(stopCapture));
	lastScanResult = scanResult;
	if (_location || !_scanWithLocation) {
		[self saveLocation:_location];
		return;
	}
	if ([CLLocationManager locationServicesEnabled]) {
		if (!locationManager) {
			locationManager = [[CLLocationManager alloc] init];
			locationManager.delegate = self;
			locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
			locationManager.distanceFilter = 500;
		}
		[locationManager startUpdatingLocation];
	} else {
		[self saveLocation:nil];
	}
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSDate* eventDate = newLocation.timestamp;
	NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
	if (abs(howRecent) < 15.0) {
		[self saveLocation:newLocation];
		[locationManager stopUpdatingLocation];
		locationManager.delegate = nil;
		locationManager = nil;
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	[self saveLocation:nil];
}

@end
