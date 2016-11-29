//
//  ViewController.m
//  PayPassword
//
//  Created by 王战胜 on 16/11/21.
//  Copyright © 2016年 王战胜. All rights reserved.
//

#import "ViewController.h"
#import "GalenPayPasswordView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickTouchup:(id)sender {
    
    GalenPayPasswordView *payPassword=[GalenPayPasswordView tradeView];
    [payPassword showInView:self.view.window];
    
    __block typeof(GalenPayPasswordView *) blockPay=payPassword;
    //完成时回调
    [payPassword setFinish:^(NSString * pwd) {
      
        [blockPay showProgressView:@"正在处理..."];
        
        [blockPay performSelector:@selector(showSuccess:) withObject:self afterDelay:3.0];
        
        NSLog(@"密码是%@",pwd);
    }];
    
    //页面销毁回调
    [payPassword setDestroy:^{
        [blockPay removeFromSuperview];
        blockPay = nil;
    }];
    
    //忘记密码回调
    [payPassword setLessPassword:^{
        NSLog(@"忘记密码？");
    }];
    
    
}



@end
