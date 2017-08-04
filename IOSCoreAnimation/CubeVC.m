//
//  CubeVC.m
//  IOSCoreAnimation
//
//  Created by 刘康蕤 on 2017/8/3.
//  Copyright © 2017年 刘康蕤. All rights reserved.
//

#import "CubeVC.h"
#import <GLKit/GLKit.h>

#define LIGHT_DIRECTION 0,1,-0.5
#define AMBINET_LIGHT 0.5

@interface CubeVC ()

// 容器
@property (nonatomic, strong) UIView * containerView;

// 6个面的数组
@property (nonatomic, strong) NSMutableArray * faces;

@property (nonatomic, assign) CGFloat floatX;
@property (nonatomic, assign) CGFloat floatY;

@property (nonatomic, assign) CGFloat pointX;
@property (nonatomic, assign) CGFloat pointY;

@end

@implementation CubeVC

- (void)applyLightingToFace:(CALayer *)face {

    // add lighting layer
    CALayer * layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    
    // get face normal
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    
    // get dot product with light direction
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(0, 1 , -0.5));
    float dotProduct = GLKVector3DotProduct(light, normal);
    
    // set lighting layer opacity
    CGFloat shadow = 1 + dotProduct - AMBINET_LIGHT;
    UIColor * color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
    
}

// 随机颜色
- (UIColor *)getColor {
    
    return [UIColor colorWithRed:(arc4random()%255)/255.0
                           green:(arc4random()%255)/255.0
                            blue:(arc4random()%255)/255.0
                           alpha:1];
}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform {
    
    UIView *face = self.faces[index];
    [self.containerView addSubview:face];
    
    CGSize  containerSize = self.containerView.bounds.size;
    face.center = CGPointMake(containerSize.width/2, containerSize.height/2);
    
    face.layer.transform = transform;
    
    // apply lighting
    //[self applyLightingToFace:face.layer];
    face.layer.backgroundColor = [self getColor].CGColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.containerView];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.containerView addGestureRecognizer:pan];
    
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/500.0;
    perspective = CATransform3DRotate(perspective, -45*M_PI/180, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -30*M_PI/180, 0, 1, 0);
    
    _floatX = -45;
    _floatY = -30;
    
    self.containerView.layer.sublayerTransform = perspective;
    
    // add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    
    // add cube face 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    
    // add cube face 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    
    // add cube face 4
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    
    // add cube face 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    
    // add cube face 6
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 1, 0, 0);
    [self addFace:5 withTransform:transform];
    
    
}

- (UIView *)containerView {

    if (!_containerView) {
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
        _containerView.backgroundColor = [UIColor grayColor];
    }
    return _containerView;
}

- (NSMutableArray *)faces {

    if (!_faces) {
        
        _faces = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 6; i++) {
         
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 200, 60)];
            label.text = [NSString stringWithFormat:@"%d",i+1];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:40];
            [view addSubview:label];
            
            [_faces addObject:view];
        }
    }
    return _faces;
}


- (void)panAction:(UIPanGestureRecognizer *)sender {

    if (sender.state == UIGestureRecognizerStateEnded) {
        _floatX = _floatX + _pointY;
        _floatY = _floatY + _pointX;
        
        _floatX = (CGFloat)((int)_floatX%360);
        _floatY = (CGFloat)((int)_floatY%360);
        
        if (_floatX < 0) {
            _floatX = _floatX + 360;
        }
        
        if (_floatY < 0) {
            _floatY = _floatY + 360;
        }
        
        return;
    }
    
    CGPoint point = [sender translationInView:self.containerView];
    
    NSLog(@"-----------------------");
    NSLog(@"x=%f,y=%f",point.x,point.y);
    NSLog(@"fx=%f,fy=%f",_floatX,_floatY);
    
    
    _pointX = point.x;
    _pointY = -point.y;
    
    CATransform3D transform = self.containerView.layer.transform;
    transform.m34 = -1.0/500.0;
    transform = CATransform3DRotate(transform, (_floatX+_pointY)*M_PI/180.0, 1, 0, 0);
    transform = CATransform3DRotate(transform, (_floatY+_pointX)*M_PI/180.0, 0, 1, 0);
    
    
    self.containerView.layer.sublayerTransform = transform;
    
}



@end
