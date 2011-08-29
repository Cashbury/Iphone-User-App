//
//  CardIOPaymentViewController.h
//

#import <UIKit/UIKit.h>
#import "CardIOPaymentViewControllerDelegate.h"
#import "CardIOCreditCardInfo.h"

@interface CardIOPaymentViewController : UINavigationController {
@private
  id<CardIOPaymentViewControllerDelegate> paymentDelegate;
  NSString *appToken;
  BOOL collectExpiry;
  BOOL collectCVV;
  BOOL collectZip;
  BOOL showsFirstUseAlert;
}

// The designated initializer.
- (id)initWithPaymentDelegate:(id<CardIOPaymentViewControllerDelegate>)aDelegate;

// Initializer for testing. Setting forceManualEntry to YES will prevent use of the camera.
- (id)initWithPaymentDelegate:(id<CardIOPaymentViewControllerDelegate>)aDelegate forceManualEntry:(BOOL)forceManualEntry;

// Use this to set your app token. If not set before presenting the view controller, an exception will be thrown.
@property(nonatomic, copy, readwrite) NSString *appToken;

// Set to NO if you don't need to collect the card expiration. Defaults to YES.
@property(nonatomic, assign, readwrite) BOOL collectExpiry;

// Set to NO if you don't need to collect the CVV from the user. Defaults to YES.
@property(nonatomic, assign, readwrite) BOOL collectCVV;

// Set to YES if you need to collect the billing zip code. Defaults to NO.
@property(nonatomic, assign, readwrite) BOOL collectZip;

// Set to NO if you want to suppress the first-time how-to alert view. Defaults to YES.
@property(nonatomic, assign, readwrite) BOOL showsFirstUseAlert;

// Access to the delegate.
@property(nonatomic, assign, readwrite) id<CardIOPaymentViewControllerDelegate> paymentDelegate;

// Indicates whether this device supports camera-based card entry, including
// factors like hardware support, OS version, and network connectivity.
// CardIO automatically provides manual entry of cards as a fallback, so it is
// not necessary to check this.
+ (BOOL)canReadCardWithCamera;

// Please send the output of this method with any technical support requests.
+ (NSString *)libraryVersion;

@end
