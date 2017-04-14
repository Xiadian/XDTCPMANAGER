//
//  XDTCPConParameter.m
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import "XDTCPConParameter.h"

@implementation XDTCPConParameter
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.host=HOST;
        self.port=PORT;
        self.timeOut=TIMEOUT;
    }
    return self;
}
@end
