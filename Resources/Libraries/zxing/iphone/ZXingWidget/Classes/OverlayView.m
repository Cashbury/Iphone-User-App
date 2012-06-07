/**
 * Copyright 2009 Jeff Verkoeyen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "OverlayView.h"

static const CGFloat kPadding = 10;

@interface OverlayView()
@property (nonatomic,assign) UIButton *cancelButton;
@property (nonatomic,retain) UILabel *instructionsLabel;
@end


@implementation OverlayView

@synthesize delegate, oneDMode;
@synthesize points = _points;
@synthesize cancelButton;
@synthesize cropRect;
@synthesize instructionsLabel;
@synthesize displayedMessage;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithFrame:(CGRect)theFrame cancelEnabled:(BOOL)isCancelEnabled oneDMode:(BOOL)isOneDModeEnabled {
  self = [super initWithFrame:theFrame];
  if( self ) {

    CGFloat rectSize = self.frame.size.width - kPadding * 2;
    if (!oneDMode) {
      cropRect = CGRectMake(kPadding, (self.frame.size.height - rectSize) / 2, rectSize, rectSize);
    } else {
      CGFloat rectSize2 = self.frame.size.height - kPadding * 2;
      cropRect = CGRectMake(kPadding, kPadding, rectSize, rectSize2);		
    }

    self.backgroundColor = [UIColor clearColor];
    self.oneDMode = isOneDModeEnabled;
    if (isCancelEnabled) {
      UIButton *butt = [UIButton buttonWithType:UIButtonTypeRoundedRect]; 
      self.cancelButton = butt;
      [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
      if (oneDMode) {
        [cancelButton setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        
        [cancelButton setFrame:CGRectMake(20, 175, 45, 130)];
      }
      else {
        CGSize theSize = CGSizeMake(100, 50);
        CGRect theRect = CGRectMake((theFrame.size.width - theSize.width) / 2, cropRect.origin.y + cropRect.size.height + 20, theSize.width, theSize.height);
        [cancelButton setFrame:theRect];
        
      }
      
      [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:cancelButton];
      [self addSubview:imageView];
    }
  }
  return self;
}



- (void)cancel:(id)sender {
	// call delegate to cancel this scanner
	if (delegate != nil) {
		[delegate cancelled];
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
	[imageView release];
	[_points release];
  [instructionsLabel release];
  [displayedMessage release];
	[super dealloc];
}


- (void)drawRect:(CGRect)rect inContext:(CGContextRef)context {
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
	CGContextStrokePath(context);
}

- (CGPoint)map:(CGPoint)point {
    CGPoint center;
    center.x = cropRect.size.width/2;
    center.y = cropRect.size.height/2;
    float x = point.x - center.x;
    float y = point.y - center.y;
    int rotation = 90;
    switch(rotation) {
    case 0:
        point.x = x;
        point.y = y;
        break;
    case 90:
        point.x = -y;
        point.y = x;
        break;
    case 180:
        point.x = -x;
        point.y = -y;
        break;
    case 270:
        point.x = y;
        point.y = -x;
        break;
    }
    point.x = point.x + center.x;
    point.y = point.y + center.y;
    return point;
}

-(void)historyButtonClicked{
    [delegate goTohistoryController];
    
}

-(void)viewForFewSecs{
    
}

-(void)showViewForaWhile{
    UIImageView *aimAimgeView   =   (UIImageView*)[self viewWithTag:TAG_SCANNER_AIM_SCAN];
    aimAimgeView.hidden         =   TRUE;
}

-(void)animateLabels{
    //UIImageView *toogleImgView  =   (UIImageView*)[self viewWithTag:TAG_TOGGLE_IMGVIEW];
    
    UILabel *toggleLabel        =   (UILabel*)[self viewWithTag:TAG_SCANNER_TOGGLE_LABEL];
    
    UIImageView *lineImage      =   (UIImageView*)[self viewWithTag:TAG_SCANNER_LINE];
    if (lineImage.isHighlighted) {
        [toggleLabel setText:@"Hode over code to auto scan"];
        lineImage.highlighted   =   FALSE;
    }else {
        [toggleLabel setText:@"Scanning ...."];
        lineImage.highlighted   =   TRUE;
    }  
}

-(void)stopAllAnimations{
    if (toggleTimer) {
        [toggleTimer invalidate];
        toggleTimer     =   nil;
    }
    if (moveLineTimer) {
        [moveLineTimer invalidate];
        moveLineTimer   =   nil;
    }
   
}

-(void)startAnimations{
    if (toggleTimer == nil) {
        toggleTimer     =   [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(animateLabels) userInfo:nil repeats:YES];
        moveLineTimer   =   [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(animateLine) userInfo:nil repeats:YES];
    }
   
}



-(void)animateLine{
    UIImageView *lineImage      =   (UIImageView*)[self viewWithTag:TAG_SCANNER_LINE];
    if (lineYOne >= 130 && lineYOne < 330 && lineYTwo == 330) {
        lineYOne    =   lineYOne+1;
    }else if(lineYOne == 330){
        lineYTwo    =   130;
        lineYOne    =   lineYOne-1;
    }else if(lineYOne > 130 && lineYTwo == 130){
        lineYOne    =   lineYOne-1;
    }else if(lineYOne == 130){
        lineYTwo    =   330;
        lineYOne    =   lineYOne+1;
    }
    lineImage.frame         =   CGRectMake(lineImage.frame.origin.x, lineYOne, lineImage.frame.size.width, lineImage.frame.size.height);
}

-(void)setNavBarItems{
    if (navBarView == nil) {
        navBarView                  =   [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 51.0)];
        
        UIImageView *frameImgView   =   [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0)];
        frameImgView.image          =   [UIImage imageNamed:@"scanner_frame"];
        [self addSubview:frameImgView];
        [frameImgView release];
        
        UIButton *backButton        =   [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame            =   CGRectMake(0, 4.0, 47, 34.0);
        [backButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"scanner_back"] forState:UIControlStateNormal];
        [navBarView addSubview:backButton];
        
        UIButton *infoButton    =   [UIButton buttonWithType:UIButtonTypeCustom];
        infoButton.frame        =   CGRectMake(274, 4.0, 43, 33.0);
        [infoButton addTarget:self action:@selector(historyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [infoButton setImage:[UIImage imageNamed:@"scanner_his"] forState:UIControlStateNormal];
        [navBarView addSubview:infoButton];
        
        [self addSubview:navBarView];
        [navBarView release];
        
        
        /*
        UIImageView *aimImgView     =   [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aim2scan_bg"]];
        aimImgView.frame            =   CGRectMake(40.0, 129.0, 234.0, 216.0);
        [self addSubview:aimImgView];
        [aimImgView release];*/
        
        UIImageView *aimtextImgView     =   [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aim2scan"]];
        aimtextImgView.frame            =   CGRectMake(65.0, 190.0, 184, 69.0);
        aimtextImgView.tag              =   TAG_SCANNER_AIM_SCAN;
        [self addSubview:aimtextImgView];
        [aimtextImgView release];
        
        
        UIImageView *imgViewtext        =   [[UIImageView alloc]initWithFrame:CGRectMake(54.0, 70, 16, 22)];
        imgViewtext.image               =   [UIImage imageNamed:@"scanner_text"];
        imgViewtext.tag                 =   TAG_TOGGLE_IMGVIEW;
        [self addSubview:imgViewtext];
        [imgViewtext release];
        
        UILabel *scanLabel              =   [[UILabel alloc]initWithFrame:CGRectMake(0.0, 69.0, 320.0, 21.0)];
        scanLabel.font                  =   [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
        scanLabel.textColor             =   [UIColor whiteColor];
        scanLabel.textAlignment         =   UITextAlignmentCenter;
        scanLabel.tag                   =   TAG_SCANNER_TOGGLE_LABEL;
        scanLabel.backgroundColor       =   [UIColor clearColor];
        scanLabel.text                  =   @"Hode over code to auto scan";//Scanning ....
        [self addSubview:scanLabel];
        [scanLabel release];
        
        
        UIImageView *lineImageView      =   [[UIImageView alloc]initWithFrame:CGRectMake(12.0, 130.0, 296.0, 11.0)];
        [lineImageView setImage:[UIImage imageNamed:@"scannera_redline"]];
        lineImageView.tag               =   TAG_SCANNER_LINE;
        [lineImageView setHighlightedImage:[UIImage imageNamed:@"scanner_yellowline"]];
        [self addSubview:lineImageView];
        [lineImageView release];
        
        /*
        UILabel *scanDownLabel              =   [[UILabel alloc]initWithFrame:CGRectMake(30.0, 384.0, 255.0, 64.0)];
        scanDownLabel.font                  =   [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        scanDownLabel.textColor             =   [UIColor whiteColor];
        scanDownLabel.numberOfLines         =   0;
        scanDownLabel.textAlignment         =   UITextAlignmentCenter;
        scanDownLabel.backgroundColor       =   [UIColor clearColor];
        scanDownLabel.shadowColor           =   [UIColor colorWithRed:(CGFloat)60/255 green:(CGFloat)63/255 blue:(CGFloat)68/255 alpha:1.0];
        scanDownLabel.shadowOffset          =   CGSizeMake(0, 1);
        scanDownLabel.text                  =   @"To auto scan code, simply aim and hold.     Place code upright. Avoid glare and shadows.";
        [self addSubview:scanDownLabel];
        [scanDownLabel release];*/
        
        lineYOne                            =   130;
        lineYTwo                            =   330;
        
        [self performSelector:@selector(showViewForaWhile) withObject:nil afterDelay:1.0f];
        
    }

}

#define kTextMargin 10

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];/*
  if (displayedMessage == nil) {
    self.displayedMessage = @"Place a barcode inside the viewfinder rectangle to scan it.";
  }
	CGContextRef c = UIGraphicsGetCurrentContext();
  
	if (nil != _points) {
    //		[imageView.image drawAtPoint:cropRect.origin];
	}
	
	CGFloat white[4] = {1.0f, 1.0f, 1.0f, 1.0f};
	CGContextSetStrokeColor(c, white);
	CGContextSetFillColor(c, white);
	[self drawRect:cropRect inContext:c];
	
  //	CGContextSetStrokeColor(c, white);
	//	CGContextSetStrokeColor(c, white);
	CGContextSaveGState(c);
	if (oneDMode) {
		char *text = "Place a red line over the bar code to be scanned.";
		CGContextSelectFont(c, "Helvetica", 15, kCGEncodingMacRoman);
		CGContextScaleCTM(c, -1.0, 1.0);
		CGContextRotateCTM(c, M_PI/2);
		CGContextShowTextAtPoint(c, 74.0, 285.0, text, 49);
	}
	else {
    UIFont *font = [UIFont systemFontOfSize:18];
    CGSize constraint = CGSizeMake(rect.size.width  - 2 * kTextMargin, cropRect.origin.y);
    CGSize displaySize = [self.displayedMessage sizeWithFont:font constrainedToSize:constraint];
    CGRect displayRect = CGRectMake((rect.size.width - displaySize.width) / 2 , cropRect.origin.y - displaySize.height, displaySize.width, displaySize.height);
    [self.displayedMessage drawInRect:displayRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	}
	CGContextRestoreGState(c);
	int offset = rect.size.width / 2;
	if (oneDMode) {
		CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
		CGContextSetStrokeColor(c, red);
		CGContextSetFillColor(c, red);
		CGContextBeginPath(c);
		//		CGContextMoveToPoint(c, rect.origin.x + kPadding, rect.origin.y + offset);
		//		CGContextAddLineToPoint(c, rect.origin.x + rect.size.width - kPadding, rect.origin.y + offset);
		CGContextMoveToPoint(c, rect.origin.x + offset, rect.origin.y + kPadding);
		CGContextAddLineToPoint(c, rect.origin.x + offset, rect.origin.y + rect.size.height - kPadding);
		CGContextStrokePath(c);
	}
	if( nil != _points ) {
		CGFloat blue[4] = {0.0f, 1.0f, 0.0f, 1.0f};
		CGContextSetStrokeColor(c, blue);
		CGContextSetFillColor(c, blue);
		if (oneDMode) {
			CGPoint val1 = [self map:[[_points objectAtIndex:0] CGPointValue]];
			CGPoint val2 = [self map:[[_points objectAtIndex:1] CGPointValue]];
			CGContextMoveToPoint(c, offset, val1.x);
			CGContextAddLineToPoint(c, offset, val2.x);
			CGContextStrokePath(c);
		}
		else {
			CGRect smallSquare = CGRectMake(0, 0, 10, 10);
			for( NSValue* value in _points ) {
				CGPoint point = [self map:[value CGPointValue]];
				smallSquare.origin = CGPointMake(
                                         cropRect.origin.x + point.x - smallSquare.size.width / 2,
                                         cropRect.origin.y + point.y - smallSquare.size.height / 2);
				[self drawRect:smallSquare inContext:c];
			}
		}
	}*/
    
    
    [self setNavBarItems];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
/*
 - (void) setImage:(UIImage*)image {
 //if( nil == imageView ) {
// imageView = [[UIImageView alloc] initWithImage:image];
// imageView.alpha = 0.5;
// } else {
 imageView.image = image;
 //}
 
 //CGRect frame = imageView.frame;
 //frame.origin.x = self.cropRect.origin.x;
 //frame.origin.y = self.cropRect.origin.y;
 //imageView.frame = CGRectMake(0,0, 30, 50);
 
 //[_points release];
 //_points = nil;
 //self.backgroundColor = [UIColor clearColor];
 
 //[self setNeedsDisplay];
 }
 */

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*) image {
	return imageView.image;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setPoints:(NSMutableArray*)pnts {
    [pnts retain];
    [_points release];
    _points = pnts;
	
    if (pnts != nil) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    }
    [self setNeedsDisplay];
}

- (void) setPoint:(CGPoint)point {
    if (!_points) {
        _points = [[NSMutableArray alloc] init];
    }
    if (_points.count > 3) {
        [_points removeObjectAtIndex:0];
    }
    [_points addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}


@end
