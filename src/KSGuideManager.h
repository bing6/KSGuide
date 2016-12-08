//
//  KSGuideManager.h
//  KSGuide
//
//  Created by bing.hao on 16/3/10.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kScreenBounds [UIScreen mainScreen].bounds

typedef enum : NSUInteger {
    KSGuideAnimationTypeNothing,
    KSGuideAnimationTypeFadeOut,
    KSGuideAnimationTypeLeft,
    KSGuideAnimationTypeRight,
    KSGuideAnimationTypeTop,
    KSGuideAnimationTypeBottom
} KSGuideAnimationType;

@protocol  KSGuideDelegate <NSObject>

@optional

- (void)KSGuidDidShowView:(id)sender;

/**
 是否显示分页

 @return 是否
 */
- (BOOL)isShowPageControl;
/**
 *  设置最后一页的跳转Button
 *
 *  @return UIButton
 */
- (UIButton *)KSGuidLastPageButton;

/**
 *  按下了Button按钮
 */
- (void)KSGuidLastPageButtonDidOnClick;

@end

@interface KSGuideManager : NSObject

@property (nonatomic, strong, readonly) UIView *contentView;
/**
 * 退出时动画效果,默认为淡出
 */
@property (nonatomic, assign) KSGuideAnimationType animationType;

/**
 * 动画执行时间
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 * 委托
 */
@property (nonatomic, weak) id<KSGuideDelegate> delegate;

/**
 * 共享实例
 */
+ (instancetype)shared;

/**
 *  清除显示过的标记
 */
- (void)clearMark;

/**
 *  显示引导图片
 *
 *  @param images images
 *  @return 是否显示了引导图
 */
- (BOOL)showGuideViewWithImages:(NSArray *)images;

/**
 隐藏引导图
 */
- (void)hideGuideView;

@end
