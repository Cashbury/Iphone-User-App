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
#define TAG_SCANNER_LINE    20
#define TAG_SCANNER_TOGGLE_LABEL    21
#define TAG_SCANNER_AIM_SCAN        22
#define TAG_TOGGLE_IMGVIEW          23
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol CancelDelegate;

@interface OverlayView : UIView {
	UIImageView *imageView;
	NSMutableArray *_points;
	UIButton *cancelButton;
  UILabel *instructionsLabel;
	id<CancelDelegate> delegate;
	BOOL oneDMode;
  CGRect cropRect;
  NSString *displayedMessage;

    UIView *navBarView;
    NSTimer *toggleTimer;
    NSTimer *moveLineTimer;
    CGFloat lineYOne,lineYTwo;

}

@property (nonatomic, retain) NSMutableArray*  points;
@property (nonatomic, assign) id<CancelDelegate> delegate;
@property (nonatomic, assign) BOOL oneDMode;
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, copy) NSString *displayedMessage;

- (id)initWithFrame:(CGRect)theFrame cancelEnabled:(BOOL)isCancelEnabled oneDMode:(BOOL)isOneDModeEnabled;

- (void)setPoint:(CGPoint)point;
-(void)stopAllAnimations;
-(void)startAnimations;
@end

@protocol CancelDelegate
- (void)cancelled;
-(void)goTohistoryController;
@end
