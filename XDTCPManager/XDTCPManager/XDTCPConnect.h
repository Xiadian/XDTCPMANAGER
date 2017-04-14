//
//  XDTCPConnect.h
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDTCPConnect;
@protocol XDSocketConnectionDelegate <NSObject>
/**
 *  和socket服务器 连接失败／断开连接 的回调方法
 *
 *  @param con 当前socket connection
 *  @param err 错误原因
 */
- (void)didDisconnect:(XDTCPConnect *)con withError:(NSError *)err;

/**
 *  和socket服务器连接成功的回调方法
 *
 *  @param con  当前socket connection
 *  @param host 连接成功的服务器地址ip
 *  @param port 连接成功的服务器端口port
 */
- (void)didConnect:(XDTCPConnect *)con toHost:(NSString *)host port:(uint16_t)port;

/**
 *  接收到从socket服务器推送下来的下行数据(原始数据流)回调方法
 *
 *  @param con  当前socket connection
 *  @param data 推送过来的下行数据
 *  @param tag  数据tag标记，和readDataWithTimeout:tag/writeData:timeout:tag:中的tag对应。
 */

- (void)didRead:(XDTCPConnect *)con withData:(NSData *)data tag:(long)tag;
@optional
/**
 发送数据到服务器成功

 @param con 当前socket connection
 @param tag 推送过来的下行数据
 */
- (void)didWriteData:(XDTCPConnect*) con WithTag:(long)tag;
@end

@interface XDTCPConnect : NSObject
@property (nonatomic, strong) dispatch_queue_t socketSendQueue;
@property(nonatomic,strong)id<XDSocketConnectionDelegate>delegate;
/**
 发送数据

 @param data nsdata
 */
-(void)sendData:(NSData *)data;
/**
 返回连接状态

 @return 是否连接
 */
-(BOOL)isConnect;

/**
 连接到服务器
 */
-(void)connectToService;

-(void)cutConnect;
@end
