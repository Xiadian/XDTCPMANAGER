//
//  XDEncoding.m
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import "XDEncoding.h"
#import "XDSocketUtils.h"
@implementation XDEncoding
- (instancetype)init
{
    if (self = [super init]) {
        _maxFrameSize = INT32_MAX;
    }
    return self;
}
-(void)encodeData:(id<XDUpstreamPacket>)requestPacket withSocketCon:(XDTCPConnect *)con{
    NSData *data = [requestPacket dataWithPacket];
    
    if (data.length == 0) {
        NSLog(@"[Encode] object data is nil ...");
        return;
    }//
    if (data.length >= _maxFrameSize - 4) {
        NSLog(@"[Encode] Too Long Frame ...");
        return;
    }
    //发送的数据
    NSMutableData *sendData = [[NSMutableData alloc] init];
    //将数据长度转换为长度字节，写入到数据块中
    NSMutableData *headData =[[NSMutableData alloc]init];
    requestPacket.packetHead.length=data.length;
    NSData *lengthData=[XDSocketUtils bytesFromValue:requestPacket.packetHead.length byteCount:4 reverse:NO];
    [headData appendData:lengthData];
    //随机码
    NSUInteger Code=requestPacket.packetHead.pid;
    NSData *codeData=[XDSocketUtils bytesFromValue:Code byteCount:2 reverse:NO];
    [headData appendData:codeData];
    //优先级
    NSUInteger priority=1000;
    requestPacket.packetHead.priority=priority;
    NSData *priorityData=[XDSocketUtils bytesFromValue:requestPacket.packetHead.priority byteCount:2 reverse:NO];
    [headData appendData:priorityData];
    //验证码
    NSUInteger verifyCode=124124;
    requestPacket.packetHead.verifyCode=verifyCode;
    NSData *verifyCodeData=[XDSocketUtils bytesFromValue:verifyCode byteCount:8 reverse:NO];
    [headData appendData:verifyCodeData];
    //优先级
    NSUInteger unkown=444;
    requestPacket.packetHead.unkown=unkown;
    NSData *unkownData=[XDSocketUtils bytesFromValue:requestPacket.packetHead.unkown byteCount:4 reverse:NO];
    [headData appendData:unkownData];
    [sendData appendData:headData];
    [sendData appendData:data];
    
    
    NSTimeInterval timeout = [requestPacket timeout];
    NSLog(@"timeout: %f, sendData: %@", timeout, sendData);
    [con sendData:sendData];

    
    
}
@end
