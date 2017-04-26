//
//  XDTCPConnect.m
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import "XDTCPConnect.h"
#import "XDTCPConParameter.h"
#import "GCDAsyncSocket.h"
#import "XDHeartBeat.h"
NSString * const RSSocketQueueSpecific = @"com.XDsocket.XDSocketQueueSpecific";
@interface XDTCPConnect () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, assign) void *IsOnSocketQueueOrTargetQueueKey;
@property (nonatomic, strong) XDTCPConParameter *parameter;
@property (nonatomic, strong) XDHeartBeat *heartBeat;

@end
@implementation XDTCPConnect
- (instancetype)init
{
    self = [super init];
    if (self) {
        //queue
        _socketSendQueue = dispatch_queue_create("com.XDSendQueue", DISPATCH_QUEUE_SERIAL);
        
        void *nonNullUnusedPointer = (__bridge void *)self;
        
        dispatch_queue_set_specific(_socketSendQueue, _IsOnSocketQueueOrTargetQueueKey, nonNullUnusedPointer, NULL);
        
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketSendQueue];
        
        self.parameter=[[XDTCPConParameter alloc]init];
        self.heartBeat=[[XDHeartBeat alloc]init];
    }
    return self;
}
#pragma mark - queue
-(void)connectToService{
    
    if (!self.asyncSocket.isConnected) {
        
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketSendQueue];
        
        NSError *error = nil;
        
        [self.asyncSocket connectToHost:self.parameter.host onPort:self.parameter.port withTimeout:self.parameter.timeOut error:&error];
        
        if (error) {
            
            NSLog(@"%@",error);
        }
    }
}
-(void)sendData:(NSData *)data{
    
    if (data.length==0) {
        
        return;
    }
    
    if(self.asyncSocket.isConnected){
        
        [self.asyncSocket writeData:data withTimeout:self.parameter.timeOut tag:0];
    }
}
-(BOOL)isConnect{
    
    return  self.asyncSocket.isConnected;
}
-(void)cutConnect{
    
    if ([self isConnect]) {
        
        [self.asyncSocket disconnect];
        [self.heartBeat.heartTimer  setFireDate:[NSDate distantFuture]];
        self.asyncSocket.delegate=nil;
    }
}
#pragma mark - GCDAsyncSocketDelegate

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketDidDisconnect: %@", err.description);
    if (self.delegate) {
        [self.heartBeat.heartTimer  setFireDate:[NSDate distantFuture]];
        [self.delegate didDisconnect:self withError:err];
    }
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"didConnectToHost: %@, port: %d", host, port);
    if (self.parameter.heartIsOn) {
        //开启定时器
        [self.heartBeat.heartTimer  setFireDate:[NSDate distantPast]];
    }
    if (self.delegate) {
        
        [self.delegate didConnect:self toHost:host port:port];
    }
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"didReadData length: %lu, tag: %ld", (unsigned long)data.length, tag);
    
    if (self.delegate) {
        
        [self.delegate didRead:self withData:data tag:tag];
    }
    
    [sock readDataWithTimeout:self.parameter.timeOut tag:tag];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //NSLog(@"didWriteDataWithTag: %ld", tag);
    
    [sock readDataWithTimeout:self.parameter.timeOut tag:tag];
}


@end
