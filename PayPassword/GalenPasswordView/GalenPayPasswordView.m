//
//  GalenPayPasswordView.m
//  PayView
//
//  Created by 王战胜 on 16/11/20.
//  Copyright © 2016年 王战胜. All rights reserved.
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
@property ( nonatomic, strong ) NSString            *tempStr;             /** 输入的密码 */



@end



@implementation GalenPayPasswordView

/** 快速创建 */
+ (instancetype)tradeView
{
    return [[self alloc] init];
}

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
    //取消按钮
    self.cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.cancelBtn setImage:[UIImage imageNamed:@"trade.bundle/zhifu-close"] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelClickTouchup) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.coverView addSubview:self.cancelBtn];
    
    //标题
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 0, CGRectGetWidth(self.frame)-110, 40)];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.font=[UIFont systemFontOfSize:18];
    self.titleLabel.textColor=[UIColor darkGrayColor];
    [self.coverView addSubview:self.titleLabel];
    self.titleLabel.text=@"请输入支付密码";
    
    //标题下方横线
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.frame), 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    lineView.alpha=0.3;
    [self.coverView addSubview:lineView];
    
    //输入框视图
    GalenPasswordView *input=[[GalenPasswordView alloc]initWithFrame:CGRectMake(0, 41, CGRectGetWidth(self.frame), 80)];
    [self.coverView addSubview:input];
    self.inPutView = input;
    
    //完成视图
    self.progressView = [[GalneProgressView alloc] init];
    self.progressView.center=CGPointMake(CGRectGetWidth(self.coverView.frame)/2,120);
    self.progressView.hidden=YES;
    [self.coverView addSubview:self.progressView];
    
    
}


-(void)cancelClickTouchup
{
    [self hidenKeyboard:^(BOOL finished) {
        if (self.destroy) {
            self.destroy();
        }
        
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
    noPWD.alpha=0.8;
    [noPWD setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [noPWD setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [self.coverView addSubview:noPWD];
    
    self.lessPwdBtn=noPWD;
    [self.lessPwdBtn addTarget:self action:@selector(lessBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark -- 忘记密码点击事件
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
#pragma mark -- 键盘你被点击的回调
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (!_tempStr) {
        _tempStr = string;
    }else{
        _tempStr = [NSString stringWithFormat:@"%@%@",_tempStr,string];
    }
    
    if ([string isEqualToString:@""]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GalenKeyboardDeleteButtonClick object:nil];
        
        _tempStr = [_tempStr substringToIndex:[_tempStr length] - 1];
        
//       NSLog(@" 点击了删除键 ---%@",_tempStr);
    }else{
        
        if (_tempStr.length == 6) {
        
            [self intputFinish];
        }
        
        NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
        userInfoDict[GalenKeyboardNumberKey] = string;
        [[NSNotificationCenter defaultCenter] postNotificationName:GalenKeyboardNumberButtonClick object:nil userInfo:userInfoDict];
        
    }
    return YES;
}


-(void)intputFinish
{
    if (self.finish) {
        self.finish(_tempStr);
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
        self.lessPwdBtn.hidden=YES;
        self.cancelBtn.hidden=YES;
        [self.responsder endEditing:NO];
        self.progressView.hidden=NO;
        
        self.titleLabel.text=@"交易处理中...";
        
    } completion:^(BOOL finished) {
        
        __weak typeof(self) weakSelf=self;
    
        [self.progressView showProgressView:infoStr stopAnimation:^(BOOL isFinish) {
            
            [weakSelf cancelClickTouchup];
        }];

        
    }];
    
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
        
    } completion:nil];
    
}


/** 键盘退下 */
- (void)hidenKeyboard:(void (^)(BOOL finished))completion
{
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.coverView.transform = CGAffineTransformMakeTranslation(0,GalenCoverViewHeight);
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
