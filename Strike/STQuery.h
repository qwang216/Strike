//
//  STQuery.h
//  Strike
//
//  Created by Jason Wang on 3/13/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import "User.h"

@interface STQuery : NSObject

+ (NSString *)currentUserUid;
+ (void)queryUserWithEmail:(NSString *)email handler:(void (^)(User *foundUser))onCompletion;
+ (void)queryContactListWithCompletionBlock:(void (^)(NSArray <User*>* contactsList))onCompletion;
//+ (void)checkDuplicateUserInAcceptedContact:(NSString *)user completion:(void(^)(BOOL isDuplicated))onCompletion;
+ (BOOL)checkDuplicateUserInAcceptedContact:(NSString *)username;

@end
