

//
//  XDDecoding.m
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import "XDDecoding.h"
#import "XDSocketUtils.h"
@implementation XDDecoding
- (instancetype)init
{
    if (self = [super init]) {
        _maxFrameSize = INT32_MAX;
    }
    return self;
}
-(NSInteger)decode:(NSData *)data output:(id<XDTCPInstrumentDelegate>)target{

    id object =data;
    if (![object isKindOfClass:[NSData class]]) {
        NSLog(@"[Decode] object should be NSData ...");
        return -1;
    }
    //取出传输数据
    NSData *downstreamData = object;
    NSUInteger headIndex=0;
    //需要解码的数据
    NSData *needDecodeData = downstreamData;

    //先读区6个字节的包头(前4个字节为数据包的长度)
    if (downstreamData.length<6) {
        //解码不正常
        return 0;
    }
    while (downstreamData.length-headIndex>6) {
    NSData *dataHead = [needDecodeData subdataWithRange:NSMakeRange(0,6)];
    //取出长度数据前四个字节
    NSData *lenData = [dataHead subdataWithRange:NSMakeRange(0, 4)];
    NSUInteger bodyLen=(NSUInteger)[XDSocketUtils valueFromBytes:lenData reverse:YES];
    //数据过长
    if (bodyLen >= _maxFrameSize - bodyLen) {
        NSLog(@"[Decode] Too Long Frame ...");
        return -1;
    }
    //数据包不够长，返回数据长度丢弃
    if (needDecodeData.length - 6 <  bodyLen) {
        return needDecodeData.length;
    }
    NSData *dataBody = [needDecodeData subdataWithRange:NSMakeRange(6,bodyLen)];
    XDSocketPacketResponse *ctx = [[XDSocketPacketResponse alloc] init];
    XDSocketPacketHead *head=[[XDSocketPacketHead alloc]init];
    head.length=bodyLen;
    //数据随机码
    NSData *pidData=[dataHead subdataWithRange:NSMakeRange(4, 2)];
    NSUInteger pid=(NSUInteger)[XDSocketUtils valueFromBytes:pidData reverse:YES];
    head.pid=pid;
    ctx.object =dataBody;
    ctx.packetHead=head;
    
    //返回的数据
    [target resiveSocketData:ctx];
    //调整已经解码数据
    headIndex += dataBody.length+6;
    needDecodeData=[downstreamData subdataWithRange:NSMakeRange(headIndex, downstreamData.length-headIndex)];
}
    return headIndex;
 
}
@end
