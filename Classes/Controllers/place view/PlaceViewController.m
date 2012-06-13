//
//  PlaceViewController.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/7/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PlaceViewController.h"

@interface PlaceViewController ()

@end

@implementation PlaceViewController
@synthesize placesTableview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setPlacesArrayWithValues{
    
    for (int i = 0; i < 3; i ++) {
        
        PlaceView *place    =   [[PlaceView alloc] init];
        switch (i) {
            case 0:
                place.name          =   @"Toast Cafe";
                place.discount      =   @"$5.00 OFF";
                place.icon          =   [UIImage imageNamed:@"toastIcon"];
                place.shopImage     =   [UIImage imageNamed:@"tostcafe"];
                break;
            case 1:
                place.name          =   @"La Boulange";
                place.discount      =   @"$10.00 OFF";
                place.icon          =   [UIImage imageNamed:@"icon_2"];
                place.shopImage     =   [UIImage imageNamed:@"bg_2"];
                break;
            case 2:
                place.name          =   @"Blue Bottle";
                place.discount      =   @"$5.00 OFF";
                place.icon          =   [UIImage imageNamed:@"bbIcon"];
                break;
                
            default:
                break;
        }
        
        [nearPlacesArray addObject:place];
        [place release];
        
    }
    for (int i = 0; i < 3; i ++) {
        
        PlaceView *place    =   [[PlaceView alloc] init];
        switch (i) {
            case 0:
                place.name          =   @"Yoga to the people";
                place.discount      =   @"$5.00 OFF . Open . 230m";
                place.icon          =   [UIImage imageNamed:@"yogaIcon"];
                break;
            case 1:
                place.name          =   @"Mandi Cafe";
                place.discount      =   @"$10.00 OFF . Open . 300m";
                place.icon          =   [UIImage imageNamed:@"icon_1"];
                break;
            case 2:
                place.name          =   @"Jumbo Seafood";
                place.discount      =   @"$5.00 OFF . Closed . 520m";
                place.icon          =   [UIImage imageNamed:@"icon_3"];
                break;
                
            default:
                break;
        }
        
        [farPlacesArray addObject:place];
        [place release];
        
    }
}

#pragma mark - Header view : Pull to refresh
-(void)setHeaderView{
    NSArray* nibViews       = [[NSBundle mainBundle] loadNibNamed:@"PullToRefreshHeaderView" owner:self options:nil];
    
    headerView              =   [nibViews objectAtIndex:0];
    headerView.frame        =   CGRectMake(0.0, -100.0, 320.0, 100.0);
    [self.placesTableview addSubview:headerView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    didSlideDown        =   FALSE;
    nearPlacesArray     =   [[NSMutableArray alloc] init];
    farPlacesArray      =   [[NSMutableArray alloc] init];
    [self setPlacesArrayWithValues];
    [self setHeaderView];
    //[[KZPlacesLibrary shared] requestPlacesWithKeywords:nil];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ValidatePlaceTimer" object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"InvalidatePlaceTimer" object:nil];
}

- (void)viewDidUnload
{
    [self setPlacesTableview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [placesTableview release];
    [nearPlacesArray release];
    [farPlacesArray release];
    [super dealloc];
}

#pragma mark - SwipeDown
-(void)swipeDownView{
    if (didSlideDown) {
        //delete
        didSlideDown    =   FALSE;
        NSArray *indexPath          =   [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil];   
        [placesTableview beginUpdates];
        [placesTableview deleteRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationTop];
        [placesTableview endUpdates];
    }else {
        //add
        didSlideDown    =   TRUE;
        NSArray *indexPath          =   [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil];   
        [placesTableview beginUpdates];
        [placesTableview insertRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationTop];
        [placesTableview endUpdates];
        
    }
}


#pragma mark - Tableview Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if(section == 1)
        return [nearPlacesArray count];
    else {
        return [farPlacesArray count];
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            if (didSlideDown) {
                if (indexPath.row == 0) {
                    return 96;
                }else {
                    return 135;
                }
            }else {
                return 135;
            }
            
            
            break;
        case 1:
            return 55;
            break;
        case 2:
            return 55;
            break;
            
        default:
            break;
    }
    return 55;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else if(section == 1) return @"Places nearby";
    else {
        return @"Places within 500m";
    }
}

#pragma mark Header View : pull to refresh

-(void)stopRefreshing{
    [headerView pullDown:kPullStatusReleaseToReload table:self.placesTableview animated:TRUE];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if ([headerView status] == kPullStatusLoading) return;
	checkForRefresh = YES;  //  only check offset when dragging
} 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([headerView status] == kPullStatusLoading) return;
    
    if (checkForRefresh) {
		if (scrollView.contentOffset.y < -45 && scrollView.contentOffset.y < 0.0f && scrollView.contentOffset.y > -95) {
			[headerView setStatus:kShowSearchBar animated:YES];
			
		} else if (scrollView.contentOffset.y <= -95) {
			[headerView setStatus:kPullStatusPullDownToReload animated:YES];
		}else {
            [headerView setStatus:kHideSearchBar animated:YES];
        }
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if ([headerView status] == kPullStatusLoading) return;
    [headerView pullDown:[headerView status] table:self.placesTableview animated:TRUE];
    if ([headerView status] == kPullStatusPullDownToReload) {
        [self performSelector:@selector(stopRefreshing) withObject:nil afterDelay:3.0];
    }
	checkForRefresh = NO;
}


-(void)checkOutClicked:(id)sender{
    
    UIButton *checkout      =   (UIButton*)sender;
    PlaceView *place        =   [nearPlacesArray objectAtIndex:checkout.tag -1];
    if (checkout.tag == 1) {//toast cafe
        PayementEntryViewController *entryController    =   [[PayementEntryViewController alloc] init];
        entryController.isPinBased                      =   TRUE;
        entryController.placeObject                     =   place;
        [self magnifyViewController:entryController duration:0.35];
    }else if(checkout.tag == 2){//la bounlage
        PayementEntryViewController *entryController    =   [[PayementEntryViewController alloc] init];
        entryController.isPinBased                      =   FALSE;
        entryController.placeObject                     =   place;
        [self magnifyViewController:entryController duration:0.35];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	
	UITableViewCell *cell               =   [tableView dequeueReusableCellWithIdentifier:@"PlacesView"];
    PlacesViewCell *placesCell          =   nil;
    
    
    
    if (indexPath.section == 0) {
        
        placesCell          =   (PlacesViewCell*)[tableView dequeueReusableCellWithIdentifier:@"PlacesViewCell"];
        if (placesCell == nil) {

            placesCell      =   [[PlacesViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacesViewCell"];
        }
 
    }else {
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PlacesView"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            switch (indexPath.section) {
                case 0:
                    cell.textLabel.text =   @"Test";
                    break;
                    
                case 1:{
                    
                    cell.textLabel.font             =   [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                    cell.textLabel.textColor        =   [UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)102/255 blue:(CGFloat)102/255 alpha:1.0];
                    cell.detailTextLabel.font       =   [UIFont fontWithName:@"Helvetica" size:14.0];
                    cell.detailTextLabel.textColor  =   [UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)102/255 blue:(CGFloat)102/255 alpha:1.0];
                    
                    
                    UIButton *checkOut              =   [UIButton buttonWithType:UIButtonTypeCustom];
                    checkOut.tag                    =   indexPath.row+1;
                    checkOut.frame                  =   CGRectMake(230, 15, 81.0, 24.0);
                    if (indexPath.row == 2) {
                        //green
                        [checkOut setImage:[UIImage imageNamed:@"checkOutGreen"] forState:UIControlStateNormal];
                    }else {
                        //yellow
                        [checkOut setImage:[UIImage imageNamed:@"checkOutYellow"] forState:UIControlStateNormal];
                    }

                    [checkOut addTarget:self action:@selector(checkOutClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:checkOut];
                    
                    // to delete 
                    
                }
                    
                    break;
                    
                case 2:{
                    
                    cell.textLabel.font             =   [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                    cell.textLabel.textColor        =   [UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)102/255 blue:(CGFloat)102/255 alpha:1.0];
                    cell.detailTextLabel.font       =   [UIFont fontWithName:@"Helvetica" size:14.0];
                    cell.detailTextLabel.textColor  =   [UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)102/255 blue:(CGFloat)102/255 alpha:1.0];
                    
                }
                    
                    break;
                    
                default:
                    break;
            }
        }
    }

    switch (indexPath.section) {
        case 0:
//            cell.textLabel.text             =   @"";
//            cell.detailTextLabel.text       =   @"";
//            cell.imageView.image            =   nil;
            break;
            
        case 1:{
            PlaceView *place                =   [nearPlacesArray objectAtIndex:indexPath.row];
            cell.textLabel.text             =   place.name;
            cell.detailTextLabel.text       =   place.discount;
            cell.imageView.image            =   place.icon;
        }
            
            break;
            
        case 2:{
            
            PlaceView *place                =   [farPlacesArray objectAtIndex:indexPath.row];
            cell.textLabel.text             =   place.name;
            cell.detailTextLabel.text       =   place.discount;
            cell.imageView.image            =   place.icon;
        }
            
            break;
            
        default:
            break;
    }
    if (indexPath.section == 0) {
            return placesCell;
        
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - KZEngagementHandlerDelegate methods

- (void) willDismissZXing
{
    if (loadingView)
    {
        if (loadingView.view.superview)
        {
            [self diminishViewController:loadingView duration:0];
            
            [loadingView release];
        }
    }
}

#pragma mark - Go to card view

- (IBAction)goToCardView:(id)sender {
    CardViewController *cardController  =   [[CardViewController alloc] init];
    [self magnifyViewController:cardController duration:0.35];
    
}

#pragma mark - Go to scanner
- (IBAction)goToScanner:(id)sender {
    
    loadingView = [[CBMagnifiableViewController alloc] initWithNibName:@"CBLoadScanner" bundle:nil];
    
    [self magnifyViewController:loadingView duration:0.2];
    
    ZXingWidgetController* vc = [KZEngagementHandler snap];
    UINavigationController *zxingnavController  =   [[UINavigationController alloc]initWithRootViewController:vc];
    [vc.navigationController.navigationBar setHidden:TRUE];
    [KZEngagementHandler shared].delegate = self;
    
    if (IS_IOS_5_OR_NEWER)
    {
        [self presentViewController:zxingnavController animated:YES completion:nil];
    }
    else
    {
        [self presentModalViewController:zxingnavController animated:YES];
    }
    [zxingnavController release];
}

#pragma mark - Go to play
- (IBAction)goToPlay:(id)sender {
    
    PlayViewController *playController  =   [[PlayViewController alloc]init];
    playController.tag                  =   FROM_CARDVIEW;
    [self magnifyViewController:playController duration:0.35f];
}
@end
