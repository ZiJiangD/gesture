//
//  DJGestureViewUnLock.m
//  gesture
//
//  Created by 董子江 on 2018/12/12.
//  Copyright © 2018 nightowl. All rights reserved.
//

#import "DJGestureViewUnLock.h"
#import <math.h>
@interface DJGestureViewUnLock ()
{
    CGPoint st_point;
    CGPoint mo_point;
}

/**
 所有按钮
 */
@property (nonatomic,strong) NSMutableArray *senderList;

/**
所有按钮的frame
 */
@property (nonatomic,strong) NSMutableArray *senderFrameList;
/**
 选中按钮
 */
@property (nonatomic,strong) NSMutableArray *selectSenderList;


@end
@implementation DJGestureViewUnLock

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.senderList=[[NSMutableArray alloc]init];
        self.senderFrameList=[[NSMutableArray alloc]init];
        self.selectSenderList=[[NSMutableArray alloc]init];
        st_point=CGPointZero;
        mo_point=CGPointZero;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        
        CGFloat sp=(self.frame.size.width-180)/4.0;
        
        for (int i=0; i<9; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.userInteractionEnabled = false;
            if (i<3) {
                btn.frame=CGRectMake(sp*(i%3+1)+60*(i%3), sp, 60, 60);
            } else if (i>=3 && i< 6){
                btn.frame=CGRectMake(sp*(i%3+1)+60*(i%3), sp*2+60, 60, 60);
            } else{
                btn.frame=CGRectMake(sp*(i%3+1)+60*(i%3), sp*3+60*2, 60, 60);
            }
            
            btn.tag = 100+i;
            [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
//            btn.backgroundColor = [UIColor orangeColor];
            btn.layer.cornerRadius=30.0;
//            btn.layer.borderWidth=1.0;
//            btn.layer.borderColor=[UIColor whiteColor].CGColor;
            btn.layer.masksToBounds=YES;
            [btn setImage:[UIImage imageNamed:@"gesture_normal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"gesture_selected"] forState:UIControlStateSelected];


            [self.senderFrameList addObject:NSStringFromCGRect(btn.frame)];
            [self.senderList addObject:btn];

            [self addSubview:btn];
        }
    }
    return self;
}
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self finish];
    } else if (pan.state == UIGestureRecognizerStateBegan) {
        CGPoint tePoint=[pan locationInView:self];
        UIButton *btn=[self pointInButton:tePoint];
        if (btn != nil) {
            st_point = btn.center;
            if (self.selectSenderList.count==0) {//第一个点
                [self setNeedsDisplay];
                [btn setSelected:true];
                [self layoutIfNeeded];
                [self.selectSenderList addObject:btn];
            }
        }
    }else{
        mo_point=[pan locationInView:self];
        UIButton *btn=[self pointInButton:mo_point];
        
        if ([NSStringFromCGPoint(st_point) isEqual:NSStringFromCGPoint(CGPointZero)]) {//没有起始位置
            if (btn != nil) {//如果起始点是在按钮上
                st_point = btn.center;
                [self drawLine2:st_point and:mo_point];
            }
            
        }else{
            [self drawLine2:st_point and:mo_point];
            if (btn != nil && ![self.selectSenderList containsObject:btn]) {//点是在按钮上 并且 按钮没被加入选择按钮数组
                st_point = btn.center;
                if (self.selectSenderList.count==0) {//第一个点
                    [self setNeedsDisplay];
                    [btn setSelected:true];
                    [self layoutIfNeeded];
                    [self.selectSenderList addObject:btn];
                    
                }else{
                    if ([self addSenderToSelectSenderListAndSetSenderSelect:btn]) {
                        [self drawLineButtonToButtonStart:self.selectSenderList[self.selectSenderList.count-2] andEndButton:self.selectSenderList[self.selectSenderList.count-1] ];
                    }
                    
                }
                
            }
        }
    }

}




/**
 添加 按钮到选择按钮的数组中，并设置按钮为选择状态

 @param sender <#sender description#>
 @return 是否添加成功（已经存在此按钮 返回false  ）
 */
- (BOOL)addSenderToSelectSenderListAndSetSenderSelect:(UIButton *)sender{
    
    BOOL Type=true;
    for (UIButton *btn in self.selectSenderList) {
        if ([btn isEqual:sender]) {
            Type=false;
            break;
        }
    }
    
    if (Type) {
        [self setNeedsDisplay];
        [sender setSelected:true];
        [self layoutIfNeeded];
        [self.selectSenderList addObject:sender];
    }
    
    
    return Type;
}




/**
 通过点找按钮

 @param point 移动的点
 @return <#return value description#>
 */
-(UIButton *)pointInButton:(CGPoint)point{
    
    CGFloat x=point.x;
    CGFloat y=point.y;
    
    int index=-1;
    
    for (int i=0;i<_senderFrameList.count;i++) {
        NSString *frameStr = _senderFrameList[i];
        CGRect sendframe = CGRectFromString(frameStr);
        CGFloat min_x=CGRectGetMinX(sendframe);
        CGFloat max_x=CGRectGetMaxX(sendframe);
        
        CGFloat min_y=CGRectGetMinY(sendframe);
        CGFloat max_y=CGRectGetMaxY(sendframe);
        
        if (x>=min_x&&x<=max_x&&y>=min_y&&y<=max_y) {
            index=i;
            break;
        }
    }
    
    if (index != -1) {
        return _senderList[index];
    }
    
    return nil;
}


/**
 画按钮到按钮的线

 @param startBtn <#startBtn description#>
 @param endButton <#endButton description#>
 */
- (void)drawLineButtonToButtonStart:(UIButton *)startBtn andEndButton:(UIButton *)endButton{
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.name = @"按钮连线";
    CGMutablePathRef shapePath =  CGPathCreateMutable();
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor orangeColor] CGColor]];
    shapeLayer.lineWidth = 10.0f ;
    
    CGPathMoveToPoint(shapePath, NULL, startBtn.center.x,startBtn.center.y);
    CGPathAddLineToPoint(shapePath, NULL, endButton.center.x,endButton.center.y);
    
    [shapeLayer setPath:shapePath];
    CGPathRelease(shapePath);
    [self.layer insertSublayer:shapeLayer atIndex:0];
//    [self.layer addSublayer:shapeLayer];
}



/**
 绘制动画线（手势线）

 @param startPoint <#startPoint description#>
 @param touchPoint <#touchPoint description#>
 */
-(void)drawLine2:(CGPoint)startPoint and:(CGPoint)touchPoint{
    
    UIButton *selectLastBtn = self.selectSenderList.lastObject;
    
    
    if (![NSStringFromCGPoint(startPoint) isEqualToString:NSStringFromCGPoint(selectLastBtn.center)]){
        return;
    }
    
    [self deleteMoveLine];
    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    solidShapeLayer.name=@"动画线";
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [solidShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [solidShapeLayer setStrokeColor:[[UIColor greenColor] CGColor]];
    solidShapeLayer.lineWidth = 10.0f ;
    
    CGPathMoveToPoint(solidShapePath, NULL, startPoint.x,startPoint.y);
    CGPathAddLineToPoint(solidShapePath, NULL, touchPoint.x,touchPoint.y);
    
    [solidShapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    [self.layer insertSublayer:solidShapeLayer atIndex:0];
//    [self.layer addSublayer:solidShapeLayer];
    
}


/**
 删除动画线（手势线）
 */
-(void)deleteMoveLine{
    NSMutableArray *list=[[NSMutableArray alloc]initWithArray:self.layer.sublayers];
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:@"动画线"] ) {
            [list removeObject:layer];
        }
    }
    [self.layer setSublayers:list];
}

/**
 删除 按钮和按钮之间连线
 */
-(void)deleteButtonToButtonLine{
    NSMutableArray *list=[[NSMutableArray alloc]initWithArray:self.layer.sublayers];
    for (CAShapeLayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:@"按钮连线"] ) {
            [list removeObject:layer];
        }
    }
    [self.layer setSublayers:list];
}



/**
 刷新
 */
-(void)reload{
    [self deleteMoveLine];
    [self deleteButtonToButtonLine];
    [self.selectSenderList removeAllObjects];
    st_point = CGPointZero;
    mo_point = CGPointZero;
    
    for (UIButton * btn in self.senderList) {
        [btn setSelected:false];
    }
    
}

/**
 结束
 */
- (void)finish{

    NSMutableArray *list = [[NSMutableArray alloc]init];
    for (UIButton * btn in self.selectSenderList) {
        [list addObject: [NSString stringWithFormat:@"%ld",btn.tag-100]];
    }

    [self deleteMoveLine];
    
   double delayInSeconds = 1.0;
   dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
   dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
       //执行事件
       [self reload];
   });

    if (self.delegate && [self.delegate respondsToSelector:@selector(DJGestureViewUnLockFinish:)]) {
        [self.delegate DJGestureViewUnLockFinish:[list componentsJoinedByString:@","]];
    }
    
}

@end
