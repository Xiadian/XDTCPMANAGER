//
//  ViewController.m
//  XDTCPManager
//
//  Created by XiaDian on 2017/3/29.
//  Copyright © 2017年 XD. All rights reserved.
//

#import "ViewController.h"
#import "XDTCPManager.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)bt:(id)sender {
    [[XDTCPManager sharedInstance] stopServers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[XDTCPManager sharedInstance] connectToServers];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)btn:(id)sender {
        NSData *da=[@"123hjdsgfsdgfjdsfgjlasgdfjdsgafhgdsakfgsadljfgsjkfghjkasgdfkhjasgfkhgdsafjhkgdsahjkfgdsahjkfgashjkgfksagjfgdsjgfjhksgfagskjfg" dataUsingEncoding:NSUTF8StringEncoding];
        [XDTCPManager requestWith:da successBlock:^(id response) {
            NSData *res=response;
            NSString *dd=[[NSString alloc]initWithData:res encoding:NSUTF8StringEncoding];;
            NSLog(@"请求成功%@",dd );
        } failureBlock:^{
            NSLog(@"请求失败");
        }];
}
@end
