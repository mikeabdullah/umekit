//
//  UMEToolbar.m
//  UMEKit
//
//  Created by Todd Ditchendorf on 2/16/10.
//  Copyright 2010 Todd Ditchendorf. All rights reserved.
//

#import "UMEToolbar.h"

#define ITEM_X 4.0
#define ITEM_MARGIN 5.0

static NSImage *sDefaultBackgroundImage = nil;
static NSImage *sBlackBackgroundImage = nil;
static NSImage *sGrayBackgroundImage = nil;
static NSImage *sNavyBackgroundImage = nil;

@interface UMEBarButtonItem ()
- (void)sizeToFit;
@property (nonatomic) UMEBarStyle barStyle;            // default is UMEBarStyleDefault
@end

@interface UMEToolbar ()
- (void)layoutItems;
@end

@implementation UMEToolbar

+ (void)initialize {
    if ([UMEToolbar class] == self) {

        NSBundle *b = [NSBundle bundleForClass:[UMEToolbar class]];

        sDefaultBackgroundImage = [[NSImage alloc] initWithContentsOfFile:[b pathForImageResource:@"toolbar_bg_default"]];
        sBlackBackgroundImage = [[NSImage alloc] initWithContentsOfFile:[b pathForImageResource:@"toolbar_bg_black"]];
        sGrayBackgroundImage = [[NSImage alloc] initWithContentsOfFile:[b pathForImageResource:@"toolbar_bg_gray"]];
        sNavyBackgroundImage = [[NSImage alloc] initWithContentsOfFile:[b pathForImageResource:@"toolbar_bg_navy"]];
    }
}


- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.barStyle = UMEBarStyleDefault;
    }
    return self;
}


- (void)dealloc {
    self.items = nil;
    self.tintColor = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark NSView

- (BOOL)isFlipped {
    return YES;
}


// necessary for the first run layout :|
//- (void)viewWillDraw {
//    if (!layoutDone) {
//        layoutDone = YES;
//        [self layoutItems];
//    }
//    [super viewWillDraw];
//}


- (void)resizeSubviewsWithOldSize:(NSSize)oldSize {
    [self layoutItems];
}


- (void)drawRect:(NSRect)dirtyRect {
    NSImage *bgImg = nil;
    
    switch (barStyle) {
        case UMEBarStyleDefault:
            bgImg = sDefaultBackgroundImage;
            break;
        case UMEBarStyleBlack:
            bgImg = sBlackBackgroundImage;
            break;
        case UMEBarStyleGray:
            bgImg = sGrayBackgroundImage;
            break;
        case UMEBarStyleNavy:
            bgImg = sNavyBackgroundImage;
            break;
        default:
            break;
    }
    
    NSRect bounds = [self bounds];
    NSDrawThreePartImage(bounds, bgImg, bgImg, bgImg, NO, NSCompositeSourceOver, 1, YES);
}


#pragma mark -
#pragma mark Public

- (void)setItems:(NSArray *)a animated:(BOOL)animated {
    self.items = a;
}


- (void)setItems:(NSArray *)a {
    if (a != items) {
        [items autorelease];
        items = [a retain];
        
        for (UMEBarButtonItem *item in items) {
            item.barStyle = barStyle;
        }
        
        [self layoutItems];
    }
}


#pragma mark -
#pragma mark Private

- (void)layoutItems {
    CGFloat x = ITEM_X;
    CGFloat y = 0;
    CGFloat w = 0;
    CGFloat h = 0;
    
    for (UMEBarButtonItem *item in items) {
        //[item sizeToFit];
        [self addSubview:item.customView];
        w = [item width];
        h = NSHeight([item.customView frame]);
        [item.customView setFrame:NSMakeRect(x, y, w, h)];
        x += w + ITEM_MARGIN;
    }
    
    [self setNeedsDisplay:YES];
}

@synthesize barStyle;
@synthesize items;
@synthesize tintColor;
@synthesize translucent;
@end
