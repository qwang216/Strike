//
//  ProfileViewController.m
//  Strike
//
//  Created by Jason Wang on 2/19/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "ProfileViewController.h"
#import <FireBase/Firebase.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic) UITextField *alertViewEmailTextField;
@property (nonatomic) NSString *uid;
@property (nonatomic) Firebase *acctRef;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    self.acctRef = [[Firebase alloc]initWithUrl:@"https://strike7.firebaseio.com"];
    if (self.uid) {
        Firebase *profileURLRef = [[[self.acctRef childByAppendingPath:@"register_user"] childByAppendingPath:self.uid] childByAppendingPath:@"profileImageURL"];
        [profileURLRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
            [self profilePicURLFromUserData:snapshot.value[@"profileImageURL"]];
        }];
    } else {
        NSLog(@"no uid");
    }
}

- (void)queryFriendsList {
    Firebase *frdListRef = [[[self.acctRef childByAppendingPath:@"friends_list"] childByAppendingPath:self.uid] childByAppendingPath:@"friend_accepted"];
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
    UIAlertController *queryAlert = [UIAlertController alertControllerWithTitle:@"Search Friends" message:@"Please enter your friend's Email" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *search = [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self queryUserOnFireBaseWithEmail:self.alertViewEmailTextField.text];
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

- (void)queryUserOnFireBaseWithEmail:(NSString *)email {
    Firebase *registeredUserRef = [self.acctRef childByAppendingPath:@"registered_users"];
    [registeredUserRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@" snapshot for registered user = %@",snapshot);
        for (FDataSnapshot *child in snapshot.children) {
            if ([child.value[@"email"] isEqualToString:email]) {
                NSLog(@"%@", child.value[@"email"]);
                NSLog(@"%@", child.value[@"name"]);
                NSLog(@"%@", child.value[@"profileImageURL"]);
            } else {
                NSLog(@"User not found");
            }
        }
        
    }];
}


- (IBAction)logoutButtonTapped:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [self popToLoginScreen];
}

- (void)popToLoginScreen {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginSignupVCID"];
    [self presentViewController:loginVC animated:NO completion:nil];
    
}

- (void)profilePicURLFromUserData:(NSString *)profileURL {
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: profileURL]];
        if (data == nil) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.profileImageView.image = [UIImage imageWithData: data];

        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"ProfileViewController didReceiveMemoryWarning");
}

@end
