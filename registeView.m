//
//  register.m
//  imChat
//
//  Created by ppnd on 14-8-27.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "registeView.h"
#import "singleSocket.h"

@interface registeView (){
    int sexOfInt;
    singleSocket *tempSocket;
}

@end

@implementation registeView

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
    
    sexOfInt = 0; //male
    
    _name.delegate = self;
    _pwd.delegate = self;
    _repwd.delegate = self;
    
    [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getResponse) userInfo:nil repeats:YES] fire];
    
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_name resignFirstResponder];
    [_pwd resignFirstResponder];
    [_repwd resignFirstResponder];
}
- (IBAction)onMan:(id)sender {
    
    if(_manT.state) {
        [_manT setOn:YES animated:YES];
        [_womanT setOn:NO animated:YES];
        sexOfInt = 0;
    }else {
        [_manT setOn:NO animated:YES];
        [_womanT setOn:YES animated:YES];
    }
    //_womanT.state = !_manT.state;
}

- (IBAction)onWoman:(id)sender {
    
    if(!_womanT.state) {
        [_manT setOn:YES animated:YES];
        [_womanT setOn:NO animated:YES];
        sexOfInt = 1;
    }else {
        [_manT setOn:NO animated:YES];
        [_womanT setOn:YES animated:YES];
    }
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registeAction:(id)sender {
    
    NSString *name = [_name.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *pwd = [_pwd.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString *str = [NSString stringWithFormat:@"%@+%@+%d",name,pwd,sexOfInt];
    
    [tempSocket sendMessage:str];
}
- (void)getResponse {
    
    NSData *aData = [tempSocket getMessage];
    
    NSString *msg = @"注册失败！";
    NSString *titles = @"出错了";
    
    if (aData != nil) {
        
        NSString *sucStr = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
        
        if ([sucStr isEqualToString:@"succeful"]) {
            msg = @"注册成功！";
            titles = @"OK";
            
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titles message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}
-(void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    const int movementDistance = 50;
    const float movementDuration = 0.3f;
    int movement = (up?-movementDistance:movementDistance);
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
@end
