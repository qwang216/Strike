//
//  Email.h
//  Strike
//
//  Created by Jason Wang on 2/16/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Email : NSObject

+ (BOOL)validateEmailWithString:(NSString*)email;

@end
