//
//  LBNewsView.m
//  LBNewsViewDemo
//
//  Created by 刘柏杉 on 16/3/28.
//  Copyright © 2016年 刘柏杉. All rights reserved.
//

#import "LBNewsView.h"
#import "LBScrollTabbar.h"

#define MYWIDTH  self.bounds.size.width
#define MYHEIGHT self.bounds.size.height
#define ANIMATED YES

@interface LBNewsView ()<LBScrollTabbarDelegate>

@property (strong, nonatomic) LBScrollTabbar* myScrollTabbar;
@property (strong, nonatomic) UIScrollView* myContentView;
@property (strong, nonatomic) NSMutableArray<UIView*>* dataViews;

@end

@implementation LBNewsView
- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.scrollTabbarHeight = 40;
        
        self.dataViews = [NSMutableArray array];
        
        // 添加LBScrollTabbar
        LBScrollTabbar* scrollTabbar = [[LBScrollTabbar alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, self.scrollTabbarHeight)];
        self.myScrollTabbar = scrollTabbar;
        self.myScrollTabbar.delegate = self;
        [self addSubview:scrollTabbar];
        
        // 添加scrollView
        UIScrollView* contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.scrollTabbarHeight, frame.size.width, frame.size.height-self.scrollTabbarHeight)];
        contentView.pagingEnabled = YES;
        self.myContentView = contentView;
        self.myContentView.delegate = self;
        [self addSubview:contentView];
        
    }
    return self;
}

#pragma mark - set方法
-(void)setSeparatorEnabled:(BOOL)separatorEnabled {
    _separatorEnabled = separatorEnabled;
    self.myScrollTabbar.separatorEnabled = separatorEnabled;
}

- (void)setSeparatorWidth:(CGFloat)separatorWidth {
    _separatorWidth = separatorWidth;
    self.myScrollTabbar.separatorWidth = separatorWidth;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    self.myScrollTabbar.separatorColor = separatorColor;
}

- (void)setUnderlineEnabled:(BOOL)underlineEnabled {
    _underlineEnabled = underlineEnabled;
    self.myScrollTabbar.underlineEnabled = underlineEnabled;
}

- (void)setUnderlineWidth:(CGFloat)underlineWidth {
    _underlineWidth = underlineWidth;
    self.myScrollTabbar.underlineWidth = underlineWidth;
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    _underlineColor = underlineColor;
    self.myScrollTabbar.underlineColor = underlineColor;
}

- (void)setSelectedTabBackgroundColor:(UIColor *)selectedTabBackgroundColor {
    _selectedTabBackgroundColor = selectedTabBackgroundColor;
    self.myScrollTabbar.selectedTabBackgroundColor = selectedTabBackgroundColor;
}

- (void)setTabWidth:(CGFloat)tabWidth {
    _tabWidth = tabWidth;
    self.myScrollTabbar.tabWidth = tabWidth;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.myScrollTabbar.titleColor = titleColor;
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
    self.myScrollTabbar.selectedTitleColor = selectedTitleColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.myScrollTabbar.titleFont = titleFont;
}

- (void)setMyBackgroundColor:(UIColor *)myBackgroundColor {
    _myBackgroundColor = myBackgroundColor;
    self.myScrollTabbar.myBackgroundColor = myBackgroundColor;
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    self.myScrollTabbar.duration = duration;
}

- (void)setScrollTabbarHeight:(CGFloat)scrollTabbarHeight {
    _scrollTabbarHeight = scrollTabbarHeight;
    self.myScrollTabbar.frame = CGRectMake(0, 0, MYWIDTH, scrollTabbarHeight);
    self.myContentView.frame = CGRectMake(0, scrollTabbarHeight, MYWIDTH, MYHEIGHT-scrollTabbarHeight);
    [self setNeedsLayout];
}

#pragma mark - 重要方法
- (void)setDataSource:(id<LBNewsViewDataSource>)dataSource {
    NSAssert(dataSource, @"这里错误");
    _dataSource = dataSource;
    if (self.titles == nil) {
        return;
    }
    
    // 循环索求数据视图
    for (NSInteger theIndex=0; theIndex<self.titles.count; theIndex++) {
        UIView* dataView = [dataSource newsView:self viewForIndex:theIndex];
        dataView.frame = CGRectMake(theIndex*self.myContentView.bounds.size.width, 0, self.myContentView.bounds.size.width, self.myContentView.bounds.size.height);
        [self.myContentView addSubview:dataView];
        [self.dataViews addObject:dataView];
    }
}

- (void)setTitles:(NSArray<NSString *> *)titles {

    _titles = titles;
    
    self.myScrollTabbar.titles = titles;
    
    self.myContentView.contentSize = CGSizeMake(self.myContentView.bounds.size.width*titles.count, self.myContentView.bounds.size.height);
    
    if (self.dataSource) {
        // 循环索求数据视图
        for (NSInteger theIndex=0; theIndex<titles.count; theIndex++) {
            UIView* dataView = [self.dataSource newsView:self viewForIndex:theIndex];
            dataView.frame = CGRectMake(theIndex*self.myContentView.bounds.size.width, 0, self.myContentView.bounds.size.width, self.myContentView.bounds.size.height);
            [self.myContentView addSubview:dataView];
            [self.dataViews addObject:dataView];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.myContentView]) {
        if (scrollView.dragging||scrollView.decelerating) {

            [self.myScrollTabbar moveSelectedBackgroundViewTo:(scrollView.contentOffset.x*self.myScrollTabbar.tabWidth/scrollView.bounds.size.width)];
        }
    }
}

// 静止情况下
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.myContentView]) {// 通知代理
        
        NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
        
        self.myScrollTabbar.theSelectedIndex = index;
        
        if (self.delegate) {
            
            NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
            [self.delegate newsView:self didScrollToViewWithIndex:index];
        }
    }
}

#pragma mark - LBScrollTabbarDelegate
/** LBScrollTabbar被点击回调事件 */
- (void)LBScrollTabbar:(LBScrollTabbar*)theScrollTabbar clickedAtIndex:(NSInteger)theIndex withTitle:(NSString*)theTitle withTab:(UIButton*)theTab {

    // scrollView跟着滚动
    NSAssert(self.myContentView.contentSize.width>=theIndex*self.myContentView.bounds.size.width, @"这里错误");
    [self.myContentView setContentOffset:CGPointMake(theIndex*self.myContentView.bounds.size.width, 0)  animated:ANIMATED];
    
    if (self.delegate) {// 通知代理
        [self.delegate newsView:self didClickedTabWithIndex:theIndex withTitle:theTitle withTab:theTab];
    }
}




@end
