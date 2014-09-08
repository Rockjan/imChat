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
#import "AsyncSocket.h"

@interface chatPanel ()
{
    NSMutableArray *dataSouce;
    NSMutableArray *chatCells;
    singleSocket *tempSocket;
    AsyncSocket    *socket;
    
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
   // tempSocket = [singleSocket sharedInstance];
    
    [self connectHost];
    
    dataSouce = [[NSMutableArray alloc] initWithCapacity:10];
    chatCells = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSDictionary *spr = @{@"flag":@"1",@"content":@"this is a test, and i don't know how to write the content.So just help yourself.this is a test, and i don't know how to write the content.So just help yourself.this is a test, and i don't know how to write the content.So just help yourself."};
    NSDictionary *me = @{@"flag":@"0",@"content":@"这个frame是初设的，没关系，后面还会重新设置其size。这个frame是初设的，没关系，后面还会重新设置其size。这个frame是初设的，没关系，后。"};
    
    //for (int i = 0 ; i < 12; i++) {
      //  [dataSouce addObject:@{@"flag":@"#"}];
        //[dataSouce addObject:me];
    //}
   //[dataSouce addObject:spr];
    _chatTable.delegate = self;
    _chatTable.dataSource = self;
    _chatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
   // [self getChatCells];
   // [self scrollTableToFoot:YES];
    // Do any additional setup after loading the view.
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
    [_chatTable reloadData];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
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
    NSString *sendM = [NSString stringWithFormat:@"05zy#%@#%@",_desName,str];
    [self sendMessage:sendM];
    
    counts ++;
}


-(void)connectHost{
    
    socket = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
   // [self initDataSource];
    [socket connectToHost:@"10.3.135.249" onPort:9000 withTimeout:-1 error:&error];
    
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString  *)host port:(UInt16)port {
    
    NSLog(@"socket连接成功");
    
    [socket readDataWithTimeout:-1 tag:0];
    
    // 每隔30s像服务器发送心跳包
    //_connectTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(keepOnLine) userInfo:nil repeats:YES];// 在keepOnLine方法中进行长连接需要向服务器发送的讯息
    
    //[_connectTimer fire];
    
}
-(void)cutOffSocket{
    
    socket.userData = SocketOfflineByUser;// 声明是由用户主动切断
    
   // [_connectTimer invalidate];
    
    [socket disconnect];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    // 对得到的data值进行解析与转换即可
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *temp = [str componentsSeparatedByString:@"#"];
        NSLog(@"+++++:%@",str);
        NSDictionary *rec = @{@"flag":@"0",@"content":temp[1]};
        [dataSouce addObject:rec];
        [self getChatCells];
        counts ++;
        [_chatTable reloadData];
    });

    [socket readDataWithTimeout:-1 tag:0];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"rec" object:nil];
    
}
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    //NSLog(@"didWriteDataWithTag:%ld",tag);
}
-(void)sendMessage:(NSString *)msg {
    
    NSData* aData= [msg dataUsingEncoding: NSUTF8StringEncoding];
    
    [socket writeData:aData withTimeout:-1 tag:0];
    [socket readDataWithTimeout:-1 tag:0];
    
}
@end
