
//
//  friendList.m
//  imChat
//
//  Created by ppnd on 14-8-27.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "friendList.h"
#import "chatCell.h"
#import "singleSocket.h"

@interface friendList ()
{
    singleSocket *tempScoket;
    NSTimer *timer;
    NSString *un;
}

@end

@implementation friendList

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
    _searchBar.delegate =self;
    tempScoket = [singleSocket sharedInstance];
    un = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
    
    // Do any additional setup after loading the view.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *msg = [NSString stringWithFormat:@"04%@",_searchBar.text];
    [tempScoket sendMessage:msg];


    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getMSG) userInfo:nil repeats:YES];
    [timer fire];
    

}
-(void)getMSG {
    
    NSData *rev = [tempScoket getMessage];
    if (rev != nil) {
        NSString *str = [[NSString alloc] initWithData:rev encoding:NSUTF8StringEncoding];
        if ([str isEqualToString:@"1"]) {
            NSString *str = [NSString stringWithFormat:@"你成功添加 %@ 为好友！",_name.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else {
            NSArray *temp = [str componentsSeparatedByString:@"#"];
            
            NSLog(@"search:%@",str);
            _name.text = temp[0];
            _sex.text = ([temp[2] intValue] == 0 ? @"男" : @"女");
        }

        
        [timer invalidate];
    }

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

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addFriend:(id)sender {
    NSString *msg = [NSString stringWithFormat:@"07%@#%@",un,_name.text];
    [tempScoket sendMessage:msg];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getMSG) userInfo:nil repeats:YES];
    [timer fire];
}
@end
