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

@property (weak, nonatomic) UIView* separator;
@property (weak, nonatomic) UIScrollView* myScrollView;
@property (strong, nonatomic) NSMutableArray<UIButton*>* myTabs;
@property (weak, nonatomic) UIView* selectedBackView;
@property (weak, nonatomic) UIView* underline;

@end

@implementation LBScrollTabbar

#pragma mark - Life Cycle
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
//        self.tabWidth = 0.2*MYWIDTH;
        self.tabWidth = -1;
        self.normalTitleColor = [UIColor blackColor];
        self.selectedTitleColor = nil;
        self.titleFont = [UIFont systemFontOfSize:13];
        self.backgroundColor = [UIColor whiteColor];
        self.myBackgroundColor = [UIColor whiteColor];
        self.normalBackgroundImage = nil;
        self.selectedBackgroundImage = nil;
        self.duration = 0.2;
        
        // 添加separator
        UIView* separator = [[UIView alloc] init];
        separator.backgroundColor = _separatorColor;
        [self addSubview:separator];
        _separator = separator;
        
        // 添加scrollView
        UIScrollView* myScrollView = [[UIScrollView alloc] init];
        myScrollView.showsHorizontalScrollIndicator = NO;
        myScrollView.showsVerticalScrollIndicator   = NO;
        myScrollView.backgroundColor = _myBackgroundColor;
        [self addSubview:myScrollView];
        _myScrollView = myScrollView;

        // 添加selectedBackView
        UIView* selectedBackView = [[UIView alloc] init];
        selectedBackView.backgroundColor = _selectedTabBackgroundColor;
        _selectedBackView = selectedBackView;
        [self.myScrollView addSubview:selectedBackView];
        
        // 下划线
        UIView* underline = [[UIView alloc] init];
        underline.backgroundColor = _underlineColor;
        _underline = underline;
        [selectedBackView addSubview:underline];
        
    }
    
    return self;
    
}

// 在此布局
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 分割线
    if (_separator) {
        
        [_separator setFrame:CGRectMake(0, MYHEIGHT-_separatorWidth, MYWIDTH, _separatorWidth)];
        
    }
    
    // 滚动区域
    if (_myScrollView) {
        
        [_myScrollView setFrame:CGRectMake(0, 0, MYWIDTH, MYHEIGHT-_separatorWidth)];
        
    }
    
    // 布局tabs
    for (int i = 0; i < _myTabs.count; i++) {
        
        UIButton* tab = _myTabs[i];
        
        CGFloat X = 0;
        
        if (i > 0) {
            
            X = CGRectGetMaxX(_myTabs[i-1].frame);
            
        }
        
        CGFloat width = 0;
        if (_tabWidth > 0) {
            width = _tabWidth;
        } else {
            width = tab.intrinsicContentSize.width+10;
        }
        
        [tab setFrame:CGRectMake(X, 0, width, _myScrollView.height)];
        
    }
    
    _myScrollView.contentSize = CGSizeMake(CGRectGetMaxX(_myTabs.lastObject.frame), _myScrollView.frame.size.height);
    
    
    // 背景view
    if (_selectedBackView) {
        
        if (_myTabs && (_myTabs.count > _theSelectedIndex)) {
            
            UIButton* tab = _myTabs[_theSelectedIndex];
            [_selectedBackView setFrame:tab.frame];
            
        }
        
    }
    
    // 下划线
    if (_underline) {
        
        [_underline setFrame:CGRectMake(0, _selectedBackView.frame.size.height-_underlineWidth, _selectedBackView.frame.size.width, _underlineWidth)];
        
    }
    
}

#pragma mark - Setters
- (void)setSeparatorEnabled:(BOOL)separatorEnabled {
    
    _separatorEnabled = separatorEnabled;
    
    if (self.separator) {
        
        self.separator.hidden = !separatorEnabled;
        
    }
    
}

- (void)setSeparatorWidth:(CGFloat)separatorWidth {
    
    _separatorWidth = separatorWidth;
    
    // 重新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (void)setSeparatorColor:(UIColor *)separatorColor {

    _separatorColor = separatorColor;
    
    if (self.separator) {
        
        self.separator.backgroundColor = separatorColor;
        
    }
    
}

- (void)setUnderlineEnabled:(BOOL)underlineEnabled {
    
    _underlineEnabled = underlineEnabled;
    
    if (_underline) {
        
        _underline.hidden = !underlineEnabled;
        
    }
    
}

- (void)setUnderlineWidth:(CGFloat)underlineWidth {
    
    _underlineWidth = underlineWidth;
    
    // 重新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    
    _underlineColor = underlineColor;
    
    if (_underline) {
        
        _underline.backgroundColor = underlineColor;
        
    }
    
}

- (void)setSelectedTabBackgroundColor:(UIColor *)selectedTabBackgroundColor {
    
    _selectedTabBackgroundColor = selectedTabBackgroundColor;
    
    if (_selectedBackView) {
        
        _selectedBackView.backgroundColor = selectedTabBackgroundColor;
        
    }
    
}

- (void)setTabWidth:(CGFloat)tabWidth {
    
    _tabWidth = tabWidth;
    
    // 重新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor {
    
    _normalTitleColor = normalTitleColor;
    
    if (_myTabs && _myTabs.count) {
        
        for (UIButton* tab in _myTabs) {
            
            [tab setTitleColor:normalTitleColor forState:UIControlStateNormal];
            
        }
        
    }
    
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    
    _selectedTitleColor = selectedTitleColor;
    
    if (_myTabs && _myTabs.count) {
        
        for (UIButton* tab in _myTabs) {
            
            [tab setTitleColor:selectedTitleColor forState:UIControlStateSelected];
            
        }
        
    }
    
}

- (void)setTitleFont:(UIFont *)titleFont {
    
    _titleFont = titleFont;
    
    if (_myTabs && _myTabs.count) {
        
        for (UIButton* tab in _myTabs) {
            
             tab.titleLabel.font = self.titleFont;
            
        }
        
    }
    
}

- (void)setMyBackgroundColor:(UIColor *)myBackgroundColor {

    _myBackgroundColor = myBackgroundColor;
    
    if (self.myScrollView) {
        
        self.myScrollView.backgroundColor = myBackgroundColor;
        
    }
    
}

- (void)setNormalBackgroundImage:(UIImage *)normalBackgroundImage {
    
    _normalBackgroundImage = normalBackgroundImage;
    
    if (_myTabs && _myTabs.count) {
        
        for (UIButton* tab in _myTabs) {
            
            [tab setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
            
        }
        
    }
    
}

- (void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage {
    
    _selectedBackgroundImage = selectedBackgroundImage;
    
    if (_myTabs && _myTabs.count) {
        
        for (UIButton* tab in _myTabs) {
            
            [tab setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
            
        }
        
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
    
    // 添加buttons
    [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton* tab = [UIButton buttonWithType:UIButtonTypeCustom];
        [tab setTitleColor:_normalTitleColor forState:UIControlStateNormal];
        [tab setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
        [tab setBackgroundImage:_normalBackgroundImage forState:UIControlStateNormal];
        [tab setBackgroundImage:_selectedBackgroundImage forState:UIControlStateSelected];
        tab.backgroundColor = [UIColor clearColor];
        tab.tag = idx;
        [tab setTitle:obj forState:UIControlStateNormal];
        tab.titleLabel.font = _titleFont;
        [tab addTarget:self action:@selector(tabTouched:) forControlEvents:UIControlEventTouchUpInside];
        if (idx == _theSelectedIndex) {
            tab.selected = YES;
        }
        [self.myScrollView addSubview:tab];
        [self.myTabs addObject:tab];
    }];
    
    // 重新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

//
- (void)setTheSelectedIndex:(NSInteger)theSelectedIndex {
//    
//    _theSelectedIndex = theSelectedIndex;
//    
    UIButton* theSelectedTab = self.myTabs[theSelectedIndex];
    
    [self tabTouched:theSelectedTab];
    
//    theSelectedTab.selected = YES;
//
//    for (UIButton* tab in self.myTabs) {
//        if (![tab isEqual:theSelectedTab]) {
//            tab.selected = NO;
//        }
//    }
    
}

- (void)tabTouched:(UIButton*)sender {
    
    sender.selected = YES;
    
    for (int i = 0; i < _myTabs.count; i++) {
        
        UIButton* tab = _myTabs[i];
        
        if ([tab isEqual:sender]) {
            
            _theSelectedIndex = i;
            
        } else {
            
            tab.selected = NO;
            
        }
        
    }
    
    // 动画
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // 重新布局
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        if (self.myScrollView) {
            [self.myScrollView scrollRectToVisible:self.selectedBackView.frame animated:NO];
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
