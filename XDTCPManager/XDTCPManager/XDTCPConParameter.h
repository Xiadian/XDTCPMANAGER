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
#define TIMEOUT 30
@interface XDTCPConParameter : NSObject
@property(nonatomic,strong)NSString *host;
@property(nonatomic,assign)NSInteger port;
@property(nonatomic,assign)NSInteger timeOut;
@end
