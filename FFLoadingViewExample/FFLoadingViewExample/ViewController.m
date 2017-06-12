//
//  ViewController.m
//  FFLoadingViewExample
//
//  Created by fang on 2017/6/12.
//  Copyright © 2017年 organization. All rights reserved.
//

#import "ViewController.h"

#import "FFLoadingView.h"

@interface ViewController ()

@property (strong, nonatomic) FFLoadingView *loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* btnStart = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, 100, 200, 40)];
    [btnStart setTitle:@"start loading" forState:UIControlStateNormal];
    [btnStart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(startLoading:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStart];
    
    UIButton* btnSuc = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, 160, 200, 40)];
    [btnSuc setTitle:@"Success" forState:UIControlStateNormal];
    [btnSuc setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSuc addTarget:self action:@selector(finishSucceed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSuc];
    
    UIButton* btnFail = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, 220, 200, 40)];
    [btnFail setTitle:@"Failure" forState:UIControlStateNormal];
    [btnFail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnFail addTarget:self action:@selector(finishFailed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFail];
    
    self.loadingView = [[FFLoadingView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 300, 100, 100)];
    self.loadingView.lineWidth = 4;
    self.loadingView.strokeColor = [UIColor blueColor];
    [self.view addSubview:self.loadingView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)startLoading:(id)sender {
    [self.loadingView startLoading];
}

- (void)finishSucceed:(id)sender {
    [self.loadingView finishSuccess:nil];
}

- (void)finishFailed:(id)sender {
    [self.loadingView finishFailure:nil];
}

@end
