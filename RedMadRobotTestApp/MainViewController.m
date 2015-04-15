//
//  MainViewController.m
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 13.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import "MainViewController.h"
#import "NetworkUtilites.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCollageButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.usernameTextField becomeFirstResponder];
    [self.usernameTextField addTarget:self
                               action:@selector(getCollage:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    [self registerForKeyboardNotifications];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    [super viewWillDisappear:animated];
}

- (void)registerForKeyboardNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

}

- (void)deregisterFromKeyboardNotifications {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];

}


- (void)keyboardDidShow:(NSNotification *)notification {

    NSDictionary* info = [notification userInfo];

    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect visibleRect = self.view.frame;
    visibleRect.size.height -= keyboardSize.height;

    float elementsHeight = CGRectGetMaxY(self.getCollageButton.frame) - CGRectGetMinY(self.usernameTextField.frame);
    float scrollPointY = CGRectGetMinY(self.usernameTextField.frame) - ((visibleRect.size.height - elementsHeight) / 2);

    CGPoint scrollPoint = CGPointMake(0.0, scrollPointY);
    [_scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)getCollage:(id)sender {
    [self.usernameTextField resignFirstResponder];
    NSString *username = [self.usernameTextField.text lowercaseString];

    [SVProgressHUD showWithStatus:NSLocalizedString(@"SEARCH", @"") maskType:SVProgressHUDMaskTypeBlack];

    [NetworkUtilites getUserWithUserName:username completion:^(RMRUser *user, NSError *error) {
        if (!error) {
            if (user != nil) {
                [[NSUserDefaults standardUserDefaults] setObject:user.idx forKey:kRMRCurrentUserIdKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //[SVProgressHUD dismiss];
                [self checkUserPermissions];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"NO_USERS", @"")];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }
    }];
}

- (void)checkUserPermissions
{
    //[SVProgressHUD showWithStatus:NSLocalizedString(@"CHECK", @"") maskType:SVProgressHUDMaskTypeBlack];

    [NetworkUtilites checkUserPermissionsWintCompletion:^(BOOL result, NSError *error) {
        if (result) {
            [SVProgressHUD dismiss];
            [self performSegueWithIdentifier:@"showCollage" sender:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"PERMISSION_DENIED", @"")];
        }
    }];
}

@end
