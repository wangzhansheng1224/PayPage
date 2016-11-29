//
//  GalenPasswordView.m
//  PayView
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GalenPasswordView.h"

#define GalenInputViewNumCount 6


@interface GalenPasswordView ()

/** 数字数组 */
@property (nonatomic, strong) NSMutableArray *nums;

@end


@implementation GalenPasswordView
- (NSMutableArray *)nums
{
    if (_nums == nil) {
        _nums = [NSMutableArray array];
    }
    return _nums;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        /** 注册keyboard通知 */
        [self setupKeyboardNote];
    }
    return self;
}

#pragma mark - Private

// 删除
- (void)delete
{
    [self.nums removeLastObject];
    
    //    NSLog(@"delete nums %@ ",self.nums);
    
    [self setNeedsDisplay];
}

// 数字
- (void)number:(NSNotification *)note
{;
    NSDictionary *userInfo = note.userInfo;
    NSString *numObj = userInfo[GalenKeyboardNumberKey];
    if (numObj.length >= GalenInputViewNumCount) return;
    [self.nums addObject:numObj];
    //    NSLog(@"数字 nums %@ ",self.nums);
    [self setNeedsDisplay];
    
}



/** 注册keyboard通知 */
- (void)setupKeyboardNote
{
    // 删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete) name:GalenKeyboardDeleteButtonClick object:nil];
    
    // 数字通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(number:) name:GalenKeyboardNumberButtonClick object:nil];
}
- (void)drawRect:(CGRect)rect
{
    // 画图
    // UIImage *bg = [UIImage imageNamed:@"trade.bundle/pssword_bg"];
    UIImage *field = [UIImage imageNamed:@"trade.bundle/password_in"];
    
    //[bg drawInRect:rect];
    
    CGFloat x = 20;
    CGFloat y = 30;
    CGFloat w = CGRectGetWidth(self.frame)-40;
    CGFloat h = 45;
    [field drawInRect:CGRectMake(x, y, w, h)];
    
    // 画点
    
    CGFloat fieldWidth=w/6;
    UIImage *pointImage = [UIImage imageNamed:@"trade.bundle/yuan"];
    CGFloat pointW = CGRectGetWidth(self.frame) * 0.04;
    CGFloat pointH = pointW;
    CGFloat pointY = h/2+y-pointH/2;
    CGFloat pointX;
    
    
    for (int i = 0; i < self.nums.count; i++) {
        
        pointX = x+fieldWidth/2-pointW/2+i*fieldWidth;
        
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
        
    }
    
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
