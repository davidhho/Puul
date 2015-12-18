#import "PUSignUpViewController.h"
#import <Parse/Parse.h>
#import "UIColor+PUColors.h"
#import "PUUtility.h"

@interface PUSignUpViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    UITableView *sTableView;
    
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UITextField *emailTextField;
    UITextField *nameTextField;
    
    BOOL username;
    BOOL password;
    BOOL email;
    BOOL name;
}

@end

@implementation PUSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Sign Up";
    self.view.backgroundColor = [UIColor whiteColor];
    
    sTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sTableView.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);
    sTableView.separatorColor = [UIColor puulRedColor];
    sTableView.delegate = self;
    sTableView.dataSource = self;
    [self.view addSubview:sTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [usernameTextField becomeFirstResponder];
}

#pragma mark - UITableView Protocols

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, cell.frame.size.height)];
    
    if (indexPath.row == 0) {
        if (!usernameTextField) {
            usernameTextField = [[UITextField alloc]initWithFrame:cell.frame];
            usernameTextField.placeholder = @"Username";
            usernameTextField.leftView = paddingView;
            usernameTextField.leftViewMode = UITextFieldViewModeAlways;
            usernameTextField.delegate = self;
            [cell.contentView addSubview:usernameTextField];
        }
    }
    if (indexPath.row == 1) {
        if (!passwordTextField) {
            passwordTextField = [[UITextField alloc]initWithFrame:cell.frame];
            passwordTextField.placeholder = @"HW Password";
            passwordTextField.leftView = paddingView;
            passwordTextField.leftViewMode = UITextFieldViewModeAlways;
            passwordTextField.secureTextEntry = YES;
            passwordTextField.delegate = self;
            [cell.contentView addSubview:passwordTextField];
        }
    }
    if (indexPath.row == 2) {
        if (!emailTextField) {
            emailTextField = [[UITextField alloc]initWithFrame:cell.frame];
            emailTextField.placeholder = @"HW Email";
            emailTextField.leftView = paddingView;
            emailTextField.leftViewMode = UITextFieldViewModeAlways;
            emailTextField.delegate = self;
            [cell.contentView addSubview:emailTextField];
        }
    }
    if (indexPath.row == 3) {
        if (!nameTextField) {
            nameTextField = [[UITextField alloc]initWithFrame:cell.frame];
            nameTextField.placeholder = @"First Last";
            nameTextField.leftView = paddingView;
            nameTextField.leftViewMode = UITextFieldViewModeAlways;
            nameTextField.delegate = self;
            [cell.contentView addSubview:nameTextField];
        }
    }
    
    if (indexPath.row == 4) {
        if (username && password && email) {
            cell.contentView.backgroundColor = [UIColor greenColor];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else{
            cell.contentView.backgroundColor = [UIColor puulRedColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        label.text = @"Sign Up";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4 && username && password && email && name) {
        //try to sign up the user
        PFUser *user = [PFUser user];
        user.username = usernameTextField.text;
        user.password = passwordTextField.text;
        user.email = emailTextField.text;
        user[@"name"] = nameTextField.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                NSLog(@"SUCCESSS");
            }
            else{
                NSLog(@"%@", error);
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == usernameTextField) {
        [passwordTextField becomeFirstResponder];
        if (textField.text.length > 0) {
            username = YES;
        }
    }
    if (textField == passwordTextField) {
        [emailTextField becomeFirstResponder];
        if (textField.text.length > 0) {
            password = YES;
        }
    }
    if (textField == emailTextField) {
        [nameTextField becomeFirstResponder];
        if (textField.text.length > 0) {
            email = YES;
        }
    }
    if (textField == nameTextField) {
        [nameTextField resignFirstResponder];
        if (nameTextField.text.length > 0) {
            name = YES;
        }
    }
    if (email && username && password && name) {
        [self reloadLastRow];
    }
    return YES;
}

#pragma mark - Helper Methods

- (void)reloadLastRow{
    [sTableView beginUpdates];
    [sTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [sTableView endUpdates];
}

@end