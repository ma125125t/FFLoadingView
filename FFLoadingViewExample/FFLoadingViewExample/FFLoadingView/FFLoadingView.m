//
//  FFLoadingView.m
//  FFLoadingView
//
//  Created by fang on 2017/6/12.
//  Copyright © 2017年 organization. All rights reserved.
//

#import "FFLoadingView.h"


#define _fromValue      @(0)
#define _StationValue   @(0.3)
#define _endValue       @(0.9)
#define _duration1      (1)
#define _duration2      (0.5)
#define _durationFinish (0.7)


#define kAnimationDrawCircle    @"kAnimationDrawCircle"
#define kAnimationDrawSuccess   @"kAnimationDrawSuccess"
#define kAnimationDrawFailure   @"kAnimationDrawFailure"
#define kAnimationClose         @"kAnimationClose"

@interface FFLoadingView()<CAAnimationDelegate>

@property (nonatomic, assign) BOOL         bWillFinish;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *successLayer;
@property (nonatomic, strong) CAShapeLayer *failureLayer;

@property (nonatomic, copy  ) FFLoadingCompleteBlock finishBlock;

@end

@implementation FFLoadingView

- (void)dealloc {
    NSLog(@"FFLoadingView dealloc");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _strokeColor = [UIColor colorWithRed:0.15 green:0.7 blue:0.92 alpha:1];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor whiteColor];
        _strokeColor = [UIColor colorWithRed:0.15 green:0.7 blue:0.92 alpha:1];
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = self.strokeColor.CGColor;
    _progressLayer.lineWidth = 4;
    _progressLayer.frame = self.bounds;
    _progressLayer.lineJoin = kCALineJoinRound;
    _progressLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_progressLayer];
    
    _successLayer = [CAShapeLayer layer];
    _successLayer.fillColor = [UIColor clearColor].CGColor;
    _successLayer.strokeColor = self.strokeColor.CGColor;
    _successLayer.lineWidth = 4;
    _successLayer.frame = self.bounds;
    _successLayer.lineJoin = kCALineJoinRound;
    _successLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_successLayer];
    
    
    _failureLayer = [CAShapeLayer layer];
    _failureLayer.fillColor = [UIColor clearColor].CGColor;
    _failureLayer.strokeColor = self.strokeColor.CGColor;
    _failureLayer.lineWidth = 4;
    _failureLayer.frame = self.bounds;
    _failureLayer.lineJoin = kCALineJoinRound;
    _failureLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_failureLayer];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    _progressLayer.lineWidth = lineWidth;
    _successLayer.lineWidth = lineWidth;
    _failureLayer.lineWidth = lineWidth;
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    _progressLayer.strokeColor = strokeColor.CGColor;
    _successLayer.strokeColor = strokeColor.CGColor;
    _failureLayer.strokeColor = strokeColor.CGColor;
}

#pragma mark - load
- (void)startLoading
{
    [_progressLayer removeAllAnimations];
    _progressLayer.path = nil;
    [_successLayer removeAllAnimations];
    _successLayer.path = nil;
    [_failureLayer removeAllAnimations];
    _failureLayer.path = nil;
    
    self.bWillFinish = NO;
    
    [self drawCircleAnimation:_fromValue end:_endValue duration:_duration1];
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.repeatCount = INFINITY;
    rotateAnimation.byValue = @(M_PI*2);
    rotateAnimation.duration = 0.7;
    [_progressLayer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
}

- (void)endLoading
{
    [_progressLayer removeAllAnimations];
    _progressLayer.path = nil;
    [_successLayer removeAllAnimations];
    _successLayer.path = nil;
    [_failureLayer removeAllAnimations];
    _failureLayer.path = nil;
    [self removeFromSuperview];
}

- (void)finishSuccess:(FFLoadingCompleteBlock)block {
    self.bWillFinish = YES;
    self.finishBlock = block;
    [self drawSuccessAnimation];
    [_failureLayer removeAllAnimations];
    _failureLayer.path = nil;
}

- (void)finishFailure:(FFLoadingCompleteBlock)block {
    self.bWillFinish = YES;
    self.finishBlock = block;
    [self drawFailureAnimation];
    [_successLayer removeAllAnimations];
    _successLayer.path = nil;
}


#pragma mark - Animation Delegate -
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString* key = [anim valueForKey:@"id"];
    if ([key isEqualToString:kAnimationDrawCircle] && !self.bWillFinish) {
        [self closeCircleAnimation];
    }
    else if ([key isEqualToString:kAnimationClose] && !self.bWillFinish) {
        [_progressLayer removeAnimationForKey:@"kAnimationDrawCircle"];
        [_progressLayer removeAnimationForKey:@"kAnimationClose"];
        
        [self drawCircleAnimation:_fromValue end:_endValue duration:_duration1];
    }
    else if ([key isEqualToString:kAnimationDrawSuccess] || [key isEqualToString:kAnimationDrawFailure]) {
        if (self.finishBlock != NULL) {
            self.finishBlock();
        }
    }
}

#pragma mark - Private Methods
- (void)drawSuccessAnimation {
    UIBezierPath* successPath = [UIBezierPath bezierPath];
    CGFloat size = self.bounds.size.width;
    [successPath moveToPoint: CGPointMake(size/3.1578, size/2)];
    [successPath addLineToPoint: CGPointMake(size/2.0618, size/1.57894)];
    [successPath addLineToPoint: CGPointMake(size/1.3953, size/2.7272)];
    _successLayer.path = successPath.CGPath;
    
    CABasicAnimation *successAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [successAnimation setValue:kAnimationDrawSuccess forKey:@"id"];
    successAnimation.duration = _durationFinish;
    successAnimation.delegate = self;
    successAnimation.fromValue = @0;
    successAnimation.toValue = @1;
    successAnimation.removedOnCompletion = NO;
    successAnimation.fillMode = kCAFillModeForwards;
    successAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_successLayer addAnimation:successAnimation forKey:kAnimationDrawSuccess];
    
    [_progressLayer removeAllAnimations];
    [self drawCircleAnimation:_fromValue end:@1 duration:_durationFinish];
}

- (void)drawFailureAnimation {
    UIBezierPath* failurePath = [UIBezierPath bezierPath];
    CGFloat size = self.bounds.size.width;
    [failurePath moveToPoint: CGPointMake(size/3.5, size/3.5)];
    [failurePath addLineToPoint: CGPointMake(size - size/3.5, size - size/3.5)];
    
    [failurePath moveToPoint: CGPointMake(size - size/3.5, size/3.5)];
    [failurePath addLineToPoint: CGPointMake(size/3.5, size - size/3.5)];
    
    _failureLayer.path = failurePath.CGPath;
    
    CABasicAnimation *failureAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [failureAnimation setValue:kAnimationDrawFailure forKey:@"id"];
    failureAnimation.duration = _durationFinish;
    failureAnimation.delegate = self;
    failureAnimation.fromValue = @0;
    failureAnimation.toValue = @1;
    failureAnimation.removedOnCompletion = NO;
    failureAnimation.fillMode = kCAFillModeForwards;
    failureAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_failureLayer addAnimation:failureAnimation forKey:kAnimationDrawFailure];
    
    [_progressLayer removeAllAnimations];
    [self drawCircleAnimation:_fromValue end:@1 duration:_durationFinish];
}

- (void)drawCircleAnimation:(NSNumber*)from end:(NSNumber*)end duration:(CGFloat)duration {
    UIBezierPath * roundPath = [UIBezierPath bezierPath];
    CGRect rectSelf = self.bounds;
    [roundPath addArcWithCenter:CGPointMake(rectSelf.size.width / 2, rectSelf.size.height / 2) radius:CGRectGetHeight(rectSelf) / 2 startAngle:- 0.5 * M_PI endAngle:1.5 * M_PI clockwise:YES];
    _progressLayer.path = roundPath.CGPath;
    
    CABasicAnimation* headStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [headStartAnimation setValue:kAnimationDrawCircle forKey:@"id"];
    headStartAnimation.fromValue = from;
    headStartAnimation.toValue = end;
    headStartAnimation.duration = duration;
    headStartAnimation.fillMode = kCAFillModeForwards;
    headStartAnimation.removedOnCompletion = NO;
    headStartAnimation.delegate = self;
    headStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_progressLayer addAnimation:headStartAnimation forKey:kAnimationDrawCircle];
}

- (void)closeCircleAnimation {
    CABasicAnimation* headEndAnimation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    [headEndAnimation1 setValue:kAnimationClose forKey:@"id"];
    headEndAnimation1.fromValue = _fromValue;
    headEndAnimation1.toValue = _endValue;
    headEndAnimation1.duration = _duration2;
    headEndAnimation1.fillMode = kCAFillModeForwards;
    headEndAnimation1.removedOnCompletion = NO;
    headEndAnimation1.delegate = self;
    headEndAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [_progressLayer addAnimation:headEndAnimation1 forKey:kAnimationClose];
}

@end
