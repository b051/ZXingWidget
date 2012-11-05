//
//  FormatReader+ForSubclass.h
//  ZXingWidget
//
//  Created by Rex Sheng on 11/5/12.
//
//

#import "FormatReader.h"
#import <zxing/common/Counted.h>
#import <zxing/Result.h>
#import <zxing/BinaryBitmap.h>
#import <zxing/Reader.h>
#import <zxing/ResultPointCallback.h>

@interface FormatReader (ForSubclass)

- (id)initWithReader:(zxing::Reader *)reader;
- (zxing::Ref<zxing::Result>)decode:(zxing::Ref<zxing::BinaryBitmap>)grayImage;
- (zxing::Ref<zxing::Result>)decode:(zxing::Ref<zxing::BinaryBitmap>)grayImage andCallback:(zxing::Ref<zxing::ResultPointCallback>)callback;

@end