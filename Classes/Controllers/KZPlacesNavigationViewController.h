//
//  KZPlacesNavigationViewController.h
//  Cashbery
//
//  Created by Basayel Said on 6/20/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KZPlacesNavigationViewController : UIViewController {

}

// Toolbar
@property (nonatomic, retain) IBOutlet UIButton *place_btn;
@property (nonatomic, retain) IBOutlet UIButton *other_btn;
- (IBAction) didTapInfoButton:(id)theSender;
- (IBAction) goBack:(id)theSender;

@end
