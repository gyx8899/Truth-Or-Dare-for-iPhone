//
//  PickerView.m
//  Truth or Dare
//
//  Created by YQ-010 on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PickerView.h"

@implementation PickerView

@synthesize labelCell;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.masksToBounds = YES;
//        self.clipsToBounds = NO;
        width = frame.size.width;
        height = frame.size.height;
		sectionWidth = frame.size.width/5;
        length = 49;
        self.labelCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 49*52, height)];
        for (int i = 1; i <= 49; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(52*(i - 1), 0, 52, height)];
            [label setBackgroundColor:[UIColor clearColor]];
            label.textColor = [UIColor brownColor];
            
            label.font = [UIFont boldSystemFontOfSize:28];
            label.text = [NSString stringWithFormat:@"%d", i + 1];
            label.textAlignment = UITextAlignmentCenter;
            [labelCell addSubview:label];
        }
        labelCell.center = CGPointMake(49*26, labelCell.center.y);
        [self addSubview:labelCell];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (int)getLabelIndex{
//    return 29 - self.labelCell.center.x/52;
    return (width/2-self.center.x)/sectionWidth+length/2+(length%2?0.5:0);
}

-(void)animationAfterDeceleration
{
	[UIView animateWithDuration:0.3 animations:^(void) {
        self.center=CGPointMake(sectionWidth*(length/2-[self getLabelIndex]-(length%2?0:0.5))+width/2,self.center.y);}];
    NSLog(@"index = %d",[self getLabelIndex]);
	
}
-(void)moveLimiting
{
	if (self.center.x<1-length*sectionWidth/2+width/2)
	{
		self.center=CGPointMake(1-length*sectionWidth/2+width/2, self.center.y);
		velocity*=-1;
	}else if (self.center.x>length*sectionWidth/2+width/2-1) 
	{
		self.center=CGPointMake(length*sectionWidth/2+width/2-1, self.center.y);
		velocity*=-1;
	}
}
-(void) decelerate
{
	float maxSpeed=28.0;
	velocity=velocity<-maxSpeed?-maxSpeed:velocity;
	velocity=velocity>maxSpeed?maxSpeed:velocity;
	if (fabs(velocity*=0.9)<0.06&&[timer isValid])
	{
		[timer invalidate];
		timer=nil;
		[self animationAfterDeceleration];
		return;
	}
	self.center=CGPointMake(self.center.x-velocity,self.center.y);
	[self moveLimiting];
}
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{	
	if ([timer isValid]) 
	{
		[timer invalidate];
		timer=nil;
	}
	[self.layer removeAllAnimations];
	startPoint = [[touches anyObject] locationInView:self];
	lastPoint=startPoint;
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	currentPoint = [[touches anyObject] locationInView:self];
	lastPoint=currentPoint;
	self.center=CGPointMake(self.center.x+currentPoint.x-startPoint.x,self.center.y);
	[self moveLimiting];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch*endTouch=[touches anyObject];
	endPoint=[endTouch locationInView:self];
	velocity=endPoint.x-lastPoint.x;
	if (fabs(velocity)<0.06||[event timestamp]-[endTouch timestamp]>0.3) 
	{
		[self animationAfterDeceleration];
		return;
	}
	timer=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(decelerate) userInfo:nil repeats:YES];
}

- (void)dealloc 
{
    [super dealloc];
	if ([timer isValid]) 
	{
		[timer invalidate];
		timer=nil;
	}
}

@end
