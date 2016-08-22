//
//  ZFQLoadFrontOrNextView.m
//  仿知乎加载
//
//  Created by _ on 16/8/15.
//  Copyright © 2016年 NXB. All rights reserved.
//

#import "ZFQLoadFrontOrNextView.h"

#define ZFQLoadViewAnimationDuration 0.5
#define ZFQLoadViewBoundceAnimationDuration 0.5

static NSString * const ZFQLoadViewContentOffset = @"contentOffset";
static NSString * const ZFQLoadViewContentSize = @"contentSize";

@interface ZFQLoadFrontOrNextView()
{
    CGPathRef orginPath;
    CGPathRef arrowTopPath;
    CGPathRef arrowBottomPath;
    BOOL _isOriginState;
}

@end

@implementation ZFQLoadFrontOrNextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor grayColor];
        _titleLabel.text = @"上下拉加载上下坡";
        [self addSubview:_titleLabel];
        
        _retainOriginalShape = NO;
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.backgroundColor = [UIColor redColor].CGColor;
        _shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        _shapeLayer.fillColor = [UIColor orangeColor].CGColor;
        _shapeLayer.lineWidth = 3;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineJoin = kCALineJoinRound;
        _shapeLayer.bounds = CGRectMake(0, 0, 40, 20);
        [self.layer addSublayer:_shapeLayer];
        
        _isOriginState = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    //更新label位置
    CGSize actualSize = [_titleLabel sizeThatFits:frame.size];
    CGFloat orginX = fabs((frame.size.width - actualSize.width)/2);
    CGFloat originY = 20;
    _titleLabel.frame = CGRectMake(orginX, originY, actualSize.width, actualSize.height);
    
    //更新shapLayer的位置
    CGFloat pX = frame.size.width/2;
    CGFloat pY = CGRectGetMaxY(_titleLabel.frame) + 8 + _shapeLayer.bounds.size.height/2;
    _shapeLayer.position = CGPointMake(pX, pY);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (_loadScrollView != newSuperview) {
        [_loadScrollView removeObserver:self forKeyPath:ZFQLoadViewContentOffset];
        _loadScrollView = (UIScrollView *)newSuperview;
        [_loadScrollView addObserver:self forKeyPath:ZFQLoadViewContentOffset options:NSKeyValueObservingOptionNew context:NULL];
    }
}

#pragma mark - Getter
- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    _shapeLayer.strokeColor = _lineColor.CGColor;
}

//横线
- (CGPathRef)originPath
{
    if (!orginPath) {
        CGSize size = self.shapeLayer.bounds.size;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, size.height/2);
        CGPathAddLineToPoint(path, NULL, size.width/2, size.height/2);
        CGPathMoveToPoint(path, NULL, size.width, size.height/2);
        CGPathAddLineToPoint(path, NULL, size.width/2, size.height/2);
        orginPath = path;
    }
    return orginPath;
}

- (CGPathRef)arrowTopPath
{
    if (!arrowTopPath) {
        CGSize size = self.shapeLayer.bounds.size;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, size.height/2);
        CGPathAddLineToPoint(path, NULL, size.width/2, 0);
        CGPathMoveToPoint(path, NULL, size.width, size.height/2);
        CGPathAddLineToPoint(path, NULL, size.width/2, 0);
        arrowTopPath = path;
    }
    return arrowTopPath;
}

- (CGPathRef)arrowBottomPath
{
    if (!arrowBottomPath) {
        CGSize size = self.shapeLayer.bounds.size;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, size.height/2);
        CGPathAddLineToPoint(path, NULL, size.width/2, size.height);
        CGPathMoveToPoint(path, NULL, size.width, size.height/2);
        CGPathAddLineToPoint(path, NULL, size.width/2, size.height);
        arrowBottomPath = path;
    }
    return arrowBottomPath;
}

- (void)pathAnimationFrom:(id)fromValue to:(id)toValue forKey:(NSString *)key
{
    if (self.retainOriginalShape == NO) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.duration = ZFQLoadViewAnimationDuration;
        animation.fromValue = fromValue;
        animation.toValue = toValue;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        self.retainOriginalShape = YES;
        [self.shapeLayer addAnimation:animation forKey:key];
    }
}

- (void)beginRefresh {}
- (void)stopLoading {}

- (void)dealloc
{
    CGPathRelease(orginPath);
    CGPathRelease(arrowTopPath);
    CGPathRelease(arrowBottomPath);
    
    [_loadScrollView removeObserver:self forKeyPath:ZFQLoadViewContentOffset];
}

@end

//----------------------------------
//----------------------------------
@implementation UIScrollView(ZFQAdditions)

- (void)setContentInsetsTop:(CGFloat)top
{
    UIEdgeInsets insets = self.contentInset;
    self.contentInset = UIEdgeInsetsMake(top, insets.left, insets.bottom, insets.right);
}

- (void)setContentInsetsBottom:(CGFloat)bottom
{
    UIEdgeInsets insets = self.contentInset;
    self.contentInset = UIEdgeInsetsMake(insets.top, insets.left, bottom, insets.right);
}

- (void)setContentOffsetY:(CGFloat)y animated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(self.contentOffset.x, y) animated:animated];
}

@end


//----------------------------------
//----------------------------------
#pragma mark - 加载上一篇
@implementation ZFQLoadHeaderView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.shapeLayer.path = [self arrowTopPath];
    
    _orginInsetsTop = _loadScrollView.contentInset.top;
    _orginInsetsBottom = _loadScrollView.contentInset.bottom;
    _originOffsetY = _loadScrollView.contentOffset.y;
}

- (void)beginRefresh
{
    [_loadScrollView setContentOffsetY:-zfqLoadViewHeight animated:YES];
}

- (void)stopLoading
{
    self.refeshState = ZFQLoadRefreshStateNormal;
}

- (void)begainPullAnimation
{
    id fromValue = (__bridge id)[self arrowTopPath];
    id toValue = (__bridge id)[self originPath];
    [self pathAnimationFrom:fromValue to:toValue forKey:@"header"];
}

- (void)endPullAnimation
{
    id fromValue = (__bridge id)[self originPath];
    id toValue = (__bridge id)[self arrowTopPath];
    [self pathAnimationFrom:fromValue to:toValue forKey:@"header"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (_refeshState == ZFQLoadRefreshStateLoading
        || self.userInteractionEnabled == NO
        || self.alpha <= 0.01
        || ([keyPath isEqualToString:ZFQLoadViewContentOffset] == NO)) {
        return;
    }
    
    CGFloat offsetY = _loadScrollView.contentOffset.y;
    
    if (offsetY < 0) {
        if (offsetY <= -zfqLoadViewHeight) {    //表示下拉拉很大
            self.refeshState = ZFQLoadRefreshStateReay;
            if (_loadScrollView.isDragging  == NO && _loadScrollView.isDecelerating == YES) {
                //开始加载后设置为正在加载状态
                self.refeshState = ZFQLoadRefreshStateLoading;
            }
        } else {
            if (self.refeshState != ZFQLoadRefreshStateNormal) {
                self.refeshState = ZFQLoadRefreshStatePulling;
            }
        }
    }
}

- (void)setRefeshState:(ZFQLoadRefreshState)refeshState
{
    if (_refeshState == refeshState) {
        return;
    }
    
    _refeshState = refeshState;
    if (_refeshState == ZFQLoadRefreshStateReay) {
        //开始动画
        NSLog(@"开始动画");
        self.retainOriginalShape = NO;
        [self begainPullAnimation];
    } else if (_refeshState == ZFQLoadRefreshStatePulling) {
        //恢复动画
        NSLog(@"恢复动画");
        self.retainOriginalShape = NO;
        [self endPullAnimation];
    } else if (_refeshState == ZFQLoadRefreshStateLoading) {
        CGFloat offsetY = _loadScrollView.contentOffset.y;
        [_loadScrollView setContentInsetsTop:_orginInsetsTop + zfqLoadViewHeight];
        [_loadScrollView setContentOffset:CGPointMake(0, offsetY)];
        
        if (self.beginRefreshBlk) {
            self.beginRefreshBlk();
        }
        
        /*
         [UIView animateWithDuration:2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
         [_loadScrollView setContentInsetsTop:_orginInsetsTop + zfqLoadViewHeight];
         //            [_loadScrollView setContentOffset:CGPointMake(0, -(_orginInsetsTop + zfqLoadViewHeight)) animated:NO]; //抖动
         //            [_loadScrollView setContentOffset:CGPointMake(0, contentTop) animated:NO]; //卡死不动
         //            [_loadScrollView setContentOffset:CGPointMake(0, -(_orginInsetsTop + zfqLoadViewHeight))]; //抖动
         [_loadScrollView setContentOffset:CGPointMake(0, contentTop)]; //正常 但动画时间不起作用了
         } completion:^(BOOL finished) {
            if (finished && self.beginRefreshBlk) {
                self.beginRefreshBlk();
            }
         }];
         */
        
        
    } else if (_refeshState == ZFQLoadRefreshStateNormal) {
        
        [UIView animateWithDuration:ZFQLoadViewBoundceAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            [_loadScrollView setContentInsetsTop:_orginInsetsTop];
            
            CGFloat offsetX = _loadScrollView.contentOffset.x;
            [_loadScrollView setContentOffset:CGPointMake(offsetX, _originOffsetY) animated:NO];
        } completion:^(BOOL finished) {
            
        }];
        
        NSLog(@"normal恢复动画");
        self.retainOriginalShape = NO;
        [self endPullAnimation];
    }
}

- (void)dealloc
{
    [_loadScrollView removeObserver:self forKeyPath:ZFQLoadViewContentSize];
}
@end

#pragma mark - 加载下一篇
@implementation ZFQLoadFooterView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.shapeLayer.path = [self arrowBottomPath];
    CGFloat height = _loadScrollView.contentSize.height;
    [self.topC setConstant:height];
    
    _orginInsetsTop = _loadScrollView.contentInset.top;
    _orginInsetsBottom = _loadScrollView.contentInset.bottom;
    _originOffsetY = _loadScrollView.contentOffset.y;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (_loadScrollView == newSuperview) {
        _loadScrollView = (UIScrollView *)newSuperview;
        [_loadScrollView addObserver:self forKeyPath:ZFQLoadViewContentSize options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)beginRefresh
{
    [_loadScrollView setContentOffsetY:zfqLoadViewHeight animated:YES];
}

- (void)stopLoading
{
    self.refeshState = ZFQLoadRefreshStateNormal;
}

- (void)begainPullAnimation
{
    id fromValue = (__bridge id)[self arrowBottomPath];
    id toValue = (__bridge id)[self originPath];
    [self pathAnimationFrom:fromValue to:toValue forKey:@"footer"];
}

- (void)endPullAnimation
{
    id fromValue = (__bridge id)[self originPath];
    id toValue = (__bridge id)[self arrowBottomPath];
    [self pathAnimationFrom:fromValue to:toValue forKey:@"footer"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (_refeshState == ZFQLoadRefreshStateLoading || self.userInteractionEnabled == NO || self.alpha <= 0.01) {
        return;
    }
    
    CGFloat offsetY = _loadScrollView.contentOffset.y;
    CGFloat contentH = _loadScrollView.contentSize.height;
    CGFloat boundsH = _loadScrollView.bounds.size.height;

    CGFloat aa = contentH - boundsH;
    if (aa <= 0) {
        aa = 0;
    }
    
    if (offsetY > 0) {
        if (offsetY >= zfqLoadViewHeight + aa) {    //表示下拉拉很大
            self.refeshState = ZFQLoadRefreshStateReay;
            if (_loadScrollView.isDragging == NO) {
                //开始加载后设置为正在加载状态
                self.refeshState = ZFQLoadRefreshStateLoading;
            }
        } else {
            if (self.refeshState != ZFQLoadRefreshStateNormal) {
                self.refeshState = ZFQLoadRefreshStatePulling;
            }
        }
    }
    
    //只有scrollView的contentSize改变时，才调整位置
    if ([keyPath isEqualToString:ZFQLoadViewContentSize]) {
        CGFloat height = _loadScrollView.contentSize.height;
        [self.topC setConstant:height];
    }
}

- (void)setRefeshState:(ZFQLoadRefreshState)refeshState
{
    if (_refeshState == refeshState) {
        return;
    }
    
    _refeshState = refeshState;
    if (_refeshState == ZFQLoadRefreshStateReay) {
        //开始动画
        NSLog(@"开始动画");
        self.retainOriginalShape = NO;
        [self begainPullAnimation];
    } else if (_refeshState == ZFQLoadRefreshStatePulling) {
        //恢复动画
        NSLog(@"恢复动画");
        self.retainOriginalShape = NO;
        [self endPullAnimation];
    } else if (_refeshState == ZFQLoadRefreshStateLoading) {
        
        CGFloat offsetY = _loadScrollView.contentOffset.y;
        [_loadScrollView setContentInsetsBottom:_orginInsetsBottom + zfqLoadViewHeight];
        [_loadScrollView setContentOffset:CGPointMake(0, offsetY)];
        
        if (self.beginRefreshBlk) {
            self.beginRefreshBlk();
        }
        
    } else if (_refeshState == ZFQLoadRefreshStateNormal) {
        
        [UIView animateWithDuration:ZFQLoadViewBoundceAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            [_loadScrollView setContentInsetsBottom:_orginInsetsBottom];
            
            CGFloat offsetY = 0;
            CGFloat offsetX = _loadScrollView.contentOffset.x;
            CGFloat contentH = _loadScrollView.contentSize.height;
            CGFloat boundsH = _loadScrollView.bounds.size.height;
            if ( contentH >= boundsH) {
                offsetY = contentH - boundsH;
                [_loadScrollView setContentOffset:CGPointMake(offsetX, offsetY) animated:NO];
            } else {
                [_loadScrollView setContentOffset:CGPointMake(offsetX, _originOffsetY) animated:NO];
            }
            
        } completion:^(BOOL finished) {
            
        }];
        
        NSLog(@"normal恢复动画");
        self.retainOriginalShape = NO;
        [self endPullAnimation];
    }

}

@end
