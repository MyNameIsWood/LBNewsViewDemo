//
//  LBNewsView.h
//  LBNewsViewDemo
//
//  Created by 刘柏杉 on 16/3/28.
//  Copyright © 2016年 刘柏杉. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBNewsView;
@protocol LBNewsViewDelegate <NSObject>
/** 处理标签被点击的回调 */
- (void)newsView:(LBNewsView*)theNewsView didClickedTabWithIndex:(NSInteger)theIndex withTitle:(NSString*)theTitle withTab:(UIButton*)theTab;
/** 处理标签被点击的回调 */
- (void)newsView:(LBNewsView*)theNewsView didScrollToViewWithIndex:(NSInteger)theIndex;
@end

@protocol LBNewsViewDataSource <NSObject>
/** 获取Index对应的View */
- (UIView*)newsView:(LBNewsView*)theNewsView viewForIndex:(NSInteger)theIndex;

@end

@interface LBNewsView : UIView

#pragma mark - UI
/** 设置是否有分割线（默认是yes） */
@property (assign, nonatomic) BOOL separatorEnabled;
/** 设置分割线宽度（默认是1） */
@property (assign, nonatomic) CGFloat separatorWidth;
/** 设置分割线颜色（默认是lightGrayColor） */
@property (strong, nonatomic) UIColor* separatorColor;

/** 设置是否有下划线(默认是yes) */
@property (assign, nonatomic) BOOL underlineEnabled;
/** 设置下划线宽度（默认是2) */
@property (assign, nonatomic) CGFloat underlineWidth;
/** 设置下划线颜色（默认是blueColor） */
@property (strong, nonatomic) UIColor* underlineColor;

/** 设置选中Tab的背景颜色（默认是半透明灰色） */
@property (strong, nonatomic) UIColor* selectedTabBackgroundColor;
/** 设置Tab按钮宽度（默认是0.2倍的自己宽度） */
@property (assign, nonatomic) CGFloat tabWidth;
/** 设置文字颜色（默认是blackColor） */
@property (strong, nonatomic) UIColor* titleColor;
/** 设置文字字体（默认是[UIFont systemFontOfSize:13]） */
@property (strong, nonatomic) UIFont* titleFont;
/** 设置背景颜色（默认是whiteColor） */
@property (strong, nonatomic) UIColor* myBackgroundColor;
/** 设置标签栏高度（默认是40） */
@property (assign, nonatomic) CGFloat scrollTabbarHeight;
#pragma mark - 动画
/** 设置selectedBackView移动动画时间（默认是0.2） */
@property (assign, nonatomic) NSTimeInterval duration;

#pragma mark - 数据
/** 设置标题 */
@property (strong, nonatomic) NSArray<NSString*>* titles;
/** 代理 */
@property (weak, nonatomic) id<LBNewsViewDelegate> delegate;
/** 数据源 */
@property (weak, nonatomic) id<LBNewsViewDataSource> dataSource;

@end
