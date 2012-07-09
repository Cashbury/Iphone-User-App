//
//  PullToRefreshHeaderView.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/12/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PullToRefreshHeaderView.h"

@implementation PullToRefreshHeaderView
@synthesize statusLabel;
@synthesize searchBar;
@synthesize status;
@synthesize activityIndicator;
@synthesize filterButton;
@synthesize refreshLabel;
@synthesize arrowImgView;
@synthesize delegate;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor    =   [UIColor redColor];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.searchBar.delegate =   self;
    didPull     =   FALSE;
    [self.activityIndicator setHidesWhenStopped:TRUE];
    [self.activityIndicator setHidden:TRUE];
    self.arrowImgView.transform =   CGAffineTransformRotate(self.arrowImgView.transform, 180*M_PI/180);
    
    // Drawing code
    for (UIView *subview in searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    
}

- (void)setStatus:(UIPullToReloadStatus)newStatus animated:(BOOL) animated {
	if (status == newStatus) return;	
	status = newStatus;
}

-(void)changeLabelToRefresh{
    if (didPull == FALSE) {
        didPull =   TRUE;
        self.refreshLabel.text  =   @"RELEASE TO REFRESH..."; 
        [UIView animateWithDuration:0.1 animations:^{
            self.arrowImgView.transform =   CGAffineTransformRotate(self.arrowImgView.transform, 180*M_PI/180);
        }];
    }
   
    
}
-(void)changeLabelToPull{
    self.arrowImgView.hidden    =   FALSE;
    if (didPull) {
        self.activityIndicator.hidden   =   TRUE;
        [self.activityIndicator stopAnimating];
        didPull     =   FALSE;
        self.refreshLabel.text  =   @"PULL DOWN TO REFRESH..."; 
        [UIView animateWithDuration:0.1 animations:^{
            self.arrowImgView.transform =   CGAffineTransformRotate(self.arrowImgView.transform, 180*M_PI/180);
        }];
    }
    
}


#pragma mark Pull Down

-(void)pullDown:(UIPullToReloadStatus)newstatus table:(UITableView*)tableView animated:(BOOL)animated{
    [self setStatus:newstatus animated: animated];
    CGFloat xvalue  =   0;
    switch (newstatus) {
        case kShowSearchBar:
            xvalue          =   46.0; 
            self.arrowImgView.hidden        =   FALSE;
            break;
        case kPullStatusPullDownToReload:
            self.activityIndicator.hidden   =   FALSE;
            [self.activityIndicator startAnimating];
            self.refreshLabel.text          =   @"LOADING...";
            self.arrowImgView.hidden        =   TRUE;
            xvalue          =   115.0;
            break;
            
        case kHideSearchBar:
            xvalue          =   0.0;
            
        default:
            break;
    }
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [tableView setContentInset:UIEdgeInsetsMake(xvalue, 0.0f, 0.0f, 0.0f)]; 
        }];
    }else {
        [tableView setContentInset:UIEdgeInsetsMake(xvalue, 0.0f, 0.0f, 0.0f)];
    }
}

#pragma  mark Searchbar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)msearchBar{
    [msearchBar setText:@""];
    [msearchBar resignFirstResponder];
}

- (IBAction)mapClicked:(id)sender {
    UIButton *map   =   (UIButton*)sender;
    if (map.selected) {
        map.selected    =   FALSE;
        [delegate goToMapView:FALSE];
    }else {
        map.selected    =   TRUE;
        [delegate goToMapView:TRUE];
    }
}


- (void)dealloc {
    [searchBar release];
    [statusLabel release];
    [activityIndicator release];
    [delegate release];
    [filterButton release];
    [refreshLabel release];
    [arrowImgView release];
    [super dealloc];
}
@end
