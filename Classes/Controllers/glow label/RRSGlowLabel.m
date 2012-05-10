//
//  RRSGlowLabel.m
//  TextGlowDemo
//
//  Created by QuintetSolutions on 7/05/2011.
//  Copyright 2010 QuintetSolutions.
//

#import "RRSGlowLabel.h"


@interface RRSGlowLabel()
- (void)initialize;
@end

@implementation RRSGlowLabel

@synthesize glowColor, glowOffset, glowAmount;

- (void)setGlowColor:(UIColor *)newGlowColor
{
    if (newGlowColor != glowColor) {
        [glowColor release];
        CGColorRelease(glowColorRef);

        glowColor = [newGlowColor retain];
        glowColorRef = CGColorCreate(colorSpaceRef, CGColorGetComponents(glowColor.CGColor));
    }
}

- (void)initialize {
    colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    self.glowOffset = CGSizeMake(0.0, 0.0);
    self.glowAmount = 0.0;
    self.glowColor = [UIColor clearColor];
}

- (void)awakeFromNib {
    [self initialize];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self initialize];
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetShadow(context, self.glowOffset, self.glowAmount);
    CGContextSetShadowWithColor(context, self.glowOffset, self.glowAmount, glowColorRef);
    
    [super drawTextInRect:rect];
    
    CGContextRestoreGState(context);
}

- (void)dealloc {
    CGColorRelease(glowColorRef);
    CGColorSpaceRelease(colorSpaceRef);
    [glowColor release];
    [super dealloc];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(action == @selector(copy:)) {
        return YES;
    }
    else {
        return [super canPerformAction:action withSender:sender];
    }
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (BOOL)becomeFirstResponder {
    if([super becomeFirstResponder]) {
        self.highlighted = YES;
        return YES;
    }
    return NO;
}


- (void)copy:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setString:self.text];
    self.highlighted = NO;
    [self resignFirstResponder];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([self isFirstResponder]) {
        self.highlighted = NO;
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuVisible:NO animated:YES];
        [menu update];
        [self resignFirstResponder];
    }
    else if([self becomeFirstResponder]) {
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.bounds inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
}

@end
