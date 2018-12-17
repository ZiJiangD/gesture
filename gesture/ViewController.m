//
//  ViewController.m
//  gesture
//
//  Created by 董子江 on 2018/12/12.
//  Copyright © 2018 nightowl. All rights reserved.
//

#import "ViewController.h"
#import "DJGestureViewUnLock.h"
#import "DJGestureIndicatorView.h"

@interface ViewController ()<DJGestureViewUnLockDelegate>
{
    DJGestureViewUnLock *gv;
    DJGestureIndicatorView *iv;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    iv = [[DJGestureIndicatorView alloc]initWithFrame:CGRectMake(0, 20, 60, 60)];
//    iv.backgroundColor = [UIColor redColor];
    iv.center=CGPointMake(self.view.center.x, iv.center.y);
    [self.view addSubview:iv];
    
    gv=[[DJGestureViewUnLock alloc]initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.width-40)];
    gv.backgroundColor = [UIColor lightGrayColor];
    gv.delegate = self;
    [self.view addSubview:gv];
    
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(100, [UIScreen mainScreen].bounds.size.height-60, 80, 60);
    btn.backgroundColor= [UIColor orangeColor];
    [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}
-(void)onClick:(UIButton *)sender{
    [gv reload];
    [iv reload];
}


- (void)DJGestureViewUnLockFinish:(nonnull NSString *)selectStr {
    
    NSLog(@"%@",selectStr);
    [iv setSelectView:selectStr];
}


@end
