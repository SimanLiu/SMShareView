//
//  ViewController.m
//  SMShareView
//
//  Created by Siman on 2017/8/16.
//  Copyright © 2017年 Siman. All rights reserved.
//

#import "ViewController.h"
#import "SMShareView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)shareClick {
    
    SMShareView *shareView = [[SMShareView alloc] initWithFrame:self.view.bounds];
    [shareView showShareViewWithCancel:nil finish:^(SMShareType shareType) {
        NSLog(@"-------------%ld",shareType);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
