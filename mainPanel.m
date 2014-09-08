//
//  mainPanel.m
//  imChat
//
//  Created by ppnd on 14-8-27.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "mainPanel.h"
#import "chatPanel.h"
#import "singleSocket.h"

@interface mainPanel (){
    singleSocket *tempSocket;
    NSMutableArray *dataSouce;
    NSTimer *ter;
    NSString *desName;
}

@end

@implementation mainPanel

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tempSocket = [singleSocket sharedInstance];
    [self getFriendList];
}

- (void)getFriendList {
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
    [tempSocket sendMessage:[NSString stringWithFormat:@"02%@",userName]];
    
    ter = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getMSG) userInfo:nil repeats:YES];
    [ter fire];
    
}
- (void)getMSG {
    NSData *tempdata = [tempSocket getMessage];
    if (tempdata != nil) {
        
        [ter invalidate];
        NSString *result = [[NSString alloc] initWithData:tempdata encoding:NSUTF8StringEncoding];
        if ([[result substringToIndex:1]  isEqualToString:@"1"]) {

            dataSouce = [NSMutableArray arrayWithArray:[[result substringFromIndex:1] componentsSeparatedByString:@"#"]];
        }
        [self.tableView reloadData];
    }
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSouce count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    desName = dataSouce[indexPath.row];
    [self performSegueWithIdentifier:@"gotoChatRoom" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    //NSArray *tempData = [(NSString *)dataSouce[indexPath.row] componentsSeparatedByString:@"#"];
    
   // NSString *titleImg = [tempData[1] isEqualToString:@"0"] ? @"male" : @"female" ;
    
   // cell.imageView.image = [UIImage imageNamed:titleImg];
    //NSString *name = dataSouce[indexPath.row]
    cell.textLabel.text = dataSouce[indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    chatPanel *des = segue.destinationViewController;
    [des setDesName:desName];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)search:(id)sender {
    [self performSegueWithIdentifier:@"gotoSearch" sender:self];
}

- (IBAction)logout:(id)sender {
    [self performSegueWithIdentifier:@"gotoChatRoom" sender:self];
}
@end
