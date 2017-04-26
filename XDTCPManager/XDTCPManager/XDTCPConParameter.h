//
//  XDTCPConParameter.h
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HOST @"192.168.4.175"
#define PORT 6666
#define TIMEOUT -1
@interface XDTCPConParameter : NSObject

/**
 地址
 */
@property(nonatomic,strong)NSString *host;

/**
 端口号
 */
@property(nonatomic,assign)NSInteger port;

/**
 链接时间默认-1
 */
@property(nonatomic,assign)NSInteger timeOut;
@end
