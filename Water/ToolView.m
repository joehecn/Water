//
//  ToolView.m
//  Water
//
//  Created by 何苗 on 2018/3/13.
//  Copyright © 2018年 joehe. All rights reserved.
//

#import "ToolView.h"

@interface ToolView () {
    NSArray *arr;
    UIButton *lastBtn;
}

@end

@implementation ToolView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        arr = @[@"点击", @"长按", @"轻扫", @"滑动", @"边缘", @"缩放", @"旋转"];
        [self createButtons];
    }
    return self;
}

-(void)createButtons {
    CGFloat padding = self.frame.size.width * 0.2 / 6;
    CGFloat btnWidth = self.frame.size.width * 0.8 / 7;
    CGFloat btnHeight = btnWidth;
    
//    NSArray *arr = @[@"点击", @"长按", @"轻扫", @"滑动", @"边缘", @"缩放", @"旋转"];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat y = self.frame.size.height - btnHeight;
        if (idx == 1 || idx == 5) {
            y = self.frame.size.height - btnHeight * 2 - padding;
        } else if (idx == 2 || idx == 4) {
            y = self.frame.size.height - btnHeight * 3 - padding * 2;
        } else if (idx == 3) {
            y = self.frame.size.height - btnHeight * 4 - padding * 3;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(idx * (btnWidth + padding), y, btnWidth, btnHeight);
        [btn setTitle:arr[idx] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor orangeColor];
        btn.layer.cornerRadius = btnWidth / 2;
        btn.layer.masksToBounds = YES;
        
        btn.tag = idx;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
}

-(void)clickBtn:(UIButton *)btn {
//    NSLog(@"%ld", (long)btn.tag);
    // 发送广播
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[NSString stringWithFormat:@"%d", (int)btn.tag] forKey:@"tag"];
    [dic setValue:arr[btn.tag] forKey:@"title"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TOOLNOTIF" object:nil userInfo:dic];
    
    btn.backgroundColor = [UIColor purpleColor];
    
    // lastBtn
    if (lastBtn) {
        lastBtn.backgroundColor = [UIColor orangeColor];
    }
    
    lastBtn = btn;
}

@end
