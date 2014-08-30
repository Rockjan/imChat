//
//  chatCell.m
//  imChat
//
//  Created by ppnd on 14-8-28.
//  Copyright (c) 2014年 zjut. All rights reserved.
//

#import "chatCell.h"

@implementation chatCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)initChatViewWithString:(NSString *)str withFlag:(BOOL)flag {

    float finalWidth = 200.0;
    float finalHeight = 0.0;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    label.font = [UIFont systemFontOfSize:14];
    label.text = str;
    label.numberOfLines = 0;
    
    float totalWidth = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    
    if (totalWidth < 200.0) {
        finalWidth = totalWidth + 10;
        finalHeight = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].height;
    }else {
        
      //  finalHeight = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
        finalHeight =[str boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    }
    float offSets = (flag ? 12 : 8);
    label.frame = CGRectMake(offSets, 5, finalWidth, finalHeight);
    NSString *imageName = (flag ? @"boubleSelf" : @"bouble");
    UIImage *bubble = [UIImage imageNamed:imageName];

    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:14]];
    bubbleImageView.frame = CGRectMake(0, 0, label.frame.size.width + 10, label.frame.size.height  + 10);

    self.frame = CGRectMake(0, 0, label.frame.size.width + 10, label.frame.size.height  + 10);
    
    [self addSubview:bubbleImageView];
    [self addSubview:label];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
