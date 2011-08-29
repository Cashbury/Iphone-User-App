//
//  CardIOPaymentViewControllerDelegate.h
//

#import <Foundation/Foundation.h>

@class CardIOPaymentViewController;
@class CardIOCreditCardInfo;

@protocol CardIOPaymentViewControllerDelegate<NSObject>

// The result of the payment entry. Precisely one of the three methods below will be called.
// In all cases, it is your responsibility to dismiss the CardIOPaymentViewController.

@required

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController;

@optional // only for the purposes of graceful deprecation

// Treat this method as @required. It will become required in an upcoming release.
- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController;

// Deprecated; use userDidProvideCreditCardInfo:inPaymentViewController: instead.
- (void)userDidProvideCreditCardNumber:(NSString *)number
                           expiryMonth:(NSUInteger)month
                            expiryYear:(NSUInteger)year
                                   cvv:(NSString *)cvv
               inPaymentViewController:(CardIOPaymentViewController *)paymentViewController;

@end
