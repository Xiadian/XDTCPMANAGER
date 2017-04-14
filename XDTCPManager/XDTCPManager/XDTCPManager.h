//
//  XDTCPManager.h
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDTCPRequest.h"
@interface XDTCPManager : NSObject
/**
 请求缓存池
 */
@property(nonatomic,strong)NSCache *requestBuffer;
/**
 //数据缓存池
 */
@property(nonatomic,strong)NSCache *dataBuffer;
/**
 //唯一表示码
 */
@property(nonatomic,assign)NSUInteger pid;


/**
 tcp网络请求的单例对象
 
 @return tcp请求对象
 */
+ (instancetype)sharedInstance;

/**
 连接服务器
 */
-(void)connectToServers;

/**
 停止连接服务器
 */
-(void)stopServers;
/**
 tcp请求
 
 @param requestData 请求数据data类型
 @param succesBlock 成功的回调
 @param failureBlock 失败的回调（主要是请求超时）
 */
+(void)requestWith:(NSData *)requestData successBlock:(succesReqBlock)succesBlock failureBlock:(failureReqBlock)failureBlock;

@end
