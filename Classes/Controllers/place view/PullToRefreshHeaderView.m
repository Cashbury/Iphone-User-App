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
@synthesize status;
@synthesize activityIndicator;
@synthesize filterButton;
@synthesize refreshLabel;
@synthesize arrowImgView;
@synthesize lensView;
@synthesize searchBarView;
@synthesize searchTextField;
@synthesize searchBgView;
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
    didPull     =   FALSE;
    self.searchTextField.delegate   =   self;
    [self.activityIndicator setHidesWhenStopped:TRUE];
    [self.activityIndicator setHidden:TRUE];
    self.arrowImgView.transform =   CGAffineTransformRotate(self.arrowImgView.transform, 180*M_PI/180);
    
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

- (IBAction)filterClicked:(id)sender {
    if ([self.searchTextField isFirstResponder]) {
        [self resignBackSearchBar];
    }
}

-(void)resignBackSearchBar{
    [UIView animateWithDuration:0.3 animations:^{
        self.searchBarView.frame        =   CGRectMake(61.0,  self.searchBarView.frame.origin.y, 196.0,  self.searchBarView.frame.size.height);
        self.searchBgView.frame         =   CGRectMake(self.searchBgView.frame.origin.x,  self.searchBgView.frame.origin.y, 186.0,  self.searchBgView.frame.size.height);
        self.searchTextField.frame      =   CGRectMake(14.0,  self.searchTextField.frame.origin.y, 170.0,  self.searchTextField.frame.size.height);
        self.lensView.frame             =   CGRectMake(80.0,  self.lensView.frame.origin.y, self.lensView.frame.size.width,  self.lensView.frame.size.height);
        
    }completion:^(BOOL f){
        [[self filterButton] setImage:[UIImage imageNamed:@"place_filter"] forState:UIControlStateNormal];
    }];
}

#pragma TextFiled Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.searchBarView.frame        =   CGRectMake(1.0,  self.searchBarView.frame.origin.y, 255.0,  self.searchBarView.frame.size.height);
        self.searchBgView.frame         =   CGRectMake(self.searchBgView.frame.origin.x,  self.searchBgView.frame.origin.y, 245.0,  self.searchBgView.frame.size.height);
        self.searchTextField.frame      =   CGRectMake(40.0,  self.searchTextField.frame.origin.y, 200.0,  self.searchTextField.frame.size.height);
        self.lensView.frame             =   CGRectMake(13.0,  self.lensView.frame.origin.y, self.lensView.frame.size.width,  self.lensView.frame.size.height);
    }completion:^(BOOL f){
        [[self filterButton] setImage:[UIImage imageNamed:@"search_cancel"] forState:UIControlStateNormal];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignBackSearchBar];
    [textField resignFirstResponder];
    return TRUE;
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
    [statusLabel release];
    [activityIndicator release];
    [delegate release];
    [filterButton release];
    [refreshLabel release];
    [arrowImgView release];
    [lensView release];
    [searchBarView release];
    [searchTextField release];
    [searchBgView release];
    [super dealloc];
}
@end
