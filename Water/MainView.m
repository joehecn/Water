//
//  MainView.m
//  Water
//
//  Created by 何苗 on 2018/3/13.
//  Copyright © 2018年 joehe. All rights reserved.
//

#import "MainView.h"

@implementation MainView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor cyanColor];
        [self createLabel];
    }
    return self;
}

-(void)createLabel {
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(self.center.x - 100, self.center.y - 25, 200, 50)];
    [lab setText:@"请点击屏幕"];
    [lab setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:lab];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.clickScreen) {
        self.clickScreen();
    }
}

@end
