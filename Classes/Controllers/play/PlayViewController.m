//
//  PlayViewController.m
//  Cashbury
//
//  Created by Quintet Solutions on 4/26/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PlayViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface PlayViewController ()

@end

@implementation PlayViewController

@synthesize spinContainerView;
@synthesize fullScrollView;
@synthesize tag;
@synthesize scrollViewOne;
@synthesize scrollViewTwo;
@synthesize scrollViewThree;


SystemSoundID soundID;
NSURL *soundURL;
SystemSoundID spinningSoundId;
NSURL * spinningSoundURL;
static const int numOfSlots =   6;
static const int slotHt     =   80;

BOOL isPlaying      =   FALSE;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Play sound
-(void)playSound{
    AudioServicesPlaySystemSound(soundID);
    
}

-(void)playSpinningSound{
    AudioServicesPlaySystemSound(spinningSoundId);
}

#pragma mark - Sound Files
-(void)createSoundFiles{

    NSString *soundFilePath                     =	[[NSBundle mainBundle] pathForResource:@"jackpot_cling" ofType:@"wav"];
    soundURL                                    =	[NSURL fileURLWithPath:soundFilePath isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &soundID);
    
    
    NSString *spinFilePath                      =	[[NSBundle mainBundle] pathForResource:@"wheelsTurning" ofType:@"wav"];
    spinningSoundURL                            =	[NSURL fileURLWithPath:spinFilePath isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)spinningSoundURL, &spinningSoundId);
    
}

#pragma mark Game Views

-(void)shuffleImages:(UIScrollView*)mScroll getArray:(NSMutableArray*)mArray{
    
    int randomIndex;
    for( int index = 0; index < [mArray count]; index++ )
    {
        randomIndex = arc4random() % [mArray count];
        
        [mArray exchangeObjectAtIndex:index withObjectAtIndex:randomIndex];
    }
    
    for (int i = 0; i < numOfSlots+2; i ++) {
        UIImageView *iView  =   (UIImageView*)[mScroll viewWithTag:i+1];
        iView.tag           =   (i+1);
        if (i == 0) {
            [iView setImage:[mArray lastObject]];
            
        }else if(i == numOfSlots+1){
            [iView setImage:[mArray objectAtIndex:0]];
        }else {
            [iView setImage:[mArray objectAtIndex:i-1]];
        }
    }
}

-(void)setImagesToArray:(NSMutableArray*)mArray{
    for (int i = 0; i < numOfSlots; i ++) {
        NSString *imgString     =   [NSString stringWithFormat:@"slot_%d",i+1];
        UIImage *imgae          =   [UIImage imageNamed:imgString];
        [mArray addObject:imgae];
    }
    int randomIndex;
    for( int index = 0; index < [mArray count]; index++ )
    {
        randomIndex = arc4random() % [mArray count];
        
        [mArray exchangeObjectAtIndex:index withObjectAtIndex:randomIndex];
    }
}

-(void)setImagesToScroll:(UIScrollView*)mScroll getArray:(NSMutableArray*)mArray{
    
    NSInteger xValue        =   25;
    for (int i = 0; i < numOfSlots+2; i ++) {
        UIImageView *iView  =   [[UIImageView alloc] initWithFrame:CGRectMake(0.0, xValue, 75.0, slotHt)];
        iView.tag           =   (i+1);
        if (i == 0) {
            [iView setImage:[mArray lastObject]];
            
        }else if(i == numOfSlots+1){
            [iView setImage:[mArray objectAtIndex:0]];
        }else {
            [iView setImage:[mArray objectAtIndex:i-1]];
        }
        [mScroll addSubview:iView];
        [iView release];
        
        xValue  =   xValue + slotHt;
    }
    
}
-(void)createGameView{
    oneImages       =   [[NSMutableArray alloc]init];
    twoImages       =   [[NSMutableArray alloc] init];
    threeImages     =   [[NSMutableArray alloc] init];
    tSpeedOne       =   slotHt;
    tSpeedTwo       =   slotHt;
    tSpeedThree     =   slotHt;
    
    self.scrollViewOne.delegate     =   self;
    self.scrollViewTwo.delegate     =   self;
    self.scrollViewThree.delegate   =   self;
    
    
    [self setImagesToArray:oneImages];
    [self setImagesToArray:twoImages];
    [self setImagesToArray:threeImages];
    
    //set images to scroll
    [self setImagesToScroll:scrollViewOne getArray:oneImages];
    [self setImagesToScroll:scrollViewTwo getArray:twoImages];
    [self setImagesToScroll:scrollViewThree getArray:threeImages];
    
    [scrollViewOne setContentSize:CGSizeMake(slotHt, slotHt * (numOfSlots + 2))];
    [scrollViewTwo setContentSize:CGSizeMake(slotHt, slotHt * (numOfSlots + 2))];
    [scrollViewThree setContentSize:CGSizeMake(slotHt, slotHt * (numOfSlots + 2))];
    
    [scrollViewOne setContentOffset:CGPointMake(0.0, slotHt*2)];
    [scrollViewTwo setContentOffset:CGPointMake(0.0, slotHt*2)];
    [scrollViewThree setContentOffset:CGPointMake(0.0, slotHt*2)];
}

#pragma mark scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /*
    if (scrollView.contentOffset.y < 0) {         
		[scrollView scrollRectToVisible:CGRectMake(scrollView.frame.origin.x,oneImages.count * slotHt,scrollView.frame.size.width,scrollView.frame.size.height) animated:NO];     
	}    
	else if (scrollView.contentOffset.y >= (oneImages.count +1) * slotHt) {         
		[scrollView scrollRectToVisible:CGRectMake(scrollView.frame.origin.x,slotHt,scrollView.frame.size.width,scrollView.frame.size.height) animated:NO];         
	}*/
    
    if (scrollView.contentOffset.y < 0) { 
        [scrollView setContentOffset:CGPointMake(0.0, oneImages.count * slotHt) animated:NO];
		    
	}    
	else if (scrollView.contentOffset.y >= (oneImages.count +1) * slotHt) {         
		
        [scrollView setContentOffset:CGPointMake(0.0, slotHt) animated:NO];
	}
    
}

-(void)moveOne{
    [scrollViewOne setContentOffset:CGPointMake(0.0, scrollViewOne.contentOffset.y - tSpeedOne)];
    tSpeedOne           =   tSpeedOne - 0.5;
    if (tSpeedOne < 0) {
        NSInteger div   =   scrollViewOne.contentOffset.y/slotHt;
        [scrollViewOne setContentOffset:CGPointMake(0.0, div * slotHt) animated:TRUE];
        [self playSound];
        if (oneTimer) {
            [oneTimer invalidate];
            oneTimer    =   nil;
        }
        tSpeedOne   =   slotHt;
    }
}
-(void)moveTwo{
    [scrollViewTwo setContentOffset:CGPointMake(0.0, scrollViewTwo.contentOffset.y - tSpeedTwo)];
    tSpeedTwo   =   tSpeedTwo - 0.4;
    if (tSpeedTwo < 0) {
        NSInteger div   =   scrollViewTwo.contentOffset.y/slotHt;
        [scrollViewTwo setContentOffset:CGPointMake(0.0, div * slotHt) animated:TRUE];
        [self playSound];
        if (twoTimer) {
            [twoTimer invalidate];
            twoTimer = nil;
        }
        tSpeedTwo  =   slotHt;
    }
}

-(void)moveThree{
    
    [scrollViewThree setContentOffset:CGPointMake(0.0, scrollViewThree.contentOffset.y - tSpeedThree)];
    tSpeedThree   =   tSpeedThree - 0.33;
    if (tSpeedThree < 0) {
        NSInteger div   =   scrollViewThree.contentOffset.y/slotHt;
        [scrollViewThree setContentOffset:CGPointMake(0.0, div * slotHt) animated:TRUE];
        [self playSound];
        if (threeTimer) {
            [threeTimer invalidate];
            threeTimer = nil;
        }
        tSpeedThree  =   slotHt;
        isPlaying   =   FALSE;
    }
    
}

-(void)createTimers{
    
    oneTimer    =   [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(moveOne) userInfo:nil repeats:TRUE];
    twoTimer    =   [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(moveTwo) userInfo:nil repeats:TRUE];
    threeTimer  =   [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(moveThree) userInfo:nil repeats:TRUE];
    
}


- (IBAction)spinButtonClicked:(id)sender {
    if (isPlaying)
        return;
    isPlaying   =   TRUE;
    [self shuffleImages:scrollViewOne getArray:oneImages];
    [self shuffleImages:scrollViewTwo getArray:twoImages];
    [self shuffleImages:scrollViewThree getArray:threeImages];
    [self playSpinningSound];
    [self createTimers];
      
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.fullScrollView setContentSize:CGSizeMake(320.0, 940.0)];
    [self createSoundFiles];
    [self createGameView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSpinContainerView:nil];
    [self setFullScrollView:nil];

    [self setScrollViewOne:nil];
    [self setScrollViewTwo:nil];
    [self setScrollViewThree:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)invalidateAllTimers{
    if (oneTimer) {
        [oneTimer invalidate];
        oneTimer    =   nil;
    }
    if (twoTimer) {
        [twoTimer invalidate];
        twoTimer    =   nil;
    }
    if (threeTimer) {
        [threeTimer invalidate];
        threeTimer  =   nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [self invalidateAllTimers];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButtonClicked:(id)sender {

    [self diminishViewController:self duration:0.35f];  
}



- (IBAction)myPrizesClicked:(id)sender {
    [fullScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:TRUE];
}

- (IBAction)prizeBoardClicked:(id)sender {
     [fullScrollView setContentOffset:CGPointMake(0.0, 345.0) animated:TRUE];
}

- (IBAction)winnersBoardClicked:(id)sender {
    [fullScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:TRUE];
}

- (void)dealloc {
    AudioServicesDisposeSystemSoundID(spinningSoundId);
    AudioServicesDisposeSystemSoundID(soundID);
    [spinContainerView release];
    [fullScrollView release];
    [scrollViewOne release];
    [scrollViewTwo release];
    [scrollViewThree release];
    [oneImages release];
    [twoTimer release];
    [threeTimer release];
    [super dealloc];
}
@end
