//
//  LoginSignupViewController.m
//  Strike
//
//  Created by Jason Wang on 2/15/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "LoginSignupViewController.h"
#import "User.h"

@interface LoginSignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic) User *currentUser;

@end

@implementation LoginSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [[User alloc]initWithFireBaseAccount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButtonTapped:(UIButton *)sender {
    [self.currentUser loginFireBaseWithEmail:self.emailTextField.text andPW:self.passwordTextField.text completionHandler:^(NSError *error, FAuthData *authData) {
        if (!error) {
            NSLog(@"login success");
        }
    }];
}
- (IBAction)registerButtonTapped:(UIButton *)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
