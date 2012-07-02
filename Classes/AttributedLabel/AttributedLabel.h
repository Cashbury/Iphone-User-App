
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>



/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: Utility Functions
/////////////////////////////////////////////////////////////////////////////

CTTextAlignment CTTextAlignmentFromUITextAlignment(UITextAlignment alignment);
CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode);

/////////////////////////////////////////////////////////////////////////////

@class AttributedLabel;
@protocol AttributedLabelDelegate <NSObject>
@optional
-(BOOL)attributedLabel:(AttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo;
-(UIColor*)colorForLink:(NSTextCheckingResult*)linkInfo underlineStyle:(int32_t*)underlineStyle; //!< Combination of CTUnderlineStyle and CTUnderlineStyleModifiers
@end

#define UITextAlignmentJustify ((UITextAlignment)kCTJustifiedTextAlignment)

/////////////////////////////////////////////////////////////////////////////

@interface AttributedLabel : UILabel {
	NSMutableAttributedString* _attributedText; //!< Internally mutable, but externally immutable copy access only
	CTFrameRef textFrame;
	CGRect drawingRect;
	NSMutableArray* customLinks;
	NSTextCheckingResult* activeLink;
}

/* Attributed String accessors */
@property(nonatomic, copy) NSAttributedString* attributedText; //!< Use this instead of the "text" property inherited from UILabel to set and get text
-(void)resetAttributedText; //!< rebuild the attributedString based on UILabel's text/font/color/alignment/... properties

/* Links configuration */
@property(nonatomic, assign) BOOL automaticallyDetectLinks; //!< Defaults to YES
@property(nonatomic, retain) UIColor* linkColor; //!< Defaults to [UIColor blueColor]. See also OHAttributedLabelDelegate
@property(nonatomic, retain) UIColor* highlightedLinkColor; //[UIColor colorWithWhite:0.2 alpha:0.5]
@property(nonatomic, assign) BOOL underlineLinks; //!< Defaults to YES. See also OHAttributedLabelDelegate
-(void)addCustomLink:(NSURL*)linkUrl inRange:(NSRange)range;
-(void)removeAllCustomLinks;

@property(nonatomic, assign) BOOL onlyCatchTouchesOnLinks; //!< If YES, pointInside will only return YES if the touch is on a link. If NO, pointInside will always return YES (Defaults to NO)
@property(nonatomic, assign) IBOutlet id<AttributedLabelDelegate> delegate;

@property(nonatomic, assign) BOOL centerVertically;
@property(nonatomic, assign) BOOL extendBottomToFit; //!< Allows to draw text past the bottom of the view if need. May help in rare cases (like using Emoji)
@end
