//
//  DJGestureIndicatorView.h
//  gesture
//
//  Created by 董子江 on 2018/12/17.
//  Copyright © 2018 nightowl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJGestureIndicatorView : UIView
/**
 选择中后的串位置如“0，2，3，4”
 
 @param selectStr <#selectStr description#>
 */
- (void)setSelectView:(NSString *)selectStr;

- (void)reload;
@end

NS_ASSUME_NONNULL_END
