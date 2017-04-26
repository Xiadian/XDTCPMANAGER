//
//  XDEncoding.h
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDSocketPacketContext.h"
#import "XDTCPConnect.h"
@interface XDEncoding : NSObject
/**
 *  应用协议中允许发送的最大数据块大小
 */
@property (nonatomic, assign) NSUInteger maxFrameSize;
/**
 //序列化数据
 @param requestPacket 发送的数据
 */
-(void)encodeData:(id<XDUpstreamPacket>)requestPacket withSocketCon:(XDTCPConnect *)con;
@end
