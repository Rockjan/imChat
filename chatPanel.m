//
//  chatPanel.m
//  imChat
//
//  Created by ppnd on 14-8-27.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "chatPanel.h"
#include "chatCell.h"
#import "singleSocket.h"

@interface chatPanel ()
{
    NSMutableArray *dataSouce;
    NSMutableArray *chatCells;
    singleSocket *tempSocket;
    NSTimer *recTimer;
    NSString *un;
    
    int counts;
}

@end

@implementation chatPanel

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        counts = 0;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _inputText.delegate = self;
    self.title = _desName;
    tempSocket = [singleSocket sharedInstance];
    
    un = [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
    
    dataSouce = [[NSMutableArray alloc] initWithCapacity:10];
    chatCells = [[NSMutableArray alloc] initWithCapacity:10];
    
    _chatTable.delegate = self;
    _chatTable.dataSource = self;
    _chatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (recTimer == nil) {
        
        recTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getMSG) userInfo:nil repeats:YES];
        [recTimer fire];
    }
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    //设置style
    [topView setBarStyle:UIBarStyleBlack];
    
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
    
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    //    [textView setInputView:topView];
    //[_inputText setInputAccessoryView:topView];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_inputText resignFirstResponder];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSouce count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if([[cell.contentView subviews] count] > 0)
    {
        for (UIView *temp in [cell.contentView subviews]) {
            [temp removeFromSuperview];
        }
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    [cell.contentView addSubview:(chatCell *)[chatCells objectAtIndex:indexPath.row]];
   
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    chatCell * tempView = (chatCell *)[chatCells objectAtIndex:indexPath.row];
    float height = 30;
    if (tempView != nil) {
        height = tempView.frame.size.height;
    }

    
    return height + 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_inputText resignFirstResponder];
}
-(void)getChatCells {
    NSDictionary *temp = dataSouce[counts];
    
    BOOL flag = [[temp objectForKey:@"flag"] isEqualToString:@"1"];
    chatCell *tempView = [[chatCell alloc] init];
    [tempView initChatViewWithString:[temp objectForKey:@"content"] withFlag:flag];
    [chatCells addObject:tempView];


}

- (void)scrollTableToFoot:(BOOL)animated {

	NSInteger r = [self.chatTable numberOfRowsInSection:0];
	if (r<1) return;
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:0];
	
	[self.chatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollTableToFoot:YES];
    [self animateTextField:textField up:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self scrollTableToFoot:YES];
    [self animateTextField:textField up:NO];
}
-(void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    const int movementDistance = 210;
    const float movementDuration = 0.2f;
   
    
    int movement = (up?-movementDistance:movementDistance);
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    if (up) {
         CGRect tframe = _chatTable.frame;
        tframe.origin.y = tframe.origin.y + 210;
        tframe.size.height = tframe.size.height-210;
        CGSize sizes =  _chatTable.contentSize;
        sizes.height = sizes.height/2.0 ;
        [_chatTable setFrame:tframe];
        [_chatTable setContentSize:sizes];
    }else {
        CGRect tframe = _chatTable.frame;
        tframe.origin.y = 65;
        CGSize sizes =  _chatTable.contentSize;
        sizes.height = sizes.height * 2.0 ;
        [_chatTable setFrame:tframe];
        [_chatTable setContentSize:sizes];
    }
    if (counts > 7) {
        [_chatTable reloadData];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    }
   
    //_inputText.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendAction:(id)sender {
    
    NSString *str = _inputText.text;
    NSDictionary *me = @{@"flag":@"1",@"content":str};
    [dataSouce addObject:me];
    [self getChatCells];
    [_chatTable reloadData];
    [self scrollTableToFoot:YES];
    NSString *sendM = [NSString stringWithFormat:@"05%@#%@#%@",un, _desName,str];
    [tempSocket sendMessage:sendM];
    counts ++;
    _inputText.text = @"";
}

- (void)getMSG {
    NSData *tempdata = [tempSocket getMessage];
    if (tempdata != nil) {
        NSString *result = [[NSString alloc] initWithData:tempdata encoding:NSUTF8StringEncoding];
        NSLog(@"recTimer : %@",result);
        NSArray *temp = [result componentsSeparatedByString:@"#"];
        if ([temp[0] isEqualToString:[NSString stringWithFormat:@"05%@",_desName]] && [temp[1] isEqualToString:un]) {
            NSString *str = temp[2];
            NSDictionary *me = @{@"flag":@"0",@"content":str};
            [dataSouce addObject:me];
            [self getChatCells];
            [_chatTable reloadData];
            [self scrollTableToFoot:YES];
            counts ++;
        }

    }
}

@end
