//
//  Neuron.m
//  IOSCoreAnimation
//
//  Created by 刘康蕤 on 2017/3/23.
//  Copyright © 2017年 刘康蕤. All rights reserved.
//

#import "Neuron.h"

#define WIDTH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define pix  [[UIScreen mainScreen] bounds].size.width/750

/// 圆圈model
@interface CircleModel : NSObject

@property (nonatomic, assign)CGFloat orignX;
@property (nonatomic, assign)CGFloat orignY;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat offsetX;
@property (nonatomic, assign)CGFloat offsetY;

-(instancetype)initWithOrignX:(CGFloat)orignX
                       OrignY:(CGFloat)orignY
                        Width:(CGFloat)width
                      OffsetX:(CGFloat)offsetX
                      OffSetY:(CGFloat)offsetY;

@end

@implementation CircleModel

-(instancetype)initWithOrignX:(CGFloat)orignX
                       OrignY:(CGFloat)orignY
                        Width:(CGFloat)width
                      OffsetX:(CGFloat)offsetX
                      OffSetY:(CGFloat)offsetY{
    if (self = [super init]) {
        self.orignX = orignX;
        self.orignY = orignY;
        self.width = width;
        self.offsetX = offsetX;
        self.offsetY = offsetY;
    }
    return self;
}

@end

/// 线Model
@interface LineModel : NSObject

@property (nonatomic, assign)CGFloat beginX;
@property (nonatomic, assign)CGFloat beginY;
@property (nonatomic, assign)CGFloat alpha;
@property (nonatomic, assign)CGFloat closeX;
@property (nonatomic, assign)CGFloat closeY;

-(instancetype)initWithBeginX:(CGFloat)beginX
                       BeginY:(CGFloat)beginY
                        Alpha:(CGFloat)alpha
                       CloseX:(CGFloat)closeX
                       CloseY:(CGFloat)closeY;

@end
@implementation LineModel

-(instancetype)initWithBeginX:(CGFloat)beginX
                       BeginY:(CGFloat)beginY
                        Alpha:(CGFloat)alpha
                       CloseX:(CGFloat)closeX
                       CloseY:(CGFloat)closeY{
    if (self = [super init]) {
        
        self.beginX = beginX;
        self.beginY = beginY;
        self.alpha = alpha;
        self.closeX = closeX;
        self.closeY = closeY;
    }
    return self;
}

@end

@interface Neuron ()

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) NSMutableArray * circleArr;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) CADisplayLink * display;
@end



@implementation Neuron

static const int pointNum = 15;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"神经元动画";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    [self initDataSource];
    [self draw];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self
                                            selector:@selector(run)
                                            userInfo:nil repeats:YES];
    
//    _display = [CADisplayLink displayLinkWithTarget:self selector:@selector(run)];
//    [_display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)viewWillDisappear:(BOOL)animated {

//    [_display removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    [_display invalidate];
    
    [_timer invalidate];
    
}

//奔跑吧
- (void)run {

    [_bgView removeFromSuperview];
    _bgView = nil;
    [self.view addSubview:self.bgView];
    
    for (int i = 0; i < pointNum; i++) {
        
        CircleModel * model = _circleArr[i];
        model.orignX += model.offsetX;
        model.orignY += model.offsetY;
        
        if (model.orignX > WIDTH) {
            model.orignX = 0;
        }else if (model.orignX < 0) {
            model.orignX = WIDTH;
        }
        
        if (model.orignY > HEIGHT - 64) {
            model.orignY = 0;
        }else if (model.orignY < 0) {
            model.orignY = HEIGHT - 64;
        }
        [_circleArr replaceObjectAtIndex:i withObject:model];
        
    }
    [self draw];
}

- (void)draw {

    for (CircleModel * model in _circleArr) {
        // 绘制圆
        [self drawCircle:model];
    }
    
    for (int i = 0; i < pointNum; i ++) {
        for (int j = 0; j < pointNum; j++) {
            if (i != j) {
                
                CircleModel * model1 = _circleArr[i];
                CircleModel * model2 = _circleArr[j];
                
                CGFloat difX = fabs(model1.orignX - model2.orignX);
                CGFloat difY = fabs(model1.orignY - model2.orignY);
                CGFloat length = sqrtf(difX*difX + difY*difY);
                CGFloat alpha = 0.0;
                if (length <= WIDTH/5) {
                    alpha = 0.2;
                }
                else if (length > WIDTH/5 && length < WIDTH/3) {
                    alpha = 0.15;
                }
                else if (length > WIDTH/4 && length < WIDTH /2) {
                    alpha = 0.1;
                }else{
                    alpha = 0.0;
                }
                
                if (alpha > 0.05) {
                    LineModel * model = [[LineModel alloc] initWithBeginX:model1.orignX + model1.width/2
                                                                   BeginY:model1.orignY + model1.width/2
                                                                    Alpha:alpha
                                                                   CloseX:model2.orignX + model2.width/2
                                                                   CloseY:model2.orignY + model2.width/2];
                    // 画线
                    [self drawLine:model];
                }
            }
        }
    }
}

// 绘制圆
- (void)drawCircle:(CircleModel *)model {

    CAShapeLayer * shape = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(model.orignX, model.orignY, model.width, model.width)];
    shape.lineWidth = 4;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.strokeColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.4].CGColor;
    shape.path = path.CGPath;
    [self.bgView.layer addSublayer:shape];
}

// 绘制线
- (void)drawLine:(LineModel *)model {

    CAShapeLayer * shape = [CAShapeLayer layer];
    shape.lineWidth = 0.5;
    shape.strokeColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:model.alpha].CGColor;
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(model.beginX, model.beginY)];
    [path addLineToPoint:CGPointMake(model.closeX, model.closeY)];
    [path closePath];
    
    shape.path = path.CGPath;
    [self.bgView.layer addSublayer:shape];
    
}


// 初始化数组
- (void)initDataSource {

    _circleArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < pointNum; i++) {
     
        CircleModel * model = [[CircleModel alloc] initWithOrignX:[self randmBetweenSmall:0 andLager:WIDTH]
                                                           OrignY:[self randmBetweenSmall:0 andLager:HEIGHT - 64]
                                                            Width:[self randmBetweenSmall:1 andLager:8]
                                                          OffsetX:[self randmBetweenSmall:-10 andLager:10]/20.0
                                                          OffSetY:[self randmBetweenSmall:-10 andLager:10]/20.0];
        [_circleArr addObject:model];
        
    }
}

// 随机返回区间内的值
- (CGFloat)randmBetweenSmall:(CGFloat)small andLager:(CGFloat)lager {

    CGFloat precison = 100.0;
    
    CGFloat difference = fabs(lager - small) * precison + 1;
    
    CGFloat randomNum = arc4random_uniform(difference);
    
    randomNum /= precison;
    
    return MIN(small, lager) + randomNum;
}

- (UIView *)bgView {

    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
    }
    return _bgView;
}

@end
