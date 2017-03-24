//
//  CAShapeLayerVC.m
//  IOSCoreAnimation
//
//  Created by 刘康蕤 on 2017/2/28.
//  Copyright © 2017年 刘康蕤. All rights reserved.
//

#import "CAShapeLayerVC.h"

@interface CAShapeLayerVC ()

@end

@implementation CAShapeLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CAShapeLayer";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test1];
    [self test2];
    [self test3];
    [self test4];
    [self test5];
    [self test6];
}

/** 设置部分圆角 */
- (void)test1 {
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 70, 70)];
    view1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view1];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = view1.bounds;
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:view1.bounds
                                                      byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                            cornerRadii:CGSizeMake(10, 10)];
    shapeLayer.path = bezierPath.CGPath;
    view1.layer.mask = shapeLayer;
    
}

- (void)test2 {

    CAShapeLayer *layer = [CAShapeLayer layer];
    // 填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    // 绘制颜色
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.lineWidth = 4;
    
    // 起始位置和重点位置
    layer.strokeStart = 0;
    layer.strokeEnd = 0.8;
    
    layer.path = [self circlePath].CGPath;
    [self.view.layer addSublayer:layer];
}

- (void)test3 {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    // 填充颜色
    layer.fillColor = [UIColor orangeColor].CGColor;
    // 绘制颜色
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.lineWidth = 4;
    
    layer.path = [self circlePath1].CGPath;
    [self.view.layer addSublayer:layer];
}

- (void)test4 {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    // 填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    // 绘制颜色
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.lineWidth = 4;
    
    layer.path = [self circlePath2].CGPath;
    [self.view.layer addSublayer:layer];
}

#pragma mark - 设置虚线
- (void)test5 {
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 300, 100, 5)];
    [self.view addSubview:lineView];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[UIColor blackColor].CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:3], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [lineView.layer addSublayer:shapeLayer];
}

- (void)test6 {

    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [self circlPath3].CGPath;
    
    shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 1;
    
    [self.view.layer addSublayer:shapeLayer];
    
    CAShapeLayer * lineShapelayer = [CAShapeLayer layer];
    lineShapelayer.path = [self circlPath4].CGPath;
    
    lineShapelayer.strokeColor = [UIColor blackColor].CGColor;
    lineShapelayer.fillColor = [UIColor clearColor].CGColor;
    lineShapelayer.lineWidth = 1;
    [self.view.layer addSublayer:lineShapelayer];
}

/** 矩形 */
- (UIBezierPath *)circlePath {

    return [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100, 80, 70, 70) cornerRadius:10];
}

/** 圆形 */
- (UIBezierPath *)circlePath1 {

    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 160, 90, 90)];
}

/** 圆弧 */
- (UIBezierPath *)circlePath2 {

    // Yes为顺时针  No为逆时针
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 200) radius:50 startAngle:0 endAngle:M_PI_2 clockwise:YES];
}

- (UIBezierPath *)circlPath3 {

    UIBezierPath * bPath = [UIBezierPath bezierPath];
    
    [bPath moveToPoint:CGPointMake(180, 330)];
//    [bPath addLineToPoint:CGPointMake(10, 380)];
    
    // 一个控制点
//    [bPath addQuadCurveToPoint:CGPointMake(10, 330) controlPoint:CGPointMake(30, 400)];
    // 2个控制点
    [bPath addCurveToPoint:CGPointMake(10, 330) controlPoint1:CGPointMake(30, 400) controlPoint2:CGPointMake(80, 400)];
    
    
    return bPath;
}

- (UIBezierPath *)circlPath4 {

    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(180, 330)];
    [path addLineToPoint:CGPointMake(80, 400)];
    [path addLineToPoint:CGPointMake(30, 400)];
    [path addLineToPoint:CGPointMake(10, 330)];
    
    return path;
}


@end
