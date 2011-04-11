//
//  LoadingViewController.h
//  Cashbury
//
//  Created by Basayel Said on 3/22/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingViewController : UIViewController {
	IBOutlet UILabel *lblMessage;
	IBOutlet UIActivityIndicatorView *loading;
}

@property (retain, nonatomic) IBOutlet UILabel *lblMessage;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@end
