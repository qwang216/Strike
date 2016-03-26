//
//  ProfileViewController.m
//  Strike
//
//  Created by Jason Wang on 2/19/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "ProfileViewController.h"
#import "STQuery.h"
#import "STPost.h"
#import <FireBase/Firebase.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic) NSString *currentUserUid;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUserUid = [STQuery currentUserUid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"ProfileViewController didReceiveMemoryWarning");
}

- (void)popToLoginScreen {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginSignupVCID"];
    [self presentViewController:loginVC animated:NO completion:nil];
    
}

- (void)queryUserWithEmail:(NSString *)email {
    [STQuery queryUserWithEmail:email handler:^(User *foundUser) {
        if (foundUser) {
            [self isUserAlreadyInContactList:foundUser];
        }else {
            NSLog(@"user not found");
        }
        
    }];
}

- (void)isUserAlreadyInContactList:(User *)user{
    if ([STQuery checkDuplicateUserInAcceptedContact:user.name]) {
        [self displayAlertViewWithDuplicatedContactUser:user];
    } else {
        [self displayUserFoundAlertViewWithUserInfo:user];
    }
}

- (void)addUserToContactList:(User *)user {
    [STPost addUserOnContactListWithUserObject:user handler:^(BOOL didSuccessed) {
        // debuging purpose
        if (didSuccessed) {
            NSLog(@"user added");
        } else {
            NSLog(@"adding user erro");
        }
    }];
}

#pragma mark -
#pragma mark IBAction

- (IBAction)friendsLockSettingSegmentControl:(UISegmentedControl *)sender {
    
}
- (IBAction)profilePicButtonTapped:(UIButton *)sender {
    
}
- (IBAction)addFriendButtonTapped:(UIButton *)sender {
    [self searchFriendAlertView];
}
- (IBAction)logoutButtonTapped:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserUid"];
    [self popToLoginScreen];
}

#pragma mark -
#pragma mark Alert Views

// search user alert
- (void)searchFriendAlertView {
    UIAlertController *queryAlert = [UIAlertController alertControllerWithTitle:@"Search Friends" message:@"Please enter your friend's Email" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *search = [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self queryUserWithEmail:queryAlert.textFields[0].text];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [queryAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [queryAlert addAction:cancel];
    [queryAlert addAction:search];
    [self presentViewController:queryAlert animated:YES completion:nil];
}

// user found alert
- (void)displayUserFoundAlertViewWithUserInfo:(User *)foundUser {
    UIAlertController *foundUserAlertView = [UIAlertController alertControllerWithTitle:@"User Found" message:[NSString stringWithFormat:@"Name: %@ Email: %@",foundUser.name, foundUser.username] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addUserToContactList:foundUser];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [foundUserAlertView addAction:cancel];
    [foundUserAlertView addAction:add];
    [self presentViewController:foundUserAlertView animated:YES completion:nil];
}

// duplicate contact list alert
- (void)displayAlertViewWithDuplicatedContactUser:(User *)user {
    UIAlertController *duplicatedContactAC = [UIAlertController alertControllerWithTitle:@"Duplicated Contact" message:[NSString stringWithFormat:@"%@ is already on contact list",user.username] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [duplicatedContactAC addAction:ok];
    [self presentViewController:duplicatedContactAC animated:YES completion:nil];
}

// no user found alert
- (void)displayAlertViewWithNoUserFound:(User *)user {
    UIAlertController *noUserFound = [UIAlertController alertControllerWithTitle:@"No User Found" message:[NSString stringWithFormat:@"No user associate it with %@",user.username] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [noUserFound addAction:ok];
    [self presentViewController:noUserFound animated:YES completion:nil];
}

@end
