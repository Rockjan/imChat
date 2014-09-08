//
//  register.h
//  imChat
//
//  Created by ppnd on 14-8-27.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registeView : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *repwd;
@property (weak, nonatomic) IBOutlet UISwitch *manT;
@property (weak, nonatomic) IBOutlet UISwitch *womanT;
- (IBAction)onMan:(id)sender;
- (IBAction)onWoman:(id)sender;

- (IBAction)onCancel:(id)sender;
- (IBAction)registeAction:(id)sender;
@end
