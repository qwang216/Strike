//
//  STPost.h
//  Strike
//
//  Created by Jason Wang on 3/16/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface STPost : NSObject

+ (void)addUserOnContactListWithUserObject:(User *)user handler:(void(^)(BOOL didSuccessed))onCompletion;

@end
