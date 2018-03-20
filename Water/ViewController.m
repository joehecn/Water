//
//  ViewController.m
//  Water
//
//  Created by 何苗 on 2018/3/13.
//  Copyright © 2018年 joehe. All rights reserved.
//

#import "ViewController.h"
#import "MainView.h"
#import "GestureViewController.h"
#import "ChartViewController.h"

@interface ViewController ()

@property(nonatomic, strong)MainView *mainView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainView];
}

-(MainView *)mainView {
    if (!_mainView) {
        _mainView = [[MainView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof (self) weakself = self;
        _mainView.clickScreen = ^() {
            [weakself showAlert];
        };
    }
    return _mainView;
}

-(void)showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你想进入哪个页面" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *gestureAction = [UIAlertAction actionWithTitle:@"进入手势" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        GestureViewController *vc = [[GestureViewController alloc]init];
        [self jumpToPage:vc];
        
    }];
    UIAlertAction *chatAction = [UIAlertAction actionWithTitle:@"进入绘图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ChartViewController *vc = [[ChartViewController alloc]init];
        [self jumpToPage:vc];
    }];
    
    [alert addAction:gestureAction];
    [alert addAction:chatAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)jumpToPage:(UIViewController *)vc {
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
