//
//  XDHeartBeat.h
//  XDTCPManager
//
//  Created by Xuezhipeng on 2017/4/26.
//  Copyright © 2017年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HEARTTIME 5
@interface XDHeartBeat : NSObject
/**
 心跳包数据
 */
@property(nonatomic,retain)id heartData;
/**
 心跳包定时器
 */
@property(nonatomic,retain)NSTimer *heartTimer;

@end
