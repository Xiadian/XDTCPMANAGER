//
//  XDSocketPacketContext.m
//  XDTCPManager
//
//  Created by XiaDian on 2017/4/1.
//  Copyright © 2017年 XD. All rights reserved.
//

#import "XDSocketPacketContext.h"


@implementation XDSocketPacketContext
#pragma mark - RSSocketPacketContext

@synthesize object = _object;
@synthesize packetHead = _packetHead;
- (instancetype)initWithObject:(id)aObject
{
    if (self = [super init]) {
        _object = aObject;
    }
    return self;
}
- (NSData *)dataWithPacket
{
    if ([_object isKindOfClass:[NSData class]]) {
        return _object;
    } else if ([_object isKindOfClass:[NSString class]]) {
        NSString *stringObject = _object;
        return [stringObject dataUsingEncoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}
@end
#pragma mark - XDSocketPacketRequest

@implementation XDSocketPacketRequest
@synthesize timeout = _timeout;
- (instancetype)init
{
    if (self = [super init]) {
        _timeout = -1;
    }
    return self;
}
@end
#pragma mark - XDSocketPacketResponse

@implementation XDSocketPacketResponse

@end
#pragma mark - XDSocketPacketHead

@implementation XDSocketPacketHead

@end

