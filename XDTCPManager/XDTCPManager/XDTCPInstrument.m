//
//  XDTCPInstrument.m
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import "XDTCPInstrument.h"

@interface XDTCPInstrument ()
@property (nonatomic, strong, readonly) NSMutableData *receiveDataBuffer;
@end
@implementation XDTCPInstrument
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.encode=[[XDEncoding alloc]init];
        self.decode=[[XDDecoding alloc]init];
        self.con=[[XDTCPConnect alloc]init];
        _receiveDataBuffer=[[NSMutableData alloc]init];
    }
    return self;
}
-(void)sendData:(id<XDUpstreamPacket>)requestPacket{
    if (self.encode==nil) {
        
    }
    else{
        __weak typeof(self) weakSelf = self;
       dispatch_async(self.con.socketSendQueue, ^{
           [weakSelf.encode encodeData:requestPacket withSocketCon:weakSelf.con];
       });
    }
}

-(BOOL)isRunning{
    return   [self.con isConnect];
}

-(void)stopService{
    [self.con cutConnect];
}
#pragma mark TCP连接代理

- (void)didDisconnect:(XDTCPConnect *)con withError:(NSError *)err{}


- (void)didConnect:(XDTCPConnect *)con toHost:(NSString *)host port:(uint16_t)port{}

#pragma 接收通知方法 分包
- (void)didRead:(XDTCPConnect *)con withData:(NSData *)data tag:(long)tag{
    if (data.length == 0) {
        return;
    }
    if (nil == _decode) {
        NSLog(@"RSSocket Decoder should not be nil ...");
        return;
    }
    //锁
    @synchronized(self) {
        //缓存_receiveDataBuffer处理粘包
        [_receiveDataBuffer appendData:data];
                data= _receiveDataBuffer;
                //被解码的数据长度 return -1说明有问题断开 0的话为于20字节的数据在判断》0说明还有剩余 那就把剩下的存入缓存等下次
                NSInteger decodedLength = [_decode decode:data output:self.delegate];
                if (decodedLength < 0) {
                    NSLog(@"fail");
                    [self stopService];
                    return;
                }//if
                if (decodedLength > 0) {
                    //截取剩下的data存入缓冲区
                    NSUInteger remainLength = _receiveDataBuffer.length - decodedLength;
                    NSData *remainData = [_receiveDataBuffer subdataWithRange:NSMakeRange(decodedLength, remainLength)];
                    [_receiveDataBuffer setData:remainData];
                }//if
    }//@synchr
}
- (void)didWriteData:(XDTCPConnect*) con WithTag:(long)tag{}
@end
