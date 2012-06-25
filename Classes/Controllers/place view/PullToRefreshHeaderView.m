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
    [self.activityIndicator setHidesWhenStopped:TRUE];
    [self.activityIndicator setHidden:TRUE];
    
    //filter butotn
    self.filterButton.layer.borderColor =   [UIColor colorWithRed:(CGFloat)204/255 green:(CGFloat)204/255 blue:(CGFloat)204/255 alpha:1.0].CGColor;
    self.filterButton.layer.borderWidth     =   1.0;
    self.filterButton.layer.cornerRadius    =   5.0;
    
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


#pragma mark Pull Down

-(void)pullDown:(UIPullToReloadStatus)newstatus table:(UITableView*)tableView animated:(BOOL)animated{
    [self setStatus:newstatus animated: animated];
    CGFloat xvalue  =   0;
    switch (newstatus) {
        case kShowSearchBar:
            xvalue          =   46.0;
            break;
        case kPullStatusPullDownToReload:
            self.activityIndicator.hidden   =   FALSE;
            [self.activityIndicator startAnimating];
            
            xvalue          =   112.0;
            break;
        case kPullStatusReleaseToReload:
            self.activityIndicator.hidden   =   TRUE;
            [self.activityIndicator stopAnimating];
            xvalue          =   46.0;
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
    [super dealloc];
}
@end
