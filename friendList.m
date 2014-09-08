
//
//  friendList.m
//  imChat
//
//  Created by ppnd on 14-8-27.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "friendList.h"
#import "chatCell.h"

@interface friendList ()

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
    chatCell *view = [[chatCell alloc] init];
    NSString *str = @"这个frame是初设的，没关系，后面还会重新设置其size。这个frame是初设的，没关系，后面还会重新设置其size。这个frame是初设的，没关系，后面还会重新设置其size。这个frame是初设的，没关系，后面还会重新设置其size。这个frame是初设的，没关系，后面还会重新设置其size。这个frame是初设的，没关系，后面还会重新设置其size。这个frame是初设的，没关系，后面还会重新设置其size。";
    [view initChatViewWithString:str withFlag:YES];
    [self.view addSubview:view];
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

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
