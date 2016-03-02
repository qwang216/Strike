//
//  RegisterViewController.m
//  Strike
//
//  Created by Jason Wang on 3/2/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "RegisterViewController.h"
#import "User.h"

@interface RegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic) User *currentUser;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [[User alloc]initWithFireBaseAccount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"RegisterVC Memory Warning");
}

- (void)pushToTabBarController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"tabBarControllerID"];
    [self presentViewController:welcomeVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark IBActions
- (IBAction)registerButtonTapped:(UIButton *)sender {
    [self registerNameEmailAndPasswordToFireBase];
}
- (IBAction)cancelButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerNameEmailAndPasswordToFireBase {
    [self.currentUser registerFireBaseWithEmail:self.emailTextField.text andPW:self.passwordTextField.text withname:self.nameTextField.text completionHandler:^(NSError *error) {
        if (!error) {
            [self pushToTabBarController];
        } else {
            [self alertWithError:[error.userInfo objectForKeyedSubscript:NSLocalizedDescriptionKey]];
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
