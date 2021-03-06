//
//  ViewController.m
//  LBNewsViewDemo
//
//  Created by 刘柏杉 on 16/3/28.
//  Copyright © 2016年 刘柏杉. All rights reserved.
//

#import "ViewController.h"
#import "LBNewsView.h"
#import "LBScrollTabbar.h"
#import "UIView+Extension.h"

// RGB颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define RandomColor RGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface ViewController ()<LBNewsViewDataSource,LBNewsViewDelegate>

@property (weak, nonatomic) LBScrollTabbar* scrollTabbar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LBScrollTabbar* scrollTabbar = [[LBScrollTabbar alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 40)];
    scrollTabbar.separatorWidth = 1;
    scrollTabbar.titles = @[@"新闻",@"体育乐乐乐乐",@"娱乐",@"社会",@"八卦",@"世界杯",@"历史"];
//    scrollTabbar.underlineColor = [UIColor redColor];
    
    [self.view addSubview:scrollTabbar];
    _scrollTabbar = scrollTabbar;
    
}

- (IBAction)changeAction:(UIButton *)sender {
    
    _scrollTabbar.tabWidth = 80;
    
}



- (UIView*)newsView:(LBNewsView*)theNewsView viewForIndex:(NSInteger)theIndex {
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = RandomColor;
    
    return view;
}

/** 处理标签被点击的回调 */
- (void)newsView:(LBNewsView*)theNewsView didClickedTabWithIndex:(NSInteger)theIndex withTitle:(NSString*)theTitle withTab:(UIButton*)theTab {
    
    NSLog(@"didClickedTabWithIndex:%ld",theIndex);
    
}
/** 处理标签被点击的回调 */
- (void)newsView:(LBNewsView*)theNewsView didScrollToViewWithIndex:(NSInteger)theIndex {
    
    NSLog(@"didScrollToViewWithIndex:%ld",theIndex);
}

@end
