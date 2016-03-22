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
@property (nonatomic) UITextField *alertViewEmailTextField;
@property (nonatomic) NSString *currentUserUid;
@property (nonatomic) Firebase *acctRef;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUserUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserUid"];
    NSLog(@"%@",self.currentUserUid);
    self.acctRef = [[Firebase alloc]initWithUrl:@"https://strike7.firebaseio.com"];
}

- (void)queryFriendsList {
    Firebase *frdListRef = [[[self.acctRef childByAppendingPath:@"friends_list"] childByAppendingPath:self.currentUserUid] childByAppendingPath:@"friend_accepted"];
    [frdListRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value == [NSNull null]) {
            // no friends list
        } else {
            // grab email and query all of them
        }
    }];
    
}
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

- (void)popToLoginScreen {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginSignupVCID"];
    [self presentViewController:loginVC animated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"ProfileViewController didReceiveMemoryWarning");
}

- (void)queryUserWithEmail {
    [STQuery queryUserWithEmail:self.alertViewEmailTextField.text handler:^(User *foundUser) {
        NSLog(@"%@",foundUser);
        if (foundUser) {
                [self displayFriendFoundAlertViewWithUserInfo:foundUser];
        }else {
            NSLog(@"user not found");
        }
        
    }];
}

#pragma mark -
#pragma mark Alert Views

- (void)searchFriendAlertView {
    UIAlertController *queryAlert = [UIAlertController alertControllerWithTitle:@"Search Friends" message:@"Please enter your friend's Email" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *search = [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self queryUserWithEmail];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [queryAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.alertViewEmailTextField = textField;
    }];
    [queryAlert addAction:cancel];
    [queryAlert addAction:search];
    [self presentViewController:queryAlert animated:YES completion:nil];
}

- (void)displayFriendFoundAlertViewWithUserInfo:(User *)foundUser {
    UIAlertController *foundUserAlertView = [UIAlertController alertControllerWithTitle:@"User Found" message:[NSString stringWithFormat:@"Name: %@ Email: %@",foundUser.name, foundUser.username] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [STPost addUserOnContactListWithUserObject:foundUser handler:^(BOOL didSuccessed) {
            if (didSuccessed) {
                NSLog(@"user added");
            } else {
                NSLog(@"adding user erro");
            }
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [foundUserAlertView addAction:cancel];
    [foundUserAlertView addAction:add];
    [self presentViewController:foundUserAlertView animated:YES completion:nil];
}

@end
