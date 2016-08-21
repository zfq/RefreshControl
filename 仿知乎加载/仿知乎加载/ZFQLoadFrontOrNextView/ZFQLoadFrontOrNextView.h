//
//  ZFQLoadFrontOrNextView.h
//  仿知乎加载
//
//  Created by _ on 16/8/15.
//  Copyright © 2016年 NXB. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const zfqLoadViewHeight = 80;

typedef NS_ENUM(NSInteger, ZFQLoadRefreshState) {
    ZFQLoadRefreshStateNormal,   //not visible
    ZFQLoadRefreshStatePulling,
    ZFQLoadRefreshStateReay,
    ZFQLoadRefreshStateLoading
};

@interface ZFQLoadFrontOrNextView : UIView
{
    UIScrollView *_loadScrollView;
    ZFQLoadRefreshState _refeshState;
    CGFloat _orginInsetsTop;
    CGFloat _orginInsetsBottom;
    CGFloat _originOffsetY;
}
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) BOOL retainOriginalShape;    //保持原有形状
@property (nonatomic,assign) ZFQLoadRefreshState refeshState;
@property (nonatomic,copy) void (^beginRefreshBlk)();

- (void)beginRefresh;
- (void)stopLoading;

@end

//加载上一篇
@interface ZFQLoadHeaderView : ZFQLoadFrontOrNextView

- (void)begainPullAnimation;
- (void)endPullAnimation;

@end

//加载下一篇
@interface ZFQLoadFooterView : ZFQLoadFrontOrNextView

@property (nonatomic,strong) NSLayoutConstraint *topC;

- (void)begainPullAnimation;
- (void)endPullAnimation;

@end