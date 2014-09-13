//
//  PickerView.h
//  Truth or Dare
//
//  Created by YQ-010 on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface PickerView : UIView{
    CGPoint startPoint; 
	CGPoint currentPoint;
	CGPoint lastPoint;
	CGPoint endPoint;
	CGFloat velocity;
	NSTimer *timer;
	int length;
	float width;
	float height;
	float sectionWidth;
}

@property (nonatomic, retain) UIView *labelCell;

- (int)getLabelIndex;

@end
