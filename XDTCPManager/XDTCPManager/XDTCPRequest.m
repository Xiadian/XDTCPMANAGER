//
//  XDTCPRequest.m
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import "XDTCPRequest.h"
#import "XDTCPManager.h"
@interface  XDTCPRequest()
/**
 开始秒数
 */
@property(nonatomic,assign)NSInteger starSecond;
@end
@implementation XDTCPRequest

/**
 构造方法 init初始化开始时间，过期时间 定时器
 
 @return 当前对象
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.starSecond=0;
        self.outTime=30;
        self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    }
    return self;
}
-(void)timeGo{
    self.starSecond+=1;
    if (self.starSecond>self.outTime) {
        //超时处理 将对象同时移除缓存区
        [[XDTCPManager sharedInstance].requestBuffer removeObjectForKey:@(self.pid)];
        [self.timer invalidate];
        self.timer=nil;
        //回调超时方法
        self.failureReqBlock();
    }
}

@end
