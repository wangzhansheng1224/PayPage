//
//  GalneProgressView.m
//  PayView
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GalneProgressView.h"

static const CFTimeInterval DURATION = 2;

@interface GalneProgressView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;/**< 圆圈*/
@property (nonatomic, strong) CAShapeLayer *shapeLayerGou;//对勾图层
@property (nonatomic, strong) CATextLayer *textL;/**< 文字图层*/
@property (nonatomic, strong) CAShapeLayer *arcLayer;

@property (strong, nonatomic) CABasicAnimation *rotateAnimation;
@property (strong, nonatomic) CABasicAnimation *strokeAnimatinStart;
@property (strong, nonatomic) CABasicAnimation *strokeAnimatinEnd;
@property (strong, nonatomic) CAAnimationGroup *animationGroup;
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) CGFloat view_w;
@property (assign, nonatomic) CGPoint centers;

@end

@implementation GalneProgressView

@synthesize shapeLayer;
@synthesize textL;
@synthesize arcLayer;

- (instancetype)init
{
    self                   = [super init];
    if (self) {
        self.frame=CGRectMake(0, 0, 200,200);
        
        //圆圈路径
        self.centers = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);//圆心
        self.radius = 30;//半径
        
        //self.frame             = [UIScreen mainScreen].bounds;
        self.gradientLayer     = [CAGradientLayer layer];
        _gradientLayer.frame   = self.frame;
        [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[[UIColor cyanColor] CGColor] ,[[UIColor orangeColor] CGColor],[[UIColor orangeColor] CGColor],(id)[[UIColor lightGrayColor] CGColor],(id)[[UIColor blueColor] CGColor] ,[[UIColor blackColor] CGColor],[[UIColor whiteColor] CGColor], nil]];
        [_gradientLayer setStartPoint:CGPointMake(0, 0)];
        [_gradientLayer setEndPoint:CGPointMake(1, 1)];
        _gradientLayer.type    = kCAGradientLayerAxial;
        
        
        UIBezierPath *be       = [UIBezierPath bezierPath];
        [be addArcWithCenter:CGPointMake(50, 50) radius:_radius startAngle:M_PI/2 endAngle:-M_PI/2 clockwise:YES];
        shapeLayer             = [CAShapeLayer layer];
        shapeLayer.path        = be.CGPath;
        shapeLayer.fillColor   = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
        shapeLayer.strokeEnd   = 0;
        shapeLayer.strokeStart = 0;
        shapeLayer.lineWidth   = 4;
        shapeLayer.bounds = CGRectMake(0, 0, 100, 100);
        shapeLayer.position         = _centers;
        
        [self.layer addSublayer:shapeLayer];
        
        textL                  = [CATextLayer layer];
        textL.string           = @" 加载中...";
        textL.contentsScale    = [UIScreen mainScreen].scale;
        textL.position         = CGPointMake(self.centers.x,self.centers.y+self.radius/2+40);
        
        textL.bounds           = CGRectMake(0,0, 100, 40);
        textL.fontSize         = 14;
        textL.alignmentMode    = kCAAlignmentCenter;
        textL.foregroundColor = [UIColor orangeColor].CGColor;//字体的颜色
        [self.layer addSublayer:textL];
        
    }
    return self;
}

- (CABasicAnimation *)rotateAnimation {
    if (!_rotateAnimation) {
        _rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _rotateAnimation.fromValue = @0;
        _rotateAnimation.toValue = @(2*M_PI);
        _rotateAnimation.duration = DURATION/2;
        _rotateAnimation.repeatCount = HUGE;
        _rotateAnimation.removedOnCompletion = NO;
        _rotateAnimation.delegate=self;
        [_rotateAnimation setValue:@"step1" forKey:@"Circle"];
    }
    return _rotateAnimation;
}

- (CABasicAnimation *)strokeAnimatinStart {
    if (!_strokeAnimatinStart) {
        _strokeAnimatinStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        _strokeAnimatinStart.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _strokeAnimatinStart.duration = DURATION/2;
        _strokeAnimatinStart.fromValue = @0;
        _strokeAnimatinStart.toValue = @1;
        _strokeAnimatinStart.beginTime = DURATION/2;
        _strokeAnimatinStart.removedOnCompletion = NO;
        _strokeAnimatinStart.fillMode = kCAFillModeForwards;
        _strokeAnimatinStart.repeatCount = HUGE;
        _strokeAnimatinStart.delegate=self;
    }
    return _strokeAnimatinStart;
}

- (CABasicAnimation *)strokeAnimatinEnd {
    if (!_strokeAnimatinEnd) {
        _strokeAnimatinEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _strokeAnimatinEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _strokeAnimatinEnd.duration = DURATION;
        _strokeAnimatinEnd.fromValue = @0;
        _strokeAnimatinEnd.toValue = @1;
        _strokeAnimatinEnd.removedOnCompletion = NO;
        _strokeAnimatinEnd.fillMode = kCAFillModeForwards;
        
        
        _strokeAnimatinEnd.repeatCount = HUGE;
    }
    return _strokeAnimatinEnd;
}

- (CAAnimationGroup *)animationGroup {
    if (!_animationGroup) {
        _animationGroup = [CAAnimationGroup animation];
        _animationGroup.animations = @[self.strokeAnimatinStart, self.strokeAnimatinEnd];
        _animationGroup.repeatCount = HUGE;
        
        _animationGroup.duration = DURATION;
    }
    return _animationGroup;
}

- (void)startProgressAnimating {
    
    [self.shapeLayer addAnimation:self.animationGroup forKey:@"group"];
    //
    [self.shapeLayer addAnimation:self.rotateAnimation forKey:@"rotate"];
   
    
}

#pragma  mark  ************************ 开始对勾动画 **************************


- (void)startGouAnimation
{
    
    
    [self startCircleHideAnimation];
    
    [self.shapeLayer removeFromSuperlayer];
    
    if (_shapeLayerGou) {
        
        _shapeLayerGou.hidden = NO;
        
    } else {
        
        CGFloat offset = self.radius/2;
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        linePath.lineCapStyle = kCGLineCapRound; //线条拐角
        linePath.lineJoinStyle = kCGLineCapRound; //终点处理
        [linePath moveToPoint:CGPointMake(self.centers.x - self.radius+4, self.centers.y - 1)];
        [linePath addLineToPoint:CGPointMake(self.centers.x-offset/2, self.centers.y + (offset - 1))];
        [linePath addLineToPoint:CGPointMake(self.centers.x + offset, self.centers.y - offset/2)];
        
        _shapeLayerGou = [CAShapeLayer layer];
        _shapeLayerGou.path = linePath.CGPath;
        _shapeLayerGou.strokeColor = [UIColor orangeColor].CGColor;//线条颜色
        _shapeLayerGou.fillColor = [UIColor clearColor].CGColor;//填充颜色
        _shapeLayerGou.lineWidth = 4.0;
        _shapeLayerGou.strokeStart = 0.17;
        _shapeLayerGou.strokeEnd = 0.0;
        _shapeLayerGou.frame = CGRectMake(5,0, self.radius, self.radius);
        //_shapeLayerGou.position         = center;
        [self.layer addSublayer:_shapeLayerGou];
        
        //        self.backgroundColor=[UIColor grayColor];
        
        
        UIBezierPath *pathS=[UIBezierPath bezierPath];
        
        [pathS addArcWithCenter:self.centers radius:self.radius startAngle:-M_PI/2 endAngle:3*M_PI/2 clockwise:YES];
        arcLayer=[CAShapeLayer layer];
        arcLayer.path=pathS.CGPath;//46,169,230
        arcLayer.fillColor=[UIColor clearColor].CGColor;
        arcLayer.strokeColor=[UIColor orangeColor].CGColor;
        arcLayer.lineWidth=4;
        //        arcLayer.bounds = CGRectMake(0, 0, 100, 100);
        //        arcLayer.position         = center;
        [self.layer addSublayer:arcLayer];
    }
    
    CABasicAnimation *animGou = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animGou.fromValue = @0.0;
    animGou.toValue = @1.0;
    animGou.duration = 0.6;
    animGou.beginTime = 0.0;
    animGou.removedOnCompletion = NO;
    animGou.fillMode = kCAFillModeForwards;
    
    [_shapeLayerGou addAnimation:animGou forKey:@"gou"];
    
    [arcLayer addAnimation:animGou forKey:@"arc"];
    
    
}


/**
 *  圆弧隐藏动画
 */
- (void)startCircleHideAnimation
{
    CABasicAnimation *animHide = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [animHide setFromValue:@1.0];
    [animHide setToValue:@0.0];
    [animHide setDuration:1];
    animHide.beginTime = 0.0;
    animHide.removedOnCompletion = NO;
    animHide.fillMode = kCAFillModeForwards;//当动画结束后,layer会一直保持着动画最后的状态
    animHide.delegate = self;
    [self.shapeLayer addAnimation:animHide forKey:@"CircleHide"];
}


- (void)circleAnimationTypeOne {
    
    NSMutableArray *colorArray = _gradientLayer.colors.mutableCopy;
    
    UIColor *lostColor = [colorArray lastObject];
    [colorArray removeLastObject];
    [colorArray insertObject:lostColor atIndex:0];
    [UIView animateWithDuration:.5 animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.gradientLayer.colors = colorArray;
    }];
}




-(void)showSuccess:(NSString *)infoStr
{
    [self startGouAnimation];
    
    textL.string = infoStr?infoStr:@"支付成功";
    
}


-(void)showProgressView:(NSString *)infoStr stopAnimation:(AnimStopBlock)stopBlock
{
    self.stopBlock=stopBlock;
    [self startProgressAnimating];
    textL.string = infoStr;
    
    
}


#pragma -mark CAAnimationDelegate


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.stopBlock) {
        
        [self performSelector:@selector(removeAnimation) withObject:self afterDelay:1.5];
        [self performSelector:@selector(backAnimationStop) withObject:self afterDelay:1.5];
    }
    
}

-(void)backAnimationStop
{
self.stopBlock(YES);
}


/**
 *  移除动画
 */
- (void)removeAnimation
{
    if (_shapeLayerGou) {
        _shapeLayerGou.hidden = YES;
        [shapeLayer removeAllAnimations];
    }
    [self.layer removeAllAnimations];
    
}


@end
