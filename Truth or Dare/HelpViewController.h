//
//  HelpViewController.h
//  Truth or Dare
//
//  Created by YQ-010 on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface HelpViewController : UIViewController<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
- (IBAction)homeBtnPressed:(id)sender;
- (IBAction)contactBtnPressed:(id)sender;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
@end
