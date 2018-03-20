//
//  GestureViewController.m
//  Water
//
//  Created by 何苗 on 2018/3/13.
//  Copyright © 2018年 joehe. All rights reserved.
//

#import "GestureViewController.h"
#import "ToolView.h"
#import "TouchView.h"
#import "MsgView.h"

@interface GestureViewController () {
    UIView *lastView;
    UIGestureRecognizer *lastGesture;
    
    NSString *title;
//    int tag;
}

@property(nonatomic, strong)ToolView *toolView;
@property(nonatomic, strong)TouchView *touchView;
@property(nonatomic, strong)MsgView *msgView;

@end

@implementation GestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor cyanColor];
    
    // 注册广播中心
    [self listeningToolNotification];
    
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.touchView];
    [self createBackBtn];
    [self.view addSubview:self.msgView];    
}

-(void) listeningToolNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifFromTool:) name:@"TOOLNOTIF" object:nil];
}

-(void)notifFromTool:(NSNotification *)notif {
    NSDictionary *dic = notif.userInfo;
    title = dic[@"title"];
    [self.touchView setLabText:title];
    
    if (lastView) {
        [lastView removeGestureRecognizer:lastGesture];
    }
    
    lastView = self.touchView;
    
    NSString *tagStr = dic[@"tag"];
    int tag = tagStr.intValue;
    
    if (tag == 0) { // 点击
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchGesture)];
        [self.touchView addGestureRecognizer:recognizer];
        lastGesture = recognizer;
    } else if (tag == 1) { // 长按
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(touchGesture:)];
        [self.touchView addGestureRecognizer:recognizer];
        lastGesture = recognizer;
    } else if (tag == 2) { // 轻扫
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(touchGesture)];
        recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.touchView addGestureRecognizer:recognizer];
        lastGesture = recognizer;
    } else if (tag == 3) { // 滑动
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(touchGesture:)];
        [self.touchView addGestureRecognizer:recognizer];
        lastGesture = recognizer;
    } else if (tag == 4) { // 边缘
        UIScreenEdgePanGestureRecognizer *recognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(touchGesture:)];
        recognizer.edges = UIRectEdgeRight;
        [self.view addGestureRecognizer:recognizer];
        lastView = self.view;
        lastGesture = recognizer;
    } else if (tag == 5) { // 缩放
        UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(touchGesture:)];
        [self.touchView addGestureRecognizer:recognizer];
        lastGesture = recognizer;
    } else { // 旋转
        UIRotationGestureRecognizer *recognizer =[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(touchGesture:)];
        [self.touchView addGestureRecognizer:recognizer];
        lastGesture = recognizer;
    }
}

-(void)touchGesture {
    [self.msgView showAnimation:title];
}
-(void)touchGesture:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.msgView showAnimation:title];
    }
}

-(ToolView *)toolView {
    if (!_toolView) {
        _toolView = [[ToolView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height / 2 - 20)];
    }
    return _toolView;
}

-(TouchView *)touchView {
    if (!_touchView) {
        _touchView = [[TouchView alloc]initWithFrame:CGRectMake(10, self.view.center.y, self.view.frame.size.width - 20, self.view.frame.size.height / 2 - 110)];
    }
    return _touchView;
}

-(MsgView *)msgView {
    if (!_msgView) {
        _msgView = [[MsgView alloc]initWithFrame:self.view.frame];
    }
    return _msgView;
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

-(void)dealloc {
    // 销毁广播
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TOOLNOTIF" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
