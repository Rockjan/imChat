//
//  login.h
//  imChat
//
//  Created by ppnd on 14-8-26.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface login : UIViewController
- (IBAction)registeUser:(id)sender;
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *pwd;

@end
