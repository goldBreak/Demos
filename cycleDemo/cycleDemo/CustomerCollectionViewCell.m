//
//  CustomerCollectionViewCell.m
//  cycleDemo
//
//  Created by xsd on 2018/4/10.
//  Copyright © 2018年 com.GF. All rights reserved.
//

#import "CustomerCollectionViewCell.h"

@implementation CustomerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.6 alpha:1];
        
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.contentView addSubview:self.lable];
        
        self.lable.font = [UIFont systemFontOfSize:12.];
        self.lable.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
@end
