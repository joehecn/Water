//
//  TouchView.m
//  Water
//
//  Created by 何苗 on 2018/3/13.
//  Copyright © 2018年 joehe. All rights reserved.
//

#import "TouchView.h"

@interface TouchView () {
    UILabel *lab;
}

@end

@implementation TouchView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor yellowColor];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        [self createLabel];
    }
    return self;
}

-(void)createLabel {
    lab = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 150, self.frame.size.height / 2 - 25, 300, 50)];
    [self setLabText:@"请点击上面的按钮,完成相关手势操作"];
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
}

-(void)setLabText:(NSString *)text {
    lab.text = text;
}

@end
