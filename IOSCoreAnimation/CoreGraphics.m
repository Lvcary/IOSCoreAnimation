//
//  CoreGraphics.m
//  IOSCoreAnimation
//
//  Created by 刘康蕤 on 2017/3/21.
//  Copyright © 2017年 刘康蕤. All rights reserved.
//

#import "CoreGraphics.h"
#import "CoreGraphicsCustomView.h"
@interface CoreGraphics ()

@property (nonatomic , strong) CoreGraphicsCustomView * customeView;

@end

@implementation CoreGraphics

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CoreGraphicsCustomView * view = [[CoreGraphicsCustomView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    self.customeView = view;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
