//
//  User.h
//  Strike
//
//  Created by Jason Wang on 2/16/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface User : NSObject
@property (nonatomic) Firebase *acctRef;
@property (nonatomic) NSUserDefaults *authDataDefualts;

- (instancetype)initWithFireBaseAccount;
- (void)loginFireBaseWithEmail:(NSString *)email andPW:(NSString *)password completionHandler: (void (^)(NSError *error, FAuthData *authData))onCompletion;
- (void)registerFireBaseWithEmail:(NSString *)email andPW:(NSString *)password withname:(NSString *)name completionHandler: (void (^)(NSError *error))onCompletion;
- (void)loginFireBaseWithTwitter;
@end
