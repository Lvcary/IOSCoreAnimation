//
//  CoreBluetooth.m
//  IOSCoreAnimation
//
//  Created by 刘康蕤 on 2017/4/5.
//  Copyright © 2017年 刘康蕤. All rights reserved.
//

#import "CoreBluetooth.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface CoreBluetooth ()<CBCentralManagerDelegate>

@property (nonatomic, strong)CBCentralManager * centralManager;

@end

@implementation CoreBluetooth

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"蓝牙技术";
    
    // 初始化蓝天中心管理者
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                           queue:nil];
    // 开始扫描
    [self beginScanning];
    
    UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 80, 80)];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [UIColor purpleColor].CGColor;
    [self.view addSubview:view];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 80, 30)];
    label.text = @"设置圆角";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    
    [self.view addSubview:label];
    
    
    
}

// 开始扫描
- (void)beginScanning {
    
    NSDictionary * options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
    [_centralManager scanForPeripheralsWithServices:nil options:options];
}

// 停止扫描
- (void)stopScanning {

    [_centralManager stopScan];
}

#pragma mark - 代理 -
// 蓝牙状态  蓝牙只有在开启状态时才可以使用
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"状态不知");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"蓝牙已开");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"蓝牙已关");
            break;
        case CBManagerStateResetting:
            NSLog(@"蓝牙信号短暂丢失，立马搜索");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"不支持蓝牙");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"蓝牙未授权");
            break;
            
        default:
            break;
    }
    
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    
    NSLog(@"dict = %@",dict);
}


// 连接外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {

//    NSLog(@"data = %@",advertisementData);
//    if ([peripheral.name isEqualToString:]) {
//        
//    }
    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{

}

@end
