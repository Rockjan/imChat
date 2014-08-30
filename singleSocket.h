//
//  singleSocket.h
//  imChat
//
//  Created by ppnd on 14-8-28.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@interface singleSocket : NSObject

enum{
    SocketOfflineByServer,// 服务器掉线，默认为0
    SocketOfflineByUser,  // 用户主动cut
};

@property (strong,nonatomic) AsyncSocket    *socket;
@property (assign,nonatomic) AsyncSocket    *recieveProcess;
@property (copy,nonatomic) NSString       *socketHost;
@property (assign,nonatomic) int            socketPort;
@property (nonatomic, retain) NSTimer       *connectTimer;

+ (singleSocket *)sharedInstance;
-(void)initDataSource;
-(void)connectHost;
-(void)cutOffSocket;
-(void)sendMessage:(NSString *)msg;
-(void)sendRegisteMSG:(NSString *)userName withPWD:(NSString *)pwd andSex:(int) sex;
-(NSData *)getMessage;
-(NSArray *)getFriendList:(NSString *)userName;


@end
