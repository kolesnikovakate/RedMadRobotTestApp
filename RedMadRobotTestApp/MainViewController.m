//
//  MainViewController.m
//  RedMadRobotTestApp
//
//  Created by Екатерина Колесникова on 13.04.15.
//  Copyright (c) 2015 Kolesnikova Ekaterina. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"
#import "JSONParser.h"
#import "UIAlertView+RMRTest.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCollageButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = YES;

    [self.usernameTextField becomeFirstResponder];
    [self.usernameTextField addTarget:self
                               action:@selector(getCollage)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [self getCollage];
}

- (void)getCollage
{
    [self.usernameTextField resignFirstResponder];
    NSString *username = [self.usernameTextField.text lowercaseString];
    NSString *completeRequestUrl = @"https://api.instagram.com/v1/users/search/";
    NSDictionary *parameters = @{@"q": username,
                                 @"client_id": kRMRClientId};

    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:completeRequestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *userId = [JSONParser parseJSONdata:responseObject andFindUserIdByUsername:username];
        if (userId != nil) {
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kRMRCurrentUserIdKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            [[UIAlertView alertRMRNoFindUsers] show];
        }
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIAlertView alertRMRUnknownError] show];
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
    }];
}

@end
