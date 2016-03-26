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
// query user with email/username
+ (void)queryUserWithEmail:(NSString *)email handler:(void (^)(User *foundUser))onCompletion {
    Firebase *registeredUserRef = [[Firebase alloc]initWithUrl:@"https://strike7.firebaseio.com/users"];
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

// Query contact list
+ (void)queryContactListWithCompletionBlock:(void (^)(NSArray <User*> *contactsList))onCompletion {
    if ([self currentUserUid]) {
        Firebase *queryFriend = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://strike7.firebaseio.com/contacts/%@/contactlist",[self currentUserUid]]];
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
        NSLog(@"no uid");
        onCompletion(nil);
    }
}

// Check if there's a pending request
+ (void)queryPendingContactListWithCompletionBlock:(void (^)(NSArray <User *> *pendingList))onCompletion {
    if ([self currentUserUid]) {
        Firebase *friendRequestQuery = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://strike7.firebaseio.com/frdRequest/%@",[self currentUserUid]]];
        Firebase *friendRequestList = [friendRequestQuery childByAutoId];
        [friendRequestList observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
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
        
    } else {
        NSLog(@"NO UID");
        onCompletion(nil);
    }
}

// check for duplicate contact
+ (BOOL)checkDuplicateUserInAcceptedContact:(NSString *)username {
    __block BOOL isDuplicated;
    if ([self currentUserUid]) {
        Firebase *acceptedListQuery = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://strike7.firebaseio.com/contacts/%@/contactslist",[self currentUserUid]]];
        [[[acceptedListQuery queryOrderedByChild:@"username"] queryEqualToValue:username] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            if (snapshot.value == [NSNull null]) {
                isDuplicated = NO;
            } else {
                isDuplicated = YES;
            }
        }];
    }
    return isDuplicated;
}


//+ (void)checkDuplicateUserInAcceptedContact:(NSString *)username completion:(void(^)(BOOL isDuplicated))onCompletion {
//    if ([self currentUserUid]) {
//        Firebase *acceptedListQuery = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://strike7.firebaseio.com/contacts/%@/contactslist",[self currentUserUid]]];
//        [[[acceptedListQuery queryOrderedByChild:@"username"] queryEqualToValue:username] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//            if (snapshot.value == [NSNull null]) {
//                onCompletion(NO);
//            } else {
//                onCompletion(YES);
//            }
//        }];
//    }
//}


// current user id
+ (NSString *)currentUserUid {
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserUid"];
    NSLog(@"currentUserUid = %@",uid);
    
    if (uid) {
        return uid;
    } else {
        return nil;
    }
}

@end
