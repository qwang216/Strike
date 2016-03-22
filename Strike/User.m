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
            [self storeUIDLocally:authData];
            onCompletion(nil,authData);
        }
        onCompletion(error,nil);
    }];
}

- (void)registerFireBaseWithEmail:(NSString *)email andPW:(NSString *)password withname:(NSString *)name completionHandler: (void (^)(NSError *error))onCompletion {
    
    [self.acctRef createUser:email password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
        if (!error) {
            [self.acctRef authUser:email password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
                if (!error) {
                    NSDictionary * userDict = @{@"name":name, @"username":email};
                    [self saveUserDataToFireBase:authData withDict:userDict];
                    onCompletion(error);
                }
            }];
        }
    }];
}

- (void)loginFireBaseWithTwitterCompletion:(void(^)(BOOL didSignIn, NSError *error))onCompletion {
    TwitterAuthHelper *twitterAuthHelper = [[TwitterAuthHelper alloc] initWithFirebaseRef:self.acctRef apiKey:@"ZJT3XZ1M4dPV1tU9KvaqpSx8r"];
    [twitterAuthHelper selectTwitterAccountWithCallback:^(NSError *error, NSArray *accounts) {
        if (!error) {
#warning getting the first twitter objc just for simplicity
            ACAccount *twitterAcount = [accounts firstObject];
            [twitterAuthHelper authenticateAccount:twitterAcount withCallback:^(NSError *error, FAuthData *authData) {
                if (!error) {
                    NSDictionary *userDict = @{@"name":authData.providerData[@"displayName"], @"username": authData.providerData[@"username"]};
                    [self saveUserDataToFireBase:authData withDict:userDict];
                    onCompletion(YES, nil);
                } else {
                    onCompletion(NO, error);
                }
            }];
        }
    }];
}

#pragma mark - 
#pragma mark Save User Info

- (void)saveUserDataToFireBase:(FAuthData *)authData withDict:(NSDictionary *)userDict {
    
    if (userDict) {
        NSMutableDictionary *currentUserData = [NSMutableDictionary dictionaryWithDictionary:userDict];
        [currentUserData setObject:authData.providerData[@"profileImageURL"] forKey:@"profileImageURL"];
        [[[self.acctRef childByAppendingPath:@"registered_users"] childByAppendingPath:authData.uid] setValue:currentUserData];
    } else {
        NSMutableDictionary *currentUserData = [NSMutableDictionary new];
        [currentUserData setObject:authData.providerData[@"profileImageURL"] forKey:@"profileImageURL"];
        [[[self.acctRef childByAppendingPath:@"registered_users"] childByAppendingPath:authData.uid] setValue:currentUserData];
    }
    
    [self storeUIDLocally:authData];
}

- (void)storeUIDLocally:(FAuthData *)authData {

  [[NSUserDefaults standardUserDefaults] setObject:authData.uid forKey:@"currentUserUid"];
    
}

@end
