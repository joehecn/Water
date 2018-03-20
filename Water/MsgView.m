//
//  MsgView.m
//  Water
//
//  Created by 何苗 on 2018/3/14.
//  Copyright © 2018年 joehe. All rights reserved.
//

#import "MsgView.h"

@interface MsgView() {
    UILabel *lab;
}

@property(nonatomic, strong)UIView *infoView;

@end

@implementation MsgView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.hidden = YES;
        
        [self createLabel];
    }
    return self;
}

-(void)createLabel {
    lab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.infoView.frame.size.height / 2 - 25, self.infoView.frame.size.width, 50)];
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [self.infoView addSubview:lab];
}

-(UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) / 4, CGRectGetHeight(self.frame) * 0.4, CGRectGetWidth(self.frame) / 2, 100)];
        _infoView.backgroundColor = [UIColor blackColor];
        _infoView.alpha = 0.5;
        [self addSubview:_infoView];
    }
    return _infoView;
}

-(void)showAnimation:(NSString *)text {
    lab.text = [NSString stringWithFormat:@"%@方法已经触发", text];
    
    self.hidden = NO;
    
    __block CGRect rect = self.infoView.frame;
    [UIView animateWithDuration:1.5 animations:^{
        rect.origin.y = CGRectGetHeight(self.frame);
        self.infoView.frame = rect;
    } completion:^(BOOL finished) {
        rect.origin.y = CGRectGetHeight(self.frame) * 0.4;
        self.infoView.frame = rect;
        self.hidden = YES;
    }];
}

@end
