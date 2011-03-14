/*
 * Copyright 2010 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

#import "FBLoginBtn.h"
#import <dlfcn.h>

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FBLoginBtn

@synthesize isLoggedIn = _isLoggedIn;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

/**
 * return the regular button image according to the login status
 */
- (UIImage*)buttonImage {
  if (_isLoggedIn) {
    return [UIImage imageNamed:@"LogoutNormal.png"];
  } else {
    return [UIImage imageNamed:@"LoginNormal.png"];
  }
}

/**
 * return the highlighted button image according to the login status
 */
- (UIImage*)buttonHighlightedImage {
  if (_isLoggedIn) {
    return [UIImage imageNamed:@"LogoutPressed.png"];
  } else {
    return [UIImage imageNamed:@"LoginPressed.png"];
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// public

/**
 * To be called whenever the login status is changed
 */
- (void)updateImage {
	NSLog(@"Update Button Image...");
  self.imageView.image = [self buttonImage];
  [self setImage: [self buttonImage]
                  forState: UIControlStateNormal];

  [self setImage: [self buttonHighlightedImage]
                  forState: UIControlStateHighlighted |UIControlStateSelected];

}

@end 
