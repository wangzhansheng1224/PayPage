//
//  ViewController.m
//  PayPassword
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 apple. All rights reserved.
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
    [payPassword setFinish:^(NSString * pwd) {
      
        [blockPay showProgressView:@"正在处理..."];
        
        [blockPay performSelector:@selector(showSuccess:) withObject:self afterDelay:3.0];
        
        
        
    }];
    
    
    [payPassword setLessPassword:^{
    
        
        NSLog(@"忘记密码？");
    }];
    
    
}



@end
