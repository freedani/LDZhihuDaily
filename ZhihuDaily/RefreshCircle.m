//
//  RefreshCircle.m
//  ZhihuDaily
//
//  Created by 李达 on 2017/2/24.
//  Copyright © 2017年 李达. All rights reserved.
//

#import "RefreshCircle.h"

@interface RefreshCircle ()

@property (nonatomic, strong) UIView *backgroundCircleView;
@property (nonatomic, strong) UIView *foregroundCircleView;
@property (nonatomic, strong) CAShapeLayer *foregroundShapeLayer;

@end

@implementation RefreshCircle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIView *backgroundCircleView = [UIView new];
    _backgroundCircleView = backgroundCircleView;
    UIView *foregroundCircleView = [UIView new];
    _foregroundCircleView = foregroundCircleView;
    
    [backgroundCircleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [foregroundCircleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:backgroundCircleView];
    [self addSubview:foregroundCircleView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backgroundCircleView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundCircleView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backgroundCircleView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundCircleView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[foregroundCircleView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(foregroundCircleView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[foregroundCircleView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(foregroundCircleView)]];
    
    CAShapeLayer *backgroundShapeLayer = [CAShapeLayer layer];
    backgroundShapeLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    backgroundShapeLayer.lineWidth = 1.5;
    backgroundShapeLayer.fillColor = nil;
    UIBezierPath *backgroundPath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 10) radius:10 startAngle:M_PI_2 endAngle:M_PI_2 + 2 * M_PI clockwise:YES];
    backgroundShapeLayer.path = backgroundPath.CGPath;
    [backgroundCircleView.layer addSublayer:backgroundShapeLayer];
    backgroundCircleView.hidden = YES;
    
    CAShapeLayer *foregroundShapeLayer = [CAShapeLayer layer];
    _foregroundShapeLayer = foregroundShapeLayer;
    foregroundShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    foregroundShapeLayer.lineWidth = 1.5;
    foregroundShapeLayer.fillColor = nil;
    UIBezierPath *foregroundPath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 10) radius:10 startAngle:M_PI_2 endAngle:M_PI_2 clockwise:YES];
    foregroundShapeLayer.path = foregroundPath.CGPath;
    [foregroundCircleView.layer addSublayer:foregroundShapeLayer];
    backgroundCircleView.hidden = YES;
    
}

- (void)setForegroundCircleViewWithProgress:(CGFloat)progress {
    _backgroundCircleView.hidden = NO;
    _foregroundCircleView.hidden = NO;
    UIBezierPath *foregroundPath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 10) radius:10 startAngle:M_PI_2 endAngle:M_PI_2 + progress * 2 * M_PI clockwise:YES];
    _foregroundShapeLayer.path = foregroundPath.CGPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
