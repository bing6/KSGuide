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

@protocol  KSGuideDelegate <NSObject>

@optional
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

@property (nonatomic, weak) id<KSGuideDelegate> delegate;

+ (instancetype)shared;

/**
 *  清除显示过的标记
 */
- (void)clearMark;

/**
 *  显示引导图片
 *
 *  @param images images
 */
- (void)showGuideViewWithImages:(NSArray *)images;

@end
