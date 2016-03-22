//
//  LoginSignupViewController.m
//  Strike
//
//  Created by Jason Wang on 2/15/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "Email.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic) User *currentUser;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.currentUser = [[User alloc]initWithFireBaseAccount];
        self.emailTextField.delegate = self;
        self.passwordTextField.delegate = self;
}

- (void)pushToTabBarController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"tabBarControllerID"];
    [self presentViewController:welcomeVC animated:YES completion:nil];
}


#pragma mark -
#pragma mark IBActions

- (IBAction)loginButtonTapped:(UIButton *)sender {
    [self.currentUser loginFireBaseWithEmail:self.emailTextField.text andPW:self.passwordTextField.text completionHandler:^(NSError *error, FAuthData *authData) {
        if (!error) {
            [self pushToTabBarController];
        } else {
            [self alertWithError:[error.userInfo objectForKeyedSubscript:NSLocalizedDescriptionKey]];
            NSLog(@"%@",error);
        }
    }];
}

- (IBAction)loginWithTwitterButtonTapped:(UIButton *)sender {
    [self.currentUser loginFireBaseWithTwitterCompletion:^(BOOL didSignIn, NSError *error) {
        if (didSignIn) {
            [self pushToTabBarController];
        } else {
            NSLog(@"Twitter login Erro = %@",error.localizedDescription);
        }
    }];
    
}

#pragma mark -
#pragma mark Alert Methods

- (void)alertWithError:(NSString *)error {
    UIAlertController *regErro = [UIAlertController alertControllerWithTitle:@"Error" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [regErro addAction:ok];
    [self presentViewController:regErro animated:YES completion:nil];
}


#pragma mark -
#pragma mark TextField Delegation

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

@end
