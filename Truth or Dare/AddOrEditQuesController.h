//
//  AddOrEditQuesController.h
//  Truth or Dare
//
//  Created by YQ-010 on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLite3Util.h"
@interface AddOrEditQuesController : UIViewController
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSString *content;
@property int id;
@property int type;
- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)saveBtnPressed:(id)sender;
@end
