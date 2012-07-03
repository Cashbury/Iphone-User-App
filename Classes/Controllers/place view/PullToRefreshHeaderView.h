//
//  PullToRefreshHeaderView.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/12/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol HeaderViewDelegate <NSObject>

-(void)goToMapView:(BOOL)isMap;

@end

typedef enum {
	kPullStatusReleaseToReload  = 0,
	kPullStatusPullDownToReload	= 1,
	kPullStatusLoading          = 2,
    kShowSearchBar              = 3,
    kHideSearchBar              = 4
} UIPullToReloadStatus;


@interface PullToRefreshHeaderView : UIView<UISearchBarDelegate>{
    //@private
    UIPullToReloadStatus status;
    BOOL didPull;
}
@property (retain, nonatomic) id<HeaderViewDelegate>delegate;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property () UIPullToReloadStatus status;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIButton *filterButton;
@property (retain, nonatomic) IBOutlet UILabel *refreshLabel;
@property (retain, nonatomic) IBOutlet UIImageView *arrowImgView;

- (void)setStatus:(UIPullToReloadStatus)status animated:(BOOL)animated;

-(void)pullDown:(UIPullToReloadStatus)newstatus table:(UITableView*)tableView animated:(BOOL)animated;

- (IBAction)mapClicked:(id)sender;
-(void)changeLabelToRefresh;
-(void)changeLabelToPull;

@end
