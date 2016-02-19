//
//  LoginSignupViewController.m
//  Strike
//
//  Created by Jason Wang on 2/15/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "LoginSignupViewController.h"
#import "User.h"
#import "Email.h"

@interface LoginSignupViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic) User *currentUser;

@end

@implementation LoginSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [[User alloc]initWithFireBaseAccount];
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)presentWelcomeVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
    [self presentViewController:welcomeVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)loginButtonTapped:(UIButton *)sender {
    [self.currentUser loginFireBaseWithEmail:self.emailTextField.text andPW:self.passwordTextField.text completionHandler:^(NSError *error, FAuthData *authData) {
        if (!error) {
            [self presentWelcomeVC];
        } else {
            [self alertWithError:[error.userInfo objectForKeyedSubscript:NSLocalizedDescriptionKey]];
            NSLog(@"%@",error);
        }
    }];
}
- (IBAction)registerButtonTapped:(UIButton *)sender {
    [self alerViewForRegisterUser];
}

#pragma mark -
#pragma mark Alert Methods

- (void)alerViewForRegisterUser {
    UIAlertController *regUser = [UIAlertController alertControllerWithTitle:@"Register" message:@"Please enter a valid Email" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *reg = [UIAlertAction actionWithTitle:@"Register" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *userInputEmail = regUser.textFields[0].text;
        NSString *userInputPW1 = regUser.textFields[1].text;
        NSString *userInputPW2 = regUser.textFields[2].text;
        if ([Email validateEmailWithString:userInputEmail] && [userInputPW1 isEqualToString:userInputPW2]) {
            [self.currentUser registerFireBaseWithEmail:userInputEmail andPW:userInputPW1 completionHandler:^(NSError *error) {
                if (!error) {
                    [self presentWelcomeVC];
                } else {
                    [self alertWithError:[error.userInfo objectForKeyedSubscript:NSLocalizedDescriptionKey]];
                    
                }
            }];
        } else if (![Email validateEmailWithString:userInputEmail]){
            [self alertWithError:@"Invalid Email Input"];
        } else {
            [self alertWithError:@"Re-Enter Password Not Matching"];
        }
    }];
    [regUser addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Email";
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
    }];
    [regUser addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    [regUser addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Re-Enter Password";
        textField.secureTextEntry = YES;
    }];
    [regUser addAction:cancel];
    [regUser addAction:reg];
    [self presentViewController:regUser animated:YES completion:nil];
}

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
