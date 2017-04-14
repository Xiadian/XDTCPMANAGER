//
//  XDDecoding.h
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/31.
//  Copyright © 2017年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDSocketPacketContext.h"
@interface XDDecoding : NSObject
@property (nonatomic, assign) NSUInteger maxFrameSize;
-(NSInteger)decode:(NSData *)data output:(id<XDTCPInstrumentDelegate>)target;
@end
