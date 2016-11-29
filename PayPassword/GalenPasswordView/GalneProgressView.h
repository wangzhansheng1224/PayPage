//
//  GalneProgressView.h
//  PayView
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^AnimStopBlock)(BOOL isFinish);
@interface GalneProgressView : UIView



/**
 *  动画完成回调block
 */
@property (nonatomic, copy) AnimStopBlock stopBlock;



-(void)showProgressView:(NSString *)infoStr stopAnimation:(AnimStopBlock) stopBlock;

-(void)showSuccess:(NSString *)infoStr;

@end
