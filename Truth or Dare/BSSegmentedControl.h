//
//  BSSegmentedControl.h
//  Money Monitor
//
//  Created by YQ006 on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSSegmentedControl : UIView

@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, readonly) NSInteger numberOfSegments;
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

- (id) initWithItems:(NSArray *)items;

- (void) addTarget:(id)target action:(SEL)action
    forControlEvents:(UIControlEvents)controlEvents;

- (void) setImage:(UIImage *)image forSegmentIndex:(NSInteger)index
    andState:(UIControlState)state;
- (void) setImage:(UIImage *)image forSegmentIndex:(NSInteger)index;
- (void) setSelectedItems:(NSArray *)items;

@end
