//
//  CardIOCreditCardInfo.h
//

#import <Foundation/Foundation.h>

typedef enum {
  CardIOCreditCardTypeUnknown = 0,
  CardIOCreditCardTypeAmex = '3',
  CardIOCreditCardTypeVisa = '4',
  CardIOCreditCardTypeMastercard = '5',
  CardIOCreditCardTypeDiscover = '6'
} CardIOCreditCardType;


@interface CardIOCreditCardInfo : NSObject {
@private
  NSString *cardNumber;
  NSUInteger expiryMonth;
  NSUInteger expiryYear;
  NSString *cvv;
  NSString *zip;
}

- (NSString *)redactedCardNumber; // card number with all but the last four digits obfuscated

@property(nonatomic, retain, readwrite) NSString *cardNumber;

// expiryMonth & expiryYear may be 0 if expiry information is not collected
@property(nonatomic, assign, readwrite) NSUInteger expiryMonth; // January == 1
@property(nonatomic, assign, readwrite) NSUInteger expiryYear; // the full four digit year

@property(nonatomic, retain, readwrite) NSString *cvv; // may be nil, if the cvv is not requested from the user

@property(nonatomic, retain, readwrite) NSString *zip; // may be nil, if the zip is not requested from the user

// Derived from cardNumber
@property(nonatomic, assign, readonly) CardIOCreditCardType cardType;

// Convenience method to return a card type string (e.g. "Visa") suitable for display. Currently English only.
+ (NSString *)displayStringForCardType:(CardIOCreditCardType)cardType;

@end
