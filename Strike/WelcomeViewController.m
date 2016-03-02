//
//  WelcomeViewController.m
//  Strike
//
//  Created by Jason Wang on 2/14/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

#import "WelcomeViewController.h"
#import <SparkSetup/SparkSetup.h>
#import <Spark-SDK/SparkCloud.h>

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (nonatomic) __block SparkDevice *myPhoton;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self grabDevice];
    NSLog(@"WelcomeVC: ViewDidLoad accessToken = %@",[SparkCloud sharedInstance].accessToken);
}

-(void)grabDevice {
    [[SparkCloud sharedInstance] getDevices:^(NSArray *sparkDevices, NSError *error) {
        NSLog(@"Device Array == %@", sparkDevices);
        for (SparkDevice *device in sparkDevices) {
            if ([device.name isEqualToString:@"Strike"]) {
                self.myPhoton = device;
                self.welcomeLabel.text = device.name;
            }
        }
    }];
}

- (IBAction)redLEDSwitchTapped:(UISwitch *)sender {
    NSLog(@"led1 touched");
    if (sender.on) {
        [self.myPhoton callFunction:@"led1" withArguments:@[@"ON"] completion:^(NSNumber *resultCode, NSError *error) {
            
            if (!error) {
                NSLog(@"LED D0 should be ON");
                NSLog(@"result code for ON == %@",resultCode);
            } else {
                NSLog(@"erro message == %@",error.userInfo);
            }
        }];
    } else {
        [self.myPhoton callFunction:@"led1" withArguments:@[@"OFF"] completion:^(NSNumber *resultCode, NSError *error) {
            if (!error) {
                NSLog(@"LED D0 should be OFF");
                NSLog(@"result code for OFF == %@",resultCode);
            }
        }];
    }
}

- (IBAction)d7LEDSwitchedTapped:(UISwitch *)sender {
    NSLog(@"led2 touched");
    if (sender.on) {
        [self.myPhoton callFunction:@"led2" withArguments:@[@"ON"] completion:^(NSNumber *resultCode, NSError *error) {
            
            if (!error) {
                NSLog(@"LED D7 should be ON");
                NSLog(@"result code for ON == %@",resultCode);
            } else {
                NSLog(@"erro message == %@",error.userInfo);
            }
        }];
    } else {
        [self.myPhoton callFunction:@"led2" withArguments:@[@"OFF"] completion:^(NSNumber *resultCode, NSError *error) {
            if (!error) {
                NSLog(@"LED D7 should be OFF");
                NSLog(@"result code for OFF == %@",resultCode);
            }
        }];
    }
}


- (IBAction)logoutButtonTapped:(UIButton *)sender {
    
    [[SparkCloud sharedInstance] logout];
    
//    [[SparkCloud sharedInstance] loginWithUser:self.keys.username password:self.keys.password completion:^(NSError *error) {
//        NSLog(@"Logback to keysAccount");
//    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)fetchDeviceNameButtonTapped:(UIButton *)sender {
    [self grabDevice];
}
- (IBAction)setupDeviceButtonTapped:(UIButton *)sender {
    [[SparkCloud sharedInstance] logout];
    
    SparkSetupMainController *setupController = [[SparkSetupMainController alloc]init];
    [self presentViewController:setupController animated:YES completion:nil];
    
    [self grabDevice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
