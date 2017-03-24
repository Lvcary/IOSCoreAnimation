//
//  CoreAnimation.m
//  IOSCoreAnimation
//
//  Created by 刘康蕤 on 2017/3/1.
//  Copyright © 2017年 刘康蕤. All rights reserved.
//

#import "CoreAnimation.h"

@interface CoreAnimation ()<CAAnimationDelegate>

/** 动画view */
@property (nonatomic, strong) UIView * animationView;

/** 动画layer*/
@property (nonatomic, strong) CALayer * animationLayer;

/** 帧动画layer*/
@property (nonatomic, strong) CALayer * keyLayer;

@property (nonatomic, strong) CADisplayLink * displayLink;

@end

@implementation CoreAnimation

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CoreAnimation";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _animationView = ({
    
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(20, 80, 60, 60)];
        view.backgroundColor = [UIColor orangeColor];
        view;
    });
    
    [self animation1];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_displayLink invalidate];
}

- (void)animation1 {

    _animationLayer = [CALayer layer];
    _animationLayer.frame = CGRectMake(20, 80, 60, 60);
    _animationLayer.backgroundColor = [UIColor orangeColor].CGColor;
    
    [self.view.layer addSublayer:_animationLayer];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    [CATransaction setCompletionBlock:^{
       
        CGAffineTransform transform = self.animationLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_4);
        self.animationLayer.affineTransform = transform;
        
    }];
    
    self.animationLayer.position = point;
    
    [CATransaction commit];
    
    [self animation2];
    [self animation3];
}

- (void)animation2 {

    CAKeyframeAnimation * keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(30, 190)];
    [bezierPath addCurveToPoint:CGPointMake(30, 300) controlPoint1:CGPointMake(80, 230) controlPoint2:CGPointMake(180, 300)];
    keyAnimation.path = bezierPath.CGPath;
    keyAnimation.duration = 2;
    keyAnimation.delegate = self;
    
    
    self.keyLayer.frame = CGRectMake(20, 180, 20, 20);
    [self.keyLayer addAnimation:keyAnimation forKey:@"positionAnimation"];
}

- (CALayer *)keyLayer {
    
    if (!_keyLayer) {
        _keyLayer = [CALayer layer];
        _keyLayer.backgroundColor = [UIColor purpleColor].CGColor;
        [self.view.layer addSublayer:_keyLayer];
    }
    return _keyLayer;
}


#pragma mark animationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    //开启事务
    [CATransaction begin];
//    禁用隐式动画
    [CATransaction setDisableActions:YES];
    
    self.keyLayer.position = CGPointMake(30, 300);
    
//    提交事务
    [CATransaction commit];
}



- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        
    }
    return _displayLink;
}

- (void)animation3 {
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}



- (void)displayLinkAction {

    static int i = 0;
    NSLog(@"i = %d",i);
    i++;
    if (i == 100) {
        [_displayLink invalidate];
        i = 0;
    }
}


@end
