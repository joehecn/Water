//
//  QuartzChart.h
//  Water
//
//  Created by 何苗 on 2018/3/14.
//  Copyright © 2018年 joehe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuartzChart : UIView

-(instancetype)initWithFrame:(CGRect)frame datas:(NSMutableArray *)mdatas;

@property BOOL showWhiteLine;
@property CGFloat longPressPointX;

@end
