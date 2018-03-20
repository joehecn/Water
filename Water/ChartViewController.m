//
//  ChatViewController.m
//  Water
//
//  Created by 何苗 on 2018/3/13.
//  Copyright © 2018年 joehe. All rights reserved.
//

// 3.0 ~ 7.8 | 20 ~ 29

#import "ChartViewController.h"
#import "DataClass.h"
#import "QuartzChart.h"

@interface ChartViewController ()

@property(nonatomic, strong)QuartzChart *quartz;

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    // 水位折线图
    [self.view addSubview:self.quartz];
    [self.quartz setNeedsDisplay];
    
    // 缩放手势
    [self addPinchGesture];
    
    // 长按键
    [self addLongPressGesture];
    
    // 返回按键
    [self createBackBtn];
}

-(QuartzChart *)quartz {
    if (!_quartz) {
         NSMutableArray *datas = [self createData];
        _quartz = [[QuartzChart alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 6, self.view.frame.size.height - 100) datas:datas];
    }
    return _quartz;
}

// 模拟水位数据
-(NSMutableArray *)createData {
    NSMutableArray *datas = [NSMutableArray array];
    for (int i = 0; i < 50; i++) {
        DataClass *data = [[DataClass alloc]init];
        data.time = [NSString stringWithFormat:@"%.1f", 3.0 + (float)i / 10];
        data.value = [self getRandomValue];
        [datas addObject:data];
    }
    return datas;
}

// 20 ~ 29 随机数
-(int)getRandomValue {
    return (arc4random() % 10) + 20;
}

// 缩放手势
-(void)addPinchGesture {
    UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
    [self.view addGestureRecognizer:recognizer];
}
-(void)pinchGesture:(UIPinchGestureRecognizer *)sender {
    CGFloat scale = sender.scale;
//    NSLog(@"%f", scale);
    CGSize size = self.quartz.frame.size;
    [self.quartz setFrame:CGRectMake(0, 0, size.width * scale, size.height)];
    [self.quartz setNeedsDisplay];
}

// 长按键
-(void)addLongPressGesture {
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    [self.quartz addGestureRecognizer:recognizer];
}
-(void)longPressGesture:(UILongPressGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_quartz];
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.quartz.showWhiteLine = true;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        self.quartz.showWhiteLine = false;
    }
    
    self.quartz.longPressPointX = point.x;
    [self.quartz setNeedsDisplay];
}

-(void)createBackBtn {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(self.view.center.x - 50, self.view.frame.size.height - 100, 100, 50);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor redColor]];
    [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

-(void)clickBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
