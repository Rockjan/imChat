//
//  login.m
//  imChat
//
//  Created by ppnd on 14-8-26.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "login.h"
#import "singleSocket.h"

@interface login (){
    singleSocket *tempSocket;
    NSString *name;
    NSString *pwd;
     NSTimer *ter;
}

@end

@implementation login

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tempSocket = [singleSocket sharedInstance];
    _name.delegate = self;
    _pwd.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registeUser:(id)sender {
    [self performSegueWithIdentifier:@"registeUser" sender:self];
}
- (IBAction)loginAction:(id)sender {
    
    name = [_name.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    pwd = [_pwd.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if ([name isEqualToString:@""] || [pwd isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"出错了！" message:@"请填写正确的登录信息！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        
        [alertView show];
    }
    NSString *msg = [NSString stringWithFormat:@"01%@",name];
    
    [tempSocket sendMessage:msg];
   // [self getMSG];
    ter = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getMSG) userInfo:nil repeats:YES];
    [ter fire];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMSG) name:@"rec" object:nil];
}
- (void)getMSG {
    
    NSData *tempdata = [tempSocket getMessage];
    if (tempdata != nil) {
        [ter invalidate];
        NSString *result = [[NSString alloc] initWithData:tempdata encoding:NSUTF8StringEncoding];

        NSString *msg = @"用户名或密码错误！";
        NSString *titles = @"出错了";
        if ([[result substringToIndex:1] isEqualToString:@"1"]) {
            
            NSArray *tempArr = [[result substringFromIndex:1] componentsSeparatedByString:@"#"];
            
            if ([name isEqualToString:tempArr[0]] && [pwd isEqualToString:tempArr[1]]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"userName"];
                [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"pwd"];
                [[NSUserDefaults standardUserDefaults] setObject:tempArr[2] forKey:@"sex"];
                [self performSegueWithIdentifier:@"gotoMainPanel" sender:self];
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titles message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                
                [alertView show];
            }
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titles message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            
            [alertView show];
        }
    }

    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_name resignFirstResponder];
    [_pwd resignFirstResponder];
}
@end
