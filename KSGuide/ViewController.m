//
//  ViewController.m
//  KSGuide
//
//  Created by bing.hao on 16/3/10.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "ViewController.h"
#import "KSGuideManager.h"

@interface ViewController ()<KSGuideDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    NSMutableArray *paths = [NSMutableArray new];
    
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"jpg"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"jpg"]];
    
    //设置委托
    [[KSGuideManager shared] setDelegate:self];
    //设置退出动画效果
    [[KSGuideManager shared] setAnimationType:KSGuideAnimationTypeTop];
//    [[KSGuideManager shared] clearMark];
    [[KSGuideManager shared] showGuideViewWithImages:paths];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)KSGuidLastPageButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 200, 44)];
    [button setTitle:@"Hi~~" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.layer setCornerRadius:5];
    [button.layer setBorderColor:[UIColor grayColor].CGColor];
    [button.layer setBorderWidth:1.0f];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setCenter:CGPointMake(kScreenBounds.size.width / 2, kScreenBounds.size.height - 100)];
    return button;
}

- (void)KSGuidLastPageButtonDidOnClick {
    
}

@end
