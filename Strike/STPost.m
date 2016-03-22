//
//  STPost.m
//  Strike
//
//  Created by Jason Wang on 3/16/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "STPost.h"

@implementation STPost


// add pending user to accepted_contactslist
+ (void)addUserOnContactListWithUserObject:(User *)user handler:(void(^)(BOOL didSuccessed))onCompletion {
    NSString *currentUserUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserUid"];
    if (currentUserUid) {
        Firebase *postFriend = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://strike7.firebaseio.com/contacts/%@/accepted_contactslist/",currentUserUid]];
        Firebase *postFriendList = [postFriend childByAutoId];
        NSDictionary *userDic = @{@"username":user.username};
        [postFriendList setValue:userDic];
        onCompletion(YES);
    } else {
        onCompletion(NO);
    }

}


@end
