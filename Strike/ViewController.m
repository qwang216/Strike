//
//  ViewController.m
//  Strike
//
//  Created by Jason Wang on 2/14/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "ViewController.h"

#import <Spark-SDK/Spark-SDK.h>
#import <SparkSetup/SparkSetup.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic) __block SparkDevice *myPhoton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)SigninButtonTapped:(UIButton *)sender {
    // log out any previous account that's saved
    [[SparkCloud sharedInstance] logout];
    
    [[SparkCloud sharedInstance] loginWithUser:self.emailTextField.text password:self.passwordTextField.text completion:^(NSError *error) {
        if (!error) {
            [self presentWelcomeVC];
        } else {
            NSLog(@"ViewController: Login error ==> %@", error.localizedDescription);
        }
    }];
    
}



- (void)presentWelcomeVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
    [self presentViewController:welcomeVC animated:YES completion:nil];
}

- (IBAction)savedUserInfoLoginButtonTapped:(UIButton *)sender {
    if ([SparkCloud sharedInstance].accessToken) {
        [self presentWelcomeVC];
        NSLog(@"call presentWelcomeVC method");
    } else {
        NSLog(@"accessToken = %@", [SparkCloud sharedInstance].accessToken);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
