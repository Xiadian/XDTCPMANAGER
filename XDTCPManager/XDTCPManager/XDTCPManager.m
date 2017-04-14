//
//  XDTCPManager.m
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import "XDTCPManager.h"
#import "XDTCPInstrument.h"
#import "XDSocketPacketContext.h"
@interface XDTCPManager()<XDTCPInstrumentDelegate>
@property(nonatomic,strong)XDTCPInstrument *Instrument;
@end
@implementation XDTCPManager
+ (instancetype)sharedInstance
{
    static XDTCPManager * tcp= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tcp = [[self alloc] init];
        tcp.dataBuffer=[[NSCache alloc]init];
        tcp.requestBuffer=[[NSCache alloc]init];
        tcp.pid=0;
        tcp.Instrument=[[XDTCPInstrument alloc]init];
        tcp.Instrument.delegate=tcp;
        tcp.Instrument.con.delegate=tcp.Instrument;
    });
    return tcp;
}
#pragma mark 连接服务器
-(void)connectToServers{
    [self.Instrument.con connectToService];
}
+(void)requestWith:(NSData *)requestData successBlock:(succesReqBlock)succesBlock failureBlock:(failureReqBlock)failureBlock{
    //判断是否是连接状态
    if ([XDTCPManager sharedInstance].Instrument.isRunning) {
        XDTCPRequest *rst=[[XDTCPRequest alloc]init];
        rst.succesReqBlock=succesBlock;
        rst.failureReqBlock=failureBlock;
        [XDTCPManager sharedInstance].pid+=1;
        rst.pid= [XDTCPManager sharedInstance].pid;
        rst.outTime=10;//设置超时时间 默认30
        [rst.timer fire];
        [[XDTCPManager sharedInstance].requestBuffer setObject:rst forKey:@(rst.pid)];
        
        //数据用自己写好的上传对象打包好
        XDSocketPacketRequest *req = [[XDSocketPacketRequest alloc] init];
        XDSocketPacketHead *head=[[XDSocketPacketHead alloc]init];
        req.packetHead=head;
        req.packetHead.pid=[XDTCPManager sharedInstance].pid;
        req.object =requestData;
        
        [[XDTCPManager sharedInstance].Instrument sendData:req];
    }
    else{
        //服务器是未连接状态
        failureBlock();
    }
}
#pragma mark instrument delegate
-(void)resiveSocketData:(id<XDDownstreamPacket>)downPacket{
    XDSocketPacketResponse *rsp =(XDSocketPacketResponse *)downPacket;
    //存入数据缓存区 加锁
    @synchronized (self) {
        [[XDTCPManager sharedInstance].dataBuffer setObject:rsp.object forKey:@(rsp.packetHead.pid)];
        //对象缓存中存在pid的请求,通过pid判断是哪个请求返回的数据
        if([[XDTCPManager sharedInstance].requestBuffer objectForKey:@(rsp.packetHead.pid)]){
            XDTCPRequest *request=[[XDTCPManager sharedInstance].requestBuffer objectForKey:@(rsp.packetHead.pid)];
            //返回数据只包含数据部分 不包含请求头
            request.succesReqBlock(rsp.object);
            //清除相应缓存
            [request.timer invalidate];
            request.timer=nil;
            [[XDTCPManager sharedInstance].requestBuffer removeObjectForKey:@(rsp.packetHead.pid)];
            [[XDTCPManager sharedInstance].dataBuffer removeObjectForKey:@(rsp.packetHead.pid)];
        }
    }
}
/**
 停止连接
 */
-(void)stopServers{
    [self .Instrument stopService];
}
/**
 缓存被移除代理方法
 
 @param cache 那个nscache类
 @param obj 移除的数据
 */
-(void)cache:(NSCache *)cache willEvictObject:(id)obj{
    
}
@end
