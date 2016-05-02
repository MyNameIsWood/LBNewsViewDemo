//
//  LBScrollTabbar.m
//  LBNewsViewDemo
//
//  Created by 刘柏杉 on 16/3/28.
//  Copyright © 2016年 刘柏杉. All rights reserved.
//

#import "LBScrollTabbar.h"
#import "UIView+Extension.h"

#define MYWIDTH  self.bounds.size.width
#define MYHEIGHT self.bounds.size.height
#define ANIMATED YES

@interface LBScrollTabbar ()

@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) UIScrollView* myScrollView;
@property (strong, nonatomic) NSMutableArray<UIButton*>* myTabs;
@property (strong, nonatomic) UIView* selectedBackView;

@end

@implementation LBScrollTabbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.myTabs = [NSMutableArray array];
        
        // 初始化赋值
        self.separatorEnabled = YES;
        self.separatorWidth = 1;
        self.separatorColor = [UIColor lightGrayColor];
        
        self.underlineEnabled = YES;
        self.underlineWidth = 2;
        self.underlineColor = [UIColor blueColor];
        
        self.selectedTabBackgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
        self.tabWidth = 0.2*MYWIDTH;
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:13];
        self.backgroundColor = [UIColor whiteColor];
        self.myBackgroundColor = [UIColor whiteColor];
        self.duration = 0.2;
        
        // 添加separator
        UIView* separator = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-self.separatorWidth, frame.size.width, self.separatorWidth)];
        separator.backgroundColor = self.separatorColor;
        [self addSubview:separator];
        self.separator = separator;
        
        // 添加scrollView
        UIScrollView* myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-self.separatorWidth)];
        myScrollView.showsHorizontalScrollIndicator = NO;
        myScrollView.showsVerticalScrollIndicator   = NO;
        [self addSubview:myScrollView];
        self.myScrollView = myScrollView;

    }
    return self;
}

- (void)setSeparatorEnabled:(BOOL)separatorEnabled {

    _separatorEnabled = separatorEnabled;
    
    if (separatorEnabled) {
        if (self.separator) {
            self.separator.hidden = NO;
        }
    }else {
        if (self.separator) {
            self.separator.hidden = YES;
        }
    }
}

- (void)setSeparatorColor:(UIColor *)separatorColor {

    _separatorColor = separatorColor;
    
    if (self.separator) {
        self.separator.backgroundColor = separatorColor;
    }
}

- (void)setSeparatorWidth:(CGFloat)separatorWidth {

    _separatorWidth = separatorWidth;
    
    if (self.separator) {
        self.separator.frame = CGRectMake(0, MYHEIGHT-separatorWidth, MYWIDTH, separatorWidth);
        if (self.myScrollView) {
            self.myScrollView.frame = CGRectMake(0, 0, MYWIDTH, MYHEIGHT-separatorWidth);
        }
    }
    
    // 重新布局
    [self setNeedsLayout];
}

- (void)setMyBackgroundColor:(UIColor *)myBackgroundColor {

    _myBackgroundColor = myBackgroundColor;
    
    if (self.myScrollView) {
        self.myScrollView.backgroundColor = myBackgroundColor;
    }
}

- (void)setTitles:(NSArray<NSString *> *)titles {

    // 清除之前的Tabs
    if (self.myTabs.count) {
        for (UIButton* tab in self.myTabs) {
            [tab removeFromSuperview];
        }
        self.myTabs = nil;
    }
    _titles = nil;
    
    if (!self.myScrollView) {
        return;
    }
    
    _titles = titles;
    // 添加selectedBackView
    UIView* selectedBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabWidth, self.myScrollView.height)];
    selectedBackView.backgroundColor = self.selectedTabBackgroundColor;
    self.selectedBackView = selectedBackView;
    [self.myScrollView addSubview:selectedBackView];
    
    // 添加underline
    if (self.underlineEnabled) {
        UIView* underline = [[UIView alloc]initWithFrame:CGRectMake(0, selectedBackView.height-self.underlineWidth, selectedBackView.width, self.underlineWidth)];
        underline.backgroundColor = self.underlineColor;
        [selectedBackView addSubview:underline];
    }
    
    // 设置contentSize
    self.myScrollView.contentSize = CGSizeMake(titles.count*self.tabWidth, self.myScrollView.height);
    
    // 添加buttons
    [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton* tab = [UIButton buttonWithType:UIButtonTypeCustom];
        [tab setTitleColor:self.titleColor forState:UIControlStateNormal];
        [tab setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
        tab.backgroundColor = [UIColor clearColor];
        tab.tag = idx;
        [tab setTitle:obj forState:UIControlStateNormal];
        tab.titleLabel.font = self.titleFont;
        [tab addTarget:self action:@selector(tabTouched:) forControlEvents:UIControlEventTouchUpInside];
        tab.frame = CGRectMake(idx*self.tabWidth, 0, self.tabWidth, self.myScrollView.height);
        if (idx == 0) {
            tab.selected = YES;
        }
        [self.myScrollView addSubview:tab];
        [self.myTabs addObject:tab];
    }];
    
}

//
- (void)setTheSelectedIndex:(NSInteger)theSelectedIndex {
    
    _theSelectedIndex = theSelectedIndex;
    
    UIButton* theSelectedTab = self.myTabs[theSelectedIndex];
    theSelectedTab.selected = YES;
    
    for (UIButton* tab in self.myTabs) {
        if (![tab isEqual:theSelectedTab]) {
            tab.selected = NO;
        }
    }
}

- (void)tabTouched:(UIButton*)sender {
    
    sender.selected = YES;
    for (UIButton* tab in self.myTabs) {
        if (![tab isEqual:sender]) {
            tab.selected = NO;
        }
    }
    
    // 动画
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.selectedBackView) {
            self.selectedBackView.x = sender.tag*self.tabWidth;
            if (self.myScrollView) {
                [self.myScrollView scrollRectToVisible:self.selectedBackView.frame animated:NO];
            }
        }
    } completion:^(BOOL finished) {
        
    }];
    
    // 告诉代理
    [self.delegate LBScrollTabbar:self clickedAtIndex:sender.tag withTitle:sender.currentTitle withTab:sender];
    
}

/** 移动选中背景至theX */
- (void)moveSelectedBackgroundViewTo:(CGFloat)theX {

    for (UIButton* tab in self.myTabs) {
        tab.selected = NO;
    }
    
    self.selectedBackView.x = theX;
    [self.myScrollView scrollRectToVisible:CGRectMake(theX, 0, self.tabWidth, MYHEIGHT) animated:ANIMATED];
    
}

@end
