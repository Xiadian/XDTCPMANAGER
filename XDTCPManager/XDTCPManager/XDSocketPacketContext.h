//
//  XDSocketPacketContext.h
//  XDTCPManager
//
//  Created by XiaDian on 2017/4/1.
//  Copyright © 2017年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  数据包协议
 */
@class XDSocketPacketHead;
@protocol XDSocketPacket <NSObject>
@required
/**
 *  数据包携带的数据变量（可以是任何数据格式）
 */
@property (nonatomic, strong) id object;
/**
 请求头需要实现的类
 */
@property (nonatomic, strong) XDSocketPacketHead *packetHead;
- (instancetype)initWithObject:(id)aObject;
- (NSData *)dataWithPacket;
@end

#pragma mark - upstream packet

/**
 *  上行数据包协议，发送数据时，必须遵循的协议
 */
@protocol XDUpstreamPacket <XDSocketPacket>

@optional

/**
 *  发送数据超时时间，必须设置。－1时为无限等待
 */
@property (nonatomic, assign) NSTimeInterval timeout;

@end

#pragma mark - downstream packet

/**
 *  下行数据包协议，接收数据时，必须遵循的协议
 */
@protocol XDDownstreamPacket <XDSocketPacket>

@end
/**
 * instrument代理主要处理数据分包
 */
@protocol XDTCPInstrumentDelegate <NSObject>
-(void)resiveSocketData:(id<XDDownstreamPacket>)downPacket;
@end

@interface XDSocketPacketContext : NSObject <XDUpstreamPacket, XDDownstreamPacket>

@end

#pragma mark - RSSocketPacketRequest

@interface XDSocketPacketRequest : XDSocketPacketContext

@end

#pragma mark - RSSocketPacketResponse

@interface XDSocketPacketResponse : XDSocketPacketContext

@end

#pragma mark - RSSocketPacketHead

/**
 数据传输协议头 自定义
 */
@interface XDSocketPacketHead : XDSocketPacketContext
@property(nonatomic,assign)NSUInteger length; //数据长度4
@property (nonatomic, assign) NSInteger pid;//验证码
@property(nonatomic,assign)NSUInteger priority; //优先级2
@property(nonatomic,assign)NSUInteger verifyCode; //验证码8
@property(nonatomic,assign)NSUInteger unkown;//未定4
@end

