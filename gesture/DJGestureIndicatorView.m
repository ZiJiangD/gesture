//
//  DJGestureIndicatorView.m
//  gesture
//
//  Created by 董子江 on 209/12/17.
//  Copyright © 209 nightowl. All rights reserved.
//

#import "DJGestureIndicatorView.h"

@interface DJGestureIndicatorView ()
/**
 所有按钮
 */
@property (nonatomic,strong) NSMutableArray *senderList;

@end

@implementation DJGestureIndicatorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.senderList=[[NSMutableArray alloc]init];
        CGFloat sp=(self.frame.size.width-9*3)/4.0;
        
        for (int i=0; i<9; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.userInteractionEnabled = false;
            if (i<3) {
                btn.frame=CGRectMake(sp*(i%3+1)+9*(i%3), sp, 9, 9);
            } else if (i>=3 && i< 6){
                btn.frame=CGRectMake(sp*(i%3+1)+9*(i%3), sp*2+9, 9, 9);
            } else{
                btn.frame=CGRectMake(sp*(i%3+1)+9*(i%3), sp*3+9*2, 9, 9);
            }
            
            btn.tag = 100+i;
            [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
//                        btn.backgroundColor = [UIColor orangeColor];
            btn.layer.cornerRadius=4.5;
            //            btn.layer.borderWidth=1.0;
            //            btn.layer.borderColor=[UIColor whiteColor].CGColor;
            btn.layer.masksToBounds=YES;
            [btn setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
            [self.senderList addObject:btn];
            [self addSubview:btn];
        }
    }
    return self;
}



/**
 选择中后的串位置如“0，2，3，4”

 @param selectStr <#selectStr description#>
 */
- (void)setSelectView:(NSString *)selectStr{
    
    for (int i=0; i<9; i++) {
        if ([selectStr containsString:[NSString stringWithFormat:@"%d",i]]) {
            UIButton *btn= self.senderList[i];
            [btn setSelected:true];
        }
    }
    
}

- (void)reload{
    for (int i=0; i<9; i++) {
       UIButton *btn= self.senderList[i];
       [btn setSelected:false];
        
    }
}


@end
