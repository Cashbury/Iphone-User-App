//
//  LegalTermsViewController.h
//  Cashbury
//
//  Created by Basayel Said on 4/17/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LegalTermsViewController : UIViewController {
	IBOutlet UITextView *textView;
}
@property (nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction)hideLegalTerms:(id)theSender;

@end
