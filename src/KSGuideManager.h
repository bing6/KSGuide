//
//  KSGuideManager.h
//  KSGuide
//
//  Created by bing.hao on 16/3/10.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KSGuideManager : NSObject

+ (instancetype)shared;

- (void)showGuideViewWithImages:(NSArray *)images;

@end
