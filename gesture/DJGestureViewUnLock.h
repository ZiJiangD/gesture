//
//  DJGestureViewUnLock.h
//  gesture
//
//  Created by 董子江 on 2018/12/12.
//  Copyright © 2018 nightowl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@class DJGestureViewUnLock;

@protocol DJGestureViewUnLockDelegate <NSObject>

@required
- (void)DJGestureViewUnLockFinish:(NSString *)selectStr;
@optional
@end




@interface DJGestureViewUnLock : UIView
@property(nonatomic ,retain) id<DJGestureViewUnLockDelegate> delegate;

-(void)reload;



@end

NS_ASSUME_NONNULL_END
