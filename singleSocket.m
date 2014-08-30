//
//  singleSocket.m
//  imChat
//
//  Created by ppnd on 14-8-28.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "singleSocket.h"

@implementation singleSocket
{
    NSMutableArray *dataSource;
}

+(singleSocket *) sharedInstance {
    
    static singleSocket *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}
-(void)initDataSource {
    dataSource = [[NSMutableArray alloc] init];
}
-(void)connectHost{
    
    _socket = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    
    [self.socket connectToHost:_socketHost onPort:_socketPort withTimeout:3 error:&error];
    
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString  *)host port:(UInt16)port {
    NSLog(@"socket连接成功");
    
    // 每隔30s像服务器发送心跳包
    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(keepOnLine) userInfo:nil repeats:YES];// 在keepOnLine方法中进行长连接需要向服务器发送的讯息
    
    [_connectTimer fire];
    
}
-(void)cutOffSocket{
    
    _socket.userData = SocketOfflineByUser;// 声明是由用户主动切断
    
    [_connectTimer invalidate];
    
    [_socket disconnect];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    // 对得到的data值进行解析与转换即可
    //NSString *msg = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    [dataSource addObject:data];
    
}
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"didWriteDataWithTag:%ld",tag);
}

-(void)sendMessage:(NSString *)msg {
    
    NSData* aData= [msg dataUsingEncoding: NSUTF8StringEncoding];
    
    [_socket writeData:aData withTimeout:-1 tag:1];
    
}
-(void)sendRegisteMSG:(NSString *)userName withPWD:(NSString *)pwd andSex:(int) sex {
    
    NSString *msg = [NSString stringWithFormat:@"%@-%@-%d",userName , pwd , sex];
    NSData* aData= [msg dataUsingEncoding: NSUTF8StringEncoding];
    
    [_socket writeData:aData withTimeout:-1 tag:1];
}

-(NSData *)getMessage {
    
    if ([dataSource count] > 0) {
        NSData *aData = [dataSource lastObject];
        [dataSource removeLastObject];
        return aData;
    }
    return nil;
}

-(NSArray *)getFriendList:(NSString *)userName {
    NSString *str = [NSString stringWithFormat:@"%@-friendList",userName];
    [self sendMessage:str];
    NSData *aData = [self getMessage];
    NSString *result = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
    
    if (![result isEqualToString:@""]) {
        
        NSArray *tempArray = [NSArray arrayWithArray:[result componentsSeparatedByString:@"*"]];
        return tempArray;
    }
    return nil;
}

-(void)keepOnLine{
    
    // 根据服务器要求发送固定格式的数据，假设为指令@"keepOnLine"，但是一般不会是这么简单的指令
    
    NSString *keepOnLineStr = @"keepOnLine";
    
    NSData   *dataStream  = [keepOnLineStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [_socket writeData:dataStream withTimeout:-1 tag:1];
    
    [_socket readDataWithTimeout:-1 tag:0];
    
}
@end
