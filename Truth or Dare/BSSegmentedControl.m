//
//  BSSegmentedControl.m
//  Money Monitor
//
//  Created by YQ006 on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BSSegmentedControl.h"
#import "UIViewAdditions.h"

@interface BSSegmentedControl ()

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation BSSegmentedControl
@synthesize target = target_, action = action_;
@synthesize items = items_;
@synthesize selectedSegmentIndex;

- (IBAction) buttonPressed:(id)sender {
    self.selectedSegmentIndex = [sender tag] - 1;
}

#pragma mark - accessors

- (NSInteger) numberOfSegments {
    return self.items.count;
}

- (void) setSelectedSegmentIndex:(NSInteger)index {
    selectedSegmentIndex = index;

    for (int i = 0; i < self.items.count; ++i) {
        UIButton *v = (UIButton *)[self viewWithTag:i + 1];
        v.userInteractionEnabled = !(v.selected = (index == i));
    }
    if (target_ != nil && action_ != nil) {
        [target_ performSelector:action_ withObject:self];
    }
}

- (NSInteger) selectedSegmentIndex {
    if (self.items.count == 0) {
        return UISegmentedControlNoSegment;
    }
    return selectedSegmentIndex;
}

- (void) setItems:(NSArray *)items {
    [items retain];
    [items_ release];
    items_ = items;

    CGFloat x = .0;
    CGFloat maxh = .0;
    UIButton *b = nil;

    for (int i = 0; i < items_.count; ++i) {
        id o = [items_ objectAtIndex:i];

        if ([o isKindOfClass:[UIImage class]]) {
            b = [UIButton buttonWithType:UIButtonTypeCustom];
            [b setImage:o forState:UIControlStateNormal];
            b.frame = (CGRect){CGPointZero, [(UIImage *)o size]};
        } else if ([o isKindOfClass:[UIButton class]]) {
            b = o;
        } else {
            [NSException raise:@"error"
                format:@"attempt to init with instance of %@", [o class]];
        }
        b.adjustsImageWhenHighlighted = NO;
        b.tag = i + 1;
        b.left = x;
        b.top = .0;
        [self addSubview:b];
        [b addTarget:self action:@selector(buttonPressed:)
            forControlEvents:UIControlEventTouchUpInside];

        x += b.width;
        CGFloat h = b.height;
        if (maxh < h) {
            maxh = h;
        }
    }
    self.width = x;
    self.height = maxh;
}

#pragma mark - lifecycle

- (void) awakeFromNib {
    items_ = [[self subviews] retain];
}

- (id) initWithItems:(NSArray *)items {
    if (self = [super init]) {
        self.items = items;
    }
    return self;
}

- (void) dealloc {
    [items_ release];
    [super dealloc];
}

#pragma mark - custom

- (void) addTarget:(id)target action:(SEL)action
    forControlEvents:(UIControlEvents)controlEvents {

    if (controlEvents == UIControlEventValueChanged) {
        self.target = target;
        self.action = action;
    }
}

- (void) setImage:(UIImage *)image forSegmentIndex:(NSInteger)index
    andState:(UIControlState)state {

    UIButton *b = (UIButton *)[self viewWithTag:index + 1];
    [b setImage:image forState:state];
}

- (void) setImage:(UIImage *)image forSegmentIndex:(NSInteger)index {
    [self setImage:image forSegmentIndex:index andState:UIControlStateNormal];
}

- (void) setSelectedItems:(NSArray *)items {
    for (int i = 0; i < items.count; ++i) {
        UIButton *b = (UIButton *)[self viewWithTag:i + 1];
        if (b == nil) {
            break;
        }
        [b setImage:[items objectAtIndex:i] forState:UIControlStateSelected];
    }
}

@end
