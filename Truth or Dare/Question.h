//
//  Question.h
//  Truth or Dare
//  Question instance, include true and dare type.
//  Created by YQ-010 on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
@property (nonatomic, retain) NSString *content;
@property int id;
@property (nonatomic, retain) NSString *truthOrDare;
@end
