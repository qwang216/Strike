//
//  User.m
//  Strike
//
//  Created by Jason Wang on 2/16/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "User.h"
#import "Email.h"
#import "TwitterAuthHelper.h"
#import <Accounts/ACAccount.h>

@implementation User

- (instancetype)initWithFireBaseAccount {
    if (self = [super init]) {
        self.acctRef = [[Firebase alloc]initWithUrl:@"https://strike7.firebaseio.com"];
        return self;
    }
    return nil;
}


#pragma mark -
#pragma mark UserLoginRegister

- (void)loginFireBaseWithEmail:(NSString *)email andPW:(NSString *)password completionHandler: (void (^)(NSError *error, FAuthData *authData))onCompletion {
    [self.acctRef authUser:email password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (!error) {
            // query from fire base using uid abt userinfo
        }
        onCompletion(error,authData);
    }];
}

- (void)registerFireBaseWithEmail:(NSString *)email andPW:(NSString *)password withname:(NSString *)name completionHandler: (void (^)(NSError *error))onCompletion {
    
    [self.acctRef createUser:email password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
        if (!error) {
            [self.acctRef authUser:email password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
                if (!error) {
                    NSDictionary * userDict = @{@"name":name, @"email":email};
                    [self saveUserInfoUnderRegisteredUserAndUserPoolWith:authData withDict:userDict];
                    onCompletion(error);
                }
            }];
        }
    }];
}

- (void)loginFireBaseWithTwitter {
    TwitterAuthHelper *twitterAuthHelper = [[TwitterAuthHelper alloc] initWithFirebaseRef:self.acctRef apiKey:@"ZJT3XZ1M4dPV1tU9KvaqpSx8r"];
    [twitterAuthHelper selectTwitterAccountWithCallback:^(NSError *error, NSArray *accounts) {
        if (!error) {
#warning getting the first twitter objc just for simplicity
            ACAccount *twitterAcount = [accounts firstObject];
            [twitterAuthHelper authenticateAccount:twitterAcount withCallback:^(NSError *error, FAuthData *authData) {
                if (!error) {
                    // set twitter to firebase
                }
            }];
        }
    }];
}

#pragma mark - 
#pragma mark Save User Info

- (void)saveUserInfoUnderRegisteredUserAndUserPoolWith:(FAuthData *)authData withDict:(NSDictionary *)userDict {
    NSMutableDictionary *currentUserData = [NSMutableDictionary dictionaryWithDictionary:userDict];
    [currentUserData setObject:authData.providerData[@"profileImageURL"] forKey:@"profileImageURL"];
    
    [[NSUserDefaults standardUserDefaults] setObject:authData.uid forKey:@"uid"];
    [[[self.acctRef childByAppendingPath:@"registered_users"] childByAppendingPath:authData.uid] setValue:currentUserData];
    [self setupUserFriendsList:authData];
}

- (void)setupUserFriendsList:(FAuthData *)authData {
    [[self.acctRef childByAppendingPath:@"friends_list"] childByAppendingPath:authData.uid];
    [[self.acctRef childByAppendingPath:@"friends_list"] childByAppendingPath:@"friends_request"];
}

@end
