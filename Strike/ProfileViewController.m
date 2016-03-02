//
//  ProfileViewController.m
//  Strike
//
//  Created by Jason Wang on 2/19/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *profileImageURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"profileImageURL"];
    [self profilePicURL:profileImageURL];
    
    NSDictionary *userDict = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"userDict"];
    NSLog(@"user dictionary %@",userDict);
}
- (IBAction)friendsLockSettingSegmentControl:(UISegmentedControl *)sender {
    
}
- (IBAction)profilePicButtonTapped:(UIButton *)sender {
}
- (IBAction)addFriendButtonTapped:(UIButton *)sender {
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

- (void)profilePicURL:(NSString *)twitterPicURLString {
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: twitterPicURLString]];
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
