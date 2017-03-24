//
//  CoreGraphicsCustomView.m
//  IOSCoreAnimation
//
//  Created by 刘康蕤 on 2017/3/21.
//  Copyright © 2017年 刘康蕤. All rights reserved.
//

#import "CoreGraphicsCustomView.h"

@implementation CoreGraphicsCustomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef  ref = UIGraphicsGetCurrentContext();
    
    // 下面的方法如果调换顺序，呈现的效果可能有差异
    [self drawLineWithRef:ref];
    [self drawRoundWithFillColorAndRef:ref];
    [self drawRoundWithRef:ref];
    [self drawtriangleWithRef:ref];
    [self drawOtherViewWithRef:ref];
}

// 画直线
- (void)drawLineWithRef:(CGContextRef)ref {
    
    CGContextMoveToPoint(ref, 10, 10);
    CGContextAddLineToPoint(ref, 10, 30);
    CGContextSetLineWidth(ref, 2);
    [[UIColor redColor] set];
    
    // 渲染
    CGContextStrokePath(ref);
    
    
    // 设置虚线
    CGContextMoveToPoint(ref, 20, 15);
    CGContextAddLineToPoint(ref, 100, 15);
    CGFloat arr[] = {3,1};
    CGContextSetLineDash(ref, 0, arr, 2);
    CGContextStrokePath(ref);
    
    // 将虚线再设置成实线
    CGContextSetLineDash(ref, 0, NULL, 0);
}

// 画圆
- (void)drawRoundWithRef:(CGContextRef)ref {

    // 圆
    CGContextAddArc(ref, 30, 60, 20, 0, M_PI * 2, 0);
    // 渲染
    CGContextStrokePath(ref);
    
    
    // 扇形
    //圆心
    CGContextMoveToPoint(ref, 140, 60);
    //此处的（140，60）是来确定圆的位置的，可以把140改成150 测试下
    CGContextAddArc(ref, 140, 60, 30, 0, M_PI/2, 0);
    CGContextClosePath(ref);
    //渲染
    CGContextDrawPath(ref, kCGPathFillStroke);
    
    
    // 椭圆
    CGContextAddEllipseInRect(ref, CGRectMake(210, 30, 80, 60));
    CGContextDrawPath(ref, kCGPathFillStroke);
}

// 画圆 填充颜色
- (void)drawRoundWithFillColorAndRef:(CGContextRef)ref {

    CGContextSetFillColorWithColor(ref, [UIColor purpleColor].CGColor);
    CGContextSetStrokeColorWithColor(ref, [UIColor orangeColor].CGColor);
    CGContextAddArc(ref, 80, 60, 20, 0, 2 * M_PI, 0);
    CGContextSetLineWidth(ref, 3);
    
    // 此方法只是画填充的颜色
//    CGContextFillPath(ref);
    
//    CGContextStrokePath(ref);
    
    // 渲染
    CGContextDrawPath(ref, kCGPathFillStroke);
}

// 画三角形
- (void)drawtriangleWithRef:(CGContextRef)ref {

    // 方法一
    CGContextMoveToPoint(ref, 20, 90);
    CGContextAddLineToPoint(ref, 5, 110);
    CGContextAddLineToPoint(ref, 35, 110);
    CGContextAddLineToPoint(ref, 20, 90);
    
    // 渲染
    CGContextStrokePath(ref);
    
    
    //方法二
    CGPoint points[3];
    points[0] = CGPointMake(60, 90);
    points[1] = CGPointMake(45, 110);
    points[2] = CGPointMake(75, 110);
    CGContextAddLines(ref, points, 3);
    CGContextClosePath(ref);
    // 渲染
    CGContextStrokePath(ref);
    
}


- (void)drawOtherViewWithRef:(CGContextRef)ref {

    /**  曲线  */
    // 起点p1
    CGContextMoveToPoint(ref, 10, 130);
    
    /** 由（x1，x2）组成的点p2，由（y1，y2）组成的点为曲线终点p3 。由p2p1,p2p3组成两条射线，该曲线同时内切与这2条射线，再根据randius（曲线的半径的长度）确定这条曲线。
     CGContextAddArcToPoint(<#CGContextRef  _Nullable c#>, <#CGFloat x1#>, <#CGFloat y1#>, <#CGFloat x2#>, <#CGFloat y2#>, <#CGFloat radius#>)
     */
    CGContextAddArcToPoint(ref, 10, 150, 30, 150, 20);
    
    CGContextStrokePath(ref);
    
    /** 渐变颜色 */
    // 方法一
    CAGradientLayer * gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(10, 160, 80, 60);
    gradient1.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,
                        (id)[UIColor grayColor].CGColor,
                        (id)[UIColor blackColor].CGColor,
                        (id)[UIColor yellowColor].CGColor,
                        (id)[UIColor blueColor].CGColor,
                        (id)[UIColor redColor].CGColor,
                        (id)[UIColor greenColor].CGColor,
                        (id)[UIColor orangeColor].CGColor,
                        (id)[UIColor brownColor].CGColor,nil];
    [self.layer insertSublayer:gradient1 atIndex:0];
    
    
    
    // 方法二
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        1.00,1.00,1.00, 1.00,
        1.00,1.00,0, 1.00,
        1.00,0,0, 1.00,
        1.00,0,1.00, 1.00,
        0,1.00,1.00, 1.00,
        0,1.00,0, 1.00,
        0,0,1.00, 1.00,
        0,0,0, 1.00,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0]) * 4));
    CGColorSpaceRelease(rgb);
    
    
    //画线形成一个矩形
    //CGContextSaveGState与CGContextRestoreGState的作用
    /*
     CGContextSaveGState函数的作用是将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的描画操作，但不影响存储在堆栈中的拷贝。在修改完成后，您可以通过CGContextRestoreGState函数把堆栈顶部的状态弹出，返回到之前的图形状态。这种推入和弹出的方式是回到之前图形状态的快速方法，避免逐个撤消所有的状态修改；这也是将某些状态（比如裁剪路径）恢复到原有设置的唯一方式。
     */
    CGContextSaveGState(ref);
    CGContextMoveToPoint(ref, 10, 230);
    CGContextAddLineToPoint(ref, 50, 230);
    CGContextAddLineToPoint(ref, 50, 270);
    CGContextAddLineToPoint(ref, 10, 270);
    CGContextClip(ref);//context裁剪路径,后续操作的路径
    CGContextDrawLinearGradient(ref, gradient, CGPointMake(10, 230), CGPointMake(50, 270), kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(ref);
    
    // 颜色渐变的圆
    CGContextDrawRadialGradient(ref, gradient, CGPointMake(150, 230), 0, CGPointMake(150, 230), 40, kCGGradientDrawsBeforeStartLocation);
    
    // 贝塞尔曲线
    // 二阶曲线，一个控制点
    CGContextMoveToPoint(ref, 10, 300);
    CGContextAddQuadCurveToPoint(ref, 20, 340, 100, 300);  // 控制点和终点
    CGContextStrokePath(ref);
    
    //三阶曲线，二个控制点
    CGContextMoveToPoint(ref, 130, 300);
    CGContextAddCurveToPoint(ref, 140, 340, 170, 340, 220, 300);  // 两个控制点和终点
    CGContextSetLineWidth(ref, 1);
    [[UIColor redColor] set];
    CGContextStrokePath(ref);
    
}


@end
