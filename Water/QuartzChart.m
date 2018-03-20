//
//  QuartzChart.m
//  Water
//
//  Created by 何苗 on 2018/3/14.
//  Copyright © 2018年 joehe. All rights reserved.
//

#import "QuartzChart.h"
#import "DataClass.h"

@interface QuartzChart() {
    NSMutableArray *datas;
    float unitWidth;
    float unitHeight;
    CGPoint chartOrigin;
}

@end

@implementation QuartzChart

-(instancetype)initWithFrame:(CGRect)frame datas:(NSMutableArray *)mdatas {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor cyanColor];
        
        datas = mdatas;
        
        // 原点
        chartOrigin = CGPointMake([UIScreen mainScreen].bounds.size.width / 10 * 1.5, self.frame.size.height / 8 * 7);
        
        // 长按键时显示白色直线
        self.showWhiteLine = false;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // 初始化标尺
    unitWidth = self.frame.size.width / 60;
    unitHeight = self.frame.size.height / 8 * 5 / 100;
    
    // Drawing code
    [self drawLine];
    
    if (self.showWhiteLine) {
        [self drawWhiteLine];
    } else {
        // 折线上显示数字
        [self drawNumber];
    }
}

-(void)drawLine {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    
    // 画坐标轴
    [self drawXY:context];
    
    // 折线
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DataClass *data = obj;
        if (idx == 0) {
            CGContextMoveToPoint(context, chartOrigin.x + unitWidth * (idx + 1), chartOrigin.y - unitHeight * data.value);
        } else {
            CGContextAddLineToPoint(context, chartOrigin.x + unitWidth * (idx + 1), chartOrigin.y - unitHeight * data.value);
        }
    }];
    
    CGContextStrokePath(context);
}

-(void)drawXY:(CGContextRef)context {
    CGContextSaveGState(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor brownColor].CGColor);
    
    // y轴
    CGContextMoveToPoint(context, chartOrigin.x, chartOrigin.y);
    CGContextAddLineToPoint(context, chartOrigin.x, chartOrigin.y - unitHeight * 120);
    // x轴
    CGContextMoveToPoint(context, chartOrigin.x, chartOrigin.y);
    CGContextAddLineToPoint(context, chartOrigin.x + unitWidth * 51, chartOrigin.y);
    // x 刻度线段
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGContextMoveToPoint(context, chartOrigin.x + unitWidth * (idx + 1), chartOrigin.y);
        CGContextAddLineToPoint(context, chartOrigin.x + unitWidth * (idx + 1), chartOrigin.y - 4);
    }];
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle]mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:10.0],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor brownColor]};
    // x 刻度标注
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DataClass *data = obj;
        [data.time drawInRect:CGRectMake(chartOrigin.x + unitWidth * (idx + 0.5), chartOrigin.y + 5, unitWidth, 10) withAttributes:dic];
    }];
    // y 刻度标注
    paragraphStyle.alignment = NSTextAlignmentRight;
    NSArray *yTips = @[@"0", @"20", @"40", @"60", @"80", @"100", @"水位/m"];
    [yTips enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * yTip = obj;
        [yTip drawInRect:CGRectMake(chartOrigin.x - 42, chartOrigin.y - unitHeight * 20 * idx, [UIScreen mainScreen].bounds.size.width / 10, 12) withAttributes:dic];
    }];
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

-(void)drawWhiteLine {
    CGFloat min = 100000000;
    CGFloat x = 0;
    int idx = 0;
    
    for (int i = 0; i < datas.count; i++) {
        CGFloat ix = chartOrigin.x + unitWidth * (i + 1);
        CGFloat diff = fabs(self.longPressPointX - ix);
        if (diff < min) {
            min = diff;
            x = ix;
            idx = i;
        }
    }
    
    DataClass *data = datas[idx];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextMoveToPoint(context, x, chartOrigin.y);
    CGContextAddLineToPoint(context, x, chartOrigin.y - unitHeight * 120);
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    // 文字
    CGContextSaveGState(context);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:[UIColor redColor]};
    [[NSString stringWithFormat:@"时间:%@", data.time] drawInRect:CGRectMake(x + 10, chartOrigin.y - unitHeight * 90, [UIScreen mainScreen].bounds.size.width / 10 * 2, 16) withAttributes:dic];
    [[NSString stringWithFormat:@"水位:%dm", data.value] drawInRect:CGRectMake(x + 10, chartOrigin.y - unitHeight * 90 + 20, [UIScreen mainScreen].bounds.size.width / 10 * 2, 16) withAttributes:dic];
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

-(void)drawNumber {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DataClass *data = obj;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle]mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:10.0],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor brownColor]};
        
        [[NSString stringWithFormat:@"%d", data.value] drawInRect:CGRectMake(chartOrigin.x + unitWidth * (idx + 0.5), chartOrigin.y - unitHeight * data.value - 12, unitWidth, 10) withAttributes:dic];
    }];
    
    CGContextStrokePath(context);
}

@end
