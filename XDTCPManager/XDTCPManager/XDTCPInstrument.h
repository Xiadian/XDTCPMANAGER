//
//  XDTCPInstrument.h
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDEncoding.h"
#import "XDDecoding.h"
#import "XDTCPConnect.h"
#import "XDSocketPacketContext.h"


@interface XDTCPInstrument : NSObject<XDSocketConnectionDelegate>
/**
 instrument代理主要处理数据分包
 */
@property(nonatomic,strong)id<XDTCPInstrumentDelegate>delegate;
/**
 编码对象
 */
@property(nonatomic,strong)XDEncoding *encode;

/**
 解码对象
 */
@property(nonatomic,strong)XDDecoding *decode;

/**
 连接对象
 */
@property(nonatomic,strong)XDTCPConnect *con;
/**
 *  service是否在运行中
 */
@property (assign, readonly) BOOL isRunning;
/**
 断开连接
 */
- (void)stopService;

/**
 发送数据

 @param requestPacket 自己封号的对象
 */
-(void)sendData:(id<XDUpstreamPacket>)requestPacket;
@end
