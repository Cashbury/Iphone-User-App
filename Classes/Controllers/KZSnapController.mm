//
//  KZSnapController.m
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZSnapController.h"
#import "CocoaQRCodeReader.h"

@interface KZSnapController (Private)
	- (ZXingWidgetController*) snapQRCode;
@end

@implementation KZSnapController


static BOOL is_open = NO;
static KZSnapController* singleton = nil;
@synthesize zxing_vc, delegate, show_cancel;


+ (ZXingWidgetController*) snapWithDelegate:(id<KZSnapHandlerDelegate>)_delegate andShowCancel:(BOOL)_show_cancel {
	if (singleton == nil) {
		singleton = [[KZSnapController alloc] init];
	}
	singleton.delegate = _delegate;
	singleton.show_cancel = _show_cancel;
	return [singleton snapQRCode];
}



- (ZXingWidgetController*) snapQRCode {
	is_open = YES;
	self.zxing_vc = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:self.show_cancel OneDMode:NO];
	QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
	NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
	[qrcodeReader release];
	self.zxing_vc.readers = readers;
	
	[readers release];
	self.zxing_vc.soundToPlay = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
	return [self.zxing_vc autorelease];
}

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    is_open = NO;
    if (self.delegate != nil) [self.delegate didSnapCode:result];
}


- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
	is_open = NO;
	if (self.delegate != nil) [self.delegate didCancelledSnapping];
}


+ (void) cancel {
	if (is_open) {
		is_open = NO;
		[singleton.zxing_vc cancelled];
	}
}


@end
