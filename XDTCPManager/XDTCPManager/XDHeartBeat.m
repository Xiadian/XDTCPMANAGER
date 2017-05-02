
//
//  XDHeartBeat.m
//  XDTCPManager
//
//  Created by Xuezhipeng on 2017/4/26.
//  Copyright © 2017年 XD. All rights reserved.
//

#import "XDHeartBeat.h"
#import "XDTCPManager.h"
@interface XDHeartBeat()

@end
@implementation XDHeartBeat
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.heartData=@"《》";
        self.heartTimer=[NSTimer scheduledTimerWithTimeInterval:HEARTTIME target:self selector:@selector(heartSend:) userInfo:nil repeats:YES];
    }
    return self;
}

/**
 定时发送心跳的方法

 @param userinfo 定时器参数
 */
-(void)heartSend:(id)userinfo{
    [XDTCPManager requestWith:self.heartData successBlock:^(id response) {
        NSLog(@"心跳发送成功");
    } failureBlock:^{
        NSLog(@"心跳发送失败");
    }];
}
-(void)timerPause{
    
  [self.heartTimer  setFireDate:[NSDate distantFuture]];
}
-(void)timerContinue{
    
  [self.heartTimer  setFireDate:[NSDate distantPast]];
}
@end
