//
//  PlaceViewController.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/7/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#define PLACE_100M       @"Places1"
#define PLACE_250M       @"Places2"
#define PLACE_500M       @"Places3"
#define PLACE_1KM       @"Places4"
#define PLACE_2KM       @"Places5"
#define PLACE_5KM       @"Places6"
#define PLACE_10KM       @"Places7"

#import "PlaceViewController.h"
#import "ScannedViewControllerViewController.h"
#import "PayementEntryViewController.h"
#import "ContactDetails.h"

@interface PlaceViewController ()

@end

@implementation PlaceViewController
@synthesize mapContainerView;
@synthesize placesTableview;
@synthesize cardviewButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
-(void)setPlacesArrayWithValues{
    
    for (int i = 0; i < 3; i ++) {
        
        PlaceView *place    =   [[PlaceView alloc] init];
        switch (i) {
            case 0:
                place.name          =   @"Toast Cafe";
                place.discount      =   @"$5.00 OFF";
                place.address       =   @"1601, Polk St. San Francisco";
                place.icon          =   [UIImage imageNamed:@"toastIcon"];
                place.shopImage     =   [UIImage imageNamed:@"tostcafe"];
                break;
            case 1:
                place.name          =   @"La Boulange";
                place.discount      =   @"$10.00 OFF";
                place.address       =   @"500 Hayes St. San Francisco";
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
}*/

#pragma mark - Header view : Pull to refresh
-(void)setHeaderView{
    NSArray* nibViews       = [[NSBundle mainBundle] loadNibNamed:@"PullToRefreshHeaderView" owner:self options:nil];
    
    headerView              =   [nibViews objectAtIndex:0];
    headerView.frame        =   CGRectMake(0.0, -115.0, 320.0, 115.0);
    headerView.delegate     =   self;
    [self.placesTableview addSubview:headerView];
}

#pragma mark MapView
-(void)goToMapView:(BOOL)isMap{
    if (isMap) {
        //show map
        self.mapContainerView.hidden        =   FALSE;
    }else {
        //hide map
        self.mapContainerView.hidden        =   TRUE;
    }
}

-(NSString*)getContactDetails:(NSString*)component code:(NSString*)qrCode{
    NSString *original                  =   @"";
    NSRange cRange                      =   [qrCode rangeOfString:component options:NSCaseInsensitiveSearch];
    if (cRange.length > 0){
        NSArray *firstString            =   [qrCode componentsSeparatedByString:component];
        if ([firstString count] > 0) {
            NSString *restString        =   [firstString lastObject];
            NSArray *secondString       =   [restString componentsSeparatedByString:@";"];
            if ([secondString count] > 0) {
                original                =   [secondString objectAtIndex:0];
                return original;
            }
        }
    }
    return original;
}

-(void)saveDateTime:(ContactDetails*)details{
    NSDate *date                    =   [NSDate date];
    NSDateFormatter *formatter      =   [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMMM dd yyyy"];
    details.date                    =   [formatter stringFromDate:date];
    [formatter setDateFormat:@"HH:mm aa"];
    details.time                    =   [formatter stringFromDate:date];
    [formatter release];
    
    
}

-(void)didScanQRCode:(NSNotification*)noti{
    NSString *qrCode            =   noti.object;
    if ([qrCode hasPrefix:CASHBURY_SCAN_QRCODE_IDENTIFICATION]) {
        //
        PlaceView *placeView                            =   [[PlaceView alloc]init];
        placeView.name                                  =   @"Martin's Taxi";
        placeView.shopImage                             =   [UIImage imageNamed:@"martin_cover"];
        placeView.icon                                  =   [UIImage imageNamed:@"martin_icon"];
        
        PayementEntryViewController *entryController    =   [[PayementEntryViewController alloc]init];
        entryController.placeObject                     =   placeView;
        [self magnifyViewController:entryController duration:0.35f];
        [placeView release];
        
    }else{
        NSLog(@"Code %@",qrCode);
        ContactDetails *contact                         =   [[ContactDetails alloc] init];
        
        
        
        ScannedViewControllerViewController *scanned    =   [[ScannedViewControllerViewController alloc] init];
        scanned.tag                                     =   SCAN_TAG_AFTERSCANNING;
        contact.qrcode                                  =   qrCode;
        if([[qrCode lowercaseString] hasPrefix:@"http://"])// url
        {
            contact.url         =   [qrCode lowercaseString];
            contact.type        =   SCAN_TYPE_WEB;
        }
        else if([[qrCode lowercaseString] hasPrefix:@"tel:"])//number
        {
            contact.type        =   SCAN_TYPE_PHONE;
            NSString *tempTel   =   @"";
            NSArray *telArray   =   [qrCode componentsSeparatedByString:@":"];
            if ([telArray count] > 0) {
                tempTel         =   [telArray lastObject];
            }
            contact.mobile      =   tempTel;  
        }
        else if([[qrCode lowercaseString] hasPrefix:@"mecard:"])//contact
        {
            contact.type        =   SCAN_TYPE_CONTACT;
            contact.name        =   [self getContactDetails:@"N:" code:qrCode];
            contact.mobile      =   [self getContactDetails:@"TEL:" code:qrCode];
            contact.email       =   [self getContactDetails:@"EMAIL:" code:qrCode];
            contact.address     =   [self getContactDetails:@"ADR:" code:qrCode];
            contact.url         =   [self getContactDetails:@"URL:" code:qrCode];
        }
        else if([[qrCode lowercaseString] hasPrefix:@"mailto:"])//mail
        {
            contact.type        =   SCAN_TYPE_EMAIL;
            NSString *tempEmail =   @"";
            NSArray *emailArray =   [qrCode componentsSeparatedByString:@":"];
            if ([emailArray count] > 0) {
                tempEmail       =   [emailArray lastObject];
            }
            contact.email       =   tempEmail;
            
        }else {//text
            contact.type        =   SCAN_TYPE_TEXT;
            contact.name        =   [qrCode lowercaseString];
        }
        [self saveDateTime:contact];
        scanned.contact         =   contact;
        [appDelegate.scanHistoryArray addObject:contact];
        [contact release];
        [self magnifyViewController:scanned duration:0.35];
    }
    
}

#pragma mark ParsePlaces


// To be deleted
-(void)setCafeBlanc{
    PlaceView *placeView    =   [[PlaceView alloc] init];
    placeView.name          =   @"Cafe Blanc";
    placeView.smallImgURL   =   @"http://s3.amazonaws.com/cashbury-pro/brands/78/normal/cafeblanc.png";
    placeView.discount      =   @"$5.00 OFF";
    placeView.address       =   @"acherafieh";
    placeView.businessID    =   10;
    placeView.latitude      =   33.8883082743;
    placeView.longitude     =   35.5169370721;
    placeView.isOpen        =   FALSE;
    placeView.distance      =   @"20";
    placeView.isNear        =   TRUE;
    [appDelegate.placesArray addObject:placeView];
    [placeView release];
    
    
    //star bucks
    PlaceView *placeView1   =   [[PlaceView alloc] init];
    placeView1.name         =   @"Starbucks";
    placeView1.smallImgURL  =   @"http://s3.amazonaws.com/cashbury-pro/brands/74/normal/starbucks.png";
    placeView1.discount     =   @"$5.00 OFF";
    placeView1.isOpen       =   FALSE;
    placeView1.distance     =   @"30";
    placeView1.latitude     =   33.8957733822;
    placeView1.longitude    =   35.4816231095;
    placeView1.businessID   =   4;
    placeView1.about        =   @"An international Coffee House";
    placeView1.isNear       =   TRUE;
    placeView1.address      =   @"Hamra Jeanne Darc";
    [appDelegate.placesArray addObject:placeView1];
    [placeView1 release];
    
}

#pragma mark UpdatePlaces
-(void)updatePlacesView{

    
    [self setCafeBlanc];

    for (int i = 0; i < [appDelegate.placesArray count]; i ++) {
        PlaceView *tempView     =   [appDelegate.placesArray objectAtIndex:i];
        if ([tempView.distance floatValue] < 100.0) {
            //near by
            [[placesDict objectForKey:@"Places1"] addObject:tempView];  
        }else if([tempView.distance floatValue] > 100.0 && [tempView.distance floatValue] < 250.0){
            [[placesDict objectForKey:@"Places2"] addObject:tempView]; 
        }else if([tempView.distance floatValue] > 250.0 && [tempView.distance floatValue] < 500.0){
            [[placesDict objectForKey:@"Places3"] addObject:tempView]; 
        }else if([tempView.distance floatValue] > 500.0 && [tempView.distance floatValue] < 1000.0){
            [[placesDict objectForKey:@"Places4"] addObject:tempView]; 
        }else if([tempView.distance floatValue] > 1000.0 && [tempView.distance floatValue] < 2000.0){
            [[placesDict objectForKey:@"Places5"] addObject:tempView]; 
        }else if([tempView.distance floatValue] > 2000.0 && [tempView.distance floatValue] < 5000.0){
            [[placesDict objectForKey:@"Places6"] addObject:tempView]; 
        }else {
            [[placesDict objectForKey:@"Places7"] addObject:tempView]; 
        }

        
    }
    
    [self.placesTableview reloadData];
    UIView *loadView            =   (UIView*)[self.view viewWithTag:300];
    UIView *mainView            =   (UIView*)[self.view viewWithTag:200];
    mainView.frame              =   CGRectMake(mainView.frame.origin.x, -480, mainView.frame.size.width, mainView.frame.size.height);
    
    [UIView animateWithDuration:0.5 animations:^{
        loadView.frame          =   CGRectMake(loadView.frame.origin.x, 480, loadView.frame.size.width, loadView.frame.size.height);
        mainView.frame          =   CGRectMake(mainView.frame.origin.x, 0, mainView.frame.size.width, mainView.frame.size.height);
    }completion:^(BOOL finished){
        [(UIActivityIndicatorView*)[loadView viewWithTag:10] stopAnimating];
        
    }];
    
}

#pragma mark animateCellBack
-(void)animateCellback{
    if (nPath != nil) {
        UITableViewCell *cell   =   [self.placesTableview cellForRowAtIndexPath:nPath];
        
        [UIView animateWithDuration:0.2 delay:0.0 options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction) animations:^{
            cell.transform                  =   CGAffineTransformMakeScale(0.9f, 0.9f);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.2 delay:0.0 options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction) animations:^{
                cell.transform              =   CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished){
            }];
            
        }];
        [nPath release];
        nPath   =   nil;
        
    }
    
}



#pragma mark Scanner History
-(void)removeScannerHisory{

    [self willDismissZXing];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[KZPlacesLibrary shared] requestPlacesWithKeywords:nil];
    appDelegate         =   [[UIApplication sharedApplication] delegate];
    //isMapviewExpand     =   TRUE;
    receivedData        =   [[NSMutableData alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didScanQRCode:) name:@"DidScanCashburyUniqueCard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeScannerHisory) name:@"DiscardScannerHistoryToMainView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlacesView) name:@"UpdatePlacesView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateCellback) name:@"AnimateCellBack" object:nil];
    placesDict          =   [[NSMutableDictionary alloc]init];
    for (int i = 0; i < 7; i++) {
        NSMutableArray *array   =   [[NSMutableArray alloc] init];
        
        [placesDict setObject:array forKey:[NSString stringWithFormat:@"Places%d",i+1]];
        [array release];
                
    }
    nPath   =   nil;
    
    [self setHeaderView];
    //[self setPlacesArrayWithValues];
    //[[KZPlacesLibrary shared] requestPlacesWithKeywords:nil];

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
    [self setMapContainerView:nil];
    [self setCardviewButton:nil];
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
    [mapContainerView release];
    [receivedData release];
    [placesDict release];
    [cardviewButton release];
    [super dealloc];
}




#pragma mark - Tableview Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else {
        return [[placesDict objectForKey:[NSString stringWithFormat:@"Places%d",section]] count];
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        if (isMapviewExpand) {
            return 311;
        }else {
            return 135;
        }
    }
    return 62;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else {
        if ([[placesDict objectForKey:[NSString stringWithFormat:@"Places%d",section]] count] > 0) {
            return 20;
        }else {
            return 0;
        }
        
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else {
        if ([[placesDict objectForKey:[NSString stringWithFormat:@"Places%d",section]] count] > 0){
            UIView *header          =   [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 20.0)];
            header.backgroundColor  =   [UIColor colorWithRed:(CGFloat)211/255 green:(CGFloat)211/255 blue:(CGFloat)211/255 alpha:1.0];
            
            UILabel *titleLabel             =   [[UILabel alloc]initWithFrame:CGRectMake(10.0, 0.0, 300.0, 20.0)];
            titleLabel.font                 =   [UIFont fontWithName:@"Helvetica" size:12.0];
            titleLabel.textColor            =   [UIColor whiteColor];
            switch (section) {
                case 1:
                    titleLabel.text         =   @"Places nearby";
                    break;
                
                case 2:
                    titleLabel.text         =   @"Places within 250m";
                    break;
                case 3:
                    titleLabel.text         =   @"Places within 500m";
                    break;
                case 4:
                    titleLabel.text         =   @"Places within 1km";
                    break;
                case 5:
                    titleLabel.text         =   @"Places within 2km";
                    break;
                case 6:
                    titleLabel.text         =   @"Places within 5km";
                    break;
                case 7:
                    titleLabel.text         =   @"Places within 10km";
                    break;

                default:
                    break;
            }
            
            titleLabel.textAlignment        =   UITextAlignmentLeft;
            titleLabel.backgroundColor      =   [UIColor clearColor];
            [header addSubview:titleLabel];
            [titleLabel release];
            
            return [header autorelease];
        }else {
            return nil;
        }
        
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	UITableViewCell *cell               =   [tableView dequeueReusableCellWithIdentifier:@"PlacesView"];
    PlacesViewCell *placesCell          =   nil;
    
    
    
    if (indexPath.section == 0) {
        
        placesCell          =   (PlacesViewCell*)[tableView dequeueReusableCellWithIdentifier:@"PlacesViewCell"];
        if (placesCell == nil) {
            
            placesCell      =   [[PlacesViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacesViewCell"];
            placesCell.mapdelegate  =   self;
            
        }
        
        
    }else {
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PlacesView"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor    =   [UIColor redColor];
            
            
            if (indexPath.section ==  1){
                PlaceView *place                =   (PlaceView*)[[placesDict objectForKey:@"Places1"] objectAtIndex:indexPath.row];
                //name
                UILabel *nameLabel              =   [[UILabel alloc]initWithFrame:CGRectMake(66.0, 8.0, 160.0, 20.0)];
                nameLabel.font                  =   [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                nameLabel.textColor             =   [UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)102/255 blue:(CGFloat)102/255 alpha:1.0];
                nameLabel.text                  =   place.name;
                nameLabel.textAlignment         =   UITextAlignmentLeft;
                nameLabel.backgroundColor       =   [UIColor clearColor];
                [cell.contentView addSubview:nameLabel];
                [nameLabel release];
                
                //adress
                UILabel *addressLabel           =   [[UILabel alloc]initWithFrame:CGRectMake(66.0, 28.0, 160.0, 15.0)];
                addressLabel.font               =   [UIFont fontWithName:@"Helvetica" size:14.0];
                addressLabel.textColor          =   [UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)102/255 blue:(CGFloat)102/255 alpha:1.0];
                addressLabel.text               =   place.address;
                addressLabel.textAlignment      =   UITextAlignmentLeft;
                addressLabel.backgroundColor    =   [UIColor clearColor];
                [cell.contentView addSubview:addressLabel];
                [addressLabel release];
                
                //detail
                UILabel *detailLabel            =   [[UILabel alloc]initWithFrame:CGRectMake(66.0, 43.0, 160.0, 14.0)];
                detailLabel.font                =   [UIFont fontWithName:@"Helvetica" size:12.0];
                detailLabel.textColor           =   [UIColor colorWithRed:(CGFloat)204/255 green:(CGFloat)204/255 blue:(CGFloat)204/255 alpha:1.0];
                detailLabel.text                =   place.about;
                detailLabel.textAlignment       =   UITextAlignmentLeft;
                detailLabel.backgroundColor     =   [UIColor clearColor];
                [cell.contentView addSubview:detailLabel];
                [detailLabel release];
                
                
                //discount
                UILabel *discountLabel          =   [[UILabel alloc]initWithFrame:CGRectMake(235.0, 40.0, 80.0, 14.0)];
                discountLabel.font              =   [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                discountLabel.textColor         =   [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1.0];
                discountLabel.text              =   place.discount;
                discountLabel.textAlignment     =   UITextAlignmentCenter;
                discountLabel.backgroundColor   =   [UIColor clearColor];
                [cell.contentView addSubview:discountLabel];
                [discountLabel release];
                
                
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
                
                CBAsyncImageView *shopImage     =   [[CBAsyncImageView alloc] initWithFrame:CGRectMake(2.0, 1.0, 60, 60)];
                [shopImage loadImageWithAsyncUrl:[NSURL URLWithString:place.smallImgURL]];
                [cell.contentView addSubview:shopImage];
                [shopImage release];

                
            }else {
                PlaceView *place                =   (PlaceView*)[[placesDict objectForKey:[NSString stringWithFormat:@"Places%d",indexPath.section]] objectAtIndex:indexPath.row];
                
                //name
                UILabel *nameLabel              =   [[UILabel alloc]initWithFrame:CGRectMake(66.0, 8.0, 160.0, 20.0)];
                nameLabel.font                  =   [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                nameLabel.textColor             =   [UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)102/255 blue:(CGFloat)102/255 alpha:1.0];
                nameLabel.text                  =   place.name;
                nameLabel.textAlignment         =   UITextAlignmentLeft;
                nameLabel.backgroundColor       =   [UIColor clearColor];
                [cell.contentView addSubview:nameLabel];
                [nameLabel release];
                
                //adress
                UILabel *addressLabel           =   [[UILabel alloc]initWithFrame:CGRectMake(66.0, 28.0, 160.0, 15.0)];
                addressLabel.font               =   [UIFont fontWithName:@"Helvetica" size:14.0];
                addressLabel.textColor          =   [UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)102/255 blue:(CGFloat)102/255 alpha:1.0];
                addressLabel.text               =   place.address;
                addressLabel.textAlignment      =   UITextAlignmentLeft;
                addressLabel.backgroundColor    =   [UIColor clearColor];
                [cell.contentView addSubview:addressLabel];
                [addressLabel release];
                
                //detail
                UILabel *detailLabel            =   [[UILabel alloc]initWithFrame:CGRectMake(66.0, 43.0, 160.0, 14.0)];
                detailLabel.font                =   [UIFont fontWithName:@"Helvetica" size:12.0];
                detailLabel.textColor           =   [UIColor colorWithRed:(CGFloat)204/255 green:(CGFloat)204/255 blue:(CGFloat)204/255 alpha:1.0];
                detailLabel.text                =   place.about;
                detailLabel.textAlignment       =   UITextAlignmentLeft;
                detailLabel.backgroundColor     =   [UIColor clearColor];
                [cell.contentView addSubview:detailLabel];
                [detailLabel release];
                
                
                //discount
                UILabel *discountLabel          =   [[UILabel alloc]initWithFrame:CGRectMake(240.0, 14.0, 80.0, 14.0)];
                discountLabel.font              =   [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                discountLabel.textColor         =   [UIColor colorWithRed:(CGFloat)153/255 green:(CGFloat)153/255 blue:(CGFloat)153/255 alpha:1.0];
                discountLabel.text              =   place.discount;
                discountLabel.textAlignment     =   UITextAlignmentCenter;
                discountLabel.backgroundColor   =   [UIColor clearColor];
                [cell.contentView addSubview:discountLabel];
                [discountLabel release];
                
                CBAsyncImageView *shopImage     =   [[CBAsyncImageView alloc] initWithFrame:CGRectMake(2.0, 1.0, 60, 60)];
                [shopImage loadImageWithAsyncUrl:[NSURL URLWithString:place.smallImgURL]];
                [cell.contentView addSubview:shopImage];
                [shopImage release];
            }
        }
    }
    if (indexPath.section == 0) {
        return placesCell;
        
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != 0) {

        nPath           =   [indexPath retain];
        UITableViewCell *cell               =   [tableView cellForRowAtIndexPath:indexPath];
        [UIView animateWithDuration:0.2 delay:0.0 options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction) animations:^{
            cell.transform                  =   CGAffineTransformMakeScale(0.9f, 0.9f);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.1 delay:0.0 options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction) animations:^{
                cell.transform              =   CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished){
            }];
            PlaceView *place   =   [[placesDict objectForKey:[NSString stringWithFormat:@"Places%d",indexPath.section]] objectAtIndex:indexPath.row];
            
            KZPlaceGrandCentralViewController *grandController  =   [[KZPlaceGrandCentralViewController alloc] initWithPlace:place];
            [self magnifyViewController:grandController duration:0.35];
        }];
    }
    
    
    
    
}

#pragma Place Mapview delegate

-(void)expandMapview{
    if (!isMapviewExpand) {
        isMapviewExpand =   TRUE;
        //[self.placesTableview reloadData];
        [self.placesTableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        self.cardviewButton.selected        =   TRUE;
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
		if (scrollView.contentOffset.y < -25 && scrollView.contentOffset.y < 0.0f && scrollView.contentOffset.y > -90) {
			[headerView setStatus:kShowSearchBar animated:YES];
			
		} else if (scrollView.contentOffset.y <= -90) {
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
    PlaceView *place        =   [[placesDict objectForKey:@"Places1"] objectAtIndex:checkout.tag -1];
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
    if (isMapviewExpand) {
        isMapviewExpand                     =   FALSE;                                                
        
        [self.placesTableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        //[self.placesTableview reloadData];
        self.cardviewButton.selected        =   FALSE;
    }else {
        CardViewController *cardController  =   [[CardViewController alloc] init];
        [self magnifyViewController:cardController duration:0.35];
    }   
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
