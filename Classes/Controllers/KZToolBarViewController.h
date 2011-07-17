//
//  KZToolBarViewController.h
//  Cashbery
//
//  Created by Basayel Said on 7/4/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KZToolBarViewController : UIViewController {
	
}

@property (nonatomic, assign) UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet UIButton *btn_snapit;
@property (nonatomic, retain) IBOutlet UIButton *btn_cards;
@property (nonatomic, retain) IBOutlet UIButton *btn_places;
@property (nonatomic, retain) IBOutlet UIButton *btn_inbox;
@property (nonatomic, retain) IBOutlet UIButton *btn_cashburies;

@property (nonatomic, retain) IBOutlet UILabel *lbl_snapit;
@property (nonatomic, retain) IBOutlet UILabel *lbl_places;
@property (nonatomic, retain) IBOutlet UILabel *lbl_inbox;
@property (nonatomic, retain) IBOutlet UILabel *lbl_cashburies;

- (IBAction) inboxAction;
- (IBAction) cashburiesAction;
- (IBAction) snapItAction;
- (IBAction) showCardsAction;
- (IBAction) showPlacesAction;
- (void) hideToolBar;
- (void) showToolBar:(UINavigationController*)_vc;

@end
