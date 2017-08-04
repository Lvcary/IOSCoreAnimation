//
//  LayerVC.m
//  IOSCoreAnimation
//
//  Created by 刘康蕤 on 2017/8/3.
//  Copyright © 2017年 刘康蕤. All rights reserved.
//

#import "LayerVC.h"

@interface LayerVC ()<CALayerDelegate>

@property (nonatomic, strong)UIView * layerView;
@property (nonatomic, strong)CALayer *blueLayer;

@property (nonatomic, strong)UIView * layerView2;

// 定时器
@property (nonatomic, strong)NSTimer * timer;
// 旋转的角度
@property (nonatomic, assign)NSInteger angle;

@end

@implementation LayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    _layerView = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 200, 200)];
    _layerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_layerView];
    
    /*
    UIImage * image = [UIImage imageNamed:@"headImage.jpeg"];
    
    _layerView.layer.contents = (__bridge id)image.CGImage;
    // contentsGravity 是为了决定内容在图层的边界中怎么对齐
    _layerView.layer.contentsGravity = kCAGravityResizeAspect;
    //_layerView.layer.contentsCenter = CGRectMake(0.1, 0.1, 0.1, 0.1);
    */
     
    _blueLayer = [CALayer layer];
    _blueLayer.frame = CGRectMake(50, 50, 100, 100);
    _blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    
    _blueLayer.delegate = self;
    
    //blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layerView.layer addSublayer:_blueLayer];
    
    
    
    // 锚点 默认值是（0.5,0.5）
    _blueLayer.anchorPoint = CGPointMake(0, 0);
    
    [_blueLayer display];
    
    
    _layerView2 = [[UIView alloc] initWithFrame:CGRectMake(50, 450, 200, 200)];
    _layerView2.backgroundColor = [UIColor redColor];
    [self.view addSubview:_layerView2];
    
    UIImage * image = [UIImage imageNamed:@"headImage.jpeg"];
    
    _layerView2.layer.contents = (__bridge id)image.CGImage;
    // contentsGravity 是为了决定内容在图层的边界中怎么对齐
    _layerView2.layer.contentsGravity = kCAGravityResizeAspect;
    
    [self rotateAnimationAction];
    
}

-(void)viewDidDisappear:(BOOL)animated {

    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void) setCGAffineTransformAction {

    CGAffineTransform transform = CGAffineTransformIdentity;
    // 缩小50%
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    // 旋转45度
    transform = CGAffineTransformRotate(transform, M_PI_4);
    // 向右移动200像素
    transform = CGAffineTransformTranslate(transform, 200, 0);
    
    // 但是变换的顺序会影响最终的结果，
    
    _layerView2.layer.affineTransform = transform;
    
}

// 3D变化
- (void)caTransform3DAction {

    CATransform3D transform = CATransform3DIdentity;
    
    // CATransform3D 的m34元素用来做透视
    transform.m34 = -1.0/500.0;
//    transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    _layerView2.layer.transform = transform;
    // 如果旋转180度 会得到一个镜像图片，设置layer的doubleSided属性为NO，那么当图层正面从相机视角消失的时候，它将不会被绘制
    _layerView2.layer.doubleSided = NO;
    
}

// 旋转动画
- (void)rotateAnimationAction {

    _angle = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rotate) userInfo:nil repeats:YES];
    
}

- (void)rotate {

    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500.0;
    transform = CATransform3DRotate(transform, _angle * M_PI/180, 0, 0, 1);
    _layerView2.layer.transform = transform;
//    _layerView2.layer.doubleSided = NO;
    _angle += 1;
    
}

#pragma mark /*****  CALayerDelegate  ******/
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {

    // 画一个圆
    CGContextSetLineWidth(ctx, 5.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
    
    
}

-(void)dealloc {
    
    _blueLayer.delegate = nil;
    
}

@end
