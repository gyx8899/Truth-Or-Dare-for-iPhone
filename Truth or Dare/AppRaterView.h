//
//  AppRaterView.h
//  Period Planner
//
//  Created by SL02 on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppRaterView : UIViewController {

	UIImageView *				titleImage;
	UIButton *					rateBtn;
	UIButton *					laterBtn;
	UIButton *					thankBtn;
}
@property (nonatomic, retain) IBOutlet UIButton *		rateBtn;
@property (nonatomic, retain) IBOutlet UIButton *		laterBtn;
@property (nonatomic, retain) IBOutlet UIButton *		thankBtn;
@property (nonatomic, retain) IBOutlet UIImageView *	titleImage;
-(IBAction)BtnPressed:(id)sender;
@end
