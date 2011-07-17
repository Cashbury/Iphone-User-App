//
//  KZMainCashburiesViewController.h
//  Cashbery
//
//  Created by Basayel Said on 7/14/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZRewardViewController.h"
#import "KZReward.h"
#import "KZReloadableDelegate.h"

@interface KZMainCashburiesViewController : UIViewController <KZReloadableDelegate> {

}

@property (nonatomic, retain) IBOutlet UIScrollView *verticalScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray* viewControllers;
@property (nonatomic, retain) KZReward *current_reward;
@property (nonatomic, retain) NSArray *rewards;

@end
