//
//  HUIPickerView.h
//  Truth or Dare
//
//  Created by YQ-010 on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "PickerView.h"
@interface HUIPickerView : UIView <UIActionSheetDelegate,UIScrollViewDelegate>{
    int playerIndex;
}


@property (nonatomic, retain) UIScrollView *playerPicker;
@property (nonatomic, retain) UIButton *leftBtn;
@property (nonatomic, retain) UIButton *rightBtn;
@property int temp;
@property BOOL isSendingNotifi;
- (id)initWithFrame:(CGRect)frame row:(int)rows;
- (int)getIndex;
- (void)sendNotification;
@end
