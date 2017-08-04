//
//  ViewController.m
//  IOSCoreAnimation
//
//  Created by 刘康蕤 on 2017/2/28.
//  Copyright © 2017年 刘康蕤. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray * dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"画图-动画";
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableview.delegate = self;
    _tableview.dataSource = self;

    _dataSource = [[NSMutableArray alloc] initWithObjects:@"CAShapeLayerVC",@"CoreAnimation",@"CoreGraphics",@"Neuron",@"CoreBluetooth",@"LayerVC",@"CubeVC", nil];
}

- (void)testRunLoop {

    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverRef runloopObserver = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        switch (activity) {
            case kCFRunLoopEntry:
                
                break;
                
            default:
                break;
        }
        
    });
    CFRunLoopAddObserver(runloop, runloopObserver, kCFRunLoopDefaultMode);
    
}


#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * indefiter = @"coreAnimation";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indefiter];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indefiter];
    }
    
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    if (indexPath.row == 6) {
        cell.detailTextLabel.text = @"立方体-可拖拽";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString * vcStr = [_dataSource objectAtIndex:indexPath.row];
    
    Class class = NSClassFromString(vcStr);
    UIViewController * viewController = [[class alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}

@end
