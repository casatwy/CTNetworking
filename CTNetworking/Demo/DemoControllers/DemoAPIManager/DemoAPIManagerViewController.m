//
//  DemoAPIManagerViewController.m
//  CTNetworking
//
//  Created by casa on 2018/2/28.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "DemoAPIManagerViewController.h"
#import "CTNetworking.h"
#import "DemoAPIManager.h"
#import <HandyFrame/UIView+LayoutMethods.h>

@interface DemoAPIManagerViewController ()<CTAPIManagerCallBackDelegate>

@property (nonatomic, strong) UIButton *startRequestButton;
@property (nonatomic, strong) DemoAPIManager *demoAPIManager;

@end

@implementation DemoAPIManagerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.startRequestButton];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.startRequestButton sizeToFit];
    [self.startRequestButton centerEqualToView:self.view];
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    NSLog(@"%@", [manager fetchDataWithReformer:nil]);
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    NSLog(@"%@", [manager fetchDataWithReformer:nil]);
}

#pragma mark - event response
- (void)didTappedStartButton:(UIButton *)startButton
{
    [self.demoAPIManager loadData];
}

#pragma mark - getters and setters
- (DemoAPIManager *)demoAPIManager
{
    if (_demoAPIManager == nil) {
        _demoAPIManager = [[DemoAPIManager alloc] init];
        _demoAPIManager.delegate = self;
    }
    return _demoAPIManager;
}

- (UIButton *)startRequestButton
{
    if (_startRequestButton == nil) {
        _startRequestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startRequestButton setTitle:@"send request" forState:UIControlStateNormal];
        [_startRequestButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_startRequestButton addTarget:self action:@selector(didTappedStartButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startRequestButton;
}

@end
