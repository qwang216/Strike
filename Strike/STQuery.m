//
//  STQuery.m
//  Strike
//
//  Created by Jason Wang on 3/13/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "STQuery.h"
#import "User.h"


@implementation STQuery

+ (void)queryUserWithEmail:(NSString *)email handler:(void (^)(User *foundUser))onCompletion {
    Firebase *registeredUserRef = [[Firebase alloc]initWithUrl:@"https://strike7.firebaseio.com/registered_users"];
    [[[registeredUserRef queryOrderedByChild:@"username"]queryEqualToValue:email] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"snapshot = %@",snapshot);
        if (snapshot.value == [NSNull null]) {
            onCompletion(nil);
        } else {
            NSString *uid = [snapshot.value allKeys][0];
            User *foundUser = [User new];
            foundUser.username = snapshot.value[uid][@"username"];
            foundUser.name = snapshot.value[uid][@"name"];
            foundUser.profileImageURL = snapshot.value[uid][@"profileImageURL"];
            foundUser.uid = uid;
            onCompletion(foundUser);
        }
    }];
}


+ (void)queryContactListWithCompletionBlock:(void (^)(NSArray <User*> *contactsList))onCompletion {
    NSString *currentUserUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserUid"];
    if (currentUserUid) {
        Firebase *queryFriend = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://strike7.firebaseio.com/contacts/%@/accepted_contactslist",currentUserUid]];
        [queryFriend observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSMutableArray <User *>*contactList = [NSMutableArray new];
            for (FDataSnapshot *contactFriend in snapshot.children) {
                User *contactUser = [[User alloc]init];
                contactUser.username = contactFriend.value[@"username"];
                contactUser.name = contactFriend.value[@"name"];
                contactUser.profileImageURL = contactFriend.value[@"profileImageURL"];
                [contactList addObject:contactUser];
            }
            onCompletion(contactList);
        }];
    } else {
        onCompletion(nil);
    }
}

+ (void)queryPendingContactListWithCompletionBlock:(void (^)(NSArray <User *> *pendingList))onCompletion {
    NSString *currentUserUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserUid"];
    if (currentUserUid) {
        Firebase *friendRequestQuery = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://strike7.firebaseio.com/contacts/%@/friend_request_contactslist",currentUserUid]];
        [friendRequestQuery observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSMutableArray <User *> *pendingRequestArray = [NSMutableArray new];
            if (snapshot.value != [NSNull null]) {
                for (FDataSnapshot *pendingRequest in snapshot.children) {
                    User *pendingUser = [User new];
                    pendingUser.username = pendingRequest.value[@"username"];
                    [pendingRequestArray addObject:pendingUser];
                }
                onCompletion(pendingRequestArray);
            } else {
                onCompletion(pendingRequestArray);
            }
        }];
        
    }
}

@end
