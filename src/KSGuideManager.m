//
//  KSGuideManager.m
//  KSGuide
//
//  Created by bing.hao on 16/3/10.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "KSGuideManager.h"

static NSString *identifier = @"Cell";

@interface KSGuideViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation KSGuideViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self myInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self myInit];
    }
    return self;
}

- (void)myInit {
    
    self.layer.masksToBounds = YES;
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = kScreenBounds;
    self.imageView.center = CGPointMake(kScreenBounds.size.width / 2, kScreenBounds.size.height / 2);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:self.imageView];
}

@end

@interface KSGuideManager ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UICollectionView *view;

@end

@implementation KSGuideManager
@synthesize contentView = _contentView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.animationType = KSGuideAnimationTypeFadeOut;
        self.animationDuration = 0.3f;
    }
    return self;
}

+ (instancetype)shared {
    static id __staticObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __staticObject = [KSGuideManager new];
    });
    return __staticObject;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _contentView;
}

- (UICollectionView *)view {
    if (_view == nil) {
        
        CGRect screen = [UIScreen mainScreen].bounds;
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = screen.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _view = [[UICollectionView alloc] initWithFrame:screen collectionViewLayout:layout];
        _view.bounces = NO;
        _view.backgroundColor = [UIColor whiteColor];
        _view.showsHorizontalScrollIndicator = NO;
        _view.showsVerticalScrollIndicator = NO;
        _view.pagingEnabled = YES;
        _view.dataSource = self;
        _view.delegate = self;
        
        [_view registerClass:[KSGuideViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _view;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, 0, kScreenBounds.size.width, 44.0f);
        _pageControl.center = CGPointMake(kScreenBounds.size.width / 2, kScreenBounds.size.height - 60);
    }
    return _pageControl;
}

- (void)clearMark {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [ud removeObjectForKey:[NSString stringWithFormat:@"KSGuide_%@", version]];
}

- (BOOL)showGuideViewWithImages:(NSArray *)images {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //根据版本号来区分是否要显示引导图
    BOOL show = [ud boolForKey:[NSString stringWithFormat:@"KSGuide_%@", version]];

    if (!show && self.window == nil) {

        self.images = images;
        self.pageControl.numberOfPages = images.count;
        self.window = [UIApplication sharedApplication].keyWindow;
        
        [self.contentView addSubview:self.view];
        [self.contentView addSubview:self.pageControl];
        [self.window addSubview:self.contentView];
        
        if ([self.delegate respondsToSelector:@selector(isShowPageControl)]) {
            self.pageControl.hidden = !([self.delegate isShowPageControl]);
        }
        if ([self.delegate respondsToSelector:@selector(KSGuidDidShowView:)]) {
            [self.delegate KSGuidDidShowView:self];
        }
        [ud setBool:YES forKey:[NSString stringWithFormat:@"KSGuide_%@", version]];
        [ud synchronize];
        return YES;
    }
    return NO;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KSGuideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *path = [self.images objectAtIndex:indexPath.row];
//    UIImage *img = [UIImage imageWithContentsOfFile:path];
//    CGSize size = [self adapterSizeImageSize:img.size compareSize:kScreenBounds.size];
//    
//    //自适应图片位置,图片可以是任意尺寸,会自动缩放.
    cell.imageView.frame = CGRectMake(0, 0, kScreenBounds.size.width, kScreenBounds.size.height);
    cell.imageView.image = [UIImage imageWithContentsOfFile:path];
//    cell.imageView.center = CGPointMake(kScreenBounds.size.width / 2, kScreenBounds.size.height / 2);

    if (indexPath.row == self.images.count - 1) {
        if (cell.button == nil) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(KSGuidLastPageButton)]) {
                cell.button = [self.delegate KSGuidLastPageButton];
                
            } else {
                cell.button = [self defaultButton];
            }
            if (cell.button) {
                [cell.button addTarget:self action:@selector(nextButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:cell.button];
            }
        }
    } else {
        if (cell.button != nil) {
            [cell.button removeFromSuperview];
            [cell setButton:nil];
        }
    }
    return cell;
}

- (UIButton *)defaultButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 200, 44)];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.layer setCornerRadius:5];
    [button.layer setBorderColor:[UIColor grayColor].CGColor];
    [button.layer setBorderWidth:1.0f];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setCenter:CGPointMake(kScreenBounds.size.width / 2, kScreenBounds.size.height - 100)];
    return button;
}

- (CGSize)adapterSizeImageSize:(CGSize)is compareSize:(CGSize)cs
{
    CGFloat w = cs.width;
    CGFloat h = cs.width / is.width * is.height;
    
    if (h < cs.height) {
        w = cs.height / h * w;
        h = cs.height;
    }
    return CGSizeMake(w, h);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = (scrollView.contentOffset.x / kScreenBounds.size.width);
}

- (void)hideGuideView {
    [self nextButtonHandler:nil];
}

- (void)nextButtonHandler:(id)sender {

    if (self.animationType != KSGuideAnimationTypeNothing) {
        
        __weak __typeof(&*self)ws = self;
        
        [UIView animateWithDuration:self.animationDuration animations:^{
            if (ws.animationType == KSGuideAnimationTypeFadeOut) {
                ws.view.alpha = 0;
            } else if (ws.animationType == KSGuideAnimationTypeTop) {
                ws.view.center = CGPointMake((kScreenBounds.size.width / 2), -(kScreenBounds.size.height / 2));
            } else if (ws.animationType == KSGuideAnimationTypeBottom) {
                ws.view.center = CGPointMake((kScreenBounds.size.width / 2), (kScreenBounds.size.height / 2) * 3);
            } else if (ws.animationType == KSGuideAnimationTypeLeft) {
                ws.view.center = CGPointMake(-(kScreenBounds.size.width / 2), (kScreenBounds.size.height / 2));
            } else if (ws.animationType == KSGuideAnimationTypeRight) {
                ws.view.center = CGPointMake((kScreenBounds.size.width / 2) * 3, (kScreenBounds.size.height / 2));
            }
            
        } completion:^(BOOL finished) {
            [ws.pageControl removeFromSuperview];
            [ws.view removeFromSuperview];
            [ws.contentView removeFromSuperview];
            [ws setWindow:nil];
            [ws setPageControl:nil];
            [self setView:nil];
            _contentView = nil;
        }];
    } else {
        [self.pageControl removeFromSuperview];
        [self.view removeFromSuperview];
        [self.contentView removeFromSuperview];
        [self setWindow:nil];
        [self setPageControl:nil];
        [self setView:nil];
        _contentView = nil;
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(KSGuidLastPageButtonDidOnClick)]) {
        [self.delegate KSGuidLastPageButtonDidOnClick];
    }
}

@end
