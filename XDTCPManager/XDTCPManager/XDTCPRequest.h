//
//  XDTCPRequest.h
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void   (^succesReqBlock)(id response);
typedef void   (^failureReqBlock)(void);
@interface XDTCPRequest : NSObject
/**
 请求成功回调
 */
@property(nonatomic,copy)succesReqBlock succesReqBlock;
/**
 请求失败回调
 */
@property(nonatomic,copy)failureReqBlock failureReqBlock;
/**
 请求计时器
 */
@property(nonatomic,strong)NSTimer * timer;
/**
 //设置过期时间
 */
@property(nonatomic,assign)NSInteger outTime;
/**
 //请求唯一标识
 */
@property(nonatomic,assign)NSInteger pid;
@end
