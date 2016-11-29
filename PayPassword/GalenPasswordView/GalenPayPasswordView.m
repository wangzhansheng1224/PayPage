//
//  GalenPayPasswordView.m
//  PayView
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GalenPayPasswordView.h"

#define GalenCoverViewHeight 450


@interface GalenPayPasswordView ()<UITextFieldDelegate>

@property ( nonatomic ,strong ) UIView              *coverView;           /** 底层视图 */
@property ( nonatomic ,strong ) UIButton            *cancelBtn;           /** 取消按钮 */
@property ( nonatomic ,strong ) UIButton            *lessPwdBtn;          /** 忘记密码按钮 */
@property ( nonatomic ,strong ) UILabel             *titleLabel;          /** 标题 */
@property ( nonatomic ,strong ) GalenPasswordView   *inPutView;           /** 输入密码 */
@property ( nonatomic, strong ) UITextField         *responsder;          /** 响应者 */



@end



@implementation GalenPayPasswordView

-(id)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        self.alpha=0;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        /** 蒙板 */
        [self setupCover];
        /** 输入框 */
        [self setupInputView];
        /** 响应者 */
        [self setupResponsder];
        /** 忘记密码按钮 */
        [self lessPwdBtnView];
    }
    return self;
    
}

-(void)setupCover
{
    
    self.coverView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.frame),CGRectGetWidth(self.frame), GalenCoverViewHeight)];
    self.coverView.backgroundColor=[UIColor whiteColor];
    
    [self addSubview:self.coverView];
    
}

-(void)setupInputView
{
    self.cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];

    [self.cancelBtn setImage:[UIImage imageNamed:@"trade.bundle/back_arrow_orange"] forState:UIControlStateNormal];
    
    [self.cancelBtn addTarget:self action:@selector(cancelClickTouchup) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self.coverView addSubview:self.cancelBtn];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 0, CGRectGetWidth(self.frame)-110, 40)];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.font=[UIFont systemFontOfSize:16];
    self.titleLabel.textColor=[UIColor darkGrayColor];
    [self.coverView addSubview:self.titleLabel];
    self.titleLabel.text=@"请输入支付密码";
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.frame), 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    lineView.alpha=0.3;
    [self.coverView addSubview:lineView];
    
    
    GalenPasswordView *input=[[GalenPasswordView alloc]initWithFrame:CGRectMake(0, 41, CGRectGetWidth(self.frame), 80)];
    
    [self.coverView addSubview:input];
    self.inPutView = input;
    
    self.progressView = [[GalneProgressView alloc] init];
    self.progressView.center=CGPointMake(CGRectGetWidth(self.coverView.frame)/2,120);
    self.progressView.hidden=YES;
    [self.coverView addSubview:self.progressView];
    
    
}


-(void)cancelClickTouchup
{
    [self hidenKeyboard:^(BOOL finished) {
        
        [self.inPutView setNeedsDisplay];
          [self hidenKeyboard:nil];
        [self removeFromSuperview];
      
        
    }];
}

-(void)setupResponsder
{
    UITextField *responsder = [[UITextField alloc] init];
    responsder.delegate = self;
    responsder.keyboardType = UIKeyboardTypeNumberPad;
    
    [self addSubview:responsder];
    self.responsder = responsder;
}

-(void)lessPwdBtnView
{
    UIButton *noPWD=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.inPutView.frame)-90, CGRectGetMaxY(self.inPutView.frame)+15, 70, 40)];
    noPWD.titleLabel.font=[UIFont systemFontOfSize:14];
    
    [noPWD setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    
    [self.coverView addSubview:noPWD];
    [noPWD setTitle:@"忘记密码" forState:UIControlStateNormal];
    self.lessPwdBtn=noPWD;
//    self.lessPwdBtn.tag=ZCTradeInputViewButtonTypeWithNoPwd;
    
    [self.lessPwdBtn addTarget:self action:@selector(lessBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma  mark  ************************ 选择无密码支付 **************************

-(void)lessBtnClick:(UIButton *)btn
{
 if (self.lessPassword)
 {
     self.lessPassword();
     
 }
    
}

/**
 *  处理字符串 和 删除键
 */
static NSString *tempStr;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (!tempStr) {
        tempStr = string;
    }else{
        tempStr = [NSString stringWithFormat:@"%@%@",tempStr,string];
    }
    
    if ([string isEqualToString:@""]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GalenKeyboardDeleteButtonClick object:self];
        
        if (tempStr.length > 0) {   //  删除最后一个字符串
            NSString *cccc = [tempStr substringToIndex:[tempStr length] - 1];
            tempStr = cccc;
        }
        
        //         NSLog(@" 点击了删除键 ---%@",tempStr);
    }else{
        
        if (tempStr.length == 6) {
            
            //
            [self intputFinish];
            
            
        }
        
        
        NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
        userInfoDict[GalenKeyboardNumberKey] = string;
        [[NSNotificationCenter defaultCenter] postNotificationName:GalenKeyboardNumberButtonClick object:self userInfo:userInfoDict];
    }
    return YES;
}


-(void)intputFinish
{
    if (self.finish) {
        
        self.finish(tempStr);
        tempStr = nil;
  
        self.lessPwdBtn.hidden=YES;
    }
    
    
}

-(void)showSuccess:(NSString *)infoStr
{

    [self.progressView showSuccess:infoStr];
    
    
}

-(void)showProgressView:(NSString *)infoStr
{
    
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.inPutView.hidden=YES;
        self.progressView.hidden=NO;
        [self.responsder endEditing:NO];
        
    } completion:^(BOOL finished) {
        
        __weak typeof(self) weakSelf=self;
        
        [self.progressView showProgressView:infoStr stopAnimation:^(BOOL isFinish) {
            
            [weakSelf cancelClickTouchup];
        }];

        
    }];
    
}

-(void)hiddenPayPasswordView
{
//    [self hidenKeyboard:nil];
//    [self removeFromSuperview];
//   [self cancelClickTouchup];
    [self performSelectorOnMainThread:@selector(cancelClickTouchup) withObject:self waitUntilDone:NO];
    
    
}




/** 快速创建 */
+ (instancetype)tradeView
{
    return [[self alloc] init];
}


-(void)showInView:(UIView *)view
{
    GalenPayPasswordView *payView=self;
    
    // 浮现
    [view addSubview:payView];
    /** 弹出键盘 */
    [self showKeyboard];
    
    
}


/** 键盘弹出 */
-(void)showKeyboard
{
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.coverView.transform = CGAffineTransformMakeTranslation(0,-GalenCoverViewHeight);
        self.alpha++;
        
        [self.responsder becomeFirstResponder];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
    
}



/** 键盘退下 */
- (void)hidenKeyboard:(void (^)(BOOL finished))completion
{
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.coverView.transform = CGAffineTransformMakeTranslation(0,0);
        self.alpha--;
        [self.responsder endEditing:NO];
        
    } completion:completion];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc---");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.responsder && ![self.responsder isFirstResponder]) {
        // [self.responsder becomeFirstResponder];
    }
}

@end
