//
//  chatPanel.h
//  imChat
//
//  Created by ppnd on 14-8-27.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chatPanel : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UITableView *chatTable;
@property (nonatomic,copy) NSString *desName;
- (IBAction)goback:(id)sender;
- (IBAction)sendAction:(id)sender;

@end
